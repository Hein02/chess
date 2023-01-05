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
end
