CREATE DATABASE footballplayermanagement;
USE footballplayermanagement;

CREATE TABLE teams(
	team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(100) NOT NULL,
    founded_year INT NOT NULL,
    stadium VARCHAR (100) NOT NULL,
    ranking_position INT DEFAULT 0
);

CREATE TABLE coaches(
	coach_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    experience_year INT DEFAULT 0,
    team_id INT,
    
    CONSTRAINT FOREIGN KEY(team_id) REFERENCES teams(team_id)
);

CREATE TABLE players(
	player_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    jersey_number INT NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(12,2) NOT NULL,
    team_id INT ,
    
    CONSTRAINT FOREIGN KEY(team_id) REFERENCES teams(team_id)
);

CREATE TABLE matches(
	match_id INT PRIMARY KEY AUTO_INCREMENT,
    home_team_id INT,
    away_team_id INT,
    match_date DATETIME NOT NULL,
    stadium VARCHAR(100) NOT NULL,
    match_status VARCHAR(30) DEFAULT('Scheduled'),
    
    CONSTRAINT FOREIGN KEY (home_team_id) REFERENCES teams(team_id),
    CONSTRAINT FOREIGN KEY (away_team_id) REFERENCES teams(team_id)
);
drop table matches;


CREATE TABLE player_statistics(
	stat_id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT,
    match_id INT,
    goals INT DEFAULT 0,
    assists INT DEFAULT 0,
    yellow_cards INT DEFAULT 0,
    rating_score DECIMAL(3,1) DEFAULT 0
);

INSERT INTO teams VALUES
(1,'Manchester CiTy',1880,'Etihad Stadium',1),
(2,'Real Madrid',1902,'Santiago Bernabeu',2),
(3,'Hanoi FC',2006,'Hang Day Stadium',3),
(4,'Saigon United',2015,'Thong Nhat Stadium',5),
(5,'Thép Xanh Nam Định',1979,'Thiên Trường Stadium',10);

INSERT INTO coaches VALUES 
(1,'Pepguardiola','Spanish',15,1),
(2,'Carlor Ancelotti','italian',25,2),
(3,'Chu Đình Nghiêm','Vietnamese',12,3),
(4,'Alexandre Polking','German-brazilian',10,4),
(5,'Park Hang-seo','Korean',15,1);

INSERT INTO players VALUES
(1,'Erling-Haaland',9,'Forward',450000000,1),
(2,'Kevin De Bruyne',17,'Midfielder',400000000,1),
(3,'Nguyễn Quang Hải',19,'Midfielder',60000000,3),
(4,'Kylian Mbappe',7,'Forward',500000000,2),
(5,'Nguyễn Văn Quyết',10,'Forward',55000000,3);

INSERT INTO matches VALUES
(1,1,2,'2026-05-10-19:00','Etihad Stadium','Finished'),
(2,3,4,'2026-05-12-18:30','Hang Day Stadium','Finished'),
(3,5,1,'2026-05-15-20:00','Thien Truong Staplayer_statisticsdium','Scheduled'),
(4,2,3,'2026-05-20-21:00','Santiago Bernabeu','Scheduled'),
(5,4,5,'2026-05-25-17:00','Thong Nhat Stadium','Scheduled');

INSERT INTO player_statistics VALUES
(1,1,1,2,1,0,9.5),
(2,4,1,1,0,1,8.2),
(3,3,2,0,2,0,8.5),
(4,5,2,3,0,0,9.0),
(5,1,4,0,0,3,5.0);
-- PHẦN 2 - CÂU 2
-- YÊU CẦU 1:
SET SQL_SAFE_UPDATES = 0;
UPDATE players
SET salary = salary * 1.15
WHERE position = 'Forward'
AND player_id IN (
    SELECT player_id
    FROM player_statistics
    GROUP BY player_id
    HAVING AVG(rating_score) > 8
);
SET SQL_SAFE_UPDATES = 1;
-- YÊU CẦU 2:
SET SQL_SAFE_UPDATES = 0;
DELETE FROM player_statistics
WHERE yellow_cards > 2;
SET SQL_SAFE_UPDATES = 1;
-- PHẦN 3
SELECT full_name, jersey_number, position
FROM players
WHERE salary > 50000000
OR position = 'Midfielder';
-- CÂU 2:
SELECT team_name, stadium
FROM teams
WHERE ranking_position BETWEEN 1 AND 5
AND stadium LIKE 'S%';
-- CÂU 3:
SELECT player_id, full_name, salary
FROM players
WHERE salary = (
    SELECT MAX(salary)
    FROM players
);
-- Phần 4
-- Câu 1:
SELECT 
    p.full_name,
    t.team_name,
    ps.goals,
    ps.assists
FROM players p
INNER JOIN teams t
ON p.team_id = t.team_id
INNER JOIN player_statistics ps
ON p.player_id = ps.player_id;
-- Câu 2:
SELECT 
    t.team_name,
    SUM(ps.goals) AS total_goals
FROM teams t
JOIN players p
ON t.team_id = p.team_id
JOIN player_statistics ps
ON p.player_id = ps.player_id
GROUP BY t.team_name
HAVING SUM(ps.goals) > 10;
-- Câu 3:
SELECT *
FROM players
WHERE salary = (
    SELECT MAX(salary)
    FROM players
);
-- PHẦN 5
-- CÂU 1: 
CREATE INDEX idx_position_salary
ON players(position, salary);
-- CÂU 2:
CREATE VIEW team_salary_summary AS
SELECT 
    t.team_name,
    COUNT(p.player_id) AS total_players,
    SUM(p.salary) AS total_salary
FROM teams t
JOIN players p
ON t.team_id = p.team_id
WHERE p.salary > 0
GROUP BY t.team_name;
