-- Function: gpSelect_Object_UnitLincDriver()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitLincDriver(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitLincDriver(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Ord Integer 
             , Id Integer, UnitId Integer, UnitCode Integer, UnitName TVarChar
             , AreaName TVarChar, JuridicalId Integer, JuridicalName TVarChar, ProvinceCityName TVarChar

             , DriverId Integer
             , DriverName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());

   RETURN QUERY
       SELECT
             ROW_NUMBER() OVER (ORDER BY Object_Unit.Id)::Integer as Ord
           , Object_Unit.Id                                   AS Id
           , Object_Unit.Id                                   AS UnitId
           , Object_Unit.ObjectCode                           AS UnitCode
           , Object_Unit.ValueData                            AS UnitName
           , Object_Area.ValueData                            AS AreaName
           , Object_Juridical.Id                              AS JuridicalID
           , Object_Juridical.ValueData                       AS JuridicalName
           , Object_ProvinceCity.ValueData                    AS ProvinceCityName

           , Object_Driver.Id                                 AS DriverId
           , Object_Driver.ValueData                          AS DriverName
           
           , Object_Unit.isErased                             AS isErased

       FROM ObjectLink AS ObjectLink_Unit

           LEFT JOIN Object AS Object_Unit
                             ON Object_Unit.Id = ObjectLink_Unit.ObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Unit.ObjectId
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()  
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                ON ObjectLink_Unit_Area.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                               AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
           LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                ON ObjectLink_Unit_ProvinceCity.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                               AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
           LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId

           LEFT JOIN Object AS Object_Driver
                             ON Object_Driver.Id = ObjectLink_Unit.ChildObjectId

       WHERE ObjectLink_Unit.DescId = zc_ObjectLink_Unit_Driver()
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_UnitLincDriver(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 07.08.19        *
*/

-- тест
-- 
-- SELECT * FROM gpSelect_Object_UnitLincDriver ('3')