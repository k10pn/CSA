; nasm -f elf32 MP1_Zodiac_Horoscope.asm -o MP1_Zodiac_Horoscope.o
; gcc -m32 -no-pie MP1_Zodiac_Horoscope.o -o MP1_Zodiac_Horoscope
; ./MP1_Zodiac_Horoscope

global main
extern printf
extern scanf
extern fgets
extern getchar
extern stdin
extern exit

section .data

    ; -------------------- WELCOME SCREEN --------------------
    welcome_title db 10, "𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟", 10
                  db "        THE MYSTIC ZODIAC ORACLE", 10
                  db "𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟", 10
                  db 0
    welcome_title_len equ $ - welcome_title

    ; WELCOME ASCII ART
    welcome_art db 9, "        .", 10
                db 9, "       .O.", 10
                db 9, "      .OOO.", 10
                db 9, "~oooooOOOOOooooo~", 10
                db 9, "  `OOOOOOOOOOO`", 10
                db 9, "    `OOOOOOO`", 10
                db 9, "    OOOO'OOOO", 10
                db 9, "   OOO'   'OOO", 10
                db 9, "  O'         'O", 10
                db   0
    welcome_art_len equ $ - welcome_art

    welcome_footer db "𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟", 10
                   db " ★⁺˚⋆｡°✩₊ DISCOVER YOUR DESTINY!", 10
                   db "𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟", 10, 10, 0

    name_prompt db "Enter your name: ", 0
    month_prompt db "Enter birth month (1-12): ", 0
    day_prompt db "Enter birth day (1-31): ", 0
    name_format db "%63s", 0
    integer_format db "%d", 0

    invalid_month db 10, "Invalid month. Please enter a value from 1 to 12.", 10, 0
    invalid_date db 10, "Invalid date for that month. Please try again.", 10, 0

    hello_format db 10, "Welcome, %s!", 10, 0
    sign_heading db 10, "𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟", 10
                 db " ଘ(੭ ᐛ )━☆ﾟ.*･｡ﾟ YOUR ZODIAC SIGN", 10
                 db "𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟", 10, 0
    sign_format db "Zodiac Sign: %s", 10
                db "Element: %s", 10
                db "Symbol: %s", 10
                db "Personality: %s", 10, 0

    ; sign-specific ascii art 
    art_capricorn db "    ____,-._", 10
                  db  " ,-`___ `-. `.", 10
                  db  "/,';-```.  `. \", 10
                  db  "  '   ___\   ``-.", 10
                  db  "      \___`      \", 10
                  db "        /   ,`9   \", 10
                  db "      _/           `.", 10
                  db "  --```       __     _)", 10
                  db "              (`-.__/", 10
                  db "             /-`", 10
                  db "            (", 10
                  db  0
    art_aquarius  db "                      ___", 10
                  db  "              _..._ .'.--'", 10
                  db  "             '----.` '.", 10
                  db  "          _..._   /   o`\", 10
                  db  "        .'     `'` '. __.'", 10
                  db  "       /    -.       \", 10
                  db  "      |      | |     |", 10
                  db  "     {      /.--\  \/ \", 10
                  db  "      `\,  /_ `\ `\ \\ '.", 10
                  db  "        '--. `\`   \ '.``", 10
                  db  "            ```     ```", 10
                  db  0
    art_pisces    db "         __", 10
                  db  "      _,'_(", 10
                  db  "   ,-'     `-._", 10
                  db  " ,'            \  ,-')", 10
                  db  "/(o)  ,-.       `'  /", 10
                  db  ">    )_.'       ,.  \", 10
                  db  "`-._         _,-' `-.'", 10
                  db  "    `-( \---'", 10
                  db  "       `'", 10
                  db  0
    art_aries     db "   _.-..", 10
                  db  " ,'9 )\)`-.,.--.", 10
                  db  " `-.|           `.", 10
                  db  "    \,      ,    \)", 10
                  db  "     `.  )._\   (\", 10
                  db  "       |//   `-,//", 10
                  db  "      ]||    //`", 10
                  db  "       ``    `` ", 10
                  db  0
    art_taurus    db "  ,/         \,", 10
                  db  " ((__,-```-,__))", 10
                  db  "  `--)~   ~(--`", 10
                  db  " .-'(       )`-,", 10
                  db  " `~~`d\   /b`~~`", 10
                  db "     |     |", 10
                  db "     (6___6)", 10
                  db "      `---`", 10
                  db  0
    art_gemini    db "._____.", 10
                  db  "  | |", 10
                  db  "  | |", 10
                  db  " _|_|_", 10
                  db  "'     '", 10
                  db  0 
    art_cancer    db "   __       __", 10
                  db  "  / <`     '> \", 10
                  db  " (  / @   @ \  )", 10
                  db  "  \(_ _\_/_ _)/", 10
                  db  "(\ `-/     \-' /)", 10
                  db  " `===\     /===`", 10
                  db  "  .==')___(`==. ", 10
                  db  " ' .='     `=.", 10
                  db  0
    art_leo       db "   (``-/`)_.-````-._", 10
                  db  "    . . `; -._    )-;-,_`)", 10
                  db  "   (v_,)'  _  )`-.\  ``-`", 10
                  db  "  _.- _..-_/ / ((.`", 10
                  db  "((,.-`   ((,/    ", 10
                  db  0
    art_virgo     db " _", 10
                  db  "` `:--.--.", 10
                  db  "   |  |  |_     ", 10
                  db  "   |  |  | )", 10
                  db  "   |  |  |/", 10
                  db  "        (J", 10
                  db  0
    art_libra     db "     __", 10
                  db  "___.`  `.___   ", 10
                  db  "____________", 10
                  db  0
    art_scorpio   db " ___    ___", 10
                  db  "( _<    >_ )", 10
                  db  "//        \\", 10
                  db  "\\___..___//", 10
                  db  " `-(    )-'", 10
                  db  "   _|__|_", 10
                  db  "  /_|__|_\", 10
                  db  "  /_|__|_\", 10
                  db  "  /_\__/_\", 10
                  db  "   \ || /  _)", 10
                  db  "     ||   ( )", 10
                  db  "     \\___//", 10
                  db  "      `---'", 10
                  db  0
    art_sagittarius db "   (", 10
                    db  "    \", 10
                    db  "     )", 10
                    db  "##-------->", 10
                    db  "    /", 10
                    db  "   (", 10
                    db  0

    menu_text db 10, "𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟", 10
              db "[1] Love and Relationships", 10
              db "[2] Career and Studies", 10
              db "[3] Health and Wellness", 10
              db "[4] Lucky Number and Color", 10
              db "[5] View Zodiac Information", 10
              db "[6] Exit", 10
              db "Enter your choice: ", 0
    invalid_choice db 10, "Invalid selection. Choose 1 to 6.", 10, 0
    goodbye db 10, "𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟 ₊‧.°.⋆✮⋆.°.‧₊ 𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟", 10
            db "Thank you for consulting the Mystic Zodiac Oracle!", 10
            db 10, "𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟 ₊‧.°.⋆✮⋆.°.‧₊ 𓆝 𓆟 𓆞 𓆝 𓆟𓆝 𓆟 𓆞 𓆝 𓆟", 10, 0

    love_text db 10, "LOVE HOROSCOPE", 10
              db "✧˖°. 𓆝 𓆟 𓆞 𓆝 𓆟 𓆝 𓆟 𓆞 𓆝 𓆟 .°˖✧", 10
              db "%s, an honest conversation will strengthen an important relationship.", 10
              db "Be open to kindness and make time for someone special.", 10, 0
    career_text db 10, "CAREER HOROSCOPE", 10
                db "✧˖°. 𓆝 𓆟 𓆞 𓆝 𓆟 𓆝 𓆟 𓆞 𓆝 𓆟 .°˖✧", 10
                db "%s, your creativity will help you solve a difficult problem today.", 10
                db "Stay focused and confident!", 10, 0
    health_text db 10, "HEALTH HOROSCOPE", 10
                db "✧˖°. 𓆝 𓆟 𓆞 𓆝 𓆟 𓆝 𓆟 𓆞 𓆝 𓆟 .°˖✧", 10
                db "%s, remember to rest, hydrate, and give yourself time to recharge.", 10
                db "A balanced routine will improve your energy.", 10, 0
    lucky_text db 10, "LUCKY NUMBER AND COLOR", 10
               db "✧˖°. 𓆝 𓆟 𓆞 𓆝 𓆟 𓆝 𓆟 𓆞 𓆝 𓆟 .°˖✧", 10
               db "Lucky number: %d", 10
               db "Lucky color: %s", 10, 0
    return_text db 10, "Press ENTER to return to the menu.", 10, 0

    ; Zodiac names, elements, symbols, personalities, and lucky colors.
    zodiac_capricorn db "CAPRICORN", 0
    zodiac_aquarius db "AQUARIUS", 0
    zodiac_pisces db "PISCES", 0
    zodiac_aries db "ARIES", 0
    zodiac_taurus db "TAURUS", 0
    zodiac_gemini db "GEMINI", 0
    zodiac_cancer db "CANCER", 0
    zodiac_leo db "LEO", 0
    zodiac_virgo db "VIRGO", 0
    zodiac_libra db "LIBRA", 0
    zodiac_scorpio db "SCORPIO", 0
    zodiac_sagittarius db "SAGITTARIUS", 0

    elem_earth db "Earth", 0
    elem_air db "Air", 0
    elem_water db "Water", 0
    elem_fire db "Fire", 0
    symbol_goat db "Goat", 0
    symbol_waterbearer db "Water Bearer", 0
    symbol_fish db "Fish", 0
    symbol_ram db "Ram", 0
    symbol_bull db "Bull", 0
    symbol_twins db "Twins", 0
    symbol_crab db "Crab", 0
    symbol_lion db "Lion", 0
    symbol_maiden db "Maiden", 0
    symbol_scales db "Scales", 0
    symbol_scorpion db "Scorpion", 0
    symbol_archer db "Archer", 0

    pers_capricorn db "Disciplined, practical, ambitious.", 0
    pers_aquarius db "Independent, inventive, humanitarian.", 0
    pers_pisces db "Compassionate, imaginative, gentle.", 0
    pers_aries db "Energetic, bold, adventurous.", 0
    pers_taurus db "Patient, loyal, dependable.", 0
    pers_gemini db "Curious, adaptable, expressive.", 0
    pers_cancer db "Caring, protective, intuitive.", 0
    pers_leo db "Confident, creative, courageous.", 0
    pers_virgo db "Analytical, helpful, observant.", 0
    pers_libra db "Diplomatic, fair, charming.", 0
    pers_scorpio db "Passionate, focused, mysterious.", 0
    pers_sagittarius db "Optimistic, honest, freedom-loving.", 0

    color_red db "Red", 0
    color_orange db "Orange", 0
    color_yellow db "Yellow", 0
    color_green db "Green", 0
    color_blue db "Blue", 0
    color_purple db "Purple", 0

