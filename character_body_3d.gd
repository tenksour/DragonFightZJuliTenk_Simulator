
extends CharacterBody3D
class_name CharacterPrin
@export var speed = 10#defualt 35
@export var inputs_active=true
@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)
@onready var cameraPivot:Node3D=$CameraPivot
@onready var cameraSubPivot:Node3D=$CameraPivot/SpringArm3D/Node3D/CameraSubPivot
@onready var camera:Camera3D=$CameraPivot/SpringArm3D/Node3D/CameraSubPivot/Camera3D
@onready var cameraPivotSpringArm:SpringArm3D=$CameraPivot/SpringArm3D
@onready var characterPivot:Node3D=$Pivot
@onready var characterImportedSkeleton:Node3D=$Pivot/Node3D/personaje_glb/Armature/Skeleton3D
@onready var animationPlayer:AnimationPlayer=$Pivot/Node3D/personaje_glb/AnimationPlayer
#@onready var animationTree:AnimationTree=$AnimationTree
#@onready var animationTree2:AnimationTree=$AnimationTree2
@onready var areaArmRight:Area3D=$areas/area_arm_right
@onready var areaArmLeft:Area3D=$areas/area_arm_left
var actions_simulate_pressed=[]
var actions_simulate_released=[]
var actions_simulate_just_pressed=[]
var estado="normal"
var sub_estado="normal"
var sub_estado_2="normal"

var current_blend := Vector3.ZERO
var target_blend := Vector3.ZERO
var blend_speed := 8.0
@export var velocidad_gravity_inicial=50
var velocidad_count_gravity=velocidad_gravity_inicial
@export var velocidad_max_gravity=150#100
@export var aceleration_gravity=8.0#5
@export var jump_hability=true
@export var padding_left_canva_estado=0
@export var vida=100
@export var printConsole=true
##es la velocidad con la cual gira cuando cambia de direccion, a mayor, mas lento
@export var velocidad_giro_walking=10
var characterTarget:Node3D
var targering_character=false

var mode_camera=1
func _ready() -> void:
	prepararAnimData()
	var meshes=characterImportedSkeleton.get_children()
	for m:MeshInstance3D in meshes:
		var mat:StandardMaterial3D=m.get_active_material(0)
		mat=mat.duplicate()

		mat.diffuse_mode=BaseMaterial3D.DIFFUSE_TOON
		mat.disable_receive_shadows=true
		mat.metallic = 0.1
		mat.roughness = 0.0   # bordes definidos estilo cartoon
		mat.stencil_mode=BaseMaterial3D.STENCIL_MODE_OUTLINE
		mat.stencil_outline_thickness=0.1
# Aplicar al MeshInstance
		m.set_surface_override_material(0,mat)
	pass
func switchTargeringChar():
	targering_character=!targering_character
func switchModeCamera():
	if mode_camera==1:
		mode_camera=2
	else:
		mode_camera=1
