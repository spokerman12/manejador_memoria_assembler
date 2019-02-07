# casos de prueba proy 1 SD17
	#.include "macros.s"

	.data
mifin: .asciiz "FIN"
###########################################
	.text
	#Caso 1: 0.5pto
	#print_strv("Caso 1 vale 0.5 punto")

  	#  malloc sin inicializar manejador
  	li $s6, 1      # indica la actividad actual
  	
  	#print_strf(sepa)
	#print_strv("malloc 400 sin haber ejecutado init -- Debe fallar\n")  	
  	
	li $a0, 400
	jal malloc
	       
        bgez $v0 fin_falla
	move $a0 $v0
	jal perror
        #print_strv("No se ejecuta el malloc -- OK!!!\n")
		
	#  usar lista sin inicializar el manejador
seguir:	#print_strf(sepa)
	#print_strv("crear lista sin inicializar el manejador -- Debe fallar\n")
  	li $s6, 2      # indica la actividad actual

	jal create
	bgez $v0, fin_falla
        move $a0 $v0
	jal perror
	#print_strv("No se ejecuta el create -- OK!!!\n")

	b fin_ok
	
	## FIN
fin_falla:
	move $a0 $v0
	jal perror
	
	#print_strv("Hubo un error en la ejecucion en ")
	#print_int($s6)
	#print_strv("\n")
	beq $s6, 1, seguir
			
fin_ok:	
	#print_strf(sepa)
	#print_strv("FIN")
	#print_strf(sepa)
	
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
	         	  
	         	  


