#####
# Universidad Simon Bolivar
# Departamento de Computacion y Tecnologia de la Informacion
# Organizacion del Computador
# Trimestre Septiembre-Diciembre 2017
#
# Proyecto 1
#
# Manejador.s
#
# Representacion del tipo de dato abstracto (TAD) correspondiente a un manejador de memoria
#
# Autores: Daniel Francis 12-10863, Javier Vivas 12-11067
#
# Ultima modificacion: 2/11/2017
#
#
# Manejador.s implementa una estructura de lista enlazada simple
# El espacio libre se calcula restando la direccion del segundo bloque
# con la suma de la direccion del primer bloque + su tamano.
# 
# Cada nodo de la lista posee atributos direccion, tamano y siguiente.
# La direccion apunta al bloque, el cual se reserva con "malloc".
#
####

.data

errores: .asciiz "ER1" 		# Mensajes de los distintos errores que pueden ocurrir
		"ER2"
		"ER3"
		"ER4"
		"ER5"
		"ER6"
# -1: argumento <= 0
# -2: argumento mayor al tamano total disponible
# -3: no hay espacio disponible
# -4: el manejador no esta inicializado
# -5: bloque inexistente
# -6: INUTILIZADO
		
inicializado:.word	0	# Vale 0 si manejador no esta inicializado.
				# Vale 1 en caso contrario


size: .word 0			# Tamaño de espacio total solicitado
firstall: .word 0		# Direccion del primer bloque almacenado
				# Aqui comienza el espacio en heap
firstfree: .word 0		# Direccion delprimer bloque dispnible. Usado solo para construir
numBloques: .word 0		# Numero de bloques almacenados (mallocs)
cabeza: .space 0		# Direccion de la cabeza de la lista

# Planificacion de registros general:
# Todas las rutinas siguen la convencion de registros $t's, y marco de $fp para 
# cargar la pila con datos importantes.
# Todas las rutinas usan los $a's como argumentos y los $v's como retorno
# $s0 esta reservado como indicador de inicializacion del manejador

# SE ASUME LA PRECONDICION:
#		"El usuario solo dispone de las direcciones "address" que retorna el manejador"

# Las etiquetas "start" refieren al momento previo de verificacion de errores
# Las etiquetas "go" refieren al momento de cumplimiento de postcondicion y previo a la ejecucion
# de la subrutina


# ESTRUCTURA UTILIZADA

# Hacemos uso de una lista enlazada simple.
# Cada bloque tiene atributos Direccion, tamano y siguiente
# Direccion es la direccion del espacio reservado, los que usa el TAD manejador
# Tamano es el tamano del espacio reservado
# siguiente es la direccion del siguiente nodo de la lista.
# El ultimo bloque apunta a null

# Para calcular los espacios, restamos direccion+tamano de un bloque con la direccion del siguiente


.text

init:				# init: Inicializa el manejador. 
				#	Toma $a0 como argumento de espacio a solicitar. 
				#	Retorna 0 si es exitoso.
				# 	De lo contrario, retorna un valor negativo.

addi $sp $sp -8			# 	Creacion del marco de init
sw $ra 4($sp)
sw $fp ($sp)
move $fp $sp

startInit:			# START: Comprobamos precondiciones para init

blez $a0 menorIgualACero
b goInit

menorIgualACero:		# 	 Espacio solicitado <= 0
addi $v0 $zero -1		#	 Codigo de error -1
move $a0 $v0
jr $ra				

goInit:				# GO: Ejecucion de la rutina

sw $a0 size			# 	Guardamos la entrada
addi $v0 $zero 9		# 	y se prepara "allocate heap memory"
syscall
sw $v0 firstall			
sw $v0 firstfree
addi $s0 $zero 1		
sw $s0 inicializado		#	Manejador esta incializado.

lw $fp ($sp)			# 	Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

#	*		*		*		*		*		*		*

malloc:				# malloc: Reserva un bloque de tamano $a0
				#	  en el espacio proporcionado en init
				#	  Retorna la direccion del bloque.
				#	  O un valor negativo si no fue posible.

addi $sp $sp -8			#	  Creacion del marco de malloc
sw $ra 4($sp)
sw $fp ($sp)
move $fp $sp

startMalloc:			# START: Comprobamos precondiciones para malloc
lw $s0 inicializado
beqz $s0 noInitMalloc
blez $a0 menorIgualACeroMalloc
lw $t0 size
bgt $a0 $t0 mayorASizeMalloc
b goMalloc

noInitMalloc:			#	 El manejador no esta inicializado
addi $v0 $zero -4		#	 Codigo de error -4		
move $a0 $v0
jr $ra

menorIgualACeroMalloc:		# 	 Espacio solicitado <= 0
addi $v0 $zero -1		#	 Codigo de error -1
move $a0 $v0
jr $ra

