extends CharacterEstadoGeneric
var count_anim=0
var animationNameFront="195_damage_charged_attack_in_anm"
var animationNameBack="196_damage_charged_attack_loop_anm"
@export var damage_vida_origin=1
var damage_vida_final=damage_vida_origin
var is_front=true
var originDamage:Node3D
var timeLife=120
@export var aceleration=125
var direction=Vector3.ZERO
func _ready() -> void:
	super._ready()

	pass
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if activo:
		if timeCount>timeLife:
			detener()
			return
		#var direction=character.global_position-originDamage.global_position
		#direction.y=0
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
	pass
func iniciar_damage(damage_rest_multiply:float,_originDamage:Node3D,_is_front=true):
	is_front=_is_front
	originDamage=_originDamage
	direction=character.global_position-originDamage.global_position
	direction.y=0
	damage_vida_final=damage_vida_origin*damage_rest_multiply
	print("iniciado1: "+str(iniciado))
	iniciar()
	
	pass
func postIniciar():
	print("iniciado1: "+str(iniciado))
	#super.iniciar()
	print("iniciado2: "+str(iniciado))
	#character.vida-=damage_vida_final
	desconectarSeñalAnimationPlayer(onAnimationFinished)
	if is_front:
		character.animationPlayer.play(animationNameFront,0.1)
	else:
		character.animationPlayer.play(animationNameBack,0.1)
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
