extends Node2D

@onready var clock = $Label
var time = Global.time

func _process(delta: float) -> void:
	time = Global.time
	#print(time)
	if time == 10:
		set_time("22:00")
	if time == 20:
		set_time("22:30")
	if time == 30:
		set_time("23:00")
	if time == 40:
		set_time("23:30")
	if time == 50:
		set_time("00:00")
	if time == 60:
		set_time("00:30")
	if time == 70:
		set_time("01:00")
	if time == 80:
		set_time("01:30")
	if time == 90:
		set_time("02:00")
	if time == 100:
		set_time("02:30")
	if time == 110:
		set_time("03:00")
	if time == 120:
		set_time("03:30")
	if time == 130:
		set_time("04:00")

func set_time(value):
	clock.text = value
