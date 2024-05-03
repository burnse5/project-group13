#! /usr/bin/python3
# Worked on by Brielle Damiani

"""
This is an example Flask | Python | Psycopg2 | PostgreSQL 
application that connects to the goats database
Template provided by John Degood

----

One-Time Installation

You must perform this one-time installation in the CSC 315 VM:

# install python pip and psycopg2 packages
sudo pacman -Syu
sudo pacman -S python-pip python-psycopg2 python-flask

----

Usage

To run the Flask application, simply execute:

export FLASK_APP=app.py 
flask run
# then browse to http://127.0.0.1:5000/

----

References

Flask documentation:  
https://flask.palletsprojects.com/  

Psycopg documentation:
https://www.psycopg.org/

This example code is derived from:
https://www.postgresqltutorial.com/postgresql-python/
https://scoutapm.com/blog/python-flask-tutorial-getting-started-with-flask
https://www.geeksforgeeks.org/python-using-for-loop-in-flask/
"""

import psycopg2
from config import config
from flask import Flask, render_template, request

# Connect to the PostgreSQL database server
def connect(query):
    conn = None
    try:
        # read connection parameters
        params = config()
 
        # connect to the PostgreSQL server
        print('Connecting to the %s database...' % (params['database']))
        conn = psycopg2.connect(**params)
        print('Connected.')
      
        # create a cursor
        cur = conn.cursor()
        
        # execute a query using fetchall()
        cur.execute(query)
        rows = cur.fetchall()

        # close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')
    # return the query result from fetchall()
    return rows
 
# app.py
app = Flask(__name__)


# serve form web page
@app.route("/")
def form():
    return render_template('my-form.html')

# Shows all Kids of a Dam PROGENY REPORT
# @app.route('/query1-handler', methods=['POST'])
# def goat_handler():
#     dam_tag = request.form['dam_tag']  # Get the dam_tag value from the form
#     query1 = f"""SELECT goat_tag, sex, dob, bwt 
#                 FROM goats natural join birth_weights 
#                 WHERE dam_tag = '{dam_tag}'"""
#     rows = connect(query1)  # Ensure dam_tag is enclosed in quotes
#     heads = ['Goat Tag', 'Sex', 'DOB', 'Birth Weight']
#     return render_template('my-result.html', rows=rows, heads=heads)
@app.route('/query1-handler', methods=['POST'])
def query1_handler():
    dam_tag = request.form['dam_tag']
    checkbox_value = request.form.get('checkbox')

    # Define SQL queries
    if checkbox_value:
        query1 = f"""SELECT goat_tag, sex, dob, bwt
                      FROM goats NATURAL JOIN birth_weights
                      WHERE dam_tag = '{dam_tag}'"""
        check = True
    else:
        query1 = f"""SELECT goat_tag, sex, dob
                      FROM goats
                      WHERE dam_tag = '{dam_tag}'"""
        check = False
    # Execute SQL query
    rows = connect(query1)
    if check:
        heads = ['Goat Tag', 'Sex', 'DOB', 'Birth Weight']
    else:
        heads = ['Goat Tag', 'Sex', 'DOB']

    return render_template('my-result.html', rows=rows, heads=heads)

# handle query POST and serve result web page
# Select * from goats where extract(month from dob) = 2 AND extract(day from dob) = 18;
@app.route('/query2-handler', methods=['POST'])
def date_handler():
    month = request.form['dob_month']
    day = request.form['dob_day']
    query2 = f""" 
        Select dob, goat_tag, sex 
        from goats 
        where extract(month from dob) = {month} 
        AND extract(day from dob) = {day};
    """
    rows = connect(query2)
    heads = ['Full DOB', 'Goat Tag', 'Sex']
    return render_template('my-result.html', rows=rows, heads=heads)

#  Show all kids belonging to a specfic sire PROGENY REPORT
@app.route('/query4-handler', methods=['POST'])
def query4_handler(): 
    sire_tag = request.form['sire_tag']
    checkbox_value = request.form.get('checkbox')
    if checkbox_value: # show weights
        query4 = f""" 
            select sire, goat_tag, dob, bwt 
            from goats natural join sires natural join birth_weights
            where sire = '{sire_tag}';
         """
        check = True
    else: #dont show weights
        query4 = f""" 
            select sire, goat_tag, dob 
            from goats natural join sires 
            where sire = '{sire_tag}';
         """
        check = False

    rows = connect(query4)

    if check:
        heads = ['Sire Tag', 'Goat Tag', 'DOB', 'Birth Weight']
    else:
        heads = ['Sire Tag', 'Goat Tag', 'DOB'] 

    return render_template('my-result.html', rows=rows, heads=heads)

