% explain.pl - Módulo de explicação da trilha de decisões
% Mostra quais regras foram acionadas e por quê

% Explica como o resultado foi calculado
explicar_resultado(entrega(Veiculo, CustoFinal, Prazo)) :-
  format("~n========== EXPLICACAO DO RESULTADO ==========~n"),
  explicar_veiculo(Veiculo),
  explicar_custo(Veiculo, CustoFinal),
  explicar_prazo(Veiculo, Prazo),
  format("=============================================~n").

% Explica por que o veículo foi escolhido
explicar_veiculo(Veiculo) :-
  format("~n[1] SELECAO DO VEICULO: ~w~n", [Veiculo]),
  obs(peso(Peso)),
  capacidade_veiculo(Veiculo, Cap),
  format("   - Peso do pacote: ~w kg~n", [Peso]),
  format("   - Capacidade do veiculo: ~w kg~n", [Cap]),
  ( obs(urgencia(expressa)), Veiculo = moto ->
      format("   - Regra aplicada: Urgencia EXPRESSA prioriza velocidade (moto escolhida)~n")
  ; format("   - Regra aplicada: Veiculo mais economico que suporta o peso~n") ).

% Explica como o custo foi calculado
explicar_custo(Veiculo, CustoFinal) :-
  format("~n[2] CALCULO DO CUSTO:~n"),
  
  % Custo base
  obs(distancia(Dist)),
  custo_por_km(Veiculo, CustoKm),
  CustoBase is Dist * CustoKm,
  format("   - Custo base: ~w km x R$ ~2f/km = R$ ~2f~n", 
         [Dist, CustoKm, CustoBase]),
  
  % Taxa de urgência
  obs(urgencia(Urg)),
  taxa_urgencia(Urg, TaxaUrg),
  CustoAposUrg is CustoBase * TaxaUrg,
  format("   - Taxa urgencia (~w): x~2f = R$ ~2f~n", 
         [Urg, TaxaUrg, CustoAposUrg]),
  
  % Taxa de período
  obs(periodo(Per)),
  taxa_periodo(Per, TaxaPer),
  CustoAposPer is CustoAposUrg * TaxaPer,
  format("   - Taxa periodo (~w): x~2f = R$ ~2f~n", 
         [Per, TaxaPer, CustoAposPer]),
  
  % Taxa de fragilidade
  obs(fragil(Frag)),
  taxa_fragil(Frag, TaxaFrag),
  CustoAposFrag is CustoAposPer * TaxaFrag,
  format("   - Taxa fragilidade (~w): x~2f = R$ ~2f~n", 
         [Frag, TaxaFrag, CustoAposFrag]),
  
  % Desconto por volume
  obs(entregas_mes(N)),
  obter_desconto(N, Desc),
  DescPerc is Desc * 100,
  format("   - Desconto volume (~w entregas/mes): -~0f%% = R$ ~2f~n", 
         [N, DescPerc, CustoFinal]),
  
  format("   >> CUSTO FINAL: R$ ~2f~n", [CustoFinal]).

% Explica como o prazo foi calculado
explicar_prazo(Veiculo, PrazoTotal) :-
  format("~n[3] CALCULO DO PRAZO:~n"),
  
  obs(distancia(Dist)),
  obs(zona(Zona)),
  velocidade_media(Veiculo, Vel),
  tempo_carga_descarga(Veiculo, TempoCarga),
  complexidade_zona(Zona, Compl),
  
  TempoViagem is (Dist / Vel) * 60 * Compl,
  
  format("   - Distancia: ~w km~n", [Dist]),
  format("   - Velocidade media do ~w: ~w km/h~n", [Veiculo, Vel]),
  format("   - Complexidade zona (~w): x~2f~n", [Zona, Compl]),
  format("   - Tempo de viagem: ~0f minutos~n", [round(TempoViagem)]),
  format("   - Tempo carga/descarga: ~w minutos~n", [TempoCarga]),
  format("   >> PRAZO TOTAL: ~w minutos~n", [PrazoTotal]),
  
  % Verifica se atende a urgência
  verificar_atendimento_urgencia(PrazoTotal).

% Verifica se o prazo calculado atende a urgência solicitada
verificar_atendimento_urgencia(Prazo) :-
  obs(urgencia(Urg)),
  ( Urg = expressa, Prazo =< 120 ->
      format("   - Status: ATENDE urgencia expressa (ate 2h)~n")
  ; Urg = expressa, Prazo > 120 ->
      format("   - AVISO: NAO ATENDE urgencia expressa! Excede 2h.~n")
  ; Urg = rapida, Prazo =< 480 ->
      format("   - Status: ATENDE urgencia rapida (mesmo dia)~n")
  ; Urg = rapida, Prazo > 480 ->
      format("   - AVISO: NAO ATENDE urgencia rapida! Excede 8h.~n")
  ; format("   - Status: Prazo adequado para urgencia ~w~n", [Urg]) ).

% Obtém o desconto (compartilhado com rules.pl)
obter_desconto(N, Desc) :-
  N >= 51, !, desconto_volume(51, Desc).
obter_desconto(N, Desc) :-
  N >= 31, !, desconto_volume(31, Desc).
obter_desconto(N, Desc) :-
  N >= 11, !, desconto_volume(11, Desc).
obter_desconto(_, Desc) :-
  desconto_volume(0, Desc).