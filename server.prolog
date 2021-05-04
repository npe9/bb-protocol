
% so you also want to be able to manage this replay.
% so how do you represent the game board?
% is the game horizontal or vertical?
% in blood bowl it's vertical.
% so you sort by row coordinate, then you sort by 
% the game board is the sorted union of the players.

% you want to be able to drive the kick off event.
drive(KickOffEventRoll) :- kick_off_event(KickOffEventRoll, Event).

tackle_zones(Player, NumZones) :- .
% x,y
tackle_zone(X, Y) :- player(X,Y).



% handoffs can depend on the weather. 
handoff(Player, Roll) :- tackle_zones(Player, NumTackle),
                         agi(Player, Agi),
                         (weather(pouring_rain) ->
                              Roll - NumTackle > Agi
                         ;    Roll + 1 - NumTackle > Agi).


% interesting how to implement weather dependent rolls
% do we implement this as a state transformer?
gfi(Roll) :- weather(blizzard), Roll >= 3; Roll >= 2.

% adjacent but not in tackle zone.
% guard short circuits
assists() :- .

% also you should be able to negotiate the ruleset from the server.
% rulesets
% list of rulesets
% followed by done


% arbitrary AIs.
% also be able to get board state at any given time.
% board state is a prolog list with player numbers and team. 

% activate player
% activate <player number>
% ack/nak
% declare action

% declare foul action

% player state has to be knocked down.
% you need a player
% the action should not be selectable unless there is an adjacent player.
% so you can also add dirty player here.
% dirty player is interesting logic. because it's either or you need to have special logic to trigger it.
foul_armor(Player, Die1, Die2, DirtyPlayerTrigged) :- armour(Player, Armour),
                                  skills(Player, Skills),
                                  % change this for blood bowl 2020
                                  (member(dirty_player, Skills) ->
                                       Armour < Die1 + Die2 + 1
                                  ;    Armour < Die1 + Die2
                                   ).


foul_injury(Player, Die1, Die2) :- armour(Player, Armour),
                                   skills(Player, Skills),
                                   % change this for blood bowl 2020
                                   ((member(dirty_player, Skills), not(DirtyPlayerTriggered)) ->
                                        Armour < Die1 + Die2 + 1
                                   ;    Armour < Die1 + Die2
                                   ).


sent_off(Die1, Die2) :- Die1 = Die2.

% valid_actions
% so you want to be able to watch the opponent place their pieces.
%

% interception
% star player points table
title(Player, rookie) :- spp(Player, Spp), Spp <= 5.
title(Player, experienced) :- spp(Player, Spp), Spp >= 6, Spp <= 15.
title(Player, veteran) :- spp(Player, Spp), Spp >= 16, Spp <= 30.
title(Player, emerging_star) :- spp(Player, Spp), Spp >= 31, Spp <= 50.

improvement_roll(Die1, Die2, new_skill) :- Die1 =/= Die2, Die1+Die2.
% logic is slightly off here. because you can be doubles or not. so the cartesian product is different 
improvement_roll(Die1, Die2, new_secondary_skill) :- Die1 = Die2, Die1+Die2.
improvement_roll(Die1, Die2, mv_or_av) :- Die1+Die2 = 10.
improvement_roll(Die1, Die2, agi) :- Die1+Die2 = 11.
improvement_roll(Die1, Die2, st) :- Die1+Die2 = 12.
% so figuring out what state you need from the improvement roll is interesting.


interception(Player, Roll) :- tackle_zones(Player, NumZones), agi(Player, Agi), Roll > Agi - 2 - NumZones.

% you need to figure out modifiers as well.
armor(Player, Die1, Die2) :- armor(Player, Armor), Die1+Die2 > Armor.

weather(2, sweltering_heat).
weather(3, very_sunny).
weather(Roll, nice) :- Roll >= 4, Roll <= 10.
weather(11, pouring_rain).
weather(12, blizzard).



% you need to figure out modifiers as well.
injury(Player, Die1, Die2, stun) :- armor(Player, Armor), Die1+Die2 > Armor.
injury(Player, Die1, Die2, ko) :- armor(Player, Armor), Die1+Die2 > Armor.
injury(Player, Die1, Die2, cas) :- armor(Player, Armor), Die1+Die2 > Armor.

