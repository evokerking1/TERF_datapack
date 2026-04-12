scoreboard players add temp terf_states 3
execute if block ~ ~ ~ #minecraft:air positioned ^ ^ ^.3 run return run function terf:entity/machines/stfr/states/shutdown_failure/rays/raycast

execute if block ~ ~ ~ #terf:stfr_blocks unless block ~ ~ ~ #terf:indestructible run setblock ~ ~ ~ air
