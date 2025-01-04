.data
    n: .long 0
    desc: .long 0
    value: .long 0
    op: .long 0
    i_it: .long 0
    nr: .long 0
    i_it_add: .long 0
    mat: .space 1048576
    citire: .asciz "%ld"
    afisare: .asciz "%ld "
    afisare_get: .asciz "((%ld, %ld), (%ld, %ld))\n"
    afisare_interval: .asciz "%ld: ((%ld, %ld), (%ld, %ld))\n"
    afisare_ij: .asciz "(%ld %ld)\n"
    endl: .asciz "\n"
    i: .long 0
    j: .long 0
    size: .long 0
    curr_size: .long 0
    nr_it: .long 0
    columns: .long 1024
    lines: .long 1023
    left: .long 0
    right: .long 0
    aux_desc: .long 0
    max_size: .long 0
    val: .long 0
    copie1: .long 0
    copie2: .long 0
    aux_byte: .byte 0
    left_afis: .long 0
    right_afis: .long 0
    ok: .long 0
    aux_value: .long 0

.text

ADD:
    pushl %ebp
    movl %esp,%ebp

    mov 16(%ebp),%al
    movl 8(%ebp),%edx
    movl %edx,left
    movl 12(%ebp),%edx
    movl %edx,right

    et_loop_uppdate_interval:
        movl left,%ecx

        mov %al,(%edi,%ecx,1)

        incl left
        
        movl left,%ebx
        cmpl %ebx,right
        jne et_loop_uppdate_interval
    
    popl %ebp
    ret


PRINT_ADD:
    pushl %ebp
    movl %esp,%ebp

    xorl %eax,%eax
    xorl %edx,%edx
    movl 8(%ebp),%eax
    divl columns
    pushl %edx
    pushl %eax

    xorl %eax,%eax
    xorl %edx,%edx
    movl 12(%ebp),%eax
    divl columns
    pushl %edx
    pushl %eax

    xorl %eax,%eax
    movl 16(%ebp),%eax

    pushl %eax
    pushl $afisare_interval
    call printf
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    popl %eax

    popl %ebp
    ret    


PRINT_MATRIX:
    movl $0,i 
    et_loop_i_afis:
            movl $0,curr_size
            movl $0,j
            et_loop_j_afis:
                /avem in eax pozitia mat[i][j]/
                xorl %eax,%eax
                movl i,%eax
                mull columns
                addl j,%eax
                
                xorl %ebx,%ebx
                mov (%edi,%eax,1),%bl
                
                push %ebx
                pushl $afisare
                call printf
                popl %ebx
                popl %ebx

                /daca j==1024 se termina al 2 lea for/
                et_verif_j_afis:
                    xorl %edx,%edx
                    incl j
                    mov columns,%edx
                    cmpl %edx,j
                    jne et_loop_j_afis
        
            /daca i==1024 se termina primul for/
            et_verif_loop_i_afis:
                pushl $endl
                call printf
                popl %ebx

                xorl %edx,%edx
                incl i
                mov lines,%edx
                cmpl %edx,i
                jne et_loop_i_afis
    
    ret


GET_INTERVAL:
    pushl %ebp
    movl %esp,%ebp

    /*avem in max_size */
    movl 8(%ebp),%ebx
    movl %ebx,aux_desc
    movl lines,%eax
    mull columns
    movl %eax,max_size
    incl max_size

    xorl %ecx,%ecx
    movl $0,left
    movl $0,right
    et_loop_get:
        mov (%edi,%ecx,1),%al

        cmp aux_desc,%al
        je et_loop_afis_get

        incl %ecx

        cmpl %ecx,max_size
        je et_loop_afis_get_00

        jmp et_loop_get
    
    et_loop_afis_get:
        movl %ecx,left

        et_search_right_get:
            incl %ecx
            mov (%edi,%ecx,1),%al

            cmp %al,aux_desc
            je et_search_right_get
        
        decl %ecx
        movl %ecx,right

        xorl %eax,%eax
        xorl %edx,%edx
        movl right,%eax
        divl columns
        pushl %edx
        pushl %eax

        xorl %eax,%eax
        xorl %edx,%edx
        movl left,%eax
        divl columns
        pushl %edx
        pushl %eax

        pushl $afisare_get
        call printf
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx

        popl %ebp
        ret
        

    et_loop_afis_get_00:
        pushl $0
        pushl $0
        pushl $0
        pushl $0
        pushl $afisare_get
        call printf
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx

        popl %ebp
        ret
    

DELETE_INTERVAL:
    pushl %ebp
    movl %esp,%ebp
    movl 8(%ebp),%ebx
    movl %ebx,aux_desc

    xorl %ecx,%ecx
    movl $0,left
    movl $0,right
    et_loop_delete:
        mov (%edi,%ecx,1),%al

        cmp aux_desc,%al
        je et_search_right_delete

        incl %ecx

        cmpl %ecx,max_size
        je et_exit_delete

        jmp et_loop_delete
    
    et_search_right_delete:
        movl %ecx,left

        et_init_right:
            incl %ecx
            mov (%edi,%ecx,1),%al

            cmp %al,aux_desc
            je et_init_right
        
        
        movl %ecx,right

    movl left,%ecx
    et_delete_interval:
        mov $0,%al
        mov %al,(%edi,%ecx,1)

        incl %ecx

        cmp %ecx,right
        jne et_delete_interval
    
    et_exit_delete:
        popl %ebx
        ret

