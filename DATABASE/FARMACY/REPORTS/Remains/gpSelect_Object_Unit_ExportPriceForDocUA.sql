-- Function: gpSelect_Object_Unit_ExportPriceForDocUA()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_ExportPriceForDocUA(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_ExportPriceForDocUA(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Head TVarChar
             , Name TVarChar
             , Addr TVarChar
             , Agent TVarChar
             , City TVarChar
             , Branch_location_lat TVarChar
             , Branch_location_lng TVarChar
             , Phones TVarChar
             , Schedule TVarChar
             , Reservation_time Integer) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY
     SELECT
           Object_Unit_View.ID
         , Object_Juridical.ValueData                           AS Head
         , Object_Unit_View.Name                                AS Name
         , ObjectString_Unit_Address.ValueData                  AS Addr
         , Object_Retail.ValueData                              AS Agent
         , Object_Area.ValueData                                AS City
         , ObjectString_Latitude.ValueData                      AS Branch_location_lat
         , ObjectString_Longitude.ValueData                     AS Bbranch_location_lng
         , ObjectString_Unit_Phone.ValueData                    AS Phone

         , (CASE WHEN COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00'
                THEN 'Пн-Пт '||LEFT ((ObjectDate_MondayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_MondayEnd.ValueData::Time)::TVarChar,5)||'; '
                ELSE ''
           END||'' ||
           CASE WHEN COALESCE(ObjectDate_SaturdayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SaturdayEnd.ValueData ::Time,'00:00') <> '00:00'
                THEN 'Сб '||LEFT ((ObjectDate_SaturdayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SaturdayEnd.ValueData::Time)::TVarChar,5)||'; '
                ELSE ''
           END||''||
           CASE WHEN COALESCE(ObjectDate_SundayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SundayEnd.ValueData ::Time,'00:00') <> '00:00'
                THEN 'Вс '||LEFT ((ObjectDate_SundayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SundayEnd.ValueData::Time)::TVarChar,5)
                ELSE ''
           END)::TVarChar                                       AS Schedule
         , 48                                                   AS Reservation_Time
     FROM Object_Unit_View AS Object_Unit_View

          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit_View.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
          INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                               AND ObjectLink_Juridical_Retail.ChildObjectId = 4
          INNER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

          INNER JOIN ObjectString AS ObjectString_Unit_Address
                                  ON ObjectString_Unit_Address.ObjectId  = Object_Unit_View.Id
                                 AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

          LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                                 ON ObjectString_Unit_Phone.ObjectId = Object_Unit_View.Id
                                AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()

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

          LEFT JOIN ObjectString AS ObjectString_Latitude
                                 ON ObjectString_Latitude.ObjectId = Object_Unit_View.Id
                                AND ObjectString_Latitude.DescId = zc_ObjectString_Unit_Latitude()
          LEFT JOIN ObjectString AS ObjectString_Longitude
                                 ON ObjectString_Longitude.ObjectId = Object_Unit_View.Id
                                AND ObjectString_Longitude.DescId = zc_ObjectString_Unit_Longitude()
          LEFT JOIN ObjectString AS ObjectString_EMail
                                 ON ObjectString_EMail.ObjectId = Object_Unit_View.Id
                                AND ObjectString_EMail.DescId = zc_ObjectString_Member_EMail()

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                               ON ObjectLink_Unit_Area.ObjectId = Object_Unit_View.Id
                              AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

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
 25.03.20                                                                     *

*/

-- тест
-- SELECT * FROM Object WHERE DescId = zc_Object_Unit();
-- SELECT * FROM gpSelect_Object_Unit_ExportPriceForDocUA ('3')