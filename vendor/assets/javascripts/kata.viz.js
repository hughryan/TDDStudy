function createHiveData(red, green, blue) {
  if (blue == 0 || isNaN(blue)) {
    blue = 0.001;
  }
  if (red == 0 || isNaN(red)) {
    red = 0.001;
  }
  if (green == 0 || isNaN(green)) {
    green = 0.001;
  }

  var data = [{
    source: {
      x: 0,
      y0: 0.0,
      y1: red
    },
    target: {
      x: 1,
      y0: 0.0,
      y1: red
    },
    group: 3
  }, {
    source: {
      x: 1,
      y0: 0.0,
      y1: green
    },
    target: {
      x: 2,
      y0: 0.0,
      y1: green
    },
    group: 7
  }, {
    source: {
      x: 2,
      y0: 0.0,
      y1: blue
    },
    target: {
      x: 0,
      y0: 0.0,
      y1: blue
    },
    group: 11
  }];
  return data;
}

function pageSetup() {
  $(function() {

  //   $("#accordion").accordion({
  //     heightStyle: "fill"
  //   });

    $.ajax({
      url: "/viz/retrieve_session",
      dataType: 'json',
      data: {
        'start': 2,
        'end': 4,
        'cyberdojo_id': gon.cyberdojo_id,
        'cyberdojo_avatar': gon.cyberdojo_avatar
      },
      success: function(data) {
        populateAccordion(data);
      },
      error: function() {
        console.error("AJAX");
      },
      type: 'GET'
    });
  });
}



function buildpulseChart(TDDData) {
  // var metrics = mapPulseArrayToMetrics(TDDPulse, metricFunction);
  var my_pulsePlot =
    pulsePlot()
    .width(100)
    .height(100)
    .innerRadius(10)
    .outerRadius(50);

  $('#PulseAreaDetail').append("<div class='pulseChart' id='pulse'></div>");
  var data = createHiveData(TDDData[0].red, TDDData[0].green, TDDData[0].blue);
  d3.select("#pulse")
    .datum(data)
    .call(my_pulsePlot);

  // TDDPulse.forEach(function(pulse, index){
  //                       $('#PulseAreaDetail').append("<div class='pulseChart' id='pulse" + index + "'></div>");
  //                       var data = createHiveData(metrics[index].red,metrics[index].green,metrics[index].blue);
  //                       d3.select("#pulse" + index + "")
  //                       .datum(TDDData[0])
  //                       .call(my_pulsePlot);
  // // });

  // var my_pulsePlotSummary =
  // pulsePlot()
  // .width(350)
  // .height(350)
  // .innerRadius(30)
  // .outerRadius(175);

  // $('#PulseAreaSummary').append("<div class='pulseChart' id='pulseAll'></div>");
  // var dataAll = createAggHiveData(metrics);
  // d3.select("#pulseAll")
  // .datum(dataAll)
  // .call(my_pulsePlotSummary);

}



function brushended() {

  if (!d3.event.sourceEvent) return; // only transition after input
  console.log("BRUSH_END")
  var extent0 = brush.extent();


  var extent1 = extent0;
  extent1[0] = Math.round(extent0[0]);
  extent1[1] = Math.round(extent0[1]);

  // console.log(extent0)
  console.log(extent1[0]);
  console.log(extent1[1]);
  var start = extent1[0];
  var end = extent1[1];

  $.ajax({
    url: "/viz/retrieve_session",
    dataType: 'json',
    data: {
      'start': start,
      'end': end,
      'cyberdojo_id': gon.cyberdojo_id,
      'cyberdojo_avatar': gon.cyberdojo_avatar
    },
    success: function(data) {
      populateAccordion(data);
    },
    error: function() {
      console.error("AJAX");
    },
    type: 'GET'
  });


  d3.select(this).transition()
    .call(brush.extent(extent1))
    .call(brush.event);
}

