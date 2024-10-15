from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

# Esquema para crear un nuevo usuario
class UserCreate(BaseModel):
    email: str
    password: str
    full_name: Optional[str] = None

# Esquema para representar un usuario (sin mostrar la contraseña)
class User(BaseModel):
    id: int
    email: str
    full_name: Optional[str] = None

    class Config:
        orm_mode = True  # Esto permite la conversión directa de un modelo de SQLAlchemy a un modelo Pydantic

# Esquema para crear una nueva transacción
class TransactionCreate(BaseModel):
    amount: float
    description: str
    date: datetime  # Cambiado a datetime para manejar fechas y horas de forma adecuada

# Esquema para representar una transacción (al devolver información)
class Transaction(BaseModel):
    id: int
    amount: float
    description: str
    owner_id: int
    date: datetime

    class Config:
        orm_mode = True

# Esquema para representar un usuario con sus transacciones
class UserWithTransactions(BaseModel):
    id: int
    email: str
    full_name: Optional[str] = None
    transactions: List[Transaction] = []  # Lista de transacciones del usuario

    class Config:
        orm_mode = True
