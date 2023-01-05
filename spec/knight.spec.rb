# frozen_string_literal: true

require_relative '../lib/knight'

describe Knight do
  subject(:knight) { described_class.new(:w) }

  describe '#knight_find_paths' do
    it 'returns the correct sq in arr for given dir' do
      path = knight.knight_find_path(:d4, :NE)
      expect(path[0]).to eq(:e6)
    end
  end

  describe '#collect_paths' do
    it 'returns the correct sq in arr for given dir' do
      actual = knight.collect_paths(:d5)
      paths = {
        NE: [:e7],
        NW: [:c7],
        SE: [:e3],
        SW: [:c3],
        EN: [:f6],
        ES: [:f4],
        WN: [:b6],
        WS: [:b4]
      }
      expect(actual).to eq(paths)
    end
  end
end
