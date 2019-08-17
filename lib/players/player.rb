require_relative '../global'
require_relative './player_attributes'
require 'age_wizard'

class Player
  attr_reader :id, :name
  attr_accessor :in_game_id, :info, :attributes, :ceilings, :statistics
  
  
  def initialize(params)
    @id = params[:id]
    @in_game_id = params[:in_game_id]
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
      adjusted_attributes = (adjusted_attributes + teammate_adjusted_attributes)
    end
    adjusted_attributes
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

  def full_name
    name[:first] + " " + name[:last]
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


  def was_drafted?
    !!@info[:draft_year]
  end


  def is_draftable_age?(draft_year)
    dob = Time.utc(info[:birth_year], info[:birth_month], info[:birth_day])
    (AgeWizard::age(dob, Time.utc(draft_year, 9, 15) >= 18) &&
     AgeWizard::age(dob, Time.utc(draft_year, 12, 31) <= 19))
  end


  def players_file
    puts players_file_line_one
    puts players_file_line_two
    puts players_file_line_three 
    puts
    puts
    puts
  end

  def players_file_line_one
    arr = [
      @attributes[:shooting] || @attributes[:glove],
      @attributes[:playmaking] || @attributes[:blocker],
      @attributes[:stick_handling],
      @attributes[:checking] || @attributes[:pads],
      @attributes[:marking] || @attributes[:angles],
      @attributes[:hitting] || @attributes[:agility],
      @attributes[:skating],
      @attributes[:endurance],
      @attributes[:penalty],
      @attributes[:faceoffs] || @attributes[:rebounds]
    ]
    
    str = " " + arr.join("  ") + " "
    fix_whitespace_for_negative_numbers(str)
  end  
  
    
  def players_file_line_two
    arr = [
      @attributes[:leadership],
      @attributes[:strength],
      @attributes[:potential],
      @attributes[:consistency],
      @attributes[:greed],
      @attributes[:fighting],
      @info[:click],
      @info[:team] ? @info[:team][:id] : 0,
      GLOBAL::POSITION_INDEX[@info[:position]],
      GLOBAL::COUNTRY_INDEX[@info[:country]],
      GLOBAL::HANDED_INDEX[@info[:handed]]
    ]
    
    str = " " + arr.join("  ") + " "
    fix_whitespace_for_negative_numbers(str)
  end
  
  def players_file_line_three
    arr = [
      @info[:birth_year], 
      @info[:birth_day], 
      @info[:birth_month],
      @info[:contract] ? info[:contract][:salary] : 0, 
      @info[:contract] ? info[:contract][:length] : 0, 
      @info[:draft_year] || 0, 
      @info[:draft_round] || 0,
      @info[:drafted_by] ? @info[:drafted_by][:id] : 0, 
      @info[:rights] ? @info[:rights][:id] : 98
    ]

    str = " " + arr.join("  ") + " "
    fix_whitespace_for_negative_numbers(str)
  end

  def players_file_lines_four_to_five
    week_arr = [
      @statistics[:week][:games],
      @statistics[:week][:goals] || @statistics[:week][:goals_against],
      @statistics[:week][:assists] || @statistics[:week][:wins],
      @statistics[:week][:gwgs] || @statistics[:week][:shutouts]
    ]

    month_arr = [
      @statistics[:month][:games],
      @statistics[:month][:goals] || @statistics[:month][:goals_against],
      @statistics[:month][:assists] || @statistics[:month][:wins],
      @statistics[:month][:gwgs] || @statistics[:month][:shutouts]
    ]

    str = " " + week_arr.join("  ") + " "
    str += "\n " + week_arr.join("  ") + " "
    str
  end


  def players_file_line_six
    arr = [
      @statistics[:career_best][:goals] || @statistics[:career_best][:gaa]*1000,
      @statistics[:career_best][:assists] || @statistics[:career_best][:shutouts]*1000,
      @statistics[:career_best][:points] || @statistics[:career_best][:svp]*1000,
      @info[:contract][:no_trade_clause] || 0,
      @info[:contract][:two_way_clause] || 0,
      0
    ]

    str = " " + week_arr.join("  ") + " "
    str
  end
  
  def players_file_line_seven
  end
  
  def players_file_lines_eight_to_ten
   str =     " 0  0  0  0  0  0 "
   str +=  "\n 0  0  0  0  0  0  0  0  0  0 "
   str +=  "\n 0  0  0  0  0  0  0  0  0  0 "
   str
  end

  def players_file_lines_eleven_to_twelve

  end

  def fix_whitespace_for_negative_numbers(str)
    str.gsub(/ -(\d)/, '-\1') #remove space before a negative number
  end
  
  
  def ==(other)
    return (@id == other.id) && (@name[:first] == other.name[:first]) && (@name[:last] == other.name[:last])
  end
end
