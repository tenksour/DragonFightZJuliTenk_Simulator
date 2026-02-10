extends CharacterEstadoGeneric
var count_anim=0
var animacion_first_finished=false
var animationName="027_sway_f_anm"
@export var velocidad=50
var last_root_pos: Vector3=Vector3.ZERO
var prev_root_transform = Transform3D.IDENTITY
var skeleton_fake:Skeleton3D
var pivot_suelto:Node3D
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
	if character.is_action_just_pressed("cross")  and !character.is_action_pressed("down") and !character.is_action_pressed("left") and !character.is_action_pressed("right") and !activo :
		iniciar()	
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
		direction=direction.normalized()*40
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
	pass
func postIniciar():
	character.callSoundMovimientoCerca()
	pivot_suelto=character.characterPivot.duplicate()
	character.get_parent().add_child(pivot_suelto)
	pivot_suelto.visible=false
	pivot_suelto.global_position=character.characterPivot.global_position
	pivot_suelto.get_node("Node3D/personaje_glb/AnimationPlayer").play(animationName,0.3)
	skeleton_fake=pivot_suelto.get_node("Node3D/personaje_glb/Armature/Skeleton3D")
	character.reiniciarBlendAnimationPlayer()
	desconectarSeñalAnimationPlayer(onAnimationFinished)
	character.animationPlayer.play(animationName,0.3)
	conectarSeñalAnimationPlayer(onAnimationFinished)
	
	#para que no rote en ese eje, pero la posicion seguira, por que el pivot suelto es el que manda en movimiento
	var dir_rotar=character.characterTarget.global_position
	dir_rotar.y=0
	character.characterPivot.look_at(dir_rotar,Vector3.UP)
	character.characterPivot.global_rotation.x=0
	pivot_suelto.look_at(character.characterTarget.global_position,Vector3.UP)
	
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
