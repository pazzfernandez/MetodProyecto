zombie = require "zombie"
Menu = require "menu"
config = require "config"
Pausa = require "pausa"


function love.load()
  math.randomseed(os.time())
  
  --Pantalla completa segun la resolucion del monitor actual
  ventana = love.window.setMode(0, 0)

  --Importar la camara de la libreria
  camara = require 'librerias/camera'
  cam = camara()
  
  --Importar generador de laberinto
  require("mapas/generador-de-laberinto")
  
  labX = 101
  labY = 101
  
  tamCasillas = 360
  
  --Crea grilla para laberinto
  mapa1 = iniciarLaberinto(labY, labX)
  
  --Crea una tabla con todos los dibujos de los corazones
  dibujos = {}
  
  table.insert(dibujos, love.graphics.newImage("sprites/heart3.png"))
  table.insert(dibujos, love.graphics.newImage("sprites/heart2.png"))
  table.insert(dibujos, love.graphics.newImage("sprites/heart1.png"))
    
  --Crea una tabla con los dibujos de la energia
  dibujosEnergia  = {}

  table.insert(dibujosEnergia, love.graphics.newImage("sprites/energia1.png"))
  table.insert(dibujosEnergia, love.graphics.newImage("sprites/energia2.png"))
  table.insert(dibujosEnergia, love.graphics.newImage("sprites/energia3.png"))
  table.insert(dibujosEnergia, love.graphics.newImage("sprites/energia4.png"))
  table.insert(dibujosEnergia, love.graphics.newImage("sprites/energia5.png"))
  table.insert(dibujosEnergia, love.graphics.newImage("sprites/energia6.png"))
	
	--Cargar los assets a utilizar
  sprites = {}

  sprites.fondoMenu = love.graphics.newImage('sprites/fondoMenu.png')
  sprites.fondoPausa = love.graphics.newImage('sprites/fondoPausa.png')
  sprites.bala = love.graphics.newImage('sprites/bala.png')
  sprites.jugador = love.graphics.newImage('sprites/jugador_1.png')
  sprites.zombie = love.graphics.newImage('sprites/zombie.png')
  sprites.cursor = love.graphics.newImage('sprites/cursor.png')
	
	--Obtener los atributos del jugador
  jugador = {}
  jugador.x = (love.graphics.getWidth() / 2)  
  jugador.y = love.graphics.getHeight() / 2
  jugador.xF = (love.graphics.getWidth() / 2)  
  jugador.yF = love.graphics.getHeight() / 2
  jugador.velocidad = 180
  
  cuerpoJug = {}
  cuerpoJug.x = (love.graphics.getWidth() / 2)-50
  cuerpoJug.y = (love.graphics.getHeight() / 2)-50
  cuerpoJug.alto = 100
  cuerpoJug.ancho = 100
  
  jugX = jugador.x
  jugY = jugador.y
  
  --ACAAAAAAAAAAAAAAAAAAAaaa ACTIVAR MUSICA
  musicaReproduciendose = false 
  musicaOnOff = 'Off'
    
  if musicaReproduciendose == false then
    musicaOnOff = 'Off'
  end
    
  --Posicion de mouse y pone invisible el mouse por defecto
  cx, cy = love.mouse.getPosition
  love.mouse.setVisible(false)
    
	--Obtener la fuente en la que van a estar las letras que aparezcan en pantalla
  love.graphics.setNewFont("04b_30/04b_30__.TTF", 80)
   
  --Craga la musica y los efectos de sonido 
  musicaIntro = love.audio.newSource("musica/Origami Repetika - Quare Frolic.mp3", "stream")
  musicaJuego = love.audio.newSource("musica/Rolemusic - Pokimonkey.mp3", "stream")
  sonidoPerder = love.audio.newSource("musica/gameOverEffect.wav", "static")
  sonidoEfectoDisparo = love.audio.newSource("musica/firingEffect.wav", "static")
    
  musicaJuego:setVolume(0.2)
	
	--Cargar tablas de zombies y de las balas
  zombies = {}    
  balas = {}

	--Otras variables necesarias
  estadoDelJuego = 1
  puntaje = 0
  tiempoMax = 2
  temporizador = tiempoMax
  nivelActual = 1
  estadoPausa = false

  enfriamientoDesplazamiento = 0
  tiempoDesplazandoce = 0
  seDesplaza = false
  
  pausa = Pausa.new()
  pausa:añadirItem{
    nombre = 'Reanudar',
    accion = function()
      estadoPausa = false
    end
  }
   
  --Boton para parar o reproducir la musica
  pausa:añadirItem{
    nombre = 'Musica',--.. musicaOnOff,
    accion = function()
      if musicaReproduciendose == true then
        musicaReproduciendose = false
      else
        musicaReproduciendose = true
      end
    end
  }
  pausa:añadirItem{
    nombre = 'Salir',
    accion = function()
      love.event.quit(0)
    end
  }
    
  if estadoDelJuego == 1 then
    menu = Menu.new()
    
    menu:añadirItem{
      nombre = 'Jugar',
      accion = function()
        estadoDelJuego = 2
        tiempoMax = 2
        temporizador = tiempoMax
        puntaje = 0
        
        --Generar laberinto
        generarLaberinto(mapa1)
        
        --Variable de vidas del jugador
        corazones = 3
      end
    }
    menu:añadirItem{
      nombre = 'Salir',
      accion = function()
        love.event.quit(0)
      end
    }
    --Boton para parar o reproducir la musica
    menu:añadirItem{
      nombre = 'Musica',--.. musicaOnOff,
      accion = function()
      if musicaReproduciendose == true then
        musicaReproduciendose = false
      else
        musicaReproduciendose = true
      end
    end
    }
  end
