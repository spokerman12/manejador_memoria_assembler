#####
# Universidad Simon Bolivar
# Departamento de Computacion y Tecnologia de la Informacion
# Organizacion del Computador
# Trimestre Septiembre-Diciembre 2017
#
# Proyecto 1
#
# Lista.s
#
# Representacion del tipo de dato abstracto (TAD) correspondiente a una lista enlazada
# haciendo uso del TAD presente en Manejador.s.
#
# La cabeza de la lista posee tres atributos de 4 bytes: tamano, ultimo y primero
# Cada nodo de la lista posee dos atributos: elemento y siguiente
#
#
# Autores: Daniel Francis 12-10863, Javier Vivas 12-11067
#
# Ultima modificacion: 2/11/2017
#
#
#
#
#	Lista.s sigue los mismos parametros de planificacion de registros,
#	y precondiciones.
#
#	******* Notese que la TAD lista NO se compone de los nodos indicados *******
#		en Manejador.s (en .data). Sino que esos nodos apuntan a los bloques 
#               (en el espacio dado por init).
#		Estos bloques SI actuan como los "nodos" de una lista enlazada.
#
######

.text

create: 			# create: Crea una lista enlazada vacia

addi $sp $sp -8			# 	Creacion del marco de create
sw $ra 4($sp)
sw $fp ($sp)
move $fp $sp

#jal init

addi $a0 $zero 12
jal malloc			# en $v0 tendremos la direccion de la cabeza de la lista	

lw $fp ($sp)			# 	Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

#	*		*		*		*		*		*		*

insert:				# insert: Inserta un nuevo nodo en la lista

addi $sp $sp -8			# 	Creacion del marco de insert
sw $ra 4($sp)
sw $fp ($sp)
move $fp $sp

la $t0 ($a0)
addi $t0 $t0 4
lw $t1 ($t0)
move $t5 $a0
beqz $t1 listaVacia		# 	Caso si la lista esta vacia
addi $t1 $t1 4
addi $a0 $zero 4
sw $t5 ($sp)			# 	Almacena t's para poder usar malloc
sw $t4 -4($sp)
sw $t3 -8($sp)

jal malloc			# 	Crea el nuevo nodo
lw $t5 ($sp)
lw $t4 -4($sp)
lw $t3 -8($sp)

sw $v0 ($t1)			#	Guarda los argumentos
sw $v0 4($t5)
sw $a1 ($v0)

lw $t3 ($t5)			#	Actualiza la lista
lw $t3 ($t3)
addi $t3 $zero 1
lw $t4 ($t5)
sw $t3 ($t4)

addi $v0 $zero 0		# 	Retorna 0 si fue exitoso

lw $fp ($sp)			# 	Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

listaVacia:			# 	Caso en el que la lista este vacia

addi $a0 $zero 4
jal malloc
la $t3 ($t5)
lw $t3 ($t3)
addi $t3 $zero 1
la $t4 ($t5)
sw $t3 ($t4)
sw $v0 4($t5)
sw $v0 8($t5)
sw $a1 ($v0)

addi $v0 $zero 0		# 	Retorna 0 si fue exitoso

lw $fp ($sp)			# 	Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

#	*		*		*		*		*		*		*

delete:				# delete: Elimina el nodo en la posicion $a1

addi $sp $sp -8			# 	Creacion del marco de delete
sw $ra 4($sp)
sw $fp ($sp)
move $fp $sp

move $t2 $zero
la $t5 ($a0)
addi $t0 $t0 0
move $t5 $t0

loop_delete:			# Busca el nodo en la posicion $a1
addi $t2 $t2 1
beq $t2 $a1 encontrado
lw $t0 4($t0)
lw $t6 ($t5)
bgt $t2 $t6 finLista
b loop_delete

encontrado:
move $a0 $t0
lw $a0 ($a0)
jal free			# Libera el bloque con manejador
b finLista

finLista:	

lw $fp ($sp)			# 	Recuperamos el marco anterior
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

#	*		*		*		*		*		*		*

print:

#	*		*		*		*		*		*		*




.include "Manejador.s"