PRINT_INTERVALS:
    movl lines,%eax
    mull columns
    movl %eax,max_size
    incl max_size
    movl $0,left
    movl $0,right
    xorl %ecx,%ecx
    et_search_values:
        mov (%edi,%ecx,1),%al
        mov %al,val

        cmpl $0,val
        jne et_afis_val

        mov max_size,%ebx
        cmpl %ecx,%ebx
        je et_final_afis

        incl %ecx
        jmp et_search_values

        et_afis_val:

            movl %ecx,left

            et_search_right:

                incl %ecx

                movl max_size,%ebx
                cmpl %ecx,%ebx
                je et_right_is_max_size

                mov (%edi,%ecx,1),%al

                cmp %al,val
                je et_search_right

                movl %ecx,right
                jmp et_afisare

                et_right_is_max_size:
                    movl max_size,%ebx
                    movl %ebx,right
                
            et_afisare:
                movl %ecx,i
                cmpl $0,right
                je et_incl
                decl right

                movl %ebx,copie1
                movl %ecx,copie2
                xorl %eax,%eax
                xorl %edx,%edx
                movl right,%eax
                divl columns
                pushl %edx
                pushl %eax

                xorl %eax,%eax
                xorl %edx,%edx
                movl left,%eax
                divl columns
                pushl %edx
                pushl %eax

                pushl val
                pushl $afisare_interval
                call printf
                popl %eax
                popl %eax
                popl %eax
                popl %eax
                popl %eax
                popl %eax
                movl copie1,%ebx
                movl copie2,%ecx

                jmp et_search_values
            
            et_incl:
                incl right
                jmp et_afisare

    et_final_afis:
        ret

INIT0_cmat:
    mov $0,%al
    xorl %ecx,%ecx
    movl $1048576,%ebx

    et_loop_init:
        mov %al,(%esi,%ecx,1)
        incl %ecx
        cmpl %ecx,%ebx
        jne et_loop_init
    
    ret

/*DEFRAGMENTATION:
    pushl %ebp
    movl %esp,%ebp

    movl 8(%ebp),desc*/


DEFRAGMENTATION_add:
    pushl %ebp
    movl %esp,%ebp

    xorl %ebx,%ebx
    movl 8(%ebp),%ebx
    movl %ebx,aux_value
    xorl %ebx,%ebx
    movl 12(%ebp),%ebx
    movl %ebx,aux_desc

    xorl %ebx,%ebx
    movl aux_value,%ebx
    movl %ebx,size
    movl $0,i
    movl $0,ok
    et_loop_i_defrag:
        movl $0,curr_size
        movl $0,j
        et_loop_j_defrag:
            /avem in eax pozitia mat[i][j]/
            xorl %eax,%eax
            movl i,%eax
            mull columns
            addl j,%eax

            /verificare mat[i][j]==0/
            mov (%edi,%eax,1),%bl
            cmp $0,%bl
            jne init_curr_size_0_defrag

            incl curr_size

            /comparam size cu curr_size/
            movl curr_size,%ebx
            cmpl size,%ebx
            jne et_verif_j_defrag

            /in eax vom avea left = first_j=j-size+1/
            xorl %edx,%edx
            movl %eax,%edx
            subl size,%edx
            incl %edx
            movl %edx,left

            /in ebx vom avea right = j+1/
            movl %eax,%ebx
            incl %ebx
            movl %ebx,right

            /pun desc pe interval/
            xorl %eax,%eax
            mov aux_desc,%al
            movl left,%ecx
            et_loop_uppdate:

                mov %al,(%edi,%ecx,1)

                incl %ecx
                cmpl %ecx,right
                jne et_loop_uppdate

            decl right
            xorl %eax,%eax
            xorl %edx,%edx
            movl right,%eax
            divl columns
            pushl %edx
            pushl %eax

            xorl %eax,%eax
            xorl %edx,%edx
            movl left,%eax
            divl columns
            pushl %edx
            pushl %eax

            pushl aux_desc
            pushl $afisare_interval
            call printf
            popl %eax
            popl %eax
            popl %eax
            popl %eax
            popl %eax
            popl %eax

            
            jmp et_exit_defrag

            init_curr_size_0_defrag:
                movl $0,curr_size

            /daca j==1024 se termina al 2 lea for/
            et_verif_j_defrag:
                xorl %edx,%edx
                incl j
                mov columns,%edx
                cmpl %edx,j
                jne et_loop_j_defrag
            
        /daca i==1024 se termina primul for/
        et_verif_loop_i_defrag:
            xorl %edx,%edx
            incl i
            mov lines,%edx
            cmpl %edx,i
            jne et_loop_i_defrag

    et_exit_defrag:
        movl right,%ecx
        incl %ecx
        popl %ebp
        ret


