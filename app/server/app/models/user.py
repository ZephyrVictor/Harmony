from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    _password = db.Column(db.String(128), nullable=False)
    favorite_dishes = db.relationship('UserFavoriteDish', back_populates='user')

    @property
    def password(self):
        return self._password

    @password.setter
    def password(self, raw):
        self._password = generate_password_hash(raw)

    def check_password(self, raw):
        return check_password_hash(self._password, raw)

# class Dish(db.Model):
#     __tablename__ = 'dishes'
#
#     id = db.Column(db.Integer, primary_key=True)
#     name = db.Column(db.String(100), nullable=False)
#     favorited_by = db.relationship('User', secondary='user_favorite_dishes', back_populates='favorite_dishes')

class UserFavoriteDish(db.Model):
    __tablename__ = 'user_favorite_dishes'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    dish_id = db.Column(db.Integer, nullable=False)
    db.UniqueConstraint('user_id', 'dish_id', name='unique_favorite')

    user = db.relationship('User', back_populates='favorite_dishes')