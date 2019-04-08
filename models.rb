require 'sinatra'
require 'sinatra/activerecord'

class Poop < ActiveRecord::Base
  validates_presence_of :user_id, :session_id, :aws_timestamp, :locale
  scope :user_day_poops, -> (user_id) do 
    where(user_id: user_id)
      .where('DATE(aws_timestamp) = ?', Date.today)
  end
end
