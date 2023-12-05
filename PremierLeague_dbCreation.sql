drop database if exists pl;
create database pl;
use pl;

create table if not exists season
(
	season_id int PRIMARY KEY auto_increment,
    startDate date not null,
    endDate date not null
);

create table if not exists fantasyLeague
(
	fantasyleague_id 		int 		PRIMARY KEY auto_increment, -- Primary Key
    fantasyleague_name 		varchar(50) not null
);

create table if not exists league
(
	league_id 		int 		PRIMARY KEY auto_increment, -- Primary Key
	league_name 	varchar(50) not null
);

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

-- TODO max 3 players from a real team in a fantasy team

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

create table if not exists fantasyLeagueMember
(
	userteam_id int not null,
    fantasyleague_id int not null,
    creator bool default(0),
    
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

create table if not exists player
(
	player_id 		int 		PRIMARY KEY auto_increment,
    	player_name 		varchar(50) not null,
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

create table if not exists fantasyTeamMember
(
	pos ENUM('GK', 'LB', 'CLB', 'CRB', 'RB', 'DM', 'LM', 'CLM', 'CRM', 'RM', 'ST', 'R1', 'R2', 'R3', 'R4') not null,
    userteam_id 	int			not null,
    player_id 		int 		not null,
    
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

create table if not exists fixture
(
	fixture_id 		int		PRIMARY KEY auto_increment,
	gameweek		int 	not null,
    	fixture_date 	date 	not null,
    	location		date	not null,
    	league_id		int 	default(1) not null,
    	season_id		int		not null,
    	home_team_id	int 	not null,
    	home_team_goals	int		not null,
    	away_team_id	int 	not null,
    	away_team_goals	int		not null,
    	forfeit			bool	default(0),
    	draw 			bool 	default(0),
    
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

create table if not exists fantasyFixture
(
	fixture_id 			int		PRIMARY KEY auto_increment,
    gameweek			int 	not null,
    fantasyleague_id	int 	not null,
    season_id			int		not null,
    home_team_id		int 	not null,
    home_team_goals		int		not null,
    away_team_id		int 	not null,
    away_team_goals		int		not null,
    forfeit				bool	default(0),
    draw 				bool 	default(0),
    
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

-- Manual Data Input
insert into league values
(1, 'Premier League');

insert into fantasyLeague(league_name) values
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

-- Sample SQL DML Statements
SELECT * from fantasyFixtures
WHERE SeasonID = 22;

SELECT * from UserTeamStats
WHERE SeasonID = 22;

SELECT * from UserTeamStats
Where fantasyLeagueID = 256;

SELECT * from fantasyFixtures
WHERE fantasyLeagueID = 256;

SELECT creator from fantasyLeagueMember
WHERE UserTeamId = 10;

SELECT * from fantasyTeamMember
WHERE UserTeamID = 10;

SELECT stats from PlayerStats
Where PlayerID = 25 and SeasonID = 22;

SELECT * from Player
WHERE TeamID = 14;

SELECT * from Fixtures
WHERE TeamID = 14;



-- Sample Views
/*create view userteamstats_alltime as
select * 
from userTeamStats
where user_id = 1;