section .bss
    user_name resb 64
    birth_month resd 1
    birth_day resd 1
    zodiac_index resd 1       ; 0=Capricorn ... 11=Sagittarius
    menu_choice resd 1

section .text

main:
    call display_welcome
    call get_user_info
    call determine_zodiac
    push dword [zodiac_index]
    call display_zodiac_art
    add esp, 4

menu_loop:
    call display_menu
    cmp eax, 1
    je menu_show_horoscope
    cmp eax, 2
    je menu_show_horoscope
    cmp eax, 3
    je menu_show_horoscope
    cmp eax, 4
    je menu_show_horoscope
    cmp eax, 5
    je menu_show_info
    cmp eax, 6
    je menu_exit

    push invalid_choice
    call printf
    add esp, 4
    jmp menu_loop

menu_show_horoscope:
    push eax
    call show_horoscope
    add esp, 4
    call wait_for_enter
    jmp menu_loop

menu_show_info:
    call display_zodiac_info
    jmp menu_loop

menu_exit:
    call exit_program

; displays welcome screen
display_welcome:
    push ebp
    mov ebp, esp
    push welcome_title
    call printf
    add esp, 4
    push welcome_art
    call printf
    add esp, 4
    push welcome_footer
    call printf
    add esp, 4
    pop ebp
    ret

