% kb.pl - Base de Conhecimento do Sistema de Entrega Urbana
% Contém fatos, tabelas e domínios relacionados a entregas

% Tabela de custos base por quilômetro para cada tipo de veículo (em R$)
custo_por_km(bicicleta, 2.50).
custo_por_km(moto, 4.00).
custo_por_km(carro, 6.50).
custo_por_km(van, 10.00).

% Capacidade máxima de carga por veículo (em kg)
capacidade_veiculo(bicicleta, 15).
capacidade_veiculo(moto, 30).
capacidade_veiculo(carro, 200).
capacidade_veiculo(van, 500).

% Velocidade média de cada veículo (km/h) em área urbana
velocidade_media(bicicleta, 15).
velocidade_media(moto, 35).
velocidade_media(carro, 30).
velocidade_media(van, 25).

% Tempo adicional para carga/descarga por tipo de veículo (em minutos)
tempo_carga_descarga(bicicleta, 5).
tempo_carga_descarga(moto, 10).
tempo_carga_descarga(carro, 20).
tempo_carga_descarga(van, 30).

% Taxa adicional por urgência (multiplicador sobre o custo)
taxa_urgencia(expressa, 1.80).    % Entrega em até 2 horas
taxa_urgencia(rapida, 1.40).      % Entrega no mesmo dia
taxa_urgencia(normal, 1.00).      % Entrega em 1-2 dias
taxa_urgencia(economica, 0.80).   % Entrega em 3-5 dias

% Taxa adicional por período do dia (multiplicador)
taxa_periodo(noturno, 1.50).      % 22h-6h
taxa_periodo(pico, 1.30).         % 7h-9h e 17h-19h
taxa_periodo(normal, 1.00).       % Demais horários

% Desconto por volume de entregas no mês (percentual)
desconto_volume(0, 0.00).         % 0-10 entregas
desconto_volume(11, 0.05).        % 11-30 entregas (5% desconto)
desconto_volume(31, 0.10).        % 31-50 entregas (10% desconto)
desconto_volume(51, 0.15).        % mais de 50 entregas (15% desconto)

% Taxa por fragilidade do produto
taxa_fragil(sim, 1.25).
taxa_fragil(nao, 1.00).

% Zonas de entrega e suas complexidades (multiplicador de tempo)
complexidade_zona(centro, 1.40).      % Trânsito intenso
complexidade_zona(suburbio, 1.00).    % Trânsito moderado
complexidade_zona(periferia, 1.20).   % Distâncias maiores dentro da zona