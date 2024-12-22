extends CharacterBody2D

var walk_speed = 8000
@export var dash_speed :int
var dashing = false
var dash_ready :bool
var player_direction :Vector2
var dead = false

func _ready() -> void:
	dash_ready = true
func _physics_process(delta: float) -> void:
	var player_distance = -(position - Global.player_position)
	var avr_player_distance = (player_distance.x + player_distance.y) / 2

	if dashing and not dead:
		
		velocity = player_direction * dash_speed * delta
	elif not dashing and not dead:
		$AnimationPlayer.play("walk")
		player_direction =  -(position - Global.player_position).normalized()
		velocity = player_direction * walk_speed * delta
		if player_direction.x < 0:
			$IceBug.flip_h = true
		else:
			$IceBug.flip_h = false
	
	
	
	if avr_player_distance < 100 and dash_ready == true:
		dashing = true
		$AnimationPlayer.play("dash")
		if $dashPowerup.playing != true:
			$dashPowerup.play()
			
		player_direction =  -(position - Global.player_position).normalized()
		$dash_cooldown.start()
		dash_ready = false

	move_and_slide()



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dash":
		dashing = false
	if anim_name == "dead":
		await get_tree().create_timer(2).timeout
		queue_free()


func _on_dash_cooldown_timeout() -> void:
	dash_ready = true


func _on_tree_recognizer_area_entered(area: Area2D) -> void:
	if dashing == true:
		area.get_parent().shake()
		die()

func stun():
	pass
func die():
	dead = true
	velocity = Vector2.ZERO
	$AnimationPlayer.play("dead")
	for i in range(5):
		$IceBug.hide()
		await get_tree().create_timer(0.075).timeout
		$IceBug.show()
		await get_tree().create_timer(0.075).timeout
	
