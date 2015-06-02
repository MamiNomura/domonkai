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
    move_down 20


    define_grid(:columns => 3, :rows => 6, :gutter => 10)
    grid.show_all

    footer
    final_page

  end

  def order_number
    text "#{@order.order_number}", size: 30, style: :bold
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

  def final_page
    start_new_page

    move_down 20
    font "fonts/aozoramincho-readme-ttf/AozoraMinchoHeavy.ttf" do
      text "教授者 資格者", :align => :center, :size => 14
    end
    move_down 10


    text "Teachers & Instructors", :align => :center, :size => 14



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
      text "Kyojusha - Teacher", :align => :center, :size => 12
      move_down 25


      kyouju.each do |member|
        member_info = member.domonkai_id.to_s + ' ' + member.last_name + ', ' +
            member.first_name.to_s + ' '+ member.japanese_tea_name + ' '+ member.tea_name

        font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
          text "#{member_info}", size: 10
          move_down 3
        end
      end
    end

    grid([0,1],[0,1]).bounding_box do
      move_down 100
      font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
        text "講師 (取次者)", :align => :center, :size => 13
      end
      move_down 5
      text "Kyojusha - Teacher", :align => :center, :size => 12
      move_down 25


      koushi.each do |member|
        member_info = member.domonkai_id.to_s + ' ' + member.last_name + ', ' +
            member.first_name.to_s + ' '+ member.japanese_tea_name.to_s + ' '+ member.tea_name.to_s

        font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
          text "#{member_info}", size: 10
          move_down 3
        end
      end
    end


    grid([0,2],[0,2]).bounding_box do
      move_down 100
      font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
        text "資格者", :align => :center, :size => 13
      end
      move_down 5
      text "Shikakusha - Qualified Instructors", :align => :center, :size => 12
      move_down 15


      shikaku.each do |member|
        member_info = member.domonkai_id.to_s + ' ' + member.last_name + ', ' +
            member.first_name.to_s + ' '+ member.japanese_tea_name.to_s + ' '+ member.tea_name.to_s

        font "fonts/aozoramincho-readme-ttf/AozoraMinchoRegular.ttf" do
          text "#{member_info}", size: 10
          move_down 3
        end
      end
    end



  end

  def line_items
    move_down 20
    table member_rows do
      row(0).font_style = :bold
      columns(1..3).align = :right
      #self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = false
    end
  end

  def member_rows
    @members.each do |member|
    [member.last_name + member.first_name]
    end
  end
  def line_item_rows
    [["Product", "Qty", "Unit Price", "Full Price"]] +
        @order.line_items.map do |item|
          [item.name, item.quantity, price(item.unit_price), price(item.full_price)]
        end
  end

  def price(num)
    @view.number_to_currency(num)
  end

  def total_price
    move_down 15
    text "Total Price: #{price(@order.total_price)}", size: 16, style: :bold
  end


  private

  def generate_grid()
    define_grid({ :columns  => 3,:rows   => 6})

  end

  def row_col_from_index(index)
    page, new_index = index.divmod(grid.rows * grid.columns)
    if new_index == 0 and page > 0
      start_new_page
      generate_grid
      return [0,0]
    end
    return new_index.divmod(grid.columns)
  end

  def create_label(index, record, options = {},  &block)
    p = row_col_from_index(index)

    shrink_text(record) if options[:shrink_to_fit] == true

    b = grid(p.first, p.last)

    if options[:vertical_text]
      rotate(270, :origin => b.top_left) do
        translate(0, b.width) do
          bounding_box b.top_left, :width => b.height, :height => b.width do
            yield record
          end
        end
      end
    else
      bounding_box b.top_left, :width => b.width, :height => b.height do
        yield record
      end
    end

  end

  def shrink_text(record)
    linecount = (split_lines = record.split("\n")).length

    # 30 is estimated max character length per line.
    split_lines.each {|line| linecount += line.length / 30 }

    # -10 accounts for the overflow margins
    rowheight = grid.row_height - 10

    if linecount <= rowheight / 12.floor
      font_size = 12
    else
      font_size = rowheight / (linecount + 1)
    end
  end


end