func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	if self.is_action_just_pressed("l1"):
		switchModeCamera()
		switchTargeringChar()
	$CanvasLayer.offset.x=padding_left_canva_estado
	$CanvasLayer/Label.text=" estado: "+estado
	$CanvasLayer/Label.text+="\n"+" fps: "+str(Engine.get_frames_per_second())
	#$CanvasLayer/Label.text+="\n"+" sub_estado: "+str(sub_estado)
	$CanvasLayer/Label.text+="\n"+" is_on_floor: "+str(is_on_floor())
	#$CanvasLayer/Label.text+="\n"+" is_on_wall: "+str(is_on_wall())
	$CanvasLayer/Label.text+="\n"+" vida: "+str(vida)
	$CanvasLayer/Label.text+="\n"+" pivot-camera: "+get_pivot_look_relative_to_camera(camera)
	$CanvasLayer/Label.text+="\n"+" gravity: "+str(calcDirectionGravity(delta))
	$CanvasLayer/Label.text+="\n"+" arm_left: "+str($areas/area_arm_left.monitoring)
	$CanvasLayer/Label.text+="\n"+" arm_right: "+str($areas/area_arm_right.monitoring)
	$CanvasLayer/Label.text+="\n"+" leg_left: "+str($areas/area_leg_left.monitoring)
	$CanvasLayer/Label.text+="\n"+" leg_right: "+str($areas/area_leg_right.monitoring)
	if animationPlayer.is_playing():
		$CanvasLayer/Label.text+="\n"+" current_time_anim_player_original: "+str(animationPlayer.current_animation_position)
	if $AnimationPlayer.is_playing():
		$CanvasLayer/Label.text+="\n"+" current_time_anim_player_aux: "+str($AnimationPlayer.current_animation_position)
	#$CanvasLayer/ProgressBar.value=vida
	#if mostrarLabelDebug:
		#$CanvasLayer.visible=true
	#else:
		#$CanvasLayer.visible=false
	
	if estado!="normal":
		return
	direction=calcSimpleMoveWalking(delta)
	if estado=="normal" and direction == Vector3.ZERO:
		var anim=animationPlayer.get_animation("000_ground_anm")
		anim.loop_mode=Animation.LOOP_LINEAR
		var anim2=animationPlayer.get_animation("001_ground_tired_anm")
		anim2.loop_mode=Animation.LOOP_LINEAR
		#animationTree.active=false
		#animationPlayer.play("000_ground_anm",0.2)
		#var dir2=Vector3.ZERO
		#current_blend = current_blend.lerp(
		#dir2,
		#blend_speed*2 * delta
		#)
		#var anim_pos = animationTree.get("parameters/playback/position")
		#print(anim_pos)
		#animationTree.active=false
		animationPlayer.play("000_ground_anm",0.5)
		#animationTree.set("parameters/normal_piso/blend_position",Vector2(current_blend.x,current_blend.z))
		#animationTree.set("parameters/Blend2/blend_amount",1)
		#var anim_name = animationTree.get("parameters/tired/current_animation")
		#var blendspace = animationTree.get("parameters/tired")
		#var anim_actual = blendspace.get_current_node()  # obtiene la animación que se está reproduciendo
		#blendspace.travel(anim_actual)  # reinicia esa animación desde el principio
		#var node_current=str(animationTree2.get("parameters/playback").get_current_node())
		#print(node_current)
		#animationTree2.get("parameters/playback").travel("0")
		#animationTree.get("parameters/tired/animation_player").seek(0, true)		#if index_animation_idle==0:
			#animationPlayer.play("idle",0.5)
		#if index_animation_idle==1:
			#animationPlayer.play("idle2",0.5)
		#if index_animation_idle==2:
			#animationPlayer.play("idle3",0.5)
	if estado=="normal" and direction != Vector3.ZERO:
		#animationTree.active=true
		var animFront="003_move_far_loop_anm"
		var animBack="003_move_far_loop_anm"
		var animLeft="005_move_far_l_loop_anm"
		var animRight="007_move_far_r_loop_anm"
		#var anim=animationPlayer.get_animation("003_move_far_loop_anm")
		#anim.loop_mode=Animation.LOOP_LINEAR
		
		animationPlayer.get_animation(animFront).loop_mode=Animation.LOOP_LINEAR
		animationPlayer.get_animation(animBack).loop_mode=Animation.LOOP_LINEAR
		animationPlayer.get_animation(animLeft).loop_mode=Animation.LOOP_LINEAR
		animationPlayer.get_animation(animRight).loop_mode=Animation.LOOP_LINEAR
		var dir2=calcSimpleMoveTeclas(delta)
		if dir2.x==1:
			animationPlayer.play(animRight,1)
		else:if dir2.x==-1:
			animationPlayer.play(animLeft,1)
		if dir2.z==1:
			animationPlayer.play(animFront,1)
		else:if dir2.z==-1:
			animationPlayer.play(animBack,1)
		#current_blend = current_blend.lerp(
		#dir2,
		#blend_speed * delta
		#)
		#animationTree.set("parameters/normal_piso/blend_position",Vector2(current_blend.x,current_blend.z))
		#
		
		
		#var node_current=str(animationTree2.get("parameters/playback").get_current_node())
		#print(node_current)
		#print(str(animationTree2.get("parameters/playback").get_current_node()))
		#if animationTree2.get("parameters/playback").get_current_node() != "0":
			#sm.travel(nombre)
		#if node_current!="1":
			#animationTree2.get("parameters/playback").travel("0")
		#animationTree.set("parameters/Blend2/blend_amount",0)
		#animationTree.set("parameters/conditions/normal_piso", true)
		#animationTree.get("parameters/playback").travel("normal_piso")
		
		#animationPlayer.play("003_move_far_loop_anm",0.2)
	# Moving the Character
	velocity = direction
	velocity+=calcDirectionGravity(delta)
	move_and_slide()
	pass

