extends Node3D
class_name estado_caer
@onready var character:CharacterPrin=self.get_parent().get_parent()
@export var animationName="033_jump_loop_anm"
@export var animationNameSecond="033_jump_loop_anm"
@export var animationNameAterrizaje="034_jump_out_anm"
@export var estadoName="caer"
var activo=false
var iniciado=false
var animAterrizar_iniciado=false
var animAterrizar_finished=false
var timeCayendo=0
## Indica el tiempo que necesita transcurrir para la animacion secundaria.
@export var timeCayendoSecondAnim=40
## Indica el tiempo que necesita transcurrir para ejecutarse la animacion de aterrizaje, si no supera este tiempo desde iniciado, no se ejecuta.
@export var timeStartAterrizajeAnim=80
##Indica si este estado se iniciara automaticamente al no estar en el suelo, anulando otros estados, si se coloca true, iniciara cuando no estemos en el suelo, y si esta en false, podremos iniciarlo manualmente desde otro estado
@export var iniciar_por_fisica=true
##indica si podra moverse walking mientras cae
@export var active_walking_move=true
@export var estadosIn = ["normal","correr"]
@export var estadoReturn="normal"
var direction_caida=Vector3()
func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	#todo estado se debe detener automaticamente si el estado ya cambio de nombre
	#tambien habra estados secundarios que afectaran velocidad o aura
	if character.estado!=estadoName and activo:
		print("Se dentendra "+estadoName+" por que el estado cambio a: "+character.estado)
		onlyDetener()
	#if Input.is_action_just_pressed("circle"):
	#	iniciar()
	if iniciar_por_fisica and !character.is_on_floor() and estadosIn.has(character.estado):
		print("Iniciara estado: "+estadoName+" por fisicia, por que no esta en el suelo")
		iniciar()
	if character.is_on_floor() and activo:
		print("Se dentra estado: "+estadoName+" por que llego al suelo")
		if timeCayendo>=timeStartAterrizajeAnim:
			aterrizar()
		else:
			detener()
		#detener()
	if activo:
		timeCayendo+=1
		var animName=animationName
		if timeCayendo>timeCayendoSecondAnim:
			animName=animationNameSecond
		if !animAterrizar_iniciado:
			character.animationPlayer.play(animName,0.4)
		character.velocity=character.calcDirectionGravity(delta)
		#si aterrizo entonces cancelo el movimiento normal caminata que puede moverse
		#if !animAterrizar_iniciado:
		#	character.velocity+=character.calcSimpleMoveWalking(delta)
		if active_walking_move:
			character.velocity+=character.calcSimpleMoveWalking(delta)
		##si la direction de caida no es igual a cero, entonces el personaje se movera en esa direccion de espaldas, moviendo su pivote
		if direction_caida!=Vector3.ZERO:
			character.velocity+=character.moveAndRotateEspalda(direction_caida)
		#character.velocity+=Vector3(30,0,0)
		character.move_and_slide()

	pass

func onFinishedAterrizaje(animName):
	detener()
	pass
func aterrizar():
	if animAterrizar_iniciado:
		return
	#character.emitirPolvoPiso()
	#character.vida-=1
	print("aterrizar iniciado")
	#character.sub_estado="normal"
	character.animationPlayer.play(animationNameAterrizaje,0.2)
	#character.animationPlayer_basic.play("camera_temblor")
	character.animationPlayer.animation_finished.connect(onFinishedAterrizaje)
	animAterrizar_iniciado=true
func iniciar_(_direction_caida:Vector3):
	direction_caida=_direction_caida
	iniciar()
	pass
func iniciar():
	
	if iniciado:
		return
	if character.animationPlayer.animation_finished.is_connected(onFinishedAterrizaje):
		character.animationPlayer.animation_finished.disconnect(onFinishedAterrizaje)
	print("iniciado: "+estadoName)
	iniciado=true
	activo=true
	character.estado=estadoName
	animAterrizar_iniciado=false
	animAterrizar_finished=false
	timeCayendo=0
	pass
	
func onlyDetener():
	iniciado=false
	activo=false
	#animAterrizar_iniciado=false
	animAterrizar_finished=false
	direction_caida.y=0
	##necesiario ya que alveces caera yendo como para abajo y para que la rotacion pivote no quede chueco
	#character.reiniciarRotacionPivotX()
	if character.animationPlayer.animation_finished.is_connected(onFinishedAterrizaje):
		character.animationPlayer.animation_finished.disconnect(onFinishedAterrizaje)
func detener():
	print("detenido")
	onlyDetener()
	#if !animAterrizar_iniciado:
		#character.emitirPolvoPiso()
	character.estado=estadoReturn
	pass
