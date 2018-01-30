import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/Project")

public class Project extends HttpServlet //Extends HttpServlet to handle HTTP get requests and HTTP post requests
{
    //The servlet container calls this method to respond to a client request to the servlet
    public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
    {
        //Sets the content type of the response being sent to the client, if the response has not been committed yet.
        res.setContentType("text/html");
        PrintWriter out = res.getWriter(); //Obtains a character-based output stream for sending text data to the client.

        //Returns the value of a request parameter as a String, or null if the parameter does not exist.
        String name = req.getParameter("filename");

        BufferedReader br = new BufferedReader(new FileReader("C:\\Users\\jkjke\\Documents\\PythonProject\\Scripts\\"+name+".txt"));

        String str;
        //reads every line of the file
        while( (str = br.readLine()) != null )
        {
            out.println(str + "<BR>");
        }

        //back button
        out.println("<br><button onclick=\"goBack()\">Back Button</button><script>function goBack() {\n" + "window.history.back();\n" + "}</script>");

        br.close();
        out.close();
    }
}