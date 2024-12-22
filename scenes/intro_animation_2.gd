extends Node2D

func _ready() -> void:
	$ColorRect.show()
	$ColorRect2.show()
	$CanvasModulate.show()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://main.tscn")
