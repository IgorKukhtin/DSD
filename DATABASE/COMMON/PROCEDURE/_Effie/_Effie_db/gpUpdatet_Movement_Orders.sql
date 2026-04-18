-- Function: gpUpdatet_Movement_Orders

DROP FUNCTION IF EXISTS gpUpdatet_Movement_Orders();

CREATE OR REPLACE FUNCTION gpUpdatet_Movement_Orders()
RETURNS TABLE (res Boolean)
AS
$BODY$
BEGIN

     -- Результат
     UPDATE Orders SET -- Дата и время создания документа на мобильном устройстве
                       createDate_ch = (LEFT (createDate, 10) || ' ' || SUBSTRING (createDate FROM 12)) :: TDateTime
                       -- Дата и время (в UTC) записи документа в БД Effie
                     , dbCreateDate_ch = (((LEFT (dbCreateDate, 10) || ' ' || SUBSTRING (dbCreateDate FROM 12)):: TIMESTAMP AT TIME ZONE 'UTC') AT TIME ZONE 'Europe/Kiev') :: TDateTime
     WHERE createDate_ch IS NULL
    ;
    
     -- Результат
     UPDATE order_returns SET -- Дата и время создания документа на мобильном устройстве
                              createDate_ch = (LEFT (createDate, 10) || ' ' || SUBSTRING (createDate FROM 12)) :: TDateTime
                              -- Дата и время (в UTC) записи документа в БД Effie
                            , dbCreateDate_ch = (((LEFT (dbCreateDate, 10) || ' ' || SUBSTRING (dbCreateDate FROM 12)):: TIMESTAMP AT TIME ZONE 'UTC') AT TIME ZONE 'Europe/Kiev') :: TDateTime
     WHERE createDate_ch IS NULL
    ;

     RETURN QUERY
     SELECT TRUE :: Boolean;

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
-- SELECT * FROM gpUpdatet_Movement_Orders();
