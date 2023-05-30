extends Area2D
class_name Portal

signal teleport(_entity : Node2D)

@export var collision_min_radius := 2

func _on_body_entered(body : Node2D):
	if !body.is_in_group("teleportable"):
		return
	
	var right_vect = global_transform.basis_xform(Vector2.RIGHT).normalized()
	var contact_vect = (body.global_position - global_position).normalized()
	
	if right_vect.dot(contact_vect) > 0 and (body.global_position - global_position).length() > collision_min_radius:
		emit_signal("teleport", body)
