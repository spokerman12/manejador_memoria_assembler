El proyecto se desarrolló a través de tres actividades: La primera era diseñar e implementar
un manejador de espacio RAM para la arquitectura RISC de un CPU MIPS. La segunda fue
utilizar el manejador para administrar la memoria utilizada de una estructura de datos
abstracta correspondiente a una lista enlazada simple. Finalmente, la tercera consistía en la
entrega del código fuente de las primeras actividades.

Manejador.s implementa una estructura de lista enlazada simple
El espacio libre se calcula restando la direccion del segundo bloque con la suma de la direccion del primer bloque + su tamano.
 
Cada nodo de la lista posee atributos direccion, tamano y siguiente.
La direccion apunta al bloque, el cual se reserva con "malloc".