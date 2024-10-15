from fastapi import FastAPI, Depends
from backend.app.auth import create_user
from app.database import engine, Base, get_db
from app.routers import transactions
from backend.app import models, schemas
from sqlalchemy.orm import Session




app = FastAPI()

# Crear las tablas si no existen
Base.metadata.create_all(bind=engine)

# Rutas de transacciones
app.include_router(transactions.router)

# Ruta para el registro de usuarios
@app.post("/register")
def register(user: schemas.UserCreate, db: Session = Depends(get_db)):
    return create_user(db=db, user=user)

