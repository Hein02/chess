# frozen_string_literal: true

require_relative '../lib/piece'

describe Piece do
  subject(:pc) { described_class.new(:w, :P) }

  describe '#find_hor_dir' do
    context 'when given dir ends with W' do
      it 'returns :W' do
        hor_dir = pc.find_hor_dir(:W)
        expect(hor_dir).to eq(:W)
      end
    end

    context 'when given dir does not ends with W' do
      it 'returns :W' do
        hor_dir = pc.find_hor_dir(:N)
        expect(hor_dir).to be_nil
      end
    end

    context 'when given dir ends with E' do
      it 'returns :W' do
        hor_dir = pc.find_hor_dir(:E)
        expect(hor_dir).to eq(:E)
      end
    end

    context 'when given dir does not ends with E' do
      it 'returns :W' do
        hor_dir = pc.find_hor_dir(:S)
        expect(hor_dir).to be_nil
      end
    end
  end
end
