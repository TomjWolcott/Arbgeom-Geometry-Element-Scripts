//! shell { offset: f32, shape: Shape }

fn shell_proj(shape_proj, offset, vector) {
    let proj = shape_proj.call(vector);

    proj + offset * (vector - proj).normalize()
}

fn shell_sdf(shape_sdf, offset, vector) {
    -offset + abs(shape_sdf.call(vector))
}

//! extrude { direction: Vec4, shape: Shape }

fn extrude_proj(shape_proj, direction, vector) {
    let dot = vector.dot(direction);

    direction * dot + shape_proj.call(vector - direction * dot)
}

fn extrude_sdf(shape_sdf, direction, vector) {
    let dot = vector.dot(direction);

    shape_sdf.call(vector - direction * dot)
}

//! shift { shift: Vec4, shape: Shape }

fn shift_proj(shape_proj, shift, vector) {
    shift + shape_proj.call(vector - shift)
}

fn shift_sdf(shape_sdf, shift, vector) {
    shape_sdf.call(vector - shift)
}

//! reorient { inv_orientation: Mat4, shape: Shape }

fn reorient_proj(shape_proj, inv_orientation, vector) {
    shape_proj.call(inv_orientation * vector)
}

fn reorient_sdf(shape_sdf, inv_orientation, vector) {
    shape_sdf.call(inv_orientation * vector)
}

//! invert { shape: Shape }

fn invert_proj(shape_proj, vector) {
    shape_proj.call(vector)
}

fn invert_sdf(shape_sdf, vector) {
    -shape_sdf.call(vector)
}

fn invert_aabb() {
    [vec4(-100000000, -100000000, -100000000, -100000000), vec4(100000000, 100000000, 100000000, 100000000)]
}

//! intersection { shape1: Shape, shape2: Shape }

fn intersection_proj(shape1_proj, shape2_proj, shape1_sdf, shape2_sdf, vector) {
    let proj1 = shape1_proj.call(vector);
    let proj2 = shape2_proj.call(vector);
    let proj3 = shape2_proj.call(proj1);
    let sdf1 = shape1_sdf.call(vector);
    let sdf2 = shape2_sdf.call(vector);

    select(
        select(proj2, proj1, sdf1 > sdf2),
        proj3,
        sign(sdf1) == sign(sdf2)
    )
}

fn intersection_sdf(shape1_proj, shape2_proj, shape1_sdf, shape2_sdf, vector) {
    let proj1 = shape1_proj.call(vector);
    let proj2 = shape2_proj.call(vector);
    let proj3 = shape2_proj.call(proj1);
    let sdf1 = shape1_sdf.call(vector);
    let sdf2 = shape2_sdf.call(vector);

    select(
        select(length(proj2) * sign(sdf2), length(proj1) * sign(sdf1), sdf1 > sdf2),
        length(proj3) * sign(sdf1),
        sign(sdf1) == sign(sdf2)
    )
}

fn intersection_aabb() {
    [vec4(-100000000, -100000000, -100000000, -100000000), vec4(100000000, 100000000, 100000000, 100000000)]
}