CREATE DATABASE IF NOT EXISTS workshop_db;
USE workshop_db;

-- Tabela Clientes
CREATE TABLE Clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Contact CHAR(11) NOT NULL,
    Address VARCHAR(255)
);

-- Tabela Mecânicos
CREATE TABLE Mechanics (
    idMechanic INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Address VARCHAR(255),
    Specialty VARCHAR(50) -- Ex: Motor, Elétrica, Suspensão
);

-- Tabela Veículos (Pertence a um Cliente)
CREATE TABLE Vehicles (
    idVehicle INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    Plate CHAR(7) NOT NULL UNIQUE,
    Model VARCHAR(50),
    Brand VARCHAR(50),
    Year CHAR(4),
    FOREIGN KEY (idClient) REFERENCES Clients(idClient)
);

-- Tabela Equipes (Agrupa mecânicos para uma OS)
CREATE TABLE Teams (
    idTeam INT AUTO_INCREMENT PRIMARY KEY,
    TeamName VARCHAR(50)
);

-- Tabela N:M (Mecânicos compõem Equipes)
CREATE TABLE TeamMembers (
    idTeam INT,
    idMechanic INT,
    PRIMARY KEY (idTeam, idMechanic),
    FOREIGN KEY (idTeam) REFERENCES Teams(idTeam),
    FOREIGN KEY (idMechanic) REFERENCES Mechanics(idMechanic)
);

-- Tabela Ordem de Serviço (OS) - O coração do sistema
CREATE TABLE ServiceOrders (
    idSO INT AUTO_INCREMENT PRIMARY KEY,
    idVehicle INT,
    idTeam INT,
    IssueDescription VARCHAR(255),
    Status ENUM('Aberta', 'Em Análise', 'Em Execução', 'Finalizada', 'Cancelada') DEFAULT 'Aberta',
    CompletionDate DATE,
    TotalAmount DECIMAL(10, 2) DEFAULT 0.00, -- Valor calculado
    FOREIGN KEY (idVehicle) REFERENCES Vehicles(idVehicle),
    FOREIGN KEY (idTeam) REFERENCES Teams(idTeam)
);

-- Tabela de Serviços (Mão de Obra tabelada)
CREATE TABLE Services (
    idService INT AUTO_INCREMENT PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL,
    LaborCost DECIMAL(10, 2) NOT NULL
);

-- Tabela de Peças (Estoque)
CREATE TABLE Parts (
    idPart INT AUTO_INCREMENT PRIMARY KEY,
    PartName VARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    StockQuantity INT DEFAULT 0
);

-- Relacionamento OS <-> Serviços
CREATE TABLE SO_Services (
    idSO INT,
    idService INT,
    Quantity INT DEFAULT 1,
    PRIMARY KEY (idSO, idService),
    FOREIGN KEY (idSO) REFERENCES ServiceOrders(idSO),
    FOREIGN KEY (idService) REFERENCES Services(idService)
);

-- Relacionamento OS <-> Peças
CREATE TABLE SO_Parts (
    idSO INT,
    idPart INT,
    Quantity INT DEFAULT 1,
    PRIMARY KEY (idSO, idPart),
    FOREIGN KEY (idSO) REFERENCES ServiceOrders(idSO),
    FOREIGN KEY (idPart) REFERENCES Parts(idPart)
);
