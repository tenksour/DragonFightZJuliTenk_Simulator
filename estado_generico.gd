extends Node3D
class_name CharacterEstadoGeneric
@onready var character:CharacterPrin=self.get_parent().get_parent()
#@export var animationName="damage_vueltereta"
@export var estadoName="generic_estado"
@export var estadoNameDetenerReturn="normal"
@export var estadoNameDetenerReturnNotFloor="idle_vuelo"
@export var estadosIn = ["normal"]
var activo=false
var iniciado=false
##indica si podra iniciar incluso cuando ya este activo, es decir reiniciarse al llamar al metodo iniciar
@export var reiniciable=false
var direction_velocity_relative=Vector3()
var direction_velocity_global=Vector3()
var timeCount=0
var time_reset_on_detener=0
##Tipo estado 0 es estado principal, 1 sub_estado y 2 estado_automatico
@export var tipo_estado=0

func desconectarSeñalAnimationPlayer(callable: Callable):
	if character.animationPlayer.animation_finished.is_connected(callable):
		character.animationPlayer.animation_finished.disconnect(callable)
func conectarSeñalAnimationPlayer(callable: Callable):
	character.animationPlayer.animation_finished.connect(callable)
	pass
func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	if character.estado!=estadoName and activo and tipo_estado==0:
		onlyDetener()
	if character.sub_estado!=estadoName and activo and tipo_estado==1:
		onlyDetener()
	if character.sub_estado_2!=estadoName and activo and tipo_estado==2:
		onlyDetener()
	if activo:
		timeCount+=1
	time_reset_on_detener+=1
func iniciar():
	#print("se iniciara: "+estadoName)
	if iniciado and !reiniciable:
		#print("no se inicio por que ya esta iniciado in: "+estadoName)
		return
	if !estadosIn.has(character.estado):
		#print("no se inicio por que no hay estado in: "+estadoName)
		return
	activo=true
	iniciado=true
	if tipo_estado==0:
		character.estado=estadoName
	if tipo_estado==1:
		character.sub_estado=estadoName
	if tipo_estado==2:
		character.sub_estado_2=estadoName
	timeCount=0
	postIniciar()
	pass
func postIniciar():
	pass
func onlyDetener():
	activo=false
	iniciado=false
	time_reset_on_detener=0
	pass
func detener():
	var estado_return=estadoNameDetenerReturn
	if !character.is_on_floor():
		estado_return=estadoNameDetenerReturnNotFloor
	onlyDetener()
	if tipo_estado==0:
		character.estado=estado_return
	if tipo_estado==1:
		character.sub_estado=estado_return
	if tipo_estado==2:
		character.sub_estado_2=estado_return
	pass
