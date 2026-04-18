-- Function: gpUpdatet_Movement_Orders_OperDate_get

DROP FUNCTION IF EXISTS gpUpdatet_Movement_Orders_OperDate_get (TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdatet_Movement_Orders_OperDate_get(
    IN inExtId           TVarChar,
    IN inMovementDescId  Integer,    --
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbScript TEXT;
   DECLARE vb1      TEXT;
BEGIN

     IF inMovementDescId = zc_Movement_OrderExternal()
     THEN 
         -- Результат
         vbScript:= 'UPDATE Orders SET OperDate_get = CURRENT_TIMESTAMP WHERE extId = ' || CHR (39) ||  inExtId || CHR (39);
    
         -- Результат
         vb1:= (SELECT *
                FROM dblink_exec ('host=192.168.251.33 dbname=effie_api port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                   -- Результат
                                , vbScript));
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.26                                        *
*/

-- тест
-- SELECT * FROM gpUpdatet_Movement_Orders_OperDate_get ('1', zc_Movement_OrderExternal(), '');
