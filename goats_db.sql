CREATE TABLE goats(
    eid_tag integer PRIMARY KEY,
    dob timestamp NOT NULL default '',
    dam_EID varchar(16) NOT NULL default '',
    tag varchar(16) NOT NULL default '',
    sex varchar(6) NOT NULL default ''
);
/*maybe add like breed date or soemthing*/
CREATE TABLE dams(
    eid_tag integer PRIMARY KEY,
    tag varchar(16) NOT NULL default '',
    num_of_kids varchar(255),
    num_of_stillborns varchar(255),
    /*avg_weight_of_child varchar(255),*/
    multiple_births char(2),
    FOREIGN KEY (eid_tag) REFERENCES goats,
    FOREIGN KEY (tag) REFERENCES goats
);
/*Might want to change this a bit*/
CREATE TABLE weights(
    birth_weight varchar(9),
    winter_weight varchar(9),
    sale_weight varchar(9),
    weaning_weight varchar(9),
    FOREIGN KEY (EID_tag) REFERENCES goats
);

/*This is Fine*/ 
INSERT INTO goats(EID_tag, DOB, dam_EID, tag, sex)
SELECT animal_id, dob_date, dam, tag, sex
FROM Animal;

/* Need to Debug*/
INSERT INTO dams(EID_tag, num_of_kids, num_of_stillborns, avg_weight_of_child, multiple_births)
SELECT
    d.EID_tag, /*This might be issue*/
    COUNT(g.EID_tag) AS num_of_kids,
    SUM(CASE WHEN g.tag == 'DOA' || g.tag == 'DWOT' THEN 1 ELSE 0 END), /* Not sure on this I think when the tag = DOA means Dead on Arrival, also DWOT means Died without Tag*/
    AVG(w.Birth_weight) AS avg_weight_of_child,
    CASE WHEN COUNT(g.EID_tag) > 1 AND COUNT(DISTINCT g.DOB) < COUNT(g.EID_tag) THEN 'yes' ELSE 'no' END AS multiple_births
FROM
    dams d
LEFT JOIN
    goats g ON d.EID_tag = g.dam_EID
LEFT JOIN  
    weights w ON g.EID_tag = w.EID_tag
GROUP BY
    d.EID_tag;

/*Anything with WT BWT, LWT is a weight just add all of those to the weight table*/
INSERT INTO Weights(birth_weight, winter_weight, sale_weight, weaning_weight)
SELECT (last_weight) /*is this my only option for weights??*/
FROM Animal;



