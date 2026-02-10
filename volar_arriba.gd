extends CharacterEstadoGeneric
var count_anim=0
var animacion_first_finished=false
var animationName="043_flyup_anm"
@export var velocidad=50
func _ready() -> void:
	super._ready()

	pass
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if character.estado=="saltando":
		if character.is_action_pressed("r1") and !activo and $"../jump".timeCount>20:
			iniciar()
		pass
	else:
		if character.is_action_pressed("r1") and !activo :
			iniciar()	
		pass
	if character.is_action_just_released("r1") and activo:
		detener()
	if activo:
		var direction=character.calcSimpleMoveWalking(delta)
		direction.y+=velocidad
		character.velocity=direction
		character.move_and_slide()
		
		
		
	pass


func postIniciar():
	character.callSoundVueloUp()
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
