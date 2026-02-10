extends Node3D
class_name Jump
@onready var character:CharacterPrin=self.get_parent().get_parent()
@export var animationName="032_jump_in_anm"
@export var animationNameIn="031_sway_out_anm"
@export var estadoName="saltando"

var activo=false
var iniciado=false
@export var aceleration_jump=8#aceleracion
var velocity_inicial=10;#velocidad inicial
var velocity_count=velocity_inicial;#variable temporal que suma
@export var velocity_max_aceleration=100 #velocidad maxima
var timeCount=0
@export var timeSalto=30
var animationInFinalizado=false
@export var necesita_estar_sobre_piso=true
@export var estadosIn = ["normal","correr"]
@export var input_active=true
@export var detener_on_realeased=false
func verificarIniciar(delta):
	if input_active and estadosIn.has(character.estado) and character.is_action_just_pressed("r1") and character.jump_hability:
		if necesita_estar_sobre_piso and character.is_on_floor():
			iniciar()
		else: if !necesita_estar_sobre_piso:
			iniciar()
func _physics_process(delta: float) -> void:
			
	#todo estado se debe detener automaticamente si el estado ya cambio de nombre
	#tambien habra estados secundarios que afectaran velocidad o aura
	if character.estado!=estadoName and activo:
		print("Se detentra: "+estadoName+" por que el estado cambio")
		onlyDetener()
	verificarIniciar(delta)
	if activo and timeCount>timeSalto:
		print("Se detentra: "+estadoName+" por que el tiempo termino")
		character.reiniciarGravedad()
		detener()
	if activo and detener_on_realeased and character.is_action_just_released("l1"):
		print("Se detentra: "+estadoName+" por que el tiempo termino")
		character.reiniciarGravedad()
		detener()
	if activo:
		velocity_count+=aceleration_jump
		if velocity_count>velocity_max_aceleration:
			velocity_count=velocity_max_aceleration
		
		#timeCayendo+=1
		#if !animAterrizar_iniciado:
		if animationInFinalizado:
			character.animationPlayer.play(animationName,0.4)
		character.velocity=character.calcDirectionGravity(delta)
		var direction=Vector3(0,velocity_count,0)
		
		character.velocity=direction
		character.velocity+=character.calcSimpleMoveWalking(delta)
		character.move_and_slide()
		timeCount+=1

	pass

func onFinishedAnimationIn(animName):
	animationInFinalizado=true
	pass
func onFinishedAterrizaje(animName):
	detener()
	pass
func aterrizar():
	#if animAterrizar_iniciado:
		#return
	#print("aterrizar iniciado")
	#character.animationPlayer.play(animationNameAterrizaje,0.1)
	#character.animationPlayer.animation_finished.connect(onFinishedAterrizaje)
	#animAterrizar_iniciado=true
	pass
	
func iniciar():
	if iniciado:
		return
	character.callSoundSaltoEntrada()
	desconectarSeñalesAnimation()
	print("iniciado jump")
	#character.animationPlayer_basic.play("jump_camera")
	iniciado=true
	activo=true
	character.estado=estadoName
	timeCount=0
	velocity_count=velocity_inicial
	character.animationPlayer.play(animationNameIn,0.1)
	if character.animationPlayer.get_animation(animationName):
		character.animationPlayer.get_animation(animationName).loop_mode=Animation.LOOP_LINEAR
	character.animationPlayer.animation_finished.connect(onFinishedAnimationIn)
	pass
	
func onlyDetener():
	animationInFinalizado=false
	iniciado=false
	activo=false
	velocity_count=velocity_inicial
	timeCount=0
	desconectarSeñalesAnimation()
func detener():
	print("detenido")
	onlyDetener()
	
	character.estado="normal"
	pass
func desconectarSeñalesAnimation():
	if character.animationPlayer.animation_finished.is_connected(onFinishedAterrizaje):
		character.animationPlayer.animation_finished.disconnect(onFinishedAterrizaje)
	if character.animationPlayer.animation_finished.is_connected(onFinishedAnimationIn):
		character.animationPlayer.animation_finished.disconnect(onFinishedAnimationIn)
