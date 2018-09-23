import os

import pandas as pd
import numpy as np

from datetime import datetime

import statsmodels.api as sm
from sklearn.preprocessing import StandardScaler

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine

from flask import Flask, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)


#################################################
# Database Setup
#################################################

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///db/maternal_health.sqlite"
db = SQLAlchemy(app)

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(db.engine, reflect=True)

#################################################
# Dataframe Setup
#################################################

# Save references to each table
tbl_mma = Base.classes.maternal_mortality_all
tbl_mms = Base.classes.maternal_mortality_summary
tbl_mrs = Base.classes.maternity_random_sample
tbl_ms = Base.classes.maternity_summary
tbl_ufcs = Base.classes.us_female_census_summary

# Create dataframes for each table
stmt = db.session.query(tbl_mma).statement
df_mma = pd.read_sql_query(stmt, db.session.bind)

stmt = db.session.query(tbl_mms).statement
df_mms = pd.read_sql_query(stmt, db.session.bind)

stmt = db.session.query(tbl_ms).statement
df_ms = pd.read_sql_query(stmt, db.session.bind)

stmt = db.session.query(tbl_mrs).statement
df_mrs = pd.read_sql_query(stmt, db.session.bind)

stmt = db.session.query(tbl_ufcs).statement
df_ufcs = pd.read_sql_query(stmt, db.session.bind)

# Rebuild df_ufcs table
df_ufcs_white_nh = df_ufcs[['year', 'age_cohort', 'white_nh', ]]
df_ufcs_hispanic = df_ufcs[['year', 'age_cohort', 'hispanic', ]]
df_ufcs_black = df_ufcs[['year', 'age_cohort', 'black', ]]
df_ufcs_ai_an = df_ufcs[['year', 'age_cohort', 'ai_an', ]]
df_ufcs_asian_pi = df_ufcs[['year', 'age_cohort', 'asian_pi', ]]

df_ufcs_white_nh.rename(columns={'white_nh': 'female_pop'}, inplace=True)
df_ufcs_hispanic.rename(columns={'hispanic': 'female_pop'}, inplace=True)
df_ufcs_black.rename(columns={'black': 'female_pop'}, inplace=True)
df_ufcs_ai_an.rename(columns={'ai_an': 'female_pop'}, inplace=True)
df_ufcs_asian_pi.rename(columns={'asian_pi': 'female_pop'}, inplace=True)

df_ufcs_white_nh['race'] = 'White, Non-Hispanic'
df_ufcs_hispanic['race'] = 'Hispanic'
df_ufcs_black['race'] = 'Black'
df_ufcs_ai_an['race'] = 'American Indian/Alaskan Native'
df_ufcs_asian_pi['race'] = 'Asian/Pacific Islander'

df_ufcs_new = df_ufcs_hispanic.append(df_ufcs_white_nh)
df_ufcs_new = df_ufcs_new.append(df_ufcs_black)
df_ufcs_new = df_ufcs_new.append(df_ufcs_ai_an)
df_ufcs_new = df_ufcs_new.append(df_ufcs_asian_pi)

# Merge rebuilt df_ufcs_new table to df_ms and df_mms

df_master = pd.merge(df_ufcs_new, df_ms, on=[
                     'year', 'race', 'age_cohort'], how='left')
df_master = pd.merge(df_master, df_mms, on=[
                     'year', 'race', 'age_cohort'], how='left')

# Scrap temporary dataframes
del df_ufcs_white_nh
del df_ufcs_hispanic
del df_ufcs_black
del df_ufcs_ai_an
del df_ufcs_asian_pi
del df_ufcs_new

###################################################
# Other Global Variables
###################################################

races = ('American Indian/Alaskan Native', 
        'Asian/Pacific Islander', 'Black', 
        'Hispanic', 'White, Non-Hispanic')


###################################################
# Route Setup
###################################################

# Standard webpage routes
@app.route("/")
def index():
    """Return the homepage."""
    return render_template("index.html")


@app.route("/plt-matmortality/")
def plt_matmortality_page():
    """Return the Plot - Maternal Mortality page."""
    return render_template("plt-matmortality.html")


@app.route("/comp-matmortality/")
def comp_matmortality_page():
    """Return the Comparison - Maternal Mortality page."""
    return render_template("comp-matmortality.html")


@app.route("/regr-matmortality/")
def regression_page():
    """Return the Regression Analysis page."""
    return render_template("regr-matmortality.html")


@app.route("/data/")
def data_page():
    """Return the Data page."""
    return render_template("data.html")

