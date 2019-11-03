require_relative 'players_parser_google_sheets'
players, players_hash = parse_players_from_google_sheet
teams = get_teams(players)
