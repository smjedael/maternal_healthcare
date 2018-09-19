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

# Save references to each table
tbl_prm = Base.classes.pregnancy_related_mortality
tbl_ms = Base.classes.maternity_summary
tbl_mms = Base.classes.maternal_mortality_summary
tbl_mrs = Base.classes.maternity_random_sample
tbl_ufcs = Base.classes.us_female_census_summary

# Create dataframes for each table
stmt = db.session.query(tbl_prm).statement
df_prm = pd.read_sql_query(stmt, db.session.bind)

stmt = db.session.query(tbl_ms).statement
df_ms = pd.read_sql_query(stmt, db.session.bind)

stmt = db.session.query(tbl_mms).statement
df_mms = pd.read_sql_query(stmt, db.session.bind)

stmt = db.session.query(tbl_mrs).statement
df_mrs = pd.read_sql_query(stmt, db.session.bind)

stmt = db.session.query(tbl_ufcs).statement
df_ufcs = pd.read_sql_query(stmt, db.session.bind)



@app.route("/")
def index():
    """Return the homepage."""
    return render_template("index.html")


@app.route("/plt-matmorbidity/")
def plt_matmorbidity_page():
    """Return the Plot - Maternal Morbidity page."""
    return render_template("plt-matmorbidity.html")


@app.route("/plt-matmortality/")
def plt_matmortality_page():
    """Return the Plot - Maternal Mortality page."""
    return render_template("plt-matmortality.html")


@app.route("/comp-matmorbidity/")
def comp_matmorbidity_page():
    """Return the Comparison - Maternal Morbidity page."""
    return render_template("comp-matmorbidity.html")


@app.route("/comp-matmortality/")
def comp_matmortality_page():
    """Return the Comparison - Maternal Mortality page."""
    return render_template("comp-matmortality.html")


@app.route("/regression/")
def regression_page():
    """Return the Regression Analysis page."""
    return render_template("regression.html")


@app.route("/data/")
def data_page():
    """Return the Data page."""
    return render_template("data.html")


@app.route("/regression/<dataframe>/<predictors>/<response>")
# Need to look into being able to filter the table
def perform_regression(dataframe, predictors, response):
    # Perform Multivariate Regression
    scale = StandardScaler()
    df = dataframe

    # Here we have 2 variables for multiple regression. If you just want to use one variable for simple linear regression,
    #then use X = df['Interest_Rate'] for example. Alternatively, you may add additional variables within the brackets.

    column_list = predictors.split('&')

    X = df[column_list]
    Y = df[response]

    X[column_list] = scale.fit_transform(X[column_list].as_matrix())

    est = sm.OLS(Y, X).fit()

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

    params = []
    coef = []
    std_err = []
    t_values = []
    p_values = []
    low_conf = []
    upp_conf = []
    conf_int = est.conf_int().T

    for i in range(len(est.params)):
        params.append(est.params.index[i])
        coef.append(np.around(est.params[i], 4))
        std_err.append(np.around(est.bse[i], 4))
        t_values.append(np.around(est.tvalues[i], 4))
        p_values.append(np.around(est.pvalues[i], 4))
        low_conf.append(np.around(conf_int.iloc[0, i], 4))
        upp_conf.append(np.around(conf_int.iloc[1, i], 4))

    regression_results['Parameters'] = params
    regression_results['Coefficient'] = coef
    regression_results['Standard Error'] = std_err
    regression_results['T-Values'] = t_values
    regression_results['P-Values'] = p_values
    regression_results['Lower Confidence'] = low_conf
    regression_results['Upper Confidence'] = upp_conf

    return jsonify(regression_results)


@app.route("/plots/scatter/<dataframe>/<xValue>/<yValue>/<xAxisLabel>/<yAxisLabel>")
def plt_scatter(dataframe, xValue, yValue, xAxisLabel, yAxisLabel):
    df = dataframe
    results = {}
    return jsonify(results)


if __name__ == "__main__":
    app.run()
