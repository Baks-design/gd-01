class_name WalkState extends State

@export var speed: float = 5.0
@export var acceleration: float = 10.0
@export var rotation_speed: float = 10.0
var _target_rotation: float = 0.0

func _on_enter(_msg: Dictionary = {}) -> void:
    _target_rotation = player.rotation.y

func handle_input(event: InputEvent) -> void:
    if event.is_action_pressed("dash"):
        state_machine.transition_to("dash")

func physics_update(delta: float) -> void:
    var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction := Vector3(input_dir.x, 0.0, input_dir.y).normalized()

    if direction.length() > 0.0:
        player.velocity.x = move_toward(player.velocity.x, direction.x * speed, acceleration * delta)
        player.velocity.z = move_toward(player.velocity.z, direction.z * speed, acceleration * delta)

        _target_rotation = atan2(direction.x, direction.z)
        player.rotation.y = rotate_toward(player.rotation.y, _target_rotation, rotation_speed * delta)
    else:
        state_machine.transition_to("idle")
        return

    if not player.is_on_floor():
        player.velocity += player.get_gravity() * delta
    else:
        player.velocity.y = 0.0

    player.move_and_slide()
