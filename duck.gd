extends Node3D
@export var target : NodePath
@export var look_at_head : LookAtModifier3D
@export var look_at_chest : LookAtModifier3D
@export var look_at_anca : LookAtModifier3D
@export_group("Movement")
@export var max_height : float = 100

@export var papera : Node3D
func _ready() -> void:
	look_at_head.target_node = %Character.get_path()
	look_at_chest.target_node = %Character.get_path()
	look_at_anca.target_node = %Character.get_path()
	#ik.interpolation = .7
	#ik.start()

func _process(delta: float) -> void:
	pass
	#check_distance()

func get_player():
	var player:Character = %Character
	return player.get_path()

func can_see_player()->bool:
	
	return true

func check_distance():
	var player_position = %Character.global_position
	var global_position_ = global_position
	player_position.y = 0
	global_position_.y = 0
	var distance = global_position_.distance_to(player_position)
	print(distance)
	papera.position.y = (distance -158)/100
