require_relative '../global'
require 'date'


class Team
  attr_reader :name, :league, :abbreviation
  attr_accessor :roster, :contracts, :rights, :management, :farm, :lines, :coach_assignments, :staff_assignments, :schedule

  def initialize(params)
    @name = params[:name]
    @league = params[:league]
    @roster = params[:roster]
    @abbreviation = params[:abbreviation]
    @contracts = params[:contracts]
    @rights = params[:rights]
    @management = params[:management]
    @farm = params[:farm]
  end


  def make_lines
    make_even_strength_lines
    make_power_play_lines
    make_penalty_kill_lines
    make_goalie_lines
  end


  def make_even_strength_lines
    line_ranks = {
      :ev_1 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []},
      :ev_2 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []},
      :ev_3 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []},
      :ev_4 => {:lw => [], :c => [], :rw => []}
    }

    final_lines = {
      :ev_1 => {},
      :ev_2 => {},
      :ev_3 => {},
      :ev_4 => {}
    }


    (0..17).each do |x|





    end

######

    line_ranks = {
      :ev_1 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []},
      :ev_2 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []},
      :ev_3 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []},
      :ev_4 => {:lw => [], :c => [], :rw => []}
    }

    line_ranks.each do |line, positions|
      tactic = head_coach.strategy[line][:tactic]
      positions.each do |position, ranks|
        roster[:skaters].each do |skater|
          ###need the forward/defense coaches opinions of attributes here
          rank = head_coach.scouting_report(skater).attributes + skater.teammate_adjusted_attributes(

          rank = skater.get_ev_lineup_score(position, tactic) * (head_coach.strategy[line][:shift_length] - 5) / 100.0 
          ranks.push( {"#{skater.name[:first]} #{skater.name[:last]}" => rank} )
        end
        ranks.sort_by! { |x| x[x.keys.first] }.reverse!
      end
    end

    final_lines = {
      :ev_1 => {},
      :ev_2 => {},
      :ev_3 => {},
      :ev_4 => {}
    }

    (0..17).each do |x|
      line, position = get_max_line_rank_delta(line_ranks)
      player = line_ranks[line][position].first.keys.first
      warn player
      final_lines[line][position] = player
      line_ranks[line].delete(position)

      line_ranks.each do |line, positions|
        positions.each do |position, ranks|
          ranks.each do |rank|
            ranks.delete(rank) if rank.keys.first == player
          end
        end
      end
    end

    final_lines
  end

  def get_max_line_rank_delta(line_ranks)
    max_gap = -1
    max_gap_line = nil
    max_gap_position = nil
    h = {}
    line_ranks.each do |line, positions|
      h[line] = {}
      positions.each do |position, ranks|
        first_rank = ranks[0].values.first || 0
        second_rank = ranks[1].values.first || 0
        third_rank = ranks[2].values.first || 0
        fourth_rank = ranks[3].values.first || 0
        h[line][position] = (first_rank - second_rank) + (first_rank - third_rank)/2 + (first_rank - fourth_rank)/4
        if h[line][position] > max_gap
          max_gap = h[line][position]
          max_gap_line = line
          max_gap_position = position
        end
      end
    end
    warn h
    [max_gap_line, max_gap_position]
  end

  def make_power_play_lines
    rank = {
      :pp_1 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []},
      :pp_2 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []}
    }
  
  end
  
  
  def make_penalty_kill_lines
    rank = {
      :sh_1 => {:lw => [], :c => [], :ld => [], :rd => []},
      :sh_2 => {:lw => [], :c => [], :ld => [], :rd => []}
    }
  end
  
  
  def make_goalie_lines
    scores = []
    roster[:goalies].each do |goalie|
      score = coach_assignments[:goalie].attributes(goalie).goalie_overall * (next_game.is_big_game? ? (goalie.attributes.energy + 100)/200 : goalie.attributes.energy/100)
      #score -= coach_assignments[:goalie].attributes(goalie).overall if upcoming_back_to_back? && game_after_next.is_big_game?
    end
  end

  
  def next_game
    #look at @schedule, find the first game that does not have a result
  end

  def game_after_next
    #look at @schedule, find the second game that does not have a result
  end

  def date_diff_next_two_games
    !game_after_next || !next_game ? nil : game_after_next.date - next_game.date
  end

  def upcoming_back_to_back?
    date_diff_next_two_games == 1
  end

  def head_coach
    management[:coaches][:head_coach]
  end
end
