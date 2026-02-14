extends Node3D
class_name KiBlastSimple
var activo=false
var iniciado=false
var nodeTarget:Node3D
var aceleration=10

@export var speed: float = 15.0
@export var turn_speed: float = 3.0   # qué tan rápido puede girar (radianes por segundo)


var velocity: Vector3 = Vector3.ZERO
@export var initial_curve_strength: float = 2.0   # intensidad del desvío
@export var curve_duration: float = 0.5           # cuánto tiempo dura la curva
var curve_timer: float = 0.0
var curve_direction: float = 1.0

var initial_forward: Vector3   # vector de orientación inicial
var initial_position: Vector3
var nodeIgnoreColision:Node3D

@export var timeLife=5
@export var timeCount=0.0
func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	if activo:
		timeCount+=delta
		if timeCount>=timeLife:
			onlyDetener()
			return
		
		$aspas_particle.global_position=initial_position
		$estrellitas_particle.global_position=initial_position
		# =========================
		# CURVA INICIAL
		# =========================
		if curve_timer > 0.0:
			rotate_y(initial_curve_strength * curve_direction * delta)
			curve_timer -= delta

		# =========================
		# SEGUIMIENTO SUAVIZADO HACIA TARGET
		elif nodeTarget != null:
			var positionFinal=nodeTarget.global_position
			if nodeTarget is CharacterPrin:
				positionFinal=nodeTarget.getPositionGlobalFromBone("016_BELLY")
			var to_target = (positionFinal - global_position).normalized()
			if to_target.length() > 0.001:
				var current_forward = -global_transform.basis.z
				var new_forward = current_forward.slerp(to_target, turn_speed * delta)
				look_at(global_position + new_forward, Vector3.UP)

		# =========================
		# RETORNO SUAVIZADO A LÍNEA ORIGINAL
		else:
			var current_forward = -global_transform.basis.z
			var new_forward = current_forward.slerp(initial_forward, turn_speed * delta)
			look_at(global_position + new_forward, Vector3.UP)

			# Ajustar posición lateral y altura suavemente
			var displacement_along_forward = initial_forward.dot(global_position - initial_position)
			var target_position = initial_position + initial_forward * displacement_along_forward
			global_position = global_position.lerp(target_position, turn_speed * delta)

		# =========================
		# MOVIMIENTO CONSTANTE
		global_position += -global_transform.basis.z * speed * delta
	pass
func iniciar(_nodeTarget:Node3D):
	
	if iniciado:
		return
	curve_timer = curve_duration
	initial_forward = -global_transform.basis.z   # guardar orientación inicial
	initial_position = global_position    
	# Elegir dirección aleatoria izquierda o derecha
	curve_direction = -1.0 if randf() < 0.5 else 1.0
	nodeTarget=_nodeTarget
	iniciado=true
	activo=true
	$AnimationPlayer.play("lanzamiento")
	$Area3D.body_entered.connect(onBodyEntered)
	pass
func calcularDirectionAcelerataSinPasarse(vectorPosicionFinal:Vector3,vectorPosicionactual:Vector3,aceleration=30):
	var direction=vectorPosicionFinal-vectorPosicionactual
	var distance = direction.length()
	direction=direction.normalized()*aceleration
	var step = min(distance, aceleration)
	return direction*step
	#charenemi.velocity=direction*step
	#charenemi.move_and_slide()
	pass
func onlyDetener():
	print("onlydetener kiblast")
	activo=false
	$AnimationPlayer.play("colision")
	$AnimationPlayer.animation_finished.connect(onEndAnimation)
func onBodyEntered(node:Node3D):
	if !activo:
		return


	if node.get_path()==nodeIgnoreColision.get_path():
		return
	if node is StaticBody3D:
		activo=false
		
	if node is CharacterPrin:
		activo=false
		node.callSimpleDamage(1,self)
	$AnimationPlayer.play("colision")
	$AnimationPlayer.animation_finished.connect(onEndAnimation)
	pass
func onEndAnimation(animNamne):
	queue_free()
	pass
