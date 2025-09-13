from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token
from db import get_db_connection
import bcrypt
from datetime import datetime

auth_bp = Blueprint("auth_bp", __name__)

@auth_bp.route("/login", methods=["POST"])
def login():
    print(datetime.now(), "Start login")

    if not request.is_json:
        return jsonify({"message": "Missing JSON in request"}), 400

    data = request.get_json()
    username = data.get("username")
    password = data.get("password")

    print(f"data: {data}")
    print(f"username: {username}")
    print(f"password: {password}")  # ระวัง: ไม่ควร log password จริงใน production

    if not username or not password:
        return jsonify({"message": "username and password are required"}), 400

    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        print("DB Connected OK")
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users WHERE user_name = %s", (username,))
        user = cursor.fetchone()
        print(datetime.now(), "DB Query OK:", user)

        if user and bcrypt.checkpw(password.encode("utf-8"), user["password"].encode("utf-8")):
            access_token = create_access_token(
                identity=user["user_name"],
                additional_claims={"user_id": user["user_id"]}
            )
            return jsonify({"access_token": access_token}), 200
        else:
            return jsonify({"message": "ข้อมูลไม่ถูกต้อง"}), 401

    except Exception as e:
        print("Login error:", e)
        return jsonify({"message": "Internal server error"}), 500

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

