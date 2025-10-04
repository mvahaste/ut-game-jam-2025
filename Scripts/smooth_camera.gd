class_name SmoothCamera extends Camera3D

@export var static_mode: bool = false

var _enabled: bool = false
var _target: Marker3D

func _ready() -> void:
	if static_mode:
		top_level = true
		return

	_target = get_parent()

	if _target == null or not _target is Marker3D:
		push_error("SmoothCamera must be a child of a Marker3D node, the target it is interpolating to.")
	else:
		top_level = true
		_enabled = true

func _process(_delta: float) -> void:
	if !_enabled:
		return

	global_transform.origin = lerp(global_transform.origin, _target.global_transform.origin, 0.025)