function TDDColor(color) {
  if (color == "red") {
    return "#af292e";
  } else if (color == "green") {
    return "#4e7300";
  } else if (color == "blue") {
    return "#385e86";
  } else if (color == "amber") {
    return "orange";
  } else if (color == "white") {
    return "#efefef";
  }

}



function drawUncatagorizedKata() {

  // console.log(gon.compiles);

  phaseHeight = 50;
  var lineHeight = 90;
  margin = {
      top: 20,
      right: 20,
      bottom: 30,
      left: 10
    },
    width = $(window).width() - margin.left - margin.right,
    height = 100 - margin.top - margin.bottom;

  var barHeight = 50,
    color = d3.scale.category20c();

  x = d3.scale.linear()
    .domain([0, compiles.length])
    .range([1, width - 40]);

  brush = d3.svg.brush()
    .x(x)
    .extent([3, 5])
    .on("brushend", brushended);

  var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

  chart = d3.select(".chart")
    .attr("width", width)
    .attr("height", barHeight * 3);


  // Draw Line for compile points
  var myLine = chart.append("svg:line")
    .attr("x1", margin.left)
    .attr("y1", lineHeight)
    .attr("x2", function(d, i) {
      return x(compiles.length) + 5;
    })
    .attr("y2", lineHeight)
    .style("stroke", "#737373")
    .style("stroke-width", "1");

  // Draw left start line
  var startLine = chart.append("svg:line")
    .attr("x1", margin.left + 1)
    .attr("y1", lineHeight - 6)
    .attr("x2", margin.left + 1)
    .attr("y2", lineHeight + 6)
    .style("stroke", "#737373");


  //Draw phase bars
  phaseBars = chart.selectAll("f")
    .data(phaseData)
    .enter().append("rect")
    .attr("x", function(d, i) {
      return x(d.first_compile_in_phase - 1);
    })
    .attr("y", phaseHeight)
    .attr("width",
      function(d, i) {
        if (d.last_compile_in_phase == compiles.length) {
          return x(d.last_compile_in_phase - d.first_compile_in_phase + 1);
        } else {
          return x(d.last_compile_in_phase - d.first_compile_in_phase + 2);
        }
      })
    .attr("height", 10)
    .attr("stroke", "grey")
    .attr("fill",
      function(d) {
        return TDDColor(d.tdd_color);
      })
    .attr("transform", "translate(" + margin.left + ",10)");



  //Draw Compile Points
  var bar = chart.selectAll("g")
    .data(data)
    .enter().append("g");

  bar.append("circle")
    .attr("cx", function(d, i) {
      return x(d.git_tag);
    })
    .attr("r", 4)
    .attr("transform", "translate(" + margin.left + "," + lineHeight + ")")
    .attr("fill", function(d) {
      return TDDColor(d.light_color);
    })
    .attr("stroke-width", 2);

  var currTDDBar = chart.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(" + margin.left + ",110)")
    .call(xAxis)
    .selectAll("text")
    .attr("y", 6)
    .attr("height", 10)
    // .attr("x", 6)
    .style("text-anchor", "start")
    .style("font-size", "16px");



  var gBrush = chart.append("g")
    .attr("class", "brush")
    .call(brush)
    .call(brush.event);

  gBrush.selectAll("rect")
    .attr("height", 51)
    .attr("transform", "translate(" + margin.left + ",59)");



  //DRAW handcoded phases

  // chart.selectAll("h")
  //     .data(cycles)
  //     .enter().append("rect")
  //     .attr("x", function(d, i) {
  //       return x(d.startCompile - 1);
  //     })
  //     .attr("y", 20)
  //     .attr("width",
  //       function(d, i) {
  //         return x(d.endCompile - d.startCompile + 1);
  //       })
  //     .attr("height", 40)
  //     .attr("rx", 6)
  //     .attr("ry", 6)
  //     .attr("stroke", "grey")
  //     .attr("fill", function(d) {
  //       if (d.valid_tdd == true) {
  //         return "#BABABA";
  //       }
  //       if (d.valid_tdd == false) {
  //         return "#6F6F6F";
  //       }

  //     })
  //     .attr("transform", "translate(" + margin.left + ",-10)");



}



