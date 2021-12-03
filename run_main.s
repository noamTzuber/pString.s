	#313374837 Noam Tzuberi
.section        .rodata
char_format:           .string  " %c"
int_format:            .string " %d"
string_format:         .string " %s"
.text

.globl run_main
.type  run_main,    @function
run_main:
    movq %rsp, %rbp         # for correct debugging
    pushq %rbp
    movq  %rsp, %rbp        # for correct debugging
    subq  $528,%rsp         # givng space for the two strings
    xorq  %rax,%rax         # for scanf rax = 0
    movq  $int_format, %rdi # the format for int
    leaq  -528(%rbp), %rsi  # the place of the length of the first string
    call  scanf

    xorq  %rax,%rax             # for scanf rax = 0
    movq  $string_format, %rdi  # the format for string
    leaq  -527(%rbp), %rsi      # scanf the firs string
    call  scanf
    xorq  %rcx,%rcx
    movb  -528(%rbp), %cl        # save the legth of first string
    leaq  -527(%rbp, %rcx), %r10 # move the end first string
    movq  $0, (%r10)             # put zero in the end of the string



    ######################
    xorq  %rax,%rax
    movq  $int_format, %rdi # the format for int
    leaq  -271(%rbp), %rsi  # the place of the length of the second string
    call  scanf


    xorq  %rax,%rax
    movq  $string_format, %rdi   # the format for string
    leaq  -270(%rbp), %rsi       # scanf the second string
    call  scanf
    xorq  %rcx,%rcx
    movb  -271(%rbp), %cl        # save the legth of second string
    leaq  -270(%rbp, %rcx), %r10 # move the end second string
    movq  $0, (%r10)             # put zero in the end of the string

###################

    xorq  %rax,%rax
    movq  $int_format, %rdi       # format for the int choose
    leaq  -14(%rbp), %rsi         # scanf the chosse for the switch table
    call  scanf


    # for moving the a
    xorq  %rdx,%rdx
    movl -14(%rbp), %edx          # move the arguments for the run_func
    leaq -528(%rbp), %rdi         # rdi= first str. rsi= second str
    leaq -271(%rbp), %rsi
    call run_func

    xorq  %rax,%rax
    movq  %rbp, %rsp
    popq  %rbp
    ret
