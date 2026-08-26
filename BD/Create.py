from db import conectar

usuarios = [
    ("Ana Silva", "ana.silva@email.com", 23),
    ("Bruno Costa", "bruno.costa@email.com", 31),
    ("Carla Souza", "carla.souza@email.com", 28),
    ("Daniel Lima", "daniel.lima@email.com", 45),
    ("Eduarda Alves", "eduarda.alves@email.com", 19),
    ("Felipe Rocha", "felipe.rocha@email.com", 37),
    ("Gabriela Dias", "gabriela.dias@email.com", 26),
    ("Henrique Melo", "henrique.melo@email.com", 52),
    ("Isabela Reis", "isabela.reis@email.com", 33),
    ("João Pereira", "joao.pereira@email.com", 41),
]

def criar_usuarios():
    conn = conectar()
    cur = conn.cursor()

    cur.executemany(
        "INSERT INTO usuarios (nome, email, idade) VALUES (?, ?, ?)",
        usuarios
    )

    conn.commit()
    cur.close()
    conn.close()
    print(f"{len(usuarios)} usuários inseridos com sucesso!")

if __name__ == "__main__":
    criar_usuarios()