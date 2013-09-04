require 'singleton'

require 'rclife/version'

module RCLife

  module Rules
    @rules =
      lambda do
        rules = {}

        # Live cells die with fewer than two neighbors
        [0, 1].each { |n| rules[[:live, n]] = :dead }

        # Live cells with two or three neighbors live
        [2, 3].each { |n| rules[[:live, n]] = :live }

        # Live cells with more than three neighbors die
        (4..8).each { |n| rules[[:live, n]] = :dead }

        # Dead cells with three neighbors respawn
        rules[[:dead, 3]] = :live

        # Dead cells without three neighbors ... stay dead
        (0..2).each { |n| rules[[:dead, n]] = :dead }
        (4..8).each { |n| rules[[:dead, n]] = :dead }

        return rules
      end.call

    def self.apply(state, neighbor_states)
      @rules[[state, neighbor_states.count(:live)]]
    end

    private

      def self.init_rules
        rules = {}

        # Live cells die with fewer than two neighbors
        [0, 1].each { |n| rules[[:live, n]] = :dead }

        # Live cells with two or three neighbors live
        [2, 3].each { |n| rules[[:live, n]] = :live }

        # Live cells with more than three neighbors die
        (4..8).each { |n| rules[[:live, n]] = :dead }

        # Dead cells with three neighbors respawn
        rules[[:dead, 3]] = :live

        # Dead cells without three neighbors ... stay dead
        (0..2).each { |n| rules[[:live, n]] = :dead }
        (4..8).each { |n| rules[[:live, n]] = :dead }

        return rules
      end

  end

  class Cell

    attr_reader :state

    def initialize(i, j, state = :live)
      @pos = { :i => i, :j => j }
      @state = state
    end

  end

  class Grid

    attr_reader :width, :height

    def initialize(width, height)
      @width = width
      @height = height
      @grid = init_grid()

      @rel_neighbors = relative_neighbors()
    end

    def [](i, j)
      if ((0...@height).include? i and (0...@width).include? j)
        @grid[i][j]
      else
        raise IndexError, 
          "(#{i}, #{j}) out of range for #{height} x #{width} grid."
      end
    end

    def neighbors(i, j)
      @rel_neighbors.map { |c| @grid[c[0] + i][c[1] + j] }
    end

    def step
      new_grid = init_grid()

      @height.times do |i|
        @width.times do |j|
          new_grid[i][j] = apply_rules(i, j)
        end
      end

      @grid = new_grid
    end

    private

      def apply_rules(i, j)
        @rel_neighbors.map { |c| 
          [c[0] + i, c[1] + j] 
        }.reduce { |a, b| @grid[a] + b }
      end

      def init_grid
        Array.new(@height) do |i|
          Array.new(@width) do |j|
            Cell.new(self, i, j)
          end
        end
      end

      def relative_neighbors
        [-1, 0, 1].repeated_combination(2).flat_map do |p| 
          p.permutation.to_a
        end.uniq - [[0,0]]
      end

  end

end
