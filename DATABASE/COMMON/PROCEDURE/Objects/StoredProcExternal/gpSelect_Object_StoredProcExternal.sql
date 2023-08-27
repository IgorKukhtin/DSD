-- Function: gpSelect_Object_StoredProcExternal()

DROP FUNCTION IF EXISTS gpSelect_Object_StoredProcExternal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StoredProcExternal(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer
             , Name     TVarChar
             , isErased Boolean
              ) 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);

      RETURN QUERY
        WITH spList AS (SELECT DISTINCT
                               tmp.ProName
                               -- № п/п
                             , ROW_NUMBER() OVER (ORDER BY tmp.ProName ASC) AS Ord
                        FROM (SELECT DISTINCT
                                     p.ProName :: TVarChar AS ProName
                                   --, p.oid :: BigInt AS oid
                              FROM pg_proc AS p
                                  JOIN pg_namespace AS n
                                                    ON n.oid     = p.pronamespace
                                                   AND n.nspname ILIKE 'public'
                              WHERE p.ProName ilike '%gpReport%'
                                 OR p.ProName ilike '%gpSelect%'
                             ) AS tmp
                       )
           , spExternal AS (SELECT LOWER (gpSelect.Name) AS Name FROM gpSelect_Object_ReportExternal (inSession:= zfCalc_UserAdmin()) AS gpSelect)
        --
        SELECT Object.Id
             , Object.ObjectCode                    AS Code
             , LOWER (Object.ValueData) :: TVarChar AS Name
             , Object.isErased
        FROM Object
             LEFT JOIN spExternal ON spExternal.Name ILIKE Object.ValueData
        WHERE Object.DescId     = zc_Object_StoredProcExternal()
          AND Object.isErased   = FALSE
          AND Object.ValueData <> ''

       UNION
        SELECT 0
             , spList.Ord               :: Integer  AS Code
             , LOWER (spList.ProName)   :: TVarChar AS Name
             , FALSE                    :: Boolean  AS isErased
        FROM spList
             LEFT JOIN spExternal ON spExternal.Name ILIKE spList.ProName
        WHERE spExternal.Name IS NULL
        ORDER BY 3
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
  18.08.23                                                      *
*/

-- тест
-- update Object set ValueData = '' where Id = 0
-- SELECT * FROM gpSelect_Object_StoredProcExternal (inSession:= zfCalc_UserAdmin())