func calcSimpleMoveTeclas(delta:float):
	var direction=Vector3.ZERO
	if is_action_pressed("right"):
		direction.x += 1
	else:if is_action_pressed("left"):
		direction.x -= 1
	if is_action_pressed("down"):
		direction.z += 1
	else:if is_action_pressed("up"):
		direction.z -= 1
	return direction
	pass
func auomaticSimpleWalkingPivot(delta:float,speed_extra=1):
	var direction=Vector3.ZERO
	direction.z -= 1
	direction=direction.rotated(Vector3.UP, characterPivot.global_rotation.y)
	direction = direction.normalized()
	if direction != Vector3.ZERO:

		#Con esa direccion voy rotando poco a poco el pivot ahi
		var original_rotation=$Pivot.rotation
		$Pivot.look_at(global_position + direction, Vector3.UP)
		var end_rotation=$Pivot.rotation
		$Pivot.rotation=original_rotation
		moveAngleTransition($Pivot,end_rotation,velocidad_giro_walking)
		#ME creo una velocidad siempre en direccion del pivot
		#ahora la direccion depende del pivot
		var directionPivot=Vector3(0,0,-1)
		directionPivot=directionPivot.rotated(Vector3.UP, $Pivot.global_rotation.y)
		direction=directionPivot
		#$Pivot.rotation.y+=deg_to_rad(girar*2)
		#direction=Vector3(0,0,-1)
		direction.x = direction.x * speed*speed_extra
		direction.z = direction.z * speed*speed_extra
	
	return direction
	pass
func calcSimpleMoveWalking(delta:float,speed_extra=1,replaceVelocidadGiro=null)-> Vector3:
	var direction=Vector3.ZERO
	

	if is_action_pressed("right"):
		direction.x += 1
	else:if is_action_pressed("left"):
		direction.x -= 1
	if is_action_pressed("down"):
		direction.z += 1
	else:if is_action_pressed("up"):
		direction.z -= 1
	if direction != Vector3.ZERO:
		#Primero roto la direccion hacia donde la camara
		direction=direction.rotated(Vector3.UP, cameraPivot.global_rotation.y)
		direction = direction.normalized()

		#nueva forma
		#var rot_actual = $Pivot.global_transform.basis
		#var rot_deseada = Basis().looking_at(direction, Vector3.UP)
		#$Pivot.global_transform.basis = rot_actual.slerp(rot_deseada, delta * 10)
		#Con esa direccion voy rotando poco a poco el pivot ahi
		#-------
		var original_rotation=$Pivot.rotation
		$Pivot.look_at(global_position + direction, Vector3.UP)
		var end_rotation=$Pivot.rotation
		$Pivot.rotation=original_rotation
		if replaceVelocidadGiro!=null:
			moveAngleTransition($Pivot,end_rotation,replaceVelocidadGiro)
		else:
			moveAngleTransition($Pivot,end_rotation,velocidad_giro_walking)		#ME creo una velocidad siempre en direccion del pivot
		#-------
		#ahora la direccion depende del pivot
		var directionPivot=Vector3(0,0,-1)
		directionPivot=directionPivot.rotated(Vector3.UP, $Pivot.global_rotation.y)
		direction=directionPivot
		#$Pivot.rotation.y+=deg_to_rad(girar*2)
		#direction=Vector3(0,0,-1)
		direction.x = direction.x * speed*speed_extra
		direction.z = direction.z * speed*speed_extra
	
	return direction
	pass
	
