from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from db import get_db_connection  # ฟังก์ชันเชื่อมต่อ DB
from datetime import datetime
from flask_jwt_extended import get_jwt
parent_bp = Blueprint("parent_bp", __name__)

# เพิ่มข้อมูลผู้ปกครอง


@parent_bp.route("/parents/insert", methods=["POST"])
@jwt_required()
def insert_parent():
    username = get_jwt_identity()
    data = request.get_json()

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # ดึงค่าจาก payload
        id_card_number = data.get("id_card_number")
        prefix_name = data.get("prefix_name")
        first_name = data.get("first_name")
        last_name = data.get("last_name")
        email = data.get("email")
        phone_number = data.get("phone_number")
        relation = data.get("relation")
        occupation = data.get("occupation")
        student_ids = data.get("student_id", [])  # list ของ student_id
        created_date = datetime.now()

        # ✅ Insert ข้อมูลผู้ปกครอง (ไม่มี RETURNING)
        cursor.execute(
            """
            INSERT INTO parents 
            (id_card_number, prefix_name, first_name, last_name, email, phone_number, relation, occupation, created_date, created_by)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """,
            (
                id_card_number,
                prefix_name,
                first_name,
                last_name,
                email,
                phone_number,
                relation,
                occupation,
                created_date,
                username,
            ),
        )

        # ✅ ดึงค่า parent_id ล่าสุดจาก Auto Increment
        parent_id = cursor.lastrowid

        # Insert ความสัมพันธ์กับนักเรียน
        for student_id in student_ids:
            cursor.execute(
                """
                INSERT INTO parents_history (student_id ,parents_id)
                VALUES (%s, %s)
                """,
                (student_id, parent_id),
            )

        conn.commit()
        return jsonify({"message": "เพิ่มข้อมูลผู้ปกครองสำเร็จ", "parent_id": parent_id}), 200

    except Exception as e:
        conn.rollback()
        print("❌ ERROR inserting parent:", e)
        return jsonify({"error": str(e)}), 500

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


# ลบข้อมูลผู้ปกครอง


@parent_bp.route("/parents/delete/<int:parents_id>", methods=["DELETE"])
@jwt_required()
def delete_parents(parents_id):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # ลบความสัมพันธ์ข้อมูลผู้ปกครองก่อน (ถ้ามีตารางเชื่อม many-to-many)
        delete_parents_query = """
            DELETE FROM parents WHERE parents_id = %s
        """
        cursor.execute(delete_parents_query, (parents_id,))

        # ลบข้อมูลผู้ปกครอง
        delete_parents_history_query = """
            DELETE FROM parents_history WHERE parents_id = %s
        """
        cursor.execute(delete_parents_history_query, (parents_id,))

        conn.commit()

        return jsonify({"message": "parents deleted successfully"}), 200

    except Exception as e:
        if conn:
            conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


# ✅ อัปเดตข้อมูลผู้ปกครอง
@parent_bp.route("/parents/update/<int:parents_id>", methods=["PUT"])
@jwt_required()
def update_parents(parents_id):
    claims = get_jwt()
    updated_by = claims["user_id"]  # ดึง user_id จาก token

    data = request.get_json()
    print("📦 รับข้อมูลมา:", data)

    id_card_number = data.get("id_card_number")
    prefix_name = data.get("prefix_name")
    first_name = data.get("first_name")
    last_name = data.get("last_name")
    email = data.get("email")
    phone_number = data.get("phone_number")
    relation = data.get("relation")
    occupation = data.get("occupation")
    student_ids = data.get("student_id", [])  # list ของ student_id

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # ✅ อัปเดตข้อมูลในตาราง parents
        cursor.execute(
            """
            UPDATE parents 
            SET 
                id_card_number=%s,
                prefix_name=%s,
                first_name=%s,
                last_name=%s,
                email=%s,
                phone_number=%s,
                relation=%s,
                occupation=%s,
                updated_by=%s,
                updated_date=NOW()
            WHERE parents_id=%s
        """,
            (
                id_card_number,
                prefix_name,
                first_name,
                last_name,
                email,
                phone_number,
                relation,
                occupation,
                updated_by,
                parents_id,
            ),
        )

        # ✅ ลบข้อมูลเดิมใน parents_history (กันซ้ำ)
        cursor.execute(
            "DELETE FROM parents_history WHERE parents_id = %s", (parents_id,)
        )

        # ✅ เพิ่มข้อมูลใหม่ของนักเรียนที่ดูแล
        insert_history = (
            "INSERT INTO parents_history (student_id, parents_id) VALUES (%s, %s)"
        )
        for sid in student_ids:
            cursor.execute(insert_history, (sid, parents_id))

        conn.commit()
        return jsonify({"message": "อัปเดตข้อมูลผู้ปกครองสำเร็จ"}), 200

    except Exception as e:
        if conn:
            conn.rollback()
        print("❌ ERROR updating parent:", e)
        return jsonify({"error": str(e)}), 500

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


# ดึงข้อมูลผู้ปกครองทั้งหมด


@parent_bp.route("/parents_all", methods=["GET"])
@jwt_required()
def get_parents_all():
    username = get_jwt_identity()

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            """
            SELECT 
                p.parents_id,
                p.id_card_number,
                p.prefix_name,
                p.first_name,
                p.last_name,
                p.email,
                p.phone_number,
                p.relation,
                p.occupation,
                DATE_FORMAT(p.created_date, '%Y-%m-%d %H:%i:%s') AS created_date,
                p.created_by,
                DATE_FORMAT(p.updated_date, '%Y-%m-%d %H:%i:%s') AS updated_date,
                p.updated_by,
                -- รวม student_id และ student_name
                COALESCE(GROUP_CONCAT(DISTINCT s.student_id), '') AS student_id,
                COALESCE(GROUP_CONCAT(DISTINCT CONCAT(s.prefix_name, s.first_name, ' ', s.last_name) SEPARATOR ', '), '') AS student_name
            FROM parents p
            LEFT JOIN parents_history ph ON ph.parents_id = p.parents_id
            LEFT JOIN students s ON ph.student_id = s.student_id
            GROUP BY 
                p.parents_id, p.id_card_number, p.prefix_name, p.first_name, p.last_name,
                p.email, p.phone_number, p.relation, p.occupation, 
                p.created_date, p.created_by, p.updated_date, p.updated_by
            ORDER BY p.parents_id DESC
        """
        )

        columns = [desc[0] for desc in cursor.description]
        parents = [dict(zip(columns, row)) for row in cursor.fetchall()]

        # แปลง student_id จาก string -> list[int]
        for p in parents:
            if p.get("student_id"):
                p["student_id"] = [
                    int(x) for x in p["student_id"].split(",") if x.isdigit()
                ]
            else:
                p["student_id"] = []

        return jsonify({"current_user": username, "parents": parents}), 200

    except Exception as e:
        print("❌ ERROR in /parents_all:", e)
        return jsonify({"error": str(e)}), 500

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
