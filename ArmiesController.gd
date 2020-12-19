extends Node

const army_type_script = preload("res://InfantryArmy.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var human_army_array = []
var orc_army_array = []

const attack_prep_dist = 50
const attack_action_dist = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta): 
	check_army_attacks()

func _register_army(army, team):
	if team == army_type_script.ArmyTeam.HUMAN: 
		human_army_array.append(army)
	elif team == army_type_script.ArmyTeam.ORC: 
		orc_army_array.append(army)
	check_army_attacks()
	
func check_army_attacks():
	# human-orc
	for human_army in human_army_array:
		var human_position = human_army.get_position()
		for orc_army in orc_army_array: 
			var orc_position =  orc_army.get_position()
			if abs(human_position - orc_position) < attack_prep_dist: 
				if human_position < orc_position: 
					human_army.start_attack(human_position, true)
					orc_army.start_attack(human_position + attack_action_dist, false)
				else: 
					orc_army.start_attack(orc_position, true)
					human_army.start_attack(orc_position + attack_action_dist, false)
				

				# TODO differentiate first attacker? 
		
