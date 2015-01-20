-- Function: gpSelect_Object_ToolsWeighing_WeightTare()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_WeightTare (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_WeightTare(
    IN inRootId      Integer   ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Num Integer, Id Integer, Name TVarChar) AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbAccessKeyAll   Boolean;
   DECLARE vbTmpCount       Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ToolsWeighing());
--   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
--   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

    vbTmpCount   := (SELECT gpGetToolsPropertyValue FROM gpGetToolsPropertyValue ('Scale_'||inRootId, 'WeightTare', 'WeightTareCount', '', '1', inSession));

    RETURN QUERY
       SELECT
             tmpCount.Id
           , tmpCount.Id
           , WeightTareValue.Value


       FROM (SELECT generate_series(1, vbTmpCount) AS Id) AS tmpCount
       LEFT JOIN gpGetToolsPropertyValue ('Scale_'||inRootId, 'WeightTare', 'WeightTare_'||tmpCount.Id, '', '0',  inSession)  AS WeightTareValue ON 1 = 1
       ORDER BY 1
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing_WeightTare (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.03.14                                                         *
*/

-- тест

-- SELECT * FROM gpSelect_Object_ToolsWeighing_WeightTare (88952, zfCalc_UserAdmin()) --Scale_1
-- SELECT * FROM gpSelect_Object_ToolsWeighing_WeightTare (89036, zfCalc_UserAdmin()) --Scale_77
-- SELECT * FROM gpSelect_Object_ToolsWeighing_WeightTare (77, zfCalc_UserAdmin()) --Scale_77