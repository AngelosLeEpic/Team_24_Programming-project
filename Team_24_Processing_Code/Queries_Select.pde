class QueriesSelect extends Queries {
  
  QueriesSelect() {
    super();
  }
  
  //STATIC SELELCT STATEMENTS
  ArrayList<DelaysDataPoint> getRowsDelayGraph() {
    ArrayList<DelaysDataPoint> dataList = new ArrayList<DelaysDataPoint>();
    try {
        Statement stmt = connection.createStatement();
        String query = "SELECT MKT_CARRIER, DEP_TIME, ARR_TIME, CRS_DEP_TIME, CRS_ARR_TIME " +
                       "FROM " + super.tableName +
                       " GROUP BY MKT_CARRIER;";
        ResultSet resultSet = stmt.executeQuery(query);
        
        while (resultSet.next()) {
            DelaysDataPoint data = new DelaysDataPoint(resultSet);
            dataList.add(data);
        }
        
        resultSet.close();
        stmt.close();
    } catch (SQLException e) {
        println("SQLException: " + e.getMessage());
    }
    
    return dataList;
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
      String query = "SELECT  MKT_CARRIER, SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END) AS 'COUNT_CANCELLED', " +
      "SUM(CASE WHEN DIVERTED = 1 THEN 1 ELSE 0 END) AS 'COUNT_DIVERTED', COUNT(*) - SUM(CANCELLED + DIVERTED) AS 'COUNT_EXPECTED' FROM flight_Data GROUP BY MKT_CARRIER;";
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
  
  
  ArrayList<DisplayDataPoint> getRowsDisplay(boolean depTrue, int lowerVal, int upperVal, String depAirport, String arrAirport, String startDateRange, String endDateRange) {
    
    String word = "";
    ArrayList<DisplayDataPoint> dataList = new ArrayList<>();
    println(depTrue, lowerVal, upperVal, depAirport, arrAirport, startDateRange, endDateRange);
    try {   
        Statement stmt = connection.createStatement();
        
        // Construct the WHERE clause dynamically
        StringBuilder whereClauseBuilder = new StringBuilder();
        String column = depTrue ? "DEP_TIME" : "ARR_TIME";
        
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

        // Time range filter
        if (lowerVal != 0 && upperVal != 0){
          if (whereClauseBuilder.length() > 0) {
            whereClauseBuilder.append(" AND ");
          }
          if (lowerVal < upperVal) {
            whereClauseBuilder.append(column).append(" BETWEEN ").append(lowerVal).append(" AND ").append(upperVal);
          } 
          else {
            whereClauseBuilder.append(column).append(" NOT BETWEEN ").append(upperVal).append(" AND ").append(lowerVal);
          }
        }
        else if (lowerVal != 0){
          if (whereClauseBuilder.length() > 0) {
            whereClauseBuilder.append(" AND ");
          }
          whereClauseBuilder.append(column).append(" <= ").append(lowerVal);
        }
        else if (upperVal != 0){
          if (whereClauseBuilder.length() > 0) {
            whereClauseBuilder.append(" AND ");
          }
          whereClauseBuilder.append(column).append(" >= ").append(upperVal);
        }
        
        
        // Date range filter
        if (startDateRange != null && !startDateRange.isEmpty() && endDateRange != null && !endDateRange.isEmpty()) {
            if (whereClauseBuilder.length() > 0) {
                whereClauseBuilder.append(" AND ");
            }
            if (lowerVal < upperVal) {
              whereClauseBuilder.append("FL_DATE BETWEEN '").append(startDateRange).append("' AND '").append(endDateRange).append("'");
            } 
            else {
              whereClauseBuilder.append("FL_DATE NOT BETWEEN '").append(startDateRange).append("' AND '").append(endDateRange).append("'");
            }
        }
        else if (startDateRange != null && !startDateRange.isEmpty()){
          if (whereClauseBuilder.length() > 0) {
            whereClauseBuilder.append(" AND ");
          }
          whereClauseBuilder.append("FL_DATE <= '").append(startDateRange).append("'");
        }
        else if (endDateRange != null && !endDateRange.isEmpty()){
          if (whereClauseBuilder.length() > 0) {
            whereClauseBuilder.append(" AND ");
          }
          whereClauseBuilder.append("FL_DATE >= '").append(endDateRange).append("'");
        }
        
        // Construct the full SQL query
        if (whereClauseBuilder.length() > 0) {
          word = " WHERE ";
        }
 
        String query = "SELECT FL_DATE, MKT_CARRIER, ORIGIN, DEST, DEP_TIME, ARR_TIME, CANCELLED, DIVERTED FROM " + super.tableName + word + whereClauseBuilder.toString();
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
  
  
  String[] getDepartureAirports(){
    
    ArrayList<String> dataList = new ArrayList<String>();
    try {
        Statement stmt = connection.createStatement();
        String query = "SELECT DISTINCT ORIGIN FROM " + super.tableName + " ORDER BY ORIGIN;";
        ResultSet resultSet = stmt.executeQuery(query);
        
        while (resultSet.next()) {
            String airport = resultSet.getString("ORIGIN");
            dataList.add(airport);
        }
        
        resultSet.close();
        stmt.close();
    } 
    catch (SQLException e) {
        println("SQLException: " + e.getMessage());
    }
    
    String[] departureAirports = dataList.toArray(new String[dataList.size()]);
    return departureAirports;
  }
  
  
  String[] getArrivalAirports(){
    
    ArrayList<String> dataList = new ArrayList<String>();
    try {
        Statement stmt = connection.createStatement();
        String query = "SELECT DISTINCT DEST FROM " + super.tableName + " ORDER BY DEST;";
        ResultSet resultSet = stmt.executeQuery(query);
        
        while (resultSet.next()) {
            String airport = resultSet.getString("DEST");
            dataList.add(airport);
        }
        
        resultSet.close();
        stmt.close();
    } 
    catch (SQLException e) {
        println("SQLException: " + e.getMessage());
    }
    
    String[] arrivalAirports = dataList.toArray(new String[dataList.size()]);
    return arrivalAirports;
  }
  
  
  //GET ROUTES (BUSY/ ALL) 
  ArrayList<RouteDataPoint> getBusyRoutes(){
    
    ArrayList<RouteDataPoint> dataList = new ArrayList<RouteDataPoint>();
    try {
      Statement stmt = connection.createStatement();
      String query = "SELECT ORIGIN, DEST, COUNT(*) AS FLIGHT_COUNT FROM " + super.tableName + " GROUP BY ORIGIN, DEST ORDER BY FLIGHT_COUNT DESC LIMIT 5;";
      ResultSet resultSet = stmt.executeQuery(query);
      
      while (resultSet.next()) {
        RouteDataPoint data = new RouteDataPoint(resultSet);
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
  ArrayList<RouteDataPoint> getAllRoutes(){
    ArrayList<RouteDataPoint> dataList = new ArrayList<RouteDataPoint>();
    try {
      Statement stmt = connection.createStatement();
      String query = "SELECT ORIGIN, DEST, COUNT(*) AS FLIGHT_COUNT FROM " + super.tableName + " GROUP BY ORIGIN, DEST ORDER BY FLIGHT_COUNT DESC;";
      ResultSet resultSet = stmt.executeQuery(query);
      
      while (resultSet.next()) {
        RouteDataPoint data = new RouteDataPoint(resultSet);
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

  
  // GET NUMBER OF ARRIVALS AND DEPARTURES PER AIRPORT - NODE MAP (EMMA)
  int getArrivals(String airportName) {
    int arrivals = 0;
    try {
      Statement stmt = connection.createStatement();
      String query = "SELECT COUNT(*) AS ARRIVALS FROM " + super.tableName + " WHERE DEST = '" + airportName + "'";
      ResultSet resultSet = stmt.executeQuery(query);

      if (resultSet.next()) {
        arrivals = resultSet.getInt("ARRIVALS");
      }

      resultSet.close();
      stmt.close();
    } catch (SQLException e) {
      println("SQLException: " + e.getMessage());
    }
    return arrivals;
  }
  int getDepartures(String airportName) {
    int departures = 0;
    try {
      Statement stmt = connection.createStatement();
      String query = "SELECT COUNT(*) AS DEPARTURES FROM " + super.tableName + " WHERE ORIGIN = '" + airportName + "'";
      ResultSet resultSet = stmt.executeQuery(query);

      if (resultSet.next()) {
        departures = resultSet.getInt("DEPARTURES");
      }

      resultSet.close();
      stmt.close();
    } catch (SQLException e) {
      println("SQLException: " + e.getMessage());
    }
    return departures;
  }

}
