extends Node
class_name DamageNumbers

func display_number(value , position : Vector2):
	var number = Label.new()
	var color = Color.WHITE
	var font = load("res://assets/fonts/PixelGameFont.ttf")
	number.global_position = position
	number.text = "+ " + str(value)
	number.z_index = 5
	# Label settings
	number.label_settings = LabelSettings.new()
	number.label_settings.font_color = color
	number.label_settings.font = font
	number.label_settings.font_size = 8
	number.label_settings.outline_color = Color.BLACK
	number.label_settings.outline_size = 1
	
	call_deferred("add_child" , number)
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	# Animate
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(
		number , "position:x" , number.position.x - randf_range(-20 , 20) , 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number , "position:y" , number.position.y - 15 , 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number , "position:y" , number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number , "scale" , Vector2.ZERO , 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	number.queue_free()
	
	
	
