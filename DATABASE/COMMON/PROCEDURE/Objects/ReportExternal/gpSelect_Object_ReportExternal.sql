-- Function: gpSelect_Object_ReportExternal()

DROP FUNCTION IF EXISTS gpSelect_Object_ReportExternal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReportExternal(
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
        SELECT Object.Id
             , Object.ObjectCode AS Code
             , Object.ValueData  AS Name
             , Object.isErased
        FROM Object
        WHERE Object.DescId     = zc_Object_ReportExternal()
          AND Object.isErased   = FALSE
          AND Object.ValueData <> ''
          AND (Object.ValueData NOT ILIKE 'gpReport_GoodsMI_byMovement'
            OR vbUserId <> 5
              )
       UNION
        SELECT 0 :: Integer AS Id
             , 0 :: Integer AS Code
             , 'gpReport_JuridicalSold' :: TVarChar  AS Name
             , FALSE :: Boolean AS isErased
        WHERE vbUserId IN (539659, 5) -- Стасюк Ю.П.
          AND 1=0

        ORDER BY 3
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
  28.04.17                                                       *
*/

-- тест
-- update Object set ValueData = '' where Id = 1208446
-- SELECT * FROM gpSelect_Object_ReportExternal (inSession:= zfCalc_UserAdmin())
