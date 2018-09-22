
function populateTable(parameters, response, model) {

    var url4 = `/regression/mrs/${parameters}/${response}`;
    d3.json(url4).then(function (data) {
        var fields = Object.keys(data);
        var i;

        // Populate standard fields first
        for (i=0;i<fields.length;i++) {
            if (document.getElementById(fields[i]) != null) {
                document.getElementById(fields[i]).innerHTML = data[fields[i]];
            };
            // Populate Dep. Variable field with proper name
            if (fields[i] == "Dep. Variable") {
                document.getElementById(fields[i]).innerHTML = regrColumns[response];
            }
            console.log(data[fields[i]]);
        };
    });

    const dataPromise4 = d3.json(url4);
    console.log("Data Promise: ", dataPromise4);
}

function handleSubmit() {
    d3.event.preventDefault();
    var parameters = document.getElementById("parameters").value;
    console.log(parameters);
    var response = document.getElementById("response").value;
    console.log(response);
    var regrModel = document.getElementById("regrModel").value;
    console.log(response);
    populateTable(parameters, response, regrModel);
}

// Add event listener for regression button
d3.select("#regrButton").on("click", handleSubmit);