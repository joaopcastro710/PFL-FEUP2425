# Blackstone — Projeto 2 (FEUP PFL)

Autores:
- @joaopcastro710
- @zaviers04

Resumo
------
Implementação do jogo Blackstone em Prolog (orientada para execução em SWI-Prolog). O ficheiro principal é `game.pl`. A implementação inclui: geração de tabuleiro inicial, visualização em texto, regras de movimento (peças movem-se como rainha de xadrez e deixam uma pedra preta), detecção e remoção de peças cercadas, modos de jogo humanos vs humanos e humanos vs bots, e um bot com dois níveis (Random e Greedy) com uma função de avaliação para escolher jogadas.

O que está implementado
-----------------------
- Representação do tabuleiro como lista de linhas (cada célula: `r` = Red, `b` = Blue, `n` = neutra/vazia, `x` = pedra preta).
- Geração automática do tabuleiro inicial para um tamanho (par) especificado.
- Loop de jogo com menu interativo:
  - Alterar tamanho do tabuleiro (par > 5; e.g., 6 para 6x6).
  - Escolher variante (Main, Medium Churn, High Churn).
  - Escolher modo (hh, hb, bh, bb — Red vs Blue sempre nessa ordem).
  - Escolher dificuldade do bot (Random, Greedy).
  - Opções para ver partidas automáticas Greedy vs Random.
- Regras de movimento:
  - Uma peça do jogador move-se como uma rainha (horizontal, vertical, diagonal) para uma célula vazia (`n`) e deixa uma pedra preta (`x`) na posição de origem.
  - Validação de caminho livre (todas as células intermédias têm de ser `n`).
- Remoção de peças cercadas:
  - Verificação de peças que não têm movimentos possíveis (8 direções); essas peças são removidas.
  - Diferenças entre variantes:
    - Main (n): remove apenas peças cercadas.
    - Medium (m): remove peças cercadas e pedras pretas adjacentes às peças cercadas.
    - High (h): remove peças cercadas e, se houver capturas, limpa todas as pedras pretas do tabuleiro (ou dependendo do caso).
- IA / Bot:
  - Nível 1: escolhe movimento aleatoriamente entre movimentos válidos.
  - Nível 2 (Greedy): avalia cada movimento segundo uma função heurística (contagem de peças e mobilidade) e escolhe o melhor movimento imediato.
  - Opções para ver Greedy vs Random e vice-versa (dificuldades 3 e 4 no menu).
- Avaliação (heurística):
  - Conta diferença de peças do jogador vs o oponente.
  - Conta mobilidade (número de movimentos disponíveis) do jogador vs oponente.
  - Peso e fórmula da heurística variam conforme a variante (parâmetros diferentes para n, m, h).
  - Resultado arredondado para 2 casas decimais e explicação textual do significado (ex.: "Bot thinks its position is slightly better").
- Persistência:
  - Ao terminar, guarda o estado final e metadados em `last_game_result.txt`.

Como executar
-------------
1. Instale SWI-Prolog (recomendado).
2. Abra o terminal na pasta que contém `game.pl`.
3. Inicie SWI-Prolog:
   - `swipl`
4. Carregue o ficheiro:
   - `?- [game].`  % ou `?- consult('game.pl').`
5. Inicie o jogo:
   - `?- play.`

Comandos e interações
---------------------
- O menu interativo permite alterar as opções antes de iniciar.
- Para jogar como humano: no turno humano, o programa pede:
  - StartRow, StartCol, EndRow, EndCol
  - As coordenadas usam (1,1) como canto inferior-esquerdo do tabuleiro (a implementação reverte internamente as linhas para que (1,1) seja bottom-left).
- Para mudar tamanho: inserir um número inteiro par > 5.
- Opções de monitorização:
  - Escolher as opções 6 ou 7 no menu para assistir a confrontos Greedy vs Random.

Regras principais
--------------------------
- As peças movem-se como rainha para uma célula vazia; a origem fica com `x`.
- Peças que não têm nenhum movimento valido (todas as 8 direções bloqueadas) são consideradas cercadas e são removidas; dependendo da variante alguns `x` também são removidos.
- Fim de jogo:
  - Se um dos jogadores não tem peças, o outro vence.
  - Se ambos não têm peças, ganha o último jogador a mover.

Detalhes técnicos importantes
----------------------------
- Representação interna do tabuleiro: lista de linhas; para aceder a (Row,Col) usa-se uma conversão que inverte a ordem das linhas (para manter (1,1) como bottom-left).
- Validação de movimentos usa um predicado `queen_path_clear` que verifica direção e células intermédias.
- Geração de todas as jogadas válidas usa `findall/3` e predicados auxiliares implementados no ficheiro.
- A função Greedy simula o efeito do movimento (aplica `move` e `remove_surrounded_pieces`) e calcula a heurística do estado resultante.
- A escrita do resultado final ocorre em `last_game_result.txt` no diretório atual.


------------
Este projeto implementa uma versão jogável do Blackstone com várias variantes e uma IA básica. É um bom ponto de partida para expandir a IA e a interface, e para formalizar regras alternativas ou melhorias na usabilidade.
