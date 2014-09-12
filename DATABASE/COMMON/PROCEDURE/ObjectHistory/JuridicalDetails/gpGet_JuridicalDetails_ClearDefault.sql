-- Function: gpGet_ClearDefault ()

DROP FUNCTION IF EXISTS gpGet_JuridicalDetails_ClearDefault (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_JuridicalDetails_ClearDefault(
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (FullName TVarChar, OKPO TVarChar)
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY 
       SELECT
             '' :: TVarChar AS ClearFullName
           , ''::TVarChar AS ClearOKPO;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_JuridicalDetails_ClearDefault (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.14                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_JuridicalDetails (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP)