end

function love.update(dt)
  
	--Tomar el input del usuario sobre la direccion 
	--SOLO si el juego YA HA COMENZADO

  if estadoPausa == false then --ESTADO 2 SOLO FUNCIONA SI NO ESTA EN PAUSA
    if estadoDelJuego == 2 then
        if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) and jugador.x < (tamCasillas * labX) then
            jugX = jugador.x + jugador.velocidad*dt
        end
        if (love.keyboard.isDown("a") or love.keyboard.isDown("left")) and jugador.x > 0 then
            jugX= jugador.x - jugador.velocidad*dt
        end
        if (love.keyboard.isDown("w") or love.keyboard.isDown("up")) and jugador.y > 0 then
            jugY = jugador.y - jugador.velocidad*dt
        end
        if (love.keyboard.isDown("s") or love.keyboard.isDown("down")) and jugador.y < (tamCasillas * labY) then
            jugY = jugador.y + jugador.velocidad*dt
        end
        
        --Desplazamiento rapido
        if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) and (love.keyboard.isDown("space")) and enfriamientoDesplazamiento <= 0  and jugador.x < (tamCasillas * labX) then
          jugX = jugador.x + jugador.velocidad *dt
          seDesplaza = true
        end

        if (love.keyboard.isDown("a") or love.keyboard.isDown("left")) and (love.keyboard.isDown("space")) and enfriamientoDesplazamiento <= 0 and jugador.x > 0 then
        jugX = jugador.x - jugador.velocidad *dt
        seDesplaza = true    
        end

        if (love.keyboard.isDown("w") or love.keyboard.isDown("up")) and (love.keyboard.isDown("space")) and enfriamientoDesplazamiento <= 0 and jugador.y > 0 then
            jugY = jugador.y - jugador.velocidad *dt
            seDesplaza = true
        end

        if (love.keyboard.isDown("s") or love.keyboard.isDown("down")) and (love.keyboard.isDown("space")) and enfriamientoDesplazamiento <= 0 and jugador.y < (tamCasillas * labY) then
            jugY = jugador.y + jugador.velocidad *dt
            seDesplaza = true 
        end
        
        cuerpoJug.x=jugador.x-50
        cuerpoJug.y=jugador.y-50
        
        if revisarColisiones(cuerpoJug)==true then
          jugador.x = jugX
          jugador.y = jugY
        end
        -------------------
        --Activa la pausa
        if(love.keyboard.isDown("escape")) then
          estadoPausa = true
        end

        


        if musicaReproduciendose == false then
          love.audio.stop(musicaIntro)
        elseif not musicaIntro:isPlaying() and musicaReproduciendose == true then
          --funciona bien xd
        end
      
       --Temporizador de enfriamiento para el desplazamiento 
        if seDesplaza then
          tiempoDesplazandoce = tiempoDesplazandoce+(dt/2)
          if tiempoDesplazandoce > 0.5 then
            tiempoDesplazandoce = 0;
            seDesplaza = false
            enfriamientoDesplazamiento = 5
          end
        end
        if math.ceil(enfriamientoDesplazamiento)~= 0 then
          enfriamientoDesplazamiento = enfriamientoDesplazamiento-dt
        end 
        -------


    elseif estadoDelJuego == 1 then
      if musicaReproduciendose == false then
        love.audio.stop(musicaIntro)
        
      elseif not musicaIntro:isPlaying() and musicaReproduciendose == true then
        --funciona bien xd
      end
      menu:actualizar(dt)
      
    end


	
	--itera sobre la tabla de zombies y el movimiento que deben hacer respecto a la posicion del jugador
    for i,z in ipairs(zombies) do
        z.x = z.x + (math.cos( zombieJugadorAngulo(z) ) * z.velocidad * dt)
        z.y = z.y + (math.sin( zombieJugadorAngulo(z) ) * z.velocidad * dt)
		
		
		--Reinicia el juego si un zombie toca al jugador
        if distanciaEntre(z.x, z.y, jugador.x, jugador.y) < 40 then
          
          --Si los corazones son mas de uno
          if corazones > 1 then
            --Se elimina uno
            corazones = corazones - 1
            
            --Elimina al enemigo para que no se sigan sacando vidas
            z.muerto = true
          else
            --parar la musica del juego
            if musicaJuego:isPlaying() then
              love.audio.stop(musicaJuego)
            end
            --Pone sonido de perder
            love.audio.play( sonidoPerder )
            
            --Dormir al programa por 1 seg mientras suena el efecto
            love.timer.sleep(1)
            estadoDelJuego = 1
            
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
    end
	
  --Obtiene la posicion del mouse para el cambio de sprite del mismo
  cx, cy = love.mouse.getPosition()

	--Itera sobre todos los elementos en la tabla de balas y
	--saca su direccion y movimiento
    for i,b in ipairs(balas) do
        b.x = b.x + (math.cos( b.direccion ) * b.velocidad * dt)
        b.y = b.y + (math.sin( b.direccion ) * b.velocidad * dt)
    end
	
	--Remueve las balas que han salido de la pantalla
    for i=#balas, 1, -1 do
        local b = balas[i]
        if (b.x < 0 or b.y < 0 or b.x > (tamCasillas * labX) or b.y > (tamCasillas * labY)) or (i>40) then
            table.remove(balas, i)
        end
    end
	
	
	--Itera sobre los zombies buscando si alguna bala ha colisionado con ellos
	--Si es asi, los elimina de la tabla y aumenta el puntaje
    for i,z in ipairs(zombies) do
        for j,b in ipairs(balas) do
            if distanciaEntre(z.x, z.y, b.x, b.y) < 30 then
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
    
    --Tomar la dimension de la pantalla
    w = (love.graphics.getWidth() / 2)  
    h = love.graphics.getHeight() / 2
    
    if estadoDelJuego == 2 then   
      --Hacer que la camara siga al jugador
      cam:lookAt(jugador.x, jugador.y)
      
      --Hacer que no llegue a los bordes, que la camara pare de seguirlo si se acerca al limite
      if cam.x < w/2 then
        cam.x = w/2
      end
      if cam.y < h/2 then
        cam.y = h/2
      end
        
        --Para los bordes de abajo:
        --Cuanto tengamos un tile map funcionar habra que añadir:
        
      --local mapaTileW = 101 * 160
      --local mapaTileH = 101 * 160
        
        --Solo si estamos trabajando con tiles, si estamos trabajando
        --con un fondo normal, no se haria el calculo y solo se pondria 
        --el ancho/alto del fondo :D
        
      --if cam.x < (mapaTileW - w/2) then
        --cam.x = mapaTileW - w/2
      --end
      --if cam.y < (mapaTileH - h/2) then
