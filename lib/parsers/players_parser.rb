#! /usr/bin/env ruby

module PLAYERS_PARSER

  NUM_LINES_PER_PLAYER = 20

  class << self
    
    def parse_player(arr)
      
    end

    def parse_players_file(file)
      File.open do 

      end
    end

    def print_player(player)
      player.is_g? ? print_goalie(player) : print_skater(player)
    end

    def print_skater(player)
      line_1 = " #{[ 
          player.skills[:glove], player.skills[:blocker], player.skills[:stick_handling],
          player.skills[:pads], player.skills[:angles], player.skills[:agility], player.skills[:skating],
          player.skills[:endurance], player.skills[:penalty], player.skills[:rebounds] 
        ].join('  ')} "
      fix_whitespace_for_negative_numbers!(line_1)
      
      line_2 = " #{[
          player.skills[:leadership], player.skills[:strength], player.skills[:potential],
          player.skills[:consistency], player.skills[:greed], player.skills[:fighting], player.info[:click],
          player.info[:team], player.info[:position], player.info[:nationality], player.info[:handed]
        ].join('  ')} "
      fix_whitespace_for_negative_numbers!(line_2)

      line_3 = " #{[
          player.info[:birth_year], player.info[:birth_day], player.info[:birth_month],
          player.info[:salary], player.info[:contract_length], player.info[:draft_year], player.info[:draft_round],
          player.info[:drafted_by], player.info[:rights]
        ].join('  ')} "
      fix_whitespace_for_negatve_numbers!(line_3)

      line_4 = " #{[
          player.statistics[:week][:games], player.statistics[:week][:goals], 
          player.statistics[:week][:assists], player.statistics[:week][:gwg]
        ].join('  ')} "

      line_5= " #{[
          player.statistics[:month][:games], player.statistics[:month][:goals], 
          player.statistics[:month][:assists], player.statistics[:month][:gwg]
        ].join('  ')} "

      record_goals = player.statistics[:career].select {|x| x[:league] == "NHL" && x[:type] == "regular"}.
                      inject({}) {|res, elem| res[elem[:season]] ||= 0 ;  res[elem[:season]] += elem[:goals] ; res}. 
                      values.max
                      
      record_assists = player.statistics[:career].select {|x| x[:league] == "NHL" && x[:type] == "regular"}.
                        inject({}) {|res, elem| res[elem[:season]] ||= 0 ;  res[elem[:season]] += elem[:assists] ; res}.
                        values.max

      record_points = player.statistics[:career].select {|x| x[:league] == "NHL" && x[:type] == "regular"}.
                       inject({}) {|res, elem| res[elem[:season]] ||= 0 ;  res[elem[:season]] += elem[:points] ; res}.
                       values.max
      line_6 = " #{[
          player.statistics[:career][:games], player.statistics[:week][:goals], 
          player.statistics[:week][:assists], player.statistics[:week][:gwg]
        ].join('  ')} "
    end

    def print_goalie(player)
                 [   player.skills[:shooting], player.skills[:playmaking], player.skills[:stick_handling],
                     player.skills[:checking], player.skills[:marking], player.skills[:hitting], player.skills[:skating],
                     player.skills[:endurance], player.skills[:penalty], player.skills[:faceoffs]]

    end

    def fix_whitespace_for_negative_numbers!(str)
      str.gsub!(/ -(\d)/, '-\1') #remove space before a negative number
    end


    def print_players_file(players)
      puts " #{players.size}"
      players.each do |player|
        print_player(player)
      end
    end

  end
end
