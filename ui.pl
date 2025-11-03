% ui.pl - Interface de coleta de dados do usuário
% Faz perguntas e armazena as respostas como observações

:- dynamic obs/1.

% Coleta todos os dados necessários para calcular a entrega
coletar_dados :-
  coletar_distancia,
  coletar_peso,
  coletar_urgencia,
  coletar_periodo,
  coletar_zona,
  coletar_fragil,
  coletar_entregas_mes.

% Coleta a distância da entrega
coletar_distancia :-
  format("~nDistancia da entrega (em km): "),
  read(Dist),
  ( number(Dist), Dist > 0 ->
      assertz(obs(distancia(Dist)))
  ; format("Distancia invalida! Usando valor padrao: 5 km~n"),
    assertz(obs(distancia(5))) ).

% Coleta o peso do pacote
coletar_peso :-
  format("Peso do pacote (em kg): "),
  read(Peso),
  ( number(Peso), Peso > 0 ->
      assertz(obs(peso(Peso)))
  ; format("Peso invalido! Usando valor padrao: 5 kg~n"),
    assertz(obs(peso(5))) ).

% Coleta o nível de urgência
coletar_urgencia :-
  format("~nNivel de urgencia:~n"),
  format("  1 - Expressa (ate 2 horas)~n"),
  format("  2 - Rapida (mesmo dia)~n"),
  format("  3 - Normal (1-2 dias)~n"),
  format("  4 - Economica (3-5 dias)~n"),
  format("Escolha (1-4): "),
  read(Escolha),
  mapear_urgencia(Escolha, Urg),
  assertz(obs(urgencia(Urg))).

% Mapeia a escolha numérica para o átomo de urgência
mapear_urgencia(1, expressa) :- !.
mapear_urgencia(2, rapida) :- !.
mapear_urgencia(3, normal) :- !.
mapear_urgencia(4, economica) :- !.
mapear_urgencia(_, normal) :-
  format("Opcao invalida! Usando urgencia normal.~n").

% Coleta o período do dia
coletar_periodo :-
  format("~nPeriodo da entrega:~n"),
  format("  1 - Noturno (22h-6h) +50%%~n"),
  format("  2 - Horario de pico (7h-9h, 17h-19h) +30%%~n"),
  format("  3 - Horario normal~n"),
  format("Escolha (1-3): "),
  read(Escolha),
  mapear_periodo(Escolha, Per),
  assertz(obs(periodo(Per))).

% Mapeia a escolha numérica para o átomo de período
mapear_periodo(1, noturno) :- !.
mapear_periodo(2, pico) :- !.
mapear_periodo(3, normal) :- !.
mapear_periodo(_, normal) :-
  format("Opcao invalida! Usando periodo normal.~n").

% Coleta a zona de entrega
coletar_zona :-
  format("~nZona de entrega:~n"),
  format("  1 - Centro (transito intenso)~n"),
  format("  2 - Suburbio (transito moderado)~n"),
  format("  3 - Periferia (distancias maiores)~n"),
  format("Escolha (1-3): "),
  read(Escolha),
  mapear_zona(Escolha, Zona),
  assertz(obs(zona(Zona))).

% Mapeia a escolha numérica para o átomo de zona
mapear_zona(1, centro) :- !.
mapear_zona(2, suburbio) :- !.
mapear_zona(3, periferia) :- !.
mapear_zona(_, suburbio) :-
  format("Opcao invalida! Usando suburbio.~n").

% Coleta se o produto é frágil
coletar_fragil :-
  format("~nO produto e fragil? (s/n): "),
  read(Resp),
  mapear_sim_nao(Resp, Fragil),
  assertz(obs(fragil(Fragil))).

% Coleta o número de entregas no mês (para desconto)
coletar_entregas_mes :-
  format("Quantas entregas ja fez este mes? (para desconto): "),
  read(N),
  ( integer(N), N >= 0 ->
      assertz(obs(entregas_mes(N)))
  ; format("Numero invalido! Usando 0 (sem desconto)~n"),
    assertz(obs(entregas_mes(0))) ).

% Mapeia resposta s/n para sim/nao
mapear_sim_nao(s, sim) :- !.
mapear_sim_nao(n, nao) :- !.
mapear_sim_nao(_, nao) :-
  format("Resposta invalida! Usando 'nao'.~n").

% Exibe o resultado formatado
exibir_resultado(entrega(Veiculo, Custo, Prazo)) :-
  format("~nVeiculo selecionado: ~w~n", [Veiculo]),
  format("Custo total: R$ ~2f~n", [Custo]),
  PrazoHoras is Prazo / 60,
  ( Prazo >= 60 ->
      format("Prazo estimado: ~0f horas e ~0f minutos~n", 
             [floor(PrazoHoras), Prazo mod 60])
  ; format("Prazo estimado: ~0f minutos~n", [Prazo]) ).