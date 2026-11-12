class_name IdleState extends State

@export var acceleration: float = 10.0

func _on_enter(_msg: Dictionary = {}) -> void:
	player.velocity.x = 0.0
	player.velocity.z = 0.0

func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	if input_dir != Vector2.ZERO:
		state_machine.transition_to("walk")
		return

	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	else:
		player.velocity.y = 0.0

	player.move_and_slide()
