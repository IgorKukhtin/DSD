-- Function: gpSelect_Object_Unit()

-- DROP FUNCTION IF EXISTS gpSelect_Object_UnitForReprice (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_UnitForReprice (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_UnitForReprice (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitForReprice(
    IN inJuridicalId      Integer,       -- наше юр.лицо
    IN inProvinceCityId   Integer,       -- район
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitName TVarChar) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

    RETURN QUERY 
     
        SELECT Object_Unit.Id          AS Id  
             , (COALESCE (Object_Juridical.ValueData, '') ||'  **  '|| 
                COALESCE (Object_Unit.ValueData, '') ||'  **  '|| 
                COALESCE (Object_ProvinceCity.ValueData, '')) :: TVarChar AS Name
        FROM Object AS Object_Unit

             LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                     ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                                    AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_RepriceAuto 
                                     ON ObjectBoolean_RepriceAuto.ObjectId = Object_Unit.Id
                                    AND ObjectBoolean_RepriceAuto.DescId = zc_ObjectBoolean_Unit_RepriceAuto()

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                  ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
             LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId

        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND COALESCE (ObjectBoolean_isLeaf.ValueData,False) = TRUE
          AND COALESCE (ObjectBoolean_RepriceAuto.ValueData,False) = TRUE
          AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
          AND (ObjectLink_Unit_ProvinceCity.ChildObjectId = inProvinceCityId OR inProvinceCityId = 0)

        ORDER BY Object_Juridical.ValueData , Object_Unit.ValueData , Object_ProvinceCity.ValueData
       ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.03.18         *
 25.06.15                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_UnitForReprice (0, 0,'2');
