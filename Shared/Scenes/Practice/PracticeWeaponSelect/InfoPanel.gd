extends Panel

onready var description = $Description
onready var primary_damage = $PrimaryDamageLabel/PrimaryDamage
onready var primary_cooldown = $PrimaryCooldownLabel/PrimaryCooldown
onready var secondary_damage = $SecondaryDamageLabel/SecondaryDamage
onready var secondary_cooldown = $SecondaryCooldownLabel/SecondaryCooldown
onready var switch_delay = $SwitchDelayLabel/SwitchDelay

func set_weapon_info(weapon):
	description.text = weapon.DESCRIPTION
	primary_damage.text = str(weapon.PRIMARY_DAMAGE)
	primary_cooldown.text = str(weapon.PRIMARY_COOLDOWN_TIME)
	secondary_damage.text = str(weapon.SECONDARY_DAMAGE)
	secondary_cooldown.text = str(weapon.SECONDARY_COOLDOWN_TIME)
	switch_delay.text = str(weapon.SWITCH_DELAY)
