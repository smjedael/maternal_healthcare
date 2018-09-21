function init() {
    var url = "/plots/race/groupbar/total_maternal_deaths";
    d3.json(url).then(function(data) {

        var layout = {
            title: "Maternal Deaths by Race per Year, per 10,000 Births (2009-2016)",
            autosize: true,
            xaxis: {
                title: "Year"
            },
            yaxis: {
                title: "Occurrences per 10,000 Births"
            }
        };
        var GBAR = document.getElementById("groupBar1");
        Plotly.plot(GBAR, data, layout);

    }); 
}

function getData(factor){
    var url = `/plots/race/groupbar/${factor}`;
    d3.json(url).then(function (data) {

        var layout = {
            title: `${raceCompColumns[factor]} per Year, per 10,000 Births (2009-2016)`,
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
    
    // Promise Pending
    const dataPromise = d3.json(url);
    console.log("Data Promise: ", dataPromise);
}


init();

