	#313374837 Noam Tzuberi
.section        .rodata
char_format:           .string " %c"
int_format:            .string " %d"
string_format:         .string " %s"
end_string:            .string "/0"
pstrlen_format:        .string "first pstring length: %d, second pstring length: %d\n"
replace_char_format:   .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
invalid_input:         .string "invalid input!\n"
pstrijcpy_char_format: .string "length: %d, string: %s\n"
pstrijcmp_char_format: .string "compare result: %d\n"
default:               .string "invalid option!\n"

.text


.globl pstrlen
.type  pstrlen,    @function
pstrlen:
    movzbq  (%rdi), %rax        # the first place is the length
    ret

.globl swap_case
.type swap_case,    @function
swap_case:
     pushq %rbp
     movq  %rsp,%rbp
     leaq (%rdi),%r8                   # save the adrres to the string

.back_loop_swap_case:                  # loop for changing the letters
     inc   %rdi
     cmpb  $0,(%rdi)
     je .finish_swap_case
     cmpb  $65,(%rdi)                  # to check once if smaller then the first letter in ascci
     jl .back_loop_swap_case           # if not move the next letter
     cmpb  $122,(%rdi)                 # to check once if smaller then the last letter in ascci
     jg .back_loop_swap_case           # if not move the next letter
     cmpb  $91,(%rdi)                  # check if small or equal to Z - if yes it need changed
     jl .change_little                 # change to little char
     cmpb  $96,(%rdi)                  # check if big or equal to z - if yes it need changed
     jg  .change_big                   # change to big char
     jmp .back_loop_swap_case          # move next char



.change_big:
    subb $32,(%rdi)                    # sub 32 for the char it change it to big
    jmp .back_loop_swap_case           # move next char
.change_little:

    addb $32,(%rdi)                    # add 32 for the char it change it to big
    jmp .back_loop_swap_case           # move next char



.finish_swap_case:

    movq %r8,%rax                     # return the string after change
    movq %rsp,%rbp
    pop  %rbp
    ret


.globl replaceChar
.type  replaceChar,    @function
replaceChar:
    pushq %rbp
    movq  %rsp, %rbp
    movq  %rdi,%rcx               # save the point to the string in rcx

.back_loop_replace:               # move all the letters
    incq %rdi                     # move the next char
    cmpb $0,(%rdi)                # check if end the string
    je .end_string                # finish the func
    cmpb %sil,(%rdi)              # check if is ti th letters that we wnt to change
    jne .back_loop_replace        # if not move the next char
    movb %dl,(%rdi)               # change the char
    jmp .back_loop_replace


.end_string:
    movq  %rcx,%rax               # end the string return the string
    movq  %rbp, %rsp              # finish the func
    popq  %rbp
    ret


.globl pstrijcpy
.type  pstrijcpy,    @function
pstrijcpy:
    pushq  %rbp
    movq   %rsp, %rbp
    movq  %rdi,%r14         # save the pointer to the string

    movzbq (%rdi),%r8       # save the legth of the first string
    cmpq   %r8 ,%rdx        # checking if bigger than the start index
    jge  .invalid_input
    cmpq   %r8,%rcx         # checking if bigger than the last index
    jge  .invalid_input

    movzbq (%rsi),%r9       # save the legth of the second string
    cmpq   %r9,%rdx         # checking if bigger than the start index
    jge  .invalid_input
    cmpq   %r9,%rcx         # checking if bigger than the last index
    jge  .invalid_input

    cmp   %rdx,%rcx         # check if the i,j not valid-  if the index not right order
    jg  .invalid_input

    incq %rdi               # move to the string( jump from the length) for first string
    incq %rsi               # move to the string( jump from the length) for second string
    leaq (%rdi,%rcx),%rdi   # jump the first index in first string
    leaq (%rsi,%rcx),%rsi   # jump the first index in second string

.back_loop_pstrijcpy:
    cmp   %rdx,%rcx         # checking if pass all the index
    jg    .finish_pstrijcpy # if the same jump the end
    movb  (%rsi),%r11b      # save the current char
    movb  %r11b,(%rdi)
    incq  %rdi              # increasing place of the index of the strings
    incq  %rsi
    incq  %rcx              # increase the check index
    jmp   .back_loop_pstrijcpy

.finish_pstrijcpy:
    movq   %r14,%rax        # move the pointer of the string to the return value
    movq   %rbp,%rsp
    popq   %rbp
    ret


.invalid_input:
    xorq %rax,%rax
    movq $invalid_input,%rdi   # print invalid input
    call printf


    movq   %r14,%rax           # finish the func  and return the pointer to the string
    movq   %rbp,%rsp
    popq   %rbp
    ret

.globl pstrijcmp
.type pstrijcmp,    @function
pstrijcmp:
    pushq  %rbp
    movq   %rsp, %rbp

    movzbq (%rdi),%r8                # save the legth of the first string
    cmpq   %r8 ,%rcx                 # checking if bigger than the start index
    jge  .invalid_input_pstrijcmp
    cmpq   %r8,%rdx                  # checking if bigger than the last index
    jge  .invalid_input_pstrijcmp

    movzbq (%rsi),%r9                # save the legth of the first string
    cmpq   %r9,%rcx                  # checking if bigger than the start index
    jge  .invalid_input_pstrijcmp
    cmpq   %r9,%rdx                  # checking if bigger than the last index
    jge  .invalid_input_pstrijcmp

    cmp   %rcx,%rdx                  # check if the i,j not valid-  if the index not right order
    jg  .invalid_input_pstrijcmp

    leaq (%rdi,%rdx),%rdi            # jump the first index in first string
    leaq (%rsi,%rdx),%rsi            # jump the first index in second string
    xorq %rax,%rax

    xor %r8,%r8                      # set r8, r9 to zero
    xor %r9,%r9

    movq $1,%r8                      # put value in r8= 1, r9=-1
    movq $-1,%r9

.back_loop_pstrijcmp:
    cmp  %rdx,%rcx                   # check if the index are equal
    jl  .finish_pstrijcmp            # if the first bigger than last finish
    incq %rdi                        # increasing the index and the pointer of char
    incq %rsi
    incq %rdx
    movzbq (%rdi),%r11               # the char of the first string
    movzbq (%rsi),%r12               # the char of the first string
    cmpq  %r11,%r12                  # check who is bigger
    je   .back_loop_pstrijcmp

    cmovl %r8,%rax                   # if less move 1
    cmovg %r9,%rax                   # if greater move 1

    movq %rsp,%rbp
    popq %rbp
    ret


.finish_pstrijcmp:                   # finish the func
    movq   %rbp,%rsp
    popq   %rbp
    ret


.invalid_input_pstrijcmp:
    movq $invalid_input,%rdi         # format for invalid
    call printf
    movq  $-2,%r8                    # return -2
    movq   %r8,%rax                  # return the pointer to the string
    movq   %rbp,%rsp
    popq   %rbp
    ret
    
