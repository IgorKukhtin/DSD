-- Function: gpSelect_Object_OverSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_OverSettings(TVarChar);
                        
CREATE OR REPLACE FUNCTION gpSelect_Object_OverSettings(
    IN inSession     TVarChar       -- сессия пользователя
) 
RETURNS TABLE (Id Integer, LineNum Integer
             , UnitId Integer, UnitName TVarChar
             , MinPrice TFloat, MinPriceEnd TFloat
             , MinimumLot TFloat
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_OverSettings());
   vbUserId:= inSession;
   --vbObjectId := lpGet_DefaultValue('zc_Object_Unit', vbUserId);

   RETURN QUERY 
    /*    SELECT 
             Object_OverSettings.Id
           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , ObjectFloat_MinPrice.ValueData ::TFloat
           , ObjectFloat_MinimumLot.ValueData ::TFloat
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

       WHERE Object_OverSettings.DescId = zc_Object_OverSettings()
*/



    WITH tmpData AS (SELECT Object_OverSettings.Id
                          , COALESCE (ObjectLink_OverSettings_Unit.ChildObjectId, 0) AS UnitId
                          , ObjectFloat_MinPrice.ValueData                           AS MinPrice
                          , ROW_NUMBER() OVER (PARTITION BY COALESCE (ObjectLink_OverSettings_Unit.ChildObjectId, 0), Object_OverSettings.isErased ORDER BY COALESCE (ObjectFloat_MinPrice.ValueData, 0), Object_OverSettings.Id DESC) :: Integer AS LineNum
                          , Object_OverSettings.isErased
                     FROM Object AS Object_OverSettings
                           LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice 
                                  ON ObjectFloat_MinPrice.ObjectId = Object_OverSettings.Id
                                 AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_OverSettings_MinPrice()
                           LEFT JOIN ObjectLink AS ObjectLink_OverSettings_Unit 
                                 ON ObjectLink_OverSettings_Unit.ObjectId = Object_OverSettings.Id 
                                AND ObjectLink_OverSettings_Unit.DescId = zc_ObjectLink_OverSettings_Unit()
                     WHERE Object_OverSettings.DescId = zc_Object_OverSettings()
                     )
            
      SELECT tmpData.Id
         --  , row_number() OVER (ORDER BY Object_Unit.Id, tmpData.MinPrice) :: Integer as LineNum
           , tmpData.LineNum       :: Integer AS LineNum
           , tmpData.UnitId        :: Integer AS UnitId
           , Object_Unit.ValueData            AS UnitName 
           , tmpData.MinPrice                 AS MinPrice
           , tmpData.MinPriceEnd :: TFloat    AS MinPriceEnd
           , CASE WHEN ObjectFloat_MinimumLot.ValueData > 0 THEN ObjectFloat_MinimumLot.ValueData ELSE 1 END :: TFloat AS MinimumLot  
           , tmpData.isErased
      FROM (SELECT tmpData.Id
                 , tmpData.UnitId
                 , tmpData.MinPrice
                 , tmpData.isErased
                 , tmpData.LineNum
                 , COALESCE (tmpData_next.MinPrice, 999999) AS MinPriceEnd
            FROM tmpData
                 LEFT JOIN tmpData AS tmpData_next ON tmpData_next.UnitId = tmpData.UnitId AND tmpData_next.isErased = tmpData.isErased AND tmpData_next.LineNum = tmpData.LineNum + 1
           ) AS tmpData
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
          LEFT JOIN ObjectFloat AS ObjectFloat_MinimumLot 
                                ON ObjectFloat_MinimumLot.ObjectId =  tmpData.Id
                               AND ObjectFloat_MinimumLot.DescId = zc_ObjectFloat_OverSettings_MinimumLot()
      ;
  
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
-- SELECT * FROM gpSelect_Object_OverSettings ('2')
