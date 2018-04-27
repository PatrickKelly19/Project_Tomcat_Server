import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Logger;

@WebServlet(name = "Football", urlPatterns = {"/html_form_send.php"})

public class Football extends HttpServlet {
    private Connection connection;
    private PreparedStatement results, booksid;
    private static final Logger LOGGER = Logger.getLogger( Football.class.getName() );

    // set up database connection and prepare SQL statements
    public void init( ServletConfig config )
            throws ServletException
    {
        // attempt database connection and create PreparedStatements
        try {
            LOGGER.info("LOGGER HERE IN SQL DATABASE!!!!!!!!\n");
            LOGGER.info("Attempting database connection POST\n");
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(
                    "jdbc:mysql://104.197.152.81:3306/Football" ,"root","root");

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
        LOGGER.info("I shouldnt be here");

    } // end of doPost method

    protected void doGet( HttpServletRequest request,
                          HttpServletResponse response )
            throws ServletException, IOException
    {
        LOGGER.info("JUST INTO dopost");

        response.setContentType("application/json;charset=UTF-8");
        //HistoricalResults(request,response);
    }

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

//    private void HistoricalResults(HttpServletRequest request,
//                            HttpServletResponse response)
//            throws ServletException, IOException
//    {
//            request.getRequestDispatcher("/graph.jsp?param=").forward(request, response);
//    }
}
