require_relative './global'
requre 'age_wizard'

class Player
  attr_reader :id, :name
  attr_accessor :info, :skills, :ceilings, :stats
  
  
  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @info = params[:info]
    @skills = params[:skills]
    @ceilings = params[:ceilings]
    @statistics = params[:statistics]
  end

  def skills_average(attributes)
    skills_sum(attributes) / attributes.size
  end
  #private :skills_calculator

  def skills_sum(attributes)
    @skills.select{|k,v| attributes.include?(k)}.values.reduce(:+)
  end
  #private :skills_sum
  
  def overall
    skills_average(OVR_ATTRS)
  end

  def expected_skills
    exp = {}
    @ceilings.each do |attribute, ceiling|
      exp[attribute] = @skills[:potential] * ceiling / 100.0
    end
    @skills.merge(exp)
  end

  def expected_overall
    skills_calculator(expected_skills)
  end

  
  def player_type
    #@skills[:potential] % 10
    @info[:type]
  end
  
  
  def is_g?
    @info[:position] == GLOBAL::POSITION_ARRAY.index("G")
  end
  
  
  def is_d?
    @info[:position] == GLOBAL::POSITION_ARRAY.index("D")
  end


  def is_c?
    @info[:position] == GLOBAL::POSITION_ARRAY.index("C")
  end


  def is_lw?
    @info[:position] == GLOBAL::POSITION_ARRAY.index("LW")
  end


  def is_rw?
    @info[:position] == GLOBAL::POSITION_ARRAY.index("RW")
  end


  def is_winger?
    is_lwer? || is_rwer?
  end
  
  def is_forward?
    is_winger? || is_center?
  end
  
  
  
  def is_role_player?
    !is_goalie? && (player_type == 9)
  end
  
  
  def is_enforcer?
    !is_goalie? && (player_type == 0)
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
    @info[:draft_year] != 0
  end
  
  def is_draftable_age?(draft_year)
    dob = Time.utc(info[:birth_year], info[:birth_month], info[:birth_day])
    (AgeWizard::age(dob, Time.utc(draft_year, 9, 15) >= 18) &&
    (AgeWizard::age(dob, Time.utc(draft_year, 12, 31) <= 19)
  end

  def print_line_one
    arr = is_goalie? ?
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
    return (@id == other.id) && (@name == other.name)
  end
end
