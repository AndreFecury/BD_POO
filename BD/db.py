import sqlite3

def conectar():
    conn = sqlite3.connect("crud.db")
    return conn

def criar_tabela():
    conn = conectar()
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL,
            idade INTEGER
        )
    """)
    conn.commit()
    cur.close()
    conn.close()

if __name__ == "__main__":
    criar_tabela()
    print("Tabela criada (ou já existia).")