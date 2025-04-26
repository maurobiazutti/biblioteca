-- Script Indexacao e Triggers.
-- Índices para melhorar performance
CREATE INDEX idx_book_title ON book(title);
CREATE INDEX idx_author_name ON author(name, last_name);
CREATE INDEX idx_loan_status ON loan(status);
CREATE INDEX idx_book_copy_status ON book_copy(status);
CREATE INDEX idx_customer_name ON customer(name, last_name);

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = now(); 
   RETURN NEW;
END;
$$ language 'plpgsql';

-- Exemplo de aplicação do trigger (repita para outras tabelas)
CREATE TRIGGER update_customer_modtime
BEFORE UPDATE ON customer
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();
