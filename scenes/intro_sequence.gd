extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.show()
	$ColorRect2.show()
	$CanvasModulate.show()
	Global.has_torch = true



func _on_next_area_body_entered(body: Node2D) -> void:
	$lowTaperFade.play("fade_out")


func _on_low_taper_fade_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://scenes/intro_animation.tscn")
