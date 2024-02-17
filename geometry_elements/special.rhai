//! blackhole { }

fn blackhole_proj(vector) {
    vec4(vector.x, -1 / (vector.x * vector.x + vector.y * vector.y + vector.z * vector.z), vector.z, vector.w)
}