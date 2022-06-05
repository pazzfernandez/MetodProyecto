zombie = require "zombie"
Menu = require "menu"


function love.load()
    math.randomseed(os.time())
    

	
	--Cargar los assets a utilizar
    sprites = {}
    sprites.fondo = love.graphics.newImage('sprites/fondo.png')
    sprites.fondoMenu = love.graphics.newImage('sprites/fondoMenu.png')
    sprites.bala = love.graphics.newImage('sprites/bala.png')
    sprites.jugador = love.graphics.newImage('sprites/jugador.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
	
	--Obtener los atributos del jugador
    jugador = {}
    jugador.x = love.graphics.getWidth() / 2
    jugador.y = love.graphics.getHeight() / 2
    jugador.velocidad = 180
	
	--Obtener la fuente en la que van a estar
	--las letras que aparezcan en pantalla
   love.graphics.setNewFont("04b_30/04b_30__.TTF", 80)
   
   --Craga la musica y los efectos de sonido 
    musicaIntro = love.audio.newSource("musica/Origami Repetika - Quare Frolic.mp3", "stream")
    musicaJuego = love.audio.newSource("musica/Rolemusic - Pokimonkey.mp3", "stream")
    sonidoPerder = love.audio.newSource("musica/gameOverEffect.wav", "static")
    sonidoEfectoDisparo = love.audio.newSource("musica/firingEffect.wav", "static")
    
    musicaJuego:setVolume(0.6)
	
	--Cargar tables de zombies y de las balas
    zombies = {}
    balas = {}
	
	--Otras variables necesarias
    estadoDelJuego = 1
    puntaje = 0
    tiempoMax = 2
    temporizador = tiempoMax
    
    
    if estadoDelJuego == 1 then
      menu = Menu.new()
      menu:añadirItem{
      nombre = 'Jugar',
      accion = function()
        estadoDelJuego = 2
        tiempoMax = 2
        temporizador = tiempoMax
        puntaje = 0
      end
    }
    menu:añadirItem{
      nombre = 'Salir',
      accion = function()
        love.event.quit(0)
      end
    }
    end
end

function love.update(dt)
	
	--Tomar el input del usuario sobre la direccion 
	--SOLO si el juego YA HA COMENZADO
    if estadoDelJuego == 2 then
        if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) and jugador.x < love.graphics.getWidth() then
            jugador.x = jugador.x + jugador.velocidad*dt
        end
        if (love.keyboard.isDown("a") or love.keyboard.isDown("left"))  and jugador.x > 0 then
            jugador.x = jugador.x - jugador.velocidad*dt
        end
        if (love.keyboard.isDown("w") or love.keyboard.isDown("up"))  and jugador.y > 0 then
            jugador.y = jugador.y - jugador.velocidad*dt
        end
        if (love.keyboard.isDown("s") or love.keyboard.isDown("down"))  and jugador.y < love.graphics.getHeight() then
            jugador.y = jugador.y + jugador.velocidad*dt
        end
        
    elseif estadoDelJuego == 1 then
      menu:actualizar(dt)
      
    end


	
	--itera sobre la tabla de zombies y el movimiento que deben hacer respecto a la posicion del jugador
    for i,z in ipairs(zombies) do
        z.x = z.x + (math.cos( zombieJugadorAngulo(z) ) * z.velocidad * dt)
        z.y = z.y + (math.sin( zombieJugadorAngulo(z) ) * z.velocidad * dt)
		
		
		--Reinicia el juego si un zombie toca al jugador
        if distanciaEntre(z.x, z.y, jugador.x, jugador.y) < 30 then
          
          --parar la musica del juego
          if musicaJuego:isPlaying() then
            love.audio.stop(musicaJuego)
          end
          --Poner el sonido de haber perdido
          love.audio.play(sonidoPerder)
          --Dormir al programa por 1 seg mientras suena el efecto
          love.timer.sleep(1)
          
          --Destruye todos los objetos zombie
            for i,z in ipairs(zombies) do
                zombies[i] = nil
                estadoDelJuego = 1
				--Coloca al jugador de nuevo al centro
                jugador.x = love.graphics.getWidth()/2
                jugador.y = love.graphics.getHeight()/2
            end
        end
    end
	
	--Itera sobre todos los elementos en la tabla de balas y
	--saca su direccion y movimiento
    for i,b in ipairs(balas) do
        b.x = b.x + (math.cos( b.direccion ) * b.velocidad * dt)
        b.y = b.y + (math.sin( b.direccion ) * b.velocidad * dt)
    end
	
	--Remueve las balas que han salido de la pantalla
    for i=#balas, 1, -1 do
        local b = balas[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(balas, i)
        end
    end
	
	
	--Itera sobre los zombies buscando si alguna bala ha colisionado con ellos
	--Si es asi, los elimina de la tabla y aumenta el puntaje
    for i,z in ipairs(zombies) do
        for j,b in ipairs(balas) do
            if distanciaEntre(z.x, z.y, b.x, b.y) < 20 then
                z.muerto = true
                b.muerto = true
                puntaje = puntaje + 1
            end
        end
    end

    for i=#zombies,1,-1 do
        local z = zombies[i]
        if z.muerto == true then
            table.remove(zombies, i)
        end
    end

	--Remueve las balas que han colisionado con los enemigos
    for i=#balas,1,-1 do
        local b = balas[i]
        if b.muerto == true then
            table.remove(balas, i)
        end
    end
	
	--Crea enemigos nuevos cada tantos segundos
    if estadoDelJuego == 2 then
        temporizador = temporizador - dt
        if temporizador <= 0 then
            crearZombie()
            tiempoMax = 0.95 * tiempoMax
            temporizador = tiempoMax
        end
    end


function love.draw()
	--Dibuja el fondo
    love.graphics.draw(sprites.fondo, 0, 0)
	
    --Sacar el tamaño de la ventana
    local anchoVentana = love.graphics.getWidth()
    local altoVentana = love.graphics.getHeight()
	--Si el juego aun no comenzo
    if estadoDelJuego == 1 then
      love.graphics.draw(sprites.fondoMenu, 0, 0)
      love.graphics.setNewFont("04b_30/04b_30__.TTF", 70)
        menu:dibujar(anchoVentana/2 - 175, altoVentana/2 - 50)
        
        --love.graphics.setNewFont("llpixel/LLPIXEL3.TTF", 90)
        love.graphics.setNewFont("pixelmania/Pixelmania.TTF", 45)
        love.graphics.printf("MATASUEGRAS", 0, love.graphics.getHeight()-525, love.graphics.getWidth(), "center")
        
        if musicaJuego:isPlaying() then
          love.audio.stop(musicaJuego)
        end
    
        --Musica para el menu principal
        love.audio.play(musicaIntro)
        if not musicaIntro:isPlaying( ) then
          love.audio.play(musicaIntro)
        end
		
    elseif estadoDelJuego == 2 then
	--Dibuja el puntaje en pantalla
    love.graphics.setNewFont("04b_30/04b_30__.TTF", 35)
    love.graphics.printf("puntaje: " .. puntaje, 0, love.graphics.getHeight()-100, love.graphics.getWidth(), "center")
	
	--Dibuja al jugador en la pantalla
    love.graphics.draw(sprites.jugador, jugador.x, jugador.y, jugadorAnguloMouse(), nil, nil, sprites.jugador:getWidth()/2, sprites.jugador:getHeight()/2)
	
	--Dibuja a los zombies 
    for i,z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, zombieJugadorAngulo(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
    end
	
	--Dibuja las balas
    for i,b in ipairs(balas) do
        love.graphics.draw(sprites.bala, b.x, b.y, nil, 0.5, nil, sprites.bala:getWidth()/2, sprites.bala:getHeight()/2)
    end
    
    --Para la musica de la introduccion si esta sonando
    if musicaIntro:isPlaying() then
      love.audio.stop(musicaIntro)
    end
    
    --Musica dentro del juego
    love.audio.play(musicaJuego)
        if not musicaJuego:isPlaying( ) then
          love.audio.play(musicaJuego)
        end
    end
end

--Funcion para crear zombies una vez se comience el juego apretando el espacio
function love.keypressed( tecla )
    if tecla == "space" then
        crearZombie()
    end
end

--Funcion para disparar si ya ha comenzado
function love.mousepressed( x, y, boton )
    if boton == 1 and estadoDelJuego == 2 then
        crearBala()
        love.audio.play( sonidoEfectoDisparo )
    
    end
end

function love.keypressed(key)
	menu:keypressed(key)

end

--Funcion para crear una bala
function crearBala()
    local bala = {}
    bala.x = jugador.x
    bala.y = jugador.y
    bala.velocidad = 500
    bala.muerto = false
    bala.direccion = jugadorAnguloMouse()
    table.insert(balas, bala)
end

--Funcion para calcular la distancia entre dos coordenadas en la pantalla
function distanciaEntre(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end
end