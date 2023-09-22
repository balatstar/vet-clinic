/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name NOT IN ('Gabumon');
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

BEGIN;
UPDATE animals SET species = 'unspecified';
ROLLBACK;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL OR species = '';
COMMIT;

BEGIN;
DELETE FROM animals;
ROLLBACK;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT DEL2022UP;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO DEL2022UP;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, COUNT(*) AS escape_count FROM animals WHERE escape_attempts >= 1 GROUP BY neutered;
SELECT
    species,
    MIN(weight_kg) AS min_weight,
    MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;
SELECT
    species,
    AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

/*What animals belong to Melody Pond?*/
SELECT animals.name AS animal_name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

/*List of all animals that are pokemon (their type is Pokemon).*/
SELECT animals.name AS animal_name
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

/*List all owners and their animals, remember to include those that don't own any animal.*/
SELECT owners.full_name AS owner_name, animals.name AS animal_name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
ORDER BY owners.full_name, animals.name;

/*How many animals are there per species?*/
SELECT species.name AS species_name, COUNT(animals.id) AS animal_count
FROM animals
JOIN species ON animals.species_id = species.id
GROUP BY species.name;

/*List all Digimon owned by Jennifer Orwell.*/
SELECT animals.name AS animal_name
FROM animals
JOIN owners ON animals.owner_id = owners.id
JOIN species ON animals.species_id = species.id
WHERE owners.full_name = 'Jennifer Orwell'
  AND species.name = 'Digimon';

/*List all animals owned by Dean Winchester that haven't tried to escape.*/
SELECT animals.name AS animal_name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester'
  AND animals.escape_attempts = 0;

/*Who owns the most animals?*/
SELECT owners.full_name AS owner_name, COUNT(animals.id) AS animal_count
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.full_name
ORDER BY animal_count DESC
LIMIT 1;

/*Who was the last animal seen by William Tatcher?*/
SELECT animals.name AS last_animal_seen
FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.visit_date DESC
LIMIT 1;

/*How many different animals did Stephanie Mendez see?*/
SELECT COUNT(DISTINCT visits.animal_id) AS animals_seen_count
FROM visits
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez';

/*List all vets and their specialties, including vets with no specialties.*/
SELECT vets.name AS vet_name, species.name AS specialty
FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id
ORDER BY vet_name, specialty;

/*List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.*/
SELECT animals.name AS animal_name
FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Stephanie Mendez'
  AND visits.visit_date BETWEEN  '2020-04-01' AND  '2020-08-30';

/*What animal has the most visits to vets?*/
SELECT animals.name AS animal_name, COUNT(visits.visit_id) AS visit_count
FROM animals
LEFT JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.name
ORDER BY visit_count DESC
LIMIT 1;

/*Who was Maisy Smith's first visit?*/
SELECT animals.name AS animal_name, MIN(visits.visit_date) AS first_visit_date
FROM animals
INNER JOIN visits ON animals.id = visits.animal_id
INNER JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
GROUP BY animals.name
ORDER BY first_visit_date ASC
LIMIT 1;

/*Details for most recent visit: animal information, vet information, and date of visit.*/
SELECT
    animals.name AS animal_name,
    vets.name AS vet_name,
    visits.visit_date AS visit_date
FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
ORDER BY visits.visit_date DESC
LIMIT 1;

/*How many visits were with a vet that did not specialize in that animal's species?*/
SELECT COUNT(*) AS mismatched_specialization_visits
FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
LEFT JOIN specializations ON (vets.id = specializations.vet_id AND animals.species_id = specializations.species_id)
WHERE specializations.vet_id IS NULL;

/*What specialty should Maisy Smith consider getting? Look for the species she gets the most.*/
SELECT
    species.name AS specialty,
    COUNT(animals.id) AS animal_count
FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
LEFT JOIN species ON animals.species_id = species.id
WHERE vets.name = 'Maisy Smith'
GROUP BY specialty
ORDER BY specialty
LIMIT 1;



