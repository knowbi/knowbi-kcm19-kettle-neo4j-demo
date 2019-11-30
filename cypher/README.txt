# ####################
# Who is the fraudster
# ####################
MATCH p=(b:Bank {name: "KBC Bank NV"})-[*]-(c:Country {name: "Panama"}) RETURN p;

MATCH p=shortestPath((b:Bank {name: "KBC Bank NV"})-[*]-(c:Country {name: "Panama"})) RETURN p;

MATCH p=(b:Bank {name: "KBC Bank NV"})-[*]-(:Person {name: "Vladimir Putin"})-[*]-(c:Country {name: "Panama"}) RETURN p;

MATCH p=(b:Bank {name: "KBC Bank NV"})-[*]-(suspect:Person)-[*]-(c:Country {name: "Panama"}) RETURN DISTINCT suspect.name;

MATCH (p:Person {name: "Tom Geudens"})
SET p:Fraudster;




# #########
# Deep Dive
# #########
http://192.168.56.1:7474/browser/
type l:\scripts\advanced_movies.cypher | bin\cypher-shell.bat -a bolt://localhost:7687 -u neo4j -p trinity

# Load movies with scripts
CALL db.schema();

// Did Tom act with Tom ?
MATCH (p1:Person)-[a1:ACTED_IN]->(m:Movie)<-[a2:ACTED_IN]-(p2:Person)
WHERE p1.name = "Tom Hanks"
AND p2.name = "Tom Cruise"
RETURN p1.name, a1.roles, p2.name, a2.roles, m.title;

// Did Tom act with Kevin ?
MATCH (p1:Person)-[a1:ACTED_IN]->(m:Movie)<-[a2:ACTED_IN]-(p2:Person)
WHERE p1.name = "Tom Hanks"
AND p2.name = "Kevin Bacon"
RETURN p1.name, a1.roles, p2.name, a2.roles, m.title;

// Lets do 3D
MATCH (p1:Person)-[a1:ACTED_IN]-(m:Movie)-[a2:ACTED_IN]-(p2:Person),
(m)-[a3:ACTED_IN]-(p3:Person)
WHERE p1.name = "Tom Hanks"
AND p2.name = "Kevin Bacon"
AND p3.name = "Ed Harris"
RETURN p1.name, a1.roles, p2.name, a2.roles, p3.name, a3.roles, m.title;

// recommendations - 101
MATCH (tom:Person {name: "Tom Hanks"})-[:ACTED_IN]->(m1)<-[:ACTED_IN]-(coActors:Person)-[:ACTED_IN]->(m2)<-[:ACTED_IN]-(cocoActors:Person)
WHERE NOT (tom)-[:ACTED_IN]->()<-[:ACTED_IN]-(cocoActors)
AND tom <> cocoActors
RETURN cocoActors.name AS Recommended, count(*) AS Strength ORDER BY Strength DESC;

// recommendations - 102
MATCH (tom:Person {name: "Tom Hanks"})-[:ACTED_IN]->(m1:Movie)<-[:ACTED_IN]-(coActors:Person)-[:ACTED_IN]->(m2:Movie)<-[:ACTED_IN]-(cocoActors:Person)
WHERE NOT (tom)-[:ACTED_IN]->()<-[:ACTED_IN]-(cocoActors)
AND tom <> cocoActors
RETURN cocoActors.name AS Recommended, collect(DISTINCT coActors.name), count(DISTINCT coActors.name) AS Strength ORDER BY Strength DESC;


// Cost of change - I
MATCH (m:Movie) RETURN m.genres LIMIT 5;

CREATE CONSTRAINT ON (g:Genre) ASSERT g.name IS UNIQUE;

MATCH (m:Movie)
WHERE EXISTS(m.genres)
UNWIND m.genres AS theGenre
MERGE (g:Genre {name: theGenre})
MERGE (m)-[:HAS_GENRE]->(g)
REMOVE m.genres;
//

// Cost of change - II
MATCH (m:Movie)-[hg:HAS_GENRE]->(g:Genre)
CALL apoc.create.addLabels( id(m), [ g.name ] ) YIELD node
RETURN count(*);

MATCH (g:Genre)
DETACH DELETE g;

DROP CONSTRAINT ON (g:Genre) ASSERT g.name IS UNIQUE;


// introducing neo4j streams
http://192.168.56.1:7475/browser/
type l:\scripts\advanced_movies.cypher | bin\cypher-shell.bat -a bolt://localhost:7688 -u neo4j -p trinity
CALL streams.publish("movietopic", "The Matrix")

cd /d L:\kafka_2.11-2.1.0
bin\windows\zookeeper-server-start.bat config\zookeeper.properties
bin\windows\kafka-server-start.bat config\server.properties
bin\windows\kafka-console-consumer.bat --bootstrap-server localhost:9092 --topic movietopic --from-beginning