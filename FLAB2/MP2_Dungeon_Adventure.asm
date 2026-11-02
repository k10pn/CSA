; Module 5 Machine Problem 2
; Dungeon Adventure and Survival Game
; NASM x86 32-bit Linux using int 0x80

BITS 32
GLOBAL _start

SECTION .data
welcome db 10, "=======================================", 10
        db "       DUNGEON OF THE LOST KING", 10
        db "=======================================", 10
        db "              |>>>>", 10
        db "              |", 10
        db "          _  _|_  _", 10
        db "         |;|_|;|_|;|", 10
        db "         \.    .  /", 10
        db "          \:  .  /", 10
        db "           ||:   |", 10
        db "           ||:.  |", 10
        db "           ||:  .|", 10
        db "       ENTER IF YOU DARE!", 10
        db "=======================================", 10, 0

name_prompt db "Enter your hero name: ", 0
class_prompt db 10, "Choose your character:", 10
             db "[1] Warrior", 10
             db "[2] Mage", 10
             db "[3] Archer", 10
             db "Enter choice: ", 0
welcome_msg db 10, "Welcome, ", 0
warrior_text db "Warrior", 0
mage_text db "Mage", 0
archer_text db "Archer", 0
invalid_class db 10, "Invalid class selection. Choose 1, 2, or 3.", 10, 0

main_menu db 10, "[1] Explore Dungeon", 10
          db "[2] View Character Status", 10
          db "[3] Use Health Potion", 10
          db "[4] View Inventory", 10
          db "[5] Exit Game", 10
          db "Enter choice: ", 0
invalid_menu db "Invalid menu selection.", 10, 0

status_title db 10, "--- CHARACTER STATUS ---", 10, 0
hero_label db "Hero: ", 0
class_label db "Class: ", 0
health_label db "Health: ", 0
max_health_label db "Maximum Health: ", 0
attack_label db "Attack: ", 0
potions_label db "Potions: ", 0
gold_label db "Gold: ", 0
room_label db "Current Room: ", 0

inventory_title db 10, "--- INVENTORY ---", 10, 0
inventory_potions db "Health Potions: ", 0
inventory_gold db "Gold: ", 0

goblin_art db 10, '     ,      ,', 10
            db '    /(.-""-.)\', 10
            db ' |\  \/      \/  /|', 10
            db ' | \ / =.  .= \ / |', 10
            db '  \  \   ^    /  /', 10
            db '   \  "-----"  /', 10
            db 'A GOBLIN APPEARS!', 10, 0
dragon_art db 10, '     / \  //\\', 10
            db '    |\___/|      \', 10
            db '    /0  0  \      |', 10
            db '   /   ^    \    /', 10
            db '  /  \___/   \  /', 10
            db '  \___________\/', 10
            db 'THE DRAGON AWAKENS!', 10, 0
treasure_art db 10, "    __________", 10
             db "   /_________/|", 10
             db "  |  _____  | |", 10
             db "  | |  ?  | | |", 10
             db "  | |_____| | /", 10
             db "  |_________|/", 10, 0

room_one db 10, "ROOM 1 - GOBLIN CHAMBER", 10, 0
room_two db 10, "ROOM 2 - TREASURE CHAMBER", 10, 0
room_three db 10, "ROOM 3 - DRAGON'S LAIR", 10, 0
combat_menu db 10, "[1] Attack  [2] Defend", 10
            db "[3] Use Potion  [4] Run", 10
            db "Enter choice: ", 0
invalid_combat db "Invalid combat selection.", 10, 0
attack_msg db "You attack the enemy.", 10, 0
defend_msg db "You defend. The next enemy attack is reduced by 5.", 10, 0
run_msg db "You retreat to the main menu.", 10, 0
enemy_hit db "The enemy attacks for ", 0
damage_end db " damage.", 10, 0
enemy_defeated db "The enemy has been defeated!", 10, 0
health_zero db "Your health has reached zero.", 10, 0

chest_prompt db "[1] Open Chest  [2] Leave Chest", 10
             db "Enter choice: ", 0
