extends Node3D
func iniciar():
	$AnimationPlayer.play("lanzamiento")
	$AnimationPlayer.animation_finished.connect(onFinished)
func onFinished(animName):
	queue_free()
	pass
