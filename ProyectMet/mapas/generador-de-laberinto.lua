--Generador de laberinto
require("nivel/Casilla")


function iniciarLaberinto(altura, base) 
  grilla = {}
  
  for i=1,altura do
    table.insert(grilla,i,{})
    for j=1,base do
      
      grilla.i = {};
      casilla1 = Casilla(i,j)
      
      if i%2==0 then 
        if j%2==0 then
          casilla1.tipo=0 
        else
          casilla1.tipo=1
        end
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

function generarLaberinto(grilla)
  
  iActual = 10
  jActual = 10
  vecinaElegida = {}
  
  grilla[iActual][jActual].visitada = true
  vecinaElegida = mirarVecinas(grilla, grilla[iActual][jActual]) --devuelve una casilla vecina aleatoria que no ha sido visitada
  
  if vecinaElegida then
    
    iActual = vecinaElegida.f
    jActual = vecinaElegida.c
    grilla[iActual][jActual].visitada = true
    
  end
end

function mirarVecinas(grilla, casilla)  --self.vecinas = {arriba=true, der=true, abajo=true, izq=true}
  noVisitadas = {}
  vecina = {}
  contador = 0
  if casilla.f==1 and casilla.c==1 then --si es la esquina superior izquierda
    
    derecha = mirarDerecha(grilla, casilla, contador) --derecha
    contador = derecha[1]
    if derecha~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    abajo = mirarAbajo(grilla, casilla, contador) --abajo
    contador = abajo[1]
    if abajo~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,abajo[2])
      else 
        table.insert(noVisitadas,1,abajo[2])
      end
    end
    
  elseif casilla.f==1 and casilla.c==grilla.base then--si es la esquina superior derecha
    
    abajo = mirarAbajo(grilla, casilla, contador) --abajo
    contador = abajo[1]
    if abajo~=-1 then
      table.insert(noVisitadas,1,abajo[2])
    end
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = izquierda[1]
    if izquierda~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,izquierda[2])
      else 
        table.insert(noVisitadas,1,izquierda[2])
      end
    end
    
  elseif casilla.f==grilla.altura and casilla.c==1 then--si es la esquina inferior izquierda
    
    derecha = mirarDerecha(grilla, casilla, contador) --derecha
    contador = derecha[1]
    if derecha~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = arriba[1]
    if arriba~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,arriba[2])
      else 
        table.insert(noVisitadas,1,arriba[2])
      end
    end
    
  elseif casilla.f==grilla.altura and casilla.c==grilla.base then--si es la esquina inferior derecha
    
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = izquierda[1]
    if izquierda~=-1 then
        table.insert(noVisitadas,2,izquierda[2])
    end
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = arriba[1]
    if arriba[2]~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,arriba[2])
      else 
        table.insert(noVisitadas,1,arriba[2])
      end
    end
    
  elseif casilla.f==1 then --si es una de la fila superior
    
    derecha = mirarDerecha(grilla, casilla, contador) --derecha
    contador = derecha[1]
    if derecha~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    
    abajo = mirarAbajo(grilla, casilla, contador) --abajo
    contador = abajo[1]
    if abajo~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,abajo[2])
      else 
        table.insert(noVisitadas,1,abajo[2])
      end
    end
    
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = izquierda[1]
    if izquierda~=-1 then
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
    contador = derecha[1]
    if derecha~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = izquierda[1]
    if izquierda~=-1 then
      if contador==1 then 
        table.insert(noVisitadas,2,izquierda[2])
      else
        table.insert(noVisitadas,1,izquierda[2])
      end
    end
    
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = arriba[1]
    if arriba~=-1 then
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
    contador = derecha[1]
    if derecha~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    
    abajo = mirarAbajo(grilla, casilla, contador) --abajo
    contador = abajo[1]
    if abajo~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,abajo[2])
      else 
        table.insert(noVisitadas,1,abajo[2])
      end
    end
    
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = arriba[1]
    if arriba~=-1 then
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
    contador = abajo[1]
    if abajo~=-1 then 
      table.insert(noVisitadas,1,abajo[2])
    end
    
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = izquierda[1]
    if izquierda~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,izquierda[2])
      else
        table.insert(noVisitadas,1,izquierda[2])
      end
    end
    
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = arriba[1]
    if arriba~=-1 then
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
    contador = derecha[1]
    if derecha~=-1 then
      table.insert(noVisitadas,1,derecha[2])
    end
    
    abajo = mirarAbajo(grilla, casilla, contador) --abajo
    contador = abajo[1]
    if abajo~=-1 then
      if contador==1 then
        table.insert(noVisitadas,2,abajo[2])
      else 
        table.insert(noVisitadas,1,abajo[2])
      end
    end
    
    izquierda = mirarIzquierda(grilla, casilla, contador) --izquierda
    contador = izquierda[1]
    if izquierda~=-1 then
      if contador==2 then 
        table.insert(noVisitadas,3,izquierda[2])
      elseif contador==1 then
        table.insert(noVisitadas,2,izquierda[2])
      else
        table.insert(noVisitadas,1,izquierda[2])
      end
    end
    
    arriba = mirarArriba(grilla, casilla, contador) --arriba
    contador = arriba[1]
    if arriba~=-1 then
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
  
  if contador~=0 then
    numAleatorio = math.random(1,contador)
    print(numAleatorio)
    vecina = noVisitadas[numAleatorio]
    print(vecina)
  end
  return vecina
end

function mirarArriba(grilla, casilla, contador)
  if grilla[casilla.f-2][casilla.c].visitada==false then
    indice = {f=casilla.f-2, c=casilla.c}
    contador = contador + 1
    return {contador, indice}
  else 
    return {0, -1}
  end
end
function mirarDerecha(grilla, casilla, contador)
  if grilla[casilla.f][casilla.c+2].visitada==false then
    indice = {f=casilla.f, c=casilla.c+2}
    contador = contador + 1
    return {contador, indice}
  else 
    return {0, -1}
  end
end
function mirarAbajo(grilla, casilla, contador)
   if grilla[casilla.f+2][casilla.c].visitada==false then
    indice = {f=casilla.f+2, c=casilla.c}
    contador = contador + 1
    return {contador, indice}
  else 
    return {0, -1}
  end
end
function mirarIzquierda(grilla, casilla, contador)
  if grilla[casilla.f][casilla.c-2].visitada==false then
    indice = {f=casilla.f, c=casilla.c-2}
    contador = contador + 1
    return {contador, indice}
  else 
    return {0, -1}
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
