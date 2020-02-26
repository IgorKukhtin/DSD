-- Function: gpSelect_Scale_Unit()

DROP FUNCTION IF EXISTS gpSelect_Scale_Unit (Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Unit(
    IN inIsCeh            Boolean,
    IN inBranchCode       Integer,
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (UnitId     Integer
             , UnitCode   Integer
             , UnitName   TVarChar
             , isErased   Boolean
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       WITH tmpToolsWeighing AS (SELECT tmp.ValueData :: Integer AS UnitId
                                 FROM gpSelect_Object_ToolsWeighing (inSession:= inSession) AS tmp
                                 WHERE tmp.NameFull ILIKE CASE WHEN inIsCeh = TRUE THEN 'ScaleCeh_' || inBranchCode ELSE 'Scale_' || inBranchCode END || '%'
                                   AND tmp.NameFull ILIKE '%FromId%'
                                   AND zfConvert_StringToFloat (tmp.ValueData) > 0
                                )
       -- Результат
       SELECT DISTINCT
              Object_Unit.Id         AS UnitId
            , Object_Unit.ObjectCode AS UnitCode
            , Object_Unit.ValueData  AS UnitName
            , Object_Unit.isErased   AS isErased
       FROM tmpToolsWeighing
            JOIN Object AS Object_Unit ON Object_Unit.Id         = tmpToolsWeighing.UnitId
                                      AND Object_Unit.DescId     = zc_Object_Unit()
                                      AND Object_Unit.ObjectCode <> 0
       ORDER BY 3
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.02.20                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_Unit (inIsCeh:= FALSE, inBranchCode:= '201', inSession:=zfCalc_UserAdmin())
