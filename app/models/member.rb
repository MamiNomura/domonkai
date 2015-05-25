class Member < ActiveRecord::Base
  belongs_to :shachu, :class_name => "Member", :foreign_key => "sensei_member_id"
  has_many :students, :class_name => "Member", :foreign_key => "sensei_member_id"
  belongs_to :shikaku_kubun


  validates :phone, allow_nil: true,  numericality: { only_integer: true }
  validates :fax, allow_nil: true,  numericality: { only_integer: true }
  validates :domonkai_id,  presence: true, uniqueness: true
  validates :first_name,  presence: true
  validates :last_name,  presence: true
  validates :japanese_first_name,  presence: true
  validates :japanese_last_name,  presence: true


  def shachu_name
    unless self.shachu.nil?
      self.shachu.last_name
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
                    'fax', 'email', 'phone', 'tea_name', 'japanese_tea_name', 'language' ]
  end


  def self.DOMONKAI_ID_LABEL
    'ID'
  end
  def self.SHIKAKU_LABEL
    'Shikaku'
  end
  def self.SHACHU_LABEL
    'Shachu'
  end
  def self.JAPANESE_ADDRESS_LABEL
    "住所"
  end
  def self.JAPANESE_LASTNAME_LABEL
    "苗字 （Last Name)"
  end
  def self.JAPANESE_FIRSTNAME_LABEL
    "名前 (First Name)"
  end
  def self.JAPANESE_CHAMEI_LABEL
    "茶名"
  end
  def self.JAPANESE_SHACHU_LABEL
    "社中"
  end
  def self.JAPANESE_SHIKAKU_LABEL
    "資格区分"
  end
  def self.JAPANESE_SEX_LABEL
    "性別"
  end
  def self.ADDRESS_LABEL
    "Address"
  end
end