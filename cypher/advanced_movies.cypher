CREATE CONSTRAINT ON (m:Movie) ASSERT m.id IS UNIQUE;
CREATE CONSTRAINT ON (p:Person) ASSERT p.id IS UNIQUE;
CREATE INDEX ON :Person(name);
CREATE INDEX ON :Movie(title);

USING PERIODIC COMMIT 40000
LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/advanced/movies/new_movies.csv" AS row
CREATE (:Movie {id: toInteger(row.movieId), released: toInteger(row.releaseYear), title: row.title, avgvote: toFloat(row.avgVote), genres: split(row.genres,':')});

USING PERIODIC COMMIT 40000
LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/advanced/movies/people.csv" AS row
CREATE (:Person {id: toInteger(row.personId), name: row.name, birthyear: toInteger(row.birthYear), deathyear: toInteger(row.deathYear)});

USING PERIODIC COMMIT 40000
LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/advanced/movies/directors.csv" AS row
MATCH (m:Movie {id: toInteger(row.movieId)})
MATCH (p:Person {id: toInteger(row.personId)})
MERGE (p)-[:DIRECTED]->(m)
SET p:Director;

USING PERIODIC COMMIT 40000
LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/advanced/movies/actors.csv" AS row
MATCH (m:Movie {id: toInteger(row.movieId)})
MATCH (p:Person {id: toInteger(row.personId)})
MERGE (p)-[a:ACTED_IN]->(m)
SET a.roles = split(row.characters, ":")
SET p:Actor;
