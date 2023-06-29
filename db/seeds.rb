# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

ShikakuKubun.create :name => "kyoju", :japanese_name => "教授（取次者）"
ShikakuKubun.create :name => "koushi toritugi", :japanese_name => "講師（取次者）"
ShikakuKubun.create :name => "shikaku-sha", :japanese_name => "講師"
ShikakuKubun.create :name => "ippan", :japanese_name => "一般会員"