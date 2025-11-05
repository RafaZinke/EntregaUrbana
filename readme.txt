

    Rafael Zink - https://github.com/RafaZinke/EntregaUrbana
    

Sobre o Projeto

Este sistema especialista utiliza programação lógica em Prolog para auxiliar empresas de entrega urbana a:

    Selecionar o veículo mais adequado (bicicleta, moto, carro ou van)
    Calcular o custo total da entrega considerando múltiplos fatores
    Estimar o prazo de entrega
    Aplicar descontos por volume e taxas adicionais
    Explicar o raciocínio por trás das decisões

Funcionalidades

O sistema considera os seguintes fatores:

    Distância da entrega (km)
    Peso do pacote (kg)
    Urgência (expressa, rápida, normal, econômica)
    Período (noturno, pico, normal)
    Zona (centro, subúrbio, periferia)
    Fragilidade do produto
    Volume de entregas no mês (para desconto)

Como Instalar
Pré-requisitos

    SWI-Prolog instalado no sistema
        Download: https://www.swi-prolog.org/download/stable

Instalação

    Clone o repositório:

bash

git clone https://github.com/seu-usuario/entrega-urbana-prolog.git
cd entrega-urbana-prolog

    Ou baixe os arquivos manualmente e organize na seguinte estrutura:

entrega_urbana/
├── src/
│   ├── main.pl
│   ├── kb.pl
│   ├── rules.pl
│   ├── ui.pl
│   └── explain.pl
└── README.md

Como Executar
No Windows (Prompt de Comando ou PowerShell):
cmd

cd entrega_urbana
swipl

Dentro do SWI-Prolog:
prolog

?- ['src/main.pl'].
?- start.


Alternativa - Linha única:
bash

swipl -s src/main.pl -g start

📖 Como Usar

    Execute o comando start.
    Escolha a opção 1 (Executar consulta de entrega)
    Responda as perguntas sobre a entrega:
        Distância em km
        Peso em kg
        Nível de urgência
        Período do dia
        Zona de entrega
        Se o produto é frágil
        Quantidade de entregas no mês
    O sistema exibirá:
        Veículo selecionado
        Custo total
        Prazo estimado
        Explicação detalhada de como chegou ao resultado

Exemplos de Entrada e Saída
Exemplo 1: Entrega Expressa no Centro

Entrada:

Distancia da entrega (em km): 8.
Peso do pacote (em kg): 3.
Nivel de urgencia: 1 (Expressa)
Periodo da entrega: 2 (Horário de pico)
Zona de entrega: 1 (Centro)
O produto e fragil? (s/n): s.
Quantas entregas ja fez este mes?: 25.

Saída:

========== RESULTADO ==========
Veiculo selecionado: moto
Custo total: R$ 72.57
Prazo estimado: 0 horas e 38 minutos

========== EXPLICACAO DO RESULTADO ==========
[1] SELECAO DO VEICULO: moto
   - Peso do pacote: 3 kg
   - Capacidade do veiculo: 30 kg
   - Regra aplicada: Urgencia EXPRESSA prioriza velocidade (moto escolhida)

[2] CALCULO DO CUSTO:
   - Custo base: 8 km x R$ 4.00/km = R$ 32.00
   - Taxa urgencia (expressa): x1.80 = R$ 57.60
   - Taxa periodo (pico): x1.30 = R$ 74.88
   - Taxa fragilidade (sim): x1.25 = R$ 93.60
   - Desconto volume (25 entregas/mes): -5% = R$ 88.92
   >> CUSTO FINAL: R$ 88.92

[3] CALCULO DO PRAZO:
   - Distancia: 8 km
   - Velocidade media do moto: 35 km/h
   - Complexidade zona (centro): x1.40
   - Tempo de viagem: 27 minutos
   - Tempo carga/descarga: 10 minutos
   >> PRAZO TOTAL: 38 minutos
   - Status: ATENDE urgencia expressa (ate 2h)

Exemplo 2: Entrega Econômica na Periferia

Entrada:

Distancia da entrega (em km): 15.
Peso do pacote (em kg): 120.
Nivel de urgencia: 4 (Economica)
Periodo da entrega: 3 (Normal)
Zona de entrega: 3 (Periferia)
O produto e fragil? (s/n): n.
Quantas entregas ja fez este mes?: 5.

Saída:

========== RESULTADO ==========
Veiculo selecionado: carro
Custo total: R$ 78.00
Prazo estimado: 1 horas e 6 minutos

 Regras Implementadas

O sistema implementa 10 regras principais:

    Seleção de veículo baseado no peso: Escolhe veículos que suportam a carga
    Priorização por urgência: Entregas expressas priorizam motos (mais rápidas)
    Cálculo de custo base: Distância × custo por km do veículo
    Taxa de urgência: Multiplica custo (expressa +80%, rápida +40%, etc)
    Taxa de período: Adiciona custo em horários especiais (noturno +50%, pico +30%)
    Taxa de fragilidade: Produtos frágeis têm acréscimo de 25%
    Desconto por volume: 5-15% de desconto conforme entregas mensais
    Custo total: Aplica todas as taxas e descontos sequencialmente
    Cálculo de prazo: Considera velocidade, distância, complexidade da zona e tempo de carga
    Validação de urgência: Verifica se o veículo atende o prazo solicitado

 Estrutura dos Arquivos

    main.pl: Menu principal e orquestração do sistema
    kb.pl: Base de conhecimento (fatos, tabelas, domínios)
    rules.pl: Regras de negócio e inferências
    ui.pl: Interface de coleta de dados do usuário
    explain.pl: Explicação da trilha de decisões

 Tecnologias

    SWI-Prolog: Interpretador Prolog utilizado
    Programação Lógica: Paradigma de resolução por inferência

 Observações

    Valores padrão são aplicados em caso de entradas inválidas
    O sistema sempre explica como chegou aos resultados
    Todas as taxas e valores podem ser ajustados em kb.pl
    O sistema avisa quando o prazo não atende a urgência solicitada

 Suporte

Para dúvidas ou problemas:

    Verifique se o SWI-Prolog está instalado corretamente
    Certifique-se de estar no diretório correto
    Confira se todos os arquivos .pl estão na pasta src/
    Abra uma issue no repositório GitHub

 Licença

Este projeto foi desenvolvido para fins acadêmicos como trabalho da disciplina de Inteligência Artificial.

