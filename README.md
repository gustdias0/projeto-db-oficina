# Workshop Database System (Oficina Mecânica)

Projeto lógico de banco de dados para o gerenciamento de uma Oficina Mecânica. O sistema controla o fluxo desde a entrada do veículo até a finalização do serviço, gerenciando equipes, peças e mão de obra.

## Modelagem Lógica

O esquema foi desenvolvido para atender a relacionamentos complexos do cenário automotivo:
- **ServiceOrders (OS):** Entidade central que conecta Veículos e Equipes.
- **Teams (Equipes):** Mecânicos são organizados em times para atender uma OS.
- **Services & Parts:** Relacionamento N:M com a Ordem de Serviço, permitindo que uma única OS contenha múltiplos serviços e múltiplas peças.

## Estrutura de Diretórios
- `schema_workshop.sql`: Script DDL para criação das tabelas e constraints.
- `queries_and_data.sql`: Script DML para inserção de dados fictícios e queries de relatório.

## Consultas Implementadas
O projeto inclui queries SQL para:
1. Cálculo dinâmico do valor total da OS (Soma de Peças + Mão de Obra).
2. Relatórios de peças mais utilizadas (Gestão de Estoque).
3. Histórico de serviços por cliente e veículo.
