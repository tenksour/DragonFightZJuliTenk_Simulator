@tool
extends Node3D
var kiblast_res=preload("res://Efectos/ki_blast_simple.tscn")
var golpe_fuerte_effect_res=preload("res://Efectos/gole_fuerte_effect.tscn")
var _kiblast:KiBlastSimple
var _golpe_fuerte_effect_res:Node3D
func _ready() -> void:
	_kiblast=kiblast_res.instantiate()
	_golpe_fuerte_effect_res=golpe_fuerte_effect_res.instantiate()
	pass
@onready var character:CharacterPrin=self.get_parent()
@export var invocarGolpeSimpleArmLeft=false:
	set(_value):
		invocarGolpeSimpleArmLeft = _value
		onInvocarGolpeSimpleArmLeft(_value)
	get:
		return invocarGolpeSimpleArmLeft
@export var invocarGolpeSimpleArmRight=false:
	set(_value):
		invocarGolpeSimpleArmRight = _value
		onInvocarGolpeSimpleArmRight(_value)
	get:
		return invocarGolpeSimpleArmRight
@export var invocarGolpeFuerteArmRight=false:
	set(_value):
		invocarGolpeFuerteArmRight = _value
		onInvocarGolpeFuerteArmRight(_value)
	get:
		return invocarGolpeFuerteArmRight
@export var invocarGolpeFuerteArmLeft=false:
	set(_value):
		invocarGolpeFuerteArmLeft = _value
		onInvocarGolpeFuerteArmLeft(_value)
	get:
		return invocarGolpeFuerteArmLeft
@export var invocarGolpeFuerteRoot=false:
	set(_value):
		invocarGolpeFuerteRoot = _value
		onInvocarGolpeFuerteRoot(_value)
	get:
		return invocarGolpeFuerteRoot
@export var activarColisionGolpes=false:
	set(_value):
		activarColisionGolpes = _value
		onActivarColisionGolpes(_value)
	get:
		return activarColisionGolpes
@export var activarSonidoViento=false:
	set(_value):
		activarSonidoViento = _value
		onActivarSonidoViento(_value)
	get:
		return activarSonidoViento
@export var activar_disparar_efecto_right_arm=false:
	set(_value):
		activar_disparar_efecto_right_arm = _value
		onActivar_disparar_efecto_right_arm(_value)
	get:
		return activar_disparar_efecto_right_arm	
@export var activar_disparar_efecto_left_arm=false:
	set(_value):
		activar_disparar_efecto_left_arm = _value
		onActivar_disparar_efecto_left_arm(_value)
	get:
		return activar_disparar_efecto_left_arm	
func onInvocarGolpeSimpleArmLeft(value):
	if !is_node_ready():
		return
	$"../".callTemblor1()	
	print("..onInvocarGolpeSimpleArmLeft")
	if value and $"../temp_audios/golpe_simple"!=null:
		$"../temp_audios/golpe_simple".play()
		var effect=preload("res://Efectos/golpe_simple_effect.tscn")
		effect=effect.instantiate()
		character.get_parent().add_child(effect)
		var posebone=character.getPositionGlobalFromBone("045_EFFECT_L")
		effect.global_position=posebone
		effect.iniciar()
	pass
func onInvocarGolpeSimpleArmRight(value):
	if !is_node_ready():
		return
	$"../".callTemblor1()	
	print("..onInvocarGolpeSimpleArmLeft")
	if value and $"../temp_audios/golpe_simple"!=null:
		$"../temp_audios/golpe_simple".play()
		var effect=preload("res://Efectos/golpe_simple_effect.tscn")
		effect=effect.instantiate()
		character.get_parent().add_child(effect)
		var posebone=character.getPositionGlobalFromBone("031_EFFECT_R")
		effect.global_position=posebone
		effect.iniciar()
	pass
func onInvocarGolpeFuerteArmRight(value):
	if !is_node_ready():
		return
	$"../".callTemblor2()
	if value and $"../temp_audios/golpe_fuerte"!=null:
		$"../temp_audios/golpe_fuerte".play()
		var golpefuerteeffect=preload("res://Efectos/gole_fuerte_effect.tscn")
		golpefuerteeffect=golpefuerteeffect.instantiate()
		character.get_parent().add_child(golpefuerteeffect)
		var posebone=character.getPositionGlobalFromBone("016_BELLY")
		golpefuerteeffect.global_position=posebone
		golpefuerteeffect.iniciar()
	pass
