class_name DashState extends State

@export var dash_speed: float = 15.0
@export var dash_duration: float = 0.2
var _timer: float = 0.0
var _dash_direction: Vector3 = Vector3.ZERO

func _on_enter(msg: Dictionary = {}) -> void:
    _timer = msg.get("duration", dash_duration)

    var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var input_vec := Vector3(input_dir.x, 0.0, input_dir.y).normalized()

    if msg.has("direction"):
        _dash_direction = (msg["direction"] as Vector3).normalized()
    elif input_vec != Vector3.ZERO:
        _dash_direction = input_vec
    else:
        _dash_direction = -player.global_transform.basis.z

func physics_update(delta: float) -> void:
    _timer -= delta

    player.velocity.x = _dash_direction.x * dash_speed
    player.velocity.z = _dash_direction.z * dash_speed

    if not player.is_on_floor():
        player.velocity += player.get_gravity() * delta
    else:
        player.velocity.y = 0.0

    player.move_and_slide()

    if _timer <= 0.0:
        var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
        if input_dir != Vector2.ZERO:
            state_machine.transition_to("walk")
        else:
            state_machine.transition_to("idle")