func is_action_pressed(action)->bool:
	#print(str(get_path())+ ":verificando input frame: "+str(count_frame_phy)+" actionVerificar: "+str(action)+" simulate array: "+str(actions_simulate_pressed))
	if actions_simulate_pressed.has(action):
		return true
	if Input.is_action_pressed(action) and inputs_active:
		return true
	return false
	pass
func is_action_just_released(action)->bool:
	if actions_simulate_released.has(action):
		return true
	if Input.is_action_just_released(action)  and inputs_active:
		return true
	return false
	pass
func is_action_just_pressed(action)->bool:
	if actions_simulate_pressed.has(action):
		return true
	if Input.is_action_just_pressed(action)  and inputs_active:
		return true
	return false
	pass
func moveAngleTransition(node:Node3D,rotation_end:Vector3,freno=8.0):
	var vector_angle_camera_mode=rotation_end
	var vector_move_angle=(vector_angle_camera_mode-node.rotation)
	#print("vector angle original="+str(vector_angle_camera_mode))
	#print("vector angle fin="+str(vector_angle_camera_mode))
	## con este if, hago que siempre gire por el lado mas cercano
	if abs(vector_move_angle.y)>deg_to_rad(180):
		#print("debe moverse mayor a 180")
		var angle_move_mejor=deg_to_rad(360)-abs(vector_move_angle.y)
		##ahora solo debo decidir si sera positivo o negativo
		if vector_move_angle.y>0:
			angle_move_mejor*=-1
		vector_move_angle.y=angle_move_mejor
	vector_move_angle=vector_move_angle/freno
	node.rotation+=vector_move_angle
func _unhandled_input(event: InputEvent) -> void:
	#event puede ser tipo inputeventmouse motion, pero tambien no puede ser por lo cual buttonmask no saldra
	#if Input.is_action_just_pressed("l1") and inputs_active:
		#global_position=Vector3(0,3.075,0)
		#Input.action_press("triangle")
	if Input.is_action_just_pressed("scroll_up")  and inputs_active:
		print("Action: Scroll Up detected (Zoom In)")
		#cameraPivotSpringArm.position.z+=-1
		cameraPivotSpringArm.spring_length-=1
	if Input.is_action_just_pressed("scroll_down")  and inputs_active:
		print("Action: Scroll Up detected (Zoom In)")
		#cameraPivotSpringArm.position.z+=1
		cameraPivotSpringArm.spring_length+=1
		# Your camera zoom in code
	if event is InputEventMouseMotion and (event.button_mask==1) and inputs_active:
		#print("butonmask: ",event.button_mask)
		cameraPivot.rotation.x -= event.relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		cameraPivot.rotation.x = clampf(cameraPivot.rotation.x, -tilt_limit, tilt_limit)
		cameraPivot.rotation.y += -event.relative.x * mouse_sensitivity
func calcDirectionGravity(delta: float)-> Vector3:
	#print("calculando gravedad")
	var direction=Vector3.ZERO
	velocidad_count_gravity=(velocidad_count_gravity+aceleration_gravity)
	#print("velocidad_count_gravity="+str(velocidad_count_gravity))
	if velocidad_count_gravity>velocidad_max_gravity:
		#print()
		velocidad_count_gravity=velocidad_max_gravity
	#if is_on_floor() and velocidad_count_gravity>=velocidad_max_gravity:
	if is_on_floor():
		velocidad_count_gravity=velocidad_gravity_inicial
	#print(direction)
	direction.y=direction.y-velocidad_count_gravity
	#print(direction)
	return direction
