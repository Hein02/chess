# frozen_string_literal: true

require_relative '../lib/model'

describe Model do
  let(:brd) { double('board') }
  let(:w_player) { double('player') }
  let(:b_player) { double('player') }
  subject(:model) { described_class.new(brd, w_player, b_player) }

  describe '#select_pc' do
    it 'calls Board#find_pc' do
      sqr = :a1
      expect(brd).to receive(:find_pc).with(sqr)
      model.select_pc(sqr)
    end
  end

  describe '#find_movement' do
    let(:pc) { double('piece') }

    it 'calls Piece#movement' do
      sqr = :a1
      expect(pc).to receive(:movement).with(sqr)
      model.find_movement(pc, sqr)
    end
  end

  describe '#move_pc' do
    it 'calls Board#reassign_pc' do
      from = :a2
      to = :a4
      expect(brd).to receive(:reassign_pc).with(from, to)
      model.move_pc(from, to)
    end
  end

  describe '#record_king_sqr' do

    it 'calls Player#update_king_sqr' do
      sqr = :a2
      cur_p = model.instance_variable_get(:@cur_p)
      expect(cur_p).to receive(:update_king_sqr).with(sqr)
      model.record_king_sqr(sqr)
    end
  end

  describe '#king_in_check?' do
    let(:king) { double('king') }

    it 'calls King#in_check?' do
      expect(king).to receive(:in_check?)
      model.king_in_check?(king)
    end
  end

  describe '#move_back' do
    it 'calls Board#reassign_pc with arguments in reverse order' do
      from = :a1
      to = :a3
      expect(brd).to receive(:reassign_pc).with(to, from)
      model.move_back(from, to)
    end
  end

  describe '#record_first_move' do
    let(:king) { double('king') }

    it 'calls Piece#first_move with true' do
      expect(king).to receive(:update_first_move).with(true)
      model.record_first_move(king)
    end
  end

  describe '#switch_player' do
    subject(:model_switch) { described_class.new(brd, w_player, b_player) }

    context 'when current player is white' do
      it 'switches to black player' do
        model_switch.switch_player
        cur_p = model_switch.instance_variable_get(:@cur_p)
        expect(cur_p).to eq(b_player)
      end
    end

    context 'when current player is black' do
      it 'switches to white player' do
        model_switch.instance_variable_set(:@cur_p, :b_player)
        model_switch.switch_player
        cur_p = model_switch.instance_variable_get(:@cur_p)
        expect(cur_p).to eq(w_player)
      end
    end
  end
end
