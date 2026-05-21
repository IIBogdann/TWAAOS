"""Funcții pentru testarea comenzii /doc:functie."""


def salut_utilizator(nume: str) -> str:
    """Salută utilizatorul după nume."""
    return f"Salut, {nume}!"


def calculeaza_total(preturi: list[float]) -> float:
    """Calculează suma prețurilor din listă."""
    return sum(preturi)
