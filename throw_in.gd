extends CharacterEstadoGeneric
var count_anim=0
var animacion_first_finished=false
var animationName="148_throw_in_anm"
@export var velocidad_root_motion=60
var last_root_pos: Vector3=Vector3.ZERO
var prev_root_transform = Transform3D.IDENTITY
var skeleton_fake:Skeleton3D
var pivot_suelto:Node3D
var time_preload=0
var tipo_damage=3 #3 mandar a volar, 2 mandar volar aturdir , 1 golpe debil
func _ready() -> void:
	super._ready()

	pass
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	#if character.estado=="saltando":
		#if character.is_action_pressed("r1") and !activo and $"../jump".timeCount>20:
			#iniciar()
		#pass
	#else:
	#if character.is_action_pressed("circle") and !activo :
		##time_preload+=1
		##if time_preload>30:
		#iniciar()
	#else:
		#time_preload=0	
	pass
	#if character.is_action_just_released("cross") and activo:
		#detener()
	if activo:
		pass
		#var skeleton=character.characterImportedSkeleton
		#var root_bone_idx=skeleton.find_bone("000_NULL")
		#var current_root_transform = skeleton.get_bone_global_pose(root_bone_idx)
	## Delta de movimiento del root
		#var root_delta = prev_root_transform.affine_inverse() * current_root_transform
	#
	## Mover al CharacterBody
		#var motion = root_delta.origin
		#motion.y = 0  # opcional, evitar movimiento vertical
		#character.velocity=motion/delta
		#character.move_and_slide()
	#
	## Resetear la posición del root en local para que la animación no mueva el mesh
		#var parent_transform = skeleton.get_bone_global_pose(skeleton.get_bone_parent(root_bone_idx))
		#skeleton.set_bone_global_pose_override(root_bone_idx, parent_transform, 1.0, true)
	## Guardar para el siguiente frame
		#prev_root_transform = current_root_transform
		
		#character.characterPivot.look_at(character.characterTarget.global_position,Vector3.UP)
		var position_bone=character.getPositionGlobalFromBone2("000_NULL",skeleton_fake)
		var direction=position_bone-character.global_position
		##direction.y+=velocidad
		character.anularPositionAnimationBone("000_NULL")
		direction=direction.normalized()*velocidad_root_motion
		character.velocity=direction
		character.move_and_slide()
		#var current_pose = character.characterImportedSkeleton.get_bone_global_pose(character.characterImportedSkeleton.find_bone("000_NULL"))
		#var current_pos = current_pose.origin
		## Delta de movimiento del hueso
		#if last_root_pos==Vector3.ZERO:
			#var boneidxe=character.characterImportedSkeleton.find_bone("000_NULL")
			#last_root_pos = character.characterImportedSkeleton.get_bone_global_pose(boneidxe).origin
		#var bone_delta = current_pos - last_root_pos
		## Normalmente ignoramos Y para root motion en suelo
		#bone_delta.y = 0.0
		## Convertimos delta en velocidad
		#character.velocity = bone_delta / delta
#
		## Movimiento real del CharacterBody3D
		#character.move_and_slide()
		## --- Anular movimiento visual del hueso ---
		##var pose = character.characterImportedSkeleton.get_bone_pose(character.characterImportedSkeleton.find_bone("000_NULL"))
		##pose.origin = Vector3.ZERO
		##character.characterImportedSkeleton.set_bone_pose(character.characterImportedSkeleton.find_bone("000_NULL"), pose)
		##
		##
		#last_root_pos = current_pos
		# --- Anular movimiento visual del hueso ---
		#var pose := skeleton.get_bone_pose(root_bone_idx)
		#pose.origin = Vector3.ZERO
		#skeleton.set_bone_pose(root_bone_idx, pose)
		#character.global_position=position_bone
		
		
	pass
func onAnimationFinished(animName):
	#if animName==animationNameIn:
		#pivot_suelto.global_position=character.characterPivot.global_position
		#character.animationPlayer.play(animationNameChargue,0.1)
		#pivot_suelto.get_node("Node3D/personaje_glb/AnimationPlayer").play(animationNameChargue,0.1)
	#if animationNameChargue==animName:
	detener()
	#desconectarSeñalAnimationPlayer(onAnimationFinished)
	#conectarSeñalAnimationPlayer(onAnimationSecondFinished)
	#detener()
	pass
func postIniciar():
	character.callSoundGolpeViento()
	print("Post iniciar: "+estadoName)
	pivot_suelto=character.characterPivot.duplicate()
	character.get_parent().add_child(pivot_suelto)
	pivot_suelto.visible=false
	pivot_suelto.global_position=character.characterPivot.global_position
	pivot_suelto.get_node("Node3D/personaje_glb/AnimationPlayer").play(animationName,0.2)
	skeleton_fake=pivot_suelto.get_node("Node3D/personaje_glb/Armature/Skeleton3D")
	character.reiniciarBlendAnimationPlayer()
	desconectarSeñalAnimationPlayer(onAnimationFinished)
	character.animationPlayer.play(animationName,0.2)
	conectarSeñalAnimationPlayer(onAnimationFinished)
	
	#para que no rote en ese eje, pero la posicion seguira, por que el pivot suelto es el que manda en movimiento
	#no necesito rotar
	#if character.characterTarget!=null:
		#var dir_rotar=character.characterTarget.global_position
		#dir_rotar.y=0
		#character.characterPivot.look_at(dir_rotar,Vector3.UP)
		#character.characterPivot.global_rotation.x=0
		#pivot_suelto.look_at(character.characterTarget.global_position,Vector3.UP)
	#

	#character.get_node("areas").get_node("area_arm_left").monitoring=false
	#character.get_node("areas").get_node("area_arm_right").monitoring=false

	character.desactivarAreasColisionGolpe()
	character.conectarSeñalesAreas(_on_area_arm_attack_body_entered)
	character.get_node("AnimationPlayer").play(animationName)
	#character.animationPlayer.play("055_strike_01_anm",0.2)
	#character.animationPlayer.get_animation(animationName).loop_mode=Animation.LOOP_LINEAR
	pass
func addCountAnim():
	count_anim+=1

	pass
func onlyDetener():
	print("se detendra fuerte out")
	super.onlyDetener()
	pivot_suelto.queue_free()
	character.desconectarSeñalesAreas(_on_area_arm_attack_body_entered)
	desconectarSeñalAnimationPlayer(onAnimationFinished)
func _on_area_arm_attack_body_entered(body: Node3D) -> void:
	print("estadoName: "+str(estadoName)+" activo: "+str(activo))
	if !activo:
		return
	if body==character:
		return
	if body is CharacterPrin:
		onlyDetener()
		$"../throw_event".iniciar()
		
		#character.callTemblor2()
		#print("time anim aux: "+str(character.get_node("AnimationPlayer").current_animation_position))
		#print("Llamando daño desde: "+character.name +" a "+ body.name)
		#body.vida-=1
		#body.callDamageAturdir(1,character)
		#if tipo_damage==3:
			#body.callDamageFuerteChargue(1,character)
		#if tipo_damage==2:
			#body.callDamageFuerteRolling(1,character)
		#else: 
			#body.callSimpleDamage(1,character)

		#body.callDamageFuerteChargue(1,character)
	else:
		if body.has_method("callSimpleDamage"):
			body.callSimpleDamage(character,1)
			pass
		pass
	pass # Replace with function body
