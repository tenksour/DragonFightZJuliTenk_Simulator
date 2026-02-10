extends Node3D
class_name estado_skill_simple
@onready var character:CharacterPrin=self.get_parent().get_parent()
@export var animationName="055_strike_01_anm"
@export var estadoName="skill_simple_1"

var activo=false
var iniciado=false
var aceleration_jump=8#aceleracion
var velocity_inicial=10;#velocidad inicial
var velocity_count=velocity_inicial;#variable temporal que suma
var velocity_max_aceleration=100 #velocidad maxima
var timeCayendo=0
var timeSalto=30
var animationInFinalizado=false
@export var colisionActiveRanges=[[0.24,0.92]]
@export var colisionTipo="bone_left"#bone_right,bone_leg_l,bone_leg_r,bone_effect
@export var timeCotinueNextSkill=0.1
var contineNextSkill=false#se asigna en tiempo real , y si hay nodo next ejecuta
@export var inputActive=true

var characterPrinIniciado=false
@export var estadosIn = ["normal","correr"]
@export var skillContinueNode:Node3D
@export var cool_down=50
var time_reset=0
var pivot_suelto:Node3D
var skeleton_fake:Skeleton3D
var velocidad_root_motion=30
##tipo damage 1=damage_simple 2=aturdir 3-mandar a volar
@export var tipo_damage=1#
func getAreaFromColisionTipo()->Area3D:
	if colisionTipo=="bone_left":
		return character.areaArmLeft
	if colisionTipo=="bone_right":
		return character.areaArmRight
	return null
	pass
func checkColisionArm():
	return
	#tengo que activarlo en una variable auxiliar a la fueta
	# por que si lpongo false por defecto el godot3d hace su calculo de nuevo como si se hubiera cambiado
	#como si se hubier acambiandod e false a verdadero y manda la señal otra vez
	var monitoring=false
	#character.areaArm.monitoring=false
	for range in colisionActiveRanges:
		if character.animationPlayer.current_animation_position>range[0] and character.animationPlayer.current_animation_position<range[1]:
			monitoring=true
			#character.areaArm.monitoring=true
			#pass
	getAreaFromColisionTipo().monitoring=monitoring
	pass
func _ready() -> void:
	print("skill simple original iniciado:"+animationName)
	
	pass
func _readyCharacter():
	if characterPrinIniciado:
		return
	if character:
		print("Señal conectada")
		#character.areaArm.body_entered.connect(_on_area_arm_attack_body_entered)
		characterPrinIniciado=true
	pass
