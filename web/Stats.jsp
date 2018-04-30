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
        body {background-color: white;}
        h1   {color: red;}
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
            String name = temp[0];
            String surname = temp[1];

        %>
        <%
            try {
                String connectionURL = "jdbc:mysql://104.197.152.81:3306/Football";
                Connection connection = null;
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                connection = DriverManager.getConnection(connectionURL, "root", "root");
                if(!connection.isClosed()) {
                    Statement stmt = connection.createStatement();
                    String sqlStr;

                    PreparedStatement read, read1, read2, read3, read4, read4a, read5, read6, read7, read7a, read7b, read7c, read7d, read8, read8a,
                            read9,read9a,read9b,read9c,read9d,read9e,read9f, noOfGames1718;

                    DecimalFormat df2 = new DecimalFormat(".##");

                    int noofgames = 0, noOfHomeGames = 0, noOfAwayGames = 0;
                    int countRows1Home = 0, countRows2Home = 0, countRows3Home = 0, countRows4Home = 0;
                    int sum = 0;
                    int sum1 = 0, sum1a = 0, sum2 = 0, sum2a = 0, sum3 = 0, sum4 = 0, goals_1617 = 0, goalsHome_1617 = 0, goalsAway_1617 = 0,
                            goalsSurname = 0, goalsName = 0, goals_1718 = 0, goalsHome_1718 = 0, goalsAway_1718 = 0, goalsSurname1718 = 0, goalsName1718 = 0;
                    int goals = 0, goals1 = 0, goals1718 = 0, goals1718_1 = 0;
                    String team3 = "", team3a = "", team4 = "";
                    int draws = 0, nameWins = 0, surnameWins = 0;
                    int amountOfCleanSheetsName = 0;
                    int amountOfCleanSheetsSurName = 0;
                    double avgNumberLastSeason = 0.0, avgNumberLastSeasonHome = 0.0, avgNumberLastSeasonAway = 0;
                    double avgNumberThisSeason = 0.0, avgNumberThisSeasonHome = 0.0, avgNumberThisSeasonAway = 0;
                    ResultSet rset ,rset1, rset2, rset3, rset4, rset4a, rset5, rset6, rset7, rset7a, rset7b, rset7c, rset7d, rset8, rset8a,rset9,rset9a,
                            rset9b,rset9c,rset9d,rset9e,rset9f;

                    read = connection.prepareStatement("SELECT * FROM LatestSeason WHERE HomeTeam = ? OR AwayTeam = ? ORDER BY id DESC                                                          LIMIT 5");

                    read1 = connection.prepareStatement("SELECT * FROM LatestSeason WHERE HomeTeam = ? OR AwayTeam = ? ORDER BY id DESC                                                          LIMIT 5");

                    read2 = connection.prepareStatement("SELECT * FROM LatestSeason WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?\n" +
                            "UNION\n" +
                            "SELECT * FROM HistoricalResults WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?");

                    read3 = connection.prepareStatement("SELECT SUM(HomeScore + AwayScore) FROM LatestSeason WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?\n" +
                            "UNION\n" +
                            "SELECT SUM(HomeScore + AwayScore) FROM HistoricalResults WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?");

                    read4 = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore) FROM LatestSeason WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ? \n" +
                            "Group BY AwayTeam, HomeTeam");

                    read4a = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore) FROM HistoricalResults WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ? \n" +
                            "Group BY AwayTeam, HomeTeam");

                    read5 = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(AwayScore) FROM LatestSeason WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ? \n" +
                            "GROUP BY HomeTeam, AwayTeam \n" +
                            "UNION \n" +
                            "SELECT HomeTeam, AwayTeam, SUM(AwayScore) FROM HistoricalResults WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?\n" +
                            "GROUP BY HomeTeam, AwayTeam");

                    read6 = connection.prepareStatement("SELECT * FROM LatestSeason WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?\n" +
                            "UNION\n" +
                            "SELECT * FROM HistoricalResults WHERE HomeTeam = ? AND AwayTeam = ? OR HomeTeam = ? AND AwayTeam = ?\n" +
                            "GROUP BY id \n" +
                            "ORDER BY id\n" +
                            "LIMIT 0 , 5");

                    read7 = connection.prepareStatement("SELECT  SUM(HomeScore + AwayScore)FROM HistoricalResults\n" +
                            "GROUP BY id LIMIT 0 , 380");

                    read7a = connection.prepareStatement("SELECT  SUM(HomeScore)FROM HistoricalResults\n" +
                            "GROUP BY id LIMIT 0 , 380");

                    read7b = connection.prepareStatement("SELECT  SUM(AwayScore)FROM HistoricalResults\n" +
                            "GROUP BY id LIMIT 0 , 380");

                    read7c = connection.prepareStatement("SELECT HomeTeam, SUM(HomeScore) FROM HistoricalResults WHERE HomeTeam = ? GROUP BY id LIMIT 19");

                    read7d = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore), SUM(AwayScore) FROM HistoricalResults WHERE AwayTeam = ? GROUP BY id LIMIT 19");

                    read8 = connection.prepareStatement("SELECT HomeTeam, SUM(HomeScore) FROM HistoricalResults WHERE HomeTeam = ? GROUP BY id LIMIT 19");

                    read8a = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore), SUM(AwayScore) FROM HistoricalResults WHERE AwayTeam = ? GROUP BY id LIMIT 19");

                    read9 = connection.prepareStatement("SELECT SUM(HomeScore + AwayScore) , COUNT(*) FROM LatestSeason");

                    read9a = connection.prepareStatement("SELECT  SUM(HomeScore), COUNT(*) FROM LatestSeason");

                    read9b = connection.prepareStatement("SELECT  SUM(AwayScore), COUNT(*) FROM LatestSeason");

                    read9c = connection.prepareStatement("SELECT HomeTeam, SUM(HomeScore), COUNT(*) FROM LatestSeason WHERE HomeTeam = ?");

                    read9d = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore), SUM(AwayScore), COUNT(*) FROM LatestSeason WHERE AwayTeam = ? GROUP BY id");

                    read9e = connection.prepareStatement("SELECT HomeTeam, SUM(HomeScore), COUNT(*) FROM LatestSeason WHERE HomeTeam = ? GROUP BY id");

                    read9f = connection.prepareStatement("SELECT HomeTeam, AwayTeam, SUM(HomeScore), SUM(AwayScore), COUNT(*) FROM LatestSeason WHERE AwayTeam = ? GROUP BY id");

                    read.setString(1,name);
                    read.setString(2,name);

                    read1.setString(1,surname);
                    read1.setString(2,surname);

                    read2.setString(1,name);
                    read2.setString(2,surname);
                    read2.setString(3,surname);
                    read2.setString(4,name);
                    read2.setString(5,name);
                    read2.setString(6,surname);
                    read2.setString(7,surname);
                    read2.setString(8,name);

                    read3.setString(1,name);
                    read3.setString(2,surname);
                    read3.setString(3,surname);
                    read3.setString(4,name);
                    read3.setString(5,name);
                    read3.setString(6,surname);
                    read3.setString(7,surname);
                    read3.setString(8,name);

                    read4.setString(1,name);
                    read4.setString(2,surname);
                    read4.setString(3,surname);
                    read4.setString(4,name);

                    read4a.setString(1,name);
                    read4a.setString(2,surname);
                    read4a.setString(3,surname);
                    read4a.setString(4,name);

                    read5.setString(1,name);
                    read5.setString(2,surname);
                    read5.setString(3,surname);
                    read5.setString(4,name);
                    read5.setString(5,name);
                    read5.setString(6,surname);
                    read5.setString(7,surname);
                    read5.setString(8,name);

                    read6.setString(1,name);
                    read6.setString(2,surname);
                    read6.setString(3,surname);
                    read6.setString(4,name);
                    read6.setString(5,name);
                    read6.setString(6,surname);
                    read6.setString(7,surname);
                    read6.setString(8,name);

                    read7c.setString(1,name);
                    read7d.setString(1,surname);

                    read8.setString(1,surname);
                    read8a.setString(1,name);

                    read9c.setString(1,name);
                    read9d.setString(1,surname);

                    read9e.setString(1,surname);
                    read9f.setString(1,name);

                    rset = read.executeQuery();
                    rset1 = read1.executeQuery();
                    rset2 = read2.executeQuery();
                    rset3 = read3.executeQuery();
                    rset4 = read4.executeQuery();
                    rset4a = read4a.executeQuery();
                    rset5 = read5.executeQuery();
                    rset6 = read6.executeQuery();
                    rset7 = read7.executeQuery();
                    rset7a = read7a.executeQuery();
                    rset7b = read7b.executeQuery();
                    rset7c = read7c.executeQuery();
                    rset7d = read7d.executeQuery();
                    rset8 = read8.executeQuery();
                    rset8a = read8a.executeQuery();
                    rset9 = read9.executeQuery();
                    rset9a = read9a.executeQuery();
                    rset9b = read9b.executeQuery();
                    rset9c = read9c.executeQuery();
                    rset9d = read9d.executeQuery();
                    rset9e = read9e.executeQuery();
                    rset9f = read9f.executeQuery();

                    out.println("<div class=\"a\">");
                    out.println("<h1>");
                    out.println("<IMG SRC=\"/images/"+name+".png\"height=\"42\" width=\"42\">");
                    out.println(name+"'s Last 5 Results");
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
                    while (rset.next()){
                        out.println("<td>"+rset.getString("HomeTeam")+"</td>");
                        out.println("<td>"+rset.getString("AwayTeam")+"</td>");
                        out.println("<td>"+rset.getInt("HomeScore")+"</td>");
                        out.println("<td>"+rset.getInt("AwayScore")+"</td>");
                        out.println("<td>"+rset.getString("Winner")+"</td>");
                        out.println("</tr>");

                        String form = rset.getString("Winner");

                        if(form.equals(name)){
                            out.println("<font color=\"lime\">W</font>");
                        }
                        else if(form.equals("Draw")){
                            out.println("<font color=\"orange\">D</font>");
                        }
                        else
                        {
                            out.println("<font color=\"red\">L</font>");
                        }
                    }
                    out.println("</table>");

                    out.println("<div class=\"a\">");
                    out.println("<h1>");
                    out.println("<IMG SRC=\"/images/"+surname+".png\"height=\"42\" width=\"42\">");
                    out.println(surname+"'s Last 5 Results");
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
                    while (rset1.next()){
                        out.println("<td>"+rset1.getString("HomeTeam")+"</td>");
                        out.println("<td>"+rset1.getString("AwayTeam")+"</td>");
                        out.println("<td>"+rset1.getInt("HomeScore")+"</td>");
                        out.println("<td>"+rset1.getInt("AwayScore")+"</td>");
                        out.println("<td>"+rset1.getString("Winner")+"</td>");
                        out.println("</tr>");

                        String form1 = rset1.getString("Winner");

                        if(form1.equals(surname)){
                            out.println("<font color=\"lime\">W</font>");
                        }
                        else if(form1.equals("Draw")){
                            out.println("<font color=\"orange\">D</font>");
                        }
                        else
                        {
                            out.println("<font color=\"red\">L</font>");
                        }
                    }
                    out.println("</table>");

                    while (rset2.next()){

                        String home1 = rset2.getString("HomeTeam");
                        String home2 = rset2.getString("AwayTeam");

                        int count1 = rset2.getInt("HomeScore");
                        int count2 = rset2.getInt("AwayScore");

                        noofgames++;

                        String result = rset2.getString("Winner");

                        if(result.equals(name)){
                            nameWins++;
                        }
                        else if(result.equals(surname)){
                            surnameWins++;
                        }
                        else
                        {
                            draws++;
                        }

                        if(Objects.equals(home1, name)){
                            noOfHomeGames++;

                            if(count1==0||count2==0){
                                amountOfCleanSheetsName++;
                            }
                        }

                        if(Objects.equals(home1, surname)){
                            noOfAwayGames++;

                            if(count1==0||count2==0){
                                amountOfCleanSheetsSurName++;
                            }
                        }
                    }

                    out.println("<div class=\"a\">");
                    out.println("<h1>Lastest Fixtures Between "+name+" and "+surname+"</h1>");
                    out.println("</div>");
                    out.println("<table border = \"1\" width = \"100%\">\n" +
                            "    <tr>\n" +
                            "        <th>Home Team</th>\n" +
                            "        <th>Away Team</th>\n" +
                            "        <th>Home Score</th>\n" +
                            "        <th>Away Score</th>\n" +
                            "        <th>Winner</th>\n" +
                            "</tr>");
                    while (rset6.next()){
                        out.println("<td>"+rset6.getString("HomeTeam")+"</td>");
                        out.println("<td>"+rset6.getString("AwayTeam")+"</td>");
                        out.println("<td>"+rset6.getInt("HomeScore")+"</td>");
                        out.println("<td>"+rset6.getInt("AwayScore")+"</td>");
                        out.println("<td>"+rset6.getString("Winner")+"</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");

                    while (rset3.next()){

                        int c = rset3.getInt(1);
                        sum = sum + c;
                    }

                    while (rset7.next()){

                        int c = rset7.getInt(1);
                        goals_1617 = goals_1617 + c;

                        avgNumberLastSeason = goals_1617/(double)380;
                    }

                    while (rset7a.next()){

                        int c = rset7a.getInt(1);
                        goalsHome_1617 = goalsHome_1617 + c;

                        avgNumberLastSeasonHome = goalsHome_1617/(double)380;
                    }

                    while (rset7b.next()){

                        int c = rset7b.getInt(1);
                        goalsAway_1617 = goalsAway_1617 + c;

                        avgNumberLastSeasonAway = goalsAway_1617/(double)380;
                    }

                    while (rset7c.next()){

                        int c = rset7c.getInt(2);
                        goals = goals + c;
                    }

                    while (rset7d.next()){

                        int c = rset7d.getInt(3);
                        goals1 = goals1 + c;
                    }

                    while (rset8.next()){

                        int c = rset8.getInt(2);
                        goalsSurname = goalsSurname + c;
                    }

                    while (rset8a.next()){

                        int c = rset8a.getInt(3);
                        goalsName = goalsName + c;
                    }

                    while (rset9.next()){

                        int c = rset9.getInt(1);
                        int getRows = rset9.getInt(2);
                        goals_1718 = goals_1718 + c;

                        avgNumberThisSeason = goals_1718/(double)getRows;
                    }

                    while (rset9a.next()){

                        int c = rset9a.getInt(1);
                        int getRows = rset9a.getInt(2);
                        goalsHome_1718 = goalsHome_1718 + c;

                        avgNumberThisSeasonHome = goalsHome_1718/(double)getRows;
                    }

                    while (rset9b.next()){

                        int c = rset9b.getInt(1);
                        int getRows = rset9b.getInt(2);
                        goalsAway_1718 = goalsAway_1718 + c;

                        avgNumberThisSeasonAway = goalsAway_1718/(double)getRows;
                    }

                    while (rset9c.next()){

                        int c = rset9c.getInt(2);
                        countRows1Home = rset9c.getInt(3);
                        goals1718 = goals1718 + c;
                    }

                    while (rset9d.next()){

                        int c = rset9d.getInt(3);
                        int countRows2 = rset9d.getInt(5);
                        countRows2Home = countRows2Home+countRows2;
                        goals1718_1 = goals1718_1 + c;
                    }

                    while (rset9e.next()){

                        int c = rset9e.getInt(2);
                        int countRows3 = rset9e.getInt(3);
                        countRows3Home = countRows3Home+countRows3;
                        goalsSurname1718 = goalsSurname1718 + c;
                    }

                    while (rset9f.next()){

                        int c = rset9f.getInt(3);
                        int countRows4 = rset9f.getInt(5);
                        countRows4Home = countRows4Home+countRows4;
                        goalsName1718 = goalsName1718 + c;
                    }

                    while (rset4.next()){

                        team3 = rset4.getString("HomeTeam");

                        if(team3.equals(name)){
                            int c1 = rset4.getInt(3);
                            sum1 = sum1 + c1;
                        }

                        if(team3.equals(surname)){
                            int c2 = rset4.getInt(3);
                            sum2 = sum2 + c2;
                        }
                    }

                    while (rset4a.next()){

                        team3a = rset4a.getString("HomeTeam");

                        if(team3a.equals(name)){
                            int c1a = rset4a.getInt(3);
                            sum1a = sum1a + c1a;
                        }

                        if(team3a.equals(surname)){
                            int c2a = rset4a.getInt(3);
                            sum2a = sum2a + c2a;
                        }
                    }

                    while (rset5.next()){

                        team4 = rset5.getString("AwayTeam");

                        if(team4.equals(name)){
                            int c3 = rset5.getInt(3);
                            sum3 = sum3 + c3;
                        }

                        if(team4.equals(surname)){
                            int c4 = rset5.getInt(3);
                            sum4 = sum4 + c4;
                        }
                    }

                    int score1 = sum1+sum1a;
                    int score2 = sum2+sum2a;

                    int totalGoals1 = score1+sum3;
                    int totalGoals2 = score2+sum4;
                    double totalAvg = sum / (double)noofgames;
                    double totalAvg1 = totalGoals1 / (double)noofgames;
                    double totalAvg2 = totalGoals2 / (double)noofgames;

                    /* This is to do with 2016/17 season*/
                    double concededavgLastSeasonHome = avgNumberLastSeasonAway;
                    double concededavgLastSeasonAway = avgNumberLastSeasonHome;

                    double result = (double)goals/19;
                    double teamAttackStrength = result/avgNumberLastSeasonHome;

                    double result1 = (double)goals1/19;
                    double teamDefenceStrength = result1/concededavgLastSeasonAway;

                    double result2 = (double)goalsSurname/19;
                    double teamAttackStrengthSurname = result2/avgNumberLastSeasonAway;

                    double result3 = (double)goalsName/19;
                    double teamDefenceStrengthName = result3/concededavgLastSeasonAway;

                    double predictedGoal = teamAttackStrength*teamDefenceStrength*avgNumberLastSeasonHome;
                    double predictedGoal1 = teamAttackStrengthSurname*teamDefenceStrengthName*avgNumberLastSeasonAway;

                    double fact=1;
                    double fact1=1;
                    List<Double> list = new ArrayList<Double>();
                    List<Double> list1 = new ArrayList<Double>();

                    double concededavgThisSeasonHome = avgNumberThisSeasonAway;
                    double concededavgThisSeasonAway = avgNumberThisSeasonHome;

                    double resultThisSeason = (double)goals1718/countRows1Home;
                    double teamAttackStrengthThisSeason = resultThisSeason/avgNumberThisSeasonHome;

                    double resultThisSeason1 = (double)goals1718_1/countRows2Home;
                    double teamDefenceStrengthThisSeason = resultThisSeason1/concededavgThisSeasonAway;

                    double result2ThisSeason = (double)goalsSurname1718/countRows3Home;
                    double teamAttackStrengthSurnameThisSeason = result2ThisSeason/avgNumberThisSeasonAway;

                    double result3ThisSeason = (double)goalsName1718/countRows4Home;
                    double teamDefenceStrengthNameThisSeason = result3ThisSeason/concededavgThisSeasonAway;

                    double predictedGoalThisSeason = teamAttackStrengthThisSeason*teamDefenceStrengthThisSeason*avgNumberThisSeasonHome;
                    double predictedGoal1ThisSeason = teamAttackStrengthSurnameThisSeason*teamDefenceStrengthNameThisSeason*avgNumberThisSeasonAway;

                    double fact12=1;
                    double fact13=1;
                    List<Double> list12 = new ArrayList<Double>();
                    List<Double> list13 = new ArrayList<Double>();

                    for (double i = 0; i <=5; i++) {
                        fact = fact * i;
                        if(fact==0)
                        {
                            fact = fact + 1;
                        }
                        double calc = Math.pow(predictedGoal, i);
                        double exp1 = Math.exp(-predictedGoal);
                        double sn = calc * exp1;
                        double calco = sn / fact;
                        double calco1 = calco * 100;
                        list.add(calco1);
                    }

                    for (double i = 0; i <=5; i++) {
                        fact1=fact1*i;
                        if(fact1==0)
                        {
                            fact1 = fact1 + 1;
                        }
                        double calc1 = Math.pow(predictedGoal1,i);
                        double exp2 = Math.exp(-predictedGoal1);
                        double sn1 = calc1*exp2;
                        double calco1 = sn1/fact1;
                        double calco2 = calco1*100;
                        list1.add(calco2);
                    }

                    double obj = Collections.max(list);
                    double obj1 = Collections.max(list1);
                    int index = list.indexOf(obj);
                    int index1 = list1.indexOf(obj1);
                    System.out.println("Goals1617 Home: "+index);
                    System.out.println("Goals1617 Away: "+index1);

                    for (double i = 0; i <=5; i++) {
                        fact12 = fact12 * i;
                        if(fact12==0)
                        {
                            fact12 = fact12 + 1;
                        }
                        double calc = Math.pow(predictedGoalThisSeason, i);
                        double exp1 = Math.exp(-predictedGoalThisSeason);
                        double sn = calc * exp1;
                        double calco = sn / fact12;
                        double calco1 = calco * 100;
                        list12.add(calco1);
                    }

                    for (double i = 0; i <=5; i++) {
                        fact13=fact13*i;
                        if(fact13==0)
                        {
                            fact13 = fact13 + 1;
                        }
                        double calc1 = Math.pow(predictedGoal1ThisSeason,i);
                        double exp2 = Math.exp(-predictedGoal1ThisSeason);
                        double sn1 = calc1*exp2;
                        double calco1 = sn1/fact13;
                        double calco2 = calco1*100;
                        list13.add(calco2);
                    }

                    double obj12 = Collections.max(list12);
                    double obj13 = Collections.max(list13);
                    int index12 = list12.indexOf(obj12);
                    int index13 = list13.indexOf(obj13);

                    int actualResult = (index+index12)/2;
                    int actualResult1 = (index1+index13)/2;

        %>
        <div class="a">
            <h1>
                <b><u><%="Prediction For "+name+" Against "+surname%></u></b>
            </h1>
        </div>
        <table style="border:4px solid red;">
            <tr>
                <th>Statistic</th>
                <th><%=name%></th>
                <th><%=surname%></th>
            </tr>
            <tr>
                <td>Predicted Result</td>
                <th><%=actualResult%></th>
                <th><%=actualResult1%></th>
        </table>

        <div class="a">
            <h1>
                <%="Statistics Between "+name+" and "+surname%>
            </h1>
        </div>
        <table>
            <tr>
                <th>Statistic</th>
                <th><%=name%></th>
                <th><%=surname%></th>
            </tr>
            <tr>
                <td>Clean Sheets</td>
                <td><%=amountOfCleanSheetsName%></td>
                <td><%=amountOfCleanSheetsSurName%></td>
            </tr>
            <tr>
                <td>Avg Amount of Goals Per Game</td>
                <td><%=df2.format(totalAvg1)%></td>
                <td><%=df2.format(totalAvg2)%></td>
            </tr>
            <tr>
                <td>Total Amount of Goals Against Opponent</td>
                <td><%=totalGoals1%></td>
                <td><%=totalGoals2%></td>
            </tr>
            <tr>
                <td>Total Home Goals Against Opponent</td>
                <td><%=score1%></td>
                <td><%=score2%></td>
            </tr>
            <tr>
                <td>Total Away Goals Against Opponent</td>
                <td><%=sum3%></td>
                <td><%=sum4%></td>
            </tr>
        </table>

        <div class="a">
            <h1>
                <%="Overall Statistics For "+name+" Against "+surname%>
            </h1>
        </div>
        <table>
            <tr>
                <th>Statistic</th>
                <th>Value</th>
            </tr>
            <tr>
                <td>Total Number of Goals</td>
                <td><%=sum%></td>
            </tr>
            <tr>
                <td>Total Number of Games</td>
                <td><%=noofgames%></td>
            </tr>
            <tr>
                <td>Total Avg Amount of Goals Per Game</td>
                <td><%=df2.format(totalAvg)%></td>
            </tr>
            <tr>
                <td>Total Number of Draws</td>
                <td><%=draws%></td>
            </tr>
            <tr>
                <td><%=name%> Total Wins</td>
                <td><%=nameWins%></td>
            </tr>
            <tr>
                <td><%=surname%> Total Wins</td>
                <td><%=surnameWins%></td>
            </tr>
        </table>

        <div class="a">
            <h1>
                <img src="/images/PremierLeague.png" style="width:60px;height:30px;" />
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
                <td><%=goals_1718%></td>
            </tr>
            <tr>
                <td>Total Amount of Home Goals 2017/18</td>
                <td><%=goalsHome_1718%></td>
            </tr>
            <tr>
                <td>Total Amount of Away Goals 2017/18</td>
                <td><%=goalsAway_1718%></td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored In Total 2017/18</td>
                <td><%=df2.format(avgNumberThisSeason)%></td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored Home 2017/18</td>
                <td><%=df2.format(avgNumberThisSeasonHome)%></td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored Away 2017/18</td>
                <td><%=df2.format(avgNumberThisSeasonAway)%></td>
            </tr>
            <tr>
                <td>Average Number of Goals Conceded Home 2017/18</td>
                <td><%=df2.format(concededavgThisSeasonHome)%></td>
            </tr>
            <tr>
                <td>Average Number of Goals Conceded Away 2017/18</td>
                <td><%=df2.format(concededavgThisSeasonAway)%></td>
            </tr>
            <tr>
                <td><%=name%> Goals Scored at Home This Season</td>
                <td><%=goals1718%></td>
            </tr>
            <tr>
                <td><%=surname%> Goals Conceded Away From Home This Season</td>
                <td><%=goals1718_1%></td>
            </tr>
            <tr>
                <td><%=surname%> Goals Scored at Home This Season</td>
                <td><%=goalsSurname1718%></td>
            </tr>
            <tr>
                <td><%=name%> Goals Conceded Away From Home This Season</td>
                <td><%=goalsName1718%></td>
            </tr>
        </table>

        <div class="a">
            <h1>
                <img src="/images/PremierLeague.png" style="width:60px;height:30px;" />
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
                <td><%=goals_1617%></td>
            </tr>
            <tr>
                <td>Total Amount of Home Goals 2016/17</td>
                <td><%=goalsHome_1617%></td>
            </tr>
            <tr>
                <td>Total Amount of Away Goals 2016/17</td>
                <td><%=goalsAway_1617%></td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored In Total 2016/17</td>
                <td><%=df2.format(avgNumberLastSeason)%></td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored Home 2016/17</td>
                <td><%=df2.format(avgNumberLastSeasonHome)%></td>
            </tr>
            <tr>
                <td>Average Number of Goals Scored Away 2016/17</td>
                <td><%=df2.format(avgNumberLastSeasonAway)%></td>
            </tr>
            <tr>
                <td>Average Number of Goals Conceded Home 2016/17</td>
                <td><%=df2.format(concededavgLastSeasonHome)%></td>
            </tr>
            <tr>
                <td>Average Number of Goals Conceded Away 2016/17</td>
                <td><%=df2.format(concededavgLastSeasonAway)%></td>
            </tr>
            <tr>
                <td><%=name%> Goals Scored at Home Last Season</td>
                <td><%=goals%></td>
            </tr>
            <tr>
                <td><%=surname%> Goals Conceded Away From Home Last Season</td>
                <td><%=goals1%></td>
            </tr>
            <tr>
                <td><%=surname%> Goals Scored at Home Last Season</td>
                <td><%=goalsSurname%></td>
            </tr>
            <tr>
                <td><%=name%> Goals Conceded Away From Home Last Season</td>
                <td><%=goalsName%></td>
            </tr>
        </table>

        <div class="a">
            <h1>
                <%="Chart Representation of Fixture"%>
            </h1>
        </div>

        <table class="columns">
            <tr>
                <td><div id="piechart" style="border: 1px solid #ccc"></div></td>
                <td><div id="piechart1" style="border: 1px solid #ccc"></div></td>
                <td><div id="piechart2" style="border: 1px solid #ccc"></div></td>
            </tr>
        </table>
        <script type="text/javascript">
            // Load google charts
            google.charts.load('current', {'packages':['corechart']});
            google.charts.setOnLoadCallback(drawChart);

            // Draw the chart and set the chart values
            function drawChart() {
                var data = google.visualization.arrayToDataTable([
                    ['Task1', 'Average Goals'],
                    ['Total Avg Goals Per Game', <%=totalAvg%>],
                    ['Avg Goals Per Game For <%=name%>', <%=df2.format(totalAvg1)%>],
                    ['Avg Goals Per Game For <%=surname%>', <%=df2.format(totalAvg1)%>]
                ]);

                // Optional; add a title and set the width and height of the chart
                var options = {'title':'Average Goals', 'width':400, 'height':300};

                // Display the chart inside the <div> element with id="piechart"
                var chart = new google.visualization.PieChart(document.getElementById('piechart'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            // Load google charts
            google.charts.load('current', {'packages':['corechart']});
            google.charts.setOnLoadCallback(drawChart);

            // Draw the chart and set the chart values
            function drawChart() {
                var data = google.visualization.arrayToDataTable([
                    ['Task1', 'Results'],
                    ['<%=name%> Wins', <%=nameWins%>],
                    ['Draws', <%=draws%>],
                    ['<%=surname%> Wins', <%=surnameWins%>]
                ]);

                // Optional; add a title and set the width and height of the chart
                var options = {'title':'Results', 'width':400, 'height':300};

                // Display the chart inside the <div> element with id="piechart"
                var chart = new google.visualization.PieChart(document.getElementById('piechart1'));
                chart.draw(data, options);
            }
        </script>

        <script type="text/javascript">
            // Load google charts
            google.charts.load('current', {'packages':['corechart']});
            google.charts.setOnLoadCallback(drawChart);

            // Draw the chart and set the chart values
            function drawChart() {
                var data = google.visualization.arrayToDataTable([
                    ['Task1', 'Total Amount of Goals'],
                    ['Total Goals For <%=name%> Against <%=surname%>', <%=totalGoals1%>],
                    ['Total Goals For <%=surname%> Against <%=name%>', <%=totalGoals2%>]
                ]);

                // Optional; add a title and set the width and height of the chart
                var options = {'title':'Total Amount of Goals', 'width':400, 'height':300};

                // Display the chart inside the <div> element with id="piechart"
                var chart = new google.visualization.PieChart(document.getElementById('piechart2'));
                chart.draw(data, options);
            }
        </script>

        <%connection.close();
        }

        }catch(Exception ex){
            out.println("Unable to connect to database"+ex);
        }

        %>
    </div>
</form>
</body>
</html>