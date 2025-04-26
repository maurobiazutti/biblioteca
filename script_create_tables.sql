-- Arquivo pronto para rodar: Modelo Biblioteca

-- DROP tables if exist to reset schema cleanly
DROP TABLE IF EXISTS loan_items;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS book_categories;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS book_authors;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS book_copies;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS libraries;
DROP TABLE IF EXISTS addresses;

-- Cria tabela de endereços
CREATE TABLE addresses (
  id SERIAL PRIMARY KEY,
  number VARCHAR(10) NOT NULL,
  street VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(30) NOT NULL,
  cep VARCHAR(10) NOT NULL,
  country VARCHAR(50) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Cria tabela de bibliotecas
CREATE TABLE libraries (
  id SERIAL PRIMARY KEY,
  address_id INTEGER NOT NULL REFERENCES addresses(id) ON DELETE RESTRICT,
  fantasy_name VARCHAR(100) NOT NULL,
  cnpj VARCHAR(20) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Cria tabela de livros
CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  isbn VARCHAR(20) UNIQUE NOT NULL,
  title VARCHAR(200) NOT NULL,
  publisher VARCHAR(100) NOT NULL,
  edition VARCHAR(20) NOT NULL,
  release_date DATE,
  language VARCHAR(30) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Cria tabela de cópias de livros
CREATE TABLE book_copies (
  id SERIAL PRIMARY KEY,
  book_id INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,  
  library_id INTEGER NOT NULL REFERENCES libraries(id) ON DELETE CASCADE,
  acquisition_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'loaned', 'maintenance', 'lost')),
  location VARCHAR(50),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Cria tabela de autores
CREATE TABLE authors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  birth_date DATE,
  nationality VARCHAR(50),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Relaciona livros e autores
CREATE TABLE book_authors (
  id SERIAL PRIMARY KEY,
  author_id INTEGER NOT NULL REFERENCES authors(id) ON DELETE CASCADE,
  book_id INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  UNIQUE (author_id, book_id)
);

-- Cria tabela de categorias
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  category VARCHAR(50) NOT NULL UNIQUE,
  description TEXT
);

-- Relaciona livros e categorias
CREATE TABLE book_categories (
  id SERIAL PRIMARY KEY,
  book_id INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
  UNIQUE (book_id, category_id)
);

-- Cria tabela de funcionários
CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  address_id INTEGER NOT NULL REFERENCES addresses(id) ON DELETE RESTRICT,
  library_id INTEGER NOT NULL REFERENCES libraries(id) ON DELETE RESTRICT,
  name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  date_of_birth DATE NOT NULL,
  cpf VARCHAR(14) UNIQUE NOT NULL,
  registration VARCHAR(20) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  date_of_admission DATE NOT NULL,
  position VARCHAR(50) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'on_leave')),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Cria tabela de clientes
CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  address_id INTEGER NOT NULL REFERENCES addresses(id) ON DELETE RESTRICT,
  name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  date_of_birth DATE NOT NULL,
  cpf VARCHAR(14) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'blocked', 'inactive')),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Cria tabela de empréstimos
CREATE TABLE loans (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL REFERENCES employees(id) ON DELETE RESTRICT,
  customer_id INTEGER NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
  loan_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  due_date TIMESTAMP NOT NULL,
  return_date TIMESTAMP,
  status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'returned', 'late', 'lost')),
  late_fine NUMERIC(10,2) DEFAULT 0.00,
  notes TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Cria tabela de itens de empréstimo
CREATE TABLE loan_items (
  id SERIAL PRIMARY KEY,
  book_copy_id INTEGER NOT NULL REFERENCES book_copies(id) ON DELETE RESTRICT,
  loan_id INTEGER NOT NULL REFERENCES loans(id) ON DELETE CASCADE,
  return_condition VARCHAR(50),
  UNIQUE (book_copy_id, loan_id)
);

