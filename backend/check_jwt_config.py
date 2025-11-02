from flask import current_app
from app import app

@app.route("/check_jwt_config")
def check_jwt_config():
    return {
        "access_token_expires": str(current_app.config["JWT_ACCESS_TOKEN_EXPIRES"]),
        "refresh_token_expires": str(current_app.config["JWT_REFRESH_TOKEN_EXPIRES"]),
    }
    
# print("JWT Access Expire:", app.config.get("JWT_ACCESS_TOKEN_EXPIRES"))
# print("JWT Refresh Expire:", app.config.get("JWT_REFRESH_TOKEN_EXPIRES"))