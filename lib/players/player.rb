require_relative '../global'
require_relative './player_attributes'
require 'age_wizard'

class Player
  attr_reader :id, :name
  attr_accessor :info, :attributes, :ceilings, :stats
  
  
  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @info = params[:info]
    @ceilings = params[:ceilings]
    @statistics = params[:statistics]
    @attributes = PlayerAttributes.new(params[:attributes], info[:position])
  end
  
  def position_adjusted_attributes(position)
    adjustment = -3 * (10 - info[:position_adjustments][position])
    position_adjusted_attributes = {
      :playmaking => adjustment,
      :shooting => adjustment,
      :marking => adjustment,
      :checking => adjustment,
      :endurance => adjustment,
      :consistency => adjustment
    }
    PlayerAttributes.new(position_adjusted_attributes, position)
  end

  def teammate_adjusted_attributes(teammates)
    adjusted_attributes = PlayerAttributes.new({}, nil)
    teammates.each do |teammate|
      adjustment = 2 * (info[:chemistry][teammate] || 0)
      teammate_adjusted_attributes = {
        :playmaking => adjustment,
        :shooting => adjustment,
        :marking => adjustment,
        :checking => adjustment,
        :endurance => adjustment,
        :consistency => adjustment
      }
      adjusted_attributes += teammate_adjusted_attributes
    end
    adjusted_attributes
  end

  def get_ev_lineup_score(position, tactic) 
    attribute_weights = GLOBAL::EV_LINE_TACTICS[tactic][position]
    calculated_position_adjusted_attributes = position_adjusted_attributes(position)
    score = 0
    attribute_weights.each do |attribute, weight|
      score += calculated_position_adjusted_attributes[attribute] * weight / 100.0
    end
    (3*score + calculated_position_adjusted_attributes.overall)/4
  end

  def get_sp_lineup_score(position, tactic)

  end


  def expected_skills
    exp = {}
    ceilings.each do |attribute, ceiling|
      exp[attribute] = attributes[:potential] * ceiling / 100.0
    end
    attributes.merge(exp)
  end

  def expected_overall
  end

  
  def is_g?
    info[:position] == :g
  end
  
  def is_skater?
    !is_g?
  end
  
  def is_d?
    info[:position] == :d || info[:position] == :rd || info[:position] == :ld
  end


  def is_c?
    info[:position] == :c
  end


  def is_lw?
    info[:position] == :lw
  end


  def is_rw?
    info[:position] == :rw
  end


  def is_winger?
    is_lw? || is_rw?
  end
  
  def is_forward?
    is_winger? || is_center?
  end
  
  
  def is_role_player?
    !is_g? && (player_type == 9)
  end
  
  
  def is_enforcer?
    !is_g? && (player_type == 0)
  end
  
  
  def is_sniper?
    is_forward? && (player_type == 1)
  end
  
  
  def is_playmaker?
    is_forward? && (player_type == 2)
  end
  
  
  def is_all_around_forward?
    is_forward? && (player_type == 3)
  end
  
  
  def is_power_forward?
    is_forward? && (player_type == 4)
  end
  
  
  def is_two_way_forward?
    is_forward? && (player_type == 5)
  end
  
  
  def is_stay_at_home_defenseman?
    is_defenseman? && (player_type == 6)
  end
  
  
  def is_physical_defenseman?
    is_defenseman? && (player_type == 7)
  end
  
  
  def is_offensive_defenseman?
    is_defenseman? && (player_type == 8)
  end
  
  def is_draft_eligible?(draft_year)
    is_draftable_age?(draft_year) && !was_drafted?
  end
  
  def has_nhl_rights?
    rights = 1..30
    rights.include?(@info[:rights])
  end
  
  def was_drafted?
    !!@info[:draft_year]
  end

  def is_draftable_age?(draft_year)
    dob = Time.utc(info[:birth_year], info[:birth_month], info[:birth_day])
    (AgeWizard::age(dob, Time.utc(draft_year, 9, 15) >= 18) &&
     AgeWizard::age(dob, Time.utc(draft_year, 12, 31) <= 19))
  end

  def print_line_one
    arr = is_g? ?
          [@skills[:glove], @skills[:blocker], @skills[:stick_handling],
              @skills[:pads], @skills[:angles], @skills[:agility], @skills[:skating],
              @skills[:endurance], @skills[:penalty], @skills[:rebounds]] :
          [@skills[:shooting], @skills[:playmaking], @skills[:stick_handling],
              @skills[:checking], @skills[:marking], @skills[:hitting], @skills[:skating],
              @skills[:endurance], @skills[:penalty], @skills[:faceoffs]]
    
    str = " " + arr.join("  ") + " "
    str = fix_whitespace_for_negative_numbers(str)
  end  
  
    
  def print_line_two(include_handed = false)
    arr = [@skills[:leadership], @skills[:strength], @skills[:potential],
         @skills[:consistency], @skills[:greed], @skills[:fighting], @info[:click],
         @info[:team], @info[:position], @info[:nationality]]
         
    if include_handed
      arr.push(@info[:handed])
    end
    
    str = " " + arr.join("  ") + " "
    str = fix_whitespace_for_negative_numbers(str)
  end

  
  def print_line_three
    arr = [@info[:birth_year], @info[:birth_day], @info[:birth_month],
         @info[:salary], @info[:contract_length], @info[:draft_year], @info[:draft_round],
         @info[:drafted_by], @info[:rights]]
    str = " " + arr.join("  ") + " "
    str = fix_whitespace_for_negative_numbers(str)
  end
  
  
  def fix_whitespace_for_negative_numbers(str)
    str.gsub(/ -(\d)/, '-\1') #remove space before a negative number
  end
  
  
  def ==(other)
    return (@id == other.id) && (@name[:first] == other.name[:first]) && (@name[:last] == other.name[:last])
  end
end
