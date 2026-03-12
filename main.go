package main

import (
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	const targetDir = "/Users/jasm/"

	slog.SetDefault(slog.New(
		slog.NewTextHandler(os.Stderr, &slog.HandlerOptions{
			AddSource:   false,
			Level:       slog.LevelInfo,
			ReplaceAttr: nil,
		}),
	))

	dirs, err := findDirectories()
	if err != nil {
		slog.Error("cannot list directories", slog.String("err", err.Error()))

		return
	}

	linkFiles(dirs, targetDir)
}

func linkFiles(dirs []string, targetDir string) {
	const dirPermission = 0o755

	for _, dir := range dirs {
		errWalk := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if info.IsDir() {
				return nil
			}

			rel := strings.TrimPrefix(path, dir+string(os.PathSeparator))

			linkPath := filepath.Join(targetDir, rel)

			errMkDir := os.MkdirAll(filepath.Dir(linkPath), dirPermission)
			if errMkDir != nil {
				return fmt.Errorf("error when trying to create dir: %w", errMkDir)
			}

			absPath, err := filepath.Abs(path)
			if err != nil {
				return fmt.Errorf("error when trying to get abs path: %w", err)
			}

			slog.Debug(
				"creating symlink",
				slog.String("link", linkPath),
				slog.String("target", absPath),
			)

			errSymlink := os.Symlink(absPath, linkPath)
			if errSymlink != nil {
				existing, errRead := os.Readlink(linkPath)
				if errRead != nil {
					return fmt.Errorf(
						"failed to create symlink and path is not a symlink: %w",
						errSymlink,
					)
				}

				if existing == absPath {
					slog.Debug(
						"symlink already exists and points to correct target, skipping",
						slog.String("link", linkPath),
					)

					return nil
				}

				slog.Debug(
					"symlink points to wrong target, re-linking",
					slog.String("link", linkPath),
					slog.String("old_target", existing),
					slog.String("new_target", absPath),
				)

				errRemove := os.Remove(linkPath)
				if errRemove != nil {
					return fmt.Errorf("failed to remove stale symlink: %w", errRemove)
				}

				return os.Symlink(absPath, linkPath)
			}

			return nil
		})
		if errWalk != nil {
			slog.Error(
				"error walking directory",
				slog.String("dir", dir),
				slog.Any("error", errWalk),
			)
		}
	}
}

func findDirectories() ([]string, error) {
	var output []string

	entries, err := os.ReadDir(".")
	if err != nil {
		return nil, fmt.Errorf("unable to list directories: %w", err)
	}

	for _, entry := range entries {
		if entry.IsDir() {
			if strings.HasPrefix(entry.Name(), ".") {
				slog.Debug(
					"skiping dir",
					slog.String("name", entry.Name()),
					slog.String("reason", "hidden"),
				)

				continue
			}

			output = append(output, entry.Name())
		}
	}

	return output, nil
}
