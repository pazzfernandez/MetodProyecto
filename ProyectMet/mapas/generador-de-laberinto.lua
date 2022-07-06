--Generador de laberinto
require("nivel/Casilla")  --requiere la clase Casilla contenida en el archivo Casilla.lua

function iniciarLaberinto(altura, base) --esta función inicializa la tabla grilla que será donde se 
  --almacenen los valores numericos que representen las paredes y caminos del laberinto
  
  math.randomseed(os.time())  --llamado a la función randomseed de math, la cual sirve para que cada vez que se ejecute
  --un random salga un nro diferente
  
  grilla = {} --tabla o vector que guarda el laberinto
  
  --llena la grilla con casillas de tipo camino, cada una está rodeada por casillas de tipo pared
  for i=1,altura do
    table.insert(grilla,i,{}) --crea una fila en la grilla
    for j=1,base do --recorre cada "columna"
      casilla1 = Casilla(i,j) --crea un objeto de tipo casilla
      
      --asigna un tipo(pared o camino) a cada casilla segun su posicion
      if i%2==0 then  
        casilla1.tipo=1
      else
        if j%2==0 then
          casilla1.tipo=1
        else
          casilla1.tipo=0
        end
      end
      grilla[i][j] = casilla1 --agrega el objeto casilla a la posicion actual de la grilla
    end
  end
  
  --guarda los datos: altura y base dentro de grilla para usos futuros
  grilla.altura = altura  
  grilla.base = base

  return grilla --devuelve la grilla iniciada
end

function generarLaberinto(grilla, iActual, jActual) 
  
  vecinaElegida = {}
  vecinaElegida.f = 0
  vecinaElegida.c = 0
  
  print("-------------------------")
  print("Casilla actual: "," i: ", iActual, " j: ",jActual)
  grilla[iActual][jActual].visitada = true
  print("Estado: ", grilla[iActual][jActual].visitada)
  vecinaElegida = mirarVecinas(grilla, grilla[iActual][jActual]) --devuelve una casilla vecina aleatoria que no ha sido visitada
  
  if vecinaElegida or vecinaElegida.f~=0 then --vecinaElegida.c~=nil and vecinaElegida.f~=nil then
    print("Vecina elegida:", vecinaElegida, " i: ", vecinaElegida.f, " j: ", vecinaElegida.c)
    sacarPared(grilla, vecinaElegida, grilla[iActual][jActual])
    iActual = vecinaElegida.f
    jActual = vecinaElegida.c
    --grilla[iActual][jActual].visitada = true
    if(iActual > 0 and jActual > 0) then
      generarLaberinto(grilla, iActual, jActual)
    end
  end
end

function mirarVecinas(grilla, casilla)  --funcion que revisa las casillas que rodean a la casilla recibida por
  --parametros y devuelve una que no ha sido visitada de forma aleatoria o, si todas han sido visitadas, una casilla
  --con valores c y f iguales a 0
  
  noVisitadas = {}  --arreglo que guardara aquellas casillas vecinas que no han sido visitadas
  vecina = Casilla(0,0) --casilla que guardara a la vecina elegida para devolver
  contador = 0  --variable numerica para guardar la cantidad de vecinas no visitadas
  
  --a continuacion se revisan las casillas de los alrededores segun la posicion de la casilla recibida por parametros
  if casilla.f==1 and casilla.c==1 then --si es la esquina superior izquierda se revisan...
    
    derecha = mirarDerecha(grilla, casilla) --casilla derecha
    if derecha[1] ~= 0  then  --si el numero devuelto por la función en la posicion 1 es distinto a cero, significa 
      --que la casilla no ha sido visitada aún
      contador = contador + derecha[1]  --agrega 1 al contador
      table.insert(noVisitadas,contador,derecha[2]) --agrega la casilla al arreglo noVisitadas
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador) 
    end 
    
    abajo = mirarAbajo(grilla, casilla) --casilla de abajo
    if abajo[1] ~= 0 then
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    

  elseif casilla.f==1 and casilla.c==grilla.base then--si es la esquina superior derecha...
    
    abajo = mirarAbajo(grilla, casilla) --casilla de abajo
    if abajo[1] ~=0 then
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    izquierda = mirarIzquierda(grilla, casilla) --casilla izquierda
    if izquierda[1] ~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  elseif casilla.f==grilla.altura and casilla.c==1 then--si es la esquina inferior izquierda...
    
    derecha = mirarDerecha(grilla, casilla) --casilla derecha
    if derecha[1] ~=0 then
      contador = contador + derecha[1]
      table.insert(noVisitadas,contador,derecha[2])
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end  
    
    arriba = mirarArriba(grilla, casilla) --casilla de arriba
    if arriba[1] ~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  elseif casilla.f==grilla.altura and casilla.c==grilla.base then --si es la esquina inferior derecha...
    
    izquierda = mirarIzquierda(grilla, casilla) --casilla izquierda
    if izquierda[1]~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end 
    
    arriba = mirarArriba(grilla, casilla) --casilla de arriba
    if arriba[1] ~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  elseif casilla.f==1 then --si es una de la fila superior...
    derecha = mirarDerecha(grilla, casilla) --casilla derecha
    if derecha[1]~=0 then
      contador = contador + derecha[1]
      table.insert(noVisitadas,contador,derecha[2])
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    abajo = mirarAbajo(grilla, casilla) --casilla de abajo
    if abajo[1]~=0 then
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    izquierda = mirarIzquierda(grilla, casilla) --casilla izquierda
    if izquierda[1]~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
      
  elseif casilla.f==grilla.altura then --si es una de la fila inferior...
    
    derecha = mirarDerecha(grilla, casilla) --casilla derecha
    if derecha[1]~=0 then
      contador = contador + derecha[1]
      table.insert(noVisitadas,contador,derecha[2])
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    izquierda = mirarIzquierda(grilla, casilla) --casilla izquierda
    if izquierda[1] ~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    arriba = mirarArriba(grilla, casilla) --casilla de arriba
    if arriba[1]~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  elseif casilla.c==1 then --si es una de la columna izquierda...
    
    derecha = mirarDerecha(grilla, casilla) --casilla derecha
    if derecha[1]~=0 then
      contador = contador + derecha[1]
      table.insert(noVisitadas,contador,derecha[2])
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    abajo = mirarAbajo(grilla, casilla) --casilla de abajo
    if abajo[1]~=0 then
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    arriba = mirarArriba(grilla, casilla) --casilla de arriba
    if arriba[1]~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  elseif casilla.c==grilla.base then --si es una de la columna derecha...
    
    abajo = mirarAbajo(grilla, casilla) --casilla de abajo
    if abajo[1]~=0 then 
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    izquierda = mirarIzquierda(grilla, casilla) --casilla izquierda
    if izquierda[1]~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    arriba = mirarArriba(grilla, casilla) --casilla de arriba
    if arriba[1]~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  else --si es una del centro...
    
    derecha = mirarDerecha(grilla, casilla) --casilla derecha
    if derecha[1]~=0 then
      contador = contador + derecha[1]
      table.insert(noVisitadas,contador,derecha[2])
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    abajo = mirarAbajo(grilla, casilla) --casilla de abajo
    if abajo[1]~=0 then
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    izquierda = mirarIzquierda(grilla, casilla) --casilla izquierda
    if izquierda[1]~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    arriba = mirarArriba(grilla, casilla) --casilla de arriba
    if arriba[1]~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  end
  
  print("CONTADOR: ", contador)
  if contador~=0 then --si hay casillas no visitadas
    for i=1,contador,1 do
      print(i," - ",noVisitadas[i])
    end
    
    numAleatorio = math.random(1,contador)  --elige una al azar entre las disponibles
    
    vecina = noVisitadas[numAleatorio] --le asigna a la casilla Vecina, la casilla elegida
  end
  
  return vecina --devuelve la casilla vecina no visitada elegida
