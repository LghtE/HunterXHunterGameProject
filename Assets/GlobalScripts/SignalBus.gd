extends Node


signal enemyHitMelee(melee_arr, ranged_arr, enemy) #Gets emitted in the flow state
signal enemyHitRanged(melee_arr, ranged_arr) #Gets emitted in the flow state
signal projShotWhenRangedArrZERO

signal auraBarChanged(aura_amt, aurasegments)
signal auraIncrease

signal onEnemyBreak(enemy)
signal onEnemyDied(enemy)
signal onEnemyReady(enemy)

signal decreaseAura(amt)
signal increaseAura(amt)

signal skillComplete()


signal convoStarted()
signal convoEnded()

signal fullscreenToggled(fullscreen)
