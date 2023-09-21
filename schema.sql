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

CREATE TABLE owners (
  id integer GENERATED ALWAYS AS IDENTITY,
  full_name varchar(100),
  age integer,
  PRIMARY KEY(id)
);

CREATE TABLE species (
  id integer GENERATED ALWAYS AS IDENTITY,
  name varchar(50),
  PRIMARY KEY(id)
);

ALTER TABLE animals
ADD COLUMN species_id integer,
ADD CONSTRAINT fk_species
    FOREIGN KEY (species_id)
    REFERENCES species(id);

ALTER TABLE animals
ADD COLUMN owner_id integer,
ADD CONSTRAINT fk_owner
    FOREIGN KEY (owner_id)
    REFERENCES owners(id);

ALTER TABLE animals DROP COLUMN species;