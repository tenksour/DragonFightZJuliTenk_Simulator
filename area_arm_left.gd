extends Area3D
class_name  AreaBasic
@onready var character:CharacterPrin=self.get_parent().get_parent()
# Called when the node enters the scene tree for the first time.
var list_objects=[]#aqui se guardaran todos los objetos tipo character
var list_objects_objetos=[]#aqui los tipo objetos
@export var pegar_hueso=false
@export var nombre_hueso="034_ELBOW_L"
func getNodeFromGroupExist(group):
	for node:Node3D in list_objects:
		if node.is_in_group(group):
			return node
	return null
func _ready() -> void:

	self.body_entered.connect(onBodyEntered)
	self.body_exited.connect(onBodyExited)
	#material_colision_debug=$MeshInstance3D.get_active_material(0)
	#$MeshInstance3D.set_surface_override_material(0,material_colision_debug)
	#material_colision_debug.albedo_color=color_active
	#material_colision_debug.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	pass # Replace with function body.

func clonarMaterial():
		pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _physics_process(delta: float) -> void:
	if pegar_hueso:
		$CollisionShape3D.global_position=character.getPositionGlobalFromBone(nombre_hueso)
		$CollisionShape3D.global_rotation=character.getRotationGlobalFromBone(nombre_hueso)
	pass
func onBodyEntered(node:Node3D):
	if character.get_path()==node.get_path():
		return
		#if node is CharacterPrin:
			#character.characterTarget=node
			#character.targering_character=true
	if character.printConsole:
		print("area:"+str(self.name)+" bodyentro: "+str(node.get_path()))
	if !list_objects.has(node):
		list_objects.append(node)
		return
	pass	
func onBodyExited(node:Node3D):
	if character.printConsole:
		print("area:"+str(self.name)+" bodysalio: "+str(node.get_path()))
	#if character.characterTarget!=null and character.characterTarget.get_path()==node.get_path():
	#	character.characterTarget=null
	if list_objects.has(node):
		list_objects.erase(node)
		return
	pass		
