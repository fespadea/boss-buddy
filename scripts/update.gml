// update

#macro BOSS_HEALTH 672
#macro BOSS_STOCKS 1
#macro PLAYER_STOCKS 3
#macro AT_HEALTH_BAR 49
#macro AT_HEALTH_BAR_HITBOX 24

var bossPlayer = 2;
var bossPlayerID;
if(is_player_on(bossPlayer)){
	var bossHealth = max(BOSS_HEALTH - get_player_damage(bossPlayer), 0);
	var i = 0;
	with oPlayer {
		if(player == bossPlayer){
			bossPlayerID[i++] = id;
			if(get_player_stocks(player) > BOSS_STOCKS){
				set_player_stocks(player, BOSS_STOCKS);
			}
		} else {
			if(get_player_stocks(player) > PLAYER_STOCKS){
				set_player_stocks(player, PLAYER_STOCKS);
			}
		}
	}
	var healthBarSprite = sprite_get("healthbar");
	with bossPlayerID{
		set_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_HITBOX_TYPE, 2);
		set_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_LIFETIME, 2);
		set_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PRIORITY, 0);
		set_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_SPRITE, healthBarSprite);
		set_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_GROUND_BEHAVIOR, 1);
		set_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_WALL_BEHAVIOR, 1);
		set_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_ENEMY_BEHAVIOR, 1);
		set_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_UNBASHABLE, 1);
		set_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_IS_TRANSCENDENT, 1);
		set_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_DOES_NOT_REFLECT, 1);
		set_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_PLASMA_SAFE, 1);
		var healthbarHitbox = create_hitbox(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, x, y);
		healthbarHitbox.image_index = floor((BOSS_HEALTH-bossHealth)/12);
		healthbarHitbox.spr_dir = 1;
		healthbarHitbox.depth = depth-1;
		reset_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_HITBOX_TYPE);
		reset_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_LIFETIME);
		reset_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PRIORITY);
		reset_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_SPRITE);
		reset_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_GROUND_BEHAVIOR);
		reset_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_WALL_BEHAVIOR);
		reset_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_ENEMY_BEHAVIOR);
		reset_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_UNBASHABLE);
		reset_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_IS_TRANSCENDENT);
		reset_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_DOES_NOT_REFLECT);
		reset_hitbox_value(AT_HEALTH_BAR, AT_HEALTH_BAR_HITBOX, HG_PROJECTILE_PLASMA_SAFE);
	}
}

if(array_length(bossPlayerID)){
	with bossPlayerID {
		if(!("boss_buddy_stats_saved" in self) || !boss_buddy_stats_saved){
			boss_buddy_stats_saved = true;
			boss_buddy_alive = true;
			boss_buddy_ground_friction = ground_friction*1.2;
			boss_buddy_max_fall = max_fall*1.1;
			boss_buddy_fast_fall = fast_fall*1.1;
			boss_buddy_max_jump_hsp = max_jump_hsp*2;
			boss_buddy_air_max_speed = air_max_speed*2;
			boss_buddy_air_accel = air_accel*2;
			boss_buddy_jump_change = jump_change*2;
			boss_buddy_walk_speed = walk_speed*2;
			boss_buddy_walk_accel = walk_accel*2;
			boss_buddy_initial_dash_speed = initial_dash_speed*2.3;
			boss_buddy_dash_speed = dash_speed*2;
		} else{
			knockback_adj = 0.1;
			ground_friction = boss_buddy_ground_friction;
			max_fall = boss_buddy_max_fall;
			fast_fall = boss_buddy_fast_fall;
			max_jump_hsp = boss_buddy_max_jump_hsp;
			air_max_speed = boss_buddy_air_max_speed;
			air_accel = boss_buddy_air_accel;
			jump_change = boss_buddy_jump_change;
			walk_speed = boss_buddy_walk_speed;
			walk_accel = boss_buddy_walk_accel;
			initial_dash_speed = boss_buddy_initial_dash_speed;
			dash_speed = boss_buddy_dash_speed;
		}
		if(bossHealth<=0){
			if(state != PS_DEAD && state != PS_RESPAWN){
				go_through = true;
				invince_time = 2;
				if(boss_buddy_alive || state != PS_WRAPPED){
					sound_play(asset_get("sfx_war_horn"));
					set_state(PS_WRAPPED);
					wrap_time = 120;
					boss_buddy_alive = false;
				} else if(state_timer >= wrap_time-2){
					create_deathbox(x, round(y-char_height/2), 2, 2, player, true, 0, 2, 2);
					boss_buddy_alive = true;
				} else {
					y--;
					var char_width = sprite_get_bbox_right(hurtbox_spr) - sprite_get_bbox_left(hurtbox_spr) + 1;
					var modValue = ceil(lerp(20, 20, state_timer/wrap_time));
					if(state_timer % modValue == 1){
						spawn_hit_fx(x+random_func(0, char_width, true)-char_width/2, y-random_func(1, char_height, true), 143);
						sound_play(asset_get("sfx_abyss_explosion"));
					}
				}
			}
		} else {
			boss_buddy_alive = true;
			var horizontalOutOfBounds = x > room_width-hsp || x < 0-hsp;
			var verticalOutOfBounds = y > room_height-vsp || y < 0-vsp;
			if (horizontalOutOfBounds || verticalOutOfBounds){
				if(horizontalOutOfBounds){
					hsp = -max_jump_hsp*sign(hsp);
				}
				if(verticalOutOfBounds){
					vsp = -jump_speed*sign(vsp);
				}
				if(state == PS_PRATFALL){
					set_state(PS_IDLE_AIR);
				}
				has_walljump = true;
				sound_play(asset_get("sfx_jumpair"));
				sound_play(asset_get("sfx_blow_medium3"));
				spawn_hit_fx (x , y - 40, 304);
			}
		}
	}
}