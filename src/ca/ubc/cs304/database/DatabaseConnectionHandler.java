package ca.ubc.cs304.database;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;

import ca.ubc.cs304.model.*;

import javax.swing.*;

/**
 * This class handles all database related transactions
 */
public class DatabaseConnectionHandler {
	// Use this version of the ORACLE_URL if you are running the code off of the server
	private static final String ORACLE_URL = "jdbc:oracle:thin:@localhost:1522:stu";
	// Use this version of the ORACLE_URL if you are tunneling into the undergrad servers
	//private static final String ORACLE_URL = "jdbc:oracle:thin:@localhost:1522:stu";
	private static final String EXCEPTION_TAG = "[EXCEPTION]";
	private static final String WARNING_TAG = "[WARNING]";
	
	private Connection connection = null;
	
	public DatabaseConnectionHandler() {
		try {
			// Load the Oracle JDBC driver
			// Note that the path could change for new drivers
			DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
		}
	}
	
	public void close() {
		try {
			if (connection != null) {
				connection.close();
			}
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
		}
	}

	// TODO: create methods that perform the queries we want

	public void insert(AbstractTable tableModel) {
		try {
			PreparedStatement ps = null;
			if (tableModel instanceof Customer) {
				Customer cust = (Customer) tableModel;
				// call method in Customer class that creates the SQL statement
				ps = cust.getInsertStatement(connection, cust);
			} // else if tableModel instanceof Vendor ... etc
			System.out.println("Executing insert");
			ps.executeUpdate();
			connection.commit();

			ps.close();
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
			// should we create a JFrame window that shows the error?
			JOptionPane.showMessageDialog(null, e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
			rollbackConnection();
		}
	}

	public void deleteDriver(int driverID) {
		try {
			PreparedStatement ps = connection.prepareStatement("DELETE FROM drivers WHERE driverID = ?");
			ps.setInt(1, driverID);

			System.out.println("Executing delete");
			int rowCount = ps.executeUpdate();
			if (rowCount == 0) {
				System.out.println(WARNING_TAG + " Driver " + driverID + " does not exist!");
			}

			connection.commit();

			ps.close();
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
			JOptionPane.showMessageDialog(null, e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
			rollbackConnection();
		}
		System.out.println("Driver and their vehicle is deleted");
	}

	// TODO: implement update customer function
	public void updateCustomer(int custID, String attr, String newValue) {
		try {
			PreparedStatement ps = Customer.getUpdateStatement(connection, custID, attr, newValue);

			System.out.println("Executing update");
			int rowCount = ps.executeUpdate();
			if (rowCount == 0) {
				System.out.println(WARNING_TAG + "CustomerID " + custID + " does not exist!");
			}

			connection.commit();

			ps.close();
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
			JOptionPane.showMessageDialog(null, e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
			rollbackConnection();
		}
		System.out.println("Customer is updated");
	}

	// SELECTION: Get orderID and subtotal for orders with subtotal greater than user specified value
	// returns a list of OrderAnalysis objects that contain the orderID and subTotal of the users that match the query
	// the UI will handle displaying the results
	public ArrayList<OrderAnalysis> selectionQuery(BigDecimal minSubTotal) {
		ArrayList<OrderAnalysis> result = new ArrayList<>();

		try {
			PreparedStatement ps = connection.prepareStatement("SELECT OrderID, Subtotal FROM MakesOrder WHERE " +
					"Subtotal > ?");
			ps.setBigDecimal(1, minSubTotal);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				OrderAnalysis analysis = new OrderAnalysis(rs.getInt("OrderID"),
													rs.getBigDecimal("Subtotal"));
				result.add(analysis);
			}

			rs.close();
			ps.close();
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
		}

		return result;
	}


	//TODO: PROJECTION&JOIN: Find customers who have made orders with subtotal greater than user specified value
	// returns a list of CustomerAnalysis objects that contain the customerID and customerName of users that match query
	public ArrayList<CustomerAnalysis> projectionJoinQuery(BigDecimal minSubTotal) {
		ArrayList<CustomerAnalysis> result = new ArrayList<>();

		try {
			PreparedStatement ps = connection.prepareStatement("SELECT DISTINCT c.customerID, c.cname " +
					"FROM customer c, makesOrder m " +
					"WHERE c.customerID=m.customerID AND " +
					"m.subTotal > ?");
			ps.setBigDecimal(1, minSubTotal);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				CustomerAnalysis analysis = new CustomerAnalysis(rs.getInt("CustomerID"),
						rs.getString("Cname"));
				result.add(analysis);
			}

			rs.close();
			ps.close();
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
		}

		return result;
	}
	//TODO: AGGREGATION with GROUPBY: Return customerID and their average subtotal amount
	public ArrayList<OrderAnalysis> aggWithGroupbyQuery(BigDecimal minSubTotal) {
		ArrayList<OrderAnalysis> result = new ArrayList<>();

		String queryStmt = "SELECT customerID, AVG(subtotal) FROM makesOrder GROUP BY customerID";

		try {
			Statement stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery(queryStmt);

			while (rs.next()) {
				OrderAnalysis analysis = new OrderAnalysis(rs.getInt("OrderID"), rs.getBigDecimal("Subtotal"));
				result.add(analysis);
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
		}

		return result;
	}
	//TODO: AGGREGATION with HAVING: Find customers with more than 2 orders
	// 								and an average subtotal price of more than 50$
	public ArrayList<Integer> AggWithHavingQuery() {
		ArrayList<Integer> result = new ArrayList<Integer>();

		String queryStmt = "SELECT customerID FROM makesOrder GROUP BY customerID " +
				"HAVING COUNT(*) > 5 AND AVG(subtotal) > 50;";


		try {
			Statement stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery(queryStmt);

			while (rs.next()) {
				int customerID = rs.getInt("CustomerID");
				result.add(customerID);
			}

			rs.close();
			stmt.close();
		}

		catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
		}

		return result;
	}

	// NESTED AGGREGATION WITH GROUPBY: Find customers who made orders with the largest avg subtotal
	public ArrayList<Integer> NestedAggregation() {
		ArrayList<Integer> result = new ArrayList<Integer>();

		String queryStmt = "(WITH temp(avgSTotal) as " +
			"(SELECT AVG(subTotal) as avgSubTotal FROM makesOrder GROUP BY customerID)) " +
			"(SELECT customerID FROM makesOrder GROUP BY customerID " +
			"Having AVG(subtotal) = (SELECT MAX(temp.avgSTotal) FROM temp))";
		/////// IS THIS VIEWS IMPLEMENTATION OK???

		try {
			Statement stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery(queryStmt);

			while (rs.next()) {
				int customerID = rs.getInt("CustomerID");
				result.add(customerID);
			}

			rs.close();
			stmt.close();
		}

		catch (SQLException e) {
		System.out.println(EXCEPTION_TAG + " " + e.getMessage());
		}

		return result;
	}

	//TODO: DIVISION: Find customers who have ordered from all restaurants

    public ArrayList<CustomerAnalysis> divisionQuery() {
        ArrayList<CustomerAnalysis> result = new ArrayList<>();

        String queryStmt = "SELECT DISTINCT c.customerID, c.cname FROM customer c WHERE NOT EXISTS " +
                "((SELECT restaurantID FROM managesRestaurant) MINUS (SELECT r.restaurantID FROM requestsOrder r, " +
                "makesOrder m WHERE r.orderID=m.orderID AND m.customerID=c.customerID))";

        try {
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(queryStmt);

            while (rs.next()) {

                CustomerAnalysis analysis = new CustomerAnalysis(rs.getInt("OrderID"),
                        rs.getString("Cname"));
                result.add(analysis);
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            System.out.println(EXCEPTION_TAG + " " + e.getMessage());
        }

        return result;
    }




    ////////////////////////// BRANCH EXAMPLES //////////////////////////
	// TODO: Delete these since they are for the Branch example


	
	public BranchModel[] getBranchInfo() {
		ArrayList<BranchModel> result = new ArrayList<BranchModel>();
		
		try {
			Statement stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT * FROM branch");
		
//    		// get info on ResultSet
//    		ResultSetMetaData rsmd = rs.getMetaData();
//
//    		System.out.println(" ");
//
//    		// display column names;
//    		for (int i = 0; i < rsmd.getColumnCount(); i++) {
//    			// get column name and print it
//    			System.out.printf("%-15s", rsmd.getColumnName(i + 1));
//    		}
			
			while(rs.next()) {
				BranchModel model = new BranchModel(rs.getString("branch_addr"),
													rs.getString("branch_city"),
													rs.getInt("branch_id"),
													rs.getString("branch_name"),
													rs.getInt("branch_phone"));
				result.add(model);
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
		}	
		
		return result.toArray(new BranchModel[result.size()]);
	}
	
	public void updateBranch(int id, String name) {
		try {
		  PreparedStatement ps = connection.prepareStatement("UPDATE branch SET branch_name = ? WHERE branch_id = ?");
		  ps.setString(1, name);
		  ps.setInt(2, id);
		
		  int rowCount = ps.executeUpdate();
		  if (rowCount == 0) {
		      System.out.println(WARNING_TAG + " Branch " + id + " does not exist!");
		  }
	
		  connection.commit();
		  
		  ps.close();
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
			rollbackConnection();
		}	
	}
	
	public boolean login(String username, String password) {
		try {
			if (connection != null) {
				connection.close();
			}
	
			connection = DriverManager.getConnection(ORACLE_URL, username, password);
			connection.setAutoCommit(false);
	
			System.out.println("\nConnected to Oracle!");
			return true;
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
			return false;
		}
	}

	// returns the connection
	public Connection getConnection() {
		return this.connection;
	}

	private void rollbackConnection() {
		try  {
			connection.rollback();	
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
		}
	}
	
	public void databaseSetup() {
		dropBranchTableIfExists();
		
		try {
			Statement stmt = connection.createStatement();
			stmt.executeUpdate("CREATE TABLE branch (branch_id integer PRIMARY KEY, " +
					"branch_name varchar2(20) not null, branch_addr varchar2(50), branch_city varchar2(20) not null," +
					" branch_phone integer)");
			stmt.close();
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
		}
		
		BranchModel branch1 = new BranchModel("123 Charming Ave", "Vancouver", 1, "First Branch",
				1234567);
		insertBranch(branch1);
		
		BranchModel branch2 = new BranchModel("123 Coco Ave", "Vancouver", 2, "Second Branch",
				1234568);
		insertBranch(branch2);
	}

	private void insertBranch(BranchModel branch2) {
	}

	private void dropBranchTableIfExists() {
		try {
			Statement stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery("select table_name from user_tables");
			
			while(rs.next()) {
				if(rs.getString(1).toLowerCase().equals("branch")) {
					stmt.execute("DROP TABLE branch");
					break;
				}
			}
			
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println(EXCEPTION_TAG + " " + e.getMessage());
		}
	}
}
