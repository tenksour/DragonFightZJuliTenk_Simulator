extends Area3D


@onready var character:CharacterPrin=self.get_parent()
@export var velocity_rotation_target=5
var moverInstantaneo=false
var list_objects=[]
var time=0
# Called when the node enters the scene tree for the first time.
func isTargetisInArea():
	for node:Node3D in list_objects:
		if node==character.characterTarget and character.targering_character:
			return true
	return false
func isNodeGroupExist(group):
	for node:Node3D in list_objects:
		if node.is_in_group(group):
			return node
	return null
func getNodeCharBodyExist():
	for node:Node3D in list_objects:
		if node is CharacterBody3D:
			return node
	return null
	pass
func _ready() -> void:
	self.body_entered.connect(onBodyEntered)
	self.body_exited.connect(onBodyExited)
	pass # Replace with function body.
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
func _physics_process(delta: float) -> void:
	#$"../CanvasLayer/Label2".text="AreaTargering:"
	#if targering_character and characterTarget:
		#cameraSubPivot.position=Vector3(20,0,0)
		#cameraSubPivot.rotation=Vector3(0,deg_to_rad(10),0)
	#if !targering_character:
		#cameraSubPivot.position=Vector3(0,0,0)
		#cameraSubPivot.rotation=Vector3(0,deg_to_rad(0),0)
	#if Input.is_action_just_pressed("l2"):
		#character.switchTargeringChar()
	#for node:Node3D in list_objects:
		#$"../CanvasLayer/Label2".text+="\n"+str(node.get_path())
		##pass
	if !character.targering_character:
		var vector_position_camera_mode=Vector3(0,0,0)
		var vector_angle_camera_mode=Vector3(0,deg_to_rad(0),0)
		movePosAngleTransition(character.cameraSubPivot,vector_position_camera_mode,vector_angle_camera_mode)
	if character.characterTarget and character.targering_character :
		var vector_position_camera_mode=Vector3(10,0,0)
		var vector_angle_camera_mode=Vector3(0,deg_to_rad(20),0)
		if character.mode_camera==2:
			vector_position_camera_mode=Vector3(-10,0,0)
			vector_angle_camera_mode=Vector3(0,deg_to_rad(-20),0)
		movePosAngleTransition(character.cameraSubPivot,vector_position_camera_mode,vector_angle_camera_mode)
		
		#$Pivot.look_at(global_position + direction, Vector3.UP)
		var vector_direction=Vector3(character.characterTarget.global_position)
		vector_direction.y+=8
		#vector_direction.x=0
		#vector_direction.y=0
		#vector_direction.z=0
		#vector_direction.y=0
		#vector_direction.z=0
		var rotation_aux=Vector3(character.cameraPivot.rotation)
		#print("rotation 1 original: "+str(rotation_aux))
		character.cameraPivot.look_at(vector_direction,Vector3.UP)
		var rotation_end=Vector3(character.cameraPivot.rotation)
		#print("rotation 2 end: "+str(rotation_end))
		if moverInstantaneo:
			time+=delta
		if !moverInstantaneo:
			character.cameraPivot.rotation=rotation_aux
			moveAngleTransition(character.cameraPivot,rotation_end,velocity_rotation_target)
		if moverInstantaneo and time>3:
			moverInstantaneo=false
		#print("rotation 3 pos_end: "+str(character.cameraPivot.rotation))
		#character.cameraPivot.rotation=rotation_aux
		if character.cameraPivot.global_rotation.x<deg_to_rad(-38):
			character.cameraPivot.global_rotation.x=deg_to_rad(-38)
		if character.cameraPivot.global_rotation.x>deg_to_rad(-10):
			character.cameraPivot.global_rotation.x=deg_to_rad(-10)
		#character.cameraPivot.global_rotation.y-=deg_to_rad(-35)
		# You can also check if the child is a spe
	pass
func onBodyEntered(node:Node3D):
	if character.get_path()!=node.get_path():
		if node is CharacterPrin:
			character.characterTarget=node
			character.targering_character=true
	print("bodyentro: "+str(node.get_path()))
	if !list_objects.has(node) and character.get_path()!=node.get_path():
		list_objects.append(node)
		return
	pass	
func onBodyExited(node:Node3D):
	print("bodysalio: "+str(node.get_path()))
	#if character.characterTarget!=null and character.characterTarget.get_path()==node.get_path():
	#	character.characterTarget=null
	if list_objects.has(node):
		list_objects.erase(node)
		return
	pass	
func movePosAngleTransition(node:Node3D,position_end:Vector3,rotation_end:Vector3):
		#funcion que en base a una posicion y rotation, hace que el nodo llegue a eso
		#gradualmente
		movePosTransition(node,position_end)
		moveAngleTransition(node,rotation_end)
func movePosTransition(node:Node3D,position_end:Vector3):
	var vector_position_camera_mode=position_end
	var vector_move=(vector_position_camera_mode-node.position)
	vector_move=vector_move/5
	node.position+=vector_move
	pass
func moveAngleTransition(node:Node3D,rotation_end:Vector3,velocity_streng=5):
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
	
	#if rad_to_deg(vector_move_angle.x)>180 or rad_to_deg(vector_move_angle.x)<180:
		#if rad_to_deg(vector_move_angle.x)>180:
			#vector_move_angle.x=deg_to_rad(360)-abs(vector_move_angle.x)
			#vector_move_angle.x*=-1
		#else: if rad_to_deg(vector_move_angle.x)<180:
			#vector_move_angle.x=deg_to_rad(-360)-abs(vector_move_angle.x)
			#vector_move_angle.x*=+1
		#
	vector_move_angle=vector_move_angle/velocity_streng
	node.rotation+=vector_move_angle
	pass
#func moveAngleTransition(node:Node3D,rotation_end:Vector3):
		##funcion que en base a una posicion y rotation, hace que el nodo llegue a eso
		##gradualmente
		#var vector_angle_camera_mode=rotation_end
		#var vector_move_angle=(node.rotation-vector_angle_camera_mode)
		#vector_move_angle=vector_move_angle.abs()
		##vector_move_angle.x=abs(vector_move_angle.x)
		##vector_move_angle.y=abs(vector_move_angle.y)
		##vector_move_angle.z=abs(vector_move_angle.z)
		#vector_move_angle=vector_move_angle/50
		#if node.rotation.x<vector_move_angle.x:
			#node.rotation.x+=vector_move_angle.x
		#if node.rotation.x>vector_move_angle.x:
			#node.rotation.x-=vector_move_angle.x
		#if node.rotation.y<vector_move_angle.y:
			#node.rotation.y+=vector_move_angle.y
		#if node.rotation.y>vector_move_angle.y:
			#node.rotation.y-=vector_move_angle.y
		#if node.rotation.z<vector_move_angle.z:
			#node.rotation.z+=vector_move_angle.z
		#if node.rotation.z>vector_move_angle.z:
			#node.rotation.z-=vector_move_angle.z
		##if node.rotation<vector_angle_camera_mode:
			##node.rotation+=vector_move_angle
		##else:
			##node.rotation-=vector_move_angle
	#
