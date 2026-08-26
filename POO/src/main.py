from src.services.media import Aluno
from src.controllers.calculo_media import calcular_final


def main():
    alunos = [
        Aluno(matricula="2026001", nome="Ana Silva", nota_prova1=8.0, nota_prova2=7.5, nota_trabalho=9.0),
        Aluno(matricula="2026002", nome="Bruno Costa", nota_prova1=4.0, nota_prova2=5.0, nota_trabalho=6.0),
        Aluno(matricula="2026003", nome="Carla Souza", nota_prova1=2.0, nota_prova2=3.0, nota_trabalho=4.0),
    ]

    for aluno in alunos:
        media_final = aluno.media()
        nota_final = calcular_final(aluno)

        print(f"Aluno: {aluno.nome} (Matrícula: {aluno.matricula})")
        print(f"  Média final: {media_final}")
        if nota_final > 0:
            print(f"  Precisa tirar {nota_final} na prova final")
        else:
            print("  Aprovado direto, não precisa fazer a prova final")
        print("-" * 40)


if __name__ == "__main__":
    main()
