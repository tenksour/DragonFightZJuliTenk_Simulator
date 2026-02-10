extends CharacterEstadoGeneric
var count_anim=0
var animationNameFrontIn="189_damage_rolling_back_in_anm"
var animationNameFrontLoop="190_damage_rolling_back_loop_anm"
var animationNameBackIn="192_damage_rolling_in_anm"
var animationNameBackLoop="193_damage_rolling_loop_anm"
@export var damage_vida_origin=1
var damage_vida_final=damage_vida_origin
var is_front=true
var originDamage:Node3D
var timeLife=60
@export var aceleration=90
var animationInFinished=false
func _ready() -> void:
	super._ready()

	pass
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if activo:
		if animationInFinished:
			if is_front:
				character.animationPlayer.play(animationNameFrontLoop,0.1)
			else:
				character.animationPlayer.play(animationNameBackLoop,0.1)
		if timeCount>timeLife:
			detener()
			return
		var direction=character.global_position-originDamage.global_position
		direction.y=0
		direction=direction.normalized()*aceleration
		character.velocity=direction
		character.move_and_slide()
	#if character.is_action_just_pressed("r2"):
		#print("entrorrrrr")
		#iniciar_damage(2)
	#if activo:
		#print("iniciado: "+str(iniciado))
	pass
func onAnimationFinished(animName):
	#detener()
	animationInFinished=true
	pass
func iniciar_damage(damage_rest_multiply:float,_originDamage:Node3D,_is_front=true):
	is_front=_is_front
	originDamage=_originDamage
	damage_vida_final=damage_vida_origin*damage_rest_multiply
	print("iniciado1: "+str(iniciado))
	iniciar()
	
	pass
func postIniciar():
	animationInFinished=false
	print("iniciado1: "+str(iniciado))
	#super.iniciar()
	print("iniciado2: "+str(iniciado))
	#character.vida-=damage_vida_final
	desconectarSeñalAnimationPlayer(onAnimationFinished)
	if is_front:
		character.animationPlayer.play(animationNameFrontIn,0.1)
	else:
		character.animationPlayer.play(animationNameBackIn,0.1)
	addCountAnim()
	character.characterPivot.look_at(originDamage.global_position,Vector3.UP)
	if !is_front:
		character.characterPivot.rotate_y(deg_to_rad(180))
	#if !is_front:
		#character.characterPivot.look_at(character.characterPivot.global_position- originDamage.global_position,Vector3.UP)
	character.characterPivot.global_rotation.x=0
	
	conectarSeñalAnimationPlayer(onAnimationFinished)
	pass
func addCountAnim():
	pass
func onlyDetener():
	super.onlyDetener()
	desconectarSeñalAnimationPlayer(onAnimationFinished)
