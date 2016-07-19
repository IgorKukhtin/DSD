-- Function: gpGet_Object_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_OverSettings(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_OverSettings(
    IN inId          Integer,       --Подразделение
    IN inSession     TVarChar       -- 
)
RETURNS TABLE (Id Integer, UnitId Integer, UnitName TVarChar
             , MinPrice TFloat, MinimumLot TFloat
             , isErased boolean
) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceGroupSettings());
   vbUserId:= inSession;

 IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 AS Integer)    AS Id
           , CAST (0 AS Integer)    AS UnitId
           , CAST ('' AS TVarChar)  AS UnitName
          
           , CAST (0 AS TFloat)     AS MinPrice
           , CAST (0 AS TFloat)     AS MinimumLot
           , False                  AS isErased
        ;
   ELSE
   RETURN QUERY 
       SELECT Object_OverSettings.Id
            , Object_Unit.Id                 AS UnitId
            , Object_Unit.ValueData          AS UnitName
            , ObjectFloat_MinPrice.ValueData
            , ObjectFloat_MinimumLot.ValueData
            , Object_OverSettings.isErased
       FROM Object AS Object_OverSettings
           LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice 
                                 ON ObjectFloat_MinPrice.ObjectId = Object_OverSettings.Id
                                AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_OverSettings_MinPrice()
           LEFT JOIN ObjectFloat AS ObjectFloat_MinimumLot 
                                 ON ObjectFloat_MinimumLot.ObjectId = Object_OverSettings.Id
                                AND ObjectFloat_MinimumLot.DescId = zc_ObjectFloat_OverSettings_MinimumLot()
           LEFT JOIN ObjectLink AS ObjectLink_OverSettings_Unit 
                                ON ObjectLink_OverSettings_Unit.ObjectId = Object_OverSettings.Id 
                               AND ObjectLink_OverSettings_Unit.DescId = zc_ObjectLink_OverSettings_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OverSettings_Unit.ChildObjectId 
            
       WHERE Object_OverSettings.Id = inId;
    END IF;

END;
$BODY$
  
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.07.16         *

*/

-- тест
--  SELECT * FROM gpGet_Object_OverSettings(0,'2')