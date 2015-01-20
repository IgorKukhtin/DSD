-- Function: gpSelect_Object_ToolsWeighing_GoodsKindWeighing()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_GoodsKindWeighing (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_GoodsKindWeighing(
    IN inRootId      Integer   ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Num Integer, Id Integer, Name TVarChar) AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbAccessKeyAll   Boolean;
   DECLARE vbTmpId          Integer;


BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ToolsWeighing());
--   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
--   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

    vbTmpId   := (SELECT gpGetToolsPropertyValue FROM gpGetToolsPropertyValue ('Scale_'||inRootId, 'Default', 'GoodsKindWeighingId', '', '0', inSession));


    RETURN QUERY
       SELECT
--             CAST(row_number() OVER (ORDER BY GoodsKindWeighing.ObjectCode) AS Integer)   AS Num
             Object_GoodsKind.ObjectCode                    AS Num
           , Object_GoodsKind.Id                            AS GoodsKindId
           , Object_GoodsKind.ValueData                     AS GoodsKindName

       FROM Object AS GoodsKindWeighing

       INNER JOIN ObjectLink AS OL_GoodsKindWeighing_GoodsKindWeighingGroup
                             ON OL_GoodsKindWeighing_GoodsKindWeighingGroup.ObjectId = GoodsKindWeighing.Id
                            AND OL_GoodsKindWeighing_GoodsKindWeighingGroup.DescId = zc_ObjectLink_GoodsKindWeighing_GoodsKindWeighingGroup()
                            AND OL_GoodsKindWeighing_GoodsKindWeighingGroup.ChildObjectId = vbTmpId

       LEFT JOIN ObjectLink AS OL_GoodsKindWeighing_GoodsKind
                            ON OL_GoodsKindWeighing_GoodsKind.ObjectId = GoodsKindWeighing.Id
                           AND OL_GoodsKindWeighing_GoodsKind.DescId = zc_ObjectLink_GoodsKindWeighing_GoodsKind()


       LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = OL_GoodsKindWeighing_GoodsKind.ChildObjectId
       WHERE GoodsKindWeighing.DescId = zc_Object_GoodsKindWeighing()

       ORDER BY Object_GoodsKind.ObjectCode
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing_GoodsKindWeighing (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.03.14                                                         *
*/

-- тест

-- SELECT * FROM gpSelect_Object_ToolsWeighing_GoodsKindWeighing (77 , zfCalc_UserAdmin()) --Scale_77