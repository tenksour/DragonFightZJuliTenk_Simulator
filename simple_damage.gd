extends CharacterEstadoGeneric
var count_anim=0
var animationNames=["158_f_damage_anm",
"159_f_damage_l_anm",
"160_f_damage_r_anm",
"161_f_damage_b_anm"
]
var animationNamesBack=["162_b_damage_anm",
"163_b_damage_l_anm",
"164_b_damage_r_anm",
"165_b_damage_b_anm"
]
@export var damage_vida_origin=1
var damage_vida_final=damage_vida_origin
var is_front=true
func _ready() -> void:
	super._ready()

	pass
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	#if character.is_action_just_pressed("r2"):
		#print("entrorrrrr")
		#iniciar_damage(2)
	#if activo:
		#print("iniciado: "+str(iniciado))
	pass
func onAnimationFinished(animName):
	detener()
	pass
func iniciar_damage2(damage_rest_multiply:float,_is_front=true):
	is_front=_is_front
	damage_vida_final=damage_vida_origin*damage_rest_multiply
	print("iniciado1: "+str(iniciado))
	iniciar()
	pass
func iniciar_damage(damage_rest_multiply:float):
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
		print("toca "+str(animationNames[count_anim]))
		character.animationPlayer.play(animationNames[count_anim],0.1)
	else:
		print("toca "+str(animationNames[count_anim]))
		character.animationPlayer.play(animationNamesBack[count_anim],0.1)
	addCountAnim()
	conectarSeñalAnimationPlayer(onAnimationFinished)
	pass
func addCountAnim():
	count_anim+=1
	if count_anim>=animationNames.size():
		count_anim=0
		pass
	pass
func onlyDetener():
	super.onlyDetener()
	desconectarSeñalAnimationPlayer(onAnimationFinished)
