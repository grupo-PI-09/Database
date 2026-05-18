USE rr_maxx;

ALTER TABLE notificacoes DROP FOREIGN KEY fk_notificacao_cliente;
ALTER TABLE notificacoes DROP FOREIGN KEY fk_notificacao_veiculo;
ALTER TABLE notificacoes DROP FOREIGN KEY fk_notificacao_os;
ALTER TABLE garantias DROP FOREIGN KEY fk_garantia_servico;
ALTER TABLE servicos_realizados DROP FOREIGN KEY fk_servico_os;
ALTER TABLE ordens_servico DROP FOREIGN KEY fk_os_cliente;
ALTER TABLE ordens_servico DROP FOREIGN KEY fk_os_veiculo;
ALTER TABLE ordens_servico DROP FOREIGN KEY fk_os_usuario;
ALTER TABLE veiculos DROP FOREIGN KEY fk_veiculo_cliente;

ALTER TABLE usuarios MODIFY id_usuarios BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE clientes MODIFY id_clientes BIGINT NOT NULL AUTO_INCREMENT;

ALTER TABLE veiculos
    MODIFY id_veiculos BIGINT NOT NULL AUTO_INCREMENT,
    MODIFY cliente_id BIGINT NOT NULL;

ALTER TABLE ordens_servico
    MODIFY id_ordens_servico BIGINT NOT NULL AUTO_INCREMENT,
    MODIFY cliente_id BIGINT NOT NULL,
    MODIFY veiculo_id BIGINT NOT NULL,
    MODIFY usuario_id BIGINT NULL;

ALTER TABLE servicos_realizados
    MODIFY id_servicos_realizados BIGINT NOT NULL AUTO_INCREMENT,
    MODIFY ordem_servico_id BIGINT NOT NULL;

ALTER TABLE garantias
    MODIFY id BIGINT NOT NULL AUTO_INCREMENT,
    MODIFY servico_id BIGINT NOT NULL;

ALTER TABLE notificacoes
    MODIFY id_notificacoes BIGINT NOT NULL AUTO_INCREMENT,
    MODIFY cliente_id BIGINT NOT NULL,
    MODIFY veiculo_id BIGINT NULL,
    MODIFY ordem_servico_id BIGINT NULL;

ALTER TABLE veiculos
    ADD CONSTRAINT fk_veiculo_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes(id_clientes)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE ordens_servico
    ADD CONSTRAINT fk_os_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes(id_clientes)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    ADD CONSTRAINT fk_os_veiculo
        FOREIGN KEY (veiculo_id) REFERENCES veiculos(id_veiculos)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    ADD CONSTRAINT fk_os_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuarios)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE servicos_realizados
    ADD CONSTRAINT fk_servico_os
        FOREIGN KEY (ordem_servico_id) REFERENCES ordens_servico(id_ordens_servico)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE garantias
    ADD CONSTRAINT fk_garantia_servico
        FOREIGN KEY (servico_id) REFERENCES servicos_realizados(id_servicos_realizados)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE notificacoes
    ADD CONSTRAINT fk_notificacao_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes(id_clientes)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT fk_notificacao_veiculo
        FOREIGN KEY (veiculo_id) REFERENCES veiculos(id_veiculos)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT fk_notificacao_os
        FOREIGN KEY (ordem_servico_id) REFERENCES ordens_servico(id_ordens_servico)
        ON DELETE SET NULL
        ON UPDATE CASCADE;
