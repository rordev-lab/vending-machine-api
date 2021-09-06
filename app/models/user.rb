# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models # added this line to extend devise model
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  after_create :reset_deposit

  enum role: { seller: 'Seller', buyer: 'Buyer' }

  def update_coins(deposit_params)
    new_deposit = JSON.parse(deposit_params[:deposit])
    user_deposited = deposit

    new_deposit.keys.each do |key|
      case key
      when "cent5"
        user_deposited[key] = user_deposited[key].to_i + new_deposit[key].to_i
      when "cent10"
        user_deposited[key] = user_deposited[key].to_i + new_deposit[key].to_i
      when "cent20"
        user_deposited[key] = user_deposited[key].to_i + new_deposit[key].to_i
      when "cent50"
        user_deposited[key] = user_deposited[key].to_i + new_deposit[key].to_i
      when "cent100"
        user_deposited[key] = user_deposited[key].to_i + new_deposit[key].to_i
      end
    end
    { deposit: user_deposited }
  end

  def reset_deposit
    self.deposit = {
      "cent5": "0",
      "cent10": "0",
      "cent20": "0",
      "cent50": "0",
      "cent100": "0"
    }
    save
  end
end
