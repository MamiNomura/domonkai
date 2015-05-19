class Member < ActiveRecord::Base
  belongs_to :shachu, :class_name => "Member", :foreign_key => "sensei_member_id"
  has_many :students, :class_name => "Member", :foreign_key => "sensei_member_id"
  belongs_to :shikaku_kubun


end