import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet; 
import java.sql.SQLException;
import java.sql.Statement;

import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;

public class Huffsa {

    private static String user = "sameera";
    private static String pwd = "oZuquie1na";

    private static String connectionStr =
        "user=" + user + "_priv&" +
        "port=5432&" +
        "password=" + pwd + "";
    private static String host = "jdbc:postgresql://dbpg-ifi-kurs03.uio.no";

    public static void main(String[] agrs) {

        try {
            // Last inn driver for PostgreSQL
            Class.forName("org.postgresql.Driver");
            // Lag tilkobling til databasen
            Connection connection = DriverManager.getConnection(host + "/" + user
                    + "?sslmode=require&ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory&" + connectionStr);

            int ch = 0;
            while (ch != 3) {
                System.out.println("--[ HUFFSA ]--");
                System.out.println("Vennligst velg et alternativ:\n 1. Søk etter planet\n 2. Legg inn resultat\n 3. Avslutt");
                ch = getIntFromUser("Valg: ", true);

                if (ch == 1) {
                    planetSok(connection);
                } else if (ch == 2) {
                    leggInnResultat(connection);
                }
            }
        } catch (SQLException|ClassNotFoundException ex) {
            System.err.println("Error encountered: " + ex.getMessage());
        }
    }

    private static void planetSok(Connection connection)  throws SQLException {
      System.out.println("--[ PLANET SØK ]--");
      String molekyl = getStrFromUser("Molekyl 1:");
      String molekylTo = getStrFromUser("Molekyl 2:");

      String sporring = "(select p.navn, p.masse, s.masse, s.avstand, p.liv "+
      "from planet as p join stjerne as s on (p.stjerne = s.navn) " +
      "join materie as m on (p.navn = m.planet) "+
      "WHERE m.molekyl ='?' "+
      "order by s.avstand) ";


      if (!molekylTo.equals("")){
        sporring += "intersect "+
        "(select p.navn, p.masse, s.masse, s.avstand, p.liv "+
        "from planet as p join stjerne as s on (p.stjerne = s.navn) " +
        "join materie as m on (p.navn = m.planet) "+
        "WHERE m.molekyl ='?' "+
        "order by s.avstand)";
      }

      sporring += ";";

      PreparedStatement statement = connection.prepareStatement(sporring);
      statement.setString(1, molekyl);
      if (!molekylTo.equals("")){
        statement.setString(2, molekylTo);
    }
    ResultSet rows = statement.executeQuery();
    if(!rows.next()){
        System.out.println("Ingen planteter...");
        return;
    }
    do {
        System.out.println("Navn: " + rows.getString(1));
        System.out.println("Planet-masse: " + rows.getFloat(2));
        System.out.println("Stjerne-masse: " + rows.getFloat(3));
        System.out.println("Stjerne-distanse: " + rows.getFloat(4));
        System.out.println("Bekreftet liv: " + rows.getBoolean(5));

    } while(rows.next());

          }


    private static void leggInnResultat(Connection connection) throws SQLException {
      System.out.println("--[ LEGG INN RESULTAT ]--");
      String PlanetNavn = getStrFromUser("Planet: ");
      String Skummel = getStrFromUser("Skummel: ");
      String Intelegent = getStrFromUser("Intellegent: ");
      String Beskrivelse = getStrFromUser("Beskrivelse: ");

      String q = "update planet " +
      "Set skummel= '?', intelligent= '?', beskrivelse= '?',liv='t' " +
      "WHERE navn = '?';";

      PreparedStatement statement = connection.prepareStatement(q);
      statement.setBoolean(1, jaellerNei(Skummel));
      statement.setBoolean(2, jaellerNei(Intelegent));
      statement.setString(3, Beskrivelse);
      statement.setString(4, PlanetNavn);

      statement.execute();

      System.out.println("Resultat lagt til.");



    }

    private static boolean jaellerNei(String bool){
        if (bool.equals("j")){
            return true;
        }
        return false;
      }

    private static Integer getIntFromUser(String message, boolean canBeBlank) {
        while (true) {
            String str = getStrFromUser(message);
            if (str.equals("") && canBeBlank) {
                return null;
            }
            try {
                return Integer.valueOf(str);
            } catch (NumberFormatException ex) {
                System.out.println("Please provide an integer or leave blank.");
            }
        }
    }

    private static String getStrFromUser(String message) {
        Scanner s = new Scanner(System.in);
        System.out.print(message);
        return s.nextLine();
    }
}