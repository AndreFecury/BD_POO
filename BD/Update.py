from db import conectar

def atualizar_usuario(id_usuario, nome=None, email=None, idade=None):
    conn = conectar()
    cur = conn.cursor()

    campos = []
    valores = []

    if nome:
        campos.append("nome = ?")
        valores.append(nome)
    if email:
        campos.append("email = ?")
        valores.append(email)
    if idade is not None:
        campos.append("idade = ?")
        valores.append(idade)

    if not campos:
        print("Nenhum campo para atualizar.")
        return

    valores.append(id_usuario)
    query = f"UPDATE usuarios SET {', '.join(campos)} WHERE id = ?"

    cur.execute(query, valores)
    conn.commit()

    linhas_afetadas = cur.rowcount
    cur.close()
    conn.close()

    if linhas_afetadas:
        print(f"Usuário {id_usuario} atualizado com sucesso!")
    else:
        print(f"Nenhum usuário encontrado com ID {id_usuario}.")

if __name__ == "__main__":
    atualizar_usuario(1, idade=24, email="ana.novo@email.com")