//! plane4D { normal: Vec4 }

fn plane4D_proj(normal, vector) {
    vector - normal * vector.dot(normal)
}

fn plane4D_sdf(normal, vector) {
    vector.dot(normal)
}

fn plane4D_aabb(size) {
    [-INFINITY, INFINITY]
}

//! box4D { size: Vec4 }

fn box4D_proj(size, vector) {
    let q = vector.abs() - size;

    let add_to_proj = select(
        select(
            select(vec4(0, 0, 0, -q.w), vec4(0, 0, -q.z, 0),
                q.z > q.w
            ), vec4(0, -q.y, 0, 0),
            q.y > q.z && q.y > q.z
        ), vec4(-q.x, 0, 0, 0),
        q.x > q.y && q.x > q.z && q.x > q.w
    );

    select(
        {
            let proj = vector.abs();
            proj += add_to_proj;

            proj * vector.signum()
        },
        vector.abs().min(size) * vector.signum(),
        q.max(vec4(0, 0, 0, 0)).length() > 0.0000001
    )
}

fn box4D_sdf(size, vector) {
    let q = vector.abs() - size;
    let max_q = max(
        max(q.x, q.y),
        max(q.z, q.w)
    );

    q.max(ZERO).length() + max_q.min(0.0)
}

fn box4D_aabb(size) {
    [-size, size]
}

//! sphere4D { radius: f32 }

fn sphere4D_proj(radius, vector) {
    radius * (vector + vec4(0.000001, 0.0, 0.0, 0.0)).normalize()
}

fn sphere4D_sdf(radius, vector) {
    vector.length() - radius
}

fn sphere4D_aabb(radius) {
    [-vec4(radius, radius, radius, radius), vec4(radius, radius, radius, radius)]
}

//! ditorus { r01: f32, r012: f32, r0123: f32 }

fn ditorus_proj(r01, r012, r0123, vector) {
    let proj1 = r01 * vec4(vector.x, vector.y, 0.0, 0.0).normalize();
    let proj2 = r012 * (vec4(vector.x, vector.y, vector.z, 0.0) - proj1).normalize();
    let proj3 = r0123 * (vector - proj2 - proj1).normalize();

    proj3 + proj2 + proj1
}

fn ditorus_sdf(r01, r012, r0123, vector) {
    let proj1 = r01 * vec4(vector.x, vector.y, 0.0, 0.0).normalize();
    let proj2 = r012 * (vec4(vector.x, vector.y, vector.z, 0.0) - proj1).normalize();

    (vector - proj1 - proj2).length() - r0123
}

fn ditorus_aabb(r01, r012, r0123) {
    [vec4(-r01 - r012 - r0123), vec4(r01 + r012 + r0123)]
}

//! torisphere { r012: f32, r0123: f32 }

fn torisphere_proj(r012, r0123, vector) {
    let proj1 = r012 * vec4(vector.x, vector.y, vector.z, 0.0).normalize();

    proj1 + r0123 * (vector - proj1).normalize()
}

fn torisphere_sdf(r012, r0123, vector) {
    let proj1 = r012 * vec4(vector.x, vector.y, vector.z, 0.0).normalize();

    (vector - proj1).length() - r0123
}

fn torisphere_aabb(r012, r0123) {
    [vec4(-r012 - r0123), vec4(r012 + r0123)]
}

//! spheritorus { r01: f32, r0123: f32 }

fn spheritorus_proj(r01, r0123, vector) {
    let proj1 = r01 * vec4(vector.x, vector.y, 0.0, 0.0).normalize();

    proj1 + r0123 * (vector - proj1).normalize()
}

fn spheritorus_sdf(r01, r0123, vector) {
    let proj1 = r01 * vec4(vector.x, vector.y, 0.0, 0.0).normalize();

    (vector - proj1).length() - r0123
}

fn spheritorus_aabb(r01, r0123) {
    [vec4(-r01 - r0123), vec4(r01 + r0123)]
}

//! nothing { }
fn nothing_proj(vector) {
    vec4(1000000, 10000000, 1000000, 1000000)
}

fn nothing_sdf(vector) {
    1000000000.0
}

fn nothing_aabb() {
    [INFINITY, -INFINITY]
}