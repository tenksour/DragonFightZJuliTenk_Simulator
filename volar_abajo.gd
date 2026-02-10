extends CharacterEstadoGeneric
var count_anim=0
var animacion_first_finished=false
var animationName="044_flydown_in_anm"
@export var velocidad=-50
func _ready() -> void:
	super._ready()

	pass
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if character.is_on_floor() and activo:
		character.callSoundSaltoSalida()
		estadoNameDetenerReturn="normal"
		detener()
	if character.is_action_pressed("r2") and !activo and !character.is_on_floor() :
		iniciar()
	if character.is_action_just_released("r2") and activo:
		estadoNameDetenerReturn="idle_vuelo"
		detener()
	if activo:
		var direction=character.calcSimpleMoveWalking(delta)
		direction.y+=velocidad
		character.velocity=direction
		character.move_and_slide()
		
		
		
	pass


func postIniciar():
	character.callSoundMovimientoCerca()
	character.reiniciarBlendAnimationPlayer()
	character.animationPlayer.play(animationName,0.5)
	#character.animationPlayer.play("055_strike_01_anm",0.2)
	#character.animationPlayer.get_animation(animationName).loop_mode=Animation.LOOP_LINEAR
	pass
func addCountAnim():
	count_anim+=1

	pass
func onlyDetener():
	super.onlyDetener()
