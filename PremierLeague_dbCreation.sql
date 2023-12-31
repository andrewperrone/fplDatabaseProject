drop database if exists pl;
create database pl;
use pl;

create table if not exists season
(
	season_id 	int 	PRIMARY KEY auto_increment, -- Primary Key
    start_date 	date 	not null,
    end_date 	date 	not null
);

insert into season values
(1, '2002-08-17', '2003-05-11'),
(2, '2003-08-16', '2004-05-15'),
(3, '2004-08-14', '2005-05-15'),
(4, '2005-08-13', '2006-05-07'),
(5, '2006-08-19', '2007-05-13'),
(6, '2007-08-11', '2008-05-11'),
(7, '2008-08-16', '2009-05-24'),
(8, '2009-08-15', '2010-05-09'),
(9, '2010-08-14', '2011-05-22'),
(10, '2011-08-13', '2012-05-13'),
(11, '2012-08-18', '2013-05-19'),
(12, '2013-08-17', '2014-05-11'),
(13, '2014-08-16', '2015-05-24'),
(14, '2015-08-08', '2016-05-17'),
(15, '2016-08-13', '2017-05-21'),
(16, '2017-08-11', '2018-05-13'),
(17, '2018-08-10', '2019-05-12'),
(18, '2019-08-09', '2020-06-26'),
(19, '2020-09-12', '2021-06-23'),
(20, '2021-08-14', '2022-05-22'),
(21, '2022-08-05', '2023-05-28'),
(22, '2023-08-11', '2024-05-19');

create table if not exists league
(
	league_id 		int 		PRIMARY KEY auto_increment, -- Primary Key
	league_name 	varchar(50) not null
);

insert into league values
(1, 'Premier League');

create table if not exists fantasyLeague
(
	fantasyleague_id 		int 		PRIMARY KEY auto_increment, -- Primary Key
    fantasyleague_name 		varchar(50) not null
);

insert into fantasyLeague(fantasyleague_name) values
('Scholastica FC'),
('Fossil Premier League'),
('Super-charged Sparrows'),
('Diogenese'),
('The Concatonators'),
('Lupus League'),
('NYCFC'),
('Ungoliant United'),
('Sportsball'),
('GameGame');

create table if not exists team
(
	team_id 		int 		PRIMARY KEY auto_increment, -- Primary Key
    team_name		varchar(50) not null,
    league_id 		int 		default(1) not null,
    
    constraint team_fk_league
		foreign key (league_id)
			references league(league_id)
				on delete no action
);

Insert into team(team_name) values
("Arsenal FC"),
("Aston Villa FC"),
("Brentford FC"),
('Burnley FC'),
("AFC Bournemouth"),
("Chelsea FC"),
("Manchester United FC"),
("Luton Town FC"),
("Everton FC"),
("Manchester City FC"),
("West Ham United FC"),
("NewCastle United"),
('Tottenham Hotspur FC');

create table if not exists userTeam
(
	userteam_id 	int 		PRIMARY KEY auto_increment, -- Primary Key
	display_name 	varchar(50) unique not null,
    full_name 		varchar(50) not null,
    team_name		varchar(50) not null,
    email 			varchar(50) default(null), -- Normally would not default to null but we probably won't fill these columns out
    `password` 		varchar(50) default(null),  -- Going to use them to practice views (maybe security too?)
    budget 			int			default(100) not null
    -- TODO make sure budget >= 0 AND budget <= 100
);

insert into userTeam(display_name, full_name, team_name) values
('AqibAshan03','Aqib Ashan', 'AqibsTeam'),
('Shakti', 'Shakti', 'Shaktis Soldiers'),
('App', 'Andrew Perrone', 'Andrews AAAAAAAAAAAAAAA'),
('WhimsicalWombat', 'Will', 'Wombatants'),
('Greg92', 'Greg', 'Team1'),
('xXxTentacionxXx', 'John Doe', 'Joy Ride'),
('Anonymous8753', 'Matt Smith', 'team'),
('Billy Eyelash', 'Rebecca', 'Espiritus'),
('SnailMan', 'Joe Shmoe', 'Goths'),
('Kira', 'Light Kamina', 'Shinigami');

create table if not exists fantasyLeagueMember
(
	userteam_id 		int not null,
    fantasyleague_id 	int not null,
    creator 			bool default(0),
    
    constraint fantasyLeagueMember_pk
		primary key (userteam_id,fantasyleague_id),
	constraint fantasyLeagueMember_fk_userTeam
		foreign key (userteam_id)
			references userTeam(userteam_id)
				on delete no action,
	constraint fantasyLeagueMember_fk_fantasyLeague
		foreign key (fantasyleague_id)
			references fantasyLeague(fantasyleague_id)
				on delete no action
);

