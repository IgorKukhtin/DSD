-- Function: gpGet_Object_Client_SYBASE()

DROP FUNCTION IF EXISTS gpGet_Object_Client_SYBASE (Integer, Integer);

CREATE OR REPLACE FUNCTION gpGet_Object_Client_SYBASE(
    IN inDatabaseId   Integer      , --
    IN inReplId       Integer        --
)
RETURNS TVarChar
AS
$BODY$
BEGIN

     RETURN (WITH tmp AS (select gpGet_Object_Client_SYBASE1 (inDatabaseId, inReplId) AS RetV
                         UNION
                          select gpGet_Object_Client_SYBASE2 (inDatabaseId, inReplId) AS RetV
                         UNION
                          select gpGet_Object_Client_SYBASE3 (inDatabaseId, inReplId) AS RetV
                         )
            SELECT RetV
            FROM tmp
            WHERE RetV <> ''
            LIMIT 1)
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 29.08.17                                        *
*/

-- тест
-- SELECT 1, * FROM gpGet_Object_Client_SYBASE (3, 1154) union SELECT 2, * FROM gpGet_Object_Client_SYBASE (2, 992) union SELECT 3, * FROM gpGet_Object_Client_SYBASE (4, 1191)
