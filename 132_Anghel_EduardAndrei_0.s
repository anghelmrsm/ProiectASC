.data
    citire1: .asciz "%ld"
    citire2: .asciz "%ld %ld"
    afisare: .asciz "%ld\n"
    afisare_add: .asciz "%ld: (%ld, %ld)\n"
    afisare_get: .asciz "(%ld, %ld)\n"
    afisare_delete: .asciz "%ld: (%ld, %ld)\n"
    i: .long 0
    j: .long 0
    n: .long 0
    v: .space 1024
    f: .space 100000
    aux: .long 0
    op: .long 0
    nr: .long 0
    left: .long 0
    right: .long 0
    desc: .long 0
    desc1: .byte 0
    value: .long 0
    i_it: .long 0
    i_it_add: .long 0
    var: .long 0
    valoare: .long 0
    val: .long 0
    size: .long 0
    max_size: .long 0
    ok: .long 0
.text

et_add:
    pushl $nr
    pushl $citire1
    call scanf
    popl %ebx
    popl %ebx

    movl $0,i_it_add
    et_loop_op1:
        incl i_it_add

        pushl $desc
        pushl $citire1
        call scanf
        popl %ebx
        popl %ebx

        pushl $value
        pushl $citire1
        call scanf
        popl %ebx
        popl %ebx

        /*avem in size valoarea sizeului pe care trebuie sa il adaugam*/
        xorl %edx,%edx
        movl value,%eax
        addl $7,%eax
        movl $8,%ebx
        divl %ebx
        movl %eax,size

        movl $1024,%eax

        cmpl %eax,size
        jg et_afis00

        subl size,%eax
        movl %eax,max_size
        incl max_size
        movl $0,i

        

        et_verif_interval:
            movl i,%ebx
            movl %ebx,left
            movl left,%ebx
            addl size,%ebx
            movl %ebx,right
            movl left,%ecx
            et_verif_0_interval:
                mov (%edi,%ecx,1),%al

                cmp $0,%al
                jne et_inc_i

                incl %ecx
                cmpl %ecx,right
                jne et_verif_0_interval

                jmp et_uppdate_interval

            et_uppdate_interval:
                movl left,%ecx

                et_uppdate:
                    mov desc,%al
                    mov %al,(%edi,%ecx,1)

                    incl %ecx

                    cmpl %ecx,right
                    jne et_uppdate

                    jmp et_afis_add

            et_inc_i:
                incl i
                movl i,%ebx

                cmpl %ebx,max_size
                jg et_verif_interval

                cmpl %ebx,max_size
                je et_afis00

                jmp et_verif_loop1
        
        et_afis_add:
            decl right

            pushl right
            pushl left
            pushl desc
            pushl $afisare_add
            call printf
            popl %ebx
            popl %ebx
            popl %ebx
            popl %ebx

            jmp et_verif_loop1
        
        et_afis00:
            pushl $0
            pushl $0
            pushl desc
            pushl $afisare_add
            call printf
            popl %ebx
            popl %ebx
            popl %ebx
            popl %ebx


        et_verif_loop1:
            movl i_it_add,%ebx
            cmpl %ebx,nr
            jne et_loop_op1
            

    jmp et_verif_n

et_get:
    
    pushl $value
    pushl $citire1
    call scanf
    popl %ebx
    popl %ebx

    xorl %ecx,%ecx
    movl $0,left
    movl $0,right
    movl $1024,%ebx

    et_search_left:
        mov (%edi,%ecx,1),%al

        cmp value,%al
        je et_inside

        incl %ecx

        cmpl %ecx,%ebx
        jne et_search_left


    et_outside:
        jmp et_afisare

    et_inside:
        movl %ecx,left
        et_search_right:

            incl %ecx

            cmpl %ecx,%ebx
            je et_right_is_1024

            mov (%edi,%ecx,1),%al

            cmp %al,value
            je et_search_right

            movl %ecx,right
            jmp et_afisare

        et_right_is_1024:
            movl $1024,right
            jmp et_afisare


    et_afisare:
        cmpl $0,right
        je et_incl_get
        decl right
        pushl right
        pushl left
        pushl $afisare_get
        call printf
        popl %ebx
        popl %ebx
        popl %ebx
        incl right
        jmp et_verif_n
    
    et_incl_get:
        incl right
        jmp et_afisare



