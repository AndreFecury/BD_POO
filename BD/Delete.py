from db import conectar

def deletar_usuario(id_usuario):
    conn = conectar()
    cur = conn.cursor()

    cur.execute("DELETE FROM usuarios WHERE id = ?", (id_usuario,))
    conn.commit()

    linhas_afetadas = cur.rowcount
    cur.close()
    conn.close()

    if linhas_afetadas:
        print(f"Usuário {id_usuario} deletado com sucesso!")
    else:
        print(f"Nenhum usuário encontrado com ID {id_usuario}.")

def deletar_todos_usuarios():
    conn = conectar()
    cur = conn.cursor()

    cur.execute("DELETE FROM usuarios")
    conn.commit()

    linhas_afetadas = cur.rowcount
    cur.close()
    conn.close()

    print(f"{linhas_afetadas} usuários deletados com sucesso!")

if __name__ == "__main__":
    deletar_todos_usuarios()

def deletar_tabela():
    conn = conectar()
    cur = conn.cursor()

    cur.execute("DROP TABLE IF EXISTS usuarios")
    conn.commit()

    cur.close()
    conn.close()
    print("Tabela 'usuarios' deletada com sucesso!")