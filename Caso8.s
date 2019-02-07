# casos de prueba proy 1 SD17
	#.include "macros.s"
	.data

	
l: 	.word 0
l1:	.word 0
mifin: .asciiz "FIN"
###########################################
	.text
	#Caso 8: 2ptos
	#print_strv("Caso 8 vale 2 puntos")



  	#  init 400
  	li $s6, 1      # indica la actividad actual
  	
  	#print_strf(sepa)
	#print_strv("Init con 400 bytes\n")  	
  	
  	li $a0, 400
  	jal init
  	
  	bnez $v0, fin_falla
  	
  	#print_strv("manejador tiene los 300 bytes\n")  	
  	#print_strf(sepa)
  	
	#crear una lista 1
	#print_strv("Voy a crear lista\n")
	jal create
	
	bltz $v0, fin_falla
	sw $v0, l
	#print_strv("Cree lista 1\n")

	#crear lista 2
	#print_strv("Voy a crear lista\n")
	jal create
	
	bltz $v0, fin_falla
	sw $v0, l1
	#print_strv("Cree lista 2\n")
	
	#insertar 10 elementos de tipo par
	#print_strf(sepa)
	#print_strv("Poblando lista con 10 Pares\n")
	li $s1 1
	li $s2, 1
	li $s3, 2
insertLoop:
	
	move $a0, $s2
	move $a1, $s3
	jal par_create 
	
	bltz $v0, fin_falla
	move $s6 $v0
	
	lw $a0, l
	move $a1, $s6
	jal insert
	
	bltz $v0 fin_falla
	#print_strv("Inserte par ")
	#print_int($s1)
	#print_strv(" ")
	move $a0, $s6
	jal par_print
	#print_strf(lf)
	
	addi $s1 $s1 1
	add $s2, $s2, 1
	add $s3 $s3 1
	ble $s1, 10, insertLoop
	

	#insertar 10 elementos de tipo Estudiante
	#print_strf(sepa)
	#print_strv("Poblando lista con 10 Estudiantes\n")
	li $s1 1
	li $s2, 'A'
	li $s3, 20
	li $s4, 30
	
insertEstLoop:
	
	move $a0, $s2
	move $a1, $s3
	move $a2, $s4
	jal estudiante_create 
	
	bltz $v0, fin_falla
	move $s6 $v0
	
	lw $a0, l1
	move $a1, $s6
	jal insert
	
	bltz $v0 fin_falla
	#print_strv("Inserte estudiante ")
	#print_int($s1)
	#print_strv(" ")
	move $a0, $s6
	jal estudiante_print
	#print_strf(lf)
	
	addi $s1 $s1 1
	add $s2, $s2, 1
	add $s3 $s3 1
	add $s4 $s4 1
	ble $s1, 10, insertEstLoop
	
	#imprimir l1
	#print_strf(sepa)
	#print_strv("Voy a imprimir la lista con 10 Pares\n")
	lw $a0, l
	la $a1, par_print
	jal print

	#imprimir l2
	#print_strf(sepa)
	#print_strv("Voy a imprimir la lista con 10 Estudiantes\n")
	lw $a0, l1
	la $a1, estudiante_print
	jal print


	# voy a borrar pos 2
	#print_strf(sepa)
	#print_strv("Voy a borrar pos 2 de la lista de Pares\n")
	lw $a0, l
	li $a1 2
	jal delete

	# voy a borrar pos 9
	#print_strf(sepa)
	#print_strv("Voy a borrar pos 9 de la lista de Personas\n")
	lw $a0, l1
	li $a1 9
	jal delete

	#imprimi 
	#print_strf(sepa)
	#print_strv("Voy a imprimir la lista de pares de nuevo, debe desaparecer solo la posicion 2\n")
	lw $a0 l
	la $a1, par_print
	jal print
	
	#imprimi 
	#print_strf(sepa)
	#print_strv("Voy a imprimir la lista de estudiantes de nuevo, debe desaparecer solo la posicion 9\n")
	lw $a0 l1
	la $a1, estudiante_print
	jal print

	b fin_ok
	
	## FIN
fin_falla:
	move $a0 $v0
	jal perror
	
	#print_strv("Hubo un error en la ejecucion en ")
	#print_int($s6)
	#print_strv("\n")
			
fin_ok:	
	la $a0 mifin
	li $v0, 4
	syscall
	li $v0, 10
	syscall

	#.include "Manejador.s"
	.include "Lista.s" # esta linea le indica al ensamblador que 
	         	   # inserte en esta posicion el archivo lista.s
	         	   # Y como lista.s hace .include de manejador.s los dos
			   # archivos son insertados aqui al final de este archivo

	#.include "Manejador.s"
	         	  
	         	  

	# tad par
	.data
	
	.text
par_create:
	sw $fp   ($sp)
	sw $ra -4($sp)
	move $fp $sp
	add $sp $sp -8
	
	sw $a0 ($sp)
	add $sp $sp -4
	
	li $a0 8
	jal malloc 
	
	add $sp $sp 4
	lw $a0 ($sp)
	
	bltz $v0 par_create_fin
	
	sw $a0,  ($v0)
	sw $a1, 4($v0)

par_create_fin:
	move $sp $fp
	lw $fp   ($sp)
	lw $ra -4($sp)
	jr $ra	
	
par_print:
	sw $fp ($sp)
	move $fp $sp
	add $sp $sp -4
	
	move $t1 $a0
	
	#print_strv("(")
	lw $a0, ($t1)
	#print_int($a0)
	#print_strv(", ")
	lw $a0, 4($t1)
	#print_int($a0)
	#print_strv(")")

	move $sp $fp
	lw $fp ($sp)
	jr $ra	

# Estudiante
	# tad par
	.data
	
	.text
estudiante_create:
	sw $fp   ($sp)
	sw $ra -4($sp)
	move $fp $sp
	add $sp $sp -8
	
	sw $a0 ($sp)
	add $sp $sp -4
	
	li $a0 12
	jal malloc 
	
	add $sp $sp 4
	lw $a0 ($sp)
	
	bltz $v0 par_create_fin
	
	sb $a0,  ($v0)
	sw $a1, 4($v0)
	sw $a2, 8($v0)
	

estudiante_create_fin:
	move $sp $fp
	lw $fp   ($sp)
	lw $ra -4($sp)
	jr $ra	
	
estudiante_print:
	sw $fp ($sp)
	move $fp $sp
	add $sp $sp -4
	
	move $t1 $a0
	
	#print_strv("[")
	lb $a0, ($t1)
	#print_char($a0)
	#print_strv(", ")
	lw $a0, 4($t1)
	#print_int($a0)
	#print_strv(", ")
	lw $a0, 8($t1)
	#print_int($a0)
	#print_strv("]")

	move $sp $fp
	lw $fp ($sp)
	jr $ra	