insert into fantasyLeagueMember values
(1, 1, 1), -- Aqib owns LeagueID 1
(2, 1, 0), -- Shakti and Andrew are members of fantasyleague_id 1
(3, 1, 0),
(2, 2, 1), -- Every fantasyleague must be owned by a user to mantain the schema
(3, 3, 1), -- TODO create SQL statements for creating and joining leagues
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 1),
(10, 10, 1);

create table if not exists player
(
	player_id 		int 		PRIMARY KEY auto_increment,
	player_name 	varchar(50) not null,
   	cost			int 		default(5) not null,
	pos ENUM('GK', 'D', 'M', 'F')  not null,
	team_id			int,
    	league_id		int 		default(1) not null,
    	constraint player_fk_team
		foreign key (team_id)
			references team(team_id)
				on delete no action,
	constraint player_fk_league
		foreign key (league_id)
			references league(league_id)
				on delete no action
);

insert into player(player_name, cost, pos, team_id) values
('David Raya Martin', '4.9', 'GK', '1'),
('Aaron Ramsdale', '4.7', 'GK', '1'),
('Karl Hein', '4.0', 'GK', '1'),
('William Saliba', '5.5', 'D', '1'),
('Oleksandr Zinchenko', '5.2', 'D', '1'),
('Benjamin White', '5.7', 'D', '1'),
('Gabriel Magalhães', '4.9', 'D', '1'),
('Jakub Kiwior', '4.9', 'D', '1'),
('Cédric Alves Soares', '3.9', 'D', '1'),
('Jurriën Timber', '4.9', 'D', '1'),
('Reuell Walters', '4.0', 'D', '1'),
('Bukayo Saka', '8.9', 'M', '1'),
('Martin Ødegaard', '8.3', 'M', '1'),
('Declan Rice', '5.4', 'M', '1'),
('Leandro Trossard', '6.5', 'M', '1'),
('Gabriel Martinelli Silva', '7.8', 'M', '1'),
('Kai Havertz', '7.1', 'M', '1'),
('Jorge Luiz Frello Filho', '5.3', 'M', '1'),
('Eddie Nketiah', '5.6', 'F', '1'),
('Gabriel Fernando de Jesus', '7.9', 'F', '1');

create table if not exists fantasyTeamMember
(
	pos ENUM('GK', 'LB', 'CLB', 'CRB', 'RB', 'DM', 'LM', 'CLM', 'CRM', 'RM', 'ST', 'R1', 'R2', 'R3', 'R4') not null,
    userteam_id 	int		not null,
    player_id 		int		default(null), -- TODO players must be unique to a team but also allowed to be null
    
    constraint fantasyTeamMember_pk
		primary key (pos, userteam_id),
	constraint fantasyTeamMember_fk_userteam
		foreign key (userteam_id)
			references userTeam(userteam_id)
				on delete no action,
	constraint fantasyTeamMember_fk_player
		foreign key (player_id)
			references player(player_id)
				on delete no action
);
-- TODO max 3 players from a real team in a fantasy team

insert into fantasyTeamMember(pos, userteam_id, player_id) values
('GK', '1', '1'),
('LB', '1', '2'),
('CLB', '1', '3'),
('CRB', '1', '4'),
('RB', '1', '5'),
('DM', '1', '6'),
('LM', '1', '7'),
('CLM', '1', '8'),
('CRM', '1', '9'),
('RM', '1', '10'),
('ST', '1', '11'),
('R1', '1', '12'),
('R2', '1', '13'),
('R3', '1', '14'),
('R4', '1', '15');

create table if not exists fixture
(
	fixture_id 		int			PRIMARY KEY auto_increment,
	gameweek		int 		default(0)not null,
	fixture_date 	date 		not null,
	location		varchar(50)	not null,
	league_id		int 		default(1) not null,
	season_id		int			default(1) not null,
	home_team_id	int 		not null,
	home_team_goals	int			not null,
	away_team_id	int 		not null,
	away_team_goals	int			not null,
	forfeit			bool		default(0) not null,
	draw 			bool 		default(0) not null,

	constraint fixture_fk_league
		foreign key (league_id)
			references league(league_id)
				on delete no action,
	constraint fixture_fk_season
		foreign key (season_id)
			references season(season_id)
				on delete no action,
	constraint fixture_fk_hometeam
		foreign key (home_team_id)
			references team(team_id)
				on delete no action,
	constraint fixture_fk_awayteam
		foreign key (away_team_id)
			references team(team_id)
				on delete no action
);

