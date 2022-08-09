module ParamsHelper
  def to_integer(number)
    number.present? ? number.to_i : nil
  end
end
