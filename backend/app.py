from flask import Flask, send_from_directory
from flask_cors import CORS
from flask_jwt_extended import JWTManager
import os
from config import Config
from auth import auth_bp
from user_routes import user_bp
from year_routes import year_bp
from classrooms_routes import classrooms_bp
from school_routes import school_bp
from teacher_routes import teacher_bp
from classes_routes import classes_bp
from student_routes import student_bp
from health_records_routes import health_records_bp
from behavior_records_routes import behavior_records_bp

# แปลง Flask → ASGI
from asgiref.wsgi import WsgiToAsgi


def create_app():
    app = Flask(__name__)

    # ตั้งค่าคอนฟิก
    app.config.from_object(Config)
    app.config["JWT_SECRET_KEY"] = Config.JWT_SECRET_KEY
    app.config["JWT_TOKEN_LOCATION"] = ["headers", "cookies"]
    app.config["JWT_COOKIE_SECURE"] = True
    app.config["JWT_COOKIE_CSRF_PROTECT"] = True

    # ตั้งค่า CORS (อนุญาตหลาย origin)
    CORS(app, resources={r"/*": {"origins": [
        "http://103.76.180.34"
    ]}}, supports_credentials=True)

    # ตั้งค่า JWT
    jwt = JWTManager(app)

    # ลงทะเบียน blueprint
    app.register_blueprint(auth_bp, url_prefix='/api')
    app.register_blueprint(user_bp, url_prefix='/api')
    app.register_blueprint(year_bp, url_prefix='/api')
    app.register_blueprint(classrooms_bp, url_prefix='/api')
    app.register_blueprint(school_bp, url_prefix='/api')
    app.register_blueprint(teacher_bp, url_prefix='/api')
    app.register_blueprint(classes_bp, url_prefix='/api')
    app.register_blueprint(student_bp, url_prefix='/api')
    app.register_blueprint(health_records_bp, url_prefix='/api')
    app.register_blueprint(behavior_records_bp, url_prefix='/api')

    # favicon
    @app.route('/favicon.ico')
    def favicon():
        return send_from_directory(
            os.path.join(app.root_path, 'static'),
            'favicon.ico',
            mimetype='image/vnd.microsoft.icon'
        )

    # root endpoint
    @app.route("/")
    def root():
        return {"status": "running", "message": "Flask API Service"}

    # health check
    @app.route("/health")
    def health_check():
        return {"status": "healthy"}, 200


    # API documentation endpoint
    @app.route("/docs")
    def api_docs():
        routes = []
        for rule in app.url_map.iter_rules():
            if rule.endpoint != 'static':
                routes.append({
                    'endpoint': rule.endpoint,
                    'methods': list(rule.methods - {'HEAD', 'OPTIONS'}),
                    'path': str(rule)
                })
        
        return {
            "title": "Flask API Documentation",
            "description": "Smart Care API Service",
            "base_url": "http://localhost:5000",
            "api_prefix": "/api",
            "endpoints": {
                "health": "GET /health - Health check endpoint",
                "root": "GET / - Root status endpoint", 
                "docs": "GET /docs - This documentation",
                "auth": "POST /api/auth/login, /api/auth/register - Authentication endpoints",
                "users": "/api/users/* - User management endpoints",
                "schools": "/api/schools/* - School management endpoints",
                "teachers": "/api/teachers/* - Teacher management endpoints",
                "students": "/api/students/* - Student management endpoints",
                "classes": "/api/classes/* - Class management endpoints",
                "classrooms": "/api/classrooms/* - Classroom management endpoints",
                "years": "/api/years/* - Academic year endpoints",
                "health_records": "/api/health_records/* - Health record endpoints",
                "behavior_records": "/api/behavior_records/* - Behavior record endpoints"
            },
            "all_routes": sorted(routes, key=lambda x: x['path'])
        }


    return app


# สร้าง Flask app และแปลงเป็น ASGI
flask_app = create_app()
app = WsgiToAsgi(flask_app)

if __name__ == "__main__":
    flask_app.run(host="0.0.0.0", port=5000, debug=True)


# รันผ่านคำนี้ >>เพื่อนให้ใช้ทดสอบ http://103.78.180.34:5000/    
# waitress-serve --host=103.78.180.34 --port=5000 app:app   
# uvicorn app:app --host 127.0.0.1:5500/ --port 5000     
# waitress-serve --host=0.0.0.0 --port=5000 app:flask_app