func reiniciarGravedad():
	velocidad_count_gravity=velocidad_gravity_inicial
func getPositionGlobalFromBone(bone_name="colision_arma_right"):
	var skeleton3d:Skeleton3D=characterImportedSkeleton
	var bone_idx=skeleton3d.find_bone(bone_name)
	var local_bone_transform = skeleton3d.get_bone_global_pose(bone_idx)
	var global_bone_transform:Transform3D = skeleton3d.global_transform * local_bone_transform
	#$CollisionShape3D.global_position=global_bone_transform.origin
	#$CollisionShape3D.global_rotation=global_bone_transform.basis.get_rotation_quaternion().get_euler()
	return global_bone_transform.origin
	
	pass
func getPositionGlobalFromBone2(bone_name,skeleton):
	var skeleton3d:Skeleton3D=skeleton
	var bone_idx=skeleton3d.find_bone(bone_name)
	var local_bone_transform = skeleton3d.get_bone_global_pose(bone_idx)
	var global_bone_transform:Transform3D = skeleton3d.global_transform * local_bone_transform
	#$CollisionShape3D.global_position=global_bone_transform.origin
	#$CollisionShape3D.global_rotation=global_bone_transform.basis.get_rotation_quaternion().get_euler()
	return global_bone_transform.origin
	
	pass
func anularPositionAnimationBone(bone_name="colision_arma_right"):
	var skeleton3d:Skeleton3D=characterImportedSkeleton
	var bone_idx=skeleton3d.find_bone(bone_name)
	var local_bone_transform = skeleton3d.get_bone_global_pose(bone_idx)
	var rest_global = skeleton3d.get_bone_global_rest(bone_idx)
	skeleton3d.set_bone_global_pose_override(
			bone_idx,
			rest_global,
			1,  # peso total
			true
		)
	pass
func getRotationGlobalFromBone(bone_name="colision_arma_right"):
	var skeleton3d:Skeleton3D=characterImportedSkeleton
	var bone_idx=skeleton3d.find_bone(bone_name)
	var local_bone_transform = skeleton3d.get_bone_global_pose(bone_idx)
	var global_bone_transform:Transform3D = skeleton3d.global_transform * local_bone_transform
	return global_bone_transform.basis.get_rotation_quaternion().get_euler()
	pass
func callSoundGolpeViento():
	$temp_audios/golpe_viento.play()
func callSoundGolpeVueloRapido():
	$temp_audios/vuelo_rapido.play()
func callSoundMovimientoCerca():
	$temp_audios/cross_up.play()
func callSoundSaltoSalida():
	$temp_audios/salto_salida.play()
func callSoundSaltoEntrada():
	$temp_audios/salto_entrada.play()
func callSoundVueloUp():
	$temp_audios/vuelo_up.play()
func callTemblor2():
	$AnimationPlayer3.play("temblor")
func callTemblor1():
	$AnimationPlayer3.play("temblor1")
func callSimpleDamage(multiplyDamage:float,iniciadorOponente:Node3D=null):
	#$nodo_auxiliar.emitirParticulaGolpeSimple()
	
	var isfront=true
	if isfront!=null:
		isfront=is_in_front(self,iniciadorOponente)
	vida-=1*multiplyDamage
	$estados/simple_damage.iniciar_damage2(multiplyDamage,isfront)
	$temp_audios/golpe_simple.play()
func callDamageFuerteChargue(multiplyDamage:float,iniciadorOponente:Node3D=null):
	#$nodo_auxiliar.emitirParticulaGolpeSimple()
	
	var isfront=true
	if isfront!=null:
		isfront=is_in_front(self,iniciadorOponente)
	vida-=1*multiplyDamage
	$estados/charge_fuerte_damage.iniciar_damage(multiplyDamage,iniciadorOponente,isfront)
	$temp_audios/golpe_fuerte.play()
