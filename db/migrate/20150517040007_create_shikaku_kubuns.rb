class CreateShikakuKubuns < ActiveRecord::Migration
  def change
    create_table :shikaku_kubuns do |t|
      t.string :name
      t.string :japanese_name
      t.timestamps
    end

    ShikakuKubun.create :name => "kyoju-sha", :japanese_name => "教授（取次者）"
    ShikakuKubun.create :name => "shikaku-sha", :japanese_name => "講師"
    ShikakuKubun.create :name => "ippan", :japanese_name => "一般会員"
  end
end