et_delete:
    pushl $value
    pushl $citire1
    call scanf
    popl %ebx
    popl %ebx

    xorl %ecx,%ecx
    movl $0,left
    movl $0,right
    movl $1024,%ebx

    et_search_left1:
        mov (%edi,%ecx,1),%al

        cmp value,%al
        je et_inside1

        incl %ecx

        cmpl %ecx,%ebx
        jne et_search_left1


    et_outside1:
        jmp et_afisare1

    et_inside1:
        movl %ecx,left

        et_search_right1:
            xor %al,%al
            mov %al,(%edi,%ecx,1)
            incl %ecx

            cmpl %ecx,%ebx
            je et_right_is_10241

            mov (%edi,%ecx,1),%al

            cmp %al,value
            je et_search_right1

            movl %ecx,right
            jmp et_afisare1

            et_right_is_10241:
                movl $1024,right
                jmp et_afisare1


    et_afisare1:
        xorl %ecx,%ecx
        movl $0,left
        movl $0,right

        et_search_values:
            mov (%edi,%ecx,1),%al
            mov %al,val

            cmpl $0,val
            jne et_afis_val

            mov $1024,%ebx
            cmpl %ecx,%ebx
            je et_verif_n

            incl %ecx
            jmp et_search_values

            et_afis_val:

                movl %ecx,left

                et_search_right_delete:

                    incl %ecx

                    movl $1024,%ebx
                    cmpl %ecx,%ebx
                    je et_right_is_1024_delete

                    mov (%edi,%ecx,1),%al

                    cmp %al,val
                    je et_search_right_delete

                    movl %ecx,right
                    jmp et_afisare_delete

                    et_right_is_1024_delete:
                        movl $1024,right
                
            et_afisare_delete:
                movl %ecx,i
                cmpl $0,right
                je et_incl_delete
                decl right
                pushl right
                pushl left
                pushl val
                pushl $afisare_delete 
                call printf
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx
                incl right
                movl i,%ecx

                jmp et_search_values
            
            et_incl_delete:
                incl right
                jmp et_afisare_delete



et_defragmentation:
    xorl %eax,%eax
    xorl %ecx,%ecx
    movl $1024,max_size

    et_loop:
        mov (%edi,%ecx,1),%dl

        cmp $0,%dl
        je et_iterations

        mov %dl,%bl
        mov $0,%bh
        mov %bh,(%edi,%ecx,1)
        mov %bl,(%edi,%eax,1)
        incl %eax

        et_iterations:
            incl %ecx
            cmpl %ecx,max_size
            jne et_loop

    xorl %ecx,%ecx
    xorl %eax,%eax
    et_afisare2:
        xorl %ecx,%ecx
        movl $0,left
        movl $0,right

        et_search_values2:
            mov (%edi,%ecx,1),%al
            mov %al,val

            cmpl $0,val
            jne et_afis_val2

            mov $1024,%ebx
            cmpl %ecx,%ebx
            je et_verif_n

            incl %ecx
            jmp et_search_values2

            et_afis_val2:

                movl %ecx,left

                et_search_right_defragmentation:

                    incl %ecx

                    movl $1024,%ebx
                    cmpl %ecx,%ebx
                    je et_right_is_1024_defragmentation

                    mov (%edi,%ecx,1),%al

                    cmp %al,val
                    je et_search_right_defragmentation

                    movl %ecx,right
                    jmp et_afisare_defragmentation

                    et_right_is_1024_defragmentation:
                        movl $1024,right
                
            et_afisare_defragmentation:
                movl %ecx,i
                cmpl $0,right
                je et_incl_defragmentation
                decl right
                pushl right
                pushl left
                pushl val
                pushl $afisare_delete 
                call printf
                popl %ebx
                popl %ebx
                popl %ebx
                popl %ebx
                incl right
                movl i,%ecx

                jmp et_search_values2
            
            et_incl_defragmentation:
                incl right
                jmp et_afisare_defragmentation



.global main
main:

et_citire_n:
    pushl $n 
    pushl $citire1
    call scanf
    popl %ebx
    popl %ebx

lea v,%edi

xorl %ecx,%ecx
et_n_iterations:
    incl i_it

    pushl $op
    pushl $citire1
    call scanf
    popl %ebx
    popl %ebx

    cmpl $1,op
    je et_add

    cmpl $2,op
    je et_get

    cmpl $3,op
    je et_delete

    cmpl $4,op
    je et_defragmentation

    et_verif_n:
        movl i_it,%ebx
        cmpl %ebx,n
        jne et_n_iterations


et_exit:
    pushl $0
    call fflush
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

.section .note.GNU-stack,"",@progbits
