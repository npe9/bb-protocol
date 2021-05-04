
kick_off_event(2, get_the_ref).
kick_off_event(3, riot).
kick_off_event(4, perfect_defense).
kick_off_event(5, high_kick).
kick_off_event(6, cheering_fans).
kick_off_event(7, changing_weather).
kick_off_event(8, brilliant_coaching).
kick_off_event(9, quick_snap).
kick_off_event(10, blitz).
kick_off_event(11, throw_a_rock).
kick_off_event(12, pitch_invasion).

% need to assert
event(get_the_ref) :- assert(bribe(blue), bribe(red)).

event(riot) :- turn(Turn), Turn >= 7, assert(turn(Turn-1)).
event(riot) :- turn(Turn), Turn < 7, assert(turn(Turn+1)).


% perfect_defense
event(perfect_defense) :- game_state(defensive_setup).

% high_kick
event(high_kick) :- game_state(high_kick).

% cheering_fans
event(cheering_fans) :- team(blue, Blue), team(red, Red), rolld3(BlueDie),rolld3(RedDie).


