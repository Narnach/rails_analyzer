# Add decent rounding to X decimals.
module FloatExt
  def round_to(x=4)
    (self * 10**x).round.to_f / 10**x
  end

  def ceil_to(x=4)
    (self * 10**x).ceil.to_f / 10**x
  end

  def floor_to(x=4)
    (self * 10**x).floor.to_f / 10**x
  end
end

class Float
  include FloatExt
end