function drawKataViz() {

  // console.log(gon.compiles);

  var phaseHeight = 50;
  var lineHeight = 90;
  var margin = {
      top: 20,
      right: 20,
      bottom: 30,
      left: 10
    },
    width = $(window).width() - margin.left - margin.right,
    height = 100 - margin.top - margin.bottom;

  var barHeight = 50,
    color = d3.scale.category20c();

  var x = d3.scale.linear()
    .domain([0, compiles.length])
    .range([1, width - 40]);

  brush = d3.svg.brush()
    .x(x)
    .extent([3, 5])
    .on("brushend", brushended);

  var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

  var chart = d3.select(".chart")
    .attr("width", width)
    .attr("height", barHeight * 3);


  // Draw Line for compile points
  var myLine = chart.append("svg:line")
    .attr("x1", margin.left)
    .attr("y1", lineHeight)
    .attr("x2", function(d, i) {
      return x(compiles.length) + 5;
    })
    .attr("y2", lineHeight)
    .style("stroke", "#737373")
    .style("stroke-width", "1");

  // Draw left start line
  var startLine = chart.append("svg:line")
    .attr("x1", margin.left + 1)
    .attr("y1", lineHeight - 6)
    .attr("x2", margin.left + 1)
    .attr("y2", lineHeight + 6)
    .style("stroke", "#737373");


  //Draw phase bars
  chart.selectAll("f")
    .data(phaseData)
    .enter().append("rect")
    .attr("x", function(d, i) {
      return x(d.first_compile_in_phase - 1);
    })
    .attr("y", phaseHeight)
    .attr("width",
      function(d, i) {
        if (d.last_compile_in_phase == compiles.length) {
          return x(d.last_compile_in_phase - d.first_compile_in_phase + 1);
        } else {
          return x(d.last_compile_in_phase - d.first_compile_in_phase + 2);
        }
      })
    .attr("height", 10)
    .attr("stroke", "grey")
    .attr("fill",
      function(d) {
        return TDDColor(d.tdd_color);
      })
    .attr("transform", "translate(" + margin.left + ",10)");



  //Draw Compile Points
  var bar = chart.selectAll("g")
    .data(data)
    .enter().append("g");

  bar.append("circle")
    .attr("cx", function(d, i) {
      return x(d.git_tag);
    })
    .attr("r", 4)
    .attr("transform", "translate(" + margin.left + "," + lineHeight + ")")
    .attr("fill", function(d) {
      return TDDColor(d.light_color);
    })
    .attr("stroke-width", 2);


  var currTDDBar = chart.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(" + margin.left + ",110)")
    .call(xAxis)
    .selectAll("text")
    .attr("y", 6)
    .attr("height", 10)
    // .attr("x", 6)
    .style("text-anchor", "start")
    .style("font-size", "16px");

  //START HIVE PLOT
  // selection.each(function(data) {

  //       var margin = {top: 20, right: 20, bottom: 30, left: 50},
  //   width = 200,
  //     height = 200,
  //     innerRadius = 10,
  //     outerRadius = 100;


  //  var hive_data = createHiveData(TDDData[0].red, TDDData[0].green, TDDData[0].blue);

  //     var opacity = 3/ hive_data.length ;

  //     var angle = d3.scale.ordinal().domain(d3.range(4)).rangePoints([0, 2 * Math.PI]),
  //     radius = d3.scale.linear().range([innerRadius, outerRadius]),
  //     color = d3.scale.ordinal().range(["#af292e","#4e7300","#385e86"]);

  // var hive = chart.selectAll("i")
  // .data(hive_data)
  // .enter()
  // .append("i");

  //     // Select the svg element, if it exists.
  //       // var svg = currTDDBar.data([hive_data]);

  //       // Otherwise, create the skeletal chart.
  //       // var gEnter = svg.enter().append("svg").append("g");

  //       // Update the outer dimensions.
  //       // svg .attr("width", width)
  //       //     .attr("height", height);

  //       // Update the inner dimensions.
  //       var i = hive.select("i")
  //           .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  //     i.selectAll(".link")
  //       .data(hive_data)
  //     .enter().append("path")
  //       .attr("class", "link")
  //       .attr("d", d3.hive.link()
  //       .angle(function(d) { 
  //         return angle(d.x);
  //       })
  //       .startRadius(function(d) { 
  //         return radius(d.y0); })
  //       .endRadius(function(d) { return radius(d.y1); 
  //       }))
  //       .style("fill", function(d) { return color(d.group);
  //     }).style("opacity",opacity);

  //       //END HIVEPLOT


  // //setup for plot
  //   var my_pulsePlot =
  //     pulsePlot()
  //     .width(100)
  //     .height(100)
  //     .innerRadius(10)
  //     .outerRadius(50)
  //     .attr("transform", "translate(" + margin.left + "," + lineHeight + ")");

  // //put on page
  //   // $('#PulseAreaDetail').append("<div class='pulseChart' id='pulse'></div>");
  //   var data = createHiveData(TDDData[0].red, TDDData[0].green, TDDData[0].blue);
  //   d3.select("#pulse")
  //     .datum(data)
  //     .call(my_pulsePlot);



  // //Draw Compile Points
  //   var cycleBars = chart.selectAll("h")
  //     .data(cycles)
  //     .enter().append("h");

  //   // cycleBars.append("circle")
  //   //   .attr("cx", function(d, i) {
  //   //     return x(d.git_tag);
  //   //   })
  //   //   .attr("r", 4)
  //   //   .attr("transform", "translate(" + margin.left + ",1)")
  //   //   .attr("fill", "black")
  //   //   .attr("stroke-width", 2);


  //   //     var cycleBoxes = chart.selectAll("h")
  //   //     .data(cycles)
  //   //     .enter().append("h");
  //   //     //  .attr("transform", function(d, i) { 
  //   //     //   return "translate(10,10)"; 
  //   //     // });

  //   cycleBars.append("rect")
  //    .attr("x", function(d, i) {
  //         return x(d.startCompile - 1);
  //       })
  //       .attr("y", 10)
  //       .attr("width",
  //         function(d, i) {
  //           if (d.endCompile == compiles.length) {
  //             return x(d.endCompile - d.startCompile + 1);
  //           } else {
  //             return x(d.endCompile - d.startCompile + 2);
  //           }
  //         })
  //       .attr("height", 10)
  //       .attr("stroke", "grey")
  //       .attr("fill","orange");
  //   //     // .attr("transform", "translate(" + margin.left + ",10)");


  chart.selectAll("h")
    .data(cycles)
    .enter().append("rect")
    .attr("x", function(d, i) {
      return x(d.startCompile - 1);
    })
    .attr("y", 20)
    .attr("width",
      function(d, i) {
        return x(d.endCompile - d.startCompile + 1);
      })
    .attr("height", 40)
    .attr("rx", 6)
    .attr("ry", 6)
    .attr("stroke", "grey")
    .attr("fill", function(d) {
      if (d.valid_tdd == true) {
        return "#BABABA";
      }
      if (d.valid_tdd == false) {
        return "#6F6F6F";
      }

    })
    .attr("transform", "translate(" + margin.left + ",-10)");



  // chart.selectAll("h")
  //   .data(cycles)
  //   .enter().append("rect")
  //   .attr("x", function(d, i) {
  //     return x(d.startCompile - 1);
  //   })
  //   .attr("y", 10)
  //   .attr("width",
  //     function(d, i) {
  //       if (d.endCompile == compiles.length) {
  //         return x(d.endCompile - d.startCompile + 1);
  //       } else {
  //         return x(d.endCompile - d.startCompile + 2);
  //       }
  //     })
  //   .attr("height", 10)
  //   .attr("stroke", "grey")
  //   .attr("fill", function(d) {
  //     if (d.valid_tdd == "true") {
  //       return "orange";
  //     }
  //       return "green";

  //   })
  // .attr("transform", "translate(" + margin.left + ",10)");



  // endCompile: 15 
  //startCompile: 1
  //valid_tdd: true


  // //Draw phase bars
  //   chart.selectAll("f")
  //     .data(phaseData)
  //     .enter().append("rect")
  //     .attr("x", function(d, i) {
  //       return x(d.first_compile_in_phase - 1);
  //     })
  //     .attr("y", phaseHeight)
  //     .attr("width",
  //       function(d, i) {
  //         if (d.last_compile_in_phase == compiles.length) {
  //           return x(d.last_compile_in_phase - d.first_compile_in_phase + 1);
  //         } else {
  //           return x(d.last_compile_in_phase - d.first_compile_in_phase + 2);
  //         }
  //       })
  //     .attr("height", 10)
  //     .attr("stroke", "grey")
  //     .attr("fill",
  //       function(d) {
  //         return TDDColor(d.tdd_color);
  //       })
  //     .attr("transform", "translate(" + margin.left + ",10)");



  var gBrush = chart.append("g")
    .attr("class", "brush")
    .call(brush)
    .call(brush.event);

  gBrush.selectAll("rect")
    .attr("height", 51)
    .attr("transform", "translate(" + margin.left + ",59)");



}


