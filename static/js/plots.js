
function init() {
    // Initialize Race Comparison Group Bar Chart
    buildCompCharts("total_maternal_deaths");
    buildScatterPlot("total_risk_factors", "total_morbidity_count");
}

function buildScatterPlot(xvalue, yvalue) {
    // Build Linearity Check Scatter Plot
    var url0 = `/plots/scatter/${xvalue}/${yvalue}`;
    console.log(url0);
    d3.json(url0).then(function (data) {
        var layout = {
            title: `<b>${summaryColumns[xvalue]} vs. ${summaryColumns[yvalue]}`,
            color: "blue",
            autosize: true,
            xaxis: {
                title: `${summaryColumns[xvalue]}`
            },
            yaxis: {
                title: `${summaryColumns[yvalue]}`
            }
        };
        var SCTR = document.getElementById("scatterPlot");
        Plotly.newPlot(SCTR, data, layout);
    });

    // Promise Pending
    const dataPromise0 = d3.json(url0);
    console.log("Data Promise: ", dataPromise0);
}

function buildCompCharts(factor){
    // Build Race Comparison Group Bar Chart
    var url1 = `/plots/race/groupbar/${factor}`;
    d3.json(url1).then(function (data) {

        var layout = {
            title: `<b>${summaryColumns[factor]} per Year, per 10,000 Births (2009-2016)</b>`,
            autosize: true,
            xaxis: {
                title: "Year"
            },
            yaxis: {
                title: "Occurrences per 10,000 Births"
            }
        };
        var GBAR = document.getElementById("groupBar1");
        Plotly.newPlot(GBAR, data, layout);
    });

    // Build Race Comparison Pie Charts
    var url2 = `/plots/race/pie/${factor}`;
    d3.json(url2).then(function (data) {
        var races = Object.keys(data);
        var i;
        for (i = 0; i < races.length; i++) {
            var layout = {
                title: `<b>${races[i]}</b><br>${summaryColumns[factor]}<br>(2009-2016)`,
                autosize: true
            };
            var PIE = document.getElementById(`pie${i}`);
            Plotly.newPlot(PIE, data[races[i]], layout);
        };
    });
    
    // Promise Pending
    const dataPromise1 = d3.json(url1);
    const dataPromise2 = d3.json(url2);
    console.log("Data Promise: ", dataPromise1);
    console.log("Data Promise: ", dataPromise2);
   
}

function populateTable(xvalues, yvalue, type){
    var url4 = `/regression/mrs/${xvalues}/${yvalue}/${type}`;
    d3.json(url4).then(function (data) {
        var myTable = document.getElementById('myTable');
        myTable.rows[0].cells[1].innerHTML = 'Hello';
       
    });
    
    const dataPromise4 = d3.json(url4);
    console.log("Data Promise: ", dataPromise4);
}

function handleSubmit(){
    d3.event.preventDefault();
    var xvalue = document.getElementById("xRiskFactor").value;
    console.log(xvalue);
    var yvalue = document.getElementById("yRiskFactor").value;
    console.log(yvalue);
    buildScatterPlot(xvalue, yvalue);
}

init();

// Add event listener for plot button
d3.select("#plotButton").on("click", handleSubmit);



