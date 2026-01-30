extends PanelContainer

# Ссылки на узлы (заполните правильные пути, основываясь на вашей структуре)
onready var title_label = $MarginContainer/VBoxContainer/HBoxContainer2/Label
onready var desc_label = $MarginContainer/VBoxContainer/ScrollContainer/RichTextLabel

# 1. Установка заголовка (уровня)
func set_title(level_text: String):
	if title_label:
		title_label.text = level_text

# 2. Установка описания задания
func set_description(description: String):
	if desc_label:
		desc_label.bbcode_text = description

func make_text_yellow():
	if desc_label:
		# Используем BBCode для изменения цвета
		desc_label.bbcode_text = "[color=#ffd500]" + desc_label.text + "[/color]"

func make_text_green():
	if desc_label:
		# Используем BBCode для изменения цвета
		desc_label.bbcode_text = "[color=#00ff00]" + desc_label.text + "[/color]"
