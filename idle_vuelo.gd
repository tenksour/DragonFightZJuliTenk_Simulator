extends CharacterEstadoGeneric
var count_anim=0
var animacion_first_finished=false
@export var damage_vida_origin=1
var damage_vida_final=damage_vida_origin
var is_front=true
var gravedad=true
# Amplitud del movimiento vertical
var amplitude := 1.7
# Velocidad del "flotamiento"
var speed := 2.2
# Tiempo acumulado
var time_passed := 0.0
func calcularDirectionVueloFlotante(delta:float):
	# Actualizamos el tiempo
	time_passed += delta * speed
	# Calculamos la velocidad en Y usando la derivada del seno
	# v = dy/dt = amplitude * cos(time_passed) * speed
	var vy = amplitude*cos(time_passed)*speed
	# Creamos el vector de movimiento
	return Vector3(0, vy, 0)
func _ready() -> void:
	super._ready()

	pass
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if character.estado==estadoName:

		#character.animationPlayer.play("055_strike_01_anm",0.2)
		var direction=character.calcSimpleMoveWalking(delta)
		if direction == Vector3.ZERO:
			character.animationPlayer.get_animation("038_fly_anm").loop_mode=Animation.LOOP_LINEAR
			character.animationPlayer.play("038_fly_anm",0.5)
			character.velocity=calcularDirectionVueloFlotante(delta)
			character.move_and_slide()
		else:

			character.animationPlayer.get_animation("003_move_far_loop_anm").loop_mode=Animation.LOOP_LINEAR
			character.animationPlayer.get_animation("005_move_far_l_loop_anm").loop_mode=Animation.LOOP_LINEAR
			character.animationPlayer.get_animation("007_move_far_r_loop_anm").loop_mode=Animation.LOOP_LINEAR
			if character.get_pivot_look_relative_to_camera(character.camera)=="FRONT":
				character.animationPlayer.play("003_move_far_loop_anm",1)
				pass
			if character.get_pivot_look_relative_to_camera(character.camera)=="BACK":
				character.animationPlayer.play("003_move_far_loop_anm",1)
				pass
			if character.get_pivot_look_relative_to_camera(character.camera)=="LEFT":
				character.animationPlayer.play("005_move_far_l_loop_anm",1)
				pass
			if character.get_pivot_look_relative_to_camera(character.camera)=="RIGHT":
				character.animationPlayer.play("007_move_far_r_loop_anm",1)
				pass
			character.velocity=direction
			character.move_and_slide()
		#var dir2=calcSimpleMoveTeclas(delta)
		#if dir2.x==1:
			#animationPlayer.play("007_move_far_r_loop_anm",1.2)
		#else:if dir2.x==-1:
			#animationPlayer.play("005_move_far_l_loop_anm",1.2)
		#if dir2.z==1:
			#animationPlayer.play("003_move_far_loop_anm",1.2)
		#else:if dir2.z==-1:
			#animationPlayer.play("003_move_far_loop_anm",1.2)
	pass


func postIniciar():
	#character.animationPlayer.play("055_strike_01_anm",0.2)
	pass
func addCountAnim():
	count_anim+=1

	pass
func onlyDetener():
	super.onlyDetener()
