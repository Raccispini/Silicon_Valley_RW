## [spacci] State Machine del PAUSE MENU 

extends Node
class_name SM_PAUSE_MENU

@export_group("Hud Nodes")
@export var PAUSE_MAIN_NODE : Control
@export var SETTINGS : Control
@export var CONTROLS : Control

enum States {
	PAUSE,SETTINGS,CONTROLS
}

## LEGGIBILITÀ: Alias per gli States, in modo da non dover chiamare ogni volta States.Papera
const S_PAUSE: States = States.PAUSE
const S_SETTINGS: States = States.SETTINGS
const S_CONTROLS: States = States.CONTROLS



const STATE_NAMES: Dictionary[States, String] = {
	States.PAUSE: "Pause",
	States.SETTINGS: "Settings",
	States.CONTROLS: "Controls"
}

@onready var STATES: Dictionary[States, State] = {
	States.PAUSE:$Main,
	States.SETTINGS:$Settings,
	States.CONTROLS: $Controls
}


@onready var OWNER: Control = $".."

func after_setup() -> void:
	current_state = STATES[S_PAUSE]
	current_state.state_started.emit()

const _PRINT_PREFIX = "PAUSE_"

#region UnderTheHood

## [bvuno] Questa parte di codice dovrebbe essere la stessa per tutte le state machine. se devi aggiungere qualcosa al _ready usa after_setup.

signal state_changed(old_state: States, new_state: States)

var current_state: State

func _ready() -> void:
	for state_name: States in STATES:
		var state_node: State = STATES[state_name]
		state_node.OWNER = OWNER
		state_node.SM = self
		state_node.sm_name = state_name
		state_node.readable_name = STATE_NAMES[state_name]
		
	after_setup()

func switch(sm_state: States) -> void:
	if sm_state == current_state.sm_name:
		push_warning("[", _PRINT_PREFIX, "SM] tried to change the current state ", current_state.readable_name, " to itself.")
		return
		
	var new_state_node = STATES[sm_state]
	current_state.state_ended.emit()
	state_changed.emit(current_state.sm_name, sm_state)
	#print("[", _PRINT_PREFIX, "SM] ", current_state.readable_name, ' -> ', new_state_node.readable_name)
	current_state = new_state_node
	new_state_node.state_started.emit()

	

#endregion
