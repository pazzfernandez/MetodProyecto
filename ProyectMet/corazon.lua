math.randomseed(os.time())


--Funcion para crear un corazon
function crearCorazon()
  
  corazonCreado = true
  --Obtener los atributos para el corazon
    corazon = {}
    corazon.x = math.random(0, love.graphics.getWidth())
    corazon.y = math.random(0, love.graphics.getHeight())
    corazon.contador = 10
  
    
end

--Funcion para generar un corazon en un lugar random del mapa
