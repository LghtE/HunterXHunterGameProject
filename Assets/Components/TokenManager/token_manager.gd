extends Node3D
class_name TokenManager



var enemies_dict : Dictionary
@export var no_of_tokens : int = 2

var no_of_tokens_avail = 0

func _ready() -> void:
	SignalBus.connect("onEnemyDied", enemyDied)
	
	
	no_of_tokens_avail = no_of_tokens
	initializeEnemies()
	assignTokens()


func initializeEnemies():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.processing:
			enemy.has_token = false
			enemies_dict[enemy] = enemy.has_token


func assignTokens():
	if enemies_dict.size() < no_of_tokens:
		no_of_tokens_avail = enemies_dict.size()
	
	while no_of_tokens_avail > 0:
		var dict_size = enemies_dict.size()
		var random_enemy = enemies_dict.keys()[randi() % dict_size] # Returns random enemy
		
		if random_enemy.has_token:
			continue
		
		random_enemy.has_token = true
		no_of_tokens_avail -= 1

func removeTokens():
	for en in enemies_dict.keys():
		if en:
			en.has_token = false

func enemyDied(enemy):
	enemies_dict.clear()
	initializeEnemies()


func _on_timer_timeout() -> void:
	no_of_tokens_avail = no_of_tokens
	
	enemies_dict.clear()
	for en in get_tree().get_nodes_in_group("enemy"):
		if en.processing:
			en.has_token = false
			enemies_dict[en] = en.has_token
	
	removeTokens()
	assignTokens()
