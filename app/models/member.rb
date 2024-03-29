class Member < ActiveRecord::Base
  belongs_to :shachu, optional: true, :class_name => "Member", :foreign_key => "sensei_member_id"
  # has_many :students, :class_name => "Member", :foreign_key => "sensei_member_id", :optional => true
  belongs_to :shikaku_kubun




  validates :domonkai_id,  presence: true, uniqueness: true
  validates :first_name,  presence: true
  validates :last_name,  presence: true
  validates :japanese_first_name,  presence: true
  validates :japanese_last_name,  presence: true

  def phone=(phone)
    unless phone.nil?
      write_attribute(:phone, phone.gsub(/\D/, ''))
    end
  end

  def fax=(fax)
    unless fax.nil?
      write_attribute(:fax, fax.gsub(/\D/, ''))
    end
  end

  def shachu_name
    unless self.shachu.nil?
      self.shachu.last_name
    end
  end

  def shachu_book_name
    unless self.shachu.nil?
      self.shachu.last_name + ' ' + self.shachu.first_name
    end
  end

  def japanese_shachu_name
    unless self.shachu.nil?
      self.shachu.japanese_last_name
    end
  end

  def shikaku_kubun_name
    unless self.shikaku_kubun.nil?
      self.shikaku_kubun.name
    end
  end

  def shikaku_kubun_japanese_name
    unless self.shikaku_kubun.nil?
      self.shikaku_kubun.japanese_name
    end
  end

  def self.allowed_attributes
    [ 'domonkai_id', 'first_name', 'last_name', 'japanese_last_name', 'japanese_first_name',
      'fax', 'email', 'phone', 'tea_name', 'japanese_tea_name', 'language', 'shikaku_kubun_id',
      'address', 'city', 'zip', 'state', 'country', 'sex', 'record_updated', 'sensei_member_id',
      'yakuin', 'record_updated'
    ]
  end

  scope :kojin, -> { where "sensei_member_id is null" }
  scope :kyoju, -> { where "shikaku_kubun_id in (1,2)" }
  scope :shikaku, -> { where "shikaku_kubun_id = 3" }
  scope :ippan, -> { where "shikaku_kubun_id = 4" }



end
