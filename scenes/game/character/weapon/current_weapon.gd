extends Node3D
class_name CurrentWeapon

@onready var ANIM_PLAYER = $AnimationPlayer
@export var CHARACTER: Character 
@export var ATTACK_DISTANCE : float = 2.0
@export var PARRY_DISTANCE: float = 100.0

@onready var SM: SM_Weapon = $StateMachine
@onready var ATTACK_COMPONENT:AttackComponent = $Attack

var enemy_entered:bool = false
var enemy_health_component:HealthComponent = null


func attack():
	var body := Utils.get_body_in_front_of_camera(CHARACTER.CAMERA,get_world_3d().direct_space_state,ATTACK_DISTANCE)
	if body!= null and body.is_in_group("enemy"):
		var enemy_health : HealthComponent = body.find_child("Health")
		enemy_health.take_damage(ATTACK_COMPONENT)


func parry():
	pass


func _on_character_ready() -> void:
	SM.after_setup()
	CHARACTER.DEFEND_ZONE.area_entered.connect(SM.STATES[SM.S_PARRY].check_parry)
