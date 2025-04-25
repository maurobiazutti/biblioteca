# 📚 Biblioteca - Visão Geral do Sistema

O sistema gerencia toda a operação de uma biblioteca, desde o cadastro de livros até o controle de empréstimos, com robustez e flexibilidade para crescer conforme necessário.

---

## 🧩 Funcionamento das Principais Entidades

### 1. Gerenciamento de Livros e Exemplares

- Na tabela `book` você cadastra informações bibliográficas (título, ISBN, editora)
- Na tabela `book_copy` você registra **cada exemplar físico** daquele livro
- Um livro (título) pode ter múltiplos exemplares físicos, potencialmente em bibliotecas diferentes
- Cada exemplar tem seu próprio **status** (`disponível`, `emprestado`, `em manutenção`)

---

### 2. Controle de Bibliotecas

- A tabela `library` permite cadastrar **múltiplas unidades** de biblioteca
- Cada biblioteca tem seu **endereço, informações de contato e CNPJ**
- Os exemplares (`book_copy`) estão vinculados a uma biblioteca específica

---

### 3. Gestão de Autores e Categorias

- A tabela `author` armazena informações sobre os autores
- Um livro pode ter múltiplos autores (relacionamento N:N via `book_author`)
- As categorias são gerenciadas de forma semelhante (relacionamento N:N via `book_category`)

---

### 4. Cadastro de Usuários

- `customer` armazena informações dos **leitores/clientes** da biblioteca
- `employee` armazena dados dos **funcionários** com seus cargos e biblioteca de atuação
- Ambos possuem controle de **status** (`ativo`, `bloqueado`, etc.)

---

### 5. Sistema de Empréstimos

- O empréstimo começa na tabela `loan` com informações gerais
- Cada item emprestado é registrado na tabela `loan_item`
- O sistema rastreia quem **autorizou o empréstimo** (`employee_id`)
- Permite registrar **data de devolução prevista, efetiva** e **multas**

---

## 🔄 Fluxo de Operações

### 📖 Empréstimo de um Livro

1. Verifica-se se o cliente está ativo (`customer.status = 'active'`)
2. Busca-se exemplares disponíveis (`book_copy.status = 'available'`)
3. Cria-se um registro na tabela `loan` com `customer_id` e `employee_id`
4. Registra-se cada exemplar emprestado na tabela `loan_item`
5. Atualiza-se o status do exemplar para **"emprestado"** (`book_copy.status = 'loaned'`)

---

### 📦 Devolução

1. Localiza-se o empréstimo (`loan`) através do ID ou dados do cliente
2. Registra-se a data de devolução (`return_date`)
3. Calcula-se multa se houver atraso (comparando `due_date` com `return_date`)
4. Atualiza-se o status do exemplar para **"disponível"**
5. Atualiza-se o status do empréstimo para **"devolvido"**

---

### ✍️ Cadastro de Novos Livros

1. Verifica-se se o título já existe na tabela `book`
2. Se não existir, cadastra-se o novo título
3. Registram-se os autores ou cria-se novos na tabela `author`
4. Vincula-se autores ao livro via `book_author`
5. Cadastra-se os exemplares físicos em `book_copy`

---

## ✅ Vantagens desta Estrutura

- **Integridade de dados:** Restrições de chave estrangeira e `UNIQUE` garantem dados consistentes
- **Flexibilidade:** Suporta múltiplas bibliotecas e múltiplos exemplares do mesmo livro
- **Rastreabilidade:** Histórico de criação e atualização com `created_at` e `updated_at`
- **Eficiência em consultas:** Índices otimizam buscas frequentes
- **Validação de dados:** `CHECK`, `NOT NULL` e outras constraints limitam valores a opções válidas

---

# Modelagem do Banco
![Diagrama UML do Banco de Dados](uml_biblioteca_pg.png)