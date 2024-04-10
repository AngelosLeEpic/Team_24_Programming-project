import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.DatabaseMetaData;
import java.util.Collections;
import java.io.FileReader;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;

class Queries {
  
  // MySQL database connection parameters
  String filename = sketchPath() + "/flights2k.csv";
  String url = "jdbc:mysql://localhost:3306/programming_project";
  String databaseName = "programming_project";
  String tableName = "flight_data";
  
  // CHECK IF EMPTY
  String username = "";
  String password = "";
  
  Connection connection;
  
  Queries(){
    try {
      BufferedReader reader = new BufferedReader(new FileReader(sketchPath() + "/credentials.txt"));
      
      username = reader.readLine();
      password = reader.readLine();
      
      // If password is empty, set it to an empty string
      if (password == null || password.isEmpty()) {
        password = "";
      }
      
      reader.close();
    } 
    catch (IOException e) {
      println("Error cannot find file credentials.txt");
      exit();
    }
    
    try {
      connection = DriverManager.getConnection(url, username, password);
      println("Connected!");
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
  
  void closeConnection() {
    try {
      if (connection != null) {
        connection.close();
        println("Connection closed");
      }
    } catch (SQLException e) {
      println("SQLException: " + e.getMessage());
    }
  }
  
}
