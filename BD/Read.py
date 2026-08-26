from db import conectar

def listar_usuarios():
    conn = conectar()
    cur = conn.cursor()

    cur.execute("SELECT id, nome, email, idade FROM usuarios ORDER BY id")
    usuarios = cur.fetchall()

    cur.close()
    conn.close()

    for usuario in usuarios:
        print(f"ID: {usuario[0]} | Nome: {usuario[1]} | Email: {usuario[2]} | Idade: {usuario[3]}")

    return usuarios

def buscar_usuario_por_id(id_usuario):
    conn = conectar()
    cur = conn.cursor()

    cur.execute("SELECT id, nome, email, idade FROM usuarios WHERE id = ?", (id_usuario,))
    usuario = cur.fetchone()

    cur.close()
    conn.close()

    return usuario

if __name__ == "__main__":
    listar_usuarios()