require 'rails_helper'

RSpec.describe 'User', type: :model do

  describe 'バリデーション' do
    let(:user) { build(:user) }

    describe 'アソシエーション' do
      context 'Bookモデルに対して' do
        it 'たくさんのbookを持っている' do
          expect(User.reflect_on_association(:books).macro).to eq :has_many
        end
      end
    end

    context 'nameカラム' do
      it '空欄だと怒られる' do
        user.name = ''
        expect(user.valid?).to eq(false)
      end
      it '2文字以上であること' do
        user.name = Faker::Lorem.characters(number:1)
        expect(user.valid?).to eq(false)
      end
      it '20文字以下であること' do
        user.name = Faker::Lorem.characters(number:21)
        expect(user.valid?).to eq(false)
      end
    end

    context 'bio' do
      let(:user) { build(:user) }
      it '50文字以下であること' do
        user.bio = Faker::Lorem.characters(number:51)
        expect(user.valid?).to eq(false)
      end
    end

  end

end
