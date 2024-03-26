class QueriesSelect extends Queries {
  
  QueriesSelect() {
    super();
  }
  
  
  ArrayList<BarDataPoint> getRowsBarGraph() {
    
    ArrayList<BarDataPoint> dataList = new ArrayList<BarDataPoint>();
    try {
      Statement stmt = connection.createStatement();
      String query = "SELECT MKT_CARRIER, SUM(DISTANCE) AS TOTAL_DIST FROM " + super.tableName + " GROUP BY MKT_CARRIER;";
      
      ResultSet resultSet = stmt.executeQuery(query);
      
      while (resultSet.next()) {
        BarDataPoint data = new BarDataPoint(resultSet);
        dataList.add(data);
      }
      
      resultSet.close();
      stmt.close();
    } 
    catch (SQLException e) {
      println("SQLException: " + e.getMessage());
    }
    
    return dataList;
  }
  
  
  ArrayList<PieDataPoint> getRowsPieChart() {
    
    ArrayList<PieDataPoint> dataList = new ArrayList<PieDataPoint>();
    try {
      Statement stmt = connection.createStatement();
      String query = "SELECT MKT_CARRIER, SUM(CANCELLED=1) AS 'COUNT_CANCELLED' , SUM(DIVERTED=1) AS 'COUNT_DIVERTED' FROM " + super.tableName + " GROUP BY MKT_CARRIER;";
      println(query);
      ResultSet resultSet = stmt.executeQuery(query);
      
      while (resultSet.next()) {
        PieDataPoint data = new PieDataPoint(resultSet);
        dataList.add(data);
      }
      
      resultSet.close();
      stmt.close();
    } 
    catch (SQLException e) {
      println("SQLException: " + e.getMessage());
    }
    
    return dataList;
  }
  
  
  ArrayList<DisplayDataPoint> getRowsDisplay(boolean depTrue, int lowerVal, int upperVal, String depAirport, String arrAirport) {
    
    ArrayList<DisplayDataPoint> dataList = new ArrayList<>();
    try {   
        Statement stmt = connection.createStatement();
        
        // Construct the WHERE clause dynamically
        StringBuilder whereClauseBuilder = new StringBuilder();
        String column = depTrue ? "DEP_TIME" : "ARR_TIME";
        
        // Time range filter
        if (lowerVal < upperVal) {
            whereClauseBuilder.append(column).append(" BETWEEN ").append(lowerVal).append(" AND ").append(upperVal);
        } else {
            whereClauseBuilder.append(column).append(" NOT BETWEEN ").append(upperVal).append(" AND ").append(lowerVal);
        }
        
        // Departure airport filter
        if (depAirport != null && !depAirport.isEmpty()) {
            if (whereClauseBuilder.length() > 0) {
                whereClauseBuilder.append(" AND ");
            }
            whereClauseBuilder.append("ORIGIN = '").append(depAirport).append("'");
        }
        
        // Arrival airport filter
        if (arrAirport != null && !arrAirport.isEmpty()) {
            if (whereClauseBuilder.length() > 0) {
                whereClauseBuilder.append(" AND ");
            }
            whereClauseBuilder.append("DEST = '").append(arrAirport).append("'");
        }
        
        // Construct the full SQL query
        String query = "SELECT FL_DATE, MKT_CARRIER, ORIGIN, DEST, DEP_TIME, ARR_TIME, CANCELLED, DIVERTED FROM " 
                        + super.tableName + " WHERE " + whereClauseBuilder.toString();
        println(query);
        
        ResultSet resultSet = stmt.executeQuery(query);
        
        while (resultSet.next()) {
            DisplayDataPoint data = new DisplayDataPoint(resultSet);
            dataList.add(data);
        }
       
        resultSet.close();
        stmt.close();
    } 
    catch (SQLException e) {
        println("SQLException: " + e.getMessage());
    }
    
    return dataList;
  }

}
