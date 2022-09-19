-- Schema Design 'contacts_management' database name

-- Users and Contacts

-- Users has a one-to-many relationshiop with Contacts
-- - A user can have many contacts, but each contact should only belong to one user

-- Users: 
-- id: Primary Key
-- username varchar(20) Unique not null
-- password text(hashed by bcrypt) NOT NULL

-- Contacts:
-- id serial Primary Key
-- first_name varchar(20) NOT NULL
-- last_name varchar(20) NOT NULL
-- email: varchar(50)
-- telephone: char(10)
-- user_id: int foreign key that references users(id) NOT NULL



CREATE TABLE users (
  id serial PRIMARY KEY,
  username varchar(20) UNIQUE NOT NULL,
  password text NOT NULL
);

CREATE TABLE contacts (
  id serial PRIMARY KEY,
  first_name varchar(20) NOT NULL,
  last_name varchar(20) NOT NULL,
  email varchar(50),
  telephone char(10),
  user_id int REFERENCES users(id) ON DELETE CASCADE NOT NULL
);