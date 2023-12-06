
#1.Retrieve all players from the team Arsenal:
SELECT player_id, player_name
FROM player
WHERE team_id = (select team_id from team where team_name like '%Arsenal%');

#2. Retrieve shots blocked, clearences, goals conceded for all Arsenal Players
select p.player_id, p.player_name, s.blocked_shots, s.clearance, s.goals_conceded
from player p, playerStats s
where p.player_id = s.player_id and p.team_id = (select team_id from team where team_name like '%Arsenal%');

#3. Retrieve all users in a fantasy league
select m.fantasyleague_id, 
	(select fantasyleague_name from fantasyLeague l where l.fantasyleague_id = m.fantasyleague_id) as fantasyleague_name, 
    m.userteam_id, 
    (select display_name from userTeam u where u.userteam_id = m.userteam_id) as display_name, 
    m.creator
from fantasyLeagueMember m
where m.fantasyleague_id = 1;

#4 Retrieve all fixtures a Arsenal has played
SELECT *, (select team_name from team where team_name like '%Arsenal%') as team_name
FROM fixture
WHERE home_team_id = (select team_id from team where team_name like '%Arsenal%') or away_team_id = (select team_id from team where team_name like '%Arsenal%') 
ORDER BY fixture_date;

#5 All the steps for running a fantasyFixture
-- Query for creating and running a fixture 
insert into fantasyfixture(fantasyleague_id, season_id, home_team_id, home_team_goals, away_team_id, away_team_goals, home_win, draw) values
(1, 22, 1, 5*rand() - 1, 2, 5*rand() - 1, home_team_goals > away_team_goals, home_team_goals = away_team_goals);
-- Update userTeamStats with most recent fixture
-- Updates Home Team
update userTeamStats 
set goals = goals + (select home_team_goals from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)),
	goals_conceded = goals_conceded + (select away_team_goals from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)),
    wins = wins + (select home_win from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)),
    losses = losses + 1 - (select home_win from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)),
    matches_played = matches_played + 1,
    clean_sheets = clean_sheets + if((select home_team_goals from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)) > 0 and
									(select away_team_goals from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)) = 0, 1, 0)
where userteam_id = (select home_team_id from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture));
-- Updates Away Team
update userTeamStats 
set goals = goals + (select away_team_goals from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)),
	goals_conceded = goals_conceded + (select home_team_goals from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)),
    wins = wins + 1 - (select home_win from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)),
    losses = losses + (select home_win from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)),
    matches_played = matches_played + 1,
    clean_sheets = clean_sheets + if((select away_team_goals from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)) > 0 and
									(select home_team_goals from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture)) = 0, 1, 0)
where userteam_id = (select away_team_id from fantasyfixture where fantasyfixture_id = (select max(fantasyfixture_id) from fantasyfixture));
SELECT * FROM pl.userteamstats;
-- TODO Update immediately after fixture
-- TODO Re-make with variables
