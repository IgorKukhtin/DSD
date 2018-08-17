-- Function: gpSelect_Object_Accommodation_Unit(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Accommodation_Unit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Accommodation_Unit(
    IN inUnitId      Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
     -- Результат
     RETURN QUERY 
       SELECT
              Object_Accommodation.Id                       AS GoodsID 
            , Object_Accommodation.ObjectCode               AS AccommodationID
            , Object_Accommodation.ValueData                AS AccommodationName
       FROM Object AS Object_Accommodation

           INNER JOIN ObjectLink AS ObjectLink_Accommodation_Unit
                                 ON ObjectLink_Accommodation_Unit.ObjectId = inUnitId
                                AND ObjectLink_Accommodation_Unit.ChildObjectId = Object_Accommodation.Id
                                AND ObjectLink_Accommodation_Unit.DescId = zc_Object_Accommodation_Unit()

       WHERE Object_Accommodation.DescId = zc_Object_Accommodation();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Accommodation_Unit (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 17.08.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Accommodation_Unit (183292, zfCalc_UserAdmin()) ORDER BY Code