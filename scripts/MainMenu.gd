extends Control

onready var buttons_container = $CenterContainer/VBoxContainer
onready var play_button = $CenterContainer/VBoxContainer/PlayButton
onready var constructor_button = $CenterContainer/VBoxContainer/ConstructorButton
onready var exit_button = $CenterContainer/VBoxContainer/ExitButton

func _ready():
	$TextureButton.connect("pressed", self, "_on_TextureButton_pressed")
	play_button.connect("pressed", self, "_on_play_button_pressed")
	constructor_button.connect("pressed", self, "_on_constructor_button_pressed")
	exit_button.connect("pressed", self, "_on_exit_button_pressed")

func _on_play_button_pressed():
	play_button_effect(play_button)
	yield(get_tree().create_timer(0.2), "timeout")
	if not SaveManager:
		var SaveManager = preload("res://scripts/SaveManager.gd").new()
		add_child(SaveManager)
	get_tree().change_scene("res://Scenes/levels/LevelSelect_1_12.tscn")

func _on_constructor_button_pressed():
	play_button_effect(constructor_button)
	yield(get_tree().create_timer(0.2), "timeout")
	print("Конструктор уровней в разработке")

func _on_exit_button_pressed():
	play_button_effect(exit_button)
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().quit()

func play_button_effect(button: Button):
	# Анимация нажатия кнопки
	var tween = create_tween()
	tween.tween_property(button, "rect_scale", Vector2(0.9, 0.9), 0.1)
	tween.tween_property(button, "rect_scale", Vector2(1, 1), 0.1)

func _on_TextureButton_pressed():
	print(1)
	SaveManager.reset_progress()
