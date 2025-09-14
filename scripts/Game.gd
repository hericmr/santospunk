extends Node2D

# Dicionário com as cenas de destino para cada direção
var scene_transitions = {
	"right": "res://cenas/bar_da_tia_ana_frente.tscn",
	"left": "res://cenas/bar_da_tia_ana_frente.tscn",  # Pode ser alterado para outra cena
	"up": "res://cenas/bar_da_tia_ana_frente.tscn",    # Pode ser alterado para outra cena
	"down": "res://cenas/bar_da_tia_ana_frente.tscn"   # Pode ser alterado para outra cena
}

func _ready():
	# Conectar os sinais das áreas de transição
	_connect_transition_areas()

func _connect_transition_areas():
	# Conectar cada área de transição
	var transition_areas = [
		$TransitionAreas/RightArea,
		$TransitionAreas/LeftArea,
		$TransitionAreas/UpArea,
		$TransitionAreas/DownArea
	]
	
	for area in transition_areas:
		if area:
			area.body_entered.connect(_on_transition_area_entered.bind(area.name))

func _on_transition_area_entered(body, area_name):
	# Verificar se o corpo que entrou é o jogador
	if body.is_in_group("player"):
		# Determinar a direção baseada no nome da área
		var direction = area_name.to_lower().replace("area", "")
		
		# Verificar se existe uma cena de destino para esta direção
		if direction in scene_transitions:
			var target_scene = scene_transitions[direction]
			print("Transicionando para: ", target_scene)
			get_tree().change_scene_to_file(target_scene)
