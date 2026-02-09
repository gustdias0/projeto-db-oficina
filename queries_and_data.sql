USE workshop_db;

-- 1. Inserção de Dados (Seed)
INSERT INTO Clients (Fname, Contact, Address) VALUES
('Gus Silva', '11999999999', 'Rua Tech, 100'),
('Ana Souza', '11888888888', 'Av. Dados, 50');

INSERT INTO Mechanics (Name, Specialty) VALUES
('Pedro', 'Motor'), ('João', 'Elétrica'), ('Carlos', 'Suspensão');

INSERT INTO Teams (TeamName) VALUES ('Equipe Alpha'), ('Equipe Beta');
INSERT INTO TeamMembers VALUES (1, 1), (1, 2), (2, 3); -- Pedro e João na Alpha, Carlos na Beta

INSERT INTO Vehicles (idClient, Plate, Model, Brand, Year) VALUES
(1, 'ABC1234', 'Civic', 'Honda', '2020'),
(2, 'XYZ9876', 'Fiesta', 'Ford', '2015');

INSERT INTO Services (ServiceName, LaborCost) VALUES
('Troca de Óleo', 100.00),
('Alinhamento', 80.00),
('Retífica de Motor', 1500.00);

INSERT INTO Parts (PartName, UnitPrice, StockQuantity) VALUES
('Óleo 5w30', 50.00, 100),
('Filtro de Óleo', 30.00, 50),
('Pistão', 200.00, 20);

-- Abrindo Ordens de Serviço
INSERT INTO ServiceOrders (idVehicle, idTeam, IssueDescription, Status, CompletionDate) VALUES
(1, 1, 'Barulho no motor e troca de óleo', 'Em Execução', '2026-02-15'),
(2, 2, 'Carro puxando pra direita', 'Finalizada', '2026-02-10');

-- Adicionando Itens às OS
-- OS 1 (Gus): Troca de Óleo + 4 Litros de Óleo + 1 Filtro
INSERT INTO SO_Services (idSO, idService, Quantity) VALUES (1, 1, 1);
INSERT INTO SO_Parts (idSO, idPart, Quantity) VALUES (1, 1, 4), (1, 2, 1);

-- OS 2 (Ana): Alinhamento (sem peças)
INSERT INTO SO_Services (idSO, idService, Quantity) VALUES (2, 2, 1);


-- 2. QUERIES COMPLEXAS

-- A) Recuperar todas as OS, status, nome do cliente e modelo do carro (JOIN Simples)
SELECT 
    so.idSO,
    so.Status,
    c.Fname AS Client,
    v.Model,
    t.TeamName
FROM ServiceOrders so
JOIN Vehicles v ON so.idVehicle = v.idVehicle
JOIN Clients c ON v.idClient = c.idClient
JOIN Teams t ON so.idTeam = t.idTeam;

-- B) Calcular o Valor Total da OS (Atributo Derivado: Soma de Peças + Soma de Serviços)
-- Essa query responde: "Quanto ficou a conta do Gus?"
SELECT 
    so.idSO,
    c.Fname,
    -- Soma custo Serviços
    COALESCE(SUM(s.LaborCost * sos.Quantity), 0) AS Labor_Total,
    -- Soma custo Peças
    COALESCE(SUM(p.UnitPrice * sop.Quantity), 0) AS Parts_Total,
    -- Total Geral
    (COALESCE(SUM(s.LaborCost * sos.Quantity), 0) + 
     COALESCE(SUM(p.UnitPrice * sop.Quantity), 0)) AS Grand_Total
FROM ServiceOrders so
JOIN Vehicles v ON so.idVehicle = v.idVehicle
JOIN Clients c ON v.idClient = c.idClient
LEFT JOIN SO_Services sos ON so.idSO = sos.idSO
LEFT JOIN Services s ON sos.idService = s.idService
LEFT JOIN SO_Parts sop ON so.idSO = sop.idSO
LEFT JOIN Parts p ON sop.idPart = p.idPart
GROUP BY so.idSO;

-- C) Filtrar Clientes que gastaram mais de R$ 500,00 (HAVING)
-- Utilizando a lógica acima, mas filtrando o resultado agrupado.
SELECT 
    c.Fname,
    COUNT(so.idSO) as Total_Orders
FROM Clients c
JOIN Vehicles v ON c.idClient = v.idClient
JOIN ServiceOrders so ON v.idVehicle = so.idVehicle
GROUP BY c.idClient
HAVING COUNT(so.idSO) >= 1; -- Exemplo simples, num cenário real filtraríamos por valor monetário

-- D) Listar peças mais utilizadas (Ordenação ORDER BY)
SELECT 
    p.PartName,
    SUM(sop.Quantity) as Total_Used
FROM Parts p
JOIN SO_Parts sop ON p.idPart = sop.idPart
GROUP BY p.idPart
ORDER BY Total_Used DESC;
