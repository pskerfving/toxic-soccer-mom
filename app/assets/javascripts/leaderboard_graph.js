$(document).ready(function (){
    // find the tag used only in the users#index page.
    if ( $('#leaderboard_graph_button').length ) { drawLeaderBoardGraph() };
});

function drawLeaderBoardGraph() {
    // get the historic_results array from the server
    $.getJSON("historic_results", function( results ) {
        var colors = ['rgb(166,206,227)','rgb(31,120,180)','rgb(178,223,138)','rgb(51,160,44)','rgb(251,154,153)','rgb(227,26,28)','rgb(253,191,111)','rgb(255,127,0)','rgb(202,178,214)','rgb(106,61,154)'];

        // draw the legend
        var legend = d3.select("#legend");
        legend.selectAll("div").data(results).enter()
            .append("div").attr("class", "legend_line").attr("data-path-id", function(d, i) { return i; })
            .append("div").attr("class", "legend_text").text(function (d){ return d[0]; });
        legend.selectAll(".legend_line").insert("div", ".legend_text").attr("class", "legend_color").attr("style", function(d, i){ return "background-color:" + colors[i]; });

        var h = 300;
        var w = 500;
        var stepSz = (w - 12)/(results[0].length - 1);

        // find max or each column and the smallest value.
        var max = [];
        results.forEach(function(row){
            row.slice(1).forEach(function(val, i){
                if (parseInt(val) > (max[i] || 0)) {
                    max[i] = parseInt(val);
                }
            });
        });

        // recalculate each value to be the negative difference to the max for that column.
        // find the greatest difference to scale the diagram properly.
        var lines = [];
        var min = 0;
        results.forEach(function(row, i){
            lines[i] = [];
            row.slice(1).forEach(function(val, j){
                var diff = parseInt(val) - max[j];
                lines[i][j] = diff;
                if (diff < min) { min = diff; }
            });
        });

        var svg = d3.select("#leaderboard_graph_canvas").append("svg");
        svg.attr("width", w).attr("height", h).attr("class", "leaderboard_canvas");

        var scale = d3.scale.linear()
            .domain([0, min])
            .range([10, h - 20]);

        var lineFunc = d3.svg.line().x(function(d, i){ return i * stepSz; }).y(function(d, i){ return scale(d); }).interpolate("linear");

        // create the grid lines.
        var axis = d3.svg.axis();
        axis.scale(scale).orient("right");
        svg.append("g").attr("class", "leaderboard_axis").attr("transform", "translate(" + (w - 22) + ", 0)").call(axis.tickSize(-w, 0, 0));

        // create the path lines
        lines.forEach(function(row, i){
            svg.append("path").attr("d", lineFunc(row))
                .attr("stroke", colors[i])
                .attr("stroke-width", 3)
                .attr("fill", "none")
                .attr("data-path-id", i)
                .attr("class", "leaderboard_graph_path");
        });

        $(".legend_line").hover(function(){
            // find the path with the corresponding id.
            var path = $(".leaderboard_graph_path[data-path-id='" + $(this).attr("data-path-id") + "']");
            // move the path to be last in the group.
            path.appendTo( ".leaderboard_canvas" );
            // make it heavy.
            path.attr("stroke-width", 7);
        }, function(){
            $(".leaderboard_graph_path").attr("stroke-width", 3);
            });

    });


}

