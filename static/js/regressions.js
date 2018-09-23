
function populateTable(parameters, response, model) {

    var url4 = `/regression/mrs/${parameters}/${response}`;
    d3.json(url4).then(function (data) {
        var fields = Object.keys(data);
        var i;

        // Populate table fields
        for (i=0;i<fields.length;i++) {
            if (document.getElementById(fields[i]) != null) {
                document.getElementById(fields[i]).innerHTML = data[fields[i]];
            };
            // Populate Dep. Variable field with proper name
            if (fields[i] == "Dep. Variable") {
                document.getElementById(fields[i]).innerHTML = regrColumns[response];
            };
            if (fields[i] == "Parameters") {
                // Remove any previously added parameters
                d3.select("tbody")
                .selectAll("tr.params")
                .remove();

                // Since this is an existing table add rows using a different class
                d3.select("tbody")
                    .selectAll("tr.params")
                    .data(data[fields[i]])
                    .enter()
                    .append("tr")
                    .attr('class', 'params')
                    .html(function (d) {
                        return `<td>${d.params}</td><td>${d.coef}</td><td>${d.std_err}</td>
                            <td>${d.t_values}</td><td>${d.p_values}</td><td>${d.low_conf}</td>
                            <td>${d.upp_conf}</td>`;
                    });
            };
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