# CASO 9 (RA1 y RA2)

_Documentación del trabajo final de M02-Sistemas Gestores de Bases de datos de los estudiantes Carlos Masana, Artur Marin y Daniela Gallardo_

## LAS TAREAS A DESARROLLAR SON 📌
* Elegir una bd de todas las bases de datos con las que hemos trabajado. (que tenga una relación m-n y una relación reflexiva)
* Plantear un entorno de uso real de la base de datos escogida. 
* Definir usuarios.
* Asignar roles y privilegios.
* Desarrollar procedimientos almacenados, funciones y triggers.
* Implementar las tareas priorizadas y hacer un manual para migrar del entorno de desarrollo en el entorno de producción.

## LO QUE TENEMOS HASTA AHORA ⚙️
* Elegimos la bbdd de la [uf3_ra2_autoavaluacio](https://github.com/guzanaz/G3-pl-sql/blob/master/G3_tablas_inserts.sql)

* Definimos a los usuarios
  * Nivel externo (usuario final)
    * Clientes
    * Ventas (trabajadores y jefe)
    * Contabilidad (trabajadores y jefe)
    * RRHH (trabajadores y jefe)
  
  * Nivel conceptual (programadores)
    * grupo_3 _(en este caso tenemos una bbdd pre-hecha/definida pero podremos modificarla en la medida que lo necesitemos para este trabajo)_
  
  * Nivel físico
    * empleados del departamento IT-Administradores (trabajadores y jefe)
    * empleados del departamento IT-Developers (trabajadores)
    
* Realizamos una "definición inicial" de los privilegios y roles que se otorgarán a los distintos tipos de usuario (_esto está documentado en el script [parte 1](https://github.com/guzanaz/G3-pl-sql/blob/master/Parte_1.sql) y está sujeto a modificaciones_)