chest_opened db "You opened the chest and gained 50 gold.", 10, 0
chest_left db "You leave the chest behind.", 10, 0
invalid_chest db "Invalid chest selection.", 10, 0
next_room db "You advance to the next room.", 10, 0

potion_used db "You used a health potion and restored 20 health.", 10, 0
potion_full db "Your health is already at maximum, but the potion was consumed.", 10, 0
no_potions db "You have no health potions left.", 10, 0
victory_msg db 10, "VICTORY!", 10
            db "CONGRATULATIONS, ", 0
victory_end db "!", 10, "You defeated the dragon and escaped!", 10
            db "Final Gold: ", 0
game_over_msg db 10, "GAME OVER", 10
              db "Your hero has fallen.", 10
              db "The dungeon remains undefeated.", 10
              db "BETTER LUCK NEXT TIME!", 10, 0
exit_msg db 10, "You leave the dungeon.", 10, 0
newline db 10, 0
tab_text db "  ", 0

SECTION .bss
name_buffer resb 64
input_buffer resb 32
number_buffer resb 16
hero_class resd 1
hero_name resd 1
hero_health resd 1
hero_max_health resd 1
hero_attack resd 1
hero_potions resd 1
hero_gold resd 1
current_room resd 1
enemy_health resd 1
enemy_damage resd 1
defend_flag resd 1
chest_done resd 1
enemy_name resd 1

SECTION .text

_start:
    call display_welcome
    call get_player_info
    call initialize_character
    call display_status

main_loop:
    call display_main_menu
    mov ecx, input_buffer
    mov edx, 32
    call read_line
    mov ecx, input_buffer
    call parse_int
    cmp eax, 1
    je .explore
    cmp eax, 2
    je .status
    cmp eax, 3
    je .potion
    cmp eax, 4
    je .inventory
    cmp eax, 5
    je .exit
    mov ecx, invalid_menu
    call print_cstr
    jmp main_loop
.explore:
    call explore_dungeon
    jmp main_loop
.status:
    call display_status
    jmp main_loop
.potion:
    call use_potion
    jmp main_loop
.inventory:
    call display_inventory
    jmp main_loop
.exit:
    call exit_program

display_welcome:
    mov ecx, welcome
    call print_cstr
    ret

get_player_info:
    mov ecx, name_prompt
    call print_cstr
    mov ecx, name_buffer
    mov edx, 64
    call read_line
    mov dword [hero_name], name_buffer

.class_loop:
    mov ecx, class_prompt
    call print_cstr
    mov ecx, input_buffer
    mov edx, 32
    call read_line
    mov ecx, input_buffer
    call parse_int
    cmp eax, 1
    jb .invalid
    cmp eax, 3
    ja .invalid
    mov [hero_class], eax
    mov ecx, welcome_msg
    call print_cstr
    mov ecx, name_buffer
    call print_cstr
    mov ecx, newline
    call print_cstr
    ret
.invalid:
    mov ecx, invalid_class
    call print_cstr
    jmp .class_loop

initialize_character:
    mov dword [current_room], 1
    mov dword [hero_gold], 0
    mov dword [chest_done], 0
    mov dword [defend_flag], 0
    mov eax, [hero_class]
    cmp eax, 1
    je .warrior
    cmp eax, 2
    je .mage
    mov dword [hero_max_health], 85
    mov dword [hero_health], 85
    mov dword [hero_attack], 25
    mov dword [hero_potions], 2
    ret
.warrior:
    mov dword [hero_max_health], 100
    mov dword [hero_health], 100
    mov dword [hero_attack], 20
    mov dword [hero_potions], 2
    ret
.mage:
    mov dword [hero_max_health], 70
    mov dword [hero_health], 70
    mov dword [hero_attack], 30
    mov dword [hero_potions], 3
    ret

display_main_menu:
    mov ecx, main_menu
    call print_cstr
    ret

