import java.sql.ResultSet;
import java.sql.SQLException;

class RawDataPoint {

  String FL_DATE = null;
  String MKT_CARRIER = null;
  int MKT_CARRIER_FL_NUM = 0;

  String ORIGIN = null;
  String ORIGIN_CITY_NAME = null;
  String ORIGIN_STATE_ABR = null;
  int ORIGIN_WAC = 0;

  String DEST = null;
  String DEST_CITY_NAME = null;
  String DEST_STATE_ABR = null;
  int DEST_WAC = 0;

  int CRS_DEP_TIME = 0;
  int DEP_TIME = 0;
  int CRS_ARR_TIME = 0;
  int ARR_TIME = 0;

  int CANCELLED = 0;
  int DIVERTED = 0;
  int DISTANCE = 0;

  RawDataPoint(ResultSet resultSet) {
    try {
      FL_DATE = columnExists(resultSet, "FL_DATE") ? resultSet.getString("FL_DATE") : null;
      MKT_CARRIER = columnExists(resultSet, "MKT_CARRIER") ? resultSet.getString("MKT_CARRIER") : null;
      MKT_CARRIER_FL_NUM = columnExists(resultSet, "MKT_CARRIER_FL_NUM") ? resultSet.getInt("MKT_CARRIER_FL_NUM") : 0;

      ORIGIN = columnExists(resultSet, "ORIGIN") ? resultSet.getString("ORIGIN") : null;
      ORIGIN_CITY_NAME = columnExists(resultSet, "ORIGIN_CITY_NAME") ? resultSet.getString("ORIGIN_CITY_NAME") : null;
      ORIGIN_STATE_ABR = columnExists(resultSet, "ORIGIN_STATE_ABR") ? resultSet.getString("ORIGIN_STATE_ABR") : null;
      ORIGIN_WAC = columnExists(resultSet, "ORIGIN_WAC") ? resultSet.getInt("ORIGIN_WAC") : 0;

      DEST = columnExists(resultSet, "DEST") ? resultSet.getString("DEST") : null;
      DEST_CITY_NAME = columnExists(resultSet, "DEST_CITY_NAME") ? resultSet.getString("DEST_CITY_NAME") : null;
      DEST_STATE_ABR = columnExists(resultSet, "DEST_STATE_ABR") ? resultSet.getString("DEST_STATE_ABR") : null;
      DEST_WAC = columnExists(resultSet, "DEST_WAC") ? resultSet.getInt("DEST_WAC") : 0;

      CRS_DEP_TIME = columnExists(resultSet, "CRS_DEP_TIME") ? resultSet.getInt("CRS_DEP_TIME") : 0;
      DEP_TIME = columnExists(resultSet, "DEP_TIME") ? resultSet.getInt("DEP_TIME") : 0;
      CRS_ARR_TIME = columnExists(resultSet, "CRS_ARR_TIME") ? resultSet.getInt("CRS_ARR_TIME") : 0;
      ARR_TIME = columnExists(resultSet, "ARR_TIME") ? resultSet.getInt("ARR_TIME") : 0;

      CANCELLED = columnExists(resultSet, "CANCELLED") ? resultSet.getInt("CANCELLED") : 0;
      DIVERTED = columnExists(resultSet, "DIVERTED") ? resultSet.getInt("DIVERTED") : 0;
      DISTANCE = columnExists(resultSet, "DISTANCE") ? resultSet.getInt("DISTANCE") : 0;

    } catch (SQLException e) {
        println("SQLException AA: " + e.getMessage());
    }
  }

  boolean columnExists(ResultSet resultSet, String columnLabel) {
    try {
        resultSet.findColumn(columnLabel);
        return true;
    } 
    catch (SQLException e) {
        return false;
    }
  }

}

class BarDataPoint extends RawDataPoint {
  
  String MKT_CARRIER = null;
  int TOTAL_DIST = 0;

  BarDataPoint(ResultSet resultSet) {
    super(resultSet); // Call superclass constructor
    try {
      MKT_CARRIER = columnExists(resultSet, "MKT_CARRIER") ? resultSet.getString("MKT_CARRIER") : null;
      TOTAL_DIST = columnExists(resultSet, "TOTAL_DIST") ? resultSet.getInt("TOTAL_DIST") : 0;
    } catch (SQLException e) {
      println("SQLException: " + e.getMessage());
    }
  }
  public int getTOTAL_DIST() {
    return TOTAL_DIST;
  }
  public String getMKT_CARRIER() {
    return MKT_CARRIER;
  }
}

class PieDataPoint extends RawDataPoint {
  
  String MKT_CARRIER = null;
  int COUNT_CANCELLED = 0;
  int COUNT_DIVERTED = 0;
  int COUNT_EXPECTED = 0;