func onInvocarGolpeFuerteArmLeft(value):
	if !is_node_ready():
		return
	$"../".callTemblor2()
	if value and $"../temp_audios/golpe_fuerte"!=null:
		$"../temp_audios/golpe_fuerte".play()
		
		var golpefuerteeffect=preload("res://Efectos/gole_fuerte_effect.tscn")
		golpefuerteeffect=golpefuerteeffect.instantiate()
		character.get_parent().add_child(golpefuerteeffect)
		var posebone=character.getPositionGlobalFromBone("016_BELLY")
		golpefuerteeffect.global_position=posebone
		golpefuerteeffect.iniciar()
	pass
func onInvocarGolpeFuerteRoot(value):
	if !is_node_ready():
		return
	$"../".callTemblor2()
	if value and $"../temp_audios/golpe_fuerte"!=null:
		$"../temp_audios/golpe_fuerte".play()
		var golpefuerteeffect=preload("res://Efectos/gole_fuerte_effect.tscn")
		golpefuerteeffect=golpefuerteeffect.instantiate()
		character.get_parent().add_child(golpefuerteeffect)
		var posebone=character.getPositionGlobalFromBone("016_BELLY")
		golpefuerteeffect.global_position=posebone
		golpefuerteeffect.iniciar()
	pass
func onActivarColisionGolpes(value):
	if !is_node_ready():
		return
	if value:
		$"..".activarAreasColisionGolpe()
	else:
		$"..".desactivarAreasColisionGolpe()
	#if !is_node_ready():
		#return
	#$"../".callTemblor2()
	#if value and $"../temp_audios/golpe_fuerte"!=null:
		#$"../temp_audios/golpe_fuerte".play()
	pass
func onActivarSonidoViento(value):
	if !is_node_ready():
		return
	if value:
		var pitch=randi_range(90,110)/100.0
		var t=randi_range(1,3)
		if t==1:
			$"../temp_audios/viento".pitch_scale=pitch
			$"../temp_audios/viento".playing=true
		if t==2:
			$"../temp_audios/viento2".pitch_scale=pitch
			$"../temp_audios/viento2".playing=true
		if t==3:
			$"../temp_audios/viento3".pitch_scale=pitch
			$"../temp_audios/viento3".playing=true
		#if $"../temp_audios/viento2".playing:
			#$"../temp_audios/viento".playing=true
			#$"../temp_audios/viento".pitch_scale=pitch
	#if !is_node_ready():
		#return
	#$"../".callTemblor2()
	#if value and $"../temp_audios/golpe_fuerte"!=null:
		#$"../temp_audios/golpe_fuerte".play()
	pass
func onActivar_disparar_efecto_left_arm(value):
	if !is_node_ready():
		return
	if value:


		var kiblast:KiBlastSimple=_kiblast.duplicate()
		var pose_left_arm=character.getPositionGlobalFromBone("045_EFFECT_L")
		kiblast.global_position=pose_left_arm
		character.get_parent().add_child(kiblast)	
		kiblast.global_rotation=character.characterPivot.global_rotation
		kiblast.nodeIgnoreColision=character
		if character.characterTarget:
			kiblast.iniciar(character.characterTarget)
		else:
			kiblast.iniciar(null)
	pass
func onActivar_disparar_efecto_right_arm(value):
	if !is_node_ready():
		return
	if value:

		
		var kiblast:KiBlastSimple=_kiblast.duplicate()
		var pose_left_arm=character.getPositionGlobalFromBone("031_EFFECT_R")
		
		kiblast.global_position=pose_left_arm
		
		character.get_parent().add_child(kiblast)	
		kiblast.global_rotation=character.characterPivot.global_rotation
		kiblast.nodeIgnoreColision=character
		if character.characterTarget:
			kiblast.iniciar(character.characterTarget)
		else:
			kiblast.iniciar(null)
	pass
