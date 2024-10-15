from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from .. import models, schemas
from ..database import get_db

# Crear el router para las rutas de transacciones
router = APIRouter()

# Crear transacción
@router.post("/transactions/", response_model=schemas.Transaction)
def create_transaction(transaction: schemas.TransactionCreate, db: Session = Depends(get_db), user_id: int = Depends()):
    db_transaction = models.Transaction(**transaction.dict(), owner_id=user_id)
    db.add(db_transaction)
    db.commit()
    db.refresh(db_transaction)
    return db_transaction

# Obtener todas las transacciones
@router.get("/transactions/", response_model=List[schemas.Transaction])
def read_transactions(skip: int = 0, limit: int = 10, db: Session = Depends(get_db), user_id: int = Depends()):
    transactions = db.query(models.Transaction).filter(models.Transaction.user_id == user_id).offset(skip).limit(limit).all()
    return transactions

# Obtener una transacción por ID
@router.get("/transactions/{transaction_id}", response_model=schemas.Transaction)
def read_transaction(transaction_id: int, db: Session = Depends(get_db), user_id: int = Depends()):
    transaction = db.query(models.Transaction).filter(models.Transaction.id == transaction_id, models.Transaction.user_id == user_id).first()
    if transaction is None:
        raise HTTPException(status_code=404, detail="Transacción no encontrada")
    return transaction

# Actualizar una transacción
@router.put("/transactions/{transaction_id}", response_model=schemas.Transaction)
def update_transaction(transaction_id: int, transaction: schemas.TransactionCreate, db: Session = Depends(get_db), user_id: int = Depends()):
    db_transaction = db.query(models.Transaction).filter(models.Transaction.id == transaction_id, models.Transaction.user_id == user_id).first()
    if db_transaction is None:
        raise HTTPException(status_code=404, detail="Transacción no encontrada")
    
    db_transaction.description = transaction.description
    db_transaction.amount = transaction.amount
    db_transaction.category = transaction.category
    db.commit()
    db.refresh(db_transaction)
    return db_transaction

# Eliminar una transacción
@router.delete("/transactions/{transaction_id}")
def delete_transaction(transaction_id: int, db: Session = Depends(get_db), user_id: int = Depends()):
    db_transaction = db.query(models.Transaction).filter(models.Transaction.id == transaction_id, models.Transaction.user_id == user_id).first()
    if db_transaction is None:
        raise HTTPException(status_code=404, detail="Transacción no encontrada")
    
    db.delete(db_transaction)
    db.commit()
    return {"detail": "Transacción eliminada exitosamente"}
