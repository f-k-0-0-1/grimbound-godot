extends Resource
class_name EnemyStats

@export_category("Base Stats")
@export var max_health: int = 50
@export var damage: int = 10
@export var speed: float = 100.0

@export_category("Combat Mechanics")
@export var knockback_resistance: float = 0.0 # 0.0 means takes full knockback, 1.0 means immune
@export var aggro_range: float = 250.0

@export_category("Rewards")
@export var xp_reward: int = 5
@export var coin_reward: int = 2
