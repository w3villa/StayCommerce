class InvoiceSerializer < ActiveModel::Serializer

  attributes :id, :invoice_period, :invoice_type, :billing_type, :status, :subtotal, :discount_amount, :total, :expenses, :discounts

  def invoice_period
    "#{object.booking.check_in_date} - #{object.booking.check_out_date}"
  end

  def subtotal
    object.expenses.pluck(:amount).sum
  end

  def discount_amount
    object.discounts.pluck(:amount).sum
  end

  def total
    object.expenses.pluck(:amount).sum - object.discounts.pluck(:amount).sum
  end

  def expenses
    object.expenses.map do |e|
    {
      id: e.id,
      category: e&.category,
      amount: e&.amount
    }
    end
  end

  def discounts
    object.discounts.map do |e|
    {
      id: e.id,
      amount: e&.amount,
      description: e&.description
    }
    end
  end

end