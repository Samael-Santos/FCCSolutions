#!/bin/bash


PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


echo $($PSQL "DELETE FROM elements WHERE atomic_number = 1000;")

echo $($PSQL "DELETE FROM properties WHERE atomic_number = 1000;")

echo $($PSQL "INSERT INTO elements(atomic_number, name, symbol)
VALUES
(9, 'Fluorine', 'F'),
(10, 'Neon', 'Ne')
;")

echo $($PSQL "INSERT INTO properties(atomic_number, type, weight, melting_point, boiling_point)
VALUES
(9, 'nonmetal', 18.998, -220, -188.1),
(10, 'nonmetal', 20.18, -248.6, -246.1)
;")
	
echo $($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;")

echo $($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;")

echo $($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;")

echo $($PSQL "ALTER TABLE properties 
ADD FOREIGN KEY (atomic_number) REFERENCES elements (atomic_number),
ALTER COLUMN
melting_point_celsius SET NOT NULL,
ALTER COLUMN
boiling_point_celsius SET NOT NULL,
ADD COLUMN
type_id INT,
ALTER COLUMN
atomic_mass TYPE real
;")
	
echo $($PSQL "ALTER TABLE elements 
ADD UNIQUE (name),
ALTER COLUMN name
SET NOT NULL,
ADD UNIQUE (symbol),
ALTER COLUMN symbol 
SET NOT NULL
;")
	
echo $($PSQL "CREATE TABLE types(type_id SERIAL PRIMARY KEY, type VARCHAR(255) NOT NULL);")

echo $($PSQL "INSERT INTO types(type) 
VALUES
('nonmetal'),
('metal'),
('metalloid')
;")

echo $($PSQL "UPDATE properties SET type_id = (SELECT DISTINCT type_id FROM types WHERE type = 'nonmetal') WHERE type = 'nonmetal';")

echo $($PSQL "UPDATE properties SET type_id = (SELECT DISTINCT type_id FROM types WHERE type = 'metal') WHERE type = 'metal';")

echo $($PSQL "UPDATE properties SET type_id = (SELECT DISTINCT type_id FROM types WHERE type = 'metalloid') WHERE type = 'metalloid';")

echo $($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL,
ADD FOREIGN KEY (type_id) REFERENCES types (type_id);")

echo $($PSQL "UPDATE elements SET symbol = initcap(symbol);")

echo $($PSQL "ALTER TABLE properties DROP COLUMN type;")
