-- Noverah Test File to Test Queries

/* Tables of info we want additionally from CSVs that are not included in schema.sql*/ 


-- this view works, make queries based off of MergedData and goats table
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


-- Create a view to display the mother's dam_tag, average birthweight, and the eid_tag of the heaviest child.
--CREATE VIEW DamAverageBirthweight AS
--SELECT 
    -- Mother's dam_tag
    --d.dam_tag AS mother_dam_tag,
    -- Average birth weight of the mother's children
   -- AVG(CAST(m.trait_alpha_value AS FLOAT)) AS avg_birth_weight,
    -- eid_tag of the heaviest child
   -- MAX(CAST(m.trait_alpha_value AS FLOAT)) AS heaviest_child_eid_tag
--FROM 
    -- Join the who_dams view with the goats table to get the mother's information
   -- who_dams AS d
--JOIN 
 --   goats AS g ON d.eid_tag = g.dam_tag
--JOIN 
    -- Join the MergedData view to get birth weight information
    --MergedData AS m ON g.goat_tag = m.animal_id
--WHERE 
    -- Filter the birth weight data to include only rows where trait_code = 357 (birth weight)
 --   m.trait_code = 357
--GROUP BY 
    -- Group the results by the mother's dam_tag
  --  d.dam_tag;
  

--Query without the who-dams schema since who-dams doesn't work for me?
--select trait_alpha_value from MergedData where trait_code = 357; -- gets the birth weight



-- manually doing average: this view works but results in a zero value
/* CREATE VIEW avg_birthweight_per_dam AS
SELECT
   g.dam_tag,
   SUM(md.trait_alpha_value::numeric) / COUNT(*) AS avg_bw
FROM
   goats AS g
JOIN
   MergedData AS md ON g.eid_tag = md.animal_id
WHERE
   md.trait_code IN (381, 393, 436, 405)
GROUP BY
   g.dam_tag; */


-- get the weaning weights just like the birth weights 
--Query 2
--     Select dob, goat_tag, sex 
--     from goats 
--     where extract(month from dob) = 3 --user input
--     AND extract(day from dob) = 10; -- user input
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
   distinct eid_tag, wean_wt --, dob, date_measured --dob and date measured should be same yr
from
   wean_weights_original NATURAL JOIN goats
where
   extract(year from dob) = extract(year from date_measured)
   AND extract(day from date_measured) in (8, 9); 
   -- MATCH YR OF DOB, AND YEAR OF THE DATE MEASURED, isolate august and september

-- query to join the goats and the wean_weights 
select * from goats natural join wean_weights;   

 -- Query FOR AVG wean weights (avg not working for me)
 --select eid_tag, AVG(wean_wt), dob
 --FROM goats natural join wean_weights 
 --GROUP BY dob;