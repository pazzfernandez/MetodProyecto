--Objeto Casilla

Casilla = Object:extend()

function Casilla:new(f,c)  --constructor
  self.f = f
  self.c = c
  self.vecinas = {arriba=true, der=true, abajo=true, izq=true}
  self.tipo = 0
  self.visitada = false
end

--function Casilla:copiar(copia)
  --self.f = copia.f
  --self.c = copia.c
  --self.vecinas = copia.vecinas
  --self.tipo = copia.tipo
  --self.visitada = copia.visitada
--end
