# casos de prueba proy 1 SD17
	#.include "macros.s"

	.data
A400:	.word 0 
A100:	.word 0 
A50:	.word 0 
mifin: .asciiz "FIN"	
###########################################
	.text
	#Caso 6: 2ptos
	#print_strv("Caso 6 vale 2 puntos")

  	#  init 500
  	li $s6, 1      # indica la actividad actual
  	
  	#print_strf(sepa)
	#print_strv("Init con 500 bytes\n")  	
  	
  	li $a0, 500
  	jal init
  	
  	bnez $v0, fin_falla
  	
  	#print_strv("manejador tiene los 500 bytes\n")  	
  	#print_strf(sepa)
  	
  	#  malloc 400 (arreglo de 100 enteros)
  	#print_strv("malloc con 400\n")
  	li $s6, 2      # indica la actividad actual
	li $a0, 400
	jal malloc
	
	blez $v0, fin_falla
	sw $v0 A400
	
	#print_strv("malloc ok\n")	
	  	
	#  generar 100 enteros y colocarlos en el arreglo
	#print_strf(sepa)
	#print_strv("Voy a llenar arreglo\n")
  	li $s6, 3      # indica la actividad actual

	li $s0 100
	lw $s1, A400
	li $s2, 1
	
populateA100:
	sw $s2, ($s1)
	
	addi $s2 $s2 5
	addi, $s0 $s0 -1
	addi $s1, $s1, 4
	bnez $s0, populateA100
	
	#  imprimir Arreglo
	#print_strf(sepa)
	#print_strv("imprimir valores\n")
  	li $s6, 4      # indica la actividad actual
  	li $s0 100
	lw $s1, A400
	li $s7 1
printA100:
	#print_strv("Pos ")
	#print_int($s7)
	#print_strv(": ")
	
	lw $a0, ($s1)
	#print_int($a0)
	#print_strf(lf)

	addi, $s0 $s0 -1
	addi $s1, $s1, 4
	addi $s7, $s7 1
	bnez $s0, printA100
	
	#  malloc 120
	#print_strf(sepa)
	#print_strv("Malloc con 120, debe fallar\n")
  	li $s6, 5      # indica la actividad actual
  	li $a0 120
	jal malloc
	
	#  verificar que no hay espacio
	bgez $v0 fin_falla
	#print_strv("No tengo 120 pq no hay espacio OK!!!\n")
			
	#  pedir para 100 y obtenerlos usarlos
	#print_strf(sepa)
	#print_strv("Malloc 100\n")
  	li $s6, 6      # indica la actividad actual
	li $a0 100
	jal malloc
		
	blez $v0, fin_falla
	sw $v0 A100
	#print_strv("Tengo los 100\n")
  	
	#  liberar el de 100
	#print_strf(sepa)
	#print_strv("Hago free de 100\n")
  	li $s6, 7      # indica la actividad actual
	lw $a0 A100
	jal free
	
	bltz $v0 fin_falla
	#print_strv("Libere\n")
	
	#  y pedir para 50 obtenerlos
	#print_strf(sepa)
	#print_strv("Malloc 50\n")
	li $s6, 8      # indica la actividad actual
	li $a0 50
	jal malloc
	
	bltz $v0, fin_falla
	sw $v0 A50
	#print_strv("tegno los 50\n")
	
	#print_strv("\nvalido las direcciones tengan sentido (debe darmenos de 500 que es el tamaño de la memoria\n")
	lw $s0 A400
	lw $s1 A100
	sub $s2 $s1 $s0
	abs $s2 $s2
	#print_strv("La diferencia en las direcciones de 400 y 100 es ")
	#print_int($s2)
	#print_strf(lf)
	lw $s1 A50
	sub $s2 $s1 $s0
	abs $s2 $s2
	#print_strv("La diferencia en las direcciones de 400 y 50 es ")
	#print_int($s2)
	#print_strf(lf)

	
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
	         	  
