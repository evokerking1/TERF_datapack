scoreboard players set core_shield_limit terf_states 0
execute store result storage terf:temp args.pitch int 4 run scoreboard players get @s terf_data_T

function terf:entity/machines/stfr/visuals/shield/charge_particle_raycast with storage terf:temp args