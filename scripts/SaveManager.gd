extends Node

const SAVE_PATH = "user://save_data.json"

var save_data = {
		"unlocked_levels": 0,
		"last_played": OS.get_datetime()
	}

func save_progress(unlocked_levels: int):
	if unlocked_levels > save_data["unlocked_levels"]:
		save_data = {
			"unlocked_levels": unlocked_levels,
			"last_played": OS.get_datetime()
		}
		
		var file = File.new()
		var error = file.open(SAVE_PATH, File.WRITE)
		if error == OK:
			file.store_string(to_json(save_data))
			file.close()
			print("Progress saved: levels unlocked - ", unlocked_levels)
		else:
			push_error("Failed to save progress")

func get_unlocked_levels() -> int:
	var file = File.new()
	if not file.file_exists(SAVE_PATH):
		# Первый запуск - разблокирован только 1 уровень
		save_progress(1)
		return 1
	
	var error = file.open(SAVE_PATH, File.READ)
	if error == OK:
		var content = file.get_as_text()
		file.close()
		var data = parse_json(content)
		if data and data.has("unlocked_levels"):
			return data["unlocked_levels"]
	
	return 1  # По умолчанию разблокирован 1 уровень

func reset_progress():
	save_progress(1)