display_status:
    mov ecx, status_title
    call print_cstr
    mov ecx, hero_label
    call print_cstr
    mov ecx, [hero_name]
    call print_cstr
    mov ecx, newline
    call print_cstr
    mov ecx, class_label
    call print_cstr
    call display_class
    mov ecx, health_label
    call print_cstr
    mov eax, [hero_health]
    call print_uint
    mov ecx, newline
    call print_cstr
    mov ecx, max_health_label
    call print_cstr
    mov eax, [hero_max_health]
    call print_uint
    mov ecx, newline
    call print_cstr
    mov ecx, attack_label
    call print_cstr
    mov eax, [hero_attack]
    call print_uint
    mov ecx, newline
    call print_cstr
    mov ecx, potions_label
    call print_cstr
    mov eax, [hero_potions]
    call print_uint
    mov ecx, newline
    call print_cstr
    mov ecx, gold_label
    call print_cstr
    mov eax, [hero_gold]
    call print_uint
    mov ecx, newline
    call print_cstr
    mov ecx, room_label
    call print_cstr
    mov eax, [current_room]
    call print_uint
    mov ecx, newline
    call print_cstr
    ret

display_class:
    mov eax, [hero_class]
    cmp eax, 1
    je .w
    cmp eax, 2
    je .m
    mov ecx, archer_text
    jmp .print
.w:
    mov ecx, warrior_text
    jmp .print
.m:
    mov ecx, mage_text
.print:
    call print_cstr
    mov ecx, newline
    call print_cstr
    ret

display_inventory:
    mov ecx, inventory_title
    call print_cstr
    mov ecx, inventory_potions
    call print_cstr
    mov eax, [hero_potions]
    call print_uint
    mov ecx, newline
    call print_cstr
    mov ecx, inventory_gold
    call print_cstr
    mov eax, [hero_gold]
    call print_uint
    mov ecx, newline
    call print_cstr
    ret

explore_dungeon:
    mov eax, [current_room]
    cmp eax, 1
    je .goblin
    cmp eax, 2
    je .treasure
    cmp eax, 3
    je .dragon
    ret
.goblin:
    mov ecx, room_one
    call print_cstr
    mov ecx, goblin_art
    call print_cstr
    mov dword [enemy_health], 30
    mov dword [enemy_damage], 10
    mov dword [enemy_name], goblin_art
    call battle_enemy
    cmp eax, 1
    jne .done
    mov dword [current_room], 2
    mov ecx, next_room
    call print_cstr
    ret
.treasure:
    cmp dword [chest_done], 1
    je .treasure_finished
    mov ecx, room_two
    call print_cstr
    mov ecx, treasure_art
    call print_cstr
.chest_loop:
    mov ecx, chest_prompt
    call print_cstr
    mov ecx, input_buffer
    mov edx, 32
    call read_line
    mov ecx, input_buffer
    call parse_int
    cmp eax, 1
    je .open
    cmp eax, 2
    je .leave
    mov ecx, invalid_chest
    call print_cstr
    jmp .chest_loop
.open:
    add dword [hero_gold], 50
    mov dword [chest_done], 1
    mov ecx, chest_opened
    call print_cstr
    jmp .advance
.leave:
    mov dword [chest_done], 1
    mov ecx, chest_left
    call print_cstr
.advance:
    mov dword [current_room], 3
    mov ecx, next_room
    call print_cstr
    ret
.treasure_finished:
    mov dword [current_room], 3
    ret
.dragon:
    mov ecx, room_three
    call print_cstr
    mov ecx, dragon_art
    call print_cstr
    mov dword [enemy_health], 60
    mov dword [enemy_damage], 15
    call battle_enemy
    cmp eax, 1
    jne .done
    call display_game_result
.done:
    ret

battle_enemy:
.battle_loop:
    mov ecx, combat_menu
    call print_cstr
    mov ecx, input_buffer
    mov edx, 32
    call read_line
    mov ecx, input_buffer
    call parse_int
    cmp eax, 1
    je .attack
    cmp eax, 2
    je .defend
    cmp eax, 3
    je .potion
    cmp eax, 4
    je .run
    mov ecx, invalid_combat
    call print_cstr
    jmp .battle_loop
.attack:
    mov ecx, attack_msg
    call print_cstr
    mov eax, [hero_attack]
    sub [enemy_health], eax
    cmp dword [enemy_health], 0
    jle .win
    call enemy_retaliate
    jmp .check_loss