end

function mirarArriba(grilla, casilla) --funcion que revisa la casilla superior de una casilla dada, si ha sido visitada, la devuelve
  if grilla[casilla.f-2][casilla.c].visitada==false then  
    indice = {f=casilla.f-2, c=casilla.c}
    c = 1
  else 
    indice = nil
    c = 0
  end
  return {c, indice}
end
function mirarDerecha(grilla, casilla)  --funcion que revisa la casilla a la derecha de una casilla dada, si ha sido visitada, la devuelve
  if grilla[casilla.f][casilla.c+2].visitada==false then
    indice = {f=casilla.f, c=casilla.c+2}
    c = 1
  else 
    indice = nil
    c = 0
  end
  return {c, indice}
end
function mirarAbajo(grilla, casilla)  --funcion que revisa la casilla inferior de una casilla dada, si ha sido visitada, la devuelve
  if grilla[casilla.f+2][casilla.c].visitada==false then
    indice = {f=casilla.f+2, c=casilla.c}
    c = 1
  else 
    indice = nil
    c = 0
  end
  return {c, indice}
end
function mirarIzquierda(grilla, casilla)  --funcion que revisa la casilla a la izquierda de una casilla dada, si ha sido visitada, la devuelve
  if grilla[casilla.f][casilla.c-2].visitada==false then
    indice = {f=casilla.f, c=casilla.c-2}
    c = 1
  else 
    indice = nil
    c = 0
  end
  return {c, indice}
end

function sacarPared(grilla, proxima, actual)  --funcion que convierte la pared entre dos casillas en camino, cambiando su atributo tipo.
  if(proxima.f == actual.f) then  --si estan en la misma fila 
    if(proxima.c > actual.c) then
      grilla[actual.f][proxima.c-1].tipo = 0
      grilla[actual.f][proxima.c-1].visitada = true
      print("PARED REMOVIDA: ", grilla[actual.f][proxima.c-1].f, " - ", grilla[actual.f][proxima.c-1].c)
    elseif(proxima.c < actual.c) then 
      grilla[actual.f][proxima.c+1].tipo = 0
      grilla[actual.f][proxima.c+1].visitada = true
      print("PARED REMOVIDA: ", grilla[actual.f][proxima.c+1].f, " - ", grilla[actual.f][proxima.c+1].c)
    end
  elseif(proxima.c == actual.c) then  --si estan en la misma columna
    if(proxima.f > actual.f) then
      grilla[proxima.f-1][actual.c].tipo = 0
      grilla[proxima.f-1][actual.c].visitada = true
      print("PARED REMOVIDA: ", grilla[proxima.f-1][actual.c].f," - ", grilla[proxima.f-1][actual.c].c)
    elseif(proxima.f < actual.f) then
      grilla[proxima.f+1][actual.c].tipo = 0
      grilla[proxima.f+1][actual.c].visitada = true
      print("PARED REMOVIDA: ", grilla[proxima.f+1][actual.c].f," - ", grilla[proxima.f+1][actual.c].c)
    end
  end
end


function dibujarLaberinto(grilla,dimCasilla) 
  for i=1,grilla.altura do  
    for j=1,grilla.base do
      if grilla[i][j].tipo ~= 0 then 
        love.graphics.setColor(237, 207, 77, 0.8) 
      else
        love.graphics.setColor(255, 0, 0, 1) 
      end
      if grilla[i][j].visitada then
        love.graphics.setColor(1, 0, 1)
      end
      love.graphics.rectangle("fill", j * dimCasilla, i * dimCasilla, dimCasilla, dimCasilla)
    end
end  
end
