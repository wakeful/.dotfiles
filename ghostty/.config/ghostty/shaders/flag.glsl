const float IDLE_TIMEOUT  = 420.0;  // seconds of inactivity before activating
const float FADE_IN_TIME  = 1.5;   // seconds to fade the effect in
const float COLS          = 68.0;  // grid columns
const float ROWS          = 48.0;  // grid rows
const float MAX_COL_DELAY = 3.0;   // max random per-column start delay
const float MIN_SPEED     = 6.0;   // slowest column, rows/second
const float MAX_SPEED     = 14.0;  // fastest column, rows/second
const float TAIL_LEN      = 14.0;  // trail length in rows behind the head
const float TERM_DIM      = 0.08;  // how much the terminal ghosts through

const vec3 WHITE = vec3(1, 1, 1);
const vec3 RED   = vec3(0.8627, 0.0784, 0.2392); // #DC143C

float hash11(float p) {
    p = fract(p * 0.1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv   = fragCoord / iResolution.xy;
    vec4 term = texture(iChannel0, uv);

    float idle = iTime - iTimeCursorChange;
    float t = idle - IDLE_TIMEOUT;
    if (t <= 0.0) {
        fragColor = term;
        return;
    }
    float fade = smoothstep(0.0, FADE_IN_TIME, t);

    float yTop = uv.y;
    float col = floor(uv.x * COLS);
    float row = floor(yTop * ROWS);

    float delay = hash11(col + 7.31) * MAX_COL_DELAY;
    float speed = mix(MIN_SPEED, MAX_SPEED, hash11(col + 41.7));
    float ct    = max(t - delay, 0.0);

    float span = ROWS + TAIL_LEN + 2.0;
    float head = mod(ct * speed, span);

    float dist = head - row;  // rows behind the head
    float intensity = 0.0;
    if (ct > 0.0 && dist >= 0.0 && dist <= TAIL_LEN) {
        intensity = 1.0;
    }

    vec3 base  = (yTop < 0.5) ? WHITE : RED;
    vec3 color = base * intensity;

    vec3 screensaver = color + term.rgb * TERM_DIM;
    fragColor = vec4(mix(term.rgb, screensaver, fade), term.a);
}
