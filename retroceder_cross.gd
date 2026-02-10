extends CharacterEstadoGeneric
var count_anim=0
var animacion_first_finished=false
var animationName="028_sway_b_anm"
var animationNameNotFlor="040_fly_sway_b_anm"
@export var velocidad=40
var last_root_pos: Vector3=Vector3.ZERO
var prev_root_transform = Transform3D.IDENTITY
var skeleton_fake:Skeleton3D
var pivot_suelto:Node3D

var continuar=false
var estadoCotinue:Node3D=self
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
	
	if character.is_action_just_pressed("cross") and character.is_action_pressed("down"):
		if !activo:
			iniciar()
		else:if timeCount>20:
			continuar=true	
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
		
		
		var position_bone=character.getPositionGlobalFromBone2("000_NULL",skeleton_fake)
		var direction=position_bone-character.global_position
		##direction.y+=velocidad
		character.anularPositionAnimationBone("000_NULL")
		direction=direction.normalized()*velocidad
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
	detener()
	if continuar:
		estadoCotinue.iniciar()
	pass
func postIniciar():
	character.callSoundMovimientoCerca()
	continuar=false
	var anmName=animationName
	if !character.is_on_floor():
		anmName=animationNameNotFlor
	pivot_suelto=character.characterPivot.duplicate()
	character.get_parent().add_child(pivot_suelto)
	pivot_suelto.visible=false
	pivot_suelto.global_position=character.characterPivot.global_position
	pivot_suelto.get_node("Node3D/personaje_glb/AnimationPlayer").play(anmName,0.3)
	skeleton_fake=pivot_suelto.get_node("Node3D/personaje_glb/Armature/Skeleton3D")
	character.reiniciarBlendAnimationPlayer()
	desconectarSeñalAnimationPlayer(onAnimationFinished)
	character.animationPlayer.play(anmName,0.3)
	conectarSeñalAnimationPlayer(onAnimationFinished)
	
	character.characterPivot.look_at(character.characterTarget.global_position,Vector3.UP)
	character.characterPivot.global_rotation.x=0
	
	pivot_suelto.look_at(character.characterTarget.global_position,Vector3.UP)
	pivot_suelto.global_rotation.x=0
	#character.animationPlayer.play("055_strike_01_anm",0.2)
	#character.animationPlayer.get_animation(animationName).loop_mode=Animation.LOOP_LINEAR
	pass
func addCountAnim():
	count_anim+=1

	pass
func onlyDetener():
	super.onlyDetener()
	pivot_suelto.queue_free()
	desconectarSeñalAnimationPlayer(onAnimationFinished)
