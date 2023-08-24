-- Function: gpSelect_pg_stat_activity()

DROP FUNCTION IF EXISTS gpSelect_pg_stat_activity();

CREATE OR REPLACE FUNCTION gpSelect_pg_stat_activity() 

RETURNS TABLE (pId         Bigint
             , Waiting     Boolean
             , UseName     TVarChar
             , Query       TVarChar
             , datname     TVarChar
             , client_addr TVarChar
             , State       TVarChar
             , Query_start TDateTime
              )
AS
$BODY$
BEGIN

  RETURN QUERY
     SELECT pg_stat_activity.pId         :: Bigint
          , pg_stat_activity.Waiting     :: Boolean
          , pg_stat_activity.UseName     :: TVarChar
          , pg_stat_activity.Query       :: TVarChar
          , pg_stat_activity.datname     :: TVarChar
          , pg_stat_activity.client_addr :: TVarChar
          , pg_stat_activity.State       :: TVarChar
          , pg_stat_activity.Query_start :: TDateTime
     FROM  pg_stat_activity
     WHERE pg_stat_activity.state ILIKE 'active'
    ;

END;
$BODY$
  LANGUAGE plpgsql;

-- тест
-- SELECT * FROM gpSelect_pg_stat_activity()
