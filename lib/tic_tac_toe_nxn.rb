
module TicTacToeNxn
  # definir los jugadores y la variable que le corresponde
  class Jugadores
    attr_accessor :jugador_1, :jugador_2, :simbolo_j1, :simbolo_j2
    def jugador1
      @jugador_1 = '1'
      @simbolo_j1 = 'X'
    end

    def jugador2
      @jugador_2 = '2'
      @simbolo_j2 = 'O'
    end
  end

  class Tablero
    attr_accessor :tablero_inicial, :tamano_tablero, :tablero
    def inicializar_tablero_inicial
      @tablero_inicial = Array.new(@tamano_tablero) { Array.new(@tamano_tablero, '-') }
    end

    def definir_tamano_tablero
      loop do
        print 'Tamaño del tablero '
        @tamano_tablero = gets.chomp
        @tamano_tablero = @tamano_tablero.to_i
        break if @tamano_tablero.positive?
      end

    end

    def mostrar_tablero
      Proc.new do
        @tablero_inicial.each { |z| puts z.join(' | ') }
      end
    end

    def calcular_tamano_tablero
      @tablero = @tamano_tablero ** 2
    end
  end

  class Juego
    attr_accessor :tablero, :jugador, :columna, :fila
    def initialize(tablero, jugador)
      @tablero = tablero
      @jugador = jugador
    end

    def tiros_para_ganar
      Proc.new { (@tablero.tamano_tablero * 2) - 1 }
    end

    def posicion_columna(posicion_jugador)
      @columna = posicion_jugador / @tablero.tamano_tablero
    end

    def posicion_fila(posicion_jugador)
      @fila = posicion_jugador - (@columna * @tablero.tamano_tablero)
    end

    def turno_jugador(simbolo, jugador)
      loop do
        print "Jugador #{jugador} (#{simbolo}) elija una posición"
        posicion = validar_posicion_tablero
        valida = inserta_columna(simbolo, posicion)
        break if valida == false
      end
    end

    def inserta_columna(simbolo, posicion_jugador)
      posicion_columna(posicion_jugador)
      posicion_fila(posicion_jugador)
      if @tablero.tablero_inicial[@columna][@fila] != '-'
        puts 'Posición ocupada '
      else
        @tablero.tablero_inicial[@columna][@fila] = simbolo
        false
      end
    end

    def validar_posicion_tablero(posicion_jugador = '')
      tab = @tablero.tablero
      loop do
        posicion_jugador = STDIN.gets.chomp
        posicion_jugador = posicion_jugador.to_i
        break if posicion_jugador.positive? && posicion_jugador <= tab

        puts "Solo se aceptan números mayores a cero y menores a #{tab}"
      end
      posicion_jugador -= 1
    end

    def jugar_de_nuevo
      volver_a_jugar = ''
      loop do
        puts 'Deseas volver a jugar ? 1.Si 2.No'
        volver_a_jugar = STDIN.gets.chomp
        volver_a_jugar = volver_a_jugar.to_i
        break if (volver_a_jugar == 1) || (volver_a_jugar == 2)
      end
      volver_a_jugar
    end

  end
  # clase para comprobar si algun jugador ha ganado
  class ComprobarGane
    attr_accessor :tablero
    def initialize(tablero)
      @tablero = tablero
    end

    def linea_ganadora_vertical(columna, simbolo, respuesta = 1)
      @tablero.tablero_inicial[columna].include? simbolo
      @tablero.tablero_inicial[columna].each do |fila|
        if fila != simbolo
          respuesta = 0
          break
        end
      end
      [respuesta, simbolo]
    end

    def linea_ganadora_horizontal(fila, simbolo, respuesta = 1)
      columna = 0
      until columna >= @tablero.tamano_tablero
        if @tablero.tablero_inicial[columna][fila] != simbolo
          respuesta = 0
          break
        end
        columna += 1
      end
      [respuesta, simbolo]
    end

    def linea_ganadora_diagonal(simbolo, respuesta = 1)
      columa_y_fila = 0
      until columa_y_fila >= @tablero.tamano_tablero
        if @tablero.tablero_inicial[columa_y_fila][columa_y_fila] != simbolo
          respuesta = 0
          break
        end
        columa_y_fila += 1
      end
      [respuesta, simbolo]
    end

    def linea_ganadora_diagonal_opuesta(simbolo, respuesta = 1)
      columna = 0
      fila = @tablero.tamano_tablero - 1
      until columna >= @tablero.tamano_tablero
        if @tablero.tablero_inicial[columna][fila] != simbolo
          respuesta = 0
        end
        columna += 1
        fila -= 1
      end
      [respuesta, simbolo]
    end
  end

  tablero = Tablero.new
  jugadores = Jugadores.new
  juego = Juego.new(tablero, jugadores)
  probar_gane = ComprobarGane.new(tablero)

  loop do
    tablero.definir_tamano_tablero
    tablero.inicializar_tablero_inicial
    tablero.calcular_tamano_tablero
    jugadores.jugador1
    jugadores.jugador2
    tiros = 0
    tiros_para_formar_linea = juego.tiros_para_ganar.call
    penultimo_tiro = false
    penultimo_tiro = true if tablero.tamano_tablero.even?
    tablero.mostrar_tablero.call
    simb_j1 = jugadores.simbolo_j1
    simb_j2 = jugadores.simbolo_j2
    until tiros >= tablero.tablero
      juego.turno_jugador(simb_j1, jugadores.jugador_1)
      tiros += 1
      tablero.mostrar_tablero.call
      if tiros >= tiros_para_formar_linea
        linea_ganadora = probar_gane.linea_ganadora_vertical(juego.columna, simb_j1)
        break if linea_ganadora[0] == 1

        linea_ganadora = probar_gane.linea_ganadora_horizontal(juego.fila, simb_j1)

        break if linea_ganadora[0] == 1

        linea_ganadora = probar_gane.linea_ganadora_diagonal(simb_j1)
        break if linea_ganadora[0] == 1

        linea_ganadora = probar_gane.linea_ganadora_diagonal_opuesta(simb_j1)
        break if linea_ganadora[0] == 1

      end
      break if tiros >= tablero.tablero

      juego.turno_jugador(simb_j2, jugadores.jugador_2)
      tablero.mostrar_tablero.call
      if tiros >= tiros_para_formar_linea
        linea_ganadora = probar_gane.linea_ganadora_vertical(juego.columna, simb_j1)
        break if linea_ganadora[0] == 1

        linea_ganadora = probar_gane.linea_ganadora_horizontal(juego.fila, simb_j2)
        break if linea_ganadora[0] == 1

        linea_ganadora = probar_gane.linea_ganadora_diagonal(simb_j2)
        break if linea_ganadora[0] == 1

        linea_ganadora = probar_gane.linea_ganadora_diagonal_opuesta(simb_j2)
        break if linea_ganadora[0] == 1

      end

      tiros += 1
    end

    empieza = 'El primero en empezar es el jugador '
    if linea_ganadora[0] == 1
      ganador = 'El ganador es el jugador '
      puts linea_ganadora[1] == simb_j1 ? ganador + '1' : ganador + '2'
      puts linea_ganadora[1] == simb_j1 ? empieza + '2' : empieza + '1'
    else
      puts "-----**** Empate ****-----"
      puts penultimo_tiro == true ? empieza + '1' : empieza + '2'
    end

    volver_a_jugar = juego.jugar_de_nuevo
    break if volver_a_jugar == 2
  end

end