-- Sets the default to the current season
alter table fixture
alter column season_id set default(22);

INSERT INTO fixture(fixture_date, location, home_team_id, home_team_goals, away_team_id, away_team_goals) VALUES 
('2023-11-25', 'GTech Community Stadium, Brentford', '3', '0', '1', '1'),
('2023-09-30', 'Vitality Stadium, Bournemouth',		 '5', '0', '1', '4'),
('2023-10-21', 'Stamford Bridge, London', 			 '6', '2', '1', '2'),
('2023-09-03', 'Emirates Stadium, London', 			 '1', '3', '7', '1'),
('2023-12-05', 'Kelinworth Road, Luton', 			 '8', '3', '1', '4'),
('2023-09-17', 'Goodison Park, Liverpool', 			 '9', '0', '1', '1'),
('2023-10-08', 'Emirates Stadium, London',  		 '1', '1','10', '0'),
('2023-11-04', 'St James Park, Newcastle', 			'12', '0', '1', '1'),
('2023-11-11', 'Emirates Stadium, London',			 '1', '3', '4', '1'),
('2023-09-24', 'Emirates Stadium, London', 			 '1', '2','13', '2');

create table if not exists fantasyFixture
(
	fantasyfixture_id 	int		PRIMARY KEY auto_increment,
    gameweek			int 	default(0) not null,
    fantasyleague_id	int 	not null,
    season_id			int		default(1) not null,
    home_team_id		int 	not null,
    home_team_goals		int		not null,
    away_team_id		int 	not null,
    away_team_goals		int		not null,
    home_win			bool    default(0) not null,
    draw				bool 	default(0) not null,
    
    constraint fantasyfixture_fk_fleague
		foreign key (fantasyleague_id)
			references fantasyLeague(fantasyleague_id)
				on delete no action,
	constraint fantasyfixture_fk_season
		foreign key (season_id)
			references season(season_id)
				on delete no action,
	constraint fantasyfixture_fk_hometeam
		foreign key (home_team_id)
			references userTeam(userteam_id)
				on delete no action,
	constraint fantasyfixture_fk_awayteam
		foreign key (away_team_id)
			references userTeam(userteam_id)
				on delete no action
);

-- Sets the default to the current season
alter table fantasyFixture
alter column season_id set default(22);
-- TODO automatically find current season

create table if not exists teamStats
(
	team_id				int 	not null,
    season_id 			int 	not null,
    matches_played		int 	default(0)	not null,
    wins				int     default(0)	not null,
    losses 				int 	default(0)	not null,
    goals				int 	default(0)  not null,
    goals_conceded		int 	default(0)  not null,
    clean_sheets		int 	default(0)  not null, 	
    
    constraint teamstats_pk
		primary key (team_id, season_id),
	constraint teamstats_fk_team
		foreign key (team_id)
			references team(team_id)
				on delete no action,
	constraint teamstats_fk_season
		foreign key (season_id)
			references season(season_id)
				on delete no action
);

insert into teamStats(team_id,season_id,matches_played,wins,losses,goals,goals_conceded,clean_sheets) values
('1','22','14','10','1','31','12','6'),
('2','22','14','9','3','33','20','2'),
('3','22','14','5','5','22','19','3'),
('4','22','14','3','7','16','30','2'),
('5','22','14','5','5','25','22','3'),
('6','22','14','8','6','16','17','5'),
('7','22','14','2','9','15','28','0'),
('8','22','14','5','7','15','20','3'),
('9','22','14','9','2','36','16','4'),
('10','22','14','6','5','24','24','1'),
('11','22','14','8','4','32','14','6');

create table if not exists userTeamStats
(
	userteam_id			int 	not null,
    season_id 			int 	not null,
    matches_played		int 	default(0)	not null,
    wins				int     default(0)	not null,
    losses 				int 	default(0)	not null,
    goals				int 	default(0)  not null,
    goals_conceded		int 	default(0)  not null,
    clean_sheets		int 	default(0)  not null,
    
    constraint userteamstats_pk
		primary key (userteam_id, season_id),
	constraint userteamstats_fk_team
		foreign key (userteam_id)
			references userTeam(userteam_id)
				on delete no action,
	constraint userteamstats_fk_season
		foreign key (season_id)
			references season(season_id)
				on delete no action
);

insert into userTeamStats(userteam_id, season_id) values
(1,22),
(2,22),
(3,22),
(4,22),
(5,22),
(6,22),
(7,22),
(8,22),
(9,22),
(10,22);