# Special Function Routes
@app.route("/regression/mrs/<predictors>/<response>")
# Need to look into being able to filter the table
def performRegression(predictors, response):
    # Perform Multivariate Regression
    scale = StandardScaler()
        
    # Here we have 2 variables for multiple regression. If you just want to use one variable for simple linear regression,
    #then use X = df['Interest_Rate'] for example. Alternatively, you may add additional variables within the brackets.
    
    column_list = predictors.split('&')

    X = df_mrs[column_list]
    Y = df_mrs[response]

    X[column_list] = scale.fit_transform(X[column_list].as_matrix())

    est = sm.OLS(Y, sm.add_constant(X)).fit()

    # Add standard fields to the dictionary
    regression_results = {}
    regression_results['Dep. Variable'] = response
    regression_results['Model'] = 'OLS'
    regression_results['Method'] = 'Least Squares'
    regression_results['Date'] = datetime.now().strftime('%a, %d %b %Y')
    regression_results['Time'] = datetime.now().strftime('%H:%M:%S')
    regression_results['No. Observations'] = np.around(est.nobs, 0)
    regression_results['Df Residuals'] = np.around(est.df_resid, 0)
    regression_results['Df Model'] = est.df_model
    regression_results['Covariance Type'] = est.cov_type
    regression_results['R-Squared'] = np.around(est.rsquared, 4)
    regression_results['Adj. R-Squared'] = np.around(est.rsquared_adj, 4)
    regression_results['F-statistic'] = np.around(est.fvalue, 4)
    regression_results['Prob (F-statistic)'] = np.around(est.f_pvalue, 4)
    regression_results['Log-Likelihood'] = np.around(est.llf, 4)
    regression_results['AIC'] = np.around(est.aic, 4)
    regression_results['BIC'] = np.around(est.bic, 4)

    # Add custom parameters as array of dictionaries
    params = []
    coef = []
    std_err = []
    t_values = []
    p_values = []
    low_conf = []
    upp_conf = []
    conf_int = est.conf_int().T
    parameters = []

    # OLDER VERSION
    #for i in range(len(est.params)):
    #    params.append(est.params.index[i])
    #    coef.append(np.around(est.params[i], 4))
    #    std_err.append(np.around(est.bse[i], 4))
    #    t_values.append(np.around(est.tvalues[i], 4))
    #    p_values.append(np.around(est.pvalues[i], 4))
    #    low_conf.append(np.around(conf_int.iloc[0, i], 4))
    #    upp_conf.append(np.around(conf_int.iloc[1, i], 4))
    #regression_results['Parameters'] = params
    #regression_results['Coefficient'] = coef
    #regression_results['Standard Error'] = std_err
    #regression_results['T-Values'] = t_values
    #regression_results['P-Values'] = p_values
    #regression_results['Lower Confidence'] = low_conf
    #regression_results['Upper Confidence'] = upp_conf

    for i in range(len(est.params)):
        parameter = {}
        parameter['params'] = est.params.index[i]
        parameter['coef'] = np.around(est.params[i], 4)
        parameter['std_err'] = np.around(est.bse[i], 4)
        parameter['t_values'] = np.around(est.tvalues[i], 4)
        parameter['p_values'] = np.around(est.pvalues[i], 4)
        parameter['low_conf'] = np.around(conf_int.iloc[0, i], 4)
        parameter['upp_conf'] = np.around(conf_int.iloc[1, i], 4)
        parameters.append(parameter)
    
    regression_results['Parameters'] = parameters    

    return jsonify(regression_results)

@app.route("/plots/scatter/<xvalue>/<yvalue>")
def scatterData(xvalue,yvalue):
    chart_data = []
    dv = df_master[[xvalue,yvalue]].dropna()
    trace = {'x':dv[xvalue].tolist(),
             'y':dv[yvalue].tolist(),
             'mode': 'markers',
             'type': 'scatter'
            }
    chart_data.append(trace)

    return jsonify(chart_data)


@app.route("/plots/race/groupbar/<factor>")
def groupBarData(factor):
    chart_data = []
    df_group = df_master.groupby([df_master.race, df_master.year])
    
    dv = np.around((df_group[factor].sum()/df_group['total_births'].sum())*10000, 2)
    
    for race in races:
        trace = {'x':dv[race].index.tolist(),
                 'y':dv[race].tolist(),
                 'name':race,
                 'type':'bar'
                }
        chart_data.append(trace)

    return jsonify(chart_data)


@app.route("/plots/race/pie/<factor>")
def pieData(factor):
    chart_data = {}
    df_group = df_master.groupby([df_master.race, df_master.age_cohort])
    dv = np.around(df_group[factor].sum(), 2)

    for race in races:
        trace = {'labels': dv[race].index.tolist(),
                 'values': dv[race].tolist(),
                 'type': 'pie',
                 'sort': False,
                 'direction': 'clockwise'
                 }
        chart_data[race] = [trace]

    return jsonify(chart_data)

if __name__ == "__main__":
    app.run()
