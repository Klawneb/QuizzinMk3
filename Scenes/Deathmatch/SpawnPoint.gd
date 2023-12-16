extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var area_3d: Area3D = $Area3D

const SPAWN_EMPTY = preload("res://Scenes/Deathmatch/spawn_empty.tres")
const SPAWN_NOT_EMPTY = preload("res://Scenes/Deathmatch/spawn_not_empty.tres")

var empty: bool = true

func _process(delta: float) -> void:
	empty = !area_3d.has_overlapping_bodies()
	if empty:
		mesh_instance_3d.set_surface_override_material(0, SPAWN_EMPTY)
	else:
		mesh_instance_3d.set_surface_override_material(0, SPAWN_NOT_EMPTY)
