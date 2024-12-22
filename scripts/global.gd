extends Node

var time :int
var player_position
var sticks :int
var fireplace_level = 4
var fire_dead : bool
var embing = false
var freeze_value = 0
var player_ref = null
var dead = false
var has_torch = true
 

func FUEL_THE_FLAMES():
	fireplace_level += 1
	embing = true
