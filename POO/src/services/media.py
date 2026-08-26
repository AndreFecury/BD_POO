class Aluno:
    """Representa um aluno matriculado em uma disciplina."""

    def __init__(self, matricula, nome, nota_prova1, nota_prova2, nota_trabalho):
        self.matricula = matricula
        self.nome = nome
        self.nota_prova1 = nota_prova1
        self.nota_prova2 = nota_prova2
        self.nota_trabalho = nota_trabalho

    def media(self):
        """Calcula a média final do aluno.

        Cada prova tem peso 2,5 e o trabalho tem peso 2.
        """
        soma_pesos = 2.5 + 2.5 + 2
        media_final = (
            (self.nota_prova1 * 2.5)
            + (self.nota_prova2 * 2.5)
            + (self.nota_trabalho * 2)
        ) / soma_pesos
        return round(media_final, 2)

    def __str__(self):
        return f"Aluno({self.matricula}, {self.nome})"
