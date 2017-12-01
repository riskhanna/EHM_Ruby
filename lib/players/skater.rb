require_relative './player'

class Skater < Player
  OFFENSE_ATTRS = [:shooting, :playmaking, :stick_handling]
  DEFENSE_ATTRS = [:marking, :checking, :hitting]
  MISC_ATTRS    = [:skating, :endurance, :penalty, :faceoffs, :leadership,
                   :strength, :potential, :consistency, :greed]

  OVR_ATTS = OFFENSE_ATTRS + DEFENSE_ATTRS + MISC_ATTRS

  def offense
    skills_average(OFFENSE_ATTRS)
  end

  def defense  
    skills_average(DEFENSE_ATTRS)
  end

  def normalizer_rating
    skills_sum([:greed, :penalty, :faceoffs]
  end
end