function populateAccordion(data) {
  var commonFiles = [];
  var uniqueStart = [];
  var uniqueEnd = [];
  for (var start_key in data.start) {
    var found = 0;
    for (var end_key in data.end) {
      if (start_key == end_key) {
        commonFiles.push(start_key)
        found = 1;
      }
    }
    if (found < 1) {
      uniqueStart.push(start_key)
    }
  }

  for (var end_key in data.end) {
    if (commonFiles.indexOf(end_key) < 0) {
      uniqueEnd.push(end_key);
    }
  }

  // console.log(commonFiles);
  // console.log(uniqueStart);
  // console.log(uniqueEnd);

  //console.log(data.start);



    $("#accordion").accordion({
      heightStyle: "fill"
    });

  $('#accordion').html("");

  //Add Common Files
  commonFiles
    .forEach(
      function(element, index) {
        // console.log(element);
        // console.log(data.start[element]);
        // console.log(data.end[element]);

        var str1 = data.start[element];
        var str2 = data.end[element];

        var safeName = element.replace('.', '');

        var newDiv = "<h3>" + element + "<\/h3><div><div id='compare_" + safeName + "' class='CodeMirror'></div></div>";
        $('#accordion').append(newDiv);

        $('#compare_' + safeName)
          .mergely({
            width: 1100,
            // height: 'auto',
            cmsettings: {
              readOnly: true,
              lineNumbers: true,
              mode: "text/x-java"
            },
            lhs: function(setValue) {
              setValue(str1);
            },
            rhs: function(setValue) {
              setValue(str2);
            }
          });
      })
    //Add unique start files
  uniqueStart.forEach(
    function(element, index) {
      // console.log(element);
      // console.log(data.start[element]);
      // console.log(data.end[element]);

      var str1 = data.start[element];
      var str2 = data.start[element];

      var safeName = element.replace('.', '');

      var newDiv = "<h3>" + element + "<\/h3><div><div id='compare_" + safeName + "' class='CodeMirror'></div></div>";
      $('#accordion').append(newDiv);

      $('#compare_' + safeName)
        .mergely({
          width: 800,
          // height: 'auto',
          cmsettings: {
            readOnly: true,
            lineNumbers: true,
            mode: "text/x-java"
          },
          lhs: function(setValue) {
            setValue(str1);
          },
          rhs: function(setValue) {
            setValue(str2);
          }
        });
    })

  //Add unique end files
  uniqueEnd.forEach(
    function(element, index) {
      // console.log(element);
      // console.log(data.start[element]);
      // console.log(data.end[element]);

      var str1 = data.end[element];
      var str2 = data.end[element];

      var safeName = element.replace('.', '');

      var newDiv = "<h3>" + element + "<\/h3><div><div id='compare_" + safeName + "' class='CodeMirror'></div></div>";
      $('#accordion').append(newDiv);

      $('#compare_' + safeName)
        .mergely({
          width: 800,
          // height: 'auto',
          cmsettings: {
            readOnly: true,
            lineNumbers: true,
            mode: "text/x-java"
          },
          lhs: function(setValue) {
            setValue(str1);
          },
          rhs: function(setValue) {
            setValue(str2);
          }
        });
    })


  $('#accordion').accordion("refresh");
  $("#accordion").accordion("option", "active", 0);
}

