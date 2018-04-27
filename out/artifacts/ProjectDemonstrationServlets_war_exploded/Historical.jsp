<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
    <title>Historical Results</title>

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
<form id="myform" name="myform" method="post" action="/Webpage/Historical.jsp">
    <% String name = request.getParameter("age"); %>
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

                read = connection.prepareStatement(  "SELECT  * FROM PleaseWorkForEverything Where HomeTeam = ? OR AwayTeam = ?");
                read.setString(1,name);
                read.setString(2,name);
                rset = read.executeQuery();

    %>
    <div class="container" id="container">
        <table id="table" border = "1" width = "100%">
            <tr>
                <th>Home Team</th>
                <th>Away Team</th>
                <th>Home Score</th>
                <th>Away Score</th>
                <th>Winner</th>
            </tr>
            <%
                while (rset.next()) {
            %>
            <tr>
                <td><%= rset.getString("HomeTeam") %></td>
                <td><%= rset.getString("AwayTeam") %></td>
                <td><%= rset.getInt("HomeScore") %></td>
                <td><%= rset.getInt("AwayScore") %></td>
                <td><%= rset.getString("Winner") %></td>
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
</form>
</body>
</html>