  PieDataPoint(ResultSet resultSet) {
    super(resultSet); // Call superclass constructor
    try {
      MKT_CARRIER = columnExists(resultSet, "MKT_CARRIER") ? resultSet.getString("MKT_CARRIER") : null;
      COUNT_CANCELLED = columnExists(resultSet, "COUNT_CANCELLED") ? resultSet.getInt("COUNT_CANCELLED") : 0;
      COUNT_DIVERTED = columnExists(resultSet, "COUNT_DIVERTED") ? resultSet.getInt("COUNT_DIVERTED") : 0;
      COUNT_EXPECTED = columnExists(resultSet, "COUNT_EXPECTED") ? resultSet.getInt("COUNT_EXPECTED") : 0;
    } catch (SQLException e) {
      println("SQLException: " + e.getMessage());
    }
  }
  public int getCOUNT_CANCELLED() {
    return COUNT_CANCELLED;
  }
  public int getCOUNT_DIVERTED() {
    return COUNT_DIVERTED;
  }
  public int getCOUNT_EXPECTED() {
    return COUNT_EXPECTED;
  }
  public String getMTK_CARRIER() {
    return MKT_CARRIER;
  }
}

class DisplayDataPoint extends RawDataPoint {
  
  String FL_DATE = null;
  String MKT_CARRIER = null;
  String ORIGIN = null;
  String DEST = null;
  int DEP_TIME = 0;
  int ARR_TIME = 0;
  int CANCELLED = 0;
  int DIVERTED = 0;

  DisplayDataPoint(ResultSet resultSet) {
    super(resultSet);
    try {
      FL_DATE = columnExists(resultSet, "FL_DATE") ? resultSet.getString("FL_DATE") : null;
      MKT_CARRIER = columnExists(resultSet, "MKT_CARRIER") ? resultSet.getString("MKT_CARRIER") : null;
      ORIGIN = columnExists(resultSet, "ORIGIN") ? resultSet.getString("ORIGIN") : null;
      DEST = columnExists(resultSet, "DEST") ? resultSet.getString("DEST") : null;
      DEP_TIME = columnExists(resultSet, "DEP_TIME") ? resultSet.getInt("DEP_TIME") : 0;
      ARR_TIME = columnExists(resultSet, "ARR_TIME") ? resultSet.getInt("ARR_TIME") : 0;
      CANCELLED = columnExists(resultSet, "CANCELLED") ? resultSet.getInt("CANCELLED") : 0;
      DIVERTED = columnExists(resultSet, "DIVERTED") ? resultSet.getInt("DIVERTED") : 0;
      if(CANCELLED == 1)
      {
        
      }
    } catch (SQLException e) {
      println("SQLException: " + e.getMessage());
    }
  }
}


class RouteDataPoint extends RawDataPoint {
  
  String ORIGIN = null;
  String DEST = null;
  int FLIGHT_COUNT = 0;

  RouteDataPoint(ResultSet resultSet) {
    super(resultSet);
    try {
      ORIGIN = columnExists(resultSet, "ORIGIN") ? resultSet.getString("ORIGIN") : null;
      DEST = columnExists(resultSet, "DEST") ? resultSet.getString("DEST") : null;
      FLIGHT_COUNT = columnExists(resultSet, "FLIGHT_COUNT") ? resultSet.getInt("FLIGHT_COUNT") : 0;
    } catch (SQLException e) {
      println("SQLException: " + e.getMessage());
    }
  }
}

class DelaysDataPoint extends RawDataPoint {
  
  String MKT_CARRIER = null;
  int CRS_DEP_TIME = 0; 
  int DEP_TIME = 0;
  int CRS_ARR_TIME = 0;
  int ARR_TIME = 0;

  DelaysDataPoint(ResultSet resultSet) {
    super(resultSet); // Call superclass constructor
    try {
      MKT_CARRIER = columnExists(resultSet, "MKT_CARRIER") ? resultSet.getString("MKT_CARRIER") : null;
      DEP_TIME = columnExists(resultSet, "DEP_TIME") ? resultSet.getInt("DEP_TIME") : 0;
      ARR_TIME = columnExists(resultSet, "ARR_TIME") ? resultSet.getInt("ARR_TIME") : 0;
      CRS_DEP_TIME = columnExists(resultSet, "CRS_DEP_TIME") ? resultSet.getInt("DEP_TIME") : 0;
      CRS_ARR_TIME = columnExists(resultSet, "CRS_ARR_TIME") ? resultSet.getInt("ARR_TIME") : 0;
    } catch (SQLException e) {
      println("SQLException: " + e.getMessage());
    }
  }
}
