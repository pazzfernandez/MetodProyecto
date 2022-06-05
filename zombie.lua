--Funcion para crear un zombie
function crearZombie()
    local zombie = {}
    zombie.x = 0
    zombie.y = 0
    zombie.velocidad = 140
    zombie.muerto = false
	
	--Aleatoriamente los coloca en uno de los lados de la pantalla
    local lado = math.random(1, 4)
    if lado == 1 then
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif lado == 2 then
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif lado == 3 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif lado == 4 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end

    table.insert(zombies, zombie)
end

--Funcion para sacar el angulo al que deberia ver el jugador
function jugadorAnguloMouse()
    return math.atan2( jugador.y - love.mouse.getY(), jugador.x - love.mouse.getX() ) + math.pi
end

--Angulo del zombie para llegar al jugador
function zombieJugadorAngulo(enemigo)
    return math.atan2( jugador.y - enemigo.y, jugador.x - enemigo.x )
end