# select * from goats natural join birth_weights where bwt > 7;
@app.route('/query5-handler', methods=['POST'])
def query5_handler():
    weight = float(request.form['weight'])
    query5 = f""" 
        select goat_tag, dob, dam_tag, sex, bwt 
        from goats natural join birth_weights 
        where bwt > {weight};
    """
    rows = connect(query5)
    heads = ['Goat Tag', 'DOB', 'Dam Tag', 'Sex', 'Birth Weight']
    return render_template('my-result.html', rows=rows, heads=heads)

#select dam_tag, AVG(bwt) from goats natural join birth_weights where bwt >= 7.0 AND bwt <= 8.0 group by dam_tag;
@app.route('/query6-handler', methods=['POST'])
def query6_handler():
    weight_low = float(request.form['weight_low'])
    weight_high = float(request.form['weight_high'])
    query6 = f""" 
        select dam_tag, AVG(bwt) 
        from goats natural join birth_weights 
        where bwt >= {weight_low} AND bwt <= {weight_high} 
        group by dam_tag;
    """
    rows = connect(query6)
    heads = ['Dam Tag', 'Average Weight']
    return render_template('my-result.html', rows=rows, heads=heads)

@app.route('/query7-handler', methods=['POST'])
def query7_handler():
    start_date= request.form['start_date']
    end_date = request.form['end_date']
    query7= f"""
        Select dob, goat_tag, bwt, dam_tag from (
        select * 
        from goats natural join birth_weights 
        where dob BETWEEN  '{start_date}'
        AND '{end_date}'
    ) AS query7;
    """ 
    rows = connect(query7)
    heads = ['DOB', 'Goat Tag', 'Birth Weight', 'Dam Tag']
    return render_template('my-result.html', rows=rows, heads=heads)

# select * from goats natural join birth_weights where bwt = 7;
# find goat of specfic weight
@app.route('/query8-handler', methods=['POST'])
def query8_handler():
    weight = float(request.form['weight'])
    query8 = f""" 
        select goat_tag, dob, dam_tag, sex, bwt 
        from goats natural join birth_weights 
        where bwt = {weight};
    """
    rows = connect(query8)
    heads = ['Goat Tag', 'DOB', 'Dam Tag', 'Sex', 'Birth Weight']
    return render_template('my-result.html', rows=rows, heads=heads)

# select * from goats natural join birth_weights where bwt < 7; 
# find goat of specfic weight range
@app.route('/query9-handler', methods=['POST'])
def query9_handler():
    weight_low = float(request.form['weight_low'])
    weight_high = float(request.form['weight_high'])
    query9 = f""" 
        select goat_tag, dob, dam_tag, sex, bwt 
        from goats natural join birth_weights 
        where bwt >= {weight_low} AND bwt <= {weight_high};
    """
    rows = connect(query9)
    heads = ['Goat Tag', 'DOB', 'Dam Tag', 'Sex', 'Birth Weight']
    return render_template('my-result.html', rows=rows, heads=heads)

#Query 10 - Stats on particular days of the year
@app.route('/query10-handler', methods=['POST'])
def query10_handler():
    input_month = float(request.form['input_month'])
    input_year = float(request.form['input_year'])
    query10 = f""" 
        SELECT
            COUNT(g.eid_tag) AS total_kids,
            AVG(b.bwt) AS avg_birth_weight, 
            SUM(CASE WHEN g.goat_tag LIKE '%DOA%' OR g.goat_tag LIKE '%DWOT%' THEN 1 ELSE 0 END) AS total_stillborns, 
            date(g.dob)
        FROM 
            birth_weights AS b
        NATURAL JOIN 
            goats AS g
        WHERE EXTRACT(MONTH FROM g.dob) = {input_month} 
        AND EXTRACT(YEAR FROM g.dob) = {input_year} 
        GROUP BY date(dob);
    """
    rows = connect(query10)
    heads = ['Total Kids', 'Average Birth Weight', 'Total Still Borns', 'Date']
    return render_template('my-result.html', rows=rows, heads=heads)


if __name__ == '__main__':
    app.run(debug = True)