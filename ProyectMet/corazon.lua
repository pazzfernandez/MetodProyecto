math.randomseed(os.time())


--Funcion para crear un corazon
function crearCorazon()
  
  corazonCreado = true
  --Obtener los atributos para el corazon
    corazon = {}
    
    --para generar un corazon en un lugar random del mapa
    corazon.x = math.random(0, love.graphics.getWidth())
    corazon.y = math.random(0, love.graphics.getHeight())

    corazon.agarrado = false
  
    table.insert(corazonest, corazon)
end


