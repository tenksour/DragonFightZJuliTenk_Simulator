@tool
extends Node3D
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
		

func onInvocarGolpeSimpleArmLeft(value):
	if !is_node_ready():
		return
	$"../".callTemblor1()	
	print("..onInvocarGolpeSimpleArmLeft")
	if value and $"../temp_audios/golpe_simple"!=null:
		$"../temp_audios/golpe_simple".play()
	pass
func onInvocarGolpeSimpleArmRight(value):
	if !is_node_ready():
		return
	$"../".callTemblor1()	
	print("..onInvocarGolpeSimpleArmLeft")
	if value and $"../temp_audios/golpe_simple"!=null:
		$"../temp_audios/golpe_simple".play()
	pass
func onInvocarGolpeFuerteArmRight(value):
	if !is_node_ready():
		return
	$"../".callTemblor2()
	if value and $"../temp_audios/golpe_fuerte"!=null:
		$"../temp_audios/golpe_fuerte".play()
	pass
func onInvocarGolpeFuerteArmLeft(value):
	if !is_node_ready():
		return
	$"../".callTemblor2()
	if value and $"../temp_audios/golpe_fuerte"!=null:
		$"../temp_audios/golpe_fuerte".play()
	pass
func onInvocarGolpeFuerteRoot(value):
	if !is_node_ready():
		return
	$"../".callTemblor2()
	if value and $"../temp_audios/golpe_fuerte"!=null:
		$"../temp_audios/golpe_fuerte".play()
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
