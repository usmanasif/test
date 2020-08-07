class Award
  AWARD_NAMES = ['Blue First', 'Blue Compare', 'Blue Star', 'Blue Distinction Plus', 'NORMAL ITEM'].freeze

  attr_reader :name, :expires_in, :quality

  def initialize(name, expires_in, quality)
    @name = name
    @expires_in = expires_in
    @quality = quality
  end

  def update_quality
    case @name
    when AWARD_NAMES[0] # Case for 'Blue First'
      update_quality_of_blue_first
    when AWARD_NAMES[1] # Case for 'Blue Compare'
      update_quality_of_blue_compare
    when AWARD_NAMES[2] # Case for 'Blue Star'
      update_quality_of_blue_star
    when AWARD_NAMES[4] # Case for 'Normal Item'
      update_quality_of_normal_item
    end
    unless @name == AWARD_NAMES[3]
      update_expires_in_value
    end # it will not be called for 'Blue Distinction Plus' because in that case quality would be 80
    ensure_quality_range # To make sure quality must stay within limit of 0-50 OR 0-80 for 'Blue Distinction Plus' case
  end

  private

  def update_quality_of_blue_first
    @quality += 1 if @quality < 50
    @quality += 1 if award_expired? && @quality < 50
  end

  def update_quality_of_blue_compare
    if award_expired?
      @quality = 0
    elsif @quality <= 50
      @quality += 3 if @expires_in <= 5
      @quality += 2 if @expires_in.between?(6, 10)
      @quality += 1 if @expires_in > 10
    end
  end

  def update_quality_of_blue_star
    @quality -= 2 if @quality.positive?
    @quality -= 2 if award_expired? && @quality.positive?
  end

  def update_quality_of_normal_item
    @quality -= 1 if @quality.positive?
    @quality -= 1 if award_expired?
  end

  def award_expired?
    return true if @expires_in <= 0
  end

  def update_expires_in_value
    @expires_in -= 1
  end

  def ensure_quality_range
    @quality = 50 if @quality > 50 && @name != AWARD_NAMES[3]
    @quality = 80 if @quality != 80 && @name == AWARD_NAMES[3] # Set 80 points for 'Blue Distinction Plus'
  end
end
