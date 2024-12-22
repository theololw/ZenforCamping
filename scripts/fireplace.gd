extends Node2D

@onready var anim_player = $AnimationPlayer
@onready var lights = $lights

func _process(delta: float) -> void:
	var fire_level = Global.fireplace_level
	
	if Global.embing == true:
		Global.embing = false
		$embers.speed_scale = 2
		$embers.scale_amount_max = 3
		$embers.scale_amount_min = 3
		$crackling.volume_db = 30
		$crackling.pitch_scale = 1.1
		await get_tree().create_timer(1).timeout
		$crackling.pitch_scale = 1.0
		$crackling.volume_db = 20
		$embers.speed_scale = 1
		$embers.scale_amount_max = 1.5
		$embers.scale_amount_min = 1.5
	if fire_level > 3:
		anim_player.play("idle_full")
		lights.scale = Vector2(1,1)
	if fire_level == 3:
		anim_player.play("idle_3")
		lights.scale = Vector2(0.75,0.75)
	if fire_level == 2:
		anim_player.play("idle_2")
		lights.scale = Vector2(0.5,0.5)
	if fire_level == 1:
		anim_player.play("idle_1")
		lights.scale = Vector2(0.25,0.25)
	if fire_level == 0:
		lights.hide()
		anim_player.play("dead")
		Global.fire_dead = true


func _on_timer_timeout() -> void:
	Global.fireplace_level -= 1
