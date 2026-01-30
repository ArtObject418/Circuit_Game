extends Control

var poses
func _ready():
	$BackButton.connect('pressed', self, '_on_BackButton_pressed')
	$PanelContainer.set_title("Уровень 9")
	$PanelContainer.set_description("• Соедините проводами все элементы цепи\n\n• Расставьте блоки на свои места")
	$PanelContainer.make_text_yellow()
	$Teoretic.set_title("ТЕОРИЯ")
	$Teoretic.set_description("Заметим, что I=U/R\n\nВот мы и вывели закон Ома для участка цепи:\n• При увеличении сопротивления ток падает\n• При росте напряжения ток растёт")
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
			if block_center.distance_to(pos.global_position) < 20:  # Допуск 10px
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
	var f1 = global_pivot($BLOCKS/TextureButton) in [$POSITIONS/Position2D12.global_position, $POSITIONS/Position2D14.global_position]
	var f2 = global_pivot($BLOCKS/TextureButton2) == $POSITIONS/Position2D22.global_position
	var f3 = global_pivot($BLOCKS/TextureButton3) == $POSITIONS/Position2D21.global_position
	var f4 = global_pivot($BLOCKS/TextureButton4) in [$POSITIONS/Position2D12.global_position, $POSITIONS/Position2D14.global_position]
	var f5 = global_pivot($BLOCKS/TextureButton5) == $POSITIONS/Position2D2.global_position
	if f1 and f2 and f3 and f4 and f5:
		$Ammetr.text = '2A'
		SaveManager.save_progress(10)
		$Complite.visible = true
		$PanelContainer.make_text_green()
	else:
		$Ammetr.text = '0A'


func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes/levels/LevelSelect_1_12.tscn") # Replace with function body.

