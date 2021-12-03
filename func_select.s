		#313374837 Noam Tzuberi
.data
.section        .rodata
char_format:           .string " %c"                                                                   # the format for the labels and functions ->
int_format:            .string " %d"                                                                   # each format called by his using
string_format:         .string " %s"
end_string:            .string "/0"
pstrlen_format:        .string "first pstring length: %d, second pstring length: %d\n"
replace_char_format:   .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
invalid_input:         .string "invalid input!\n"
pstrijcpy_char_format: .string "length: %d, string: %s\n"
pstrijcmp_char_format: .string "compare result: %d\n"
default:               .string "invalid option!\n"


.align 8

.switch_case:                    # the table for choose the matck case
        .quad .case_50_60
        .quad .default
        .quad .case_52
        .quad .case_53
        .quad .case_54
        .quad .case_55
        .quad .default
        .quad .default
        .quad .default
        .quad .default
        .quad .case_50_60

.text
.globl run_func
.type  run_func,    @function
run_func:
    pushq %rbp
    movq  %rsp, %rbp
    subq  $50, %rdx               # sub 50 for find the match shoose
    cmpq  $10, %rdx               # if is bigger then 10
    ja   .default                 # if not in the range
    jmp  *.switch_case(,%rdx,8)   # choose the right option

.func_done:
    xorq  %rax,%rax               # end the func
    movq  %rbp, %rsp
    popq  %rbp
    ret


.case_50_60:

    call pstrlen                  # call the func
    movq %rax,%r10                # save number
    movq %rsi,%rdi                # call func again for the second string
    call pstrlen
    movq %rax,%r11                # save number
    movq $pstrlen_format, %rdi    # move the format for printf
    xorq %rax,%rax                # preper rax for printf
    movq %r10, %rsi               # move the arguments for the printf
    movq %r11, %rdx
    call printf

    xorq  %rax,%rax               # end the tab
    movq  %rbp, %rsp
    popq  %rbp

    jmp .func_done                # finish the func


 .case_52:

    pushq %rbp
    movq  %rbp, %rsp          # creating place in stack
    pushq %rbx                # for using 12,rbx
    pushq %r12
    subq  $16,%rsp            # space for two letters
    movq  %rdi,%rbx           # saving the strings because we need use this registers
    movq  %rsi,%r12
    xorq  %rax,%rax
    movq  $char_format, %rdi  # format for scan the letters - the first letter
    leaq  -32(%rbp), %rsi
    call  scanf

    xorq  %rax,%rax
    movq  $char_format, %rdi  # format for scan the letters - the second letter
    leaq  -24(%rbp), %rsi
    call  scanf

    movq  %rbx,%rdi           # arguments for replacechar - the first string
    movzbq  -32(%rbp),%rsi    # the first letter
    movzbq  -24(%rbp),%rdx    # the second letter
    call replaceChar
    movq %rax, %rbx           # saving the return argument


    movq  %r12,%rdi           # arguments for replacechar - the second string
    movzbq  -32(%rbp),%rsi    # the first letter
    movzbq  -24(%rbp),%rdx    # the second letter
    call replaceChar
    movq %rax, %r12           # saving the return argument

    xorq %rax,%rax                    # the part that print the new strings
    movq $replace_char_format,%rdi    # the wanted format
    movq -32(%rbp),%rsi               # the old and ne chars
    movq -24(%rbp),%rdx
    leaq 1(%rbx),%rcx                 # the strings
    leaq 1(%r12),%r8

    call printf

    popq %rax           # return the stack to how it was at first
    popq %rax           # pop the two chars
    popq %r12           # return rbx, r12 to the original value
    popq %rbx
    movq %rsp,%rbp      # finish the label
    popq %rbp
    jmp .func_done


.case_53:
    pushq %rbp
    movq  %rbp, %rsp
    pushq %rbx                # save rbx on stack
    pushq %r13                # save r13 on stack

    movq  %rdi,%rbx           # saving the string
    movq  %rsi,%r13
    subq  $16,%rsp            # open place on the stack for two numbers

    movq  $int_format, %rdi   # format for scannig number
    leaq  -32(%rbp), %rsi     # the first in the start of stack
    call  scanf

    movq  $int_format, %rdi   # format for scannig number
    leaq  -24(%rbp), %rsi
    call  scanf

    movq %rbx,%rdi            # move arguments for the func rbx,r13 - the strings
    movq %r13,%rsi
    movl -32(%rbp),%ecx       # move the start index of the strings
    movl -24(%rbp),%edx       # move the end index of the strings

    call pstrijcpy


    movq $pstrijcpy_char_format,%rdi    # the format of the print
    movzbq  (%rax),%rsi                 # the length
    leaq  1(%rax),%rdx                  # the string
    movq  %rax, %rax
    call printf

    movq $pstrijcpy_char_format,%rdi    # the format of the print
    movzbq  (%r13),%rsi                 # the length
    leaq  1(%r13),%rdx                  # the string
    movq  %rax, %rax
    call printf

    popq %rax           # pop the two numbers we saved
    popq %rax
    popq %r13           # return the original values to r13, rbx
    popq %rbx
    movq %rbp,%rsp
    popq %rbp
    jmp .func_done      #  finish the label


.case_54:
    pushq %rbp
    movq  %rsp, %rbp
    pushq %rsi          # svae the second string in the stack
    call swap_case      # call the func for the first string

    movq  $pstrijcpy_char_format,%rdi       # the format of the printing - same format as pstringcpy
    movzbq (%rax),%rsi                      # move the legth
    leaq  1(%rax),%rdx                      # move the string
    xorq  %rax, %rax
    call printf

    popq %rdi                               # pop the rsi we saved- the second string
    xor  %rax,%rax
    call swap_case                          # call the func for the second string


    movq  $pstrijcpy_char_format,%rdi       # the format of the printing -  same format as pstringcpy
    movzbq (%rax),%rsi                      # move the legth
    leaq  1(%rax),%rdx                      # move the string
    xorq  %rax, %rax
    call printf

    xorq %rax,%rax
    movq %rbp,%rsp
    popq %rbp
    jmp .func_done                          #  finish the label


.case_55:
    pushq %rbp
    movq  %rbp, %rsp
    pushq %rbx                # save rbx on stack
    pushq %r12                # save r12 on stack

    movq  %rdi,%rbx           # saving the first string
    movq  %rsi,%r12           # saving the second string
    subq  $16,%rsp            # give place for two numbers in the struct

    movq  $int_format, %rdi  # scanf the first index
    leaq  -32(%rbp), %rsi    # the place in stack
    call  scanf

    movq  $int_format, %rdi  # scanf the second index
    leaq  -24(%rbp), %rsi    # the place in stack
    call  scanf

    movq %rbx,%rdi          # move arguments for the func
    movq %r12,%rsi          # moving the two strings
    movl -32(%rbp),%edx     # moving the index
    movl -24(%rbp),%ecx
    call pstrijcmp


    movq  $pstrijcmp_char_format,%rdi  # print the format of this func
    movq  %rax,%rsi                    # move the rsult
    xorq  %rax, %rax
    call printf                        # print the result
    jmp .func_done


.default:
    xor %rax,%rax                      # if the chose want one of the option
    movq $default,%rdi                 # print "invalid inpup!"
    call printf
    jmp .func_done
