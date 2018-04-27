<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
    <title>Premier League Fixtures</title>

    <style>
        table tr:not(:first-child){
            cursor: pointer;transition: all .25s ease-in-out;
        }
        table tr:not(:first-child):hover{background-color: #ff0000;}
    </style>

    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            text-align: left;
            padding: 8px;
        }

        tr:nth-child(even){background-color: #f2f2f2}

        th {
            background-color: #ff0000;
            color: white;
        }
    </style>
</head>
<body>
<form id="myform" name="myform" method="post" action="/Webpage/Fixtures.jsp">
<%
    try {
        String connectionURL = "jdbc:mysql://104.197.152.81:3306/Football";
        Connection connection = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        connection = DriverManager.getConnection(connectionURL, "root", "root");
        if(!connection.isClosed()) {
            Statement stmt = connection.createStatement();
            String sqlStr;

            PreparedStatement read, read1;

            ResultSet rset;

            read = connection.prepareStatement(  "select DateofMatch, HomeTeam, AwayTeam from Fixtures where DateofMatch between '2018-04-28' and '2018-05-13'");
            rset = read.executeQuery();

%>
<div class="container" id="container">
<table id="table" border = "1" width = "100%">
    <tr>
        <th>Date of Fixture</th>
        <th>Home Team</th>
        <th>Away Team</th>
    </tr>
        <%
            while (rset.next()) {
%>
    <tr>
        <td><%= rset.getString("DateofMatch") %></td>
        <td><%= rset.getString("HomeTeam") %></td>
        <td><%= rset.getString("AwayTeam") %></td>
    </tr>

        <%          }
%>

        <%connection.close();
        }

    }catch(Exception ex){
        out.println("Unable to connect to database"+ex);
    }
%>
</table>
</div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

    <script>
        $('tr').click(function() {
            $('tr').removeClass('selected');
            $(this).addClass('selected');

            var td = $(this).children('td');
            for (var i = 1; i < td.length; ++i) {
                window.location="http://35.193.184.35/Webpage/Stats.jsp?param="+td[1].innerText+";"+td[2].innerText;
            }
        });
    </script>
</form>
</body>
</html>