
#1.Retrieve all players from the team Arsenal:
SELECT player.player_id, player.player_name
FROM player
JOIN team ON player.team_id = team.team_id
WHERE team.team_name = 'Arsenal';


#2. Get the total points scored by a users fantasy team in a specific season
SELECT userteam.team_name, SUM(playerstats.points) AS total_points
FROM userteam
JOIN playerstats ON userteam.userteam_id = playerstats.userteam_id
WHERE userteam.user_id = 1001 AND playerstats.season_id = 1
GROUP BY userteam.team_name;

#3. Retrieve all users in a fantasy league
SELECT users.user_id, users.username, fantasyleague.league_name
FROM users
JOIN league ON users.user_id = league.user_id
JOIN fantasyleague ON league.league_id = fantasyleague.league_id
WHERE fantasyleague.season_id = 1;


#4Retrieve the upcoming fixtures for a specific team:
SELECT fixture.fixture_id, home_team.team_name AS home_team, away_team.team_name AS away_team, fixture.date
FROM fixture
JOIN team AS home_team ON fixture.home_team_id = home_team.team_id
JOIN team AS away_team ON fixture.away_team_id = away_team.team_id
WHERE (home_team.team_name = 'Chelsea' OR away_team.team_name = 'Chelsea') AND fixture.date > CURDATE()
ORDER BY fixture.date;


