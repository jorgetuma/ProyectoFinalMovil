# pokedex

Pokedex- Proyecto final desarrollo movil por
Jorge Tuma y Aneury Estevez

## Funcionamiento del la App

La pantalla principal consiste en un listView, al hacer tap sobre el icono de un pokemon cualquiera se despliega
la vista de detalles del pokemon seleccionado. En la vista de detalles se muestra la descripción, estadisticas, habilidades, evoluciones, movimientos
y tipos del pokemon.

Al presionar el icono del corazon de un pokemon este se marca como favorito. Arriba a la derecha hay un boton para acceder a la vista de los pokemones favoritos.

Existe la posibilidad de realizar busqueda de pokemones dado su nombre, id o tipo principal. Esto al presionar el icono de la lupa en la parte superior derecha.

## Tecnoligias empleadas
Se utilizan en su mayoria librerias oficiales de Flutter. Para la vista del detalle Pokemon se utiliza un SlidingUpPanel,
que es una libreria alternativa al SlidingSheet.

La base de datos utilizda es Sqlite con la libreria de Sqlflite. Otras librerias utilizadas cached_preferences 
