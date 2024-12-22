extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.show()
	$ColorRect2.show()
	Global.has_torch = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.time > 120:
		$daynightchange.play("day")


func _on_timer_timeout() -> void:
	Global.time += 1


func _on_daynightchange_animation_finished(anim_name: StringName) -> void:
	if anim_name == "day":
		get_tree().change_scene_to_file("res://scenes/outro.tscn")
