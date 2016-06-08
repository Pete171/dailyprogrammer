$:.unshift File.dirname(__FILE__)
require 'rectangle_generator'
require 'rectangle_finder'
require 'rectangle_output_ascii'

class RectangleGame
  INIT = 0
  NEW_DIAGRAM = 1
  SHOW_DIAGRAM = 2
  WAITING_FOR_ANSWER = 3
  SET_OPTIONS = 4
  SHOW_OPTIONS = 5
  SHOW_PRESETS = 6
  SET_PRESET = 7
  EXIT = 8

  OPTIONS = [
    { name: "Row Count", property_name: "row_count" },
    { name: "Column Count", property_name: "col_count" },
    { name: "Minimum Rectangles", property_name: "min_rectangles" },
    { name: "Maximum Rectangles", property_name: "max_rectangles" },
  ]


  PRESETS = {
    "1" => {
      name: "Easy",
      options: {
        row_count: 10,
        col_count: 10,
        min_rectangle_height: 3,
        max_rectangle_height: 5,
        min_rectangle_width: 3,
        max_rectangle_width: 5,
        min_rectangles: 1,
        max_rectangles: 3,
        escape_count: 300,
      },
    },
    "2" => {
      name: "Normal",
      options: {
        row_count: 12,
        col_count: 16,
        min_rectangle_height: 3,
        max_rectangle_height: 5,
        min_rectangle_width: 3,
        max_rectangle_width: 5,
        min_rectangles: 3,
        max_rectangles: 12,
        escape_count: 600,
      },
    },
    "3" => {
      name: "Hard",
      options: {
        row_count: 24,
        col_count: 28,
        min_rectangle_height: 3,
        max_rectangle_height: 7,
        min_rectangle_width: 3,
        max_rectangle_width: 7,
        min_rectangles: 5,
        max_rectangles: 15,
        escape_count: 1800,
      },
    },
    "4" => {
      name: "AWFUL.",
      options: {
        row_count: 24,
        col_count: 28,
        min_rectangle_height: 3,
        max_rectangle_height: 7,
        min_rectangle_width: 3,
        max_rectangle_width: 7,
        min_rectangles: 10,
        max_rectangles: 40,
        escape_count: 1800,
      },
    },
  }

  def initialize
    @generator = RectangleGenerator.new(RectangleOutputAscii.new)
    @finder = RectangleFinder.new
    @state = INIT
  end
  
  def loop
    run = true
    while run do
      case @state
      when INIT
        _doInit
      when NEW_DIAGRAM
        _newDiagram
      when SHOW_DIAGRAM
        _showDiagram
      when WAITING_FOR_ANSWER
        _waitingForAnswer
      when SHOW_OPTIONS
        _showOptions
      when SET_OPTIONS
        _setOptions
      when SHOW_PRESETS
        _showPresets
      when SET_PRESET
        _setPreset
      when EXIT
        puts "Goodbye."
        run = false
      else
        raise "Unexpected state"
      end
    end
  end

  def _getInput
  end

  def _doInit
    puts "Starting game.  Type 'show' to show options, 'set' to set options, 'show presets' to show presets, 'set preset' to set presets, 'quit' to exit.  Press any other key to continue."
    input = $stdin.gets.chomp
    if input == 'show' then
      state = SHOW_OPTIONS
    elsif input == 'set' then
      state = SET_OPTIONS
    elsif input == 'show presets' then
      state = SHOW_PRESETS
    elsif input == 'set preset' then
      state = SET_PRESET
    elsif input == 'quit' then
      state = EXIT
    else
      state = NEW_DIAGRAM
    end
    @state = state
  end

  def _newDiagram
    @active_diagram = @generator.run
    @active_diagram_answer = @finder.run(@active_diagram)
    @state = SHOW_DIAGRAM
  end

  def _showDiagram
    puts "How many squares do you see?"
    puts "------------"
    puts @active_diagram
    puts "------------"
    puts "Your answer:"
    @state = WAITING_FOR_ANSWER
  end

  def _waitingForAnswer
    input = $stdin.gets.chomp
    if input == 'quit' then
      state = EXIT
    elsif input == 'show' then
      state = SHOW_DIAGRAM
    else
      answer = input.to_i
      if input == 'c' || answer ==  @active_diagram_answer then
        puts "Yes! Press any key to play again.  (Type 'quit' to exit.)"
        input = $stdin.gets.chomp
        state = input != 'quit' ? NEW_DIAGRAM : EXIT
      else
        puts "No!  Please try again.  (Type 'quit' to exit.  Type 'show' to redisplay the diagram.)"
        state = WAITING_FOR_ANSWER
      end
    end
    @state = state
  end

  def _showOptions
    OPTIONS.each do |option|
      puts option[:name] + ": " + @generator.public_send(option[:property_name]).to_s
    end
    @state = INIT
  end

  def _setOptions
    OPTIONS.each do |option|
      puts option[:name] + ":"
      value = $stdin.gets.chomp.to_i
      @generator.public_send(option[:property_name]+"=", value)
    end
    @state = INIT
  end

  def _showPresets
    PRESETS.each do |key, preset|
      puts "[#{key}] #{preset[:name]}"
    end
    @state = INIT
  end

  def _setPreset
    preset_key = $stdin.gets.chomp
    p preset_key
    preset = PRESETS.fetch(preset_key)#TODO-something if not present
    preset[:options].each do |option, value|
      @generator.public_send(option.to_s+"=", value)
    end
    @state = INIT
  end
end

r = RectangleGame.new
r.loop
