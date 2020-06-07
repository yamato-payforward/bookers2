require 'rails_helper'

describe 'ヘッダーのテスト' do
  describe 'ログインしていない場合' do
    before do
      visit root_path
    end
    context 'リンク確認' do
      subject { page }
      it 'Homeリンクが表示される' do
        home_link = find_all('a')[0].native.attributes["href"].value
        expect(home_link).to match("")
      end
      it 'Aboutリンクが表示される' do
        about_link = find_all('a')[1].native.attributes["href"].value
        expect(about_link).to match("home/about")
      end
      it 'Sign upリンクが表示される' do
        signup_link = find_all('a')[2].native.attributes["href"].value
        expect(signup_link).to match("users/sign_up")
      end
      it 'loginリンクが表示される' do
        login_link = find_all('a')[3].native.attributes["href"].value
        expect(login_link).to match("users/sign_in")
      end
    end
  end

  describe 'ログインしている場合' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
    end

    context 'リンク確認' do
      subject { page }
      it 'Homeリンクが表示される' do
        home_link = find_all('a')[0].native.attributes["href"].value
        expect(home_link).to match("users/#{user.id}")
      end
      it 'usersリンクが表示される' do
        users_link = find_all('a')[1].native.attributes["href"].value
        expect(users_link).to match("users")
      end
      it 'booksリンクが表示される' do
        books_link = find_all('a')[2].native.attributes["href"].value
        expect(books_link).to match("books")
      end
      it 'logoutリンクが表示される' do
        logout_link = find_all('a')[3].native.attributes["href"].value
        expect(logout_link).to match("users/sign_out")
      end
    end
  end
end
