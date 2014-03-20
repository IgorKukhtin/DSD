-- Function: gpSelect_Object_ToolsWeighing_PriceList()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_PriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_PriceList(
    IN inRootId      Integer   ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Name TVarChar, Value Integer) AS
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

    vbTmpCount   := (SELECT gpGetToolsPropertyValue FROM gpGetToolsPropertyValue ('Scale_'||inRootId, 'PriceList', 'PriceListCount', '', '1', inSession));

    RETURN QUERY
       SELECT
             CAST('PriceList_'||tmpCount.Id AS TVarChar) AS Name
           , CAST(PriceListValue.Value AS Integer)       AS Value
           , Object_PaidKind.Id                     AS PriceListId
           , Object_PaidKind.ValueData              AS PriceListName


       FROM (SELECT generate_series(1, vbTmpCount) AS Id) AS tmpCount
       LEFT JOIN gpGetToolsPropertyValue ('Scale_'||inRootId, 'PriceList', 'PriceList_'||tmpCount.Id, '', '0',  inSession)  AS PriceListValue ON 1 = 1
       LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = COALESCE (CAST(PriceListValue.Value AS Integer),0)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing_PriceList (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.03.14                                                         *
*/

-- тест

-- SELECT * FROM gpSelect_Object_ToolsWeighing_PriceList (88952, zfCalc_UserAdmin()) --Scale_1
-- SELECT * FROM gpSelect_Object_ToolsWeighing_PriceList (89036, zfCalc_UserAdmin()) --Scale_77
-- SELECT * FROM gpSelect_Object_ToolsWeighing_PriceList (77, zfCalc_UserAdmin()) --Scale_77