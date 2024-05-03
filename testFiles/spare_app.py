# Queries Taken out of app.py Brielle

# select * from mult_kids where mult_births >= 5;
# query that will show dams who have had multiple births >= to input
@app.route('/query3-handler', methods=['POST'])
def query3_handler():
    num_multiples = request.form['multi_births']
    query3 = f""" 
        select * 
        from mult_kids 
        where mult_births >= {num_multiples};
    """
    rows = connect(query3)
    heads = ['Dam ID', 'Number of Kids']
    return render_template('my-result.html', rows=rows, heads=heads)

# Shows all Kids of a Dam PROGENY REPORT w/o Weights
@app.route('/query1-handler', methods=['POST'])
def goat_handler():
    dam_tag = request.form['dam_tag']  # Get the dam_tag value from the form
    query1 = f"""SELECT goat_tag, sex, dob 
                FROM goats 
                WHERE dam_tag = '{dam_tag}'"""
    rows = connect(query1)  # Ensure dam_tag is enclosed in quotes
    heads = ['Goat Tag', 'Sex', 'DOB']
    return render_template('my-result.html', rows=rows, heads=heads)

# Shows all Kids of a Dam PROGENY REPORT w/weights
@app.route('/query1-handler', methods=['POST'])
def goat_handler():
    dam_tag = request.form['dam_tag']  # Get the dam_tag value from the form
    query1 = f"""SELECT goat_tag, sex, dob 
                FROM goats natural join birth_weights 
                WHERE dam_tag = '{dam_tag}'"""
    rows = connect(query1)  # Ensure dam_tag is enclosed in quotes
    heads = ['Goat Tag', 'Sex', 'DOB']
    return render_template('my-result.html', rows=rows, heads=heads)