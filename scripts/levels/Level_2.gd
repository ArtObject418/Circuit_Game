extends Control

var poses
func _ready():
	$BackButton.connect('pressed', self, '_on_BackButton_pressed')
	$PanelContainer.set_title("Уровень 2")
	$PanelContainer.set_description("• Соедините проводами все элементы цепи\n\n• Расставьте блоки на свои места")
	$PanelContainer.make_text_yellow()
	$Complite.visible = false
	update_poses()
	

func update_poses():
	yield(get_tree().create_timer(0.2), "timeout")
	poses = []
	for pos in $POSITIONS.get_children():
		var occupied = false
		for block in $BLOCKS.get_children():
			if block.repos_stat:  # Пропускаем перемещаемые блоки
				continue
			
			# Проверяем, занимает ли блок эту позицию (с допуском)
			var block_center = block.rect_global_position + block.rect_size/2
			if block_center.distance_to(pos.global_position) < 20:  # Допуск 20px
				block.rect_global_position = pos.global_position - block.rect_size/2
				occupied = true
				break
		
		if not occupied:
			poses.append(pos.global_position)
	
#	print("Свободные позиции: ", str(poses))
	check_completed()

func global_pivot(button: TextureButton):
	return button.rect_global_position + button.rect_size/2

func check_completed():
	var f1 = global_pivot($BLOCKS/TextureButton) == $POSITIONS/Position2D4.global_position
	var f2 = global_pivot($BLOCKS/TextureButton2) == $POSITIONS/Position2D5.global_position
	var f3 = global_pivot($BLOCKS/TextureButton3) == $POSITIONS/Position2D.global_position
	var f4 = global_pivot($BLOCKS/TextureButton4) == $POSITIONS/Position2D2.global_position
	var f5 = global_pivot($BLOCKS/TextureButton5) == $POSITIONS/Position2D3.global_position
	var f6 = global_pivot($BLOCKS/TextureButton2) == $POSITIONS/Position2D3.global_position
	var f7 = global_pivot($BLOCKS/TextureButton) == $POSITIONS/Position2D11.global_position
	var f8 = global_pivot($BLOCKS/TextureButton5) == $POSITIONS/Position2D4.global_position
	if f1 and f2 and f3 and f4 and f5 or f7 and f6 and f8 and f3 and f4:
		SaveManager.save_progress(3)
		$Complite.visible = true
		$PanelContainer.make_text_green()


func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes/levels/LevelSelect_1_12.tscn") # Replace with function body.
