extends TextureButton


var repos_stat = false
var repos_stat_lets = false
var scale_vector = Vector2(1,1)
var true_scale = Vector2(1,1)
var move_go = Vector2(128,128)
var sign_scale = 0
onready var size = rect_size

func scale_but(scale_vector_arg: Vector2):
	rect_scale = rect_scale + \
		sign_scale*Vector2(0.02,0.02) \
		if ((rect_scale < scale_vector_arg) if sign_scale == 1 else (rect_scale > scale_vector_arg)) \
		else scale_vector_arg

func moving():
	if repos_stat:
		rect_global_position = get_global_mouse_position() - rect_pivot_offset
	elif repos_stat_lets and not repos_stat:
		var min_delta = pow(abs(rect_global_position.x + rect_size.x/2 - $"../..".poses[0][0]), 2) + \
			pow(abs(rect_position.y + rect_size.y/2 - $"../..".poses[0][1]), 2)
		move_go = $"../..".poses[0]
		for i in $"../..".poses.slice(1, len($"../..".poses)):
			var min_delta2 = pow(abs(rect_global_position.x + rect_size.x/2 - i[0]), 2) + \
				pow(abs(rect_position.y + rect_size.y/2 - i[1]), 2)
			if min_delta > min_delta2:
				min_delta = min_delta2
				move_go = i
		rect_global_position = move_go - size/2
		repos_stat_lets = false
		$"../..".update_poses()

func _ready():
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_on_button_up")

func _process(delta: float) -> void:
	moving()
	scale_but(scale_vector)

func _on_button_down() -> void:
	repos_stat = true
	repos_stat_lets = true
	sign_scale = -1
	rect_pivot_offset = get_local_mouse_position()
	scale_vector = Vector2(0.8,0.8)
	$"../..".update_poses()

func _on_button_up() -> void:
	repos_stat = false
	sign_scale = 1
	scale_vector = Vector2(1,1)
