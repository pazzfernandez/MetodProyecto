--Generador de laberinto
require("nivel/Casilla")

function iniciarLaberinto(altura, base) 
  math.randomseed(os.time())
  grilla = {}
  
  for i=1,altura do
    table.insert(grilla,i,{})
    for j=1,base do
      
      grilla.i = {};
      casilla1 = Casilla(i,j)
      
      if i%2==0 then 
        casilla1.tipo=1
      else
        if j%2==0 then
          casilla1.tipo=1
        else
          casilla1.tipo=0
        end
      end
      grilla[i][j] = casilla1
    end
  end
  
  grilla.altura = altura
  grilla.base = base

  return grilla
end

function generarLaberinto(grilla, iActual, jActual)
  
  vecinaElegida = {}
  
  print("-------------------------")
  print("Casilla actual: "," i: ", iActual, " j: ",jActual)
  grilla[iActual][jActual].visitada = true
  print("Estado: ", grilla[iActual][jActual].visitada)
  vecinaElegida = mirarVecinas(grilla, grilla[iActual][jActual]) --devuelve una casilla vecina aleatoria que no ha sido visitada
  
  if vecinaElegida~=nil then
    print("Vecina elegida:", vecinaElegida, " i: ", vecinaElegida.f, " j: ", vecinaElegida.c)
    sacarPared(grilla, vecinaElegida, grilla[iActual][jActual])
    iActual = vecinaElegida.f
    jActual = vecinaElegida.c
    --grilla[iActual][jActual].visitada = true
    if(iActual >0 and jActual > 0) then
      generarLaberinto(grilla, iActual, jActual)
    end
  end
end

function mirarVecinas(grilla, casilla)  --self.vecinas = {arriba=true, der=true, abajo=true, izq=true}
  noVisitadas = {}
  vecina = {}
  contador = 0
  if casilla.f==1 and casilla.c==1 then --si es la esquina superior izquierda
    
    derecha = mirarDerecha(grilla, casilla, contador) --derecha
    contador = contador + derecha[1]
    if derecha[2].f~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    
    abajo = mirarAbajo(grilla, casilla, contador) --abajo
    contador = contador + abajo[1]
    if abajo[2].f~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,abajo[2])
      else 
        table.insert(noVisitadas,1,abajo[2])
      end
    end
    
  elseif casilla.f==1 and casilla.c==grilla.base then--si es la esquina superior derecha
    
    abajo = mirarAbajo(grilla, casilla, contador) --abajo
    contador = contador + abajo[1]
    if abajo[2]~=-1 then
      table.insert(noVisitadas,1,abajo[2])
    end
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = contador + izquierda[1]
    if izquierda[2].f~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,izquierda[2])
      else 
        table.insert(noVisitadas,1,izquierda[2])
      end
    end
    
  elseif casilla.f==grilla.altura and casilla.c==1 then--si es la esquina inferior izquierda
    
    derecha = mirarDerecha(grilla, casilla, contador) --derecha
    contador = contador + derecha[1]
    if derecha[2].f~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = contador + arriba[1]
    if arriba[2].f~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,arriba[2])
      else 
        table.insert(noVisitadas,1,arriba[2])
      end
    end
    
  elseif casilla.f==grilla.altura and casilla.c==grilla.base then --si es la esquina inferior derecha
    
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = contador + izquierda[1]
    if izquierda[2].f~=-1 then
      table.insert(noVisitadas,1,izquierda[2])
    end
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = contador + arriba[1]
    if arriba[2].f~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,arriba[2])
      else 
        table.insert(noVisitadas,1,arriba[2])
      end
    end
    
  elseif casilla.f==1 then --si es una de la fila superior
    derecha = mirarDerecha(grilla, casilla, contador) --derecha
    contador = contador + derecha[1]
    if derecha[2].f~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    
    abajo = mirarAbajo(grilla, casilla, contador) --abajo
    contador = contador + abajo[1]
    if abajo[2].f~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,abajo[2])
      else 
        table.insert(noVisitadas,1,abajo[2])
      end
    end
    
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = contador + izquierda[1]
    if izquierda[2].f~=-1 then
      if contador==2 then 
        table.insert(noVisitadas,3,izquierda[2])
      elseif contador==1 then
        table.insert(noVisitadas,2,izquierda[2])
      else
        table.insert(noVisitadas,1,izquierda[2])
      end
    end
  elseif casilla.f==grilla.altura then --si es una de la fila inferior
    
    derecha = mirarDerecha(grilla, casilla, contador) --derecha
    contador = contador + derecha[1]
    if derecha[2].f~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = contador + izquierda[1]
    if izquierda[2].f~=-1 then
      if contador==1 then 
        table.insert(noVisitadas,2,izquierda[2])
      else
        table.insert(noVisitadas,1,izquierda[2])
      end
    end
    
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = contador + arriba[1]
    if arriba[2].f~=-1 then
      if contador==2 then
        table.insert(noVisitadas,3,arriba[2])
      elseif contador==1 then
        table.insert(noVisitadas,2,arriba[2])
      else 
        table.insert(noVisitadas,1,arriba[2])
      end
    end
    
  elseif casilla.c==1 then --si es una de la columna izquierda
    
    derecha = mirarDerecha(grilla, casilla, contador) --derecha
    contador = contador + derecha[1]
    if derecha[2].f~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    
    abajo = mirarAbajo(grilla, casilla, contador) --abajo
    contador = contador + abajo[1]
    if abajo[2].f~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,abajo[2])
      else 
        table.insert(noVisitadas,1,abajo[2])
      end
    end
    
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = contador + arriba[1]
    if arriba[2].f~=-1 then
      if contador==2 then
        table.insert(noVisitadas,3,arriba[2])
      elseif contador==1 then
        table.insert(noVisitadas,2,arriba[2])
      else 
        table.insert(noVisitadas,1,arriba[2])
      end
    end
    
  elseif casilla.c==grilla.base then --si es una de la columna derecha

    abajo = mirarAbajo(grilla, casilla, contador) --abajo
    contador = contador + abajo[1]
    if abajo[2].f~=-1 then 
      table.insert(noVisitadas,1,abajo[2])
    end
    
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = contador + izquierda[1]
    if izquierda[2].f~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,izquierda[2])
      else
        table.insert(noVisitadas,1,izquierda[2])
      end
    end
    
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = contador + arriba[1]
    if arriba[2].f~=-1 then
      if contador==2 then
        table.insert(noVisitadas,3,arriba[2])
      elseif contador==1 then
        table.insert(noVisitadas,2,arriba[2])
      else 
        table.insert(noVisitadas,1,arriba[2])
      end
    end
    
  else --si es una del centro
    
    derecha = mirarDerecha(grilla, casilla, contador) --derecha
    contador = contador + derecha[1]
    if derecha[2].f~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    
    abajo = mirarAbajo(grilla, casilla, contador) --abajo
    contador = contador + abajo[1]
    if abajo[2].f~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,abajo[2])
      else 
        table.insert(noVisitadas,1,abajo[2])
      end
    end
    
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = contador + izquierda[1]
    if izquierda[2].f~=-1 then
      if contador==2 then 
        table.insert(noVisitadas,3,izquierda[2])
      elseif contador==1 then
        table.insert(noVisitadas,2,izquierda[2])
      else
        table.insert(noVisitadas,1,izquierda[2])
      end
    end
    
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = contador + arriba[1]
    if arriba[2].f~=-1 then
      if contador==3 then
        table.insert(noVisitadas,4,arriba[2])
      elseif contador==2 then
        table.insert(noVisitadas,3,arriba[2])
      elseif contador==1 then
        table.insert(noVisitadas,2,arriba[2])
      else
        table.insert(noVisitadas,1,arriba[2])
      end
    end
    
  end
  
  print("CONTADOR: ", contador)
  if contador~=0 then
    print("aentrooooooo--------")
    numAleatorio = math.random(1,contador)
    numAleatorio2 = numeroAleatorio(contador)
    print("Numero aleatorio: ")
    print("CON MATH.RANDOM",numAleatorio)
    print("CON FUNCION", numAleatorio2)
    
    for i=1,contador,1 do
      print(i," - ",noVisitadas[i])
    end
    
    vecina = noVisitadas[numAleatorio2]
    --print("Vecina elegida DENTRO FUNCION:", vecina, " i: ", vecina.f, " j: ", vecina.c)
    --print("Casilla elegida: ",vecina, " i: ", vecina.f, " j: ", vecina.c)
  end
  return vecina
