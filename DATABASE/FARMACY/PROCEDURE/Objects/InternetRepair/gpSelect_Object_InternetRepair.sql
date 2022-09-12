-- Function: gpSelect_Object_InternetRepair(Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InternetRepair (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InternetRepair(
    IN inIsShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    -- Результат
    RETURN QUERY 
       SELECT
              Object_InternetRepair.Id                       AS GoodsID 
            , Object_InternetRepair.ObjectCode               AS InternetRepairID
            , Object_InternetRepair.ValueData                AS InternetRepairName
            , Object_InternetRepair.isErased                 AS isErased
       FROM Object AS Object_InternetRepair

           INNER JOIN ObjectLink AS ObjectLink_InternetRepair
                                 ON ObjectLink_InternetRepair.ChildObjectId = vbUnitId
                                AND ObjectLink_InternetRepair.ObjectId = Object_InternetRepair.Id
                                AND ObjectLink_InternetRepair.DescId = zc_Object_InternetRepair()

       WHERE Object_InternetRepair.DescId = zc_Object_InternetRepair()
         AND (Object_InternetRepair.isErased = False OR inIsShowAll = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  ALTER FUNCTION gpSelect_Object_InternetRepair (Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.09.22                                                       *              
*/

-- тест
-- SELECT * FROM gpSelect_Object_InternetRepair (zfCalc_UserAdmin()) ORDER BY Code