; reads name month day 
get_user_info:
    push ebp
    mov ebp, esp

read_again:
    push name_prompt
    call printf
    add esp, 4

    ; Reads names with spaces and periods.
    push dword [stdin]
    push 64
    push user_name
    call fgets
    add esp, 12

    call trim_name

    push month_prompt
    call printf
    add esp, 4

    push birth_month
    push integer_format
    call scanf
    add esp, 8

    cmp eax, 1
    je month_was_read

    call clear_input
    push invalid_month
    call printf
    add esp, 4
    jmp read_again

month_was_read:
    push day_prompt
    call printf
    add esp, 4

    push birth_day
    push integer_format
    call scanf
    add esp, 8

    cmp eax, 1
    je date_was_read

    call clear_input
    push invalid_date
    call printf
    add esp, 4
    jmp read_again

date_was_read:
    ; Consume the newline left by scanf.
    call clear_input

    call validate_birthdate
    cmp eax, 1
    je valid_input

    cmp eax, 2
    je bad_month

    push invalid_date
    call printf
    add esp, 4
    jmp read_again

bad_month:
    push invalid_month
    call printf
    add esp, 4
    jmp read_again

valid_input:
    push user_name
    push hello_format
    call printf
    add esp, 8

    pop ebp
    ret

; Removes the newline added by fgets.
trim_name:
    mov edx, user_name

