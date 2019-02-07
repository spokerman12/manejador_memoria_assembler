# casos de prueba proy 1 SD17
	#.include "macros.s"

	.data
mifin: .asciiz "FIN"
###########################################
	.text
	#Caso 5: 1pto
	#print_strv("Caso 5 vale 1 punto")

  	#  init 32
  	li $s6, 1      # indica la actividad actual
  	
  	#print_strf(sepa)
	#print_strv("Init con 32 bytes\n")  	
  	
  	li $a0, 32
  	jal init
  	
  	bnez $v0, fin_falla
  	
  	#print_strv("manejador tiene los 32 bytes\n")  	
  	
  	#  malloc 8 bytes 
  	#print_strf(sepa)
  	#print_strv("malloc con 8 \n")
  	li $s6, 2      # indica la actividad actual
	li $a0, 8
	jal malloc
	move $s0, $v0     #Guardo direccion retornada por malloc
	
	blez $v0, fin_falla
	
	#print_strv("malloc de 8 OK\n")	

  	#  malloc 4 bytes 
  	#print_strf(sepa)
  	#print_strv("malloc con 4 \n")
  	li $s6, 3      # indica la actividad actual
	li $a0, 4
	jal malloc
	
	blez $v0, fin_falla
	
	#print_strv("malloc de 4 OK\n")	
	  		
	  			  			  		
	#  realloc 20
	#print_strf(sepa)
	#print_strv("Realloc de 8 a 20 \n")
  	li $s6, 4      # indica la actividad actual
  	
  	move $a0, $s0
  	li $a1 20
	jal reallococ
	
	#  verificar que no hay espacio
	blez $v0 fin_falla
	#print_strv("Tengo el espaio de realloc OK!!!\n")

  	#  2do malloc 8 bytes
  	#print_strf(sepa) 
  	#print_strv("2do malloc con 8 \n")
  	li $s6, 2      # indica la actividad actual
	li $a0, 8
	jal malloc
	move $s0, $v0     #Guardo direccion retornada por malloc
	
	blez $v0, fin_falla
	
	#print_strv("2do malloc de 8 OK\n")	

								
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