func _physics_process(delta: float) -> void:
	_readyCharacter()

	time_reset+=1*delta
	if character.estado=="skill_simple_2":
		time_reset=0
	if character.estado!=estadoName and activo:
		print("se cumplio esta condicion 3")
		print("onlydetener")
		onlyDetener()
	#if activo and timeCayendo>timeSalto:
		#character.reiniciarGravedad()
		#detener()
	
	#if character.inputs_active and Input.is_action_just_pressed("triangle"):
		#character.areaArm.monitoring=!character.areaArm.monitoring
		#print("1 teclado trinagulo")
		#character.areaArm.clonarMaterial()
		#character.areaArm.monitoring=!character.areaArm.monitoring
	#return a
	if time_reset>(cool_down*delta) and inputActive and character.is_action_just_released("square") and estadosIn.has(character.estado):
		iniciar()
		#print("2 teclado iniciadooooo....")
		#character.areaArm.monitoring=false
	
	#character.areaArm.monitoring=truessssssssssssssssssssssssssssssss
	if activo:
		#character.visibleArm1(true)
		#var mesh_arm=null
		#if character.characterImportedSkeleton.has_node("arma1_hidde_default"):
			#mesh_arm=character.characterImportedSkeleton.get_node("arma1_hidde_default")
		#if mesh_arm:
			#mesh_arm.visible=true
		#var mesh_effectarm=null
		#if character.characterImportedSkeleton.has_node("arma1effect_hidde_default"):
			#mesh_effectarm=character.characterImportedSkeleton.get_node("arma1effect_hidde_default")
		#if mesh_effectarm:
			#mesh_effectarm.visible=true
		character.animationPlayer.play(animationName,0.05)
		character.get_node("AnimationPlayer").play(animationName)
		if character.inputs_active and Input.is_action_just_released("square") and character.animationPlayer.current_animation_position>timeCotinueNextSkill:
			#print("se continuara skill.....")
			contineNextSkill=true
		checkColisionArm()
		
		
		
		#pivot_suelto.look_at(character.characterTarget.global_position,Vector3.UP)
		#character.characterPivot.look_at(character.characterTarget.global_position,Vector3.UP)
		#character.characterPivot.global_rotation.x=0
		#pivot_suelto.global_rotation.x=0
		
		var position_bone=character.getPositionGlobalFromBone2("000_NULL",skeleton_fake)
		var direction=position_bone-character.global_position
		##direction.y+=velocidad
		character.anularPositionAnimationBone("000_NULL")
		direction=direction.normalized()*velocidad_root_motion
		#direction=direction.rotated(character.characterTarget.global_position,)
		character.velocity=direction
		character.move_and_slide()
		#character.velocity=character.calcDirectionGravity(delta)
		#character.move_and_slide()
			#pass
		#velocity_count+=aceleration_jump
		#if velocity_count>velocity_max_aceleration:
			#velocity_count=velocity_max_aceleration
		#
		##timeCayendo+=1
		##if !animAterrizar_iniciado:
		#if animationInFinalizado:
			#character.animationPlayer.play(animationName,0.3)
		#character.velocity=character.calcDirectionGravity(delta)
		#var direction=Vector3(0,velocity_count,0)
		#
		#character.velocity=direction
		#character.velocity+=character.calcSimpleMoveWalking(delta)
		#character.move_and_slide()
		#timeCayendo+=1
		
	#todo estado se debe detener automaticamente si el estado ya cambio de nombre
	#tambien habra estados secundarios que afectaran velocidad o aura

	pass

func onFinishedAnimation(animName):
	#detener()
	#return
	if contineNextSkill and skillContinueNode:	
		print(" se continuara skill")
		detener()
		skillContinueNode.iniciar()
	else:
		detener()
	#print("onanimationfinished")
		#animationInFinalizado=true
	#if skillContinueNode and contineNextSkill:
		#skillContinueNode.iniciar()
		#contineNextSkill=false
	#else:
		#detener()
	pass
func aterrizar():
	#if animAterrizar_iniciado:
		#return
	#print("aterrizar iniciado")
	#character.animationPlayer.play(animationNameAterrizaje,0.1)
	#character.animationPlayer.animation_finished.connect(onFinishedAterrizaje)
	#animAterrizar_iniciado=true
	pass
	
