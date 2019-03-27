-- Function: gpSelect_Object_RetailForRepriceChange()

DROP FUNCTION IF EXISTS gpSelect_Object_RetailForRepriceChange (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RetailForRepriceChange(
    IN inJuridicalId      Integer,       -- наше юр.лицо
    IN inProvinceCityId   Integer,       -- район
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitName TVarChar)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

       RETURN QUERY 
         SELECT 
               Object_Retail.Id         AS Id
             , Object_Retail.ValueData  AS Name
         FROM Object AS Object_Retail
         WHERE Object_Retail.DescId   = zc_Object_Retail()
           AND Object_Retail.isErased = FALSE
         ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.08.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_RetailForRepriceChange (0, 0, zfCalc_UserAdmin())
