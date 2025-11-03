% main.pl - Sistema Especialista de Entrega Urbana
% Carrega todos os módulos necessários

:- ['kb.pl', 'rules.pl', 'ui.pl', 'explain.pl'].

% Predicado principal para iniciar o sistema
start :-
  banner,
  menu.

% Exibe o banner inicial do sistema
banner :-
  format("~n╔════════════════════════════════════════════════════════╗~n"),
  format("║   Sistema Especialista - Entrega Urbana               ║~n"),
  format("║   Calcula custo, prazo e melhor veículo para entrega  ║~n"),
  format("╚════════════════════════════════════════════════════════╝~n"),
  format("~nDesenvolvido por: [Seu Nome] (@seu-usuario-github)~n~n").

% Menu principal com opções
menu :-
  format("~n========== MENU PRINCIPAL ==========~n"),
  format("1) Executar consulta de entrega~n"),
  format("2) Sair~n"),
  format("====================================~n"),
  format("Escolha uma opcao: "),
  read(Opcao),
  processar_opcao(Opcao).

% Processa a opção escolhida pelo usuário
processar_opcao(1) :-
  !,
  executar_consulta,
  limpar_dados,
  menu.

processar_opcao(2) :-
  !,
  format("~nEncerrando o sistema... Até logo!~n").

processar_opcao(_) :-
  format("~nOpcao invalida! Tente novamente.~n"),
  menu.

% Executa uma consulta completa de entrega
executar_consulta :-
  format("~n========== NOVA CONSULTA DE ENTREGA ==========~n"),
  coletar_dados,
  ( calcular_entrega(Resultado) ->
      format("~n========== RESULTADO ==========~n"),
      exibir_resultado(Resultado),
      explicar_resultado(Resultado)
  ; format("~nNao foi possivel calcular a entrega. Verifique os dados informados.~n") ).

% Limpa os dados da consulta anterior
limpar_dados :- retractall(obs(_)).