func callDamageAturdir(multiplyDamage:float,iniciadorOponente:Node3D=null):
	#$nodo_auxiliar.emitirParticulaGolpeSimple()
	
	var isfront=true
	if isfront!=null:
		isfront=is_in_front(self,iniciadorOponente)
	vida-=1*multiplyDamage
	$estados/aturdir_damage.iniciar_damage(multiplyDamage,iniciadorOponente,isfront)
	$temp_audios/golpe_medio.play()
func callDamageFuerteRolling(multiplyDamage:float,iniciadorOponente:Node3D=null):
	#$nodo_auxiliar.emitirParticulaGolpeSimple()
	
	var isfront=true
	if isfront!=null:
		isfront=is_in_front(self,iniciadorOponente)
	vida-=1*multiplyDamage
	$estados/rolling_fuerte_damage.iniciar_damage(multiplyDamage,iniciadorOponente,isfront)
	$temp_audios/golpe_medio.play()
func is_in_front(of_body: Node3D, target: Node3D) -> bool:
	# Forward del personaje (Godot usa -Z como forward)
	var forward: Vector3 = -of_body.global_transform.basis.z.normalized()

	# Dirección desde of_body hacia target
	var dir_to_target: Vector3 = (target.global_position - of_body.global_position).normalized()

	# Producto punto
	var dot: float = forward.dot(dir_to_target)

	return dot > 0
func get_pivot_look_relative_to_camera(
	_camera: Camera3D
):
	# Forward del pivot y de la cámara
	var pivot_forward: Vector3 = -characterPivot.global_transform.basis.z
	var cam_forward: Vector3 = -_camera.global_transform.basis.z
	var cam_right: Vector3 = _camera.global_transform.basis.x

	# Ignorar altura (opcional pero recomendado)
	pivot_forward.y = 0
	cam_forward.y = 0
	cam_right.y = 0

	pivot_forward = pivot_forward.normalized()
	cam_forward = cam_forward.normalized()
	cam_right = cam_right.normalized()

	# Comparar contra ejes de cámara
	var front_dot = cam_forward.dot(pivot_forward)
	var right_dot = cam_right.dot(pivot_forward)

	if abs(front_dot) > abs(right_dot):
		return "FRONT" if front_dot > 0 else "BACK"
	else:
		return "RIGHT" if right_dot > 0 else "LEFT"
#func get_pivot_look_vector3_relative_to_camera(
	#pivot: Node3D,
	#camera: Camera3D
#) -> Vector3:
	## Forward del pivote
	#var pivot_forward: Vector3 = -pivot.global_transform.basis.z.normalized()
#
	## Ejes de la cámara
	#var cam_basis = camera.global_transform.basis
	#var cam_right: Vector3 = cam_basis.x.normalized()
	#var cam_up: Vector3 = cam_basis.y.normalized()
	#var cam_forward: Vector3 = -cam_basis.z.normalized()
#
	## Proyección del forward del pivote en los ejes de la cámara
	#var x = cam_right.dot(pivot_forward)    # derecha / izquierda
	#var y = cam_up.dot(pivot_forward)       # arriba / abajo
	#var z = cam_forward.dot(pivot_forward)  # frente / atrás
#
	#return Vector3(x, y, z)
func reiniciarBlendAnimationPlayer():
	self.animationPlayer.play(self.animationPlayer.current_animation,0.0)
	pass
func getLines(file):
	var lineas:PackedStringArray
	if file:
		var text = file.get_as_text()
		lineas = text.split("\n", false)
	# Limpia posibles '\r' (Windows)
		for i in range(lineas.size()):
			lineas[i] = lineas[i].strip_edges()
	return lineas
	pass
func isCharacterTargetInAreaAndTargering():
	return $area_targering.isTargetisInArea()
