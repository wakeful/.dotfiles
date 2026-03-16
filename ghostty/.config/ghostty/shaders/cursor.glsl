vec4  TRAIL_COLOR          = iCurrentCursorColor;
const float DURATION       = 0.09;
const float MAX_TRAIL_LEN  = 0.2;
const float MIN_DIST_MULT  = 1.5;
const float BLUR           = 2.0;

float ease(float x) {
    return sqrt(1.0 - pow(x - 1.0, 2.0));
}

float sdfRect(vec2 p, vec2 center, vec2 halfSize) {
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float edgeSDF(vec2 p, vec2 a, vec2 b, inout float s, float d) {
    vec2 e = b - a, w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    d = min(d, dot(p - proj, p - proj));

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float sc  = c0 * c1 * c2;
    s *= mix(1.0, -1.0, step(0.5, sc + (1.0 - c0) * (1.0 - c1) * (1.0 - c2)));
    return d;
}

float sdfQuad(vec2 p, vec2 v0, vec2 v1, vec2 v2, vec2 v3) {
    float s = 1.0, d = dot(p - v0, p - v0);
    d = edgeSDF(p, v0, v3, s, d);
    d = edgeSDF(p, v1, v0, s, d);
    d = edgeSDF(p, v2, v1, s, d);
    d = edgeSDF(p, v3, v2, s, d);
    return s * sqrt(d);
}

vec2 toNorm(vec2 v, float isPosition) {
    return (v * 2.0 - iResolution.xy * isPosition) / iResolution.y;
}

float alpha(float dist) {
    return 1.0 - smoothstep(0.0, toNorm(vec2(BLUR), 0.0).x, dist);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 uv = toNorm(fragCoord, 1.0);
    vec2 offset = vec2(-0.5, 0.5);

    vec4 cur  = vec4(toNorm(iCurrentCursor.xy, 1.0), toNorm(iCurrentCursor.zw, 0.0));
    vec4 prev = vec4(toNorm(iPreviousCursor.xy, 1.0), toNorm(iPreviousCursor.zw, 0.0));

    vec2 centerCur  = cur.xy  - cur.zw  * offset;
    vec2 centerPrev = prev.xy - prev.zw * offset;

    float dist     = length(centerPrev - centerCur);
    float minDist  = cur.w * MIN_DIST_MULT;
    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);

    vec4 color = fragColor;

    if (dist > minDist) {
        float isLong        = step(MAX_TRAIL_LEN, dist);
        float delayFactor   = MAX_TRAIL_LEN / dist;
        float headT         = mix(1.0, ease(progress), isLong);
        float tailT         = mix(ease(progress), ease(smoothstep(delayFactor, 1.0, progress)), isLong);

        vec2 headTL = mix(prev.xy, cur.xy, headT);
        vec2 tailTL = mix(prev.xy, cur.xy, tailT);

        vec2  delta      = abs(centerCur - centerPrev);
        float isStraight = max(step(delta.y, 0.001), step(delta.x, 0.001));

        float trRight = step(cur.x, prev.x) == step(prev.y, cur.y) ? 1.0 : 0.0;
        float trLeft  = 1.0 - trRight;
        vec2 v0 = vec2(headTL.x + cur.z * trRight, headTL.y - cur.w);
        vec2 v1 = vec2(headTL.x + cur.z * trLeft, headTL.y);
        vec2 v2 = vec2(tailTL.x + cur.z * trLeft, tailTL.y);
        vec2 v3 = vec2(tailTL.x + cur.z * trRight, tailTL.y - prev.w);

        vec2 headC   = mix(centerPrev, centerCur, headT);
        vec2 tailC   = mix(centerPrev, centerCur, tailT);
        vec2 boxSize = (max(headC, tailC) - min(headC, tailC)) + cur.zw;
        vec2 boxCtr  = (headC + tailC) * 0.5;

        float sdf = mix(sdfQuad(uv, v0, v1, v2, v3),
                        sdfRect(uv, boxCtr, boxSize * 0.5),
                        isStraight);

        color = mix(color, TRAIL_COLOR, alpha(sdf));
        color = mix(color, fragColor, step(sdfRect(uv, centerCur, cur.zw * 0.5), 0.0));
    }

    fragColor = color;
}
