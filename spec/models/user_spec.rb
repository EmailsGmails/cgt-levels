require 'spec_helper'

include CgtraderLevels

describe User do
  describe 'new user' do
    before do
      @level = Level.create(experience: 0, title: 'First level')
      @user = User.new
    end

    it 'has 0 reputation points' do
      expect(@user.reputation).to eq(0)
    end

    it "has assigned 'First level'" do
      expect(@user.level).to eq(@level)
    end
  end

  describe 'level up' do
    before do
      @level_1 = Level.create(experience: 0, title: 'First level')
      @level_2 = Level.create(experience: 10, title: 'Second level')
      @user = User.create
    end

    it "level ups from 'First level' to 'Second level'" do

      expect {
        @user.update_attribute(:reputation, 10)
      }.to change { @user.reload.level }.from(@level_1).to(@level_2)
    end

    it "level ups from 'First level' to 'Second level'" do
      expect {
        @user.update_attribute(:reputation, 11)
      }.to change { @user.reload.level }.from(@level_1).to(@level_2)
    end
  end

  describe "associate privilege with level" do
    before do
      @level = Level.create(experience: 0, title: 'First level')
      @privilege = Privilege.create!(name: "Coins", technical_name: "coins", value: 0)
    end

    it "associates a privilege with a level" do
      @level.privileges << @privilege
      expect(@level.reload.privileges).to include(@privilege)
    end
  end

  describe 'level up privileges & privileges' do
    before do
      @privilege_1 = Privilege.create(name: "Coin Bonus", technical_name: "coins", value: 7)
      @privilege_2 = Privilege.create(name: "Tax Break", technical_name: "tax", value: -5)
      @privilege_3 = Privilege.create(name: "Coin Bonus 10", technical_name: "coins", value: 10)
      @level_1 = Level.create(experience: 0, title: 'First level')
      @level_2 = Level.create(experience: 10, title: 'Second level')
      @level_3 = Level.create(experience: 13, title: 'Third level')
      @level_4 = Level.create(experience: 20, title: 'Fourth level')
      @user = User.create(coins: 1)
    end

    it 'gives 7 coins to user' do
      @level_2.privileges << @privilege_1

      expect {
        @user.update_attribute(:reputation, 10)
      }.to change { @user.reload.coins }.from(1).to(8)
    end

    it 'reduces tax rate by 1' do
      @level_3.privileges << @privilege_2

      expect {
        @user.update_attribute(:reputation, 13)
      }.to change { @user.reload.tax }.from(30).to(25)
    end

    it 'combines privileges' do
      @level_4.privileges << @privilege_2
      @level_4.privileges << @privilege_3

      expect {
        @user.update_attribute(:reputation, 20)
      }.to change { @user.reload.coins }.from(1).to(11)
        .and change { @user.reload.tax }.from(30).to(25)
    end
  end

  describe 'user stats' do
    it "validates that tax is between 0 and 100" do
      user = CgtraderLevels::User.create(tax: 0)
      expect(user.valid?).to be true

      user.tax = -10
      expect(user.valid?).to be false
      expect(user.errors[:tax]).to include("must be greater than or equal to 0")

      user.tax = 110
      expect(user.valid?).to be false
      expect(user.errors[:tax]).to include("must be less than or equal to 100")
    end
  end
end
