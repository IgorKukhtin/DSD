-- Function: gpGet_Object_Client_NEW_SYBASE()

DROP FUNCTION IF EXISTS gpGet_Object_Client_NEW_SYBASE (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Client_NEW_SYBASE(
    IN inName   TVarChar
)
RETURNS TVarChar
AS
$BODY$
BEGIN

     RETURN (WITH tmp AS (select gpGet_Object_Client_NEW_SYBASE1 (inName) AS RetV
                         UNION
                          select gpGet_Object_Client_NEW_SYBASE2 (inName) AS RetV
                         UNION
                          select gpGet_Object_Client_NEW_SYBASE3 (inName) AS RetV
                         )
            SELECT RetV
            FROM tmp
            WHERE RetV <> ''
            -- LIMIT 1
            )
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.18                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_Client_NEW_SYBASE1 ('Иван Елениди')
