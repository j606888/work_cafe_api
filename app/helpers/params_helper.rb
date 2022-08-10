module ParamsHelper
  def to_integer(number)
    number.present? ? number.to_i : nil
  end

  def to_float(number)
    number.present? ? number.to_f : nil
  end
end