create table if not exists playerStats
(
	player_id			int 	not null,
    season_id 			int 	not null,
    apearances			int 	default(0)	not null,
    wins				int     default(0)	not null,
    losses 				int 	default(0)	not null,
    goals				int 	default(0)  not null,
    goals_conceded		int 	default(0)  not null,
    assists				int 	default(0)  not null,
    passes				int 	default(0)  not null,
    crosses				int 	default(0)  not null,
    blocked_shots		int 	default(0)  not null,
    clearance			int 	default(0)  not null,
    interception		int 	default(0)  not null,
    
    constraint playerstats_pk
		primary key (player_id, season_id),
	constraint playerstats_fk_player
		foreign key (player_id)
			references player(player_id)
				on delete no action,
	constraint playerstats_fk_season
		foreign key (season_id)
			references season(season_id)
				on delete no action
);

INSERT INTO playerStats (player_id,season_id,apearances,wins,losses,goals,goals_conceded,assists,passes,crosses,blocked_shots,clearance,interception) VALUES
(1, 22, 10, 6, 1, 0, 7, 0, 292, 0, 0, 0, 0),
(2, 22, 5, 4, 0, 0, 4, 0, 126, 0, 0, 0, 0),
(3, 22, 15, 10, 1, 1, 11, 1, 1120, 0, 2, 26, 9),
(4, 22, 15, 10, 1, 1, 11, 1, 1141, 0, 0, 0, 0),
(5, 22, 13, 9, 1, 1, 7, 0, 2727, 0, 8, 6, 9),
(6, 22, 14, 9, 1, 1, 11, 1, 737, 16, 0, 24, 10),
(7, 22, 13, 9, 1, 0, 9, 0, 662, 1, 4, 19, 11),
(8, 22, 6, 4, 0, 0, 3, 0, 162, 3, 0, 11, 0),
(9, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 22, 1, 1, 0, 0, 0, 0, 45, 0, 0, 1, 0),
(11, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(12, 22, 14, 9, 1, 5, 0, 6, 536, 75, 8, 5, 6),
(13, 22, 12, 8, 0, 4, 0, 1, 546, 27, 7, 1, 3),
(14, 22, 15, 10, 1, 2, 0, 1, 925, 4, 7, 24, 23),
(15, 22, 11, 7, 1, 3, 0, 1, 191, 31, 5, 1, 5),
(16, 22, 13, 9, 1, 2, 0, 2, 387, 65, 7, 1, 3),
(17, 22, 15, 10, 1, 3, 0, 1, 318, 5, 5, 5, 7),
(18, 22, 11, 7, 1, 0, 0, 0, 317, 3, 2, 2, 2),
(19, 22, 14, 10, 1, 5, 0, 0, 152, 0, 6, 3, 3),
(20, 22, 10, 6, 0, 2, 0, 1, 183, 3, 4, 3, 5);

-- Sample Views
-- All Time teamStats (includes every instance of team stats from other seasons)
create view total_teamstats as
select s.team_id, 
	(select team_name from team t where t.team_id = s.team_id) as 'team_name',
	sum(matches_played) as 'matches_played', 
    sum(wins) as 'wins', 
    sum(losses) as 'losses',
    sum(goals) as 'goals',
    sum(goals_conceded) as 'goals_conceded',
    sum(clean_sheets) as 'clean_sheets'
from teamStats s
group by s.team_id;

-- All Time userTeamStats
create view total_userteamstats as
select s.userteam_id, 
	(select display_name from userTeam u where u.userteam_id = s.userteam_id) as 'display_name',
    (select team_name from userTeam u where u.userteam_id = s.userteam_id) as 'team_name',
	sum(matches_played) as 'matches_played', 
    sum(wins) as 'wins', 
    sum(losses) as 'losses',
    sum(goals) as 'goals',
    sum(goals_conceded) as 'goals_conceded',
    sum(clean_sheets) as 'clean_sheets'
from userTeamStats s
group by s.userteam_id;

-- All Time playerStats
create view total_playerstats as
select s.player_id, 
	(select player_name from player p where p.player_id = s.player_id) as 'player_name',
	sum(apearances) as 'apearances', 
    sum(wins) as 'wins', 
    sum(losses) as 'losses',
    sum(goals) as 'goals',
    sum(goals_conceded) as 'goals_conceded',
    sum(assists) as 'assists',
    sum(passes) as 'passes',  
    sum(crosses) as 'crosses',
    sum(blocked_shots) as 'blocked_shots',
    sum(clearance) as 'clearance',
    sum(interception) as 'interception'
from playerStats s
group by s.player_id;

-- TODO Create secure user view (prevent seeing real names, passwords and emails)
-- TODO Create user view so users can see their own passwords and emails
