
module GLOBAL
  EHM_PATH = "C:/Program Files (x86)/Eastside Hockey Manager"

  NATIONALITY_ARRAY = ["", "CAN", "USA", "RUS", "CZE", "SWE", "FIN", "BLR", "SVK", "NOR", "GER", "n/a", "ITA", "AUS", "LAT", "UKR", "SLV", "SUI", "POL", "FRA", "JPN"]
  TEAM_ARRAY = ["", "ANA", "ATL", "BOS", "BUF", "CGY", "CAR", "CHI", "COL", "CBJ", "DAL", "DET", "EDM", "FLA", "LA", "MIN", "MTL", "NYI", "NYR", "NAS", "NJ", "OTT", "PHI", "PHO", "PIT", "SJ", "STL", "TB", "TOR", "VAN", "WSH"]            
  POSITION_ARRAY = ["", "G", "D", "LW", "C", "RW"]
  
  LEFT_HANDED = 1
  RIGHT_HANDED = 0
  
  HEIGHT_ARRAY = [505, 506, 507, 508, 509, 510, 511, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610]
  
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
