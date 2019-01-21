
module GLOBAL
  EHM_PATH = "C:/Program Files (x86)/Eastside Hockey Manager"

  NATIONALITY_ARRAY = ["", "CAN", "USA", "RUS", "CZE", "SWE", "FIN", "BLR", "SVK", "NOR", "GER", "n/a", "ITA", "AUS", "LAT", "UKR", "SLV", "SUI", "POL", "FRA", "JPN"]

  TEAM_ARRAY = ["", "ANA", "ATL", "BOS", "BUF", "CGY", "CAR", "CHI", "COL", "CBJ", "DAL", "DET", "EDM", "FLA", "LA", "MIN", "MTL", "NYI", "NYR", "NAS", "NJ", "OTT", "PHI", "PHO", "PIT", "SJ", "STL", "TB", "TOR", "VAN", "WSH"]            

  POSITION_INDEX = {
    :g => 1,
    :rd => 2,
    :ld => 2,
    :d => 2,
    :lw => 3,
    :c => 4,
    :rw => 5
  }

  HANDED_INDEX = {
    :l => 1,
    :r => 0
  }

  HEIGHT_ARRAY = [505, 506, 507, 508, 509, 510, 511, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610]
  
  EV_LINE_TACTICS = {
    :run_and_gun => {
        :lw => {:playmaking => 18, :shooting => 22, :stickhandling => 20, :skating => 20, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :rw => {:playmaking => 18, :shooting => 22, :stickhandling => 20, :skating => 20, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :c =>  {:playmaking => 22, :shooting => 15, :stickhandling => 19, :skating => 19, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5, :faceoffs => 5},
        :ld => {:playmaking => 18, :shooting => 18, :stickhandling => 18, :marking => 2, :checking => 2, :hitting => 2, :skating => 20, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :rd => {:playmaking => 18, :shooting => 18, :stickhandling => 18, :marking => 2, :checking => 2, :hitting => 2, :skating => 20, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5}
    },

    :passing_plays => {
        :lw => {:playmaking => 16, :shooting => 16, :stickhandling => 16, :marking => 6, :hitting => 5, :checking => 6, :skating => 10, :strength => 5, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :rw => {:playmaking => 16, :shooting => 16, :stickhandling => 16, :marking => 6, :hitting => 5, :checking => 6, :skating => 10, :strength => 5, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :c =>  {:playmaking => 18, :shooting => 10, :stickhandling => 14, :marking => 7, :hitting => 5, :checking => 7, :skating => 9, :strength => 5, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5, :faceoffs => 5},
        :ld => {:playmaking => 13, :shooting => 7, :stickhandling => 7, :marking => 14, :hitting => 12, :checking => 14, :skating => 8, :strength => 5, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :rd => {:playmaking => 13, :shooting => 7, :stickhandling => 7, :marking => 14, :hitting => 12, :checking => 14, :skating => 8, :strength => 5, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5}
    },

    :dump_and_chase => {
        :lw => {:playmaking => 8, :shooting => 8, :stickhandling => 8, :marking => 7, :hitting => 14, :checking => 7, :skating => 16, :strength => 12, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :rw => {:playmaking => 8, :shooting => 8, :stickhandling => 8, :marking => 7, :hitting => 14, :checking => 7, :skating => 16, :strength => 12, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :c => {:playmaking => 7, :shooting => 6, :stickhandling => 7, :marking => 8, :hitting => 13, :checking => 8, :skating => 15, :strength => 11, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5, :faceoffs => 5},
        :ld => {:playmaking => 4, :shooting => 6, :stickhandling => 4, :marking => 15, :hitting => 15, :checking => 15, :skating => 10, :strength => 11, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :rd => {:playmaking => 4, :shooting => 6, :stickhandling => 4, :marking => 15, :hitting => 15, :checking => 15, :skating => 10, :strength => 11, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5}
    },

    :hit_and_grind => {
        :lw => {:playmaking => 6, :shooting => 12, :stickhandling => 7, :marking => 5, :hitting => 20, :checking => 5, :skating => 10, :strength => 15, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :rw => {:playmaking => 6, :shooting => 12, :stickhandling => 7, :marking => 5, :hitting => 20, :checking => 5, :skating => 10, :strength => 15, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :c => {:playmaking => 5, :shooting => 10, :stickhandling => 5, :marking => 5, :hitting => 20, :checking => 5, :skating => 10, :strength => 15, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5, :faceoffs => 5},
        :ld => {:playmaking => 4, :shooting => 7, :stickhandling => 4, :marking => 10, :hitting => 20, :checking => 10, :skating => 10, :strength => 15, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :rd => {:playmaking => 4, :shooting => 7, :stickhandling => 4, :marking => 10, :hitting => 20, :checking => 10, :skating => 10, :strength => 15, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5}
    },

    :neutral_zone_trap => {
        :lw => {:playmaking => 5, :shooting => 8, :stickhandling => 8, :marking => 16, :hitting => 7, :checking => 16, :skating => 10, :strength => 10, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :rw => {:playmaking => 5, :shooting => 8, :stickhandling => 8, :marking => 16, :hitting => 7, :checking => 16, :skating => 10, :strength => 10, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :c => {:playmaking => 7, :shooting => 5, :stickhandling => 5, :marking => 16, :hitting => 7, :checking => 16, :skating => 9, :strength => 10, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5, :faceoffs => 5},
        :ld => {:playmaking => 4, :shooting => 3, :stickhandling => 3, :marking => 19, :hitting => 14, :checking => 19, :skating => 8, :strength => 10, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5},
        :rd => {:playmaking => 4, :shooting => 3, :stickhandling => 3, :marking => 19, :hitting => 14, :checking => 19, :skating => 8, :strength => 10, :consistency => 10, :endurance => 5, :leadership => 2.5, :clutch => 2.5}
    }
  }

  PP_LINE_TACTICS = {
    :shooting => 0,
    :screen_and_shoot => 1,
    :passing_plays => 2,
    :crash_the_net => 3,
    :shot_from_point => 4
  }

  SH_LINE_TACTICS = {
    :aggressive => 0,
    :loose_box => 1,
    :passive_box => 2,
    :small_box => 3,
    :tight_box => 4
  }


  def self.print_line_tactic_totals
    EV_LINE_TACTICS.each do |tactic, positions|
      positions.each do |position, weights|
        puts "#{tactic}\t#{position}\t#{weights.values.inject(0){|sum,x| sum + x}}"
      end
    end
  end
  

  HEADER_ARRAY = ["Name",
        "Pos",
        "Team",
        "Leag",
        "Nat",
        "Ovr",
        "Off",
        "Def",
        "Shoot / Glove",
        "Play / Block",
        "StHa",
        "Check / Pads",
        "Mark / Angles",
        "Hit / Agil",
        "Skate",
        "Endur",
        "Pen",
        "FOs / Rebnds",
        "Ldr",
        "Str",
        "Pot",
        "Con",
        "Greed",
        "Inj Res",
        "Fight",
        "Ht",
        "Wt",
        "Handed",
        "Alt Pos",
        "Click",
        "Contract Length",
        "Salary",
        "Birth Year",
        "Birth Month",
        "Birth Day",
        "Draft Year",
        "Draft Round",
        "Draft Ovr",
        "Drafted By",
        "Junior Team",
        "Junior Leag",
        "ID"]

  def self.decode_position(pos_int)
    return POSITION_ARRAY[pos_int]
  end  
  
  
  def self.decode_team(team_int)
    return TEAM_ARRAY[team_int]
  end
  
  
  def self.decode_junior_team(junior_team_int)
    ###DO SOMETHING
    return junior_team_int #dummy
  end
  
  
  def self.decode_junior_league(junior_team_int)
    ###DO SOMETHING
    return junior_team_int #dummy
  end
  
  
  def self.load_teams
  
  end
  
  
  def self.decode_nationality(nat_int)
    if nat_int < 0 || nat_int > 20 then
      nat_int = 0
    end
    nationality = NATIONALITY_ARRAY[nat_int]
  end
  
  
  def self.encode_handed(handed)
    if (handed == "L")
      return LEFT_HANDED
    elsif (handed == "R")
      return RIGHT_HANDED
    else
      raise "incorrect handed value"
    end
  end
  
  
  def self.decode_height(height_int)
    return HEIGHT_ARRAY[height_int]
  end
  
  
  def self.get_league(team_int)
    if team_int <= 0 || team_int > 60 then
      league = ""
    elsif team_int > 30 then
      league = "AHL"
    else  
      league = "NHL"
    end
  end
    
    
  def self.get_binomial(lower_bound, upper_bound)
    diff = upper_bound - lower_bound
    x = lower_bound
    r = Random.new
    for i in 0..diff
      if (r.rand(100) < 50)
        x += 1
      end
    end

    return x
  end


  def self.min(int_one, int_two)
    return (int_one < int_two ? int_one : int_two)
  end


  def self.max(int_one, int_two)
    return (int_one > int_two ? int_one : int_two)
  end
  
  
  def self.blank_if_zero(value)
    if (value == 0)
      return ""
    else
      return value
    end
  end
end
