import mysql.connector
from mysql.connector import Error
from config import Config


# เชื่อมต่อฐานข้อมูล
def get_db_connection():
    try:
        print(f"Attempting to connect to database:")
        print(f"Host: {Config.DB_HOST}")
        print(f"User: {Config.DB_USER}")
        print(f"Database: {Config.DB_DATABASE}")
        
        connection = mysql.connector.connect(
            host=Config.DB_HOST,
            user=Config.DB_USER,
            password=Config.DB_PASS,
            database=Config.DB_DATABASE,
            autocommit=True
        )
        
        if connection.is_connected():
            print("Successfully connected to MySQL database")
            return connection
            
    except Error as e:
        print(f"DB Connection Error: {e}")
        print(f"Error Code: {e.errno}")
        print(f"Error Message: {e.msg}")
        raise
    except Exception as e:
        print(f"Unexpected error: {e}")
        raise