trim_loop:
    mov al, [edx]

    cmp al, 0
    je trim_done

    cmp al, 10
    je terminate_name

    cmp al, 13
    je terminate_name

    inc edx
    jmp trim_loop

terminate_name:
    mov byte [edx], 0

trim_done:
    ret

; Removes invalid characters remaining in the input buffer.
clear_input:
clear_input_loop:
    call getchar

    cmp eax, 10
    je clear_input_done

    cmp eax, -1
    jne clear_input_loop

clear_input_done:
    ret

; returns EAX=1 valid, EAX=2 invalid month
validate_birthdate:
    mov eax, [birth_month]
    cmp eax, 1
    jl invalid_month_result
    cmp eax, 12
    jg invalid_month_result

    mov edx, [birth_day]
    cmp edx, 1
    jl invalid_day_result
    cmp edx, 31
    jg invalid_day_result

    ; Months with only 30 days: April, June, September, November.
    cmp eax, 4
    je thirty_day_month
    cmp eax, 6
    je thirty_day_month
    cmp eax, 9
    je thirty_day_month
    cmp eax, 11
    je thirty_day_month

    ; February accepts only days 1 through 28.
    cmp eax, 2
    jne valid_date_result
    cmp edx, 28
    jle valid_date_result
    jmp invalid_day_result

thirty_day_month:
    cmp edx, 30
    jle valid_date_result
    jmp invalid_day_result

invalid_month_result:
    mov eax, 2
    ret
invalid_day_result:
    xor eax, eax
    ret
valid_date_result:
    mov eax, 1
    ret


; identifies the sign using month/day ranges.
determine_zodiac:
    mov eax, [birth_month]
    mov edx, [birth_day]

    ; January 1-19 = Capricorn; January 20-31 = Aquarius.
    cmp eax, 1
    jne check_february
    cmp edx, 19
    jle set_capricorn
    jmp set_aquarius

check_february:
    cmp eax, 2
    jne check_march
    cmp edx, 18
    jle set_aquarius
    jmp set_pisces

check_march:
    cmp eax, 3
    jne check_april
    cmp edx, 20
    jle set_pisces
    jmp set_aries

check_april:
    cmp eax, 4
    jne check_may
    cmp edx, 19
    jle set_aries
    jmp set_taurus

