math.randomseed(os.time())


--Funcion para crear un zombie
function crearZombie()
    local zombie = {}
    zombie.x = 0
    zombie.y = 0
    local velocid = math.random(50, 160)
    if velocid % 5 == 0 or velocid % 3 == 0 then
      zombie.velocidad = velocid
    else
      zombie.velocidad = 140
    end
    zombie.muerto = false
	
	posicionDeCasilla = math.random(0, cantidadCasillasCamino)

    zombie.x = 650 + (360 * casillaCaminoX[posicionDeCasilla])
    zombie.y = 400 + (360 * casillaCaminoY[posicionDeCasilla])
    

    table.insert(zombies, zombie)
end

--Funcion para sacar el angulo al que deberia ver el jugador
function jugadorAnguloMouse()
    return math.atan2( jugador.yF - love.mouse.getY(), jugador.xF - love.mouse.getX() ) + math.pi
end

--Angulo del zombie para llegar al jugador
function zombieJugadorAngulo(enemigo)
    return math.atan2( jugador.y - enemigo.y, jugador.x - enemigo.x )
end