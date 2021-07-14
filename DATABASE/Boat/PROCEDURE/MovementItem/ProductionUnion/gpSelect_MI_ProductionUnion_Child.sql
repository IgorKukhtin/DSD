-- Function: gpSelect_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionUnion_Child (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionUnion_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, NPP Integer, ParentId Integer
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , DescName TVarChar
             , ReceiptLevelName TVarChar
             , Amount TFloat
             , isErased Boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , Value TFloat, Value_service TFloat
             , Amount_diff TFloat
             , Color_value Integer
             , Color_Level Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);
     
     DROP TABLE IF EXISTS _tmpReceiptProdModelChild;
     DROP TABLE IF EXISTS _tmpReceiptGoodsChild;

     --получим данные ReceiptProdModelChild
     PERFORM gpSelect_Object_ReceiptProdModelChild_Goods(0, FALSE, inSession);
     CREATE TEMP TABLE _tmpReceiptProdModelChild ON COMMIT DROP AS
          (SELECT tmp.ReceiptProdModelId
                , tmp.NPP
                , tmp.ObjectId
                , tmp.ObjectCode
                , tmp.ObjectName
                , tmp.DescName
                , tmp.ReceiptLevelName
                , tmp.GoodsGroupNameFull
                , tmp.GoodsGroupName
                , tmp.Article
                , tmp.ProdColorName
                , tmp.MeasureName
                , tmp.Value ::TFloat
                , tmp.Value_service AS Value_service
                , tmp.Color_value
                , tmp.Color_Level
          FROM tmpResult AS tmp
         UNION 
          SELECT tmp.ReceiptProdModelId
               , tmp.NPP
               , tmp.GoodsId     AS ObjectId
               , tmp.GoodsCode   AS ObjectCode
               , tmp.GoodsName   AS ObjectName
               , ObjectDesc.ItemName AS DescName
               , '' ::TVarChar AS ReceiptLevelName
               , tmp.GoodsGroupNameFull
               , tmp.GoodsGroupName
               , tmp.Article
               , tmp.ProdColorName
               , tmp.MeasureName
               , tmp.Value ::TFloat
               , 0  ::TFloat AS Value_service
               , 15138790      ::Integer       AS Color_value                          --  фон для Value
               , CASE WHEN ObjectDesc.Id = zc_Object_ReceiptService() THEN 15073510  -- малиновый
                      ELSE  zc_Color_Blue()
                 END           ::Integer       AS Color_Level
          FROM gpSelect_Object_ReceiptProdModelChild_ProdColorPattern (0, FALSE, inSession) AS tmp
               LEFT JOIN ObjectDesc ON ObjectDesc.Id = tmp.GoodsId
          WHERE COALESCE (tmp.GoodsId,0) <> 0
          );
     --
     CREATE TEMP TABLE _tmpReceiptGoodsChild ON COMMIT DROP AS
          (SELECT tmp.ReceiptGoodsId
                , tmp.NPP
                , tmp.ObjectId
                , tmp.ObjectCode
                , tmp.ObjectName
                , tmp.DescName
                , tmp.GoodsGroupNameFull
                , tmp.GoodsGroupName
                , tmp.Article
                , tmp.ProdColorName
                , tmp.MeasureName
                , tmp.Value ::TFloat
                , tmp.Value_service ::TFloat
                , tmp.Color_value
                , tmp.Color_Level
           FROM gpSelect_Object_ReceiptGoodsChild_ProdColorPatternNo (FALSE, FALSE, inSession) AS tmp
          UNION
           SELECT tmp.ReceiptGoodsId
                , tmp.NPP
                , tmp.GoodsId     AS ObjectId
                , tmp.GoodsCode   AS ObjectCode
                , tmp.GoodsName   AS ObjectName
                , ObjectDesc.ItemName AS DescName
                , tmp.GoodsGroupNameFull
                , tmp.GoodsGroupName
                , tmp.Article
                , tmp.ProdColorName
                , tmp.MeasureName
                , tmp.Value ::TFloat
                , 0  ::TFloat AS Value_service
                , 15138790      ::Integer                  AS Color_value                          --  фон для Value
                , CASE WHEN ObjectDesc.Id = zc_Object_ReceiptService() THEN 15073510  -- малиновый
                       ELSE  zc_Color_Blue()
                  END           ::Integer                  AS Color_Level
           FROM gpSelect_Object_ReceiptGoodsChild_ProdColorPattern(FALSE, FALSE, inSession) AS tmp
                LEFT JOIN ObjectDesc ON ObjectDesc.Id = tmp.GoodsId
           WHERE COALESCE (tmp.GoodsId,0) <> 0
          );


    IF inShowAll
    THEN
     RETURN QUERY
     WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )
   , tmpMI_Master AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId
                           , MILO_ReceiptProdModel.ObjectId AS ReceiptProdModelId
                      FROM tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemLinkObject AS MILO_ReceiptProdModel
                                                            ON MILO_ReceiptProdModel.MovementItemId = MovementItem.Id
                                                           AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()
                     )

   , tmpMI AS (SELECT MovementItem.ObjectId   AS ObjectId
                    , MovementItem.Amount
                    , MovementItem.Id
                    , MovementItem.ParentId
                    , MovementItem.isErased
               FROM tmpIsErased
                    JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Child()
                                     AND MovementItem.isErased   = tmpIsErased.isErased
              )

     SELECT
         0 AS Id
       , tmpReceiptProdModelChild.NPP :: Integer
       , tmpMI_Master.Id AS ParentId
       , tmpReceiptProdModelChild.ObjectId       AS ObjectId
       , tmpReceiptProdModelChild.ObjectCode     AS ObjectCode
       , tmpReceiptProdModelChild.ObjectName     AS ObjectName
       , tmpReceiptProdModelChild.DescName ::TVarChar
       , tmpReceiptProdModelChild.ReceiptLevelName :: TVarChar
       , 0 ::TFloat AS Amount
       , FALSE                                   AS isErased

       , tmpReceiptProdModelChild.GoodsGroupNameFull
       , tmpReceiptProdModelChild.GoodsGroupName
       , tmpReceiptProdModelChild.Article
       , tmpReceiptProdModelChild.ProdColorName
       , tmpReceiptProdModelChild.MeasureName
       , tmpReceiptProdModelChild.Value         ::TFloat
       , tmpReceiptProdModelChild.Value_service ::TFloat
       --разница от введенного
       , (0 - tmpReceiptProdModelChild.Value) :: TFloat AS Amount_diff
       , tmpReceiptProdModelChild.Color_value
       , tmpReceiptProdModelChild.Color_Level
     FROM _tmpReceiptProdModelChild AS tmpReceiptProdModelChild
          INNER JOIN tmpMI_Master ON tmpMI_Master.ReceiptProdModelId = tmpReceiptProdModelChild.ReceiptProdModelId
          LEFT JOIN tmpMI ON tmpMI.ParentId = tmpMI_Master.Id
                         AND tmpMI.ObjectId = tmpReceiptProdModelChild.ObjectId
     WHERE tmpMI.ObjectId IS NULL
  UNION ALL
     SELECT
         0 AS Id
       , tmpReceiptGoodsChild.NPP :: Integer
       , tmpMI_Master.Id AS ParentId
       , tmpReceiptGoodsChild.ObjectId       AS ObjectId
       , tmpReceiptGoodsChild.ObjectCode     AS ObjectCode
       , tmpReceiptGoodsChild.ObjectName     AS ObjectName
       , tmpReceiptGoodsChild.DescName
       , ''    ::TVarChar AS  ReceiptLevelName
       , 0 ::TFloat AS Amount
       , FALSE                               AS isErased

       , tmpReceiptGoodsChild.GoodsGroupNameFull
       , tmpReceiptGoodsChild.GoodsGroupName
       , tmpReceiptGoodsChild.Article
       , tmpReceiptGoodsChild.ProdColorName
       , tmpReceiptGoodsChild.MeasureName
       , tmpReceiptGoodsChild.Value ::TFloat
       , tmpReceiptGoodsChild.Value_service ::TFloat
       --разница от введенного
       , (0 - tmpReceiptGoodsChild.Value) :: TFloat AS Amount_diff
       , tmpReceiptGoodsChild.Color_value
       , tmpReceiptGoodsChild.Color_Level     
     FROM _tmpReceiptGoodsChild AS tmpReceiptGoodsChild
          INNER JOIN tmpMI_Master ON tmpMI_Master.ObjectId = tmpReceiptGoodsChild.ReceiptGoodsId
          LEFT JOIN tmpMI ON tmpMI.ParentId = tmpMI_Master.Id
                         AND tmpMI.ObjectId = tmpReceiptGoodsChild.ObjectId
     WHERE tmpMI.ObjectId IS NULL
  UNION ALL
     SELECT
         MovementItem.Id
       --, ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id ASC) :: Integer AS NPP
       , COALESCE (tmpReceiptProdModelChild.NPP, tmpReceiptGoodsChild.NPP)  :: Integer AS NPP
       , MovementItem.ParentId
       , MovementItem.ObjectId      AS ObjectId
       , Object_Object.ObjectCode   AS ObjectCode
       , Object_Object.ValueData    AS ObjectName
       , ObjectDesc.ItemName ::TVarChar AS DescName
       , tmpReceiptProdModelChild.ReceiptLevelName  ::TVarChar AS ReceiptLevelName
       , MovementItem.Amount           ::TFloat
       , MovementItem.isErased

       , COALESCE (tmpReceiptProdModelChild.GoodsGroupNameFull, tmpReceiptGoodsChild.GoodsGroupNameFull) ::TVarChar  AS GoodsGroupNameFull
       , COALESCE (tmpReceiptProdModelChild.GoodsGroupName, tmpReceiptGoodsChild.GoodsGroupName)         ::TVarChar  AS GoodsGroupName
       , COALESCE (tmpReceiptProdModelChild.Article, tmpReceiptGoodsChild.Article)                       ::TVarChar  AS Article
       , COALESCE (tmpReceiptProdModelChild.ProdColorName, tmpReceiptGoodsChild.ProdColorName)           :: TVarChar AS ProdColorName
       , COALESCE (tmpReceiptProdModelChild.MeasureName, tmpReceiptGoodsChild.MeasureName)               ::TVarChar  AS MeasureName
       , COALESCE (tmpReceiptProdModelChild.Value, tmpReceiptGoodsChild.Value)                           ::TFloat    AS Value
       , COALESCE (tmpReceiptProdModelChild.Value_service, tmpReceiptGoodsChild.Value_service)           ::TFloat    AS Value_service
       --разница от введенного
       , ( MovementItem.Amount - COALESCE (tmpReceiptProdModelChild.Value, tmpReceiptGoodsChild.Value) - COALESCE (tmpReceiptProdModelChild.Value_service, tmpReceiptGoodsChild.Value_service) )  :: TFloat   AS Amount_diff
       
       , COALESCE (tmpReceiptProdModelChild.Color_value, tmpReceiptGoodsChild.Color_value) :: Integer AS Color_value
       , COALESCE (tmpReceiptProdModelChild.Color_Level, tmpReceiptGoodsChild.Color_Level) :: Integer AS Color_Level
     FROM tmpMI AS MovementItem
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
          
          LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = MovementItem.ParentId

          LEFT JOIN _tmpReceiptProdModelChild AS tmpReceiptProdModelChild
                                              ON tmpReceiptProdModelChild.ReceiptProdModelId = tmpMI_Master.ReceiptProdModelId
                                             AND tmpReceiptProdModelChild.ObjectId           = MovementItem.ObjectId
                                            
          LEFT JOIN _tmpReceiptGoodsChild AS tmpReceiptGoodsChild 
                                          ON tmpReceiptGoodsChild.ReceiptGoodsId = tmpMI_Master.ObjectId
                                         AND tmpReceiptGoodsChild.ObjectId       = MovementItem.ObjectId
     ;
   ELSE 
   RETURN QUERY
    WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )

    

   , tmpMI_Master AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId
                           , MILO_ReceiptProdModel.ObjectId AS ReceiptProdModelId
                      FROM tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemLinkObject AS MILO_ReceiptProdModel
                                                            ON MILO_ReceiptProdModel.MovementItemId = MovementItem.Id
                                                           AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()
                     )

 /*  , tmpReceiptProdModelChild AS (SELECT tmpMI_Master.Id AS ParentId
                                       , ObjectFloat_Value.ValueData       ::TFloat   AS Value
                                       , ObjectDesc.ItemName               ::TVarChar AS DescName
                                       , Object_Object.Id                  ::Integer  AS ObjectId
                                       , Object_Object.ObjectCode          ::Integer  AS ObjectCode
                                       , Object_Object.ValueData           ::TVarChar AS ObjectName
                                  FROM tmpMI_Master
                                       INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                             ON ObjectLink_ReceiptProdModel.ChildObjectId = tmpMI_Master.ReceiptProdModelId  --Object_ReceiptProdModelChild.Id
                                                            AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                       LEFT JOIN Object AS Object_ReceiptProdModelChild
                                                        ON Object_ReceiptProdModelChild.Id = ObjectLink_ReceiptProdModel.ObjectId
                                                       AND Object_ReceiptProdModelChild.DescId = zc_Object_ReceiptProdModelChild()
                                                       AND Object_ReceiptProdModelChild.isErased = FALSE
                             
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                            AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value() 

                                       INNER JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                           AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptProdModelChild_Object()
                                       INNER JOIN Object AS Object_Object
                                                        ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                                       AND Object_Object.DescId IN (zc_Object_Goods(),zc_Object_ReceiptService())
                                       LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                                  WHERE COALESCE (tmpMI_Master.ReceiptProdModelId,0) <> 0
                                  )

   , tmpReceiptGoodsChild AS (SELECT tmpMI_Master.Id AS ParentId
                                   , ObjectFloat_Value.ValueData       ::TFloat   AS Value
                                   , ObjectDesc.ItemName               ::TVarChar AS DescName
                                   , Object_Object.Id                  ::Integer  AS ObjectId
                                   , Object_Object.ObjectCode          ::Integer  AS ObjectCode
                                   , Object_Object.ValueData           ::TVarChar AS ObjectName
                              FROM tmpMI_Master
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                        ON ObjectLink_ReceiptGoods.ChildObjectId = tmpMI_Master.ObjectId
                                                       AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()

                                   LEFT JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id = ObjectLink_ReceiptGoods.ObjectId 

                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value()  

                                   LEFT JOIN ObjectLink AS ObjectLink_Object
                                                        ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
      
                                   INNER JOIN Object AS Object_Object
                                                    ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                                   AND Object_Object.DescId IN (zc_Object_Goods(),zc_Object_ReceiptService())
                                   LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                              WHERE COALESCE (tmpMI_Master.ReceiptProdModelId,0) = 0
                              )
*/
   , tmpMI AS (SELECT MovementItem.ObjectId   AS ObjectId
                    , MovementItem.Amount
                    , MovementItem.Id
                    , MovementItem.ParentId
                    , MovementItem.isErased
               FROM tmpIsErased
                    JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Child()
                                     AND MovementItem.isErased   = tmpIsErased.isErased
              )


     SELECT
         MovementItem.Id
       --, ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id ASC) :: Integer AS NPP
       , COALESCE (tmpReceiptProdModelChild.NPP, tmpReceiptGoodsChild.NPP)  :: Integer AS NPP
       , MovementItem.ParentId
       , MovementItem.ObjectId      AS ObjectId
       , Object_Object.ObjectCode   AS ObjectCode
       , Object_Object.ValueData    AS ObjectName
       , ObjectDesc.ItemName ::TVarChar AS DescName
       , tmpReceiptProdModelChild.ReceiptLevelName  ::TVarChar AS ReceiptLevelName
       , MovementItem.Amount           ::TFloat
       , MovementItem.isErased

       , COALESCE (tmpReceiptProdModelChild.GoodsGroupNameFull, tmpReceiptGoodsChild.GoodsGroupNameFull) ::TVarChar  AS GoodsGroupNameFull
       , COALESCE (tmpReceiptProdModelChild.GoodsGroupName, tmpReceiptGoodsChild.GoodsGroupName)         ::TVarChar  AS GoodsGroupName
       , COALESCE (tmpReceiptProdModelChild.Article, tmpReceiptGoodsChild.Article)                       ::TVarChar  AS Article
       , COALESCE (tmpReceiptProdModelChild.ProdColorName, tmpReceiptGoodsChild.ProdColorName)           :: TVarChar AS ProdColorName
       , COALESCE (tmpReceiptProdModelChild.MeasureName, tmpReceiptGoodsChild.MeasureName)               ::TVarChar  AS MeasureName
       , COALESCE (tmpReceiptProdModelChild.Value, tmpReceiptGoodsChild.Value)                           ::TFloat    AS Value
       , COALESCE (tmpReceiptProdModelChild.Value_service, tmpReceiptGoodsChild.Value_service)           ::TFloat    AS Value_service
       --разница от введенного
       , ( MovementItem.Amount - COALESCE (tmpReceiptProdModelChild.Value, tmpReceiptGoodsChild.Value) - COALESCE (tmpReceiptProdModelChild.Value_service, tmpReceiptGoodsChild.Value_service) )  :: TFloat   AS Amount_diff
       
       , COALESCE (tmpReceiptProdModelChild.Color_value, tmpReceiptGoodsChild.Color_value) :: Integer AS Color_value
       , COALESCE (tmpReceiptProdModelChild.Color_Level, tmpReceiptGoodsChild.Color_Level) :: Integer AS Color_Level
     FROM tmpMI AS MovementItem
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

          LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = MovementItem.ParentId

          LEFT JOIN _tmpReceiptProdModelChild AS tmpReceiptProdModelChild
                                              ON tmpReceiptProdModelChild.ReceiptProdModelId = tmpMI_Master.ReceiptProdModelId
                                             AND tmpReceiptProdModelChild.ObjectId           = MovementItem.ObjectId
                                            
          LEFT JOIN _tmpReceiptGoodsChild AS tmpReceiptGoodsChild 
                                          ON tmpReceiptGoodsChild.ReceiptGoodsId = tmpMI_Master.ObjectId
                                         AND tmpReceiptGoodsChild.ObjectId       = MovementItem.ObjectId

     ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         *
*/

-- тест
-- SELECT * from gpSelect_MI_ProductionUnion_Child (inMovementId:= 306,inShowAll:=true,  inIsErased:= true, inSession:= zfCalc_UserAdmin());