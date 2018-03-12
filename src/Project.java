import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) throws SQLException {
        ArrayList<Person> personlist = new ArrayList<Person>();
        try {
            // Step 1: Load the JDBC driver. jdbc:mysql://localhost:3306/travel
            Class.forName("com.mysql.jdbc.Driver");

            // Step 2: Establish the connection to the database.
            String url = "jdbc:mysql://104.197.152.81:3306/Football";
            Connection conn = DriverManager.getConnection(url, "root", "root");
            Statement st = conn.createStatement();
            ResultSet srs = st.executeQuery("SELECT * FROM PremierLeagueResultsAndOdds");
            int ids,ids1,ids2;
            String ps,ps1,ps2;
            while (srs.next()) {
//                Person person = new Person();
                ids = srs.getInt("id");
                ps = srs.getString("HomeTeam");
                ps1 = srs.getString("AwayTeam");
                ids1 = srs.getInt("HomeScore");
                ids2 = srs.getInt("AwayScore");
                ps2 = srs.getString("Winner");
                System.out.println(ids+" "+ps+" "+ps1+" "+ids1+" "+ids2+" "+ps2+" ");
            }

            //System.out.println(personlist.get(1).getID()+" "+personlist.get(1).getHomeTeam()+" "+personlist.get(1).getAwayTeam()+" "+personlist.get(1).getHomeScore()+" "+personlist.get(1).getAwayScore()+" "+personlist.get(1).getWinner());
//            System.out.println(personlist.get(1).getHomeTeam());
//            System.out.println(personlist.get(1).getAwayTeam());
//            System.out.println(personlist.get(1).getHomeScore());
//            System.out.println(personlist.get(1).getAwayScore());
//            System.out.println(personlist.get(1).getWinner());

        } catch (Exception e) {
            System.err.println("Got an exception! ");
            System.err.println(e.getMessage());
        }
    }
}