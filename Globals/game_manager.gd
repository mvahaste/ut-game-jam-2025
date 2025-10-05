extends Node

var day: int = 1
var day_failed: bool = false
var player_money: int = 0
var player_money_from_sales: int = 0
var money_needed_per_day: int = 450
var last_day_failed: bool = false
var will_lose_game: bool = false
var items_sold: Array[BaseItem] = []

enum Result {
	WIN,
	LOSE,
	DIE
}

var final_result: Result = Result.WIN

func end_day():
	day += 1

	if day > 3:
		final_result = Result.WIN
		SceneManager.transition_to_scene(SceneManager.Scenes.GAME_OVER)
		pass

	day_failed = player_money < money_needed_per_day

	player_money_from_sales = _player_sell()
	player_money += player_money_from_sales

	player_money -= money_needed_per_day
	if player_money < 0:
		player_money = 0

	if last_day_failed and day_failed:
		final_result = Result.LOSE
		SceneManager.transition_to_scene(SceneManager.Scenes.GAME_OVER)
		pass

	last_day_failed = day_failed
	SceneManager.transition_to_scene(SceneManager.Scenes.RESULTS)

func _player_sell() -> int:
	var money = 0
	items_sold.clear()

	for i in range(InventoryManager.inventory.size()):
		var item = InventoryManager.inventory[i]
		items_sold.append(item)
		money += item.value
		InventoryManager.remove_item(i)

	for i in range(InventoryManager.hidden_inventory.size()):
		var item = InventoryManager.hidden_inventory[i]
		items_sold.append(item)
		money += item.value
		InventoryManager.hidden_inventory.remove_at(i)

	return money