check_may:
    cmp eax, 5
    jne check_june
    cmp edx, 20
    jle set_taurus
    jmp set_gemini

check_june:
    cmp eax, 6
    jne check_july
    cmp edx, 20
    jle set_gemini
    jmp set_cancer

check_july:
    cmp eax, 7
    jne check_august
    cmp edx, 22
    jle set_cancer
    jmp set_leo

check_august:
    cmp eax, 8
    jne check_september
    cmp edx, 22
    jle set_leo
    jmp set_virgo

check_september:
    cmp eax, 9
    jne check_october
    cmp edx, 22
    jle set_virgo
    jmp set_libra

check_october:
    cmp eax, 10
    jne check_november
    cmp edx, 22
    jle set_libra
    jmp set_scorpio

check_november:
    cmp eax, 11
    jne check_december
    cmp edx, 21
    jle set_scorpio
    jmp set_sagittarius

check_december:
    cmp edx, 21
    jle set_sagittarius
    jmp set_capricorn

set_capricorn: 
    mov dword [zodiac_index], 0
    ret

set_aquarius: 
    mov dword [zodiac_index], 1
    ret
    
set_pisces: 
    mov dword [zodiac_index], 2
    ret

set_aries: 
    mov dword [zodiac_index], 3
    ret

set_taurus: 
    mov dword [zodiac_index], 4
    ret

set_gemini: 
    mov dword [zodiac_index], 5
    ret

set_cancer: 
    mov dword [zodiac_index], 6
    ret

set_leo: 
    mov dword [zodiac_index], 7
    ret

set_virgo: 
    mov dword [zodiac_index], 8
    ret

set_libra: 
    mov dword [zodiac_index], 9
    ret

set_scorpio: 
    mov dword [zodiac_index], 10
    ret

set_sagittarius: 
    mov dword [zodiac_index], 11
    ret


; zodiac art
display_zodiac_art:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    cmp eax, 0
    je art_capricorn_branch
    cmp eax, 1
    je art_aquarius_branch
    cmp eax, 2
    je art_pisces_branch
    cmp eax, 3
    je art_aries_branch
    cmp eax, 4
    je art_taurus_branch
    cmp eax, 5
    je art_gemini_branch
    cmp eax, 6
    je art_cancer_branch
    cmp eax, 7
    je art_leo_branch
    cmp eax, 8
    je art_virgo_branch
    cmp eax, 9
    je art_libra_branch
    cmp eax, 10
    je art_scorpio_branch
    jmp art_sagittarius_branch

art_capricorn_branch: 
    push art_capricorn
    jmp print_art

art_aquarius_branch: 
    push art_aquarius 
    jmp print_art

art_pisces_branch: 
    push art_pisces
    jmp print_art

art_aries_branch: 
    push art_aries
    jmp print_art

art_taurus_branch: 
    push art_taurus
    jmp print_art

art_gemini_branch: 
    push art_gemini
    jmp print_art

art_cancer_branch: 
    push art_cancer
    jmp print_art

art_leo_branch: 
    push art_leo
    jmp print_art

art_virgo_branch: 
    push art_virgo
    jmp print_art

art_libra_branch: 
    push art_libra
    jmp print_art

art_scorpio_branch: 
    push art_scorpio
    jmp print_art

art_sagittarius_branch: 
    push art_sagittarius
    jmp print_art ; ummmmmmm

print_art:
    call printf
    add esp, 4
    call display_zodiac_info
    pop ebp
    ret


; prints sign, element, symbol, personality.
display_zodiac_info:
    push ebp
    mov ebp, esp
    push sign_heading
    call printf
    add esp, 4

    mov eax, [zodiac_index]
    ; Select sign data through a compact branch table.
    cmp eax, 0
    je info_capricorn
    cmp eax, 1
    je info_aquarius
    cmp eax, 2
    je info_pisces
    cmp eax, 3
    je info_aries
    cmp eax, 4
    je info_taurus
    cmp eax, 5
    je info_gemini
    cmp eax, 6
    je info_cancer
    cmp eax, 7
    je info_leo
    cmp eax, 8
    je info_virgo
    cmp eax, 9
    je info_libra
    cmp eax, 10
    je info_scorpio
    jmp info_sagittarius

