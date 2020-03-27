-- Function: gpSelect_Object_Unit_ExportPriceFor103UA()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_ExportPriceFor103UA(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_ExportPriceFor103UA(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitCode Integer
             , UnitName TVarChar) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY
     SELECT
           Object_Unit_View.ID
         , Object_Unit_View.Code
         , Object_Unit_View.Name
     FROM Object_Unit_View AS Object_Unit_View

          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit_View.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
          INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                               AND ObjectLink_Juridical_Retail.ChildObjectId = 4

          INNER JOIN ObjectString AS ObjectString_Unit_Address
                                  ON ObjectString_Unit_Address.ObjectId  = Object_Unit_View.Id
                                 AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

     WHERE Object_Unit_View.isErased = False
       AND Object_Unit_View.Name NOT ILIKE '%закрыта%'
       AND COALESCE (ObjectString_Unit_Address.ValueData, '') <> ''
       AND Object_Unit_View.Id <> 11460971
     ORDER BY Object_Unit_View.Id;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В
 24.03.20                                                                     *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit_ExportPriceFor103UA ('3')