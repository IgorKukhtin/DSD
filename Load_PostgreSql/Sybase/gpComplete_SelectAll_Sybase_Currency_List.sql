-- Function: gpComplete_SelectAll_Sybase_Currency_List()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase_Currency_List();

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase_Currency_List()                              

RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, InternalName TVarChar)
AS
$BODY$
BEGIN

     -- Результат
     RETURN QUERY 

     -- Результат
     SELECT Object_Currency_View.Id
          , Object_Currency_View.Code
          , Object_Currency_View.Name
          , Object_Currency_View.InternalName
     FROM Object_Currency_View
     WHERE Object_Currency_View.isErased = FALSE
       AND Object_Currency_View.Id IN (76965  -- USD
                                     , 559615 -- EUR
                                   --, 344548 -- PLN
                                   --, 309707 -- RUB
                                      )
    ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 20.01.20                                        *
*/

-- тест
-- SELECT * FROM gpComplete_SelectAll_Sybase_Currency_List ()
