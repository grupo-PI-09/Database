DROP DATABASE IF EXISTS rr_maxx;

CREATE DATABASE IF NOT EXISTS rr_maxx;
USE rr_maxx;

-- TABELA: usuarios
CREATE TABLE usuarios (
    id_usuarios INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(50) NOT NULL UNIQUE,
    email_usuario VARCHAR(50),
    senha VARCHAR(12) NOT NULL,
    perfil ENUM('admin', 'mecanico') NOT NULL,
    ativo TINYINT(1) NOT NULL DEFAULT 1,
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- TABELA: clientes
CREATE TABLE clientes (
    id_clientes INT AUTO_INCREMENT PRIMARY KEY,
    nome_usuario VARCHAR(50) NOT NULL,
    dt_nascimento DATE,
    telefone VARCHAR(11),
    email_usuario VARCHAR(100),
    endereco VARCHAR(100),
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ativo TINYINT(1) NOT NULL DEFAULT 1
);

-- TABELA: veiculos
CREATE TABLE veiculos (
    id_veiculos INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    placa VARCHAR(10) NOT NULL UNIQUE,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    ano INT,
    quilometragem INT,
    tipo_combustivel ENUM('gasolina', 'etanol', 'flex') NOT NULL,
    ativo TINYINT(1) NOT NULL DEFAULT 1,
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_veiculo_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes(id_clientes)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- TABELA: ordens_servico
CREATE TABLE ordens_servico (
    id_ordens_servico INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    veiculo_id INT NOT NULL,
    usuario_id INT,
    data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_fechamento DATETIME NULL,
    status ENUM(
        'aberta',
        'em_andamento',
        'aguardando_aprovacao',
        'aguardando_peca',
        'finalizada',
        'cancelada'
    ) NOT NULL DEFAULT 'aberta',
    problema_relatado TEXT,
    diagnostico TEXT,
    quilometragem INT,
    valor_estimado DECIMAL(10,2) DEFAULT 0.00,
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    forma_pagamento VARCHAR(50),
    observacoes TEXT,
    CONSTRAINT fk_os_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes(id_clientes)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_os_veiculo
        FOREIGN KEY (veiculo_id) REFERENCES veiculos(id_veiculos)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_os_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuarios)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- TABELA: servicos_realizados
CREATE TABLE servicos_realizados (
    id_servicos_realizados INT AUTO_INCREMENT PRIMARY KEY,
    ordem_servico_id INT NOT NULL,
    nome_servico VARCHAR(100) NOT NULL,
    descricao TEXT,
    tipo_servico ENUM('preventiva', 'corretiva') NOT NULL DEFAULT 'corretiva',
    valor DECIMAL(10,2) NOT NULL,
    data_servico DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_servico_os
        FOREIGN KEY (ordem_servico_id) REFERENCES ordens_servico(id_ordens_servico)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- TABELA: garantias
CREATE TABLE garantias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    servico_id INT NOT NULL,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME GENERATED ALWAYS AS (DATE_ADD(data_inicio, INTERVAL 3 MONTH)) STORED,
    status ENUM('ativa', 'encerrada', 'cancelada') NOT NULL DEFAULT 'ativa',
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_garantia_servico
        FOREIGN KEY (servico_id) REFERENCES servicos_realizados(id_servicos_realizados)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- TABELA: notificacoes
CREATE TABLE notificacoes (
    id_notificacoes INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    veiculo_id INT NULL,
    ordem_servico_id INT NULL,
    tipo ENUM(
        'pos_servico',
        'aniversario',
        'oferta',
        'revisao_preventiva',
        'status_os',
        'retorno'
    ) NOT NULL,
    assunto VARCHAR(150) NOT NULL,
    mensagem TEXT NOT NULL,
    canal ENUM('whatsapp', 'sms', 'email') NOT NULL DEFAULT 'whatsapp',
    status ENUM('pendente', 'enviada', 'erro') NOT NULL DEFAULT 'pendente',
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_agendamento DATETIME NULL,
    data_envio DATETIME NULL,
    CONSTRAINT fk_notificacao_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes(id_clientes)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_notificacao_veiculo
        FOREIGN KEY (veiculo_id) REFERENCES veiculos(id_veiculos)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT fk_notificacao_os
        FOREIGN KEY (ordem_servico_id) REFERENCES ordens_servico(id_ordens_servico)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);