/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
  id integer GENERATED ALWAYS AS IDENTITY,
  name varchar(50),
  date_of_birth date,
  escape_attempts integer,
  neutered boolean,
  weight_kg decimal(6, 2),
  PRIMARY KEY(id)
);
ALTER TABLE animals
ADD COLUMN species VARCHAR(50);
