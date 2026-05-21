from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Gestiune inventar", version="1.0.0")


class Produs(BaseModel):
    id: int
    nume: str
    pret: float
    stoc: int = 0


inventory: list[Produs] = []


@app.get("/")
def root():
    return {"status": "activ", "docs": "/docs", "produse": "/produse"}


def find_product_index(product_id: int) -> int | None:
    for index, product in enumerate(inventory):
        if product.id == product_id:
            return index
    return None


@app.get("/produse")
def get_all_products(stoc_minim: int | None = None):
    if stoc_minim is None:
        return inventory
    return [product for product in inventory if product.stoc < stoc_minim]


@app.get("/produse/{produs_id}")
def get_product_by_id(produs_id: int):
    index = find_product_index(produs_id)
    if index is None:
        raise HTTPException(
            status_code=404,
            detail=f"Produsul cu ID-ul {produs_id} nu a fost găsit.",
        )
    return inventory[index]


@app.post("/produse", status_code=201)
def add_product(product: Produs):
    inventory.append(product)
    return product


@app.delete("/produse/{produs_id}")
def delete_product(produs_id: int):
    index = find_product_index(produs_id)
    if index is None:
        raise HTTPException(
            status_code=404,
            detail=f"Produsul cu ID-ul {produs_id} nu a fost găsit.",
        )
    return inventory.pop(index)


@app.put("/produse/{produs_id}")
def update_product(produs_id: int, product: Produs):
    index = find_product_index(produs_id)
    if index is None:
        raise HTTPException(
            status_code=404,
            detail=f"Produsul cu ID-ul {produs_id} nu a fost găsit.",
        )
    inventory[index] = product
    return product
