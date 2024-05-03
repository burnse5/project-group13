-- Group13 Schema for goats database
-- \i schema.sql THEN \i working_schema.sql

-- this view works off the Session Animal Traits table, we use for weights like Birth Weight and Weaning Weigh
--Noverah
CREATE VIEW MergedData AS
SELECT 
    SAT.session_id AS session_id,
    SAT.animal_id AS animal_id,
    SAT.trait_code AS trait_code,
    SAT.alpha_value AS trait_alpha_value,
    SAT.alpha_units AS trait_alpha_units,
    SAT.when_measured AS trait_when_measured,
    SAT.latestForSessionAnimal AS trait_latestForSessionAnimal,
    SAT.latestForAnimal AS trait_latestForAnimal,
    SAT.is_history AS trait_is_history,
    SAT.is_exported AS trait_is_exported,
    SAT.is_deleted AS trait_is_deleted,
    SAA.activity_code AS activity_code,
    SAA.when_measured AS activity_when_measured,
    SAA.latestForSessionAnimal AS activity_latestForSessionAnimal,
    SAA.latestForAnimal AS activity_latestForAnimal,
    SAA.is_history AS activity_is_history,
    SAA.is_exported AS activity_is_exported,
    SAA.is_deleted AS activity_is_deleted
FROM 
    SessionAnimalTrait SAT
INNER JOIN 
    SessionAnimalActivity SAA ON SAT.session_id = SAA.session_id AND SAT.animal_id = SAA.animal_id;


-- initialize goats table, all goats
CREATE TABLE goats(
    eid_tag integer PRIMARY KEY, 
    dob timestamp,
    dam_tag varchar(16) NOT NULL default '',
    goat_tag varchar(16) NOT NULL default '', 
    sex varchar(20) NOT NULL default ''
);

-- Insert into goats, straight from given schema.sql
INSERT INTO goats(eid_tag, DOB, dam_tag, goat_tag, sex)
SELECT animal_id, dob_date, dam, tag, sex
FROM Animal;

-- view of all goats with DOA or DWOT in their tag indicating stillborn
CREATE VIEW stillborn_kids AS
select 
    *
from 
    goats as g
where 
    g.goat_tag LIKE '%DOA%' OR g.goat_tag LIKE '%DWOT%';

-- Number of stillborns per dam
CREATE VIEW dam_num_stillborns AS
select 
    g.goat_tag, COUNT(d.eid_tag) as num_stillborns
from 
    goats as g
join 
    stillborn_kids as d on g.goat_tag = d.dam_tag
group by 
    g.goat_tag;

-- finding who is a dam
CREATE VIEW who_dams AS
SELECT
   d1.*
FROM
   goats AS g
LEFT JOIN
   goats AS d1 ON g.goat_tag = d1.dam_tag
WHERE
   d1.sex = 'Female' AND d1.eid_tag IS NOT NULL;

--How many times a dam has given birth
CREATE VIEW mult_kids AS
select
   g.goat_tag, COUNT(DISTINCT DATE(d.dob)) as mult_births
from
   goats as g
join
   goats as d on g.goat_tag = d.dam_tag
group by
   g.goat_tag;


-- finding the corresponding kids to dams
CREATE VIEW dam_kids AS
select 
    g.goat_tag, COUNT(d.eid_tag) as num_kids
from 
    goats as g
join 
    goats as d on g.goat_tag = d.dam_tag
group by 
    g.goat_tag;

-- dams table, only goats that are dams
CREATE TABLE dams( --eid_tag, dam_tag, num_of_kids, multiple_births, stillborns
    eid_tag integer PRIMARY KEY,
    goat_tag varchar(16) NOT NULL default '',
    num_of_kids float,
    -- avg_weight_of_child varchar(255),
    multiple_births float,
    num_of_stillborns float NOT NULL default 0,
    FOREIGN KEY (eid_tag) REFERENCES goats
);


--insert into dams table 
INSERT INTO dams(eid_tag, goat_tag, num_of_kids, multiple_births, num_of_stillborns)
SELECT
    a.eid_tag,
    a.goat_tag,
    k.num_kids,
    COALESCE (m.mult_births, 0),
    COALESCE (s.num_stillborns, 0)
FROM
    who_dams AS a 
NATURAL JOIN
    dam_kids AS k
LEFT JOIN
    mult_kids AS m ON a.goat_tag = m.goat_tag
LEFT JOIN 
    dam_num_stillborns AS s ON a.goat_tag = s.goat_tag;

-- Birth weights from table 
CREATE VIEW birth_weights_original AS
select 
    animal_id AS eid_tag, 
    trait_alpha_value AS BWT, 
    trait_when_measured AS date_measured
from 
    MergedData as md
where 
    md.trait_code=357;

--Finds birth weight for each goat by eid_tag
--select * from goats natural join birth_weights; --Adds BWT column to goats
CREATE VIEW birth_weights AS
SELECT
   DISTINCT eid_tag,
   CASE 
      WHEN bwt = '' THEN NULL
      ELSE CAST(bwt AS FLOAT)
   END AS bwt
FROM
   birth_weights_original NATURAL JOIN goats
WHERE
   DATE(dob) = DATE(date_measured);

-- View for Sires
CREATE VIEW sires AS
SELECT
    animal_id as eid_tag, 
    tag as goat_tag,
    sire
FROM
    Animal;
    
-- View for Breeds
CREATE VIEW breeds AS
SELECT
    animal_id as eid_tag, 
    tag as goat_tag,
    breed
FROM
    Animal
WHERE
    breed != '';

--View for sale weights, found using status and last_weight
CREATE VIEW sale_weights AS
SELECT
    tag as goat_tag, 
    CASE
        WHEN last_weight = '' THEN NULL
        ELSE CAST (last_weight AS FLOAT)
    END as sale_weight
FROM
    Animal
WHERE
    status = 'Sold';


-- DROP VIEW wean_weights_original; 
CREATE VIEW wean_weights_original AS
select
   animal_id AS eid_tag,
   trait_alpha_value AS wean_wt,
   trait_when_measured AS date_measured
from
   MergedData as md
where
   md.trait_code in (53, 383); -- test : 53

-- DROP VIEW wean_weights;
CREATE VIEW wean_weights AS
select
   distinct eid_tag, wean_wt 
   from
   wean_weights_original NATURAL JOIN goats
where
   extract(year from dob) = extract(year from date_measured)
   AND extract(day from date_measured) in (8, 9); 

-- query to join the goats and the wean_weights 
-- select * from goats natural join wean_weights; 

-- Query to get average of #stillborns, #kids, avg bw oon a specific day,month,year
SELECT
    AVG(d.num_of_stillborns) AS avg_stillborns,
    AVG(d.num_of_kids) AS avg_kids,
    AVG(b.bwt) AS avg_birth_weight
FROM
    dams d
JOIN
    birth_weights b ON d.eid_tag = b.eid_tag
JOIN
    goats g ON d.eid_tag = g.eid_tag
WHERE
    EXTRACT(YEAR FROM g.dob) = 2024
    AND EXTRACT(MONTH FROM g.dob) = 4
    AND EXTRACT(DAY FROM g.dob) = 15;
