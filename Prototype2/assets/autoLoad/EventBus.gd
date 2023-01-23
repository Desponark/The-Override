# Event bus for distant nodes to communicate using signals.
# This is intended for cases where connecting the nodes directly creates more coupling
# or increases code complexity substantially.
extends Node

signal playerWasKilled
signal enemyWasHit
signal spawnProjectile(newProjectile)
signal spawnEnemy(newEnemy)