.defend:
    mov ecx, defend_msg
    call print_cstr
    mov dword [defend_flag], 1
    call enemy_retaliate
    jmp .check_loss
.potion:
    call use_potion
    jmp .battle_loop
.run:
    mov ecx, run_msg
    call print_cstr
    xor eax, eax
    ret
.check_loss:
    cmp dword [hero_health], 0
    jle .loss
    jmp .battle_loop
.win:
    mov ecx, enemy_defeated
    call print_cstr
    mov eax, 1
    ret
.loss:
    call display_game_over
    call terminate_program

enemy_retaliate:
    mov eax, [enemy_damage]
    cmp dword [defend_flag], 1
    jne .damage_ready
    sub eax, 5
    cmp eax, 0
    jge .damage_ready
    xor eax, eax
.damage_ready:
    mov ebx, eax
    mov ecx, enemy_hit
    call print_cstr
    mov eax, ebx
    call print_uint
    mov ecx, damage_end
    call print_cstr
    sub [hero_health], ebx
    cmp dword [hero_health], 0
    jg .show
    mov dword [hero_health], 0
.show:
    mov dword [defend_flag], 0
    ret

use_potion:
    cmp dword [hero_potions], 0
    jle .empty
    dec dword [hero_potions]
    mov eax, [hero_health]
    cmp eax, [hero_max_health]
    jge .full
    add eax, 20
    cmp eax, [hero_max_health]
    jle .store
    mov eax, [hero_max_health]
.store:
    mov [hero_health], eax
    mov ecx, potion_used
    call print_cstr
    ret
.full:
    mov ecx, potion_full
    call print_cstr
    ret
.empty:
    mov ecx, no_potions
    call print_cstr
    ret

display_game_result:
    mov ecx, victory_msg
    call print_cstr
    mov ecx, [hero_name]
    call print_cstr
    mov ecx, victory_end
    call print_cstr
    mov eax, [hero_gold]
    call print_uint
    mov ecx, newline
    call print_cstr
    mov ecx, health_label
    call print_cstr
    mov eax, [hero_health]
    call print_uint
    mov ecx, newline
    call print_cstr
    call terminate_program

display_game_over:
    mov ecx, health_zero
    call print_cstr
    mov ecx, game_over_msg
    call print_cstr
    ret

read_line:
    push ebx
    push edx
    mov eax, 3
    xor ebx, ebx
    int 0x80
    pop edx
    pop ebx
    cmp eax, 0
    jle .done
    mov edi, ecx
    add edi, eax
    dec edi
    cmp byte [edi], 10
    jne .terminate
    mov byte [edi], 0
    ret
.terminate:
    mov byte [ecx + eax], 0
.done:
    ret

parse_int:
    xor eax, eax
    xor ebx, ebx
.next:
    mov bl, [ecx]
    cmp bl, 0
    je .finish
    cmp bl, '0'
    jb .finish
    cmp bl, '9'
    ja .finish
    imul eax, eax, 10
    sub bl, '0'
    add eax, ebx
    inc ecx
    jmp .next
.finish:
    ret

print_uint:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov edi, number_buffer + 15
    mov byte [edi], 0
    cmp eax, 0
    jne .convert
    dec edi
    mov byte [edi], '0'
    jmp .write
.convert:
    xor edx, edx
    mov ebx, 10
.digit:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz .digit
.write:
    mov ecx, edi
    mov edx, number_buffer + 15
    sub edx, edi
    mov eax, 4
    mov ebx, 1
    int 0x80
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

print_cstr:
    push eax
    push ebx
    push edx
    push esi
    mov esi, ecx
    xor edx, edx
.length:
    cmp byte [esi + edx], 0
    je .write
    inc edx
    jmp .length
.write:
    mov eax, 4
    mov ebx, 1
    int 0x80
    pop esi
    pop edx
    pop ebx
    pop eax
    ret

exit_program:
    mov ecx, exit_msg
    call print_cstr
    call terminate_program

terminate_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
