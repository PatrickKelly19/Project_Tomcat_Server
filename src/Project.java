// Fig. 9.27: SurveyServlet.java
// A Web-based survey that uses JDBC from a servlet.

import java.io.*;
import java.sql.*;
import java.util.List;
import java.util.Objects;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "Project", urlPatterns = {"/html_form_send.php"})

public class Project extends HttpServlet {
    private Connection connection;
    private PreparedStatement results, booksid;
    private final static Logger LOGGER = Logger.getLogger(Project.class.getName());

    // set up database connection and prepare SQL statements
    public void init( ServletConfig config )
            throws ServletException
    {
        // attempt database connection and create PreparedStatements
        try {
            LOGGER.info("Attempting database connection POST\n");
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(
                    "jdbc:mysql://104.197.152.81:3306/Football" ,"root","root");

            // PreparedStatement to obtain survey option table's data
            //booksid = connection.prepareStatement("SELECT MAX(id) FROM PleaseWorkForEverything"
            //);
            LOGGER.info("Creating Prepared Statements\n");

        }

        // for any exception throw an UnavailableException to
        // indicate that the servlet is not currently available
        catch ( Exception exception ) {
            exception.printStackTrace();
            throw new UnavailableException( exception.getMessage() );
        }
    } // end of init method

    // process survey response
    protected void doPost( HttpServletRequest request,
                           HttpServletResponse response )
            throws ServletException, IOException
    {

        LOGGER.info("Gone into doPost\n");
        // set up response to client
        response.setContentType( "text/html" );
        PrintWriter out = response.getWriter();

        // start XHTML document
        out.println( "<?xml version = \"1.0\"?>" );

        out.println( "<!DOCTYPE html PUBLIC \"-//W3C//DTD " +
                "XHTML 1.0 Strict//EN\" \"http://www.w3.org" +
                "/TR/xhtml1/DTD/xhtml1-strict.dtd\">" );

        out.println(
                "<html xmlns = \"http://www.w3.org/1999/xhtml\">" );

        // head section of document
        out.println( "<head>" );

        try {

            String teamName = request.getParameter("age").trim();
            String teamName1 = request.getParameter("age1").trim();
            Statement stmt = connection.createStatement();
            ResultSet rs;
            ResultSet rs1;
            rs = stmt.executeQuery("SELECT * FROM PleaseWorkForEverything WHERE HomeTeam='"+teamName+"'");

            out.println("<table BORDER=1 CELLPADDING=1 CELLSPACING=0 WIDTH=50%>"
                    +"<tr><th>Home Team</th><th>Away Team</th><th>Home Score</th><th>Away Score</th><th>Winner</th></tr>");

            while (rs.next()) {
                String age = request.getParameter("age");
                String age1 = request.getParameter("age1");

                if(!Objects.equals(age, age1))
                {
                    if (age.equals(teamName)) {
                        String home = rs.getString(2);
                        String away = rs.getString(3);
                        String homescore = rs.getString(4);
                        String awayscore = rs.getString(5);
                        String winner = rs.getString(6);

                        System.out.println(home+away+winner);
                        out.print("<tr><td align=\"center\">"+home+"</td><td align=\"center\">"+away+"</td><td align=\"center\">"+homescore+"</td><td align=\"center\">"+awayscore+"</td><td align=\"center\">"+winner+"</td></tr>");
                    } else {
                        out.println("<p>No Results Found</p>");
                    }
                }
                else {
                    System.out.println("Two same teams picked");
                    //out.println("<p>Team A and B must be different</p>");
                }
            }
            out.print("</table>");
            out.println("<p>Team A and B must be different</p>");
            out.println("<p>Thank you for participating.<br>");
            out.println("<button onclick=\"goBack()\">Back Button</button><script>function goBack() {\n" + "window.history.back();\n" + "}</script></br>");
            out.println("</pre></body></html>");
        }

        // if database exception occurs, return error page
        catch (SQLException sqlException) {
            sqlException.printStackTrace();
            LOGGER.info("!Entry Database exception\n");
            out.println("<title>Error</title>");
            out.println("</head>");
            out.println("<body><p>Database error occurred. ");
            out.println("<br>");
            out.println("<button onclick=\"goBack()\">Back Button</button><script>function goBack() {\n" + "window.history.back();\n" + "}</script>");
            out.println("</br>");
            out.println("Try again later.</p></body></html>");
            out.close();
        }
    } // end of doPost method

    // close SQL statements and database when servlet terminates
    public void destroy()
    {
        try {
            // attempt to close statements and database connection
            results.close();
            connection.close();
            LOGGER.info("Database connection closed\n");
        }

        // handle database exceptions by returning error to client
        catch( SQLException sqlException ) {
            sqlException.printStackTrace();
            LOGGER.info("Database exceptions\n");
        }
    } // end of destroy method
}