func iniciar():

	if iniciado:
		return
	character.callSoundGolpeViento()
	desconectarSeñalesAnimation()
	print("iniciado "+estadoName)
	#character.animationPlayer_basic.play("jump_camera")
	iniciado=true
	activo=true
	character.estado=estadoName
	contineNextSkill=false
	
	
	
	pivot_suelto=character.characterPivot.duplicate()
	character.get_parent().add_child(pivot_suelto)
	pivot_suelto.visible=false
	pivot_suelto.global_position=character.characterPivot.global_position
	pivot_suelto.get_node("Node3D/personaje_glb/AnimationPlayer").play(animationName,0.1)
	skeleton_fake=pivot_suelto.get_node("Node3D/personaje_glb/Armature/Skeleton3D")
	if character.characterTarget!=null:
		var dir_rotar=character.characterTarget.global_position
		dir_rotar.y=0
		character.characterPivot.look_at(dir_rotar,Vector3.UP)
		character.characterPivot.global_rotation.x=0
		pivot_suelto.look_at(character.characterTarget.global_position,Vector3.UP)
	
	
	
	character.get_node("areas").get_node("area_arm_left").monitoring=false
	character.get_node("areas").get_node("area_arm_right").monitoring=false

	#getAreaFromColisionTipo().monitoring=false
	#timeCayendo=0aa
	#velocity_count=velocity_inicial
	#character.animationPlayer.play(animationNameIn,0.1)
	character.animationPlayer.animation_finished.connect(onFinishedAnimation)
	#conectando 
	#print("--conecntado area..."+str(getAreaFromColisionTipo().get_path()))
	#print("--iniciado "+estadoName)
	#desconectarSeñalesAreas()
	character.conectarSeñalesAreas(_on_area_arm_attack_body_entered)
	#character.get_node("areas").get_node("area_arm_left").body_entered.connect(_on_area_arm_attack_body_entered)
	#character.get_node("areas").get_node("area_arm_right").body_entered.connect(_on_area_arm_attack_body_entered)
	#getAreaFromColisionTipo().body_entered.connect(_on_area_arm_attack_body_entered)aaaaaaaa
	
	pass
	
func onlyDetener():
	pivot_suelto.queue_free()
	character.get_node("areas").get_node("area_arm_left").monitoring=false
	character.get_node("areas").get_node("area_arm_right").monitoring=false
	time_reset=0
	
	#character.visibleArm1(false)
	#var mesh_arm=character.characterImportedSkeleton.get_node("arma1_hidde_default")
	#var mesh_effectarm=character.characterImportedSkeleton.get_node("arma1effect_hidde_default")
	#if mesh_effectarm:
		#mesh_arm.visible=false
	#if mesh_arm:
		#mesh_effectarm.visible=false
	animationInFinalizado=false
	iniciado=false
	activo=false
	contineNextSkill=false
	
	#getAreaFromColisionTipo().monitoring=false
	#character.areaArm.monitoring=false
	#velocity_count=velocity_inicial
	#timeCayendo=0
	desconectarSeñalesAnimation()
	#desconectarSeñalesAreas()
	character.desconectarSeñalesAreas(_on_area_arm_attack_body_entered)
func desconectarSeñalesAreas():
	if character.get_node("areas").get_node("area_arm_right").body_entered.is_connected(_on_area_arm_attack_body_entered):
		character.get_node("areas").get_node("area_arm_right").body_entered.disconnect(_on_area_arm_attack_body_entered)
		pass
	if character.get_node("areas").get_node("area_arm_left").body_entered.is_connected(_on_area_arm_attack_body_entered):
		character.get_node("areas").get_node("area_arm_left").body_entered.disconnect(_on_area_arm_attack_body_entered)
func detener():
	#print("detenido")
	onlyDetener()
	
	#character.areaArm.monitoring=false
	if character.is_on_floor():
		character.estado="normal"
	else:
		character.estado="idle_vuelo"
	pass
func desconectarSeñalesAnimation():
	#print("desconentadoanimacion y area3d")
	if character.animationPlayer.animation_finished.is_connected(onFinishedAnimation):
		character.animationPlayer.animation_finished.disconnect(onFinishedAnimation)
func _on_area_arm_attack_body_entered(body: Node3D) -> void:
	print("estadoName: "+str(estadoName)+" activo: "+str(activo))
	if !activo:
		return
	if body==character:
		return
	if body is CharacterPrin:
		character.callTemblor1()
		print("time anim aux: "+str(character.get_node("AnimationPlayer").current_animation_position))
		print("Llamando daño desde: "+character.name +" a "+ body.name)
		#body.vida-=1
		if tipo_damage==2:
			body.callDamageAturdir(1,character)
		else:
			body.callSimpleDamage(1,character)
	else:
		if body.has_method("callSimpleDamage"):
			body.callSimpleDamage(character,1)
			pass
		pass
	pass # Replace with function body
#esta fucnion es la que se puede remplazar desde clases extenddias.

	#body.visible=false
