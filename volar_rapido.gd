extends CharacterEstadoGeneric
var count_anim=0
var animationNamesEntrada=["012_dash_f_in_anm",
"015_dash_l_in_anm",
"018_dash_r_in_anm",
"012_dash_f_in_anm"
]
var animationNamesLoop=["013_dash_f_loop_anm",
"016_dash_l_loop_anm",
"019_dash_r_loop_anm",
"013_dash_f_loop_anm"
]

var animationGolpeIn="092_rush_strike_f_in_anm"
var animationGolpeChargue="093_rush_strike_f_loop_anm"
var inicio_golpe=false
var inicio_golpe_chargue=false


var animacion_first_finished=false
@export var damage_vida_origin=1
var damage_vida_final=damage_vida_origin
var is_front=true
var gravedad=true
@export var velocidad=5
@export var velocidad_giro=15
@export var velocidad_giro_up=1.4
@export var estadoNameDetenerReturnNotGravity="idle_vuelo"
func _ready() -> void:
	super._ready()

	pass
func isPressCualquierFlecha():
	if character.is_action_pressed("left"):
		return true
	if character.is_action_pressed("right"):
		return true
	if character.is_action_pressed("up"):
		return true
	if character.is_action_pressed("down"):
		return true
	return false
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if character.is_action_pressed("cross") and !activo:
		if !character.get_node("area_targering").isTargetisInArea():
			iniciar()
	if (character.is_action_just_released("cross") or character.is_action_just_released("square"))  and activo:
		if inicio_golpe:
			onlyDetener()
			$"../dash_square_fuerte_out".iniciar()
		else:
			detener()
	if activo:
		if character.is_action_just_pressed("square"):
			inicio_golpe=true
		var giro_velocity=velocidad_giro
		
		#Si ya inicio a cargar el golpe
		#Si el personaje esta frente al enemigo, es decir mirando al frente
		#Si el personaje tiene un target character
		#Entonces su pivot apuntadra al oponente  gradualmente
		if inicio_golpe and character.get_pivot_look_relative_to_camera(character.camera)=="FRONT" and character.characterTarget!=null and character.targering_character:
			var objetivo = character.characterTarget.global_transform.origin
			var dir = (objetivo - global_transform.origin).normalized()

			var rot_actual = character.characterPivot.global_transform.basis
			var rot_deseada = Basis().looking_at(dir, Vector3.UP)
			character.characterPivot.global_transform.basis = rot_actual.slerp(rot_deseada, delta * 40)
		#giro_velocity=velocidad_giro_up
		#if character.get_pivot_look_relative_to_camera(character.camera)=="FRONT" and character.characterTarget!=null and character.targering_character:
			#giro_velocity=velocidad_giro_up
		#if character.characterTarget!=null and character.targering_character:
			#print("aplicando velocidad giro max")
			#giro_velocity=velocidad_giro_up
		var dir=character.calcSimpleMoveWalking(delta,velocidad,giro_velocity)
		if dir==Vector3.ZERO:
			dir=character.auomaticSimpleWalkingPivot(delta,velocidad)
		character.velocity=dir
		var direction_target=Vector3.ZERO
		if character.characterTarget!=null and character.get_pivot_look_relative_to_camera(character.camera)=="FRONT":
			direction_target=character.characterTarget.global_position-character.global_position
			direction_target=direction_target.normalized()
			direction_target*=180
			character.velocity.y+=direction_target.y
		
		if gravedad:
			character.velocity+=character.calcDirectionGravity(delta)
		character.move_and_slide()
		if animacion_first_finished and !inicio_golpe:
			character.animationPlayer.get_animation(getAnimNameLoop()).loop_mode=Animation.LOOP_LINEAR
			character.animationPlayer.play(getAnimNameLoop(),1.6)
		else: if inicio_golpe and !inicio_golpe_chargue:
			character.reiniciarBlendAnimationPlayer()
			character.animationPlayer.play(animationGolpeIn,0.2)
		else: if inicio_golpe and inicio_golpe_chargue:
			character.animationPlayer.play(animationGolpeChargue,0.1)
			pass
	#if character.is_action_just_pressed("r2"):
		#print("entrorrrrr")
		#iniciar_damage(2)
	#if activo:
		#print("iniciado: "+str(iniciado))
	pass
