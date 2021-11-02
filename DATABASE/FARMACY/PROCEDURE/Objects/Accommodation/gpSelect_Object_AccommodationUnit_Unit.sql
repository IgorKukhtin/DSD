-- Function: gpSelect_Object_AccommodationUnit_Unit(Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_AccommodationUnit_Unit (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AccommodationUnit_Unit(
    IN inUnitId      Integer,
    IN inIsShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY 
       SELECT
              Object_Accommodation.Id                       AS GoodsID 
            , Object_Accommodation.ObjectCode               AS AccommodationID
            , Object_Accommodation.ValueData                AS AccommodationName
            , Object_Accommodation.isErased                 AS isErased
       FROM Object AS Object_Accommodation

           INNER JOIN ObjectLink AS ObjectLink_Accommodation_Unit
                                 ON ObjectLink_Accommodation_Unit.ChildObjectId = inUnitId
                                AND ObjectLink_Accommodation_Unit.ObjectId = Object_Accommodation.Id
                                AND ObjectLink_Accommodation_Unit.DescId = zc_Object_Accommodation_Unit()

       WHERE Object_Accommodation.DescId = zc_Object_Accommodation()
         AND (Object_Accommodation.isErased = False OR inIsShowAll = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  ALTER FUNCTION gpSelect_Object_Accommodation_Unit (Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.11.21                                                       *
*/

-- тест
-- 
select * from gpSelect_Object_AccommodationUnit_Unit(inUnitId := 377605 , inIsShowAll := 'False' ,  inSession := '3');