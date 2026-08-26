from src.services.media import Aluno

MEDIA_APROVACAO = 7.0
MEDIA_MINIMA_APOS_FINAL = 5.0


def calcular_final(aluno: Aluno):
    """Calcula quanto o aluno precisa tirar na prova final.

    Retorna 0 se o aluno já estiver aprovado (não precisa ir para a final).
    """
    media_aluno = aluno.media()

    if media_aluno >= MEDIA_APROVACAO:
        return 0.0

    nota_necessaria = (MEDIA_MINIMA_APOS_FINAL * 2) - media_aluno
    nota_necessaria = max(0.0, min(10.0, nota_necessaria))
    return round(nota_necessaria, 2)
