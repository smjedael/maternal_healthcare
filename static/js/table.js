var Regression = [{
"AIC":-356407.7687,"Adj. R-Squared":0.0028,"BIC":-356386.6836,
"Coefficient":[0.0167,0.0068],"Covariance Type":"nonrobust",
"Date":"Fri, 21 Sep 2018","Dep. Variable":"prepregnancy_hypertension",
"Df Model":1.0,"Df Residuals":279998.0,"F-statistic":798.9069,"Log-Likelihood":178205.8844,
"Lower Confidence":[0.0162,0.0064],"Method":"Least Squares","Model":"OLS","No. Observations":280000.0,
"P-Values":[0.0,0.0],"Parameters":["const","race_black"],"Prob (F-statistic)":0.0,"R-Squared":0.0028,
"Standard Error":[0.0002,0.0002],"T-Values":[69.1026,28.2649],"Time":"22:16:55","Upper Confidence":[0.0172,0.0073]}
];



d3.select("tbody")
  .selectAll("tr")
  .data(Regression)
  .enter()
  .append("tr")
  .html(function(d) {
    return `<td>${d.AIC}</td>
    <td>${d.AdjRSquared}</td
    ><td>${d.bic}</td>
    <td>${d.Coefficient}</td>
    <td>${d.CovarianceType}</td>
    <td>${d.Date}</td>
    <td>${d.DepVariable}</td>
    <td>${d.BIC}</td>
    <td>${d.BIC}</td>
    <td>${d.BIC}</td>
    <td>${d.BIC}</td>
    <td>${d.BIC}</td>
    <td>${d.BIC}</td>
    <td>${d.BIC}</td>`;
  });