mayorASizeMalloc:		# 	 Espacio solicitado > espacio disponible
addi $v0 $zero -2		#	 Codigo de error -2
move $a0 $v0
jr $ra

goMalloc:			# GO: Ejecucion de la rutina
lw $t0 firstfree		#	$t0 tiene al primero libre
lw $t1 numBloques		#	$t1 tiene el numero de bloques
addi $t1 $t1 1			
sw $t1 numBloques
beq $t1 1 primeraEjecucion	#	Caso en el que no haya otros bloques
				#	reservados.
lw $t1 cabeza+4			#	Pero si los hay, $t1 apunta al primero
lw $t1 ($t1)
lw $t2 firstall
bne $t1 $t2 noAlineado		#	Si $t1 no es firstall, entonces
				#	el primer bloque no esta alineado.
lw $t1 cabeza+4			#	Caso contrario, inicia el loop para buscar
b loop_malloc

noAlineado:			# 	 Caso en que el primer bloque ($t1)
				#	 no esta alineado con firstall.
sub $t3 $t1 $t2			#	 Calcula el espacio disponible.
ble $t3 $a0 allocate
b loop_malloc			# 	 Si no es suficiente, inicia el loop

loop_malloc:			# Busca espacios libres entre bloques
lw $t3 8($t1)
beqz $t3 ultimoBloque		# 	 Si $t3=null, estamos en el ultimo bloque
lw $t3 ($t3)
lw $t2 4($t1)		
lw $t4 ($t1)		
add $t4 $t4 $t2		 
sub $t4 $t3 $t4			# 	 Espacio = dirSiguiente - (dirActual+sizeActual)
bge $t4 $a0 allocate
lw $t1 8($t1)
b loop_malloc

ultimoBloque:			#	 Caso en que la busqueda llega al ultimo bloque
lw $t3 4($t1)
lw $t2 size
lw $t4 firstall
add $t2 $t2 $t4			#	 $t2 = sizetotal + direccionInicial
lw $t5 ($t1)
add $t3 $t3 $t5
sub $t3 $t2 $t3			#	 Espacio = $t2 - (sizeActual+dirActual)
bge $t3 $a0 allocate
lw $t4 numBloques
addi $t4 $t4 -1
sw $t4 numBloques
addi $v0 $zero -3		#	Si no hay espacio retorna -3
move $a0 $v0
jr $ra

allocate:			# Reserva el espacio encontrado
lw $t3 firstfree
addi $t3 $t3 8
la $t2 4($t3)
sw $t2 8($t1)
sw $t2 firstfree
lw $t4 firstfree
lw $t5 ($t1)
lw $t6 4($t1)
add $t5 $t5 $t6
sw $t5 ($t2)
sw $a0 4($t2)
lw $t2 ($t2)
move $v0 $t2			# 	Retorna la direccion del espacio 	

lw $fp ($sp)			#	Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

primeraEjecucion:		# Caso en que numElementos = 0
sw $t0 cabeza+8			
sw $a0 cabeza+12		
la $t2 cabeza+8			
sw $t2 cabeza+4			
sw $t2 firstfree 		

add $v0 $zero $t0 		
add $t0 $a0 $t0			# 	Retorna la direccion del espacio 	

lw $fp ($sp)			#	Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

#	*		*		*		*		*		*		*

reallococ:			# reallococ: Modifica el tamano del bloque de direccion
				# $a0. 
				# Si no hay suficiente espacio continuo para cambiar el tamano
				# el bloque es reubicado.

addi $sp $sp -8			#	Creacion del marco de reallococ
sw $ra 4($sp)
sw $fp ($sp)
move $fp $sp
								
beqz $a1 realfree		#	Si el espacio objetivo es 0, hacer free

realfree:
jal free
jr $ra

startReallococ:			# START: Comprobamos precondiciones para reallococ
lw $s0 inicializado
beqz $s0 noInitReallococ
bltz $a0 menorACeroReallococ
lw $t0 size
bgt $a1 $t0 mayorASizeReallococ
b goReallococ

noInitReallococ:			#	 El manejador no esta inicializado
addi $v0 $zero -4		#	 Codigo de error -4		
move $a0 $v0
jr $ra

menorACeroReallococ:
addi $v0 $zero -1		#	Espacio solicitado <= 0
move $a0 $v0			#	Codigo de error -1
jr $ra

mayorASizeReallococ:
addi $v0 $zero -2		#	Espacio solicitado mayor al tamano de init
move $a0 $v0			#	Codigo de error -2
jr $ra

goReallococ:			# GO:	Ejecucion de la rutina
lw $t0 cabeza+4
b busca_reallococ

busca_reallococ:		# 	Busca el bloque a modificar
beqz $t0 findelista1
lw $t1 ($t0)
beq $t1 $a0 finbusca_reallococ
lw $t0 8($t0)			
b busca_reallococ