function checkLogin() {

  $("#logout").click(function() {
    // $.ajax({
    //   url: 'del_cookie',
    //   type: 'post',
    //   data: username,
    //   dataType: 'JSON'
    // }).done(function() {
    // location.reload();
    // });
    // $.removeCookie('username');
    $.removeCookie('username', { path: '/' });
    location.reload();
  });

  $('#username').html("Hello " + username);
}

function redrawPhaseBars() {
  // phaseBars.exit().remove();
  phaseBars.remove();

  console.log("redrawPhaseBars");
  //Draw phase bars
  phaseBars = chart.selectAll(".phase")
    .data(phaseData)
    .enter().append("g");

  phaseBars.append("rect")
    .attr("x", function(d, i) {
      return x(d.first_compile_in_phase);
    })
    .attr("y", phaseHeight)
    .attr("width",
      function(d, i) {
        return x(d.last_compile_in_phase - d.first_compile_in_phase);
      })
    .attr("height", 10)
    .attr("stroke", "grey")
    .attr("fill",
      function(d) {
        return TDDColor(d.tdd_color);
      })
    .attr("transform", "translate(" + margin.left + ",10)");


  // phaseBars.remove();
  //saveMarkup();
}

function saveMarkup() {

  phaseDataJSON = {
    phaseData: phaseData,
    cyberdojo_id: gon.cyberdojo_id,
    cyberdojo_avatar: gon.cyberdojo_avatar
  };

  $.ajax({
    url: 'store_markup',
    type: 'post',
    data: phaseDataJSON,
    dataType: 'JSON'
  });
}

