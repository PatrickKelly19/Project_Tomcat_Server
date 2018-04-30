<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Objects" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="static java.util.Collections.*" %>
<html>
<head>
    <title>Head-Head Statistics</title>
    <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <style>
        body {
            background-color: white;
        }

        h1 {
            color: red;
        }
    </style>
    <style>
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        tr:nth-child(even) {
            background-color: #dddddd;
        }
    </style>
    <style>
        div.a {
            text-align: center;
        }

        div.b {
            text-align: left;
        }

        div.c {
            text-align: right;
        }

        div.d {
            text-align: justify;
        }
    </style>
</head>
<body>
<form id="myform" name="myform" method="post" action="Patrick.jsp">
    <div class="container" id="container">
        <% String accountID = request.getParameter("param"); %>
        <%
            String[] temp;
            String delimiter = ";";

            temp = accountID.split(delimiter);
            String homeTeam = temp[0];
            String awayTeam = temp[1];

        %>
        <%
            try {
                String connectionURL = "jdbc:mysql://104.197.152.81:3306/Football";
                Connection connection = null;
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                connection = DriverManager.getConnection(connectionURL, "root", "root");
                if (!connection.isClosed()) {

                    DecimalFormat decimal = new DecimalFormat(".##");

                    PreparedStatement last5HomeTeam, last5AwayTeam, noOfGames, totalGoals, homeGoalsCS, homeGoalsPS, awayGoalsCSPS,                                                        resultsBetHomeAway, totalGoalsLS, totalHomeGoalsLS, totalAwayGoalsLS, homeGoalsLSHT, goalsConcededAwayLSAT,                                          homeGoalsLSAT, goalConcededAwayLSHT, totalGoalsCS, totalHomeGoalsCS, totalAwayGoalsCS, homeGoalsCSHT,                                                goalsConcededAwayCSAT, homeGoalsCSAT, goalsConcededAwayCSHT;

                    int totalNoOfGames = 0, totalNoOfGamesBetHomeAway = 0, countNoHomeGamesHT = 0, countNoAwayGamesAT = 0, countNoHomeGamesAT = 0,                           countNoAwayGamesHT = 0, sumOfHomeGoalsCSHT = 0, sumOfHomeGoalsPSHT = 0, sumOfAwayGoalsCSAT = 0, sumOfHomeGoalsPSAT = 0,                              sumOfAwayGoalsHT = 0, sumOfAwayGoalsAT = 0, goals_1617 = 0, goalsHome_1617 = 0, goalsAway_1617 = 0, goalsAtHomeLSAT = 0,                             goalsConAwayLSHT = 0, goals_1718 = 0, goalsHome_1718 = 0, goalsAway_1718 = 0, goalsAtHomeCSAT = 0, goalsConAwayCSHT = 0,                             goalsAtHomeLSHT = 0, goalsConAwayLSAT = 0, goalsAtHomeCSHT = 0, goalsConAwayCSAT = 0, amtOfDrawsHTAT = 0, homeTeamWins = 0,                          awayTeamWins = 0, amountOfCleanSheetsName = 0, amountOfCleanSheetsSurName = 0;

                    double avgNumberLastSeason = 0.0, avgNumberLastSeasonHome = 0.0, avgNumberLastSeasonAway = 0, avgNumberThisSeason = 0.0,                                    avgNumberThisSeasonHome = 0.0, avgNumberThisSeasonAway = 0;

                    ResultSet resultSet1, resultSet2, resultSet3, resultSet5, resultSet20, resultSet21, resultSet22, resultSet4, resultSet6,                                       resultSet7, resultSet8, resultSet9, resultSet10, resultSet11, resultSet12, resultSet13,                                                              resultSet14, resultSet15, resultSet16, resultSet17, resultSet18, resultSet19;


                    //Queries To Database For Stats Required

                    last5HomeTeam = connection.prepareStatement("SELECT * FROM LatestSeason WHERE HomeTeam = ? OR AwayTeam = ? ORDER BY id DESC                                                          LIMIT 5");

                    last5AwayTeam = connection.prepareStatement("SELECT * FROM LatestSeason WHERE HomeTeam = ? OR AwayTeam = ? ORDER BY id DESC                                                          LIMIT 5");

                    noOfGames = connection.prepareStatement("SELECT * FROM LatestSeason WHERE HomeTeam = ? AND AwayTeam = ?                                                                            OR HomeTeam = ? AND AwayTeam = ?\n" +
                            "UNION\n" +
                            "SELECT * FROM HistoricalResults WHERE HomeTeam = ? AND AwayTeam                                                                          = ? OR HomeTeam = ? AND AwayTeam = ?");

                    totalGoals = connection.prepareStatement("SELECT SUM(HomeScore + AwayScore) FROM LatestSeason WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?\n" +
                            "UNION\n" +
                            "SELECT SUM(HomeScore + AwayScore) FROM HistoricalResults WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?");

                    homeGoalsCS = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore) FROM LatestSeason WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ? \n" +
                            "Group BY AwayTeam, HomeTeam");

                    homeGoalsPS = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore) FROM HistoricalResults WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ? \n" +
                            "Group BY AwayTeam, HomeTeam");

                    awayGoalsCSPS = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(AwayScore) FROM LatestSeason WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ? \n" +
                            "GROUP BY HomeTeam, AwayTeam \n" +
                            "UNION \n" +
                            "SELECT HomeTeam, AwayTeam, SUM(AwayScore) FROM HistoricalResults WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?\n" +
                            "GROUP BY HomeTeam, AwayTeam");

                    resultsBetHomeAway = connection.prepareStatement("SELECT * FROM LatestSeason WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?\n" +
                            "UNION\n" +
                            "SELECT * FROM HistoricalResults WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?\n" +
                            "GROUP BY id \n" +
                            "ORDER BY id\n" +
                            "LIMIT 0 , 5");

                    totalGoalsLS = connection.prepareStatement("SELECT  SUM(HomeScore + AwayScore)FROM HistoricalResults\n" +
                            "GROUP BY id LIMIT 0 , 380");

                    totalHomeGoalsLS = connection.prepareStatement("SELECT  SUM(HomeScore)FROM HistoricalResults\n" +
                            "GROUP BY id LIMIT 0 , 380");

                    totalAwayGoalsLS = connection.prepareStatement("SELECT  SUM(AwayScore)FROM HistoricalResults\n" +
                            "GROUP BY id LIMIT 0 , 380");

                    homeGoalsLSHT = connection.prepareStatement("SELECT HomeTeam, SUM(HomeScore) FROM HistoricalResults WHERE HomeTeam = ? GROUP BY id LIMIT 19");

                    goalsConcededAwayLSAT = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore), SUM(AwayScore) FROM HistoricalResults WHERE AwayTeam = ? GROUP BY id LIMIT 19");

                    homeGoalsLSAT = connection.prepareStatement("SELECT HomeTeam, SUM(HomeScore) FROM HistoricalResults WHERE HomeTeam = ? GROUP BY id LIMIT 19");

                    goalConcededAwayLSHT = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore), SUM(AwayScore) FROM HistoricalResults WHERE AwayTeam = ? GROUP BY id LIMIT 19");

                    totalGoalsCS = connection.prepareStatement("SELECT SUM(HomeScore + AwayScore) , COUNT(*) FROM LatestSeason");

                    totalHomeGoalsCS = connection.prepareStatement("SELECT  SUM(HomeScore), COUNT(*) FROM LatestSeason");

                    totalAwayGoalsCS = connection.prepareStatement("SELECT  SUM(AwayScore), COUNT(*) FROM LatestSeason");

                    homeGoalsCSHT = connection.prepareStatement("SELECT HomeTeam, SUM(HomeScore), COUNT(*) FROM LatestSeason WHERE HomeTeam = ?");

                    goalsConcededAwayCSAT = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore), SUM(AwayScore), COUNT(*) FROM LatestSeason WHERE AwayTeam = ? GROUP BY id");

                    homeGoalsCSAT = connection.prepareStatement("SELECT HomeTeam, SUM(HomeScore), COUNT(*) FROM LatestSeason WHERE HomeTeam = ? GROUP BY id");

                    goalsConcededAwayCSHT = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore), SUM(AwayScore), COUNT(*) FROM LatestSeason WHERE AwayTeam = ? GROUP BY id");

                    last5HomeTeam.setString(1, homeTeam);
                    last5HomeTeam.setString(2, homeTeam);

                    last5AwayTeam.setString(1, awayTeam);
                    last5AwayTeam.setString(2, awayTeam);

                    noOfGames.setString(1, homeTeam);
                    noOfGames.setString(2, awayTeam);
                    noOfGames.setString(3, awayTeam);
                    noOfGames.setString(4, homeTeam);
                    noOfGames.setString(5, homeTeam);
                    noOfGames.setString(6, awayTeam);
                    noOfGames.setString(7, awayTeam);
                    noOfGames.setString(8, homeTeam);

                    totalGoals.setString(1, homeTeam);
                    totalGoals.setString(2, awayTeam);
                    totalGoals.setString(3, awayTeam);
                    totalGoals.setString(4, homeTeam);
                    totalGoals.setString(5, homeTeam);
                    totalGoals.setString(6, awayTeam);
                    totalGoals.setString(7, awayTeam);
                    totalGoals.setString(8, homeTeam);

                    homeGoalsCS.setString(1, homeTeam);
                    homeGoalsCS.setString(2, awayTeam);
                    homeGoalsCS.setString(3, awayTeam);
                    homeGoalsCS.setString(4, homeTeam);

                    homeGoalsPS.setString(1, homeTeam);
                    homeGoalsPS.setString(2, awayTeam);
                    homeGoalsPS.setString(3, awayTeam);
                    homeGoalsPS.setString(4, homeTeam);

                    awayGoalsCSPS.setString(1, homeTeam);
                    awayGoalsCSPS.setString(2, awayTeam);
                    awayGoalsCSPS.setString(3, awayTeam);
                    awayGoalsCSPS.setString(4, homeTeam);
                    awayGoalsCSPS.setString(5, homeTeam);
                    awayGoalsCSPS.setString(6, awayTeam);
                    awayGoalsCSPS.setString(7, awayTeam);
                    awayGoalsCSPS.setString(8, homeTeam);

                    resultsBetHomeAway.setString(1, homeTeam);
                    resultsBetHomeAway.setString(2, awayTeam);
                    resultsBetHomeAway.setString(3, awayTeam);
                    resultsBetHomeAway.setString(4, homeTeam);
                    resultsBetHomeAway.setString(5, homeTeam);
                    resultsBetHomeAway.setString(6, awayTeam);
                    resultsBetHomeAway.setString(7, awayTeam);
                    resultsBetHomeAway.setString(8, homeTeam);

                    homeGoalsLSHT.setString(1, homeTeam);
                    goalsConcededAwayLSAT.setString(1, awayTeam);

                    homeGoalsLSAT.setString(1, awayTeam);
                    goalConcededAwayLSHT.setString(1, homeTeam);

                    homeGoalsCSHT.setString(1, homeTeam);
                    goalsConcededAwayCSAT.setString(1, awayTeam);

                    homeGoalsCSAT.setString(1, awayTeam);
                    goalsConcededAwayCSHT.setString(1, homeTeam);

                    resultSet1 = last5HomeTeam.executeQuery();
                    resultSet2 = last5AwayTeam.executeQuery();
                    resultSet3 = noOfGames.executeQuery();
                    resultSet5 = totalGoals.executeQuery();
                    resultSet20 = homeGoalsCS.executeQuery();
                    resultSet21 = homeGoalsPS.executeQuery();
                    resultSet22 = awayGoalsCSPS.executeQuery();
                    resultSet4 = resultsBetHomeAway.executeQuery();
                    resultSet6 = totalGoalsLS.executeQuery();
                    resultSet7 = totalHomeGoalsLS.executeQuery();
                    resultSet8 = totalAwayGoalsLS.executeQuery();
                    resultSet9 = homeGoalsLSHT.executeQuery();
                    resultSet10 = goalsConcededAwayLSAT.executeQuery();
                    resultSet11 = homeGoalsLSAT.executeQuery();
                    resultSet12 = goalConcededAwayLSHT.executeQuery();
                    resultSet13 = totalGoalsCS.executeQuery();
                    resultSet14 = totalHomeGoalsCS.executeQuery();
                    resultSet15 = totalAwayGoalsCS.executeQuery();
                    resultSet16 = homeGoalsCSHT.executeQuery();
                    resultSet17 = goalsConcededAwayCSAT.executeQuery();
                    resultSet18 = homeGoalsCSAT.executeQuery();
                    resultSet19 = goalsConcededAwayCSHT.executeQuery();

                    //Home Teams Last 5 Games
                    out.println("<div class=\"a\">");
                    out.println("<h1>");
                    out.println("<IMG SRC=\"/images/" + homeTeam + ".png\"height=\"42\" width=\"42\">");
                    out.println(homeTeam + "'s Last 5 Results");
                    out.println("</h1>");
                    out.println("</div>");
                    out.println("<table border = \"1\" width = \"100%\">\n" +
                            "    <tr>\n" +
                            "        <th>Home Team</th>\n" +
                            "        <th>Away Team</th>\n" +
                            "        <th>Home Score</th>\n" +
                            "        <th>Away Score</th>\n" +
                            "        <th>Winner</th>\n" +
                            "</tr>");
                    out.println("Recent Form: ");
                    while (resultSet1.next()) {
                        out.println("<td>" + resultSet1.getString("HomeTeam") + "</td>");
                        out.println("<td>" + resultSet1.getString("AwayTeam") + "</td>");
                        out.println("<td>" + resultSet1.getInt("HomeScore") + "</td>");
                        out.println("<td>" + resultSet1.getInt("AwayScore") + "</td>");
                        out.println("<td>" + resultSet1.getString("Winner") + "</td>");
                        out.println("</tr>");

                        //Getting Recent Form of Home Team
                        String form = resultSet1.getString("Winner");

                        if (form.equals(homeTeam)) {
                            out.println("<font color=\"lime\">W</font>");
                        } else if (form.equals("Draw")) {
                            out.println("<font color=\"orange\">D</font>");
                        } else {
                            out.println("<font color=\"red\">L</font>");
                        }
                    }
                    out.println("</table>");

                    //Away Teams Last 5 Results
                    out.println("<div class=\"a\">");
                    out.println("<h1>");
                    out.println("<IMG SRC=\"/images/" + awayTeam + ".png\"height=\"42\" width=\"42\">");
                    out.println(awayTeam + "'s Last 5 Results");
                    out.println("</h1>");
                    out.println("</div>");
                    out.println("<table border = \"1\" width = \"100%\">\n" +
                            "    <tr>\n" +
                            "        <th>Home Team</th>\n" +
                            "        <th>Away Team</th>\n" +
                            "        <th>Home Score</th>\n" +
                            "        <th>Away Score</th>\n" +
                            "        <th>Winner</th>\n" +
                            "</tr>");
                    out.println("Recent Form: ");
                    while (resultSet2.next()) {
                        out.println("<td>" + resultSet2.getString("HomeTeam") + "</td>");
                        out.println("<td>" + resultSet2.getString("AwayTeam") + "</td>");
                        out.println("<td>" + resultSet2.getInt("HomeScore") + "</td>");
                        out.println("<td>" + resultSet2.getInt("AwayScore") + "</td>");
                        out.println("<td>" + resultSet2.getString("Winner") + "</td>");
                        out.println("</tr>");

                        //Getting Recent Form of Away Team
                        String form1 = resultSet2.getString("Winner");

                        if (form1.equals(awayTeam)) {
                            out.println("<font color=\"lime\">W</font>");
                        } else if (form1.equals("Draw")) {
                            out.println("<font color=\"orange\">D</font>");
                        } else {
                            out.println("<font color=\"red\">L</font>");
                        }
                    }
                    out.println("</table>");

                    //Getting Number of Games/Wins/Loses/Draws for Fixture Between Home Team and Away Team
                    while (resultSet3.next()) {

                        String home1 = resultSet3.getString("HomeTeam");
                        String home2 = resultSet3.getString("AwayTeam");

                        int count1 = resultSet3.getInt("HomeScore");
                        int count2 = resultSet3.getInt("AwayScore");

                        totalNoOfGames++;

                        String result = resultSet3.getString("Winner");

                        if (result.equals(homeTeam)) {
                            homeTeamWins++;
                        } else if (result.equals(awayTeam)) {
                            awayTeamWins++;
                        } else {
                            amtOfDrawsHTAT++;
                        }

                        //Getting Number of Clean Sheets of Home Team Against Away Team
                        if (Objects.equals(home1, homeTeam)) {

                            if (count1 == 0 || count2 == 0) {
                                amountOfCleanSheetsName++;
                            }
                        }

                        //Getting Number of Clean Sheets of Away Team Against Home Team
                        if (Objects.equals(home1, awayTeam)) {

                            if (count1 == 0 || count2 == 0) {
                                amountOfCleanSheetsSurName++;
                            }
                        }
                    }

                    out.println("<div class=\"a\">");
                    out.println("<h1>Lastest Fixtures Between " + homeTeam + " and " + awayTeam + "</h1>");
                    out.println("</div>");
                    out.println("<table border = \"1\" width = \"100%\">\n" +
                            "    <tr>\n" +
                            "        <th>Home Team</th>\n" +
                            "        <th>Away Team</th>\n" +
                            "        <th>Home Score</th>\n" +
                            "        <th>Away Score</th>\n" +
                            "        <th>Winner</th>\n" +
                            "</tr>");
                    while (resultSet4.next()) {
                        out.println("<td>" + resultSet4.getString("HomeTeam") + "</td>");
                        out.println("<td>" + resultSet4.getString("AwayTeam") + "</td>");
                        out.println("<td>" + resultSet4.getInt("HomeScore") + "</td>");
                        out.println("<td>" + resultSet4.getInt("AwayScore") + "</td>");
                        out.println("<td>" + resultSet4.getString("Winner") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");

                    //Getting Total Number of Goals Between Home and Away Teams From 2016/17 and 2017/18 Season
                    while (resultSet5.next()) {

                        int c = resultSet5.getInt(1);
                        totalNoOfGamesBetHomeAway = totalNoOfGamesBetHomeAway + c;
                    }

                    //Getting Total Number of Goals 2016/17 Season
                    while (resultSet6.next()) {

                        int c = resultSet6.getInt(1);
                        goals_1617 = goals_1617 + c;

                        //Average Number of Goals Scored Away 2016/17
                        avgNumberLastSeason = goals_1617 / (double) 380; //Diving by the amount of games in a season
                    }

                    //Getting Total Number of Home Goals 2016/17 Season
                    while (resultSet7.next()) {

                        int c = resultSet7.getInt(1);
                        goalsHome_1617 = goalsHome_1617 + c;

                        //Average Number of Goals Scored Home 2016/17
                        avgNumberLastSeasonHome = goalsHome_1617 / (double) 380;
                    }

                    //Getting Total Number of Away Goals 2016/17 Season
                    while (resultSet8.next()) {

                        int c = resultSet8.getInt(1);
                        goalsAway_1617 = goalsAway_1617 + c;

                        //Average Number of Goals Scored Away 2016/17
                        avgNumberLastSeasonAway = goalsAway_1617 / (double) 380;
                    }

                    //Amount of Home Goals Scored in 2016/17 Season From Home Team
                    while (resultSet9.next()) {

                        int c = resultSet9.getInt(2);
                        goalsAtHomeLSHT = goalsAtHomeLSHT + c;
                    }

                    //Amount of Goals Conceded By Away Team Away From Home in 2016/17 Season
                    while (resultSet10.next()) {

                        int c = resultSet10.getInt(3);
                        goalsConAwayLSAT = goalsConAwayLSAT + c;
                    }

                    //Amount of Home Goals Scored in 2016/17 Season From Away Team
                    while (resultSet11.next()) {

                        int c = resultSet11.getInt(2);
                        goalsAtHomeLSAT = goalsAtHomeLSAT + c;
                    }

                    //Amount of Goals Conceded By Home Team Away From Home in 2016/17 Season
                    while (resultSet12.next()) {

                        int c = resultSet12.getInt(3);
                        goalsConAwayLSHT = goalsConAwayLSHT + c;
                    }

                    //Getting Total Number of Goals 2017/18 Season
                    while (resultSet13.next()) {

                        int c = resultSet13.getInt(1);
                        int getCurrentGamesPlayed = resultSet13.getInt(2);
                        goals_1718 = goals_1718 + c;

                        //Average Number of Goals Scored 2017/18
                        avgNumberThisSeason = goals_1718 / (double) getCurrentGamesPlayed; //Divided By The Number of Games Played Currently This Season
                    }

                    //Getting Total Number of Home Goals 2017/18 Season
                    while (resultSet14.next()) {

                        int c = resultSet14.getInt(1);
                        int getCurrentGamesPlayed = resultSet14.getInt(2);
                        goalsHome_1718 = goalsHome_1718 + c;

                        //Average Number of Goals Scored Home 2017/18
                        avgNumberThisSeasonHome = goalsHome_1718 / (double) getCurrentGamesPlayed; //Divided By The Number of Games Played at Home Currently This Season
                    }

                    //Getting Total Number of Away Goals 2017/18 Season
                    while (resultSet15.next()) {

                        int c = resultSet15.getInt(1);
                        int getCurrentGamesPlayed = resultSet15.getInt(2);
                        goalsAway_1718 = goalsAway_1718 + c;

                        //Average Number of Goals Scored Away 2017/18
                        avgNumberThisSeasonAway = goalsAway_1718 / (double) getCurrentGamesPlayed; //Divided By The Number of Games Played Away from Home Currently This Season
                    }

                    //Amount of Home Goals Scored in 2017/18 Season From Home Team
                    while (resultSet16.next()) {

                        int c = resultSet16.getInt(2);
                        countNoHomeGamesHT = resultSet16.getInt(3); //Counting Number of Home Games Played This Season for Home Team
                        goalsAtHomeCSHT = goalsAtHomeCSHT + c;
                    }

                    //Amount of Goals Conceded By Away Team Away From Home in 2017/18 Season
                    while (resultSet17.next()) {

                        int c = resultSet17.getInt(3);
                        int count = resultSet17.getInt(5);
                        countNoAwayGamesAT = countNoAwayGamesAT + count; //Counting Number of Away Games Played This Season For Away Team
                        goalsConAwayCSAT = goalsConAwayCSAT + c;
                    }

                    //Amount of Home Goals Scored in 2017/18 Season From Away Team
                    while (resultSet18.next()) {

                        int c = resultSet18.getInt(2);
                        int count = resultSet18.getInt(3);
                        countNoHomeGamesAT = countNoHomeGamesAT + count; //Counting Number of Home Games Played This Season For Away Team
                        goalsAtHomeCSAT = goalsAtHomeCSAT + c;
                    }

                    //Amount of Goals Conceded By Home Team Away From Home in 2017/18 Season
                    while (resultSet19.next()) {

                        int c = resultSet19.getInt(3);
                        int count = resultSet19.getInt(5);
                        countNoAwayGamesHT = countNoAwayGamesHT + count; //Counting Number of Away Games Played This Season For Home Team
                        goalsConAwayCSHT = goalsConAwayCSHT + c;
                    }

                    //Home Goals Current Season Against Opponent
                    while (resultSet20.next()) {

                        String amtGoalsHome = resultSet20.getString("HomeTeam");

                        //Getting Amount of Goals for Home Team At Home
                        if (amtGoalsHome.equals(homeTeam)) {
                            int c = resultSet20.getInt(3);
                            sumOfHomeGoalsCSHT = sumOfHomeGoalsCSHT + c;
                        }

                        //Getting Amount of Goals for Away Team At Home
                        if (amtGoalsHome.equals(awayTeam)) {
                            int c = resultSet20.getInt(3);
                            sumOfAwayGoalsCSAT = sumOfAwayGoalsCSAT + c;
                        }
                    }

                    //Home Goals From Previous Seasons Against Opponent
                    while (resultSet21.next()) {

                        String amtGoalsHomePS = resultSet21.getString("HomeTeam");

                        //Getting Amount of Goals for Home Team At Home
                        if (amtGoalsHomePS.equals(homeTeam)) {
                            int c = resultSet21.getInt(3);
                            sumOfHomeGoalsPSHT = sumOfHomeGoalsPSHT + c;
                        }

                        //Getting Amount of Goals for Home Team At Home
                        if (amtGoalsHomePS.equals(awayTeam)) {
                            int c = resultSet21.getInt(3);
                            sumOfHomeGoalsPSAT = sumOfHomeGoalsPSAT + c;
                        }
                    }

                    //Home Goals From Previous Seasons and Current Season Against Opponent
                    while (resultSet22.next()) {

                        String amtGoalsAwayPSCS = resultSet22.getString("AwayTeam");

                        //Getting Amount of Goals for Home Team Away From Home
                        if (amtGoalsAwayPSCS.equals(homeTeam)) {
                            int c = resultSet22.getInt(3);
                            sumOfAwayGoalsHT = sumOfAwayGoalsHT + c;
                        }

                        //Getting Amount of Goals for Away Team Away From Home
                        if (amtGoalsAwayPSCS.equals(awayTeam)) {
                            int c = resultSet22.getInt(3);
                            sumOfAwayGoalsAT = sumOfAwayGoalsAT + c;
                        }
                    }

                    //Total Home Goals Against Opponent
                    int s1 = sumOfHomeGoalsCSHT + sumOfHomeGoalsPSHT;
                    int s2 = sumOfAwayGoalsCSAT + sumOfHomeGoalsPSAT;

                    //Total Amount of Goals Against Opponent
                    int totalGoalsAgainstAway = s1 + sumOfAwayGoalsHT;
                    int totalGoalsAgainstHome = s2 + sumOfAwayGoalsAT;

                    //Average Amount of Goals Scored in Fixture
                    double totalAvg = totalNoOfGamesBetHomeAway / (double) totalNoOfGames;

                    //Average Amount of Goals Scored by Home Team and Away Team
                    double totalAvg1 = totalGoalsAgainstAway / (double) totalNoOfGames;
                    double totalAvg2 = totalGoalsAgainstHome / (double) totalNoOfGames;

                    //Calculate Average number of Goals Each Team is Likely to Score in This Fixture Last Season

                    //2016/17 Average Number of Goals Scored and Conceded Home and Away
                    double concededavgLastSeasonHome = avgNumberLastSeasonAway;
                    double concededavgLastSeasonAway = avgNumberLastSeasonHome;

                    //Number of Home Games Last Season by Home Team Divided by the Number of Home Games Played
                    double result = (double) goalsAtHomeLSHT / 19;

                    //Divide the Resulting Value by Last Seasons Average Home Goals Scored which gets "Attack Strength"
                    double teamAttackStrengthHT = result / avgNumberLastSeasonHome;

                    //Number of Goals Conceded Away from Home Last Season by Away Team Divided by the Number of Away Games Played
                    double result1 = (double) goalsConAwayLSAT / 19;

                    //Divide the Resulting Value by Last Seasons Average Goals Conceded by an Away Team Per Game which gets "Defence Strength"
                    double teamDefenceStrengthAT = result1 / concededavgLastSeasonAway;

                    //Number of Home Games Last Season by Away Team Divided by the Number of Home Games Played
                    double result2 = (double) goalsAtHomeLSAT / 19;

                    //Divide the Resulting Value by Last Seasons Average Away Goals Scored which gets "Attack Strength"
                    double teamAttackStrengthAT = result2 / avgNumberLastSeasonAway;

                    //Number of Goals Conceded Away from Home Last Season by Home Team Divided by the Number of Away Games Played
                    double result3 = (double) goalsConAwayLSHT / 19;

                    //Divide the Resulting Value by Last Seasons Average Goals Conceded by an Home Team Per Game which gets "Defence Strength"
                    double teamDefenceStrengthHT = result3 / concededavgLastSeasonAway;

                    //Calculation Which Will Give Likely Number of Goals Home Team and Away Team Might Score Last Season
                    double predictedGoalLSHT = teamAttackStrengthHT * teamDefenceStrengthAT * avgNumberLastSeasonHome;
                    double predictedGoalLSAT = teamAttackStrengthAT * teamDefenceStrengthHT * avgNumberLastSeasonAway;


                    //Calculate Average number of Goals Each Team is Likely to Score in This Fixture This Season

                    //2017/18 Average Number of Goals Scored and Conceded Home and Away
                    double concededavgThisSeasonHome = avgNumberThisSeasonAway;
                    double concededavgThisSeasonAway = avgNumberThisSeasonHome;

                    //Number of Home Games This Season by Home Team Divided by the Number of Home Games Played
                    double resultThisSeason = (double) goalsAtHomeCSHT / countNoHomeGamesHT;

                    //Divide the Resulting Value by This Seasons Average Home Goals Scored which gets "Attack Strength"
                    double teanAttackStrengthCSHT = resultThisSeason / avgNumberThisSeasonHome;

                    //Number of Goals Conceded Away from Home This Season by Away Team Divided by the Number of Away Games Played
                    double resultThisSeason1 = (double) goalsConAwayCSAT / countNoAwayGamesAT;

                    //Divide the Resulting Value by This Seasons Average Goals Conceded by an Away Team Per Game which gets "Defence Strength"
                    double teamDefenceStrengthCSAT = resultThisSeason1 / concededavgThisSeasonAway;

                    //Number of Home Games This Season by Away Team Divided by the Number of Home Games Played
                    double result2ThisSeason = (double) goalsAtHomeCSAT / countNoHomeGamesAT;

                    //Divide the Resulting Value by This Seasons Average Away Goals Scored which gets "Attack Strength"
                    double teamAttackStrengthCSAT = result2ThisSeason / avgNumberThisSeasonAway;

                    //Number of Goals Conceded Away from Home This Season by Home Team Divided by the Number of Away Games Played
                    double result3ThisSeason = (double) goalsConAwayCSHT / countNoAwayGamesHT;

                    //Divide the Resulting Value by This Seasons Average Goals Conceded by an Home Team Per Game which gets "Defence Strength"
                    double teamDefenceStrengthCSHT = result3ThisSeason / concededavgThisSeasonAway;

                    //Calculation Which Will Give Likely Number of Goals Home Team and Away Team Might Score This Season
                    double predictedGoalCSHT = teanAttackStrengthCSHT * teamDefenceStrengthCSAT * avgNumberThisSeasonHome;
                    double predictedGoalCSAT = teamAttackStrengthCSAT * teamDefenceStrengthCSHT * avgNumberThisSeasonAway;

                    double includeZero = 1; //Factorial for Poisson Distribution Formula

                    //Arraylist to Hold Predicted Outcomes
                    List<Double> listLSHT = new ArrayList<Double>();
                    List<Double> listLSAT = new ArrayList<Double>();
                    List<Double> listCSHT = new ArrayList<Double>();
                    List<Double> listCSAT = new ArrayList<Double>();

                    //Poisson Distribution - Predicting Multiple Outcomes

                    //i is Expected Goals 0 to 5
                    for (double i = 0; i <= 5; i++) {
                        includeZero = includeZero * i;
                        if (includeZero == 0) {
                            includeZero = includeZero + 1;
                        }

                        //Predicted Goals is the Average Event Rate Per Game
                        double powerLSHT = Math.pow(predictedGoalLSHT, i);
                        double powerLSAT = Math.pow(predictedGoalLSAT, i);
                        double powerCSHT = Math.pow(predictedGoalCSHT, i);
                        double powerCSAT = Math.pow(predictedGoalCSAT, i);

                        double expLSHT = Math.exp(-predictedGoalLSHT);
                        double expLSAT = Math.exp(-predictedGoalLSAT);
                        double expCSHS = Math.exp(-predictedGoalCSHT);
                        double expCSAT = Math.exp(-predictedGoalCSAT);

                        double resLSHT = powerLSHT * expLSHT;
                        double resLSAT = powerLSAT * expLSAT;
                        double resCSHT = powerCSHT * expCSHS;
                        double resCSAT = powerCSAT * expCSAT;

                        double res1LSHT = resLSHT / includeZero;
                        double res1LSAT = resLSAT / includeZero;
                        double res1CSHT = resCSHT / includeZero;
                        double res1CSAT = resCSAT / includeZero;


                        double res2LSHT = res1LSHT * 100;
                        double res2LSAT = res1LSAT * 100;
                        double res2CSHT = res1CSHT * 100;
                        double res2CSAT = res1CSAT * 100;

                        listLSHT.add(res2LSHT); //Percentages for 0 to 5 Goals Added to Array Lists
                        listLSAT.add(res2LSAT);
                        listCSHT.add(res2CSHT);
                        listCSAT.add(res2CSAT);
                    }

                    //Objects Holds Max Value from Array List
                    double objLSHT = Collections.max(listLSHT);
                    double objLSAT = Collections.max(listLSAT);
                    double objCSHT = Collections.max(listCSHT);
                    double objCSAT = Collections.max(listCSAT);

                    //Finds Index of Object Which Holds Max Value
                    int indexLSHT = listLSHT.indexOf(objLSHT);
                    int indexLSAT = listLSAT.indexOf(objLSAT);
                    int indexCSHT = listCSHT.indexOf(objCSHT);
                    int indexCSAT = listCSAT.indexOf(objCSAT);

                    //Get Average Result of Predicted Outcome for Home and Away From Both Seasons
                    int scoreHT = (indexLSHT + indexCSHT) / 2;
                    int scoreAT = (indexLSAT + indexCSAT) / 2;

        %>
        <div class="a">
            <h1>
                <b><u><%="Prediction For " + homeTeam + " Against " + awayTeam%>
                </u></b>
            </h1>
        </div>
        <table style="border:4px solid red;">
            <tr>
                <th>Statistic</th>
                <th><%=homeTeam%>
                </th>
                <th><%=awayTeam%>
                </th>
            </tr>
            <tr>
                <td>Predicted Result</td>
                <th><%=scoreHT%>
                </th>
                <th><%=scoreAT%>
                </th>
        </table>

        <div class="a">
            <h1>
                <%="Statistics Between " + homeTeam + " and " + awayTeam%>
            </h1>
        </div>
        <table>
            <tr>
                <th>Statistic</th>
                <th><%=homeTeam%>
                </th>
                <th><%=awayTeam%>
                </th>
            </tr>
            <tr>
                <td>Clean Sheets</td>
                <td><%=amountOfCleanSheetsName%>
                </td>
                <td><%=amountOfCleanSheetsSurName%>
                </td>
            </tr>
            <tr>
                <td>Avg Amount of Goals Per Game</td>
                <td><%=decimal.format(totalAvg1)%>
                </td>
                <td><%=decimal.format(totalAvg2)%>
                </td>
            </tr>
            <tr>
                <td>Total Amount of Goals Against Opponent</td>
                <td><%=totalGoalsAgainstAway%>
                </td>
                <td><%=totalGoalsAgainstHome%>
                </td>
            </tr>
            <tr>
                <td>Total Home Goals Against Opponent</td>
                <td><%=s1%>
                </td>
                <td><%=s1%>
                </td>
            </tr>
            <tr>
                <td>Total Away Goals Against Opponent</td>
                <td><%=sumOfAwayGoalsHT%>
                </td>
                <td><%=sumOfAwayGoalsAT%>
                </td>
            </tr>
        </table>

        <div class="a">
            <h1>
                <%="Overall Statistics For " + homeTeam + " Against " + awayTeam%>
            </h1>
        </div>
        <table>
            <tr>
                <th>Statistic</th>
                <th>Value</th>
            </tr>
            <tr>
                <td>Total Number of Goals</td>
                <td><%=totalNoOfGamesBetHomeAway%>
                </td>
            </tr>
            <tr>
                <td>Total Number of Games</td>
                <td><%=totalNoOfGames%>
                </td>
            </tr>
            <tr>
                <td>Total Avg Amount of Goals Per Game</td>
                <td><%=decimal.format(totalAvg)%>
                </td>
            </tr>
            <tr>
                <td>Total Number of Draws</td>
                <td><%=amtOfDrawsHTAT%>
                </td>
            </tr>
            <tr>
                <td><%=homeTeam%> Total Wins</td>
                <td><%=homeTeamWins%>
                </td>
            </tr>
            <tr>
                <td><%=awayTeam%> Total Wins</td>
                <td><%=awayTeamWins%>
                </td>
            </tr>
        </table>

        <div class="a">
            <h1>
                <img src="/images/PremierLeague.png" style="width:60px;height:30px;"/>
                <%="Premier League Statistics For 2017/18 Season"%>
            </h1>
        </div>
        <table>
            <tr>
                <th>Statistic</th>
                <th>Value</th>
            </tr>
            <tr>
                <td>Total Amount of Goals 2017/18</td>
                <td><%=goals_1718%>
                </td>
            </tr>
            <tr>
                <td>Total Amount of Home Goals 2017/18</td>
                <td><%=goalsHome_1718%>
                </td>
            </tr>
            <tr>
                <td>Total Amount of Away Goals 2017/18</td>
                <td><%=goalsAway_1718%>
                </td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored In Total 2017/18</td>
                <td><%=decimal.format(avgNumberThisSeason)%>
                </td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored Home 2017/18</td>
                <td><%=decimal.format(avgNumberThisSeasonHome)%>
                </td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored Away 2017/18</td>
                <td><%=decimal.format(avgNumberThisSeasonAway)%>
                </td>
            </tr>
            <tr>
                <td>Average Number of Goals Conceded Home 2017/18</td>
                <td><%=decimal.format(concededavgThisSeasonHome)%>
                </td>
            </tr>
            <tr>
                <td>Average Number of Goals Conceded Away 2017/18</td>
                <td><%=decimal.format(concededavgThisSeasonAway)%>
                </td>
            </tr>
            <tr>
                <td><%=homeTeam%> Goals Scored at Home This Season</td>
                <td><%=goalsAtHomeCSHT%>
                </td>
            </tr>
            <tr>
                <td><%=awayTeam%> Goals Conceded Away From Home This Season</td>
                <td><%=goalsConAwayCSAT%>
                </td>
            </tr>
            <tr>
                <td><%=awayTeam%> Goals Scored at Home This Season</td>
                <td><%=goalsAtHomeCSAT%>
                </td>
            </tr>
            <tr>
                <td><%=homeTeam%> Goals Conceded Away From Home This Season</td>
                <td><%=goalsConAwayCSHT%>
                </td>
            </tr>
        </table>

        <div class="a">
            <h1>
                <img src="/images/PremierLeague.png" style="width:60px;height:30px;"/>
                <%="Premier League Statistics For 2016/17 Season"%>
            </h1>
        </div>
        <table>
            <tr>
                <th>Statistic</th>
                <th>Value</th>
            </tr>
            <tr>
                <td>Total Amount of Goals 2016/17</td>
                <td><%=goals_1617%>
                </td>
            </tr>
            <tr>
                <td>Total Amount of Home Goals 2016/17</td>
                <td><%=goalsHome_1617%>
                </td>
            </tr>
            <tr>
                <td>Total Amount of Away Goals 2016/17</td>
                <td><%=goalsAway_1617%>
                </td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored In Total 2016/17</td>
                <td><%=decimal.format(avgNumberLastSeason)%>
                </td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored Home 2016/17</td>
                <td><%=decimal.format(avgNumberLastSeasonHome)%>
                </td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored Away 2016/17</td>
                <td><%=decimal.format(avgNumberLastSeasonAway)%>
                </td>
            </tr>
            <tr>
                <td>Average Number of Goals Conceded Home 2016/17</td>
                <td><%=decimal.format(concededavgLastSeasonHome)%>
                </td>
            </tr>
            <tr>
                <td>Average Number of Goals Conceded Away 2016/17</td>
                <td><%=decimal.format(concededavgLastSeasonAway)%>
                </td>
            </tr>
            <tr>
                <td><%=homeTeam%> Goals Scored at Home Last Season</td>
                <td><%=goalsAtHomeLSHT%>
                </td>
            </tr>
            <tr>
                <td><%=awayTeam%> Goals Conceded Away From Home Last Season</td>
                <td><%=goalsConAwayLSAT%>
                </td>
            </tr>
            <tr>
                <td><%=awayTeam%> Goals Scored at Home Last Season</td>
                <td><%=goalsAtHomeLSAT%>
                </td>
            </tr>
            <tr>
                <td><%=homeTeam%> Goals Conceded Away From Home Last Season</td>
                <td><%=goalsConAwayLSHT%>
                </td>
            </tr>
        </table>

        <div class="a">
            <h1>
                <%="Chart Representation of Fixture"%>
            </h1>
        </div>

        <table class="columns">
            <tr>
                <td>
                    <div id="piechart" style="border: 1px solid #ccc"></div>
                </td>
                <td>
                    <div id="piechart1" style="border: 1px solid #ccc"></div>
                </td>
                <td>
                    <div id="piechart2" style="border: 1px solid #ccc"></div>
                </td>
            </tr>
        </table>
        <script type="text/javascript">
            // Load google charts
            google.charts.load('current', {'packages': ['corechart']});
            google.charts.setOnLoadCallback(drawChart);

            // Draw the chart and set the chart values
            function drawChart() {
                var data = google.visualization.arrayToDataTable([
                    ['Task1', 'Average Goals'],
                    ['Total Avg Goals Per Game', <%=totalAvg%>],
                    ['Avg Goals Per Game For <%=homeTeam%>', <%=decimal.format(totalAvg1)%>],
                    ['Avg Goals Per Game For <%=awayTeam%>', <%=decimal.format(totalAvg1)%>]
                ]);

                // Optional; add a title and set the width and height of the chart
                var options = {'title': 'Average Goals', 'width': 400, 'height': 300};

                // Display the chart inside the <div> element with id="piechart"
                var chart = new google.visualization.PieChart(document.getElementById('piechart'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            // Load google charts
            google.charts.load('current', {'packages': ['corechart']});
            google.charts.setOnLoadCallback(drawChart);

            // Draw the chart and set the chart values
            function drawChart() {
                var data = google.visualization.arrayToDataTable([
                    ['Task1', 'Results'],
                    ['<%=homeTeam%> Wins', <%=homeTeamWins%>],
                    ['Draws', <%=amtOfDrawsHTAT%>],
                    ['<%=awayTeam%> Wins', <%=awayTeamWins%>]
                ]);

                // Optional; add a title and set the width and height of the chart
                var options = {'title': 'Results', 'width': 400, 'height': 300};

                // Display the chart inside the <div> element with id="piechart"
                var chart = new google.visualization.PieChart(document.getElementById('piechart1'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            // Load google charts
            google.charts.load('current', {'packages': ['corechart']});
            google.charts.setOnLoadCallback(drawChart);

            // Draw the chart and set the chart values
            function drawChart() {
                var data = google.visualization.arrayToDataTable([
                    ['Task1', 'Total Amount of Goals'],
                    ['Total Goals For <%=homeTeam%> Against <%=awayTeam%>', <%=totalGoalsAgainstAway%>],
                    ['Total Goals For <%=awayTeam%> Against <%=homeTeam%>', <%=totalGoalsAgainstHome%>]
                ]);

                // Optional; add a title and set the width and height of the chart
                var options = {'title': 'Total Amount of Goals', 'width': 400, 'height': 300};

                // Display the chart inside the <div> element with id="piechart"
                var chart = new google.visualization.PieChart(document.getElementById('piechart2'));
                chart.draw(data, options);
            }
        </script>

        <%
                    connection.close();
                }

            } catch (Exception ex) {
                out.println("Unable to connect to database" + ex);
            }

        %>
    </div>
</form>
</body>
</html>