findelista1:
addi $v0 $zero -5		#	El bloque no existe
move $a0 $v0			#	Codigo de error -5
jr $ra

findelista2:
addi $v0 $zero -3		#	No hay espacio disponible
move $a0 $v0			#	Codigo de error -3
jr $ra

finbusca_reallococ:		# Ha encontrado el bloque
lw $t2 4($t0)			
blt $a1 $t2 resize
beq $a1 $t2 mismoTamano
bgt $a1 $t2 mayorTamano

resize:
sw $a1 4($t0)			# Cambia el tamano. Retorna la direccion del bloque
move $v0 $a0

lw $fp ($sp)
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

mismoTamano:			# Caso en que el tamano no cambia
move $v0 $a0

lw $fp ($sp)
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

mayorTamano:			# Caso en que el tamano es mayor
lw $t3 ($t0) 			
add $t4 $t3 $t2
lw $t5 8($t0) 
lw $t5 ($t5)
sub $t5 $t5 $t4			
sub $t6 $a1 $t2		
blt $t5 $t6 buscaEspacio	# Sigue buscando
bge $t5 $t6 resize		# o realiza el cambio

buscaEspacio:
beqz $t0 findelista2		# Llega al final de la lista sin encontrar espacio
lw $t1 ($t0)
lw $t2 4($t0)
add $t3 $t1 $t2
lw $t4 8($t0)
beqz $t4 ultimoEspacio		# Caso borde de que el espacio esta al final de la lista
lw $t4 ($t4)
sub $t5 $t4 $t3			
move $t7 $t0						
lw $t0 8($t0)
sub $t5 $t5 $t4			
sub $t6 $a1 $t2		
bge $t5 $t6 resizeUbica
blt $t5 $t6 buscaEspacio

resizeUbica:			# El espacio encontrado es adeuado
lw $t8 ($t7)
la $t7 8($t7)
sw $t0 ($t7)		
sw $t8 8($t0)
sw $a1 4($t0)			# Retornamos nueva direccion
lw $v0 ($t0)

lw $fp ($sp)			# Recuperamos marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

ultimoEspacio:			# Caso borde de que el espacio esta al final de la lista	
lw $t1 ($t0)
lw $t2 4($t0)
lw $t4 firstall
lw $t5 size
add $t3 $t1 $t2			
add $t6 $t4 $t5			
sub $t7 $t6 $t3			
sub $t8 $a1 $t2			
bge $t7 $t8 resize


			
#	*		*		*		*		*		*		*
			
free:				# free: Libera el espacio del bloque de 
				#	direccion $a0.

addi $sp $sp -8			# Creamos el marco de free
sw $ra 4($sp)
sw $fp ($sp)
move $fp $sp
			
lw $s0 inicializado		# Revisa que init haya sido ejecutado
beqz $s0 noInitFree
			
la $t1 ($a0)			
la $t2 cabeza+4			
lw $t3 ($t2)
lw $t3 ($t3)			
sw $ra ($sp)
jal loop_free			# Comienza la busqueda del bloque
lw $ra ($sp)
lw $t5 ($t2)
lw $t5 8($t5)
sw $t5 ($t4)

lw $t1 numBloques		# Libera al bloque
addi $t1 $t1 -1
sw $t1 numBloques
addi $s0 $zero 0
move $v0 $s0			

lw $fp ($sp)			# Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

noInitFree:			#	 El manejador no esta inicializado
addi $v0 $zero -4		#	 Codigo de error -4		
move $a0 $v0
jr $ra

loop_free:
move $t4 $t2
beq $t3 $t1 finloop		# Encontro el bloque
la $t2 12($t2)			
lw $t3 ($t2)
lw $t3 ($t3)
b loop_free

finloop: jr $ra

#	*		*		*		*		*		*		*

perror:				# perror: Identificador de errores. La tabla 
				#	  se ubica al comienzo de este archivo.

addi $sp $sp -8			# 	 Creamos el marco para perror
sw $ra 4($sp)
sw $fp ($sp)
move $fp $sp

addi $v0 $zero 4

beq $a0 -1 perror1		# Variaciones del codigo
beq $a0 -2 perror2
beq $a0 -3 perror3
beq $a0 -4 perror4
beq $a0 -6 perror6

jr $ra				# El codigo de error es >= 0


perror1:
la $a0 errores
syscall
lw $fp ($sp)			# Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

perror2:
la $a0 errores+4
syscall
lw $fp ($sp)			# Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra


perror3:
la $a0 errores+8
syscall
lw $fp ($sp)			# Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra


perror4:
la $a0 errores+12
syscall
lw $fp ($sp)			# Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra


perror6:
la $a0 errores+16
lw $fp ($sp)			# Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra