; nasm -f elf32 LABEXER3.asm -o LABEXER3.o
; ld -m elf_i386 LABEXER3.o -o LABEXER3
; ./LABEXER3 .

%macro PRINT 1
    mov esi, %1
    call print_z
%endmacro

%macro PRINT_BUF 1
    mov esi, %1
    call print_z
%endmacro

%macro NL 0
    PRINT newline
%endmacro

%macro SEP 0
    PRINT separator
%endmacro

section .data
    title_border db "==========================", 10, 0
    title        db "COR / TUITION FEE CALCULATOR", 10, 0
    separator    db "==========================", 10, 0
    tuition_sep  db "==========================", 10, 0
    student_info db "STUDENT INFORMATION", 10, 0
    courses_title db "COURSE CODE", 9, "TITLE", 10, 0
    courses_list db "CCS9021    INFORMATION MANAGEMENT (LEC)", 10
                 db "CCS9021L   INFORMATION MANAGEMENT (LAB)", 10
                 db "CS9001     DISCRETE STRUCTURES 1", 10
                 db "CS9003     COMPUTER SYSTEMS & ARCHITECTURE", 10
                 db "CS9003L    COMPUTER SYSTEMS & ARCHITECTURE (LAB)", 10
                 db "CS0070     OBJECT ORIENTED PROGRAMMING", 10
                 db "CS0070L    OBJECT ORIENTED PROGRAMMING-LAB", 10
                 db "GED0021    SPECIALIZED ENGLISH PROGRAM 2", 10
                 db "GED0075    LINEAR ALGEBRA", 10
                 db "GED0081    COLLEGE PHYSICS 1 LECTURE", 10
                 db "GED0081L   COLLEGE PHYSICS 1 LABORATORY", 10, 0
    newline      db 10, 0

    menu_header  db 10, "===============================", 10
                 db "            COR", 10
                 db "===============================", 10, 0
    menu_items   db "1. Input  - Input the details", 10
                 db "2. Output - Display the full info", 10
                 db "3. Write  - Write the full details into a file", 10
                 db "4. Read   - Read the content of the file", 10
                 db "5. Exit", 10, 0
    p_choice     db "Enter your choice: ", 0
    invalid_choice db "Invalid choice. Please enter 1 to 5.", 10, 0
    file_name    db "COR_details.txt", 0
    file_saved   db "Full details written to COR_details.txt.", 10, 0
    file_read_error db "Unable to read COR_details.txt. Write the file first.", 10, 0
    file_write_error db "Unable to write COR_details.txt.", 10, 0

    p_student    db "Student number: ", 0
    p_name       db "Full name: ", 0
    p_year       db "Year level (1-4): ", 0
    p_phone      db "Phone number: ", 0
    p_zip        db "Zip code: ", 0
    p_college    db "College: ", 0
    p_program    db "Program: ", 0
    p_address    db "Address: ", 0
    p_units      db "Total units: ", 0
    p_labs       db "Number of lab courses: ", 0
    invalid_num  db "Invalid input. Please enter a valid whole number.", 10, 0
    invalid_year db "Invalid year level. Enter a number from 1 to 4.", 10, 0

    l_student    db "Student # : ", 0
    l_name       db "Name : ", 0
    l_phone      db "Phone : ", 0
    l_zip        db "Zip Code : ", 0
    l_year       db "Year Level : ", 0
    l_college    db "College : ", 0
    l_program    db "Program : ", 0
    l_address    db "Address : ", 0
    total_label  db "TOTAL TUITION FEE : ", 0
    php_label    db " PHP", 10, 0

section .bss
    student     resb 64
    full_name   resb 128
    year_text   resb 16
    phone       resb 32
    zip_code    resb 16
    college     resb 128
    program     resb 128
    address     resb 256
    units_text  resb 16
    labs_text   resb 16
    year_value  resd 1
    units_value resd 1
    labs_value  resd 1
    tuition     resd 1
    choice_text resb 8
    file_buffer resb 2048

section .text
    global _start

_start:
menu_loop:
    PRINT menu_header
    PRINT menu_items
    PRINT p_choice
    mov edi, choice_text
    mov esi, 8
    call read_line
    mov esi, choice_text
    call parse_uint
    jc invalid_menu
    cmp eax, 1
    je input_details
    cmp eax, 2
    je output_details
    cmp eax, 3
    je write_details
    cmp eax, 4
    je read_details
    cmp eax, 5
    je exit_program

invalid_menu:
    PRINT invalid_choice
    jmp menu_loop

input_details:
    call input_all_details
    jmp menu_loop

output_details:
    call output_all_details
    jmp menu_loop

write_details:
    call write_all_details
    jmp menu_loop

read_details:
    call read_all_details
    jmp menu_loop

input_all_details:
    PRINT title_border
    PRINT title
    PRINT title_border
    PRINT p_student
    mov edi, student
    mov esi, 64
    call read_line

    PRINT p_name
    mov edi, full_name
    mov esi, 128
    call read_line

year_input:
    PRINT p_year
    mov edi, year_text
    mov esi, 16
    call read_line
    mov esi, year_text
    call parse_uint
    jc bad_year
    cmp eax, 1
    jb bad_year
    cmp eax, 4
    ja bad_year
    mov [year_value], eax
    jmp year_done

bad_year:
    PRINT invalid_year
    jmp year_input

year_done:
    PRINT p_phone
    mov edi, phone
    mov esi, 32
    call read_line

    PRINT p_zip
    mov edi, zip_code
    mov esi, 16
    call read_line

    PRINT p_college
    mov edi, college
    mov esi, 128
    call read_line
    mov esi, college
    call uppercase

    PRINT p_program
    mov edi, program
    mov esi, 128
    call read_line
    mov esi, program
    call uppercase

    PRINT p_address
    mov edi, address
    mov esi, 256
    call read_line

    jmp units_input

output_all_details:
    SEP
    PRINT student_info
    SEP
    PRINT l_student
    PRINT_BUF student
    NL
    PRINT l_name
    PRINT_BUF full_name
    NL
    PRINT l_phone
    PRINT_BUF phone
    NL
    PRINT l_zip
    PRINT_BUF zip_code
    NL
    PRINT l_year
    mov eax, [year_value]
    call print_uint
    NL
    PRINT l_college
    PRINT_BUF college
    NL
    PRINT l_program
    PRINT_BUF program
    NL
    PRINT l_address
    PRINT_BUF address
    NL
    SEP
    PRINT courses_title
    SEP
    PRINT courses_list
    SEP
    PRINT p_units
    mov eax, [units_value]
    call print_uint
    NL
    PRINT p_labs
    mov eax, [labs_value]
    call print_uint
    NL
    PRINT total_label
    mov eax, [tuition]
    call print_uint
    PRINT php_label
    SEP
    ret

units_input:
    PRINT p_units
    mov edi, units_text
    mov esi, 16
    call read_line
    mov esi, units_text
    call parse_uint
    jc bad_units
    mov [units_value], eax
    jmp units_done

bad_units:
    PRINT invalid_num
    jmp units_input

units_done:
labs_input:
    PRINT p_labs
    mov edi, labs_text
    mov esi, 16
    call read_line
    mov esi, labs_text
    call parse_uint
    jc bad_labs
    mov [labs_value], eax
    jmp labs_done

bad_labs:
    PRINT invalid_num
    jmp labs_input

labs_done:
    mov eax, [units_value]
    mov ebx, [labs_value]
    call calculate_tuition
    mov [tuition], eax
    call output_all_details
    ret

write_all_details:
    call build_file_buffer
    mov eax, 5
    mov ebx, file_name
    mov ecx, 577
    mov edx, 0644o
    int 0x80
    test eax, eax
    js .error
    mov ebx, eax
    mov eax, 4
    mov ecx, file_buffer
    mov edx, edi
    int 0x80
    mov eax, 6
    int 0x80
    PRINT file_saved
    ret
.error:
    PRINT file_write_error
    ret