end

function mirarArriba(grilla, casilla, contador)
  if grilla[casilla.f-2][casilla.c].visitada==false then
    indice = {f=casilla.f-2, c=casilla.c}
    contador = 1
  else 
    indice = {f=-1, c=-1}
    contador = 0
  end
  return {contador, indice}
end
function mirarDerecha(grilla, casilla, contador)
  if grilla[casilla.f][casilla.c+2].visitada==false then
    indice = {f=casilla.f, c=casilla.c+2}
    contador = 1
  else 
    indice = {f=-1, c=-1}
    contador = 0
  end
  return {contador, indice}
end
function mirarAbajo(grilla, casilla, contador)
   if grilla[casilla.f+2][casilla.c].visitada==false then
    indice = {f=casilla.f+2, c=casilla.c}
    contador = 1
  else 
    indice = {f=-1, c=-1}
    contador = 0
  end
  return {contador, indice}
end
function mirarIzquierda(grilla, casilla, contador)
  if grilla[casilla.f][casilla.c-2].visitada==false then
    indice = {f=casilla.f, c=casilla.c-2}
    contador = 1
  else 
    indice = {f=-1, c=-1}
    contador = 0
  end
  return {contador, indice}
end



function numeroAleatorio(cantVecinas)
  cantNumeros = cantVecinas*5 --calcular el limite de la función random, cada vacina tendrá 5 numeros asignados

  num = math.random(1, cantNumeros) --tomar un numero aleatorio en el rango de 1 a limite

  --revisar a que vecina corresponde el numero
  inicio = 1  
  fin = 5
  for i = 1,cantVecinas,1 do
    for j=inicio,fin,1 do
      if(j == num) then
        seleccionada = i
        return seleccionada
      end
    end
    inicio = inicio + 5
    fin = fin + 5
  end
end

function sacarPared(grilla, proxima, actual)
  if(proxima.f == actual.f) then
    if(proxima.c > actual.c) then
      grilla[actual.f][proxima.c-1].tipo = 0
      grilla[actual.f][proxima.c-1].visitada = true
      print("PARED REMOVIDA: ", grilla[actual.f][proxima.c-1].f, " - ", grilla[actual.f][proxima.c-1].c)
    elseif(proxima.c < actual.c) then
      grilla[actual.f][proxima.c+1].tipo = 0
      grilla[actual.f][proxima.c+1].visitada = true
      print("PARED REMOVIDA: ", grilla[actual.f][proxima.c+1].f, " - ", grilla[actual.f][proxima.c+1].c)
    end
  end
  if(proxima.c == actual.c) then
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
