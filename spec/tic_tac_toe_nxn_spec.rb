=begin
RSpec.describe TicTacToeNxn do
  it "has a version number" do
    expect(TicTacToeNxn::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end

describe 'fizzbuzz' do it 
 'returns "fizz" when passed 3' do 
   expect(fizzbuzz(3)).to eq 'fizz' 
 end 
end

require 'nombre_metodo'
require './lib/fizzbuzz'
describe 'fizzbuzz' do it 
  'returns "fizz" when passed 3' do 
    expect(fizzbuzz(3)).to eq 'fizz' 
  end 
 end
=end
#require 'spec_helper'
RSpec.describe TicTacToeNxn::ComprobarGane do
  it "find out the columna number" do
    comprobar_gane = TicTacToeNxn::ComprobarGane
    tablero = TicTacToeNxn::Tablero
    juego = TicTacToeNxn::Juego
    allow(juego).to receive(:tamano_tablero).and_return(3)
    tablero.tamano_tablero = 3
    tablero.tablero_inicial = [["X","O","O"],["X","X","O"],["X","-","-"]]
    tablero.calcular_tamano_tablero
    expect(comprobar_gane.linea_ganadora_horizontal(0, 'X')).to eq [1, 'X']
  end
end