func prepararAnimData():
	var library_original=animationPlayer.get_animation_library("")
	var library_code: AnimationLibrary
	library_code = $AnimationPlayer.get_animation_library("")
	$AnimationPlayer.speed_scale=animationPlayer.speed_scale
	var anims=[]
	for anim_name in library_original.get_animation_list():
		var concat="res://DRAGONCHARACTERS/GOKUFINBASE/glb/animaciones/"
		var filea= FileAccess.open(concat+anim_name+".txt", FileAccess.READ)
		if filea:
			var anim = Animation.new()
			anim.length = animationPlayer.get_animation(anim_name).length
			anim.loop_mode = Animation.LOOP_NONE
			print("animacion aux duration: "+str(anim.length))
			var lineas=getLines(filea)
			var key_frames=0
			var track_left_index := anim.add_track(Animation.TYPE_VALUE)
			anim.track_set_interpolation_type(track_left_index, Animation.INTERPOLATION_NEAREST)
			anim.track_set_path(track_left_index, "areas/area_arm_left:monitoring")
			
			var track_right_index := anim.add_track(Animation.TYPE_VALUE)
			anim.track_set_path(track_right_index, "areas/area_arm_right:monitoring")
			#anim.track_set_interpolation_type(track_right_index, Animation.INTERPOLATION_NEAREST)
			#anim.track_set_interpolation_type(track_left_index, Animation.INTERPOLATION_NEAREST)
			anim.value_track_set_update_mode(track_left_index,Animation.UPDATE_DISCRETE)
			anim.value_track_set_update_mode(track_right_index,Animation.UPDATE_DISCRETE)
			
			var track_leg_right_index := anim.add_track(Animation.TYPE_VALUE)
			anim.track_set_interpolation_type(track_leg_right_index, Animation.INTERPOLATION_NEAREST)
			anim.track_set_path(track_leg_right_index, "areas/area_leg_right:monitoring")
			anim.value_track_set_update_mode(track_leg_right_index,Animation.UPDATE_DISCRETE)
			
			var track_leg_left_index := anim.add_track(Animation.TYPE_VALUE)
			anim.track_set_interpolation_type(track_leg_left_index, Animation.INTERPOLATION_NEAREST)
			anim.track_set_path(track_leg_left_index, "areas/area_leg_left:monitoring")
			anim.value_track_set_update_mode(track_leg_left_index,Animation.UPDATE_DISCRETE)
			#anim.track_set_interpolation_type(track_left_index, Animation.UPDATE_DISCRETE)
			#anim.track_set_update_mode(track_left_index, Animation.UPDATE_DISCRETE)
			for lin in lineas:
				if lin.split("\t")[1]=="activar_left_arm_colision":
					var time=float(lin.split("\t")[0])
					var value=lin.split("\t")[2]
					#var track := anim.add_track(Animation.TYPE_VALUE)
					#anim.track_set_path(track, "areas/area_arm_left:monitoring")
					if value=="true":
						anim.track_set_interpolation_type(track_left_index, Animation.INTERPOLATION_NEAREST)
						anim.track_insert_key(track_left_index, time, true)
					else:
						anim.track_set_interpolation_type(track_left_index, Animation.INTERPOLATION_NEAREST)
						anim.track_insert_key(track_left_index, time, false)
					key_frames+=1
				if lin.split("\t")[1]=="activar_right_arm_colision":
					var time=float(lin.split("\t")[0])
					var value=lin.split("\t")[2]
					#var track := anim.add_track(Animation.TYPE_VALUE)
					#anim.track_set_path(track, "areas/area_arm_right:monitoring")
					if value=="true":
						anim.track_insert_key(track_right_index, time, true)
					else:
						anim.track_insert_key(track_right_index, time, false)
					key_frames+=1
				if lin.split("\t")[1]=="activar_right_leg_colision":
					var time=float(lin.split("\t")[0])
					var value=lin.split("\t")[2]
					#var track := anim.add_track(Animation.TYPE_VALUE)
					#anim.track_set_path(track, "areas/area_arm_right:monitoring")
					if value=="true":
						anim.track_insert_key(track_leg_right_index, time, true)
					else:
						anim.track_insert_key(track_leg_right_index, time, false)
					key_frames+=1
				if lin.split("\t")[1]=="activar_left_leg_colision":
					var time=float(lin.split("\t")[0])
					var value=lin.split("\t")[2]
					#var track := anim.add_track(Animation.TYPE_VALUE)
					#anim.track_set_path(track, "areas/area_arm_right:monitoring")
					if value=="true":
						anim.track_insert_key(track_leg_left_index, time, true)
					else:
						anim.track_insert_key(track_leg_left_index, time, false)
					key_frames+=1
			print("animacion agregada"+anim_name+"frames agregados: "+str(key_frames))
			print(anim.length)
			#limpio los tracks sin keys
			if anim.track_get_key_count(track_left_index)==0:
				anim.remove_track(track_left_index)
			if anim.track_get_key_count(track_right_index)==0:
				anim.remove_track(track_right_index)
				pass
			if anim.track_get_key_count(track_leg_left_index)==0:
				anim.remove_track(track_leg_left_index)
				pass
			if anim.track_get_key_count(track_leg_right_index)==0:
				anim.remove_track(track_leg_right_index)
				pass
			library_code.add_animation(anim_name,anim)		
			#var a=$AnimationPlayer.get_animation(anim_name)	
			#a.track_set_update_mode(track_left_index, Animation.UPDATE_DISCRETE)
			pass
		ResourceSaver.save(library_code, "res://librarytest.tres")
		#print(anim_name)
	#var path = "res://DRAGONCHARACTERS/GOKUFINBASE/glb/animaciones/055_strike_01_anm.txt"
	#var path2 = "res://DRAGONCHARACTERS/GOKUFINBASE/glb/animaciones/056_strike_02_anm.txt"
	#var file := FileAccess.open(path, FileAccess.READ)
	#var lineas:PackedStringArray
	#if file:
		#var text := file.get_as_text()
		#lineas = text.split("\n", false)
