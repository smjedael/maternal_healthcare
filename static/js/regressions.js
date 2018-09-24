
function populateTable(parameters, response, model) {
    // Clear table of existing values
    clearTable(regrTblFields);

    //Build parameter string
    var paramString = parameters[0];

    for (var i=1;i<parameters.length;i++){
        paramString = paramString + '&' + parameters[i];
    }

    var url4 = `/regression/${model}/${paramString}/${response}`;
    d3.json(url4).then(function (data) {
        var fields = Object.keys(data);

        // Populate table fields
        for (var i=0;i<fields.length;i++) {
            if (document.getElementById(fields[i]) != null) {
                document.getElementById(fields[i]).innerHTML = data[fields[i]];
            }
            // Populate Dep. Variable field with proper name
            if (fields[i] == "Dep. Variable") {
                document.getElementById(fields[i]).innerHTML = summaryColumns[response];
                console.log(summaryColumns[response]);
            }
            if (fields[i] == "Param. Headers") {
                // Remove any previously added parameters
                d3.select("tbody")
                    .selectAll("tr.headers")
                    .remove();

                // Since this is an existing table add rows using a different class
                d3.select("tbody")
                    .selectAll("tr.headers")
                    .data(data[fields[i]])
                    .enter()
                    .append("tr")
                    .attr('class', 'headers')
                    .html(function (d) {
                        return `<td><b>${d.params}</b></td><td><b>${d.coef}</b></td><td><b>${d.std_err}</b></td>
                            <td><b>${d.t_values}</b></td><td><b>${d.p_values}</b></td><td><b>${d.low_conf}</b></td>
                            <td><b>${d.upp_conf}</b></td>`;
                    });
            }
            if (fields[i] == "Param. Values") {
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
                        return `<td>${summaryColumns[d.params]}</td><td>${d.coef}</td><td>${d.std_err}</td>
                            <td>${d.t_values}</td><td>${d.p_values}</td><td>${d.low_conf}</td>
                            <td>${d.upp_conf}</td>`;
                    });
            }
            console.log(data[fields[i]]);
        }
    });

    const dataPromise4 = d3.json(url4);
    console.log("Data Promise: ", dataPromise4);
}

function clearTable(fields) {
    console.log(fields);
    for (var i=0; i<fields.length;i++){
        if (document.getElementById(fields[i]) != null) {
            document.getElementById(fields[i]).innerHTML = "";
        }
    }
}

function getMultipleSelectedValue(id) {
    var x = document.getElementById(id);
    var optionArray = [];
    for (var i = 0; i < x.length; i++) {
        if (x.options[i].selected == true) optionArray.push(x.options[i].value);
    }
    return optionArray;
    
}

function handleSubmit() {
    d3.event.preventDefault();
    //var parameters = document.getElementById("parameters").value;
    var parameters = getMultipleSelectedValue("parameters");
    var response = document.getElementById("response").value;
    var regrModel = document.getElementById("regrModel").value;
    populateTable(parameters, response, regrModel);
}

// Add event listener for regression button
d3.select("#regrButton").on("click", handleSubmit);