--        cam.y = mapaTileH - h/2
  --    end
        
        
    else
      --Si estamos en el menu, que la camara este fija en el medio
      cam:lookAt(w, h)

  end
  
  --SI LA PAUSA ESTA ACTIVA
  else
    pausa:actualizar(dt)

    if(love.keyboard.isDown("return")) then
      estadoPausa = false
    end
  end
end

function love.draw()
	
	 
    --Sacar el tamaño de la ventana
    local anchoVentana = love.graphics.getWidth()
    local altoVentana = love.graphics.getHeight()
    
    cam:attach()
    --Si el juego aun no comenzo
      if estadoDelJuego == 1 then
        love.graphics.draw(sprites.fondoMenu, 0, 0)
        love.graphics.setNewFont("04b_30/04b_30__.TTF", 70)
          menu:dibujar(anchoVentana/2 - 175, altoVentana/2 - 50)
          
          --love.graphics.setNewFont("llpixel/LLPIXEL3.TTF", 90)
          love.graphics.setNewFont("pixelmania/Pixelmania.TTF", 45)
          love.graphics.printf("MATASUEGRAS", 0, love.graphics.getHeight()-(love.graphics.getHeight()/4)*3, love.graphics.getWidth(), "center")
          
          if musicaJuego:isPlaying() then
            love.audio.stop(musicaJuego)
          end
      
          --Musica para el menu principal
          love.audio.play(musicaIntro)
          if not musicaIntro:isPlaying( ) then
            love.audio.play(musicaIntro)
          end
      
      elseif estadoDelJuego == 2 then
        
        --Dibuja el laberinto
        dibujarLaberinto(mapa1, tamCasillas)
        
    --Dibuja al jugador en la pantalla
      love.graphics.draw(sprites.jugador, jugador.x, jugador.y, jugadorAnguloMouse(), nil, nil, sprites.jugador:getWidth()/2, sprites.jugador:getHeight()/2)
      
      love.graphics.rectangle("line", cuerpoJug.x, cuerpoJug.y, cuerpoJug.ancho, cuerpoJug.alto)
      
    --Dibuja a los zombies 
      for i,z in ipairs(zombies) do
          love.graphics.draw(sprites.zombie, z.x, z.y, zombieJugadorAngulo(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
      end
    
    --Dibuja las balas
      for i,b in ipairs(balas) do
          love.graphics.draw(sprites.bala, b.x, b.y, nil, 0.5, nil, sprites.bala:getWidth()/2, sprites.bala:getHeight()/2)
      end
      
      
      
      if musicaReproduciendose == true then
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
    cam:detach()
    
    if estadoDelJuego == 2  then
    --Dibuja los corazones en la pantalla dependiendo de cuantos le queden al jugador
      if corazones ~=0 then
        love.graphics.draw(dibujos[math.floor(corazones)], love.graphics.getHeight()-(love.graphics.getHeight()/6)*5.7, 15)
      end
      
    --Dibuja el medidor de energia
      if enfriamientoDesplazamiento >= 0 then
        love.graphics.draw(dibujosEnergia[math.floor(enfriamientoDesplazamiento+1)],love.graphics.getHeight()-(love.graphics.getHeight()/6)*5.7 , 90)
      elseif enfriamientoDesplazamiento < 0 then
        love.graphics.draw(dibujosEnergia[math.floor(1)],love.graphics.getHeight()-(love.graphics.getHeight()/6)*5.7 , 90)
      end

    --Dibuja el puntaje en pantalla
      love.graphics.setNewFont("04b_30/04b_30__.TTF", 35)
      love.graphics.printf("puntaje: " .. puntaje, 0, love.graphics.getHeight()-love.graphics.getHeight()/6, love.graphics.getWidth(), "center")
    end

     --Dibuja pantalla de pausa
     if estadoPausa then         
      love.graphics.draw(sprites.fondoPausa, -200, -250, 0, 4, 4) --Fondo
      love.graphics.printf("PAUSA", 0, love.graphics.getHeight()-(love.graphics.getHeight()/6)*4, love.graphics.getWidth()-(love.graphics.getWidth()/2)+550, "center", 0, 1, 1, -100, 0) --Titulo Pausa
    
      love.graphics.setNewFont("04b_30/04b_30__.TTF", 50)
      pausa:dibujar(love.graphics.getWidth()/2 - 175, love.graphics.getHeight()/2 - 50)
    end

  --Dibuja el cursor con el sprite
  love.graphics.draw(sprites.cursor, cx-15, cy-15, 0, 0.07)
    
end

--Funcion para crear zombies una vez se comience el juego apretando el espacio
function love.keypressed( tecla )
    if tecla == "space" then
        crearZombie()
    end
end

--Funcion para disparar si ya ha comenzado
function love.mousepressed( x, y, boton )
    if boton == 1 and estadoDelJuego == 2 and estadoPausa == false then
        crearBala()
        love.audio.play( sonidoEfectoDisparo )
    
    end
end

function love.keypressed(key)
  if estadoDelJuego == 1 then
    
    menu:keypressed(key)
  else if estadoDelJuego == 2 and estadoPausa == true then
    pausa:keypressed(key)
  end
end
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

function revisarColisiones(cuerpoRecibido)
  --Posicion i y j del cuerpo respecto a la casilla en dónde se encuentra
  local jj = (cuerpoRecibido.x/tamCasillas) - 0.3 
  local ii = (cuerpoRecibido.y/tamCasillas) + 0.4 
--  print("fila, i = ",math.floor(ii), " - columna, j = ",math.floor(jj))
  
 -- local alto = 100
  --local ancho = 100
  
  --Lineas del cuerpo para revisar colision
  --local cuerpo = {}
  --cuerpo.arr = cuerpoRecibido.y
  --cuerpo.aba = cuerpoRecibido.y + ancho
  --cuerpo.izq = cuerpoRecibido.x
  --cuerpo.der = cuerpoRecibido.x + alto
  
  --Líneas de la casilla para revisar colision
  --local casilla = {}
  --casilla.arr = ii
--  casilla.aba = ii + tamCasillas
--  casilla.izq = jj
--  casilla.der = jj + tamCasillas
  
  --print("Cuerpo: izq:",cuerpo.izq," - der:",cuerpo.der," - arr:",cuerpo.arr," - abaj:", cuerpo.aba)
  --print("Casilla: izq:",casilla.izq," - der:",casilla.der," - arr:",casilla.arr," - abaj:", casilla.aba)
  
--  if mapa1[math.floor(ii)][math.floor(jj)].tipo == 0 then
--    print("es camino")
--  else 
--    print("ES PARED")
--  end
  
--  if  casilla.der > cuerpo.izq  and
--      cuerpo.der  > casilla.izq and
--      cuerpo.aba  > casilla.arr and
--      casilla.aba > cuerpo.arr then
--    print("")
--  end
  
  --print("Marrón - i:",ii," j:",jj)
  local jr = ( (cuerpoRecibido.x+cuerpoRecibido.ancho)/tamCasillas ) - 0.3
  --print("Rojo - i:", ii," j:",jr)
  local iv = ( (cuerpoRecibido.y+cuerpoRecibido.alto)/tamCasillas ) + 0.4
  --print("Verde - i:", iv," j:",jj)
  --print("Naranja - i:",iv," j:",jr)

  --esquinas = {}
  --esquinas.arrIzq = {ii, jj}
  --esquinas.arrDer = {ii, jr}
  --esquinas.abaIzq = {iv, jj}
  --esquinas.abaDer = {iv, jr}
  
  --if ii==iv and jj==jr then
    --están en la misma casilla
  --end
  
  if  mapa1[math.floor(ii)][math.floor(jj)].tipo == 0 and
      mapa1[math.floor(ii)][math.floor(jr)].tipo == 0 and
      mapa1[math.floor(iv)][math.floor(jj)].tipo == 0 and
      mapa1[math.floor(iv)][math.floor(jr)].tipo == 0 then
    --print("Todos en camino")
    return true
  else
    --print("Marron: ",mapa1[math.floor(ii)][math.floor(jj)].tipo)
    --print("Rojo: ",mapa1[math.floor(ii)][math.floor(jr)].tipo)
    --print("Verde: ",mapa1[math.floor(iv)][math.floor(jj)].tipo)
    --print("Naranja: ",mapa1[math.floor(iv)][math.floor(jr)].tipo)
    return false
  end
end