--Clase mapa

Mapa = Object:extend()  --definir la clase

local tipoCuadrado = { --tabla utilizada para guardar los colores según el uso que se le de a esa porcion del mapa
   -- 0 es vacío
    {237, 207, 77, 0.8}, --camino - 
    {30, 255, 105, 0.8}, --centro 
    {177, 102, 224, 0.8}, --inicio
    {1, 0, 1}, --recursos 
    {138, 46, 0, 0.79} --pared 
}
  
function Mapa:new(alto, ancho, cuadAncho, cuadAlto) --constructor
  self.lienzo = {} --crea una tabla para contener valores que representan a cada cuadrado del mapa
  
  for i=1,alto do
    table.insert(self.lienzo,i,{})
    for j=1,ancho do
      self.lienzo.i = {};
      self.lienzo[i][j]=0 --le asigna un cero a cada cuadrado del mapa, el cero representa una casilla libre
      --print(self.lienzo[i][j])
    end
  end
  
  self.tamCuadrado = {cuadAlto, cuadAncho} --tamaño de las divisiones cuadradas que tendrá el lienzo
  self.alto = alto
  self.ancho = ancho
end

function Mapa.dibujar(mapa1) --dibujar el mapa
  
  for i, fila in ipairs(mapa1.lienzo) do  --recorre la tabla
    for j, cuadrado in ipairs(fila) do
      if cuadrado ~= 0 then --a los valores distintos a cero
        love.graphics.setColor(tipoCuadrado[cuadrado]) --les asigno el color según la tabla de tipoCuadrado
      else
        love.graphics.setColor(255, 0, 0, 1) --temporalmente los cuadrados vacíos irán rojos
      end
      love.graphics.rectangle("fill", j * 25, i * 25, mapa1.tamCuadrado[1], mapa1.tamCuadrado[1])
    end
end  
end