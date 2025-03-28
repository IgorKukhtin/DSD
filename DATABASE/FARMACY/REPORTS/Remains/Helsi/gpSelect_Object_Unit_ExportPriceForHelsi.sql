-- Function: gpSelect_Object_Unit_ExportPriceForHelsi()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_ExportPriceForHelsi(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_ExportPriceForHelsi(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitCode Integer
             , UnitName TVarChar
             , JuridicalId Integer
             , JuridicalCode Integer
             , JuridicalName TVarChar
             , Address TVarChar
             , Phone TVarChar
             , Latitude TVarChar, Longitude TVarChar
             , MondayStart TDateTime, MondayEnd TDateTime
             , SaturdayStart TDateTime, SaturdayEnd TDateTime
             , SundayStart TDateTime, SundayEnd TDateTime
) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY
     SELECT
           Object_Unit_View.ID
         , Object_Unit_View.Code
         , Object_Unit_View.Name
         , Object_Juridical.ID
         , Object_Juridical.ObjectCode
         , Object_Juridical.ValueData
         , ObjectString_Unit_Address.ValueData
         , ObjectString_Unit_Phone.ValueData

         , ObjectString_Latitude.ValueData        AS Latitude
         , ObjectString_Longitude.ValueData       AS Longitude
         , CASE WHEN COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_MondayStart.ValueData ELSE Null END ::TDateTime AS MondayStart
         , CASE WHEN COALESCE(ObjectDate_MondayEnd.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_MondayEnd.ValueData ELSE Null END ::TDateTime AS MondayEnd
         , CASE WHEN COALESCE(ObjectDate_SaturdayStart.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_SaturdayStart.ValueData ELSE Null END ::TDateTime AS SaturdayStart
         , CASE WHEN COALESCE(ObjectDate_SaturdayEnd.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_SaturdayEnd.ValueData ELSE Null END ::TDateTime AS SaturdayEnd
         , CASE WHEN COALESCE(ObjectDate_SundayStart.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_SundayStart.ValueData ELSE Null END ::TDateTime AS SundayStart
         , CASE WHEN COALESCE(ObjectDate_SundayEnd.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_SundayEnd.ValueData ELSE Null END ::TDateTime AS SundayEnd
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

          LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                                 ON ObjectString_Unit_Phone.ObjectId = Object_Unit_View.Id
                                AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()

          LEFT JOIN ObjectString AS ObjectString_Latitude
                                 ON ObjectString_Latitude.ObjectId = Object_Unit_View.Id
                                AND ObjectString_Latitude.DescId = zc_ObjectString_Unit_Latitude()
          LEFT JOIN ObjectString AS ObjectString_Longitude
                                 ON ObjectString_Longitude.ObjectId = Object_Unit_View.Id
                                AND ObjectString_Longitude.DescId = zc_ObjectString_Unit_Longitude()

          LEFT JOIN ObjectDate AS ObjectDate_MondayStart
                               ON ObjectDate_MondayStart.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_MondayStart.DescId = zc_ObjectDate_Unit_MondayStart()
          LEFT JOIN ObjectDate AS ObjectDate_MondayEnd
                               ON ObjectDate_MondayEnd.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_MondayEnd.DescId = zc_ObjectDate_Unit_MondayEnd()
          LEFT JOIN ObjectDate AS ObjectDate_SaturdayStart
                               ON ObjectDate_SaturdayStart.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_SaturdayStart.DescId = zc_ObjectDate_Unit_SaturdayStart()
          LEFT JOIN ObjectDate AS ObjectDate_SaturdayEnd
                               ON ObjectDate_SaturdayEnd.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_SaturdayEnd.DescId = zc_ObjectDate_Unit_SaturdayEnd()
          LEFT JOIN ObjectDate AS ObjectDate_SundayStart
                               ON ObjectDate_SundayStart.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_SundayStart.DescId = zc_ObjectDate_Unit_SundayStart()
          LEFT JOIN ObjectDate AS ObjectDate_SundayEnd
                               ON ObjectDate_SundayEnd.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_SundayEnd.DescId = zc_ObjectDate_Unit_SundayEnd()

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
 23.10.19                                                                     *

*/

-- тест
-- SELECT * FROM Object WHERE DescId = zc_Object_Unit();
--
SELECT * FROM gpSelect_Object_Unit_ExportPriceForHelsi ('3')
