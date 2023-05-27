extends Node

enum Portals {RIGHT, LEFT, NONE}

@export_category("Portal Settings")
@export_range(0,1.0) var slow_time : float = 0.07

var spawning_portal : bool = false
var actual_portal : Portals = Portals.NONE
var right_portal : Portal
var left_portal : Portal
var aiming_portal : Portal
var start_point : Vector2 = Vector2.ZERO
var end_point : Vector2 = Vector2.ZERO


var portal_scene := preload("res://Portal/portal.tscn")

func _process(delta):
	handle_right_portal_input()
	handle_left_portal_input()
	
	aim_portal()

func handle_right_portal_input():
	if Input.is_action_just_pressed("right-click") and !spawning_portal:
		actual_portal = Portals.RIGHT
		spawning_portal = true
		Engine.time_scale = slow_time
		start_point = get_parent().get_global_mouse_position()
		spawn_portal()
	
	if Input.is_action_just_released("right-click") and actual_portal == Portals.RIGHT:
		actual_portal = Portals.NONE
		spawning_portal = false
		Engine.time_scale = 1

func handle_left_portal_input():
	if Input.is_action_just_pressed("left-click") and !spawning_portal:
		actual_portal = Portals.LEFT
		spawning_portal = true
		Engine.time_scale = slow_time
		start_point = get_parent().get_global_mouse_position()
		spawn_portal()
	
	if Input.is_action_just_released("left-click") and actual_portal == Portals.LEFT:
		actual_portal = Portals.NONE
		spawning_portal = false
		Engine.time_scale = 1


func spawn_portal():
	var instance = portal_scene.instantiate()
	
	if actual_portal == Portals.RIGHT:
		if right_portal : right_portal.queue_free()
		right_portal = instance
	elif actual_portal == Portals.LEFT:
		if left_portal : left_portal.queue_free()
		left_portal = instance
	
	aiming_portal = instance
	
	add_child(instance)
	instance.set_global_position(start_point)
	instance.set_as_top_level(true)

func aim_portal():
	if !spawning_portal:
		return
	
	var angle_rotation = start_point.angle_to_point(get_parent().get_global_mouse_position())
	aiming_portal.set_global_rotation(angle_rotation)