cas(Die1, _, badly_hurt) :- Die1 <= 3.
cas(4, 1, broken_ribs).
cas(4, 2, groin_strain).
cas(4, 3, gouged_eye).
cas(4, 4, broken_jaw).
cas(4, 5, fractured_arm).
cas(4, 6, fractured_leg).
cas(4, 7, smashed_hand).
cas(4, 8, pinched_nerve).
cas(5, 1, niggling_injury).
cas(5, 2, niggling_injury).
cas(5, 3, smashed_hip).
cas(5, 4, smashed_ankle).
cas(5, 5, serious_concussion).
cas(5, 7, fractured_skull).
cas(5, 8, smashed_hand).
cas(6, _, dead).

inducement(bloodweiser_base, 2, 50000).
inducement(bribe, 3, 100000).
inducement(extra_team_training, 4, 100000).
inducement(halfling_master_chef, 1, 300000).
inducement(igor, 1, 100000).
inducement(wandering_apothecary, 2, 100000).
inducement(wizard, 1, 150000).

% so you need a list of things to evaluate at the beginning of drive.
% so you have a list of things to consider. Each of which might change the state of the game.


% inducement(star_player, 2, X).
% mercenary
% inducement(igor, 1, 100000).


% mvp
%% choose(List, Elt) - chooses a random element
%% in List and unifies it with Elt.
choose([], []).
choose(List, Elt) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, Elt).

add_spp(Player, Amount) :- spp(Player, Spp), assert(spp(Player,Spp+Amount)).

% playing a game vs a replay
mvp(Player) :- add_spp(Player, 5).

% teams change over time.
touchdown(Player) :- add_spp(Player, 3), team(Player, Team), score(Team).


block(Attacker, Defender, knockdown) :- .

prematch_sequence() :-
    determine_weather(),
    move_gold(),
    take_inducements().

match() :-
    fans(),
    fame(),
    turns().

improvement_roll :- mvp.

% go through database and move dead players to the "ex player" list

% what is a replay? A replay is just a unification that satisfies the game rules.
% a played game is what comes up with a replay.

delete_killed.

pay_spiralling_expenses(TV, TV) :- TV < 1750000.
pay_spiralling_expenses(TV, NewTV) :- TV >= 1750000,  TV <= 1890000, NewTV is TV - 10000.

% p.29
% concede is an action.
% roll dice for each player. 
concede(Player) :-  both_mvps(OtherPlayer), lose_fanfactor(Player), bag_of_players.

update_roster(TV, Players) :- delete_killed,
                              generate_winnings(TV, WinTV),
                              pay_spiralling_expenses(WinTV, NewTV),
                              fan_factor(),
                              transfer_gold(),
                              hire_journeymen(),
                              add_journeymen(),
                              record_value().


postmatch_sequence() :-
    improvement_rolls(),
    update_roster().

% games are state transformers over teams.
game :-
    prematch_sequence(),
    match(),
    postmatch_sequence().

% this is inherently stateful. blitz goes away, so does pass and hand_off.
% so actions are state transformers
% [block, move, blitz, pass, hand_off]

% so those are really choice points. and you don't have to use the block part of the blitz
blitz(Actions, ActionsPostBlitz) :- member(blitz, Actions), delete(Actions, blitz, ActionsPostBlitz), move(A, B), block(C, D).


pass(Actions, ActionsPostPass) :- member(pass, Actions), delete(Actions, pass, ActionsPostBlitz), move(A, B), pass(C, D).

% so the choice point matters here too.
block_dice(Attacker, Defender, -3) :- str(Attacker) < str(Defender), 2*str(Attacker) < str(Defender).
block_dice(Attacker, Defender, -2) :- str(Attacker) < str(Defender), 2*str(Attacker) > str(Defender).
block_dice(Attacker, Defender, 1) :- str(Attacker) = str(Defender).
block_dice(Attacker, Defender, 2) :- str(Attacker) > str(Defender), 2*str(Attacker) <= str(Defender).
block_dice(Attacker, Defender, 3) :- str(Attacker) > str(Defender), 2*str(Attacker) > str(Defender).

% so the list of all valid actions is a set of functors.
% you then pick out of the list. 

% how do you define a move?
% so you pass 