func onAnimationFirshFinished(animName):
	if animName==animationGolpeChargue:
		onlyDetener()
		$"../dash_square_fuerte_out".iniciar()
		return			
	animacion_first_finished=true
	if animName==animationGolpeIn:
		inicio_golpe_chargue=true
	
func onAnimationFinished(animName):
	detener()
	pass
func getAnimNameLoop():
	if character.get_pivot_look_relative_to_camera(character.camera)=="FRONT":
		return animationNamesLoop[0]
		pass
	if character.get_pivot_look_relative_to_camera(character.camera)=="BACK":
		return animationNamesLoop[3]
		pass
	if character.get_pivot_look_relative_to_camera(character.camera)=="LEFT":
		return animationNamesLoop[1]
		pass
	if character.get_pivot_look_relative_to_camera(character.camera)=="RIGHT":
		return animationNamesLoop[2]
		pass
	return animationNamesLoop[0]
	pass
func getAnimNameEntrada():
	if character.get_pivot_look_relative_to_camera(character.camera)=="FRONT":
		return animationNamesEntrada[0]
		pass
	if character.get_pivot_look_relative_to_camera(character.camera)=="BACK":
		return animationNamesEntrada[3]
		pass
	if character.get_pivot_look_relative_to_camera(character.camera)=="LEFT":
		return animationNamesEntrada[1]
		pass
	if character.get_pivot_look_relative_to_camera(character.camera)=="RIGHT":
		return animationNamesEntrada[2]
		pass
	return animationNamesEntrada[0]
	pass
func postIniciar():
	character.callSoundGolpeVueloRapido()
	inicio_golpe=false
	inicio_golpe_chargue=false
	animacion_first_finished=false
	if character.is_on_floor():
		gravedad=true
		estadoNameDetenerReturn="normal"
	else:
		gravedad=false
		estadoNameDetenerReturn=estadoNameDetenerReturnNotGravity
	#if character.get_pivot_look_relative_to_camera(character.camera)=="FRONT":
		#character.animationPlayer.play(animationNamesEntrada[0],0.1)
		#pass
	#if character.get_pivot_look_relative_to_camera(character.camera)=="BACK":
		#character.animationPlayer.play(animationNamesEntrada[3],0.1)
		#pass
	#if character.get_pivot_look_relative_to_camera(character.camera)=="LEFT":
		#character.animationPlayer.play(animationNamesEntrada[1],0.1)
		#pass
	#if character.get_pivot_look_relative_to_camera(character.camera)=="RIGHT":
		#character.animationPlayer.play(animationNamesEntrada[2],0.1)
		#pass
	character.animationPlayer.play(getAnimNameEntrada(),0.5)
	conectarSeñalAnimationPlayer(onAnimationFirshFinished)
	#print("iniciado1: "+str(iniciado))
	##super.iniciar()
	#print("iniciado2: "+str(iniciado))
	#character.vida-=damage_vida_final
	#desconectarSeñalAnimationPlayer(onAnimationFinished)
	#if is_front:
		#print("toca "+str(animationNames[count_anim]))
		#character.animationPlayer.play(animationNames[count_anim],0.1)
	#else:
		#print("toca "+str(animationNames[count_anim]))
		#character.animationPlayer.play(animationNamesBack[count_anim],0.1)
	#addCountAnim()
	#conectarSeñalAnimationPlayer(onAnimationFinished)
	pass
func addCountAnim():
	count_anim+=1
	#if count_anim>=animationNames.size():
		#count_anim=0
		#pass
	pass
func onlyDetener():
	super.onlyDetener()
	animacion_first_finished=false
	character.reiniciarBlendAnimationPlayer()
	desconectarSeñalAnimationPlayer(onAnimationFinished)
	desconectarSeñalAnimationPlayer(onAnimationFirshFinished)
