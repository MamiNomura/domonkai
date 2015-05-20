class Member < ActiveRecord::Base
  belongs_to :shachu, :class_name => "Member", :foreign_key => "sensei_member_id"
  has_many :students, :class_name => "Member", :foreign_key => "sensei_member_id"
  belongs_to :shikaku_kubun

  validates :phone, numericality: { only_integer: true }
  validates :fax, numericality: { only_integer: true }
  validates :domonkai_id,  presence: true, uniqueness: true
  validates :first_name,  presence: true
  validates :last_name,  presence: true
  validates :japanese_first_name,  presence: true
  validates :japanese_last_name,  presence: true
end