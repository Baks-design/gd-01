class_name FollowCamera extends Camera3D

@export var target: Node3D
@export var follow_speed: float = 8.0
@export var offset: Vector3 = Vector3(0, 15, 10)
var _smooth_position: Vector3

func _ready() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF

	if target:
		_smooth_position = target.global_position + offset
		global_position = _smooth_position
		look_at(target.global_position, Vector3.UP)

func _process(delta: float) -> void:
	if not target:
		return

	var target_pos: Vector3 = target.get_global_transform_interpolated().origin + offset

	var weight: float = 1.0 - exp(-follow_speed * delta)
	_smooth_position = _smooth_position.lerp(target_pos, weight)

	global_position = _smooth_position
	look_at(target.global_position, Vector3.UP)