function saveNewPhase(start, end, color) {

  phaseDataJSON = {
    phaseData: {
      start: start,
      end: end,
      color: color
    },
    cyberdojo_id: gon.cyberdojo_id,
    cyberdojo_avatar: gon.cyberdojo_avatar,
    user: document.cookie
  };

  $.ajax({
    url: 'store_markup',
    type: 'post',
    data: phaseDataJSON,
    dataType: 'JSON'
  });
}


function addNewPhase(start, end, color) {
  console.log(brush.extent());
  var newPhase = new Object();
  newPhase.first_compile_in_phase = start;
  newPhase.last_compile_in_phase = end;
  newPhase.tdd_color = color;
  phaseData.push(newPhase);
  redrawPhaseBars();
  saveNewPhase(start, end, color);
}

function setUserNameCookie(username) {

  username = {
    username: username
  };
  $.ajax({
    url: 'set_cookie',
    type: 'post',
    data: username,
    dataType: 'JSON'
  });
}

function deleteMatchingPhases(start, end) {
  // phaseData = phaseData.filter(function(element) {
  //   if (currLocation[0] >= element.first_compile_in_phase && currLocation[0] <= element.last_compile_in_phase) {
  //     console.log("WOOHOO");
  //     console.log(element);
  //     return false;
  //   } else {
  //     return true;
  //   }
  // });
  // redrawPhaseBars();


  for (var i = phaseData.length; i--; i > 0) {
    console.log(phaseData[i]);
    currStart = phaseData[i].first_compile_in_phase
    currEnd = phaseData[i].last_compile_in_phase
    if (currStart >= start && currStart < end) {
      deletePhase(phaseData[i], i);
    } else if (currEnd > start && currEnd <= end) {
      deletePhase(phaseData[i], i);
    }
  }
  redrawPhaseBars();

}

