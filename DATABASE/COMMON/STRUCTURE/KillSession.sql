/*
DO $$

BEGIN
   
   PERFORM pg_terminate_backend(pg_stat_activity.procpid)
   FROM pg_stat_activity
   WHERE pg_stat_activity.datname = 'project';

   EXCEPTION WHEN OTHERS THEN

      PERFORM pg_terminate_backend(pg_stat_activity.pid)
      FROM pg_stat_activity
      WHERE pg_stat_activity.datname = 'project';

END $$;
*/
