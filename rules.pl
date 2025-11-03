% rules.pl - Regras de Negócio do Sistema de Entrega Urbana
% Define as regras para calcular custos, prazos e selecionar veículos

:- dynamic obs/1.

% Meta principal: calcula toda a informação da entrega
% Retorna: entrega(Veiculo, CustoFinal, PrazoMinutos)
calcular_entrega(entrega(Veiculo, CustoFinal, PrazoMinutos)) :-
  selecionar_veiculo(Veiculo),
  calcular_custo_total(Veiculo, CustoFinal),
  calcular_prazo_total(Veiculo, PrazoMinutos).

% ===== REGRA 1: Seleção de veículo baseado no peso =====
% Escolhe o veículo mais adequado considerando capacidade e custo
selecionar_veiculo(Veiculo) :-
  obs(peso(Peso)),
  veiculos_adequados(Peso, Veiculos),
  Veiculos \= [],
  melhor_veiculo(Veiculos, Veiculo).

% Encontra todos os veículos que suportam o peso
veiculos_adequados(Peso, Veiculos) :-
  findall(V, (capacidade_veiculo(V, Cap), Peso =< Cap), Veiculos).

% ===== REGRA 2: Escolha do melhor veículo considerando urgência =====
% Se for expressa, prioriza velocidade (moto); senão, prioriza economia
melhor_veiculo(Veiculos, Veiculo) :-
  obs(urgencia(expressa)),
  member(moto, Veiculos),
  !,
  Veiculo = moto.

melhor_veiculo(Veiculos, Veiculo) :-
  obs(urgencia(expressa)),
  !,
  Veiculos = [Veiculo|_].

melhor_veiculo(Veiculos, Veiculo) :-
  escolher_mais_economico(Veiculos, Veiculo).

% Escolhe o veículo de menor custo por km
escolher_mais_economico([V], V) :- !.
escolher_mais_economico([V1|Resto], Melhor) :-
  escolher_mais_economico(Resto, V2),
  custo_por_km(V1, C1),
  custo_por_km(V2, C2),
  ( C1 =< C2 -> Melhor = V1 ; Melhor = V2 ).

% ===== REGRA 3: Cálculo do custo base (distância x custo/km) =====
custo_base(Veiculo, CustoBase) :-
  obs(distancia(Dist)),
  custo_por_km(Veiculo, CustoKm),
  CustoBase is Dist * CustoKm.

% ===== REGRA 4: Aplicação da taxa de urgência =====
aplicar_taxa_urgencia(Custo, CustoComUrgencia) :-
  obs(urgencia(Urg)),
  taxa_urgencia(Urg, Taxa),
  CustoComUrgencia is Custo * Taxa.

% ===== REGRA 5: Aplicação da taxa de período do dia =====
aplicar_taxa_periodo(Custo, CustoComPeriodo) :-
  obs(periodo(Per)),
  taxa_periodo(Per, Taxa),
  CustoComPeriodo is Custo * Taxa.

% ===== REGRA 6: Aplicação da taxa de fragilidade =====
aplicar_taxa_fragil(Custo, CustoComFragil) :-
  obs(fragil(Frag)),
  taxa_fragil(Frag, Taxa),
  CustoComFragil is Custo * Taxa.

% ===== REGRA 7: Aplicação de desconto por volume =====
aplicar_desconto_volume(Custo, CustoFinal) :-
  obs(entregas_mes(N)),
  obter_desconto(N, Desc),
  CustoFinal is Custo * (1 - Desc).

% Determina o desconto baseado no número de entregas
obter_desconto(N, Desc) :-
  N >= 51, !, desconto_volume(51, Desc).
obter_desconto(N, Desc) :-
  N >= 31, !, desconto_volume(31, Desc).
obter_desconto(N, Desc) :-
  N >= 11, !, desconto_volume(11, Desc).
obter_desconto(_, Desc) :-
  desconto_volume(0, Desc).

% ===== REGRA 8: Cálculo do custo total (aplica todas as taxas) =====
calcular_custo_total(Veiculo, CustoFinal) :-
  custo_base(Veiculo, C1),
  aplicar_taxa_urgencia(C1, C2),
  aplicar_taxa_periodo(C2, C3),
  aplicar_taxa_fragil(C3, C4),
  aplicar_desconto_volume(C4, CustoFinal).

% ===== REGRA 9: Cálculo do prazo de entrega =====
% Prazo = (distância / velocidade) * 60 + tempo de carga/descarga + ajuste por zona
calcular_prazo_total(Veiculo, PrazoTotal) :-
  obs(distancia(Dist)),
  obs(zona(Zona)),
  velocidade_media(Veiculo, Vel),
  tempo_carga_descarga(Veiculo, TempoCarga),
  complexidade_zona(Zona, Complexidade),
  TempoViagem is (Dist / Vel) * 60 * Complexidade,
  PrazoTotal is round(TempoViagem + TempoCarga).

% ===== REGRA 10: Validação de urgência vs prazo disponível =====
% Verifica se o veículo consegue atender a urgência solicitada
validar_urgencia(Veiculo, PrazoCalculado) :-
  obs(urgencia(expressa)),
  PrazoCalculado =< 120, !.  % Expressa: máximo 2h

validar_urgencia(Veiculo, PrazoCalculado) :-
  obs(urgencia(rapida)),
  PrazoCalculado =< 480, !.  % Rápida: máximo 8h (mesmo dia)

validar_urgencia(_, _).  % Normal e econômica: sem restrição de prazo