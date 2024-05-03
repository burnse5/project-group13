## Database Systems: Goat Progeny Report 
#### Group Members: Brielle Damiani, Noverah Adeen, Elizabeth Burns
###### Goat Data Database for Sylvies Farm (<https://silvies.us/>) which contains progeny information for each goat.

### Instructions to create the goats database:
#### Enter the following commands into the Linux terminal:
- createdb goats
- psql goats
- \i schema.sql
- \i working_schema.sql
#### Running schema.sql will load csv data into tables, and working_schema.sql will create the Dams and Goats tables of the relational database.
  
### User-End Instructions for the GUI
#### The current User interface supports the following Queries:
[![Home-Page1-v1.png](https://i.postimg.cc/DzMj5GH8/Home-Page1-v1.png)](https://postimg.cc/d7GjVhqY)
 [![Home-Page2.png](https://i.postimg.cc/RF2YCtLj/Home-Page2.png)](https://postimg.cc/tZtk2Yf5)

### Explanation of the Queries' GUI
- Query 1: Find all the Kids belonging to a specific Dam
  - Entering the dam tag of the specific dam results in a list of the Dam's Kids' information (ID, Tag, Sex, DOB)
  [![Query1.png](https://i.postimg.cc/kXQdHMq5/Query1.png)](https://postimg.cc/3dx64TyM)

- Query 2: Find all the gaots born on a specific day
  - Entering the desired month and day results in a list of goats born on that date.
  [![Query2.png](https://i.postimg.cc/x19SVr13/Query2.png)](https://postimg.cc/SJ1Pcv8n)

- Query 3: Find all the dams that have multiple births (more than one kid)
  - Entering the number of kids results in a list of dams who birthed the specified number of kids.
     
  [![QUERY3.png](https://i.postimg.cc/d1kbjw5w/QUERY3.png)](https://postimg.cc/DJhp2kVM)

- Query 4: Find all the kids of a specific Sire
  - Entering Sire Tag results in a list of all the kids of the specified Sire.
[![Query4.png](https://i.postimg.cc/gkq5VnDP/Query4.png)](https://postimg.cc/dL34vQpW)

- Query 5: See all Goat info for goats greater than the specified weight
    - Entering a weight value results in list of goats + their info of a greater weight.
[![Query5.png](https://i.postimg.cc/sDdLtpXW/Query5.png)](https://postimg.cc/MX5tBf1Z)

- Query 6: See all Dams with a specified kid birthweight range.
  - Entering Dam Tag results in a list of all the Dams who have a specified kid birthweight range.
    
[![Query6.png](https://i.postimg.cc/0jmBzNtr/Query6.png)](https://postimg.cc/FkrZqhXQ)




