##__Code_to_run__##

# Details for connecting to the server:
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms='pdw',
                                                                server=Sys.getenv("PDW_SERVER"),
                                                                schema='cdmDatabaseSchema',
                                                                user=NULL,
                                                                password=NULL,
                                                                port='port')


# The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortDatabaseSchema <-'cohort_Database_Schema.dbo'
cdmDatabaseSchema <- 'cdm_Database_Schema.dbo'
vocaDatabaseSchema <- 'voca_Database_Schema.dbo'
oncologyDatabaseSchema <- 'oncology_Database_Schema.dbo'


# The name of the table where the study-specific cohorts will be instantiated:
cohortTable <-'cohort'
episodeTable <- 'episode_table_name'
episodeEventTable <- 'episode_event_table_name'

# Create table in your database
createEpisodeAndEventTable <- FALSE

# Target regimen concept ids(blank = all):
targetRegimenConceptIds <- c(35806596,35804761) #FOLFOX, FOLFIRI

targetCohortId <- 272

# The number of cores in use:
maxCores <- 4

## Episode table and episode Event generation:
episodeAndEpisodeEvent<-generateEpisodeTable(targetRegimenConceptIds,
                                             connectionDetails,
                                             cohortTable,
                                             cdmDatabaseSchema,
                                             cohortDatabaseSchema,
                                             targetCohortId,
                                             maxCores)

## Insert episode table to database:
insertEpisodeToDatabase(connectionDetails,
                        oncologyDatabaseSchema,
                        episodeTable,
                        episodeEventTable,
                        createEpisodeAndEventTable,
                        episodeAndEpisodeEvent)

## Create the cohort for treatmentCycleExtraction:
conceptIdSet <- c(443384,
                  4181344,
                  443381,
                  443390,
                  4180792,
                  4180791,
                  443382,
                  4180790,
                  443391,
                  435754,
                  443383,
                  4089661) #colorectal cancer (condition)

targetCohortId <- 272

createCohort(createCohortTable = FALSE,
             connectionDetails = connectionDetails,
             oracleTempSchema = NULL,
             cdmDatabaseSchema = cdmDatabaseSchema,
             cohortDatabaseSchema = cohortDatabaseSchema,
             vocabularyDatabaseSchema = vocaDatabaseSchema,
             cohortTable = cohortTable,
             conceptIdSet = conceptIdSet,
             includeConceptIdSetDescendant = TRUE,
             targetCohortId = targetCohortId)

## Rule Editor ##

targetRegimenIds <- c(35806596,35804761)
newJson <- ruleEditor(targetRegimenIds) #edit your rule
ruleSave(newJson,targetRegimenIds) #save your rule