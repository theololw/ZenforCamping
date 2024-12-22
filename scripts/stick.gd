extends Node2D

var in_range = false
@onready var sprite = $Stick
@onready var burning_sprite = $burning_stick
@export var stick_type :int
@export var velocity = Vector2()
@export var throwable :bool
var rotate_speed = randi_range(-10,10)

# in range code
func _on_area_2d_body_entered(body: Node2D) -> void:
	in_range = true
func _on_area_2d_body_exited(body: Node2D) -> void:
	in_range = false

func _ready() -> void:
	sprite.show()
	burning_sprite.hide()
	sprite.material = sprite.material.duplicate()
	if stick_type == 0:
		sprite.frame = 0
	if stick_type == 1:
		sprite.frame = 1
	if stick_type == 2:
		sprite.frame = 2

func _process(delta: float) -> void:
	# select outline
	if in_range and throwable == false:
		sprite.material.set_shader_parameter("width",1)
	else:
		sprite.material.set_shader_parameter("width",0)
	
	# throwing code
	if throwable == true:
		sprite.rotate(rotate_speed*delta)
		position += velocity*delta*500
		velocity /= 1.04
		
		await get_tree().create_timer(1).timeout
		throwable = false
	
	# code for picking the stick up
	if Input.is_action_just_pressed("pickup") and in_range and Global.sticks < 7:
		Global.sticks += 1
		queue_free()
	

# burning script
func _on_fireplace_detect_body_entered(body: Node2D) -> void:
	if Global.fireplace_level != 0:
		Global.FUEL_THE_FLAMES()
		$AnimationPlayer.play("burn")
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
