extends Node3D


func _on_button_button_down() -> void:
	$CharacterBody3D2.inputs_active=true
	$CharacterBody3D.inputs_active=false
	$CharacterBody3D2.camera.make_current()
	pass # Replace with function body.


func _on_button_2_button_down() -> void:
	$CharacterBody3D.inputs_active=true
	$CharacterBody3D2.inputs_active=false
	$CharacterBody3D.camera.make_current()
	pass # Replace with function body.
