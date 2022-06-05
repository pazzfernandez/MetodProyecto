--Generar el laberinto

mapa = {}
tipoBaldosa = {}
entradas = {{11, 17}, {13,15}, {13, 19}, {19, 17} } --por dónde se puede entrar al centro: formato f, c

function iniciarMapa()
  
  mapa = { --33*20
  {4,4,4,4,4,4,4,4,4,4,4,  4,4,4,4,4,4,4,4,4,4,4,  4,4,4,4,4,4,4,4,4,4,4},
  {4,2,2,2,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,2,2,2,4},
  {4,2,2,2,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,2,2,2,4},
  {4,2,2,2,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,2,2,2,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,1,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,1,1,1,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,1,1,1,1,1,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,1,1,1,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,1,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},

  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},

  {4,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,4},
  {4,2,2,2,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,2,2,2,4},
  {4,2,2,2,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,2,2,2,4},
  {4,2,2,2,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,2,2,2,4},
  {4,4,4,4,4,4,4,4,4,4,4,  4,4,4,4,4,4,4,4,4,4,4,  4,4,4,4,4,4,4,4,4,4,4}
  
  }

  tipoBaldosa = {
   -- 0 es camino
    {0, 0, 1}, --centro - azul
    {1, 0, 0}, --inicio - rojo
    {1, 0, 1}, --recursos - rosado
    {1, 1, 1} --pared - blanca
  }
  

end

function dibujarMapa()
  
  for i, fila in ipairs(mapa) do
    for j, cuadrado in ipairs(fila) do
      --Asegurarse que no es 0 (camino)
      if cuadrado ~= 0 then
        --Pintarlo del color que corresponde según el tipo de cuadrado que es
        love.graphics.setColor(tipoBaldosa[cuadrado])
        --dibujar el rectangulo
        love.graphics.rectangle("fill", j * 25, i * 25, 25, 25)
      end
    end
  end
  
  
end


function crearLaberinto() 
  posicionInicio = {{3,3}, {3,31}, {23,3}, {23,31}}  --posicion de inicio de los jugadores: formato f, c 
  
  for i, pJugador in ipairs(posicionInicio) do
    unirAlCentro(posicionInicio[pJugador][1], posicionInicio[pJugador][2])
  end
  
end

function unirAlCentro(jugY, jugX)
  
  inicio = {}
  inicio.x = jugX
  inicio.y = jugY
  
  final = buscarEntradaLibre(jugY, jugX)
  
  
end

function buscarEntradaLibre()
  
end

function esCamino(x,y)
  return mapa[y][x] ~= 4
end