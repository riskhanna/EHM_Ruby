# /usr/bin/env ruby


module STARTGAME

  NUM_LINES_PER_PLAYER = 10

  module LINE_ONE
    SHOOTING = 0
    PLAYMAKING = 1
    STICK_HANDLING = 2
    CHECKING = 3
    MARKING = 4
    HITTING = 5
    SKATING = 6
    ENDURANCE = 7
    PENALTY = 8
    FACEOFFS = 9
    
    GLOVE = 0
    BLOCKER = 1
    PADS = 3
    ANGLES = 4
    AGILITY = 5
    REBOUNDS = 9
  end

    module LINE_TWO
    LEADERSHIP = 0
    STRENGTH = 1
    POTENTIAL = 2
    CONSISTENCY = 3
    GREED = 4
    FIGHTING = 5
    CLICK = 6
    TEAM = 7
    POSITION = 8
    NATIONALITY = 9
  end

  module LINE_THREE
    BIRTH_YEAR = 0
    BIRTH_DAY = 1
    BIRTH_MONTH = 2
    SALARY = 3
    CONTRACT_LENGTH = 4
    DRAFT_YEAR = 5
    DRAFT_ROUND = 6
    DRAFTED_BY = 7
    RIGHTS = 8
  end
  
  module LINE_FOUR
    CAREER_GAMES = 0
    CAREER_GOALS = 1
    CAREER_ASSISTS = 2
    CAREER_PIM = 3
    
    CAREER_GA = 1
    CAREER_SO = 2
    CAREER_SAVES = 3
  end
  
  module LINE_FIVE
    DEFAULT = " 0  0  0 "
  end
  
  module LINE_SIX
    DEFAULT = " 0  0  0  0 "
  end
  
  module LINE_SEVEN #all values need to be divided by 1000
    CAREER_HIGH_GOALS = 0
    CAREER_HIGH_ASSISTS = 1
    CAREER_HIGH_POINTS = 2
    CAREER_BEST_GAA = 0
    CAREER_HIGH_SOS = 1
    CAREER_BEST_SVP = 2
  end

  #NO LEADING AND TRAILING SPACE IN LINE EIGHT
  module LINE_EIGHT # format {name}#{handed}
    DELIMITER = "#"
    NAME = 0
    HANDED = 1
  end
  
  module LINE_NINE
    SMALL_DELIMITER = "            "
    BIG_DELIMITER   = "             "
    HEIGHT = 0
    WEIGHT = 1
  end
  
  module LINE_TEN
    ALT_POSITION = 0
    DRAFT_OVERALL = 1
    INJURY_RESIST = 2
    JUNIOR_TEAM = 3
    FINAL_STRING = "1  1  1  1  1  1 "
  end

  class << self
  
    def get_players(default_roster)
      players = Players.new()
      File.open(default_roster, "r") do |file|
        num_players = file.gets.to_i
        (1..num_players).each do |id|
          player = player_from_stream(file, id)
          players.push(player)
        end
      end
      players
    end
    
    def print_player(player)
      arr = []
      arr.push(player.print_line_one)
      arr.push(player.print_line_two(false)) #exclude handedness at the end
      arr.push(player.print_line_three)
      arr.push(get_statistics_line(player))
      arr.push(LINE_FIVE::DEFAULT)
      arr.push(LINE_SIX::DEFAULT)
      arr.push(get_career_highs_line(player))
      arr.push(get_name_and_handed_line(player))
      arr.push(get_height_weight_line(player))
      arr.push(get_final_line(player))
      str = arr.join("\n")
    end
    

    def print_startgame_file(players)
      str = " #{players.size} \n"
      players.each do |player|
        str += print_player(player)
        str += "\n"
      end
      str
    end
    
    
    def self.get_statistics_line(player)
      if player.is_goalie?
        str = " #{player.statistics[:career_games]}" +
            "  #{player.statistics[:career_ga]}" +
            "  #{player.statistics[:career_so]}" +
            "  #{player.statistics[:career_saves]} "
      else
        str = " #{player.statistics[:career_games]}" +
            "  #{player.statistics[:career_goals]}" +
            "  #{player.statistics[:career_assists]}" +
            "  #{player.statistics[:career_pim]} "
      end
    end
    
    
    def self.get_career_highs_line(player)
      if player.is_goalie?
        gaa = (player.statistics[:career_best_gaa] * 1000).to_i
        sos = (player.statistics[:career_high_sos] * 1000).to_i
        svp = (player.statistics[:career_best_svp] * 100000).to_i
        str = " #{gaa}" +
            "  #{sos}" +
            "  #{svp} "
      else
        goals = (player.statistics[:career_high_goals] * 1000).to_i
        assists = (player.statistics[:career_high_assists] * 1000).to_i
        points = (player.statistics[:career_high_points] * 1000).to_i
        str = " #{goals}" +
            "  #{assists}" +
            "  #{points} "
      end
    end
    
    
    def self.get_name_and_handed_line(player)
      str = "#{player.name}##{player.bio[:handed]}"
    end
    
    
    def self.get_height_weight_line(player)
      str = " #{player.bio[:height]}"
      if (player.bio[:height] >= 10)
        str += "            "
      else
        str += "             "
      end
      str += "#{player.bio[:weight]} "
    end
    
    
    def self.get_final_line(player)
      bio = player.bio
      skills = player.skills
      str = " #{bio[:alt_position]}  #{bio[:draft_overall]}  #{skills[:injury_resist]}  #{bio[:junior_team] + 1}  "
      str += LINE_TEN::FINAL_STRING
    end
    
    
    def self.player_from_stream(file, player_id)
      skills = {}
      statistics= {}
      bio = {}
      
      arr_one = file.gets.split(" ").map(&:to_i)
      arr_two = file.gets.split(" ").map(&:to_i)
      arr_three = file.gets.split(" ").map(&:to_i)
      arr_four = file.gets.split(" ").map(&:to_i)
      file.gets # don't care about line five
      file.gets # don't care about line six
      arr_seven = file.gets.split(" ").map(&:to_i)
      arr_eight = file.gets.split(LINE_EIGHT::DELIMITER)
      arr_nine = file.gets.split(" ").map(&:to_i)
      arr_ten = file.gets.split(" ").map(&:to_i)
      
      #### parse the arrays and populate the json ####
      name = arr_eight[LINE_EIGHT::NAME].strip
      
      
      bio[:click] = arr_two[LINE_TWO::CLICK]
      bio[:team] = arr_two[LINE_TWO::TEAM]
      bio[:position] = arr_two[LINE_TWO::POSITION]
      bio[:nationality] = arr_two[LINE_TWO::NATIONALITY]
      bio[:handed] = arr_eight[LINE_EIGHT::HANDED].strip
      
      bio[:birth_year] = arr_three[LINE_THREE::BIRTH_YEAR]
      bio[:birth_day] = arr_three[LINE_THREE::BIRTH_DAY]
      bio[:birth_month] = arr_three[LINE_THREE::BIRTH_MONTH]
      bio[:salary] = arr_three[LINE_THREE::SALARY]
      bio[:contract_length] = arr_three[LINE_THREE::CONTRACT_LENGTH]
      bio[:draft_year] = arr_three[LINE_THREE::DRAFT_YEAR]
      bio[:draft_round] = arr_three[LINE_THREE::DRAFT_ROUND]
      bio[:drafted_by] = arr_three[LINE_THREE::DRAFTED_BY]
      bio[:rights] = arr_three[LINE_THREE::RIGHTS]
      
      bio[:height] = arr_nine[LINE_NINE::HEIGHT]
      bio[:weight] = arr_nine[LINE_NINE::WEIGHT]
      bio[:alt_position] = arr_ten[LINE_TEN::ALT_POSITION]
      bio[:draft_overall] = arr_ten[LINE_TEN::DRAFT_OVERALL]
      bio[:junior_team] = arr_ten[LINE_TEN::JUNIOR_TEAM] - 1
      
      if bio[:position].eql?(GLOBAL::POSITION_ARRAY.index("G"))
        skills[:glove] = arr_one[LINE_ONE::GLOVE]
        skills[:blocker] = arr_one[LINE_ONE::BLOCKER]
        skills[:pads] = arr_one[LINE_ONE::PADS]
        skills[:angles] = arr_one[LINE_ONE::ANGLES]
        skills[:agility] = arr_one[LINE_ONE::AGILITY]
        skills[:rebounds] = arr_one[LINE_ONE::REBOUNDS]
      else
        skills[:shooting] = arr_one[LINE_ONE::SHOOTING]
        skills[:playmaking] = arr_one[LINE_ONE::PLAYMAKING]
        skills[:checking] = arr_one[LINE_ONE::CHECKING]
        skills[:marking] = arr_one[LINE_ONE::MARKING]
        skills[:hitting] = arr_one[LINE_ONE::HITTING]
        skills[:faceoffs] = arr_one[LINE_ONE::FACEOFFS]
      end
      
      skills[:stick_handling] = arr_one[LINE_ONE::STICK_HANDLING]
      skills[:skating] = arr_one[LINE_ONE::SKATING]
      skills[:endurance] = arr_one[LINE_ONE::ENDURANCE]
      skills[:penalty] = arr_one[LINE_ONE::PENALTY]
      skills[:leadership] = arr_two[LINE_TWO::LEADERSHIP]
      skills[:strength] = arr_two[LINE_TWO::STRENGTH]
      skills[:potential] = arr_two[LINE_TWO::POTENTIAL]
      skills[:consistency] = arr_two[LINE_TWO::CONSISTENCY]
      skills[:greed] = arr_two[LINE_TWO::GREED]
      skills[:fighting] = arr_two[LINE_TWO::FIGHTING]
      skills[:injury_resist] = arr_ten[LINE_TEN::INJURY_RESIST]
    
      statistics[:career_games] = arr_four[LINE_FOUR::CAREER_GAMES]
      
      if !bio[:position].eql?(GLOBAL::POSITION_ARRAY.index("G"))
        statistics[:career_goals] = arr_four[LINE_FOUR::CAREER_GOALS]
        statistics[:career_assists] = arr_four[LINE_FOUR::CAREER_ASSISTS]
        statistics[:career_pim] = arr_four[LINE_FOUR::CAREER_PIM]
        statistics[:career_high_goals] = arr_seven[LINE_SEVEN::CAREER_HIGH_GOALS] / 1000
        statistics[:career_high_assists] = arr_seven[LINE_SEVEN::CAREER_HIGH_ASSISTS] / 1000
        statistics[:career_high_points] = arr_seven[LINE_SEVEN::CAREER_HIGH_POINTS] / 1000
      else
        statistics[:career_ga] = arr_four[LINE_FOUR::CAREER_GA]
        statistics[:career_so] = arr_four[LINE_FOUR::CAREER_SO]
        statistics[:career_saves] = arr_four[LINE_FOUR::CAREER_SAVES]
        statistics[:career_best_gaa] = arr_seven[LINE_SEVEN::CAREER_BEST_GAA] / 1000.0
        statistics[:career_high_sos] = arr_seven[LINE_SEVEN::CAREER_HIGH_SOS] / 1000
        statistics[:career_best_svp] = arr_seven[LINE_SEVEN::CAREER_BEST_SVP] / 100000.0
      end
      
      params = { 
        id: player_id,
        name: name,
        skills: skills,
        bio: bio,
        statistics: statistics
      }
      bio[:position] == GLOBAL::POSITION_ARRAY.index("G") ? Goalie.new(params) : Skater.new(params)

    end
  
  end
end
