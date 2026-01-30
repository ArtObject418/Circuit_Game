# LevelSelect.gd
extends Control

# Загружаем текстуры
const INACTIVE_TEXTURES = {
	1: preload("res://textures/levels_buttons/unable/01.png"),
	2: preload("res://textures/levels_buttons/unable/02.png"),
	3: preload("res://textures/levels_buttons/unable/03.png"),
	4: preload("res://textures/levels_buttons/unable/04.png"),
	5: preload("res://textures/levels_buttons/unable/05.png"),
	6: preload("res://textures/levels_buttons/unable/06.png"),
	7: preload("res://textures/levels_buttons/unable/07.png"),
	8: preload("res://textures/levels_buttons/unable/08.png"),
	9: preload("res://textures/levels_buttons/unable/09.png"),
	10: preload("res://textures/levels_buttons/unable/10.png"),
	11: preload("res://textures/levels_buttons/unable/11.png"),
	12: preload("res://textures/levels_buttons/unable/12.png")
}

const ACTIVE_TEXTURES = {
	1: preload("res://textures/levels_buttons/able/01.png"),
	2: preload("res://textures/levels_buttons/able/02.png"),
	3: preload("res://textures/levels_buttons/able/03.png"),
	4: preload("res://textures/levels_buttons/able/04.png"),
	5: preload("res://textures/levels_buttons/able/05.png"),
	6: preload("res://textures/levels_buttons/able/06.png"),
	7: preload("res://textures/levels_buttons/able/07.png"),
	8: preload("res://textures/levels_buttons/able/08.png"),
	9: preload("res://textures/levels_buttons/able/09.png"),
	10: preload("res://textures/levels_buttons/able/10.png"),
	11: preload("res://textures/levels_buttons/able/11.png"),
	12: preload("res://textures/levels_buttons/able/12.png")
}

# Пути к сценам уровней
const LEVEL_SCENES = {
	1: "res://Scenes/levels/Level_1.tscn",
	2: "res://Scenes/levels/Level_2.tscn",
	3: "res://Scenes/levels/Level_3.tscn",
	4: "res://Scenes/levels/Level_4.tscn",
	5: "res://Scenes/levels/Level_5.tscn",
	6: "res://Scenes/levels/Level_6.tscn",
	7: "res://Scenes/levels/Level_7.tscn",
	8: "res://Scenes/levels/Level_8.tscn",
	9: "res://Scenes/levels/Level_9.tscn",
	10: "res://Scenes/levels/Level_10.tscn",
	11: "res://Scenes/levels/Level_11.tscn",
	12: "res://Scenes/levels/Level_12.tscn"
}

onready var level_buttons = {
		1: $VBoxContainer/HBoxContainer/Level_1,
		2: $VBoxContainer/HBoxContainer/Level_2,
		3: $VBoxContainer/HBoxContainer/Level_3,
		4: $VBoxContainer/HBoxContainer/Level_4,
		5: $VBoxContainer/HBoxContainer2/Level_5,
		6: $VBoxContainer/HBoxContainer2/Level_6,
		7: $VBoxContainer/HBoxContainer2/Level_7,
		8: $VBoxContainer/HBoxContainer2/Level_8,
		9: $VBoxContainer/HBoxContainer3/Level_9,
		10: $VBoxContainer/HBoxContainer3/Level_10,
		11: $VBoxContainer/HBoxContainer3/Level_11,
		12: $VBoxContainer/HBoxContainer3/Level_12
}

func _ready():
	# Инициализируем SaveManager если нужно
	init_save_manager()
	
	# Обновляем состояние кнопок
	update_level_buttons()
	print(get_unlocked_levels())
	
	# Подключаем все кнопки
	connect_all_buttons()

func init_save_manager():
	# Проверяем, есть ли SaveManager в автозагрузках
	if not has_node("/root/SaveManager"):
		# Пробуем загрузить как автозагрузку
		if ResourceLoader.exists("res://scripts/SaveManager.gd"):
			var SaveManager = preload("res://scripts/SaveManager.gd")
			var save_manager = SaveManager.new()
			get_tree().root.add_child(save_manager)
			save_manager.name = "SaveManager"
		else:
			# Создаем временный SaveManager
			print("SaveManager не найден, создаем временный")
			var temp_save_manager = Node.new()
			temp_save_manager.name = "SaveManager"
			temp_save_manager.set_script(preload("res://scripts/SaveManager.gd"))
			get_tree().root.add_child(temp_save_manager)

func update_level_buttons():
	var unlocked_levels = get_unlocked_levels()
	for level_num in range(1, 13):
		var button = level_buttons.get(level_num)
		if button:
			# Устанавливаем текстуру в зависимости от разблокировки
			if level_num <= unlocked_levels:
				button.disabled = false
			else:
				button.disabled = true

func connect_all_buttons():
	for level_num in level_buttons:
		var button = level_buttons[level_num]
		if button:
			# Отключаем предыдущие соединения
			if button.is_connected("pressed", self, "_on_level_button_pressed"):
				button.disconnect("pressed", self, "_on_level_button_pressed")
			
			# Подключаем с параметром номера уровня
			button.connect("pressed", self, "_on_level_button_pressed", [level_num])

func _on_level_button_pressed(level_num: int):
	# Проверяем, разблокирован ли уровень
	if level_num > get_unlocked_levels():
		print("Уровень ", level_num, " заблокирован!")
		return
	
	# Анимация нажатия
	var button = level_buttons.get(level_num)
	if button:
		button_click_effect(button)
		yield(get_tree().create_timer(0.15), "timeout")
	
	# Загружаем уровень
	if LEVEL_SCENES.has(level_num):
		print("Загрузка уровня ", level_num)
		get_tree().change_scene(LEVEL_SCENES[level_num])
	else:
		print("Ошибка: сцена для уровня ", level_num, " не найдена")

func button_click_effect(button: TextureButton):
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "rect_scale", Vector2(0.95, 0.95), 0.08)
	tween.tween_property(button, "rect_scale", Vector2(1, 1), 0.12)

func get_unlocked_levels() -> int:
	# Получаем количество разблокированных уровней из SaveManager
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		if save_manager.has_method("get_unlocked_levels"):
			return save_manager.get_unlocked_levels()
	
	# Если SaveManager не работает, возвращаем 1
	return 1

func _on_back_button_pressed():
	play_button_effect($BackButton)
	# Кнопка "Назад" - возврат в главное меню
	# Если у вас есть кнопка назад, подключите её к этой функции
	get_tree().change_scene("res://Main.tscn")

# Функция для принудительного обновления кнопок (например, после прохождения уровня)
func refresh_level_buttons():
	update_level_buttons()

# Функция для тестирования - разблокировать все уровни
func _unlock_all_levels():
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		if save_manager.has_method("save_progress"):
			save_manager.save_progress(12)
			update_level_buttons()
			print("Все уровни разблокированы!")

func play_button_effect(button: Button):
	# Анимация нажатия кнопки
	var tween = create_tween()
	tween.tween_property(button, "rect_scale", Vector2(0.9, 0.9), 0.1)
	tween.tween_property(button, "rect_scale", Vector2(1, 1), 0.1)

func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn") # Replace with function body.
