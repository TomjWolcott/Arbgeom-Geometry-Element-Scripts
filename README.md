Here are the functions I currently have defined for geometries in Arbgeom current written in Rhai, these are used for both shapes in the scene and the manifold itself. Some important things to note:

- Some of the functions might be not be the most efficient right now
- This has to be interpreted by rust and transpiled to wgsl on the gpu. This is why I avoid if/else statements and often opt for select(false_value, true_value, boolean) instead

The ron files, which define the worlds and demonstrate connecting together the geometry elements, are also uploaded here under worlds.  Inside that you may see `Dynamic( id: "abc", value: ____)`, these are used to dynamically control certain values, the field is initially set to whatever "value" is set to.  In the future these will be controlled by rhai scripts, but I haven't set that up yet.
