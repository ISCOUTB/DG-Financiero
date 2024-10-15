from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    full_name = Column(String, nullable=True)  # full_name es opcional

    # Relación con la tabla de transacciones
    transactions = relationship("Transaction", back_populates="owner")


class Transaction(Base):
    __tablename__ = 'transactions'

    id = Column(Integer, primary_key=True, index=True)
    amount = Column(Integer)
    description = Column(String)
    owner_id = Column(Integer, ForeignKey('users.id'))  # Clave foránea que apunta a la tabla de usuarios

    # Relación con la tabla de usuarios
    owner = relationship("User", back_populates="transactions")

