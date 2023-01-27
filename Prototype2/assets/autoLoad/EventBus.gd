# Event bus for distant nodes to communicate using signals.
# This is intended for cases where connecting the nodes directly creates more coupling
# or increases code complexity substantially.
extends Node

# warning-ignore-all:UNUSED_SIGNAL
signal enemyWasHit
signal spawnProjectile(newProjectile)
signal spawnEnemy(newEnemy)
signal spawnLoot(loot)
