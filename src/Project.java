import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Logger;

import com.google.gson.Gson;
import jdk.nashorn.internal.parser.JSONParser;
import org.json.*;

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
        response.setContentType("application/json;charset=UTF-8");

        HeadtoHead(request,response);

//        try {
//
//            String teamName = request.getParameter("age").trim();
//            Statement stmt = connection.createStatement();
//            ResultSet rs;
//            rs = stmt.executeQuery("SELECT * FROM PleaseWorkForEverything WHERE HomeTeam='"+teamName+"' OR AwayTeam='"+teamName+"'");
//            JSONArray jArray = new JSONArray(); //create a JSON Array obj.
//            while(rs.next()){
//
//                JSONObject job=new JSONObject(); //create a JSON Object obj.
//                String age = request.getParameter("age");
//
//                if (age.equals(teamName)) {
//                    job.put("HomeTeam", rs.getString(2));
//                    job.put("AwayTeam", rs.getString(3));
//                    job.put("Winner", rs.getString(6));
//
//                    jArray.put(job);
//                }
//            }
//            JSONObject json1 = new JSONObject();
//            request.setAttribute("jsonString", jArray.toString());
//            RequestDispatcher dispatcher = request.getRequestDispatcher("Dance.jsp");
//            dispatcher.forward(request, response);
//        } catch (SQLException ignored)
//        {
//
//
//        } catch (IOException | JSONException ioE) {
//            ioE.printStackTrace();
//        }
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

    private void HeadtoHead(HttpServletRequest request,
                            HttpServletResponse response)
            throws ServletException, IOException
    {
        try {

            String teamName = request.getParameter("age").trim();
            Statement stmt = connection.createStatement();
            ResultSet rs;
            rs = stmt.executeQuery("SELECT * FROM PleaseWorkForEverything WHERE HomeTeam='"+teamName+"' OR AwayTeam='"+teamName+"'");
            JSONArray jArray = new JSONArray(); //create a JSON Array obj.
            while(rs.next()){

                JSONObject job = new JSONObject(); //create a JSON Object obj.
                String age = request.getParameter("age");

                if (age.equals(teamName)) {
                    job.put("HomeTeam", rs.getString(2));
                    job.put("AwayTeam", rs.getString(3));
                    job.put("Winner", rs.getString(6));

                    jArray.put(job);
                }
            }
            request.setAttribute("jsonString", jArray.toString());
            RequestDispatcher dispatcher = request.getRequestDispatcher("Dance.jsp");
            dispatcher.forward(request, response);
//            String json = new Gson().toJson(jArray);
//
//            response.setContentType("application/json");
//            response.setCharacterEncoding("UTF-8");
//            response.getWriter().write(json);
            //response.getWriter().write(jArray.toString());
//            request.setAttribute("jsonString", jArray.toString());
//            System.out.println(jArray.toString());
//            RequestDispatcher dispatcher = request.getRequestDispatcher("Dance.jsp");
//            dispatcher.forward(request, response);
//            String s = jArray.toString();
//            request.getSession().setAttribute("jsonArray",s);
//            response.sendRedirect("Dance.jsp");
//            response.setContentType("application/json");
//            response.setCharacterEncoding("UTF-8");
//            response.getWriter().write(new Gson().toJson(jArray)); //this is how simple GSON works
        } catch (SQLException ignored)
        {

        } catch (IOException | JSONException ioE) {
            ioE.printStackTrace();
        }
    }
}
