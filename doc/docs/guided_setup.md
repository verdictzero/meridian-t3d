# Guided Terrain Setup

`setup_tool.gd` provides a non-interactive method of importing a heightmap and generating a scene that uses Terrain3D.

## Usage

```
$ godot --headless --path project --script addons/terrain_3d/tools/setup_tool.gd -- <heightmap_image> <data_directory> <scene_path>
```

- `heightmap_image` – path to an image file compatible with Terrain3D (e.g. `.exr`, `.png`, `.r16`).
- `data_directory` – directory where the processed terrain data will be stored.
- `scene_path` – location of the resulting `.tscn` scene.

The tool loads the heightmap, creates terrain data, saves it to `data_directory` and packs a simple scene containing a `Terrain3D` node.
