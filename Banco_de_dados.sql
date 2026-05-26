DROP DATABASE IF EXISTS rr_maxx;

CREATE DATABASE IF NOT EXISTS rr_maxx;
USE rr_maxx;


-- TABELA: usuarios
CREATE TABLE usuarios (
    id_usuarios BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    login VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    perfil ENUM('admin', 'mecanico') NOT NULL,
    ativo TINYINT(1) NOT NULL DEFAULT 1,
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- TABELA: clientes
CREATE TABLE clientes (
    id_clientes BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome_usuario VARCHAR(50) NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    dt_nascimento DATE,
    telefone VARCHAR(11),
    email_usuario VARCHAR(100),
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ativo TINYINT(1) NOT NULL DEFAULT 1
);


-- TABELA: enderecos
CREATE TABLE enderecos (
    id_endereco BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    cep VARCHAR(8),
    logradouro VARCHAR(120),
    numero VARCHAR(10),
    complemento VARCHAR(60),
    bairro VARCHAR(80),
    cidade VARCHAR(80),
    estado CHAR(2),
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_endereco_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes(id_clientes)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- TABELA: veiculos
-- TABELA: veiculos
CREATE TABLE veiculos (
    id_veiculos BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    placa VARCHAR(10) NOT NULL UNIQUE,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    ano INT,
    quilometragem INT,
    tipo_combustivel ENUM(
        'gasolina',
        'etanol',
        'flex',
        'diesel',
        'hibrido',
        'eletrico'
    ) NOT NULL,
    ativo TINYINT(1) NOT NULL DEFAULT 1,
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_veiculo_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes(id_clientes)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- TABELA: ordens_servico (ajustada)
CREATE TABLE ordens_servico (
    id_ordens_servico BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    veiculo_id BIGINT NOT NULL,
    usuario_id BIGINT,
    data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_fechamento DATETIME NULL,
    proxima_revisao DATE NULL,
    status ENUM(
        'aberta',
        'em_andamento',
        'aguardando_aprovacao',
        'aguardando_peca',
        'finalizada',
        'cancelada'
    ) NOT NULL DEFAULT 'aberta',
    quilometragem INT,
    valor_estimado DECIMAL(10,2) DEFAULT 0.00,
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    garantia ENUM('sem_garantia', '3_meses', '6_meses', '12_meses')
        NOT NULL DEFAULT 'sem_garantia',
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
    id_servicos_realizados BIGINT AUTO_INCREMENT PRIMARY KEY,
    ordem_servico_id BIGINT NOT NULL,
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




-- TABELA: notificacoes
CREATE TABLE notificacoes (
    id_notificacoes BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    veiculo_id BIGINT NULL,
    ordem_servico_id BIGINT NULL,
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
