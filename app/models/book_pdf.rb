#!/bin/env ruby
# encoding: utf-8

class BookPdf < Prawn::Document
  def initialize(members, view)
    super(top_margin: 36, bottom_margin: 36, left_margin: 36, right_mergin: 36, page_size: 'A4')

    #font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf"


    @members = members
    @view = view

    front_page
    header


    member_label_page
    footer
    final_page

  end


  def front_page

    text Date::MONTHNAMES[Date.today.month] + ' ' + Date.today.year.to_s , :align => :center, :size => 30

    move_down 20
    font "fonts/aozoramincho-readme-ttf/AozoraMinchoHeavy.ttf" do
      text "表千家", :align => :center, :size => 50
    end
    move_down 10


    font "fonts/aozoramincho-readme-ttf/AozoraMinchoHeavy.ttf" do
      text "同門会米国北加支部", :align => :center, :size => 40
    end
    move_down 10

    font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
      text "会員名簿", :align => :center, :size => 30
    end


    move_down 60

    text "Omotesenke", :size => 50, :align => :center

    text "Domonkai Northern California Region", :size => 30
    text "Membership Directory",  :size => 25, :align => :center

    move_down 80
    font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
      text "この会員名簿は表千家同門会以外での使用を禁じます。",  :size => 18
    end
    move_down 5
    text "Membership use only", :size => 18

    move_down 130
    text "1759 Sutter St."
    text "San Francisco, CA 94115"
    text "URL: http://www.omotesenke.jp/english/goannai/ncalif.html"
    move_down 20
    font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
      text "表千家ホームページアドレス"
    end
    move_down 5
    text "Omotesenke Home Page"

    text "http://www.omotesenke.jp"

    start_new_page
  end

  def header
    repeat lambda{ |pg| pg > 1 } do
      bounding_box [bounds.left, bounds.top + 25], :width  => bounds.width do

        font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
          text "表千家同門会米国北加支部 - 05", :align => :center, :size => 11
        end
        move_down 8
        text "Omotesenke Domonkai Northern California Region - 05", :align => :center, :size => 11
        stroke_horizontal_rule
        move_down 10
      end
    end
  end

  def footer
    string = "- <page> - "
    # Green page numbers 1 to 7
    options = { :at => [bounds.right - 50, 0],
                :align => :center,
                :page_filter => lambda{ |pg| pg > 1 },
                :start_count_at => 1,
                :size => 12
    }
    number_pages string, options
  end

  def create_grid
    define_grid(:columns => 3, :rows => 5, :gutter => 5, :row_gutter => 0, :column_gutter => 0)
    #grid.show_all
  end
  def member_label_page

    create_grid

    i = 0
    j = 0
    @members.each do |member|

      member_one = '(' + member.language.to_s + ') '+ member.last_name.to_s + ', ' + member.first_name.to_s
      member_two = member.japanese_last_name.to_s + ' ' + member.japanese_first_name.to_s

      member_list = []

      if member.shikaku_kubun_id.eql? 4
        two = '#05-' + member.domonkai_id.to_s
      else
        two = '#05-' + member.domonkai_id.to_s + ' ' + member.shikaku_kubun.japanese_name.to_s
      end
      member_list << two

      unless [1,2].include?(member.shikaku_kubun_id?)
        tea_names = member.tea_name.to_s + ' ' + member.japanese_tea_name.to_s
        tea_names = tea_names.strip
        unless tea_names.nil?
          tea_names = ' ' + tea_names
        end

        unless member.shachu.nil?
          member_list <<   member.shachu_name.to_s + ' 社中' + tea_names
        else
          member_list << '個人'+ tea_names
        end

      end


      if member.country.eql? "USA"
        member_address = member.city.to_s + ', ' + member.state.to_s + ' ' + member.zip
      else
        member_address = member.city.to_s + ', ' + member.state.to_s + ' ' + member.zip + ' ' + member.country.to_s
      end

      grid([i,j],[i,j]).bounding_box do

        if i.eql? 0
        end
        move_down 20
        text "<u><b>#{member_one}</b></u>", size: 11 , :inline_format => true
        move_down 2
        font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
          text "#{member_two}"
          move_down 3
          unless member_list.nil?
            for item in member_list do
              text item, :size => 9
              move_down 2
            end
          end
          move_down 3
          text member.address.to_s , :size => 10
          move_down 2
          text member_address , :size => 10
          move_down 5
          unless member.phone.nil?
            text "Phone: #{ActionController::Base.helpers.number_to_phone(member.phone, area_code: true).to_s}" , :size => 9
            move_down 2
          end
          unless member.fax.nil?
            text "Fax: #{ActionController::Base.helpers.number_to_phone(member.fax, area_code: true).to_s}" , :size => 9
            move_down 2
          end
          unless member.email.nil?
            text "Email: #{member.email}" , :size => 10
            move_down 2
          end
        end
      end
      j+=1
      if j == 3
        j = 0
        i+=1
      end
      if i == 5
        i = 0
        start_new_page
        create_grid
      end

    end
  end

  def final_page

    start_new_page
    move_down 20
    font "fonts/aozoramincho-readme-ttf/AozoraMinchoHeavy.ttf" do
      text "教授者 資格者", :align => :center, :size => 14
    end
    move_down 10


    text "<u>Teachers & Instructors</u>", :align => :center, :size => 14 , :inline_format => true


    kyouju = Member.where(shikaku_kubun_id: 1).order(:domonkai_id)
    koushi = Member.where(shikaku_kubun_id: 2).order(:domonkai_id)
    shikaku = Member.where(shikaku_kubun_id: 3).order(:domonkai_id)

    define_grid(:columns => 3, :rows => 1, :gutter => 5)
    grid([0,0],[0,0]).bounding_box do
      move_down 100
      font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
        text "教授 (取次者)", :align => :center, :size => 13
      end
      move_down 5
      text "<u>Kyojusha - Teacher</u>", :align => :center, :size => 12 , :inline_format => true
      move_down 25


      kyouju.each do |member|
        member_info = member.domonkai_id.to_s + ' ' + member.last_name + ', ' +
            member.first_name.to_s + ' '+ member.japanese_tea_name + ' '+ member.tea_name

        font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
          text "#{member_info}", size: 10
          move_down 4
        end
      end
    end

    grid([0,1],[0,1]).bounding_box do
      move_down 100
      font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
        text "講師 (取次者)", :align => :center, :size => 13
      end
      move_down 5
      text "<u>Kyojusha - Teacher</u>", :align => :center, :size => 12 , :inline_format => true
      move_down 25


      koushi.each do |member|
        member_info = member.domonkai_id.to_s + ' ' + member.last_name + ', ' +
            member.first_name.to_s + ' '+ member.japanese_tea_name.to_s + ' '+ member.tea_name.to_s

        font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
          text "#{member_info}", size: 10
          move_down 4
        end
      end
    end


    grid([0,2],[0,2]).bounding_box do
      move_down 100
      font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
        text "資格者", :align => :center, :size => 13
      end
      move_down 5
      text "<u>Shikakusha - Qualified Instructors</u>", :align => :center, :size => 12 , :inline_format => true
      move_down 15


      shikaku.each do |member|
        member_info = member.domonkai_id.to_s + ' ' + member.last_name + ', ' +
            member.first_name.to_s + ' '+ member.japanese_tea_name.to_s + ' '+ member.tea_name.to_s

        font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
          text "#{member_info}", size: 10
          move_down 4
        end
      end
    end



  end


end