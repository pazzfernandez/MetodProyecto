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

function mirarVecinas(grilla, casilla)  --self.vecinas = {arriba=true, der=true, abajo=true, izq=true}
  noVisitadas = {}
  vecina = {}
  contador = 0
  if casilla.f==1 and casilla.c==1 then --si es la esquina superior izquierda
    
    derecha = mirarDerecha(grilla, casilla) --derecha
    if derecha[1] ~= 0  then
      contador = contador + derecha[1]
      table.insert(noVisitadas,contador,derecha[2])
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end 
    
    abajo = mirarAbajo(grilla, casilla) --abajo
    if abajo[1] ~= 0 then
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    

  elseif casilla.f==1 and casilla.c==grilla.base then--si es la esquina superior derecha
    
    abajo = mirarAbajo(grilla, casilla) --abajo
    if abajo[1] ~=0 then
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    izquierda = mirarIzquierda(grilla, casilla) --izquierda
    if izquierda[1] ~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  elseif casilla.f==grilla.altura and casilla.c==1 then--si es la esquina inferior izquierda
    
    derecha = mirarDerecha(grilla, casilla) --derecha
    if derecha[1] ~=0 then
      contador = contador + derecha[1]
      table.insert(noVisitadas,contador,derecha[2])
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end  
    
    arriba = mirarArriba(grilla, casilla) --arriba
    if arriba[1] ~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  elseif casilla.f==grilla.altura and casilla.c==grilla.base then --si es la esquina inferior derecha
    
    izquierda = mirarIzquierda(grilla, casilla) --izquierda
    if izquierda[1]~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end 
    
    arriba = mirarArriba(grilla, casilla) --arriba
    if arriba[1] ~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  elseif casilla.f==1 then --si es una de la fila superior
    derecha = mirarDerecha(grilla, casilla) --derecha
    if derecha[1]~=0 then
      contador = contador + derecha[1]
      table.insert(noVisitadas,contador,derecha[2])
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    abajo = mirarAbajo(grilla, casilla) --abajo
    if abajo[1]~=0 then
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    izquierda = mirarIzquierda(grilla, casilla) --izquierda
    if izquierda[1]~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
      
  elseif casilla.f==grilla.altura then --si es una de la fila inferior
    
    derecha = mirarDerecha(grilla, casilla) --derecha
    if derecha[1]~=0 then
      contador = contador + derecha[1]
      table.insert(noVisitadas,contador,derecha[2])
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    izquierda = mirarIzquierda(grilla, casilla) --izquierda
    if izquierda[1] ~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    arriba = mirarArriba(grilla, casilla) --arriba
    if arriba[1]~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  elseif casilla.c==1 then --si es una de la columna izquierda
    
    derecha = mirarDerecha(grilla, casilla) --derecha
    if derecha[1]~=0 then
      contador = contador + derecha[1]
      table.insert(noVisitadas,contador,derecha[2])
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    abajo = mirarAbajo(grilla, casilla) --abajo
    if abajo[1]~=0 then
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    arriba = mirarArriba(grilla, casilla) --arriba
    if arriba[1]~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  elseif casilla.c==grilla.base then --si es una de la columna derecha
    
    abajo = mirarAbajo(grilla, casilla) --abajo
    if abajo[1]~=0 then 
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    izquierda = mirarIzquierda(grilla, casilla) --izquierda
    if izquierda[1]~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    arriba = mirarArriba(grilla, casilla) --arriba
    if arriba[1]~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  else --si es una del centro
    
    derecha = mirarDerecha(grilla, casilla) --derecha
    if derecha[1]~=0 then
      contador = contador + derecha[1]
      table.insert(noVisitadas,contador,derecha[2])
      print("Mirar derecha vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    abajo = mirarAbajo(grilla, casilla) --abajo
    if abajo[1]~=0 then
      contador = contador + abajo[1]
      table.insert(noVisitadas,contador,abajo[2])
      print("Mirar abajo vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    izquierda = mirarIzquierda(grilla, casilla) --izquierda
    if izquierda[1]~=0 then
      contador = contador + izquierda[1]
      table.insert(noVisitadas,contador,izquierda[2])
      print("Mirar izquierda vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
    arriba = mirarArriba(grilla, casilla) --arriba
    if arriba[1]~=0 then
      contador = contador + arriba[1]
      table.insert(noVisitadas,contador,arriba[2])
      print("Mirar arriba vecina: ", noVisitadas[contador], " - CONTADOR: ", contador)
    end
    
  end
  
  print("CONTADOR: ", contador)
  if contador~=0 then
    for i=1,contador,1 do
      print(i," - ",noVisitadas[i])
    end
    
    numAleatorio = math.random(1,contador)
    
    vecina = noVisitadas[numAleatorio]
  else
    vecina.f = 0
    vecina.c = 0
  end
  
  return vecina
end

function mirarArriba(grilla, casilla)
  if grilla[casilla.f-2][casilla.c].visitada==false then
    indice = {f=casilla.f-2, c=casilla.c}
    c = 1
  else 
    indice = nil
    c = 0
  end
  return {c, indice}
end
function mirarDerecha(grilla, casilla)
  if grilla[casilla.f][casilla.c+2].visitada==false then
    indice = {f=casilla.f, c=casilla.c+2}
    c = 1
  else 
    indice = nil
    c = 0
  end
  return {c, indice}
end
function mirarAbajo(grilla, casilla)
  if grilla[casilla.f+2][casilla.c].visitada==false then
    indice = {f=casilla.f+2, c=casilla.c}
    c = 1
  else 
    indice = nil
    c = 0
  end
  return {c, indice}
end
function mirarIzquierda(grilla, casilla)
  if grilla[casilla.f][casilla.c-2].visitada==false then
    indice = {f=casilla.f, c=casilla.c-2}
    c = 1
  else 
    indice = nil
    c = 0
  end
  return {c, indice}
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
  elseif(proxima.c == actual.c) then
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
