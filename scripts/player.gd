extends CharacterBody2D

var speed = 12000  # speed in pixels/sec
@export var dashlength = 20000
@onready var Camera = $Camera2D
@onready var anim_player = $AnimationPlayer
@onready var stickbag = $Player/Sticks
@onready var stick = preload("res://scenes/stick.tscn")
@onready var icebug = preload("res://scenes/icebug.tscn")
@onready var icebug_cooldown = $icebug_cooldown
var in_cutscene :bool
var dying = false
var dashing = false
var in_warmth = true
var dead_anim_playing = false

func _ready() -> void:
	Global.player_ref = self
	$CanvasLayer/ice.show()
	$CanvasLayer/vignette.show()

func _physics_process(delta):
	if Global.has_torch == false:
		$Player/torch.hide()
	# movement
	Global.player_position = position
	
	if dashing and not in_cutscene and not dying:
		velocity = velocity.normalized() * dashlength * delta
	elif not in_cutscene:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * speed * delta
	
		# animations
		if direction != Vector2(0,0) and not dashing:
			anim_player.play("walk")
			$walking.stream_paused = false
		else:
			if not dashing:
				anim_player.stop()
				$walking.stream_paused = true
	
		if Input.is_action_pressed("ui_right"):
			$Player.scale.x = -4
		elif Input.is_action_pressed("ui_left"):
			$Player.scale.x = 4
	
	
	# dash
	if Input.is_action_just_pressed("dash") and not dashing and not in_cutscene and not dying:
		dashing = true
		anim_player.play("dive")
	move_and_slide()
	
	
	# camera
	Camera.offset = get_local_mouse_position()/10
	
	# stick
	if Input.is_action_just_pressed("throw") and Global.sticks > 0:
		throw_stick()
	stick_bag_sprite()
	
	# icebug
	if Input.is_action_just_pressed("f"):
		spawn_icebug()
	
	if Global.time == 50.0:
		icebug_cooldown.start()
	freeze_control()
	
	# warmth
	if in_warmth and Global.fire_dead == false:
		Global.freeze_value -= 20 * delta
	else:
		Global.freeze_value += 7.5 * delta
	

# sticks
func stick_bag_sprite():
	var sticks = Global.sticks
	if sticks == 0:
		stickbag.frame = 4
	if sticks == 1:
		stickbag.frame = 5
	if sticks == 2:
		stickbag.frame = 6
	if sticks == 3:
		stickbag.frame = 7
	if sticks == 4:
		stickbag.frame = 8
	if sticks == 5:
		stickbag.frame = 9
	if sticks == 6:
		stickbag.frame = 10
	if sticks == 7:
		stickbag.frame = 11
	if sticks == 8:
		stickbag.frame = 12
func throw_stick():
	Global.sticks -= 1
	var stick_instance = stick.instantiate()
	
	stick_instance.velocity = get_local_mouse_position().normalized()
	stick_instance.position = position
	stick_instance.throwable = true
	get_parent().add_child(stick_instance)

# dive
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dive":
		dashing = false
		velocity = Vector2.ZERO


# spawns an icebug
func spawn_icebug():
	var icebug_instance = icebug.instantiate()
	
	# random position
	var side = randi_range(1,4)
	if side == 1:
		icebug_instance.position.y = position.y+randi_range(-500,500)
		icebug_instance.position.x = position.x-800
	if side == 2:
		icebug_instance.position.y = position.y+randi_range(-500,500)
		icebug_instance.position.x = position.x+800
	if side == 3:
		icebug_instance.position.y = position.y-500
		icebug_instance.position.x = position.x+randi_range(-800,800)
	if side == 4:
		icebug_instance.position.y = position.y+500
		icebug_instance.position.x = position.y+randi_range(-800,800)
		
	get_parent().add_child(icebug_instance)


# makes sure so that the freeze_value correlates to the players state
func freeze_control():
	if Global.freeze_value < 0:
		Global.freeze_value = 0
	if Global.freeze_value > 100:
		dying = true
		if speed > -1:
			speed -= 100
		if speed < 1:
			Global.dead = true
			if dead_anim_playing == false:
				$"dead animation".play("dead")
				print("jabbada")
				dead_anim_playing = true
	$Player.modulate.r = 1 -Global.freeze_value / 10.0
	$Player.modulate.v = 1 -Global.freeze_value / 100.0
	$CanvasLayer/vignette.material.set_shader_parameter("vignette_intensity",Global.freeze_value /50)
	$CanvasLayer/ice.material.set_shader_parameter("coverage", Global.freeze_value /80)

# activates when touching an icebug
func _on_icebug_recogniser_body_entered(body: Node2D) -> void:
	Global.freeze_value += 75

func _on_icebug_cooldown_timeout() -> void:
	spawn_icebug()

func _on_warmth_source_recognizer_area_entered(area: Area2D) -> void:
	in_warmth = true
func _on_warmth_source_recognizer_area_exited(area: Area2D) -> void:
	in_warmth = false

func restart():
	Global.freeze_value = 0
	Global.dead = false
	Global.fireplace_level = 4
	Global.has_torch = false
	Global.time = 0
	get_tree().change_scene_to_file("res://main.tscn")

func _on_retry_button_pressed() -> void:
	restart()


func _on_dead_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dead":
		await get_tree().create_timer(2).timeout
		restart()