function deletePhase(currPhase, i) {

  phaseDataJSON = {
    phaseData: {
      start: currPhase.first_compile_in_phase,
      end: currPhase.last_compile_in_phase,
      color: currPhase.tdd_color
    },
    cyberdojo_id: gon.cyberdojo_id,
    cyberdojo_avatar: gon.cyberdojo_avatar,
    user: username
  };

  phaseData.splice(i, 1);
  $.ajax({
    url: 'del_markup',
    type: 'post',
    data: phaseDataJSON,
    dataType: 'JSON'
  });

}

function addAllPrexistingMarkup(markupArr) {
  if (markupArr == undefined) {
    return;
  }
  markupArr.forEach(function(element, index, array) {
    console.log(element.tdd_color);
    // element.tdd_color;
    // addNewPhase(element.first_compile_in_phase, element.last_compile_in_phase, element.tdd_color);

    phaseData.push(element);
    // redrawPhaseBars();

  });
  redrawPhaseBars();
}

function initializeKeyBindings() {

  console.log("INIT BINDINGS");
  $(document).keydown(function(e) {
    console.log(e.which);
    switch (e.which) {
      case 65: //a
        addNewPhase(brush.extent()[0], brush.extent()[1], "red");
        break;

      case 83: //s
        addNewPhase(brush.extent()[0], brush.extent()[1], "green");
        break;

      case 68: //d
        addNewPhase(brush.extent()[0], brush.extent()[1], "blue");
        break;

      case 70: //f
        addNewPhase(brush.extent()[0], brush.extent()[1], "white");
        break;

      case 37: // left
        if (brush.extent()[0] < 1) {
          break
        }
        if (brush.extent()[0] >= brush.extent()[1]) {
          break
        }
        if (e.shiftKey) {
          currLocation = brush.extent();
          brush.extent([currLocation[0] - 1, currLocation[1]]);
          brush(d3.select(".brush").transition());
        } else if (e.altKey) {
          currLocation = brush.extent();
          brush.extent([currLocation[0], currLocation[1] - 1]);
          brush(d3.select(".brush").transition());
        } else {
          currLocation = brush.extent();
          brush.extent([currLocation[0] - 1, currLocation[1] - 1]);
          brush(d3.select(".brush").transition());
        }
        break;

      case 38: // up
        break;

      case 39: // right
        if (brush.extent()[1] > (gon.compiles.length - 1)) {
          break
        }
        if (brush.extent()[1] <= brush.extent()[0]) {
          break
        }
        if (e.shiftKey) {
          currLocation = brush.extent();
          brush.extent([currLocation[0], currLocation[1] + 1]);
          brush(d3.select(".brush").transition());
        } else if (e.altKey) {
          currLocation = brush.extent();
          brush.extent([currLocation[0] + 1, currLocation[1]]);
          brush(d3.select(".brush").transition());
        } else {
          currLocation = brush.extent();
          brush.extent([currLocation[0] + 1, currLocation[1] + 1]);
          brush(d3.select(".brush").transition());
        }
        break;

      case 40: // down
        break;

      case 88: // x
        currLocation = brush.extent();
        deleteMatchingPhases(brush.extent()[0], brush.extent()[1]);
        // phaseBars.data(phaseData).exit().remove();
        break;

      default:
        return; // exit this handler for other keys
    }

    e.preventDefault(); // prevent the default action (scroll / move caret)
  });

}