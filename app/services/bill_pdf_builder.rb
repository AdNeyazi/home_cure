class BillPdfBuilder
  def initialize(bill)
    @bill = bill
  end

  def render
    require "prawn"

    Prawn::Document.new(page_size: "A4", margin: 30) do |pdf|
      pdf.font_size 10
      build_header(pdf)
      build_patient_details(pdf)
      build_line_items(pdf)
      build_totals(pdf)
      build_footer(pdf)
    end.render
  end

  private

  attr_reader :bill

  def build_header(pdf)
    pdf.text "Care Clinical Lab", size: 20, style: :bold
    pdf.text "Opp. New police station, Near police line bus stop", size: 10
    pdf.text "Phone no.: Lab : 7447868244, Customer care : 07109-295921", size: 10
    pdf.move_down 10
    pdf.text "Bill / Reg. no: #{bill.bill_number}", size: 11, style: :bold
    pdf.stroke_horizontal_rule
    pdf.move_down 12
  end

  def build_patient_details(pdf)
    label_width = 105
    value_width = 200
    right_label_width = 95

    left_details = [
      [ "Name", bill.patient.full_name ],
      [ "Age / Sex", "#{bill.patient.age.presence || "-"} / #{bill.patient.gender.presence || "-"}" ],
      [ "Mobile number", bill.patient.phone_number.presence || "-" ]
    ]

    right_details = [
      [ "Date", bill.bill_date.strftime("%d/%m/%Y") ],
      [ "Referred by", bill.patient.doctor&.full_name.presence || "Self / Walk-in" ],
      [ "Received by", "CARE CLINICAL LAB" ]
    ]

    pdf.bounding_box([ pdf.bounds.left, pdf.cursor ], width: pdf.bounds.width, height: 70) do
      left_details.each_with_index do |(label, value), index|
        y = 68 - (index * 20)
        pdf.draw_text "#{label}:", at: [ 0, y ], style: :bold
        pdf.draw_text value.to_s, at: [ label_width, y ]
      end

      right_x = label_width + value_width
      right_details.each_with_index do |(label, value), index|
        y = 68 - (index * 20)
        pdf.draw_text "#{label}:", at: [ right_x, y ], style: :bold
        pdf.draw_text value.to_s, at: [ right_x + right_label_width, y ]
      end
    end

    pdf.move_down 8
  end

  def build_line_items(pdf)
    start_y = pdf.cursor
    col_sno = 44
    col_name = 360
    col_amount = 106
    row_height = 24

    draw_cell(pdf, pdf.bounds.left, start_y, col_sno, row_height, "S. No.", bold: true, align: :center, bg: "E6F4F1")
    draw_cell(pdf, pdf.bounds.left + col_sno, start_y, col_name, row_height, "Investigations", bold: true, bg: "E6F4F1")
    draw_cell(pdf, pdf.bounds.left + col_sno + col_name, start_y, col_amount, row_height, "Amount", bold: true, align: :right, bg: "E6F4F1")

    y = start_y - row_height
    bill.bill_items.each_with_index do |item, index|
      draw_cell(pdf, pdf.bounds.left, y, col_sno, row_height, (index + 1).to_s, align: :center)
      draw_cell(pdf, pdf.bounds.left + col_sno, y, col_name, row_height, item.test.name.to_s)
      draw_cell(pdf, pdf.bounds.left + col_sno + col_name, y, col_amount, row_height, "Rs.#{format_amount(item.line_total)}", align: :right)
      y -= row_height
    end

    pdf.move_cursor_to(y - 8)
  end

  def build_totals(pdf)
    left_width = 150
    value_width = 120
    x = pdf.bounds.right - (left_width + value_width)

    lines = [
      [ "Total amount", "Rs.#{format_amount(bill.gross_amount)}" ],
      [ "Discount", "Rs.#{format_amount(bill.total_discount)}" ],
      [ "Amount paid", "Rs.#{format_amount(bill.amount_paid)}" ],
      [ "Amount due", "Rs.#{format_amount(bill.amount_due)}" ]
    ]

    lines.each do |label, value|
      pdf.text_box "#{label}:", at: [ x, pdf.cursor ], width: left_width, height: 16, style: :bold
      pdf.text_box value, at: [ x + left_width, pdf.cursor ], width: value_width, height: 16, align: :right
      pdf.move_down 16
    end

    pdf.move_down 4
    pdf.text "Amount Paid (in words): #{bill.amount_paid_in_words.to_s.capitalize}", style: :bold
    pdf.move_down 10
  end

  def build_footer(pdf)
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    pdf.text "~~~ Thank You ~~~", align: :center, style: :bold, size: 12
  end

  def format_amount(amount)
    format("%.2f", amount.to_d)
  end

  def draw_cell(pdf, x, y, width, height, text, align: :left, bold: false, bg: nil)
    if bg
      pdf.fill_color bg
      pdf.fill_rectangle [ x, y ], width, height
      pdf.fill_color "000000"
    end

    pdf.stroke_rectangle [ x, y ], width, height

    pdf.font("Helvetica", style: (bold ? :bold : :normal)) do
      text_x = x + 6
      text_width = width - 12
      pdf.text_box text.to_s, at: [ text_x, y - 7 ], width: text_width, height: height, valign: :center, align: align, overflow: :truncate
    end
  end
end