read_all_details:
    mov eax, 5
    mov ebx, file_name
    xor ecx, ecx
    xor edx, edx
    int 0x80
    test eax, eax
    js .error
    mov ebx, eax
    mov eax, 3
    mov ecx, file_buffer
    mov edx, 2047
    int 0x80
    push eax
    push ebx
    mov byte [file_buffer + eax], 0
    PRINT file_buffer
    pop ebx
    pop eax
    mov eax, 6
    int 0x80
    PRINT newline
    ret
.error:
    PRINT file_read_error
    ret

build_file_buffer:
    mov edi, file_buffer
    mov esi, student_info
    call append_z
    mov esi, l_student
    call append_z
    mov esi, student
    call append_z
    mov esi, newline
    call append_z
    mov esi, l_name
    call append_z
    mov esi, full_name
    call append_z
    mov esi, newline
    call append_z
    mov esi, l_phone
    call append_z
    mov esi, phone
    call append_z
    mov esi, newline
    call append_z
    mov esi, l_zip
    call append_z
    mov esi, zip_code
    call append_z
    mov esi, newline
    call append_z
    mov esi, l_year
    call append_z
    mov eax, [year_value]
    call append_uint
    mov esi, newline
    call append_z
    mov esi, l_college
    call append_z
    mov esi, college
    call append_z
    mov esi, newline
    call append_z
    mov esi, l_program
    call append_z
    mov esi, program
    call append_z
    mov esi, newline
    call append_z
    mov esi, l_address
    call append_z
    mov esi, address
    call append_z
    mov esi, newline
    call append_z
    mov esi, p_units
    call append_z
    mov eax, [units_value]
    call append_uint
    mov esi, newline
    call append_z
    mov esi, p_labs
    call append_z
    mov eax, [labs_value]
    call append_uint
    mov esi, newline
    call append_z
    mov esi, total_label
    call append_z
    mov eax, [tuition]
    call append_uint
    mov esi, php_label
    call append_z
    mov byte [edi], 0
    mov eax, edi
    sub eax, file_buffer
    mov edi, eax
    ret

append_z:
.loop:
    mov al, [esi]
    inc esi
    test al, al
    jz .done
    mov [edi], al
    inc edi
    jmp .loop
.done:
    ret

append_uint:
    push eax
    mov esi, units_text + 15
    mov byte [esi], 0
    mov ebx, 10
.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec esi
    mov [esi], dl
    test eax, eax
    jnz .convert
    call append_z
    pop eax
    ret

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

read_line:
    mov eax, 3
    xor ebx, ebx
    mov ecx, edi
    mov edx, esi
    dec edx
    int 0x80
    test eax, eax
    jle .empty
    mov ecx, eax
    xor edx, edx
.scan:
    cmp edx, ecx
    jae .terminate
    cmp byte [edi + edx], 10
    je .terminate
    inc edx
    jmp .scan
.terminate:
    mov byte [edi + edx], 0
    ret
.empty:
    mov byte [edi], 0
    ret

calculate_tuition:
    imul eax, 1000
    imul ebx, 600
    add eax, ebx
    ret

uppercase:
.next:
    mov al, [esi]
    test al, al
    jz .done
    cmp al, 'a'
    jb .skip
    cmp al, 'z'
    ja .skip
    sub byte [esi], 32
.skip:
    inc esi
    jmp .next
.done:
    ret

parse_uint:
    xor eax, eax
    xor ecx, ecx
    xor edi, edi
.digit:
    mov dl, [esi + ecx]
    test dl, dl
    jz .finish
    cmp dl, '0'
    jb .invalid
    cmp dl, '9'
    ja .invalid
    sub dl, '0'
    mov ebx, eax
    lea eax, [eax + eax * 4]
    add eax, eax
    movzx edx, dl
    add eax, edx
    inc ecx
    inc edi
    jmp .digit
.finish:
    test edi, edi
    jz .invalid
    clc
    ret
.invalid:
    stc
    ret

print_z:
    mov edi, esi
    xor edx, edx
.count:
    cmp byte [edi + edx], 0
    je .write
    inc edx
    jmp .count
.write:
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 0x80
    ret

print_uint:
    mov edi, units_text + 15
    mov byte [edi], 0
    mov ebx, 10
.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz .convert
    mov esi, edi
    call print_z
    ret