-- Brielle Test Queries
SELECT
   COUNT(g.eid_tag) AS total_kids, -- Count number of kids on the day
   AVG(b.bwt) AS avg_birth_weight, -- Get the average birth weight for the day
   SUM(CASE WHEN g.goat_tag LIKE '%DOA%' OR g.goat_tag LIKE '%DWOT%' THEN 1 ELSE 0 END) AS total_stillborns, -- Count total stillborns
   date(g.dob)
FROM 
   birth_weights AS b
NATURAL JOIN 
   goats AS g
--LEFT JOIN stillborn_kids AS sk ON g.eid_tag = sk.eid_tag
WHERE EXTRACT(MONTH FROM g.dob) = 3 
GROUP BY date(dob);

-- select 
--     COUNT(g.eid_tag) as total_kids, --count number of kids on day
--     AVG(b.bwt) as avg_birth_weight, --get average birth weight for day
--     COUNT(g.goat_tag LIKE '%DOA%' OR g.goat_tag LIKE '%DWOT%') AS total_stillborns, -- number of still borns
--     g.dob 
-- from birth_weights as b 
-- NATURAL JOIN goats as g  
-- FULL OUTER JOIN stillborn_kids as sk 
-- ON g.eid_tag = sk.eid_tag 
-- where date(g.dob) = '2021-11-06'
-- group by (DISTINCT DATE(g.dob)); 

-- SELECT
    -- SUM(d.num_of_stillborns) AS total_stillborns,
    -- COUNT(g.eid_tag) AS total_kids,
    -- AVG(b.bwt) AS avg_birth_weight
-- FROM
--     dams d
-- JOINp
--     birth_weights b ON d.eid_tag = b.eid_tag
-- JOIN
--     goats g ON d.eid_tag = g.eid_tag
-- WHERE
--     EXTRACT(YEAR FROM g.dob) = 2021
--     AND EXTRACT(MONTH FROM g.dob) = 3
--     AND EXTRACT(DAY FROM g.dob) = 18;

-- select * from goats where date(dob) = '2021-03-18'



-- --Query 1
--     SELECT goat_tag, sex, dob 
--     FROM goats 
--     WHERE dam_tag = '9007' --user input
-- --Query 2
    -- Select dob, goat_tag, sex 
    -- from goats 
    -- where extract(month from dob) = 3 --user input
    -- AND extract(day from dob) = 10; -- user input
-- --Query 3
--     select * 
--     from mult_kids 
--     where mult_births >= 3; -- user input
-- --Query 4
--     select sire, goat_tag, dob 
--     from goats natural join sires 
--     where sire = '10LYNX'; --user input
-- --Query 5
--     select goat_tag, dob, dam_tag, sex, bwt 
--     from goats natural join birth_weights 
--     where bwt > 8.0; --user input

-- --Query 6
--    select dam_tag, AVG(bwt) 
--     from goats natural join birth_weights 
--     where bwt >= 7.5 --user input
--     AND bwt <= --user input 
--     group by dam_tag;

-- NEW QUERIES

--query 7 show all goats born between ___ and ___
-- Select * from (
--     select * 
--     from goats natural join birth_weights 
--     where dob BETWEEN  '2021-03-06' --user input
--     AND '2021-03-10' --user input 
-- ) AS query7;

-- Query 8 show dams and info children between ____ and ___
-- select dam_tag, AVG(bwt)
-- from goats natural join birth_weights
-- where dam.dob
-- group by dam_tag;

-- select goat_tag, dob, dam_tag, sex, bwt 
-- from goats natural join birth_weights 
-- where bwt >= 7.0 AND bwt <= 8.0;



-- CREATE VIEW sires AS
-- SELECT
--     animal_id as eid_tag, 
--     tag as goat_tag,
--     sire
-- FROM
--     Animal;

-- CREATE VIEW breeds AS
-- SELECT
--     animal_id as eid_tag, 
--     tag as goat_tag,
--     breed
-- FROM
--     Animal
-- WHERE
--     breed != '';





-- select dam_tag, AVG(bwt)
-- from goats natural join birth_weights 
-- where bwt >= 7.0 AND bwt <= 8.0 
-- group by dam_tag; 

-- --birth weights old
-- CREATE VIEW birth_weights AS
-- select 
--     distinct eid_tag, bwt
-- from 
--     birth_weights_original NATURAL JOIN goats
-- where 
--     (dob) = date(date_measured);

-- CREATE VIEW birth_weights_original AS
-- select 
--     animal_id AS eid_tag, 
--     trait_alpha_value AS BWT, 
--     trait_when_measured AS date_measured
-- from 
--     MergedData as md
-- where 
--     md.trait_code=357;


-- CREATE VIEW birth_weights AS
-- select 
--     distinct eid_tag, bwt
-- from 
--     birth_weights NATURAL JOIN goats
-- where 
--     date(dob) = date(date_measured);