@tool
extends Node

# Command line tool to import a heightmap and generate a scene using Terrain3D.
# Usage:
#   godot --headless --path project --script addons/terrain_3d/tools/setup_tool.gd -- <heightmap> <data_dir> <scene.tscn>

func _ready() -> void:
    var args := OS.get_cmdline_user_args()
    if args.size() < 3:
        print("Usage: godot --headless --path project --script addons/terrain_3d/tools/setup_tool.gd -- <heightmap> <data_dir> <scene.tscn>")
        get_tree().quit()
        return
    var heightmap_path := args[0]
    var data_dir := args[1]
    var scene_path := args[2]

    var height_img: Image = Terrain3DUtil.load_image(heightmap_path, ResourceLoader.CACHE_MODE_IGNORE)
    if height_img == null:
        push_error("Failed to load heightmap: %s" % heightmap_path)
        get_tree().quit()
        return

    var terrain := Terrain3D.new()
    add_child(terrain)
    terrain.material = Terrain3DMaterial.new()
    terrain.assets = Terrain3DAssets.new()

    var images := []
    images.resize(Terrain3DRegion.TYPE_MAX)
    images[Terrain3DRegion.TYPE_HEIGHT] = height_img
    terrain.get_data().import_images(images, Vector3.ZERO)

    DirAccess.make_dir_recursive_absolute(data_dir)
    terrain.get_data().save_directory(data_dir)
    terrain.data_directory = data_dir

    var root := Node3D.new()
    root.add_child(terrain)
    var scene := PackedScene.new()
    scene.pack(root)
    var err := ResourceSaver.save(scene_path, scene)
    if err != OK:
        push_error("Failed to save scene: %s" % scene_path)
    else:
        print("Scene saved to %s" % scene_path)
    get_tree().quit()
