require 'singleton'

require 'rclife/version'

module RCLife

  module Rules
    @rules = Hash[
        # Live cells die with fewer than two neighbors
        [0, 1].map { |n| [[:live, n], :dead] } +

        # Live cells with two or three neighbors live
        [2, 3].map { |n| [[:live, n], :live] } +

        # Live cells with more than three neighbors die
        (4..8).map { |n| [[:live, n], :dead] } +

        # Dead cells with three neighbors respawn
        [[[:dead, 3], :live]] +

        # Dead cells without three neighbors ... stay dead
        (0..2).map { |n| [[:dead, n], :dead] } +
        (4..8).map { |n| [[:dead, n], :dead] }
    ]

    def self.apply(state, neighbor_states)
      @rules[[state, neighbor_states.count(:live)]]
    end

  end

  class Cell

    attr_reader :state
    attr_reader :i, :j

    def initialize(i, j, state = :dead)
      if not [:live, :dead].include?(state)
        raise "Cell state must be :live or :dead. Got: #{state.to_s}"
      else
        @i = i
        @j = j
        @state = state
      end
    end

  end

  class Grid

    attr_reader :width, :height

    def initialize(width, height)
      @width = width
      @height = height
      @grid = init_grid()
    end

    def [](i, j)
      if in_bounds?(i, j)
        @grid[i][j].state
      else
        nil
      end
    end

    def []=(i, j, state)
      if in_bounds?(i, j)
        @grid[i][j] = Cell.new(i, j, state)
      else
        nil
      end
    end

    def step
      new_grid = @grid.map do |row|
        row.map do |cell|
          new_state = Rules.apply(cell.state, neighbor_states(cell))
          Cell.new(cell.i, cell.j, new_state)
        end
      end

      @grid = new_grid
    end

    def pretty_print
      chars = { :live => ?#, :dead => ?. }

      @height.times do |i|
        @width.times do |j|
          print chars[@grid[i][j].state]
        end
        puts
      end
    end

    private

      # The relative coordinates of any given cell's immediate neighbors.
      REL_NEIGHBORS = 
        [-1, 0, 1].repeated_combination(2).flat_map do |p| 
          p.permutation.to_a
        end.uniq - [[0,0]]

      # Initialize a new grid of dead cells.
      def init_grid
        Array.new(@height) do |i|
          Array.new(@width) do |j|
            Cell.new(i, j)
          end
        end
      end

      # Calculate the absolute coordinates of the neighbors of a given cell.
      # +cell+:: cell whose neighbors you want to calculate.
      def neighbor_states(cell)
        REL_NEIGHBORS.map do |c| 
          self[c[0] + cell.i, c[1] + cell.j]
        end.select { not nil }
      end

      # Returns true iff (i, j) is on the grid.
      def in_bounds?(i, j)
        ((0...@height).include? i and (0...@width).include? j)
      end

  end

end
