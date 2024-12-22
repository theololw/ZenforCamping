extends Node2D

@export var plant_type: int
@onready var sprite = $plant1
var player_distance
var avr_player_distance

func _ready() -> void:
	if plant_type == 1:
		sprite.frame = 0
	if plant_type == 2:
		sprite.frame = 1
	if plant_type == 3:
		sprite.frame = 2

func _process(delta: float) -> void:
	player_distance = abs(position - Global.player_position)
	avr_player_distance = (player_distance.x + player_distance.y)/2.0
	
	if avr_player_distance <= 1000.0:
		$plant1.modulate.a = avr_player_distance / 150
	else:
		$plant1.modulate
	
	



func _on_fireplace_detect_area_entered(area: Area2D) -> void:
	queue_free()