.global main
main:

et_citire_n:
    pushl $nr_it
    pushl $citire
    call scanf
    popl %ebx
    popl %ebx

lea mat,%edi

movl $0,i_it
et_loop_iterations:
    incl i_it

    pushl $op
    pushl $citire
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
        cmpl %ebx,nr_it
        jne et_loop_iterations
        
        jmp et_exit

et_add:
    pushl $nr
    pushl $citire
    call scanf
    popl %ebx
    popl %ebx

    movl $0,i_it_add
    et_loop_op1:
        incl i_it_add

        pushl $desc
        pushl $citire
        call scanf
        popl %ebx
        popl %ebx

        pushl $value
        pushl $citire
        call scanf
        popl %ebx
        popl %ebx

        xorl %edx,%edx
        movl value,%eax
        addl $7,%eax
        movl $8,%ebx
        divl %ebx
        movl %eax,size

        movl $0,i
        movl $0,ok
        et_loop_i:
            movl $0,curr_size
            movl $0,j
            et_loop_j:
                /avem in eax pozitia mat[i][j]/
                xorl %eax,%eax
                movl i,%eax
                mull columns
                addl j,%eax

                /verificare mat[i][j]==0/
                mov (%edi,%eax,1),%bl
                cmp $0,%bl
                jne init_curr_size_0

                incl curr_size

                /comparam size cu curr_size/
                movl curr_size,%ebx
                cmpl size,%ebx
                jne et_verif_j

                /in edx vom avea left = first_j=j-size+1/
                xorl %edx,%edx
                movl %eax,%edx
                subl size,%edx
                incl %edx

                /in ebx vom avea right = j+1/
                movl %eax,%ebx
                incl %ebx

                movl %edx,left_afis
                movl %ebx,right_afis
                decl right_afis

                /pun valoarea desc pe intervalul j-size+1,j+1/
                pushl desc
                pushl %ebx
                pushl %edx
                call ADD
                popl %ebx
                popl %ebx
                popl %ebx

                movl $1,ok
                pushl desc
                pushl left_afis
                pushl right_afis
                call PRINT_ADD
                popl %ebx
                popl %ebx
                popl %ebx

                jmp  et_verif_loop_1
                
                init_curr_size_0:
                    movl $0,curr_size

                /daca j==1024 se termina al 2 lea for/
                et_verif_j:
                    xorl %edx,%edx
                    incl j
                    mov columns,%edx
                    cmpl %edx,j
                    jne et_loop_j
        
            /daca i==1024 se termina primul for/
            et_verif_loop_i:
                xorl %edx,%edx
                incl i
                mov lines,%edx
                cmpl %edx,i
                jne et_loop_i

        cmpl $0,ok
        jne et_verif_loop_1

        et_afis00:
            pushl desc
	        pushl $0
            pushl $0
	        call PRINT_ADD
            popl %ebx
	        popl %ebx 
	        popl %ebx
        
        et_verif_loop_1:
            movl i_it_add,%ebx                                                                         
            cmpl %ebx,nr
            jne et_loop_op1
    

    /call PRINT_MATRIX/
    /call PRINT_INTERVALS/ 
    
    jmp et_verif_n   


et_get:
    pushl $desc
    pushl $citire
    call scanf
    popl %ebx
    popl %ebx

    pushl desc
    call GET_INTERVAL
    popl %ebx

    jmp et_verif_n

et_delete:
    pushl $desc
    pushl $citire
    call scanf
    popl %ebx
    popl %ebx

    pushl desc
    call DELETE_INTERVAL
    popl %ebx

    /call PRINT_MATRIX/
    call PRINT_INTERVALS

    jmp et_verif_n

et_defragmentation:

    xorl %ecx,%ecx
    et_search:
        cmpl $1048576,%ecx
        je et_verif_j_defragmentation

        xorl %eax,%eax
        mov (%edi,%ecx,1),%al

        cmp $0,%al
        je et_increase

        movl %eax,desc

        movl %ecx,left

        xorl %ebx,%ebx
        et_right:
            mov (%edi,%ecx,1),%bl
            incl %ecx

            cmp %al,%bl
            je et_right
        
        /avem in left si right capetele intervalului/
        /iar in value calculam size-ul intervalului/
        movl %ecx,%ebx
        subl left,%ebx
        movl %ebx,value
        decl value

        movl %ecx,i
        pushl desc
        call DELETE_INTERVAL
        popl %ebx
        movl i,%ecx

        movl %ecx,i
        pushl desc
        pushl value
        call DEFRAGMENTATION_add
        popl %ebx
        popl %ebx

        jmp et_search

    et_increase:
        incl %ecx
        jmp et_search

    et_verif_j_defragmentation:
        /*call PRINT_INTERVALS*/
        jmp et_verif_n




et_exit:

    pushl $0
    call fflush
    popl %ebx
    
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

.section .note.GNU-stack,"",@progbits



