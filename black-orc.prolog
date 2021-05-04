team(black_orc_team, 'Black Orc Team', [goblin_bruiser, black_orc, trained_troll]).

player_type(goblin_bruiser, 12,'Goblin Bruiser Lineman', 45000, 6, 2, 3, 4, 8, [dodge, right_stuff, stunty, thick_skull], [a], [g,p,s]).
player_type(black_orc, 12,'Black Orc', 90000, 4, 4, 4, 5, 10, [brawler, grab], [g, s], [a,p]).
player_type(trained_troll, 1,'Trained Troll', 115000, 4, 5, 5, 5, 10, [always_hungry, loner(3), mighty_blow(1), projectile_vomit, really_stupid, regeneration, throw_teammate], [s], [a,g,p]).

