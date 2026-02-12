extends CharacterEstadoGeneric
var count_anim=0
var animationNameFront="150_throw_event_anm"
var animationNameBack="151_throw_enemy_anm"
@export var damage_vida_origin=1
var damage_vida_final=damage_vida_origin
var is_front=true
var originDamage:Node3D
var timeLife=10
@export var aceleration=5
var charEnemy:CharacterPrin
var animationPlayerClone:AnimationPlayer
func _ready() -> void:
	super._ready()

	pass
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if character.is_action_just_pressed("circle") and !activo:
		iniciar()
	if activo:
		
		var nombre_hueso_throw="052_THROW"
		var nombre_hueso_pivot=character.boneThrow
		var pos_bone_enemy=null
		#if character.boneThrowCurrent:
		pos_bone_enemy=character.getPositionGlobalFromBone(nombre_hueso_throw)
		#else:
			#pos_bone_enemy=character.get_bone_global_rest_position(character.characterImportedSkeleton,nombre_hueso_pivot)
		#var rotation_enemy=character.getRotationGlobalFromBone(nombre_hueso_throw)
		#var pos_bone_enemy=character.get_bone_global_rest_position(character.characterImportedSkeleton,"016_BELLY")
		if character.characterTarget:
			
			var charenemi:CharacterPrin=character.characterTarget
			charenemi.estado="null"
			charenemi.enableColision(character.aciveColisionEnemyThrow)
			#charenemi.global_position=character.global_position
			charenemi.characterPivot.global_rotation=character.characterPivot.global_rotation
			#charenemi.global_position=pos_bone_enemy
			#var pos_bone_enemy_central=character.get_bone_global_rest_position(charenemi.characterImportedSkeleton,nombre_hueso_pivot)
			var pos_bone_enemy_central=charenemi.getPositionGlobalFromBone(nombre_hueso_pivot)
			var diferencia_hueso=pos_bone_enemy_central-charenemi.global_position
			#var diferencia=pos_bone_enemy_central-pos_bone_enemy
			#var posicion_final=pos_bone_enemy-diferencia
			var posicion_final=pos_bone_enemy-diferencia_hueso
			#charenemi.global_position=pos_bone_enemy-diferencia_hueso
			var direction=posicion_final-charenemi.global_position
			var distance = direction.length()
			direction=direction.normalized()*30
			var step = min(distance, 30)
			#charenemi.global_rotation=rotation_enemy
			charenemi.velocity=direction*step
			charenemi.move_and_slide()
		pass
	pass
func onAnimationFinished(animName):
	detener()
	pass
	pass
func postIniciar():
	animationPlayerClone=null
	charEnemy=null
	print("iniciado1: "+str(iniciado))
	#character.vida-=damage_vida_final
	desconectarSeñalAnimationPlayer(onAnimationFinished)
	#if is_front:
		#character.animationPlayer.play(animationNameFront,0.1)
	#else:
		#character.animationPlayer.play(animationNameBack,0.1)
	#addCountAnim()
	#character.characterPivot.look_at(originDamage.global_position,Vector3.UP)
	#if !is_front:
		#character.characterPivot.rotate_y(deg_to_rad(180))
	#if !is_front:
		#character.characterPivot.look_at(character.characterPivot.global_position- originDamage.global_position,Vector3.UP)
	#character.characterPivot.global_rotation.x=0
	if character.characterTarget:
		
		charEnemy=character.characterTarget
		charEnemy.estado="null"
		var animationPlayerOriginal=character.animationPlayer
		animationPlayerClone=animationPlayerOriginal.duplicate()
		charEnemy.characterImportedSkeleton.get_parent().get_parent().add_child(animationPlayerClone)
		charEnemy.animationPlayer.pause()
		
		animationPlayerClone.play(animationNameBack)
		
		var libraryAuxCharEnemy=charEnemy.getAnimationPlayerAux().get_animation_library("")
		var animationAux=character.getAnimationPlayerAux().get_animation(animationNameBack)
		if animationAux:
			libraryAuxCharEnemy.add_animation("temporal_animation",animationAux)
			charEnemy.getAnimationPlayerAux().play("temporal_animation")
		pass
		
	##voy a tener que crear otro animation player duplicado para
	##para poder invocar parametros del personaje enemigo
	## o copiarlo temporalmente al character del enemigo y luego borrarlo
	##si eso seria lo mejor
	character.animationPlayer.play(animationNameFront,0.1)
	if character.getAnimationPlayerAux().has_animation(animationNameFront):
		character.getAnimationPlayerAux().play(animationNameFront)

	
	conectarSeñalAnimationPlayer(onAnimationFinished)
	#character.activarCamaraThrow()
	pass
func addCountAnim():
	pass
func onlyDetener():
	
	super.onlyDetener()
	character.activarCamaraOriginal()
	if charEnemy!=null:
		charEnemy.enableColision(true)
		charEnemy.estado=estadoNameDetenerReturnNotFloor
	if animationPlayerClone!=null:
		animationPlayerClone.queue_free()
	desconectarSeñalAnimationPlayer(onAnimationFinished)
