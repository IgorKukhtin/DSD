-- Function: gpSelect_Scale_Retail()

DROP FUNCTION IF EXISTS gpSelect_Scale_Retail (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Retail(
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (GuideId   Integer
             , GuideCode Integer
             , GuideName TVarChar
             , isErased        Boolean
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT Object_Retail.Id         AS GuideId
            , Object_Retail.ObjectCode AS GuideCode
            , Object_Retail.ValueData  AS GuideName
            , Object_Retail.isErased   AS isErased
       FROM Object AS Object_Retail
       WHERE Object_Retail.DescId = zc_Object_Retail()
       --AND Object_Retail.ObjectCode <> 0
         AND Object_Retail.isErased = FALSE
       ORDER BY 3
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.04.22                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_Retail (inSession:=zfCalc_UserAdmin())
