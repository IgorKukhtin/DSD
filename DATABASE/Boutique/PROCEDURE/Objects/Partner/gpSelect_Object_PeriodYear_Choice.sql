-- Поcтавщики
DROP FUNCTION IF EXISTS gpSelect_Object_PeriodYear_Choice(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PeriodYear_Choice(
       IN inSession          TVarChar )
RETURNS TABLE (Id Integer, PeriodYear Integer
              ) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     
     SELECT DISTINCT 0 AS Id 
          , ObjectFloat_PeriodYear.ValueData :: Integer AS PeriodYear
     FROM ObjectFloat AS ObjectFloat_PeriodYear 
     WHERE ObjectFloat_PeriodYear.DescId = zc_ObjectFloat_Partner_PeriodYear()
     ORDER BY 2 Desc;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
 10.02.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PeriodYear_Choice ('3')