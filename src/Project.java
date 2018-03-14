// Fig. 9.27: SurveyServlet.java
// A Web-based survey that uses JDBC from a servlet.

import java.io.*;
import java.sql.*;
import java.util.Objects;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "FootballPost", urlPatterns = {"/html_form_send.php"})

public class FootballPost extends HttpServlet {
    private Connection connection;
    private PreparedStatement results, booksid;
    private final static Logger LOGGER = Logger.getLogger(FootballPost.class.getName());

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

        //out.println("<p>"+home+" "+away+" "+winner+" "+homescore+" "+awayscore+" "+"</p>");

        //if none of the survey entries are empty
        try {

            String teamName = request.getParameter("age").trim();
            Statement stmt = connection.createStatement();
            ResultSet rs;
            rs = stmt.executeQuery("SELECT * FROM PleaseWorkForEverything WHERE HomeTeam='"+teamName+"'");
            System.out.println("HELLO: "+teamName);

            //ResultSet totalRS = booksid.executeQuery();
            while (rs.next()) {
                System.out.println("YOU ARE GETTING HERE!!!!!"+teamName);
                String age = request.getParameter("age");
                if (age.equals(teamName)) {
                    String home = rs.getString(2);
                    String away = rs.getString(3);
                    String homescore = rs.getString(4);
                    String awayscore = rs.getString(5);
                    String winner = rs.getString(6);
                    System.out.println(home+away+winner);
                    out.println("<p>"+home+" "+away+" "+winner+" "+homescore+" "+awayscore+" "+"</p>");

                } else if (age.equals("Chelsea")) {
//                    Statement stmt = connection.createStatement();
//                    ResultSet rs1 = stmt.executeQuery("SELECT * FROM PleaseWorkForEverything WHERE HomeTeam = 'Chelsea' AND AwayTeam = 'Chelsea'");
//                    out.println("<p>"+rs1+"</p>");
                } else if (age.equals("Liverpool")) {
//                    Statement stmt = connection.createStatement();
//                    ResultSet rs2 = stmt.executeQuery("SELECT * FROM PleaseWorkForEverything WHERE HomeTeam = 'Liverpool' AND AwayTeam = 'Liverpool'");
//                    out.println("<p>"+rs2+"</p>");
                } else {
                    out.println("<p>Default!!!!!</p>");
                }
            }
//            // get results
//            //results.executeUpdate();
//            LOGGER.info("Results saved to database successfully!\n");
//            out.println("<title>Thank you!</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("</br>Results successfully stored in database");
            //out.println("<br><form>\n" + "<input class=\"MyButton\" type=\"button\" value=\"Check database results\" onclick=\"window.location.href='http://localhost:8080/Get'\" />\n" + "</form></br>");
            out.println("<p>Thank you for participating.<br>");
            out.println("<button onclick=\"goBack()\">Back Button</button><script>function goBack() {\n" + "window.history.back();\n" + "}</script></br>");
            // end XHTML document
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