#
	## Limpia posibles '\r' (Windows)
		#for i in range(lineas.size()):
			#lineas[i] = lineas[i].strip_edges()
		#file.close()
	#var anim = Animation.new()
	#anim.length = 1.0
	#anim.loop_mode = Animation.LOOP_NONE
	#var track := anim.add_track(Animation.TYPE_VALUE)
	#anim.track_set_path(track, "areas/area_arm_right:monitoring")
	#anim.track_insert_key(track, 0.2, true)	
	#var library: AnimationLibrary
	#library = $AnimationPlayer.get_animation_library("")
#
	## Añadir animación a la librería
	#library.add_animation("055_strike_01_anm", anim)
	##animationPlayer.add_animation("activar_area", anim)
	##animationPlayer.play("activar_area")
	#print(lineas)
	pass
func desactivarAreasColisionGolpe():
	$areas/area_arm_left.monitoring=false
	$areas/area_arm_right.monitoring=false
	$areas/area_leg_left.monitoring=false
	$areas/area_leg_right.monitoring=false
func conectarSeñalesAreas(callback: Callable):
	$areas/area_arm_left.body_entered.connect(callback)
	$areas/area_arm_right.body_entered.connect(callback)
	$areas/area_leg_left.body_entered.connect(callback)
	$areas/area_leg_right.body_entered.connect(callback)
	pass
func desconectarSeñalesAreas(callback: Callable):
	if $areas/area_arm_left.body_entered.is_connected(callback):
		$areas/area_arm_left.body_entered.disconnect(callback)
		pass
	if $areas/area_arm_right.body_entered.is_connected(callback):
		$areas/area_arm_right.body_entered.disconnect(callback)
	if $areas/area_leg_left.body_entered.is_connected(callback):
		$areas/area_leg_left.body_entered.disconnect(callback)
	if $areas/area_leg_right.body_entered.is_connected(callback):
		$areas/area_leg_right.body_entered.disconnect(callback)
