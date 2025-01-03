-- Function: gpSelect_Object_Unit_ExportPriceForSite()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_ExportPriceForSite(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_ExportPriceForSite(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, RegNumber Integer, SerialNumber Integer, Name TVarChar) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

    RETURN QUERY
    SELECT
           Object_Unit.Id
         , Object_Unit.ObjectCode
         , COALESCE (ObjectFloat_SerialNumberMypharmacy.ValueData, 0)::Integer       AS RegNumber
         , COALESCE (ObjectFloat_SerialNumberTabletki.ValueData, 0)::Integer         AS SerialNumber
         , REPLACE(Object_Unit.ValueData, '/', '-')::TVarChar                        AS Name
    FROM Object AS Object_Unit
        
      LEFT JOIN ObjectFloat AS ObjectFloat_SerialNumberTabletki
                            ON ObjectFloat_SerialNumberTabletki.ObjectId = Object_Unit.Id
                           AND ObjectFloat_SerialNumberTabletki.DescId = zc_ObjectFloat_Unit_SerialNumberTabletki()
      LEFT JOIN ObjectFloat AS ObjectFloat_SerialNumberMypharmacy
                            ON ObjectFloat_SerialNumberMypharmacy.ObjectId = Object_Unit.Id
                           AND ObjectFloat_SerialNumberMypharmacy.DescId = zc_ObjectFloat_Unit_SerialNumberMypharmacy()

    WHERE Object_Unit.DescId = zc_Object_Unit()
      AND (COALESCE (ObjectFloat_SerialNumberTabletki.ValueData, 0) <> 0
       OR COALESCE (ObjectFloat_SerialNumberMypharmacy.ValueData, 0) <> 0) 
      AND Object_Unit.isErased = False
    ORDER BY Object_Unit.Id;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 18.02.19        *
 19.07.18        *
 07.06.18        *

*/

-- тест
-- SELECT * FROM Object WHERE DescId = zc_Object_Unit();
-- SELECT * FROM gpSelect_Object_Unit_ExportPriceForSite ('3')