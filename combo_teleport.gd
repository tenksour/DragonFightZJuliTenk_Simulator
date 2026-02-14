extends CharacterEstadoGeneric
var count_anim=0
var animacion_first_finished=false
var animationName="031_sway_out_anm"
@export var velocidad_root_motion=50
var last_root_pos: Vector3=Vector3.ZERO
var prev_root_transform = Transform3D.IDENTITY
var skeleton_fake:Skeleton3D
var pivot_suelto:Node3D
var time_preload=0
var tipo_damage=3 #3 mandar a volar, 2 mandar volar aturdir , 1 golpe debil
var time_inicio_teleport=1
var nodeTarget:CharacterPrin
var directionCurrentTarget=Vector3.ZERO
func _ready() -> void:
	super._ready()
	pass
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if activo:
		if timeCount%4==0 or timeCount%3==0:
			character.characterPivot.visible=false
		else:
			character.characterPivot.visible=true
			pass
		pass
		#var position_bone=character.getPositionGlobalFromBone2("000_NULL",skeleton_fake)
		#var direction=position_bone-character.global_position
		###direction.y+=velocidad
		#character.anularPositionAnimationBone("000_NULL")
		#direction=direction.normalized()*velocidad_root_motion
		#character.velocity=direction
		#character.move_and_slide()
		
	pass
func onAnimationFinished(animName):
	#detener()
	transportar()
	onlyDetener()
	character.characterPivot.visible=true
	$"../golpe_square_fuerte_out".iniciar()
	pass
func iniciar2(targetCharacter:CharacterPrin,directionVelocity:Vector3):
	nodeTarget=targetCharacter
	directionCurrentTarget=directionVelocity
	iniciar()
	pass
func transportar():

	character.global_position=nodeTarget.global_position+(directionCurrentTarget/6)
	character.characterPivot.look_at(nodeTarget.global_position,Vector3.UP)
	character.characterPivot.global_rotation.x=0

func postIniciar():
	character.enfocarCamaraInstantaneo()
	character.callSoundTeleport()
	character.characterPivot.visible=false
	#character.callSoundGolpeViento()
	#print("Post iniciar: "+estadoName)
	#pivot_suelto=character.characterPivot.duplicate()
	#character.get_parent().add_child(pivot_suelto)
	#pivot_suelto.visible=false
	#pivot_suelto.global_position=character.characterPivot.global_position
	#pivot_suelto.get_node("Node3D/personaje_glb/AnimationPlayer").play(animationName,0.2)
	#skeleton_fake=pivot_suelto.get_node("Node3D/personaje_glb/Armature/Skeleton3D")
	#character.reiniciarBlendAnimationPlayer()
	desconectarSeñalAnimationPlayer(onAnimationFinished)
	character.animationPlayer.play(animationName,0.2)
	conectarSeñalAnimationPlayer(onAnimationFinished)
	
	##para que no rote en ese eje, pero la posicion seguira, por que el pivot suelto es el que manda en movimiento
	#
	#if character.characterTarget!=null:
		#var dir_rotar=character.characterTarget.global_position
		#dir_rotar.y=0
		#character.characterPivot.look_at(dir_rotar,Vector3.UP)
		#character.characterPivot.global_rotation.x=0
		#pivot_suelto.look_at(character.characterTarget.global_position,Vector3.UP)
	#

	#character.get_node("areas").get_node("area_arm_left").monitoring=false
	#character.get_node("areas").get_node("area_arm_right").monitoring=false

	#character.desactivarAreasColisionGolpe()
	#character.conectarSeñalesAreas(_on_area_arm_attack_body_entered)
	#character.get_node("AnimationPlayer").play(animationName)
	pass
func addCountAnim():
	count_anim+=1

	pass
func onlyDetener():
	print("se detendra comboteleport out")
	super.onlyDetener()
	character.characterPivot.visible=true
	#pivot_suelto.queue_free()
	character.desconectarSeñalesAreas(_on_area_arm_attack_body_entered)
	desconectarSeñalAnimationPlayer(onAnimationFinished)
func _on_area_arm_attack_body_entered(body: Node3D) -> void:
	print("estadoName: "+str(estadoName)+" activo: "+str(activo))
	if !activo:
		return
	if body==character:
		return
	if body is CharacterPrin:
		character.callTemblor2()
		print("time anim aux: "+str(character.get_node("AnimationPlayer").current_animation_position))
		print("Llamando daño desde: "+character.name +" a "+ body.name)
		#body.vida-=1
		if tipo_damage==3:
			body.callDamageFuerteChargue(1,character)
		if tipo_damage==2:
			body.callDamageFuerteRolling(1,character)
		else: 
			body.callSimpleDamage(1,character)

		#body.callDamageFuerteChargue(1,character)
	else:
		if body.has_method("callSimpleDamage"):
			body.callSimpleDamage(character,1)
			pass
		pass
	pass # Replace with function body
func conectarSeñalesAreas():
	character.get_node("areas").get_node("area_arm_left").body_entered.connect(_on_area_arm_attack_body_entered)
	character.get_node("areas").get_node("area_arm_right").body_entered.connect(_on_area_arm_attack_body_entered)
	character.get_node("areas").get_node("area_leg_left").body_entered.connect(_on_area_arm_attack_body_entered)
	character.get_node("areas").get_node("area_leg_right").body_entered.connect(_on_area_arm_attack_body_entered)
	pass
func desconectarSeñalesAreas():
	if character.get_node("areas").get_node("area_arm_right").body_entered.is_connected(_on_area_arm_attack_body_entered):
		character.get_node("areas").get_node("area_arm_right").body_entered.disconnect(_on_area_arm_attack_body_entered)
		pass
	if character.get_node("areas").get_node("area_arm_left").body_entered.is_connected(_on_area_arm_attack_body_entered):
		character.get_node("areas").get_node("area_arm_left").body_entered.disconnect(_on_area_arm_attack_body_entered)
	if character.get_node("areas").get_node("area_leg_left").body_entered.is_connected(_on_area_arm_attack_body_entered):
		character.get_node("areas").get_node("area_leg_left").body_entered.disconnect(_on_area_arm_attack_body_entered)
	if character.get_node("areas").get_node("area_leg_right").body_entered.is_connected(_on_area_arm_attack_body_entered):
		character.get_node("areas").g
