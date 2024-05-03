-- Liz Test Queries


/*CREATE VIEW who_dams_original AS
SELECT
   d1.*
FROM
   goats AS g
LEFT JOIN
   goats AS d1 ON g.goat_tag = d1.dam_tag
WHERE
   d1.sex = 'Female' AND d1.eid_tag IS NOT NULL;

CREATE VIEW who_dams AS
SELECT
    *
FROM
    who_dams_original
WHERE
    eid_tag IN (select DISTINCT eid_tag FROM who_dams_original);*/


CREATE TABLE dams( --eid_tag, dam_tag, num_of_kids, multiple_births, stillborns
    eid_tag integer PRIMARY KEY,
    goat_tag varchar(16) NOT NULL default '',
    num_of_kids varchar(255),
    -- avg_weight_of_child varchar(255),
    multiple_births integer,
    num_of_stillborns integer NOT NULL default 0,
    FOREIGN KEY (eid_tag) REFERENCES goats
);

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









/*
Made breeds view instead of attribute to be joined with goats, makes query slightly more complex

select * from goats natural join breeds where breed = 'ARG';
    Filters goats by all marked as ARG = American Range Goat
    Can combine this with other queries to have results be only ARGs
    Might want to bc he said queries are 'boring' if they're hard coded instead of variables


CREATE VIEW breeds AS
SELECT
    animal_id as eid_tag, breed
FROM
    Animal
WHERE
    breed != '';

--------------------------------------------------------------------------------------------

Made sires view instead of attribute in goats so there are not a lot of nulls in goats

select * from goats natural join sires where dam_tag = *user input dam_tag*;
    Gives all kids of specific dam with their sires also listed
    Nothing will show in sire column if they do not have a sire listed

select * from goats natural join sires where dam_tag = *user input* or goat_tag = *same input*;
    Gives all kids of specific, and that dam, with their sires listed
    Nothing will show in sire column if they do not have a sire listed
    May list multiple goats as the dam because dam_tags are reused, but there's no other way to know dam
    Test value dam_tag = '10001' - 8 kids, 5 have sires


CREATE VIEW sires AS
SELECT
    animal_id as eid_tag, sire
FROM
    Animal;

--------------------------------------------------------------------------------------------

select * from goats where dob > *specific date*;
    Filters goats born after a specific date, including that date
    Date needs to be in single quotes, format year-month-day
    Ex: '2019-03-23'
select * from goats where dob < *specific date*;
    Filters goats born before a specific date, DOES NOT include that date
*/


