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

                    PreparedStatement last5HomeTeam, last5AwayTeam, noOfGames, totalGoals, homeGoalsCS, homeGoalsPS, awayGoalsCSPS,                                             resultsBetHomeAway, totalGoalsLS, totalHomeGoalsLS, totalAwayGoalsLS, homeGoalsLSHT,                                                      goalsConcededAwayLSAT, homeGoalsLSAT, goalConcededAwayLSHT, totalGoalsCS, totalHomeGoalsCS,                                               totalAwayGoalsCS, homeGoalsCSHT, goalsConcededAwayCSAT, homeGoalsCSAT, goalsConcededAwayCSHT;

                    int totalNoOfGames = 0, totalNoOfGamesBetHomeAway = 0;
                    int countNoHomeGamesHT = 0, countNoAwayGamesAT = 0, countNoHomeGamesAT = 0, countNoAwayGamesHT = 0;
                    int sumOfHomeGoalsCSHT = 0, sumOfHomeGoalsPSHT = 0, sumOfAwayGoalsCSAT = 0, sumOfHomeGoalsPSAT = 0, sumOfAwayGoalsHT = 0, sumOfAwayGoalsAT = 0, goals_1617 = 0, goalsHome_1617 = 0, goalsAway_1617 = 0,
                            goalsAtHomeLSAT = 0, goalsConAwayLSHT = 0, goals_1718 = 0, goalsHome_1718 = 0, goalsAway_1718 = 0, goalsAtHomeCSAT = 0, goalsConAwayCSHT = 0;
                    int goalsAtHomeLSHT = 0, goalsConAwayLSAT = 0, goalsAtHomeCSHT = 0, goalsConAwayCSAT = 0;
                    int amtOfDrawsHTAT = 0, homeTeamWins = 0, awayTeamWins = 0;
                    int amountOfCleanSheetsName = 0;
                    int amountOfCleanSheetsSurName = 0;
                    double avgNumberLastSeason = 0.0, avgNumberLastSeasonHome = 0.0, avgNumberLastSeasonAway = 0;
                    double avgNumberThisSeason = 0.0, avgNumberThisSeasonHome = 0.0, avgNumberThisSeasonAway = 0;
                    ResultSet rset, rset1, rset2, rset3, rset4, rset4a, rset5, rset6, rset7, rset7a, rset7b, rset7c, rset7d, rset8, rset8a, rset9, rset9a,
                            rset9b, rset9c, rset9d, rset9e, rset9f;


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

                    rset = last5HomeTeam.executeQuery();
                    rset1 = last5AwayTeam.executeQuery();
                    rset2 = noOfGames.executeQuery();
                    rset3 = totalGoals.executeQuery();
                    rset4 = homeGoalsCS.executeQuery();
                    rset4a = homeGoalsPS.executeQuery();
                    rset5 = awayGoalsCSPS.executeQuery();
                    rset6 = resultsBetHomeAway.executeQuery();
                    rset7 = totalGoalsLS.executeQuery();
                    rset7a = totalHomeGoalsLS.executeQuery();
                    rset7b = totalAwayGoalsLS.executeQuery();
                    rset7c = homeGoalsLSHT.executeQuery();
                    rset7d = goalsConcededAwayLSAT.executeQuery();
                    rset8 = homeGoalsLSAT.executeQuery();
                    rset8a = goalConcededAwayLSHT.executeQuery();
                    rset9 = totalGoalsCS.executeQuery();
                    rset9a = totalHomeGoalsCS.executeQuery();
                    rset9b = totalAwayGoalsCS.executeQuery();
                    rset9c = homeGoalsCSHT.executeQuery();
                    rset9d = goalsConcededAwayCSAT.executeQuery();
                    rset9e = homeGoalsCSAT.executeQuery();
                    rset9f = goalsConcededAwayCSHT.executeQuery();

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
                    while (rset.next()) {
                        out.println("<td>" + rset.getString("HomeTeam") + "</td>");
                        out.println("<td>" + rset.getString("AwayTeam") + "</td>");
                        out.println("<td>" + rset.getInt("HomeScore") + "</td>");
                        out.println("<td>" + rset.getInt("AwayScore") + "</td>");
                        out.println("<td>" + rset.getString("Winner") + "</td>");
                        out.println("</tr>");

                        //Getting Recent Form of Home Team
                        String form = rset.getString("Winner");

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
                    while (rset1.next()) {
                        out.println("<td>" + rset1.getString("HomeTeam") + "</td>");
                        out.println("<td>" + rset1.getString("AwayTeam") + "</td>");
                        out.println("<td>" + rset1.getInt("HomeScore") + "</td>");
                        out.println("<td>" + rset1.getInt("AwayScore") + "</td>");
                        out.println("<td>" + rset1.getString("Winner") + "</td>");
                        out.println("</tr>");

                        //Getting Recent Form of Away Team
                        String form1 = rset1.getString("Winner");

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
                    while (rset2.next()) {

                        String home1 = rset2.getString("HomeTeam");
                        String home2 = rset2.getString("AwayTeam");

                        int count1 = rset2.getInt("HomeScore");
                        int count2 = rset2.getInt("AwayScore");

                        totalNoOfGames++;

                        String result = rset2.getString("Winner");

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
                    while (rset6.next()) {
                        out.println("<td>" + rset6.getString("HomeTeam") + "</td>");
                        out.println("<td>" + rset6.getString("AwayTeam") + "</td>");
                        out.println("<td>" + rset6.getInt("HomeScore") + "</td>");
                        out.println("<td>" + rset6.getInt("AwayScore") + "</td>");
                        out.println("<td>" + rset6.getString("Winner") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");

                    //Getting Total Number of Goals Between Home and Away Teams From 2016/17 and 2017/18 Season
                    while (rset3.next()) {

                        int c = rset3.getInt(1);
                        totalNoOfGamesBetHomeAway = totalNoOfGamesBetHomeAway + c;
                    }

                    //Getting Total Number of Goals 2016/17 Season
                    while (rset7.next()) {

                        int c = rset7.getInt(1);
                        goals_1617 = goals_1617 + c;

                        //Average Number of Goals Scored Away 2016/17
                        avgNumberLastSeason = goals_1617 / (double) 380; //Diving by the amount of games in a season
                    }

                    //Getting Total Number of Home Goals 2016/17 Season
                    while (rset7a.next()) {

                        int c = rset7a.getInt(1);
                        goalsHome_1617 = goalsHome_1617 + c;

                        //Average Number of Goals Scored Home 2016/17
                        avgNumberLastSeasonHome = goalsHome_1617 / (double) 380;
                    }

                    //Getting Total Number of Away Goals 2016/17 Season
                    while (rset7b.next()) {

                        int c = rset7b.getInt(1);
                        goalsAway_1617 = goalsAway_1617 + c;

                        //Average Number of Goals Scored Away 2016/17
                        avgNumberLastSeasonAway = goalsAway_1617 / (double) 380;
                    }

                    //Amount of Home Goals Scored in 2016/17 Season From Home Team
                    while (rset7c.next()) {

                        int c = rset7c.getInt(2);
                        goalsAtHomeLSHT = goalsAtHomeLSHT + c;
                    }

                    //Amount of Goals Conceded By Away Team Away From Home in 2016/17 Season
                    while (rset7d.next()) {

                        int c = rset7d.getInt(3);
                        goalsConAwayLSAT = goalsConAwayLSAT + c;
                    }

                    //Amount of Home Goals Scored in 2016/17 Season From Away Team
                    while (rset8.next()) {

                        int c = rset8.getInt(2);
                        goalsAtHomeLSAT = goalsAtHomeLSAT + c;
                    }

                    //Amount of Goals Conceded By Home Team Away From Home in 2016/17 Season
                    while (rset8a.next()) {

                        int c = rset8a.getInt(3);
                        goalsConAwayLSHT = goalsConAwayLSHT + c;
                    }

                    //Getting Total Number of Goals 2017/18 Season
                    while (rset9.next()) {

                        int c = rset9.getInt(1);
                        int getCurrentGamesPlayed = rset9.getInt(2);
                        goals_1718 = goals_1718 + c;

                        //Average Number of Goals Scored 2017/18
                        avgNumberThisSeason = goals_1718 / (double) getCurrentGamesPlayed; //Divided By The Number of Games Played Currently This Season
                    }

                    //Getting Total Number of Home Goals 2017/18 Season
                    while (rset9a.next()) {

                        int c = rset9a.getInt(1);
                        int getCurrentGamesPlayed = rset9a.getInt(2);
                        goalsHome_1718 = goalsHome_1718 + c;

                        //Average Number of Goals Scored Home 2017/18
                        avgNumberThisSeasonHome = goalsHome_1718 / (double) getCurrentGamesPlayed; //Divided By The Number of Games Played at Home Currently This Season
                    }

                    //Getting Total Number of Away Goals 2017/18 Season
                    while (rset9b.next()) {

                        int c = rset9b.getInt(1);
                        int getCurrentGamesPlayed = rset9b.getInt(2);
                        goalsAway_1718 = goalsAway_1718 + c;

                        //Average Number of Goals Scored Away 2017/18
                        avgNumberThisSeasonAway = goalsAway_1718 / (double) getCurrentGamesPlayed; //Divided By The Number of Games Played Away from Home Currently This Season
                    }

                    //Amount of Home Goals Scored in 2017/18 Season From Home Team
                    while (rset9c.next()) {

                        int c = rset9c.getInt(2);
                        countNoHomeGamesHT = rset9c.getInt(3); //Counting Number of Home Games Played This Season for Home Team
                        goalsAtHomeCSHT = goalsAtHomeCSHT + c;
                    }

                    //Amount of Goals Conceded By Away Team Away From Home in 2017/18 Season
                    while (rset9d.next()) {

                        int c = rset9d.getInt(3);
                        int count = rset9d.getInt(5);
                        countNoAwayGamesAT = countNoAwayGamesAT + count; //Counting Number of Away Games Played This Season For Away Team
                        goalsConAwayCSAT = goalsConAwayCSAT + c;
                    }

                    //Amount of Home Goals Scored in 2017/18 Season From Away Team
                    while (rset9e.next()) {

                        int c = rset9e.getInt(2);
                        int count = rset9e.getInt(3);
                        countNoHomeGamesAT = countNoHomeGamesAT + count; //Counting Number of Home Games Played This Season For Away Team
                        goalsAtHomeCSAT = goalsAtHomeCSAT + c;
                    }

                    //Amount of Goals Conceded By Home Team Away From Home in 2017/18 Season
                    while (rset9f.next()) {

                        int c = rset9f.getInt(3);
                        int count = rset9f.getInt(5);
                        countNoAwayGamesHT = countNoAwayGamesHT + count; //Counting Number of Away Games Played This Season For Home Team
                        goalsConAwayCSHT = goalsConAwayCSHT + c;
                    }

                    //Home Goals Current Season Against Opponent
                    while (rset4.next()) {

                        String amtGoalsHome = rset4.getString("HomeTeam");

                        //Getting Amount of Goals for Home Team At Home
                        if (amtGoalsHome.equals(homeTeam)) {
                            int c = rset4.getInt(3);
                            sumOfHomeGoalsCSHT = sumOfHomeGoalsCSHT + c;
                        }

                        //Getting Amount of Goals for Away Team At Home
                        if (amtGoalsHome.equals(awayTeam)) {
                            int c = rset4.getInt(3);
                            sumOfAwayGoalsCSAT = sumOfAwayGoalsCSAT + c;
                        }
                    }

                    //Home Goals From Previous Seasons Against Opponent
                    while (rset4a.next()) {

                        String amtGoalsHomePS = rset4a.getString("HomeTeam");

                        //Getting Amount of Goals for Home Team At Home
                        if (amtGoalsHomePS.equals(homeTeam)) {
                            int c = rset4a.getInt(3);
                            sumOfHomeGoalsPSHT = sumOfHomeGoalsPSHT + c;
                        }

                        //Getting Amount of Goals for Home Team At Home
                        if (amtGoalsHomePS.equals(awayTeam)) {
                            int c = rset4a.getInt(3);
                            sumOfHomeGoalsPSAT = sumOfHomeGoalsPSAT + c;
                        }
                    }

                    //Home Goals From Previous Seasons and Current Season Against Opponent
                    while (rset5.next()) {

                        String amtGoalsAwayPSCS = rset5.getString("AwayTeam");

                        //Getting Amount of Goals for Home Team Away From Home
                        if (amtGoalsAwayPSCS.equals(homeTeam)) {
                            int c = rset5.getInt(3);
                            sumOfAwayGoalsHT = sumOfAwayGoalsHT + c;
                        }

                        //Getting Amount of Goals for Away Team Away From Home
                        if (amtGoalsAwayPSCS.equals(awayTeam)) {
                            int c = rset5.getInt(3);
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

                    double fact = 1;
                    double fact1 = 1;
                    double fact12 = 1;
                    double fact13 = 1;

                    //Arraylist to Hold Predicted Outcomes
                    List<Double> listLSHT = new ArrayList<Double>();
                    List<Double> listLSAT = new ArrayList<Double>();
                    List<Double> listCSHT = new ArrayList<Double>();
                    List<Double> listCSAT = new ArrayList<Double>();

                    //Poisson Distribution - Predicting Multiple Outcomes
                    for (double i = 0; i <= 5; i++) {
                        fact = fact * i;
                        if (fact == 0) {
                            fact = fact + 1;
                        }
                        double calc = Math.pow(predictedGoalLSHT, i);
                        double exp1 = Math.exp(-predictedGoalLSHT);
                        double sn = calc * exp1;
                        double calco = sn / fact;
                        double calco1 = calco * 100;
                        listLSHT.add(calco1);
                    }

                    //Poisson Distribution - Predicting Multiple Outcomes
                    for (double i = 0; i <= 5; i++) {
                        fact1 = fact1 * i;
                        if (fact1 == 0) {
                            fact1 = fact1 + 1;
                        }
                        double calc1 = Math.pow(predictedGoalLSAT, i);
                        double exp2 = Math.exp(-predictedGoalLSAT);
                        double sn1 = calc1 * exp2;
                        double calco1 = sn1 / fact1;
                        double calco2 = calco1 * 100;
                        listLSAT.add(calco2);
                    }

                    //Poisson Distribution - Predicting Multiple Outcomes
                    for (double i = 0; i <= 5; i++) {
                        fact12 = fact12 * i;
                        if (fact12 == 0) {
                            fact12 = fact12 + 1;
                        }
                        double calc = Math.pow(predictedGoalCSHT, i);
                        double exp1 = Math.exp(-predictedGoalCSHT);
                        double sn = calc * exp1;
                        double calco = sn / fact12;
                        double calco1 = calco * 100;
                        listCSHT.add(calco1);
                    }

                    //Poisson Distribution - Predicting Multiple Outcomes
                    for (double i = 0; i <= 5; i++) {
                        fact13 = fact13 * i;
                        if (fact13 == 0) {
                            fact13 = fact13 + 1;
                        }
                        double calc1 = Math.pow(predictedGoalCSAT, i);
                        double exp2 = Math.exp(-predictedGoalCSAT);
                        double sn1 = calc1 * exp2;
                        double calco1 = sn1 / fact13;
                        double calco2 = calco1 * 100;
                        listCSAT.add(calco2);
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