info_capricorn: 
    push pers_capricorn
    push symbol_goat
    push elem_earth
    push zodiac_capricorn
    push sign_format
    jmp print_info

info_aquarius: 
    push pers_aquarius
    push symbol_waterbearer
    push elem_air
    push zodiac_aquarius
    push sign_format
    jmp print_info

info_pisces: 
    push pers_pisces
    push symbol_fish
    push elem_water
    push zodiac_pisces
    push sign_format
    jmp print_info

info_aries: 
    push pers_aries
    push symbol_ram
    push elem_fire
    push zodiac_aries
    push sign_format
    jmp print_info

info_taurus: 
    push pers_taurus
    push symbol_bull
    push elem_earth
    push zodiac_taurus
    push sign_format
    jmp print_info

info_gemini: 
    push pers_gemini
    push symbol_twins
    push elem_air
    push zodiac_gemini
    push sign_format
    jmp print_info

info_cancer: 
    push pers_cancer
    push symbol_crab
    push elem_water
    push zodiac_cancer
    push sign_format
    jmp print_info

info_leo: 
    push pers_leo
    push symbol_lion
    push elem_fire
    push zodiac_leo
    push sign_format
    jmp print_info

info_virgo: 
    push pers_virgo
    push symbol_maiden
    push elem_earth
    push zodiac_virgo
    push sign_format
    jmp print_info

info_libra:
    push pers_libra
    push symbol_scales
    push elem_air
    push zodiac_libra
    push sign_format
    jmp print_info

info_scorpio: 
    push pers_scorpio
    push symbol_scorpion
    push elem_water
    push zodiac_scorpio
    push sign_format
    jmp print_info

info_sagittarius: 
    push pers_sagittarius
    push symbol_archer
    push elem_fire
    push zodiac_sagittarius
    push sign_format

print_info:
    call printf
    add esp, 20
    pop ebp
    ret

; reads and returns the menu choice in EAX.
display_menu:
    push ebp
    mov ebp, esp
    push menu_text
    call printf
    add esp, 4
    push menu_choice
    push integer_format
    call scanf
    add esp, 8
    mov eax, [menu_choice]
    pop ebp
    ret

; receives menu choice and displays its category.
show_horoscope:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    cmp eax, 1
    je show_love
    cmp eax, 2
    je show_career
    cmp eax, 3
    je show_health
    cmp eax, 4
    je show_lucky
    ret

show_love:
    push user_name
    push love_text
    call printf
    add esp, 8
    pop ebp
    ret
show_career:
    push user_name
    push career_text
    call printf
    add esp, 8
    pop ebp
    ret
show_health:
    push user_name
    push health_text
    call printf
    add esp, 8
    pop ebp
    ret
show_lucky:
    mov eax, [zodiac_index]
    add eax, 7
    ; Use a fixed color selected through conditional branches.
    cmp eax, 8
    jle lucky_color_red
    cmp eax, 10
    jle lucky_color_orange
    cmp eax, 12
    jle lucky_color_yellow
    cmp eax, 14
    jle lucky_color_green
    cmp eax, 16
    jle lucky_color_blue
    jmp lucky_color_purple

lucky_color_red: 
    push color_red
    jmp print_lucky

lucky_color_orange: 
    push color_orange
    jmp print_lucky

lucky_color_yellow: 
    push color_yellow
    jmp print_lucky

lucky_color_green: 
    push color_green
    jmp print_lucky

lucky_color_blue: 
    push color_blue
    jmp print_lucky

lucky_color_purple: 
    push color_purple
    jmp print_lucky ; ummmmmmm

print_lucky:
    push eax
    push lucky_text
    call printf
    add esp, 12
    pop ebp
    ret

wait_for_enter:
    push return_text
    call printf
    add esp, 4
    call getchar
    call getchar
    ret

; terminates the program.
exit_program:
    push goodbye
    call printf
    add esp, 4
    push 0
    call exit