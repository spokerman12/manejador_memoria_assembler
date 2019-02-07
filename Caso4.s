# casos de prueba proy 1 SD17
	#.include "macros.s"

	.data
mifin: .asciiz "FIN"	
###########################################
	.text
	#Caso 4: 0.5pto
	#print_strv("Caso 4 vale 0.5 punto")

  	#  init 20
  	li $s6, 1      # indica la actividad actual
  	
  	#print_strf(sepa)
	#print_strv("Init con 20 bytes\n")  	
  	
  	li $a0, 20
  	jal init
  	
  	bnez $v0, fin_falla
  	
  	#print_strv("manejador tiene los 20 bytes\n")  	
  	
  	#  malloc 12 bytes 
  	#print_strf(sepa)
 	#print_strv("malloc con 12 \n")
  	li $s6, 2      # indica la actividad actual
	li $a0, 12
	jal malloc

	move $s0, $v0     #Guardo direccion retornada por malloc
	
	blez $v0, fin_falla
	
	#print_strv("malloc de 12 -- OK!!\n")	
	  		
  	#  malloc 4 bytes 
  	#print_strf(sepa)
  	#print_strv("malloc con 4 \n")
  	li $s6, 3      # indica la actividad actual
	li $a0, 4
	jal malloc
	
	blez $v0, fin_falla
	
	#print_strv("malloc de 4 -- OK!!\n")	

	#  realloc de 12 a 16
	#print_strf(sepa)
	#print_strv("Realloc de 12 a 16 -- debe fallar \n")
  	li $s6, 4      # indica la actividad actual
  	
  	move $a0, $s0  #En $s0 esta malloc de 12
  	li $a1 16
	jal reallococ
	
	#  verificar que no hay espacio
	bgez $v0 fin_falla
	move $a0 $v0
	jal perror
	#print_strv("No tengo el espaio de realloc OK!!!\n")
				
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
	         	  
