# KCM19 Kettle - Neo4J Demo
This repository contains the Kettle code to load, remodel and continue loading advanced movie data to Neo4J as demoed at the [KCM19 Neo4J Deep Dive Session](https://www.know-bi.be/kcm19-deep-dive-sessions#neo4j). 

# Required 
* have a [Neo4j](https://www.neo4j.com) database up and running. 
* download Kettle from [kettle.be](http://remix.kettle.be) or [Sourceforge](https://sourceforge.net/projects/pentaho/files/Pentaho%208.3/client-tools/pdi-ce-8.3.0.0-371.zip/download)
* If downloaded from Sourceforge (plugins included in Kettle Remix): 
    * download and unzip the latest Kettle Neo4j Output [plugins](https://github.com/knowbi/knowbi-pentaho-pdi-neo4j-output/releases) to your 'data-integration/plugins' folder. 
    * download and unzip the latest version of the [Environments plugin](https://github.com/mattcasters/kettle-environment) to your 'data-integration/plugins' folder. 
* unzip Kettle
* start Spoon
* create a project environment, set your metastore folder to this repository
* add these variables to kettle.properties:
    * MOVIES_HOST=<your Neo4j host>
    * MOVIES_BOLT=<your Neo4j Bolt port>
    * MOVIES_USER=<your Neo4j username>
    * MOVIES_PASS=<your Neo4j password>

# How to use
* master: the 'cypher' directory in contains the Cypher queries Tom used in his presentation
    * README.txt: various queries to showcase Neo4j and Cypher functionality
    * advanced_movies.cypher: cypher queries to load and remodel the advanced movies demo graph. This cypher script was recreated in Kettle to demo how Kettle can be used to 
* v1: the Kettle code to run the initial Advanced Movies graph
* remodel: the cypher code to remodel the Advanced Movies graph, orchestrated through Kettle
* v2: the updated Kettle code to load the remodeled Advanced Movies graph. 
