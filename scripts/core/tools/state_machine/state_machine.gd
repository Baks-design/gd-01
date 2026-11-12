class_name StateMachine extends Node

@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			var key := child.name.to_lower().trim_suffix("state")
			states[key] = child
			child.state_machine = self
			child.player = get_parent() as CharacterBody3D 

	if initial_state:
		current_state = initial_state
		current_state.enter()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	var key := target_state_name.to_lower().trim_suffix("state")
	if not states.has(key):
		push_error("State does not exist: " + target_state_name)
		return

	if current_state and current_state.is_entering:
		await get_tree().process_frame
		if not is_inside_tree():
			return

	if current_state:
		current_state.exit()

	current_state = states[key]
	current_state.enter(msg)
