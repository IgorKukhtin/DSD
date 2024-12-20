-- Function: gpSelect_MI_ProductionUnion_Master()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ProductionUnion (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ProductionUnion (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_ProductionUnion_Master (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionUnion_Master (
    IN inMovementId  Integer      , -- ключ Документа
    --IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar, DescName TVarChar
             , Article TVarChar, ProdColorName TVarChar, Comment_goods TVarChar
             , ReceiptProdModelId Integer, ReceiptProdModelCode Integer, ReceiptProdModelName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , Comment TVarChar
             , isErased Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , CIN TVarChar, EngineNum TVarChar, EngineName TVarChar
             , MovementId_OrderClient Integer, InvNumber_OrderClient TVarChar, InvNumberFull_OrderClient TVarChar, OperDate_OrderClient TDateTime
             , FromName_OrderClient TVarChar, ProductName_OrderClient TVarChar, CIN_OrderClient TVarChar
             , Ord Integer
             )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbToId         Integer;
  DECLARE vbFromId       Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ProductionUnion());
    vbUserId := lpGetUserBySession (inSession);

    SELECT MovementLinkObject_From.ObjectId        AS FromId
         , MovementLinkObject_To.ObjectId          AS ToId
    INTO vbFromId
       , vbToId
    FROM Movement AS Movement_ProductionUnion
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement_ProductionUnion.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement_ProductionUnion.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

    WHERE Movement_ProductionUnion.Id = inMovementId
      AND Movement_ProductionUnion.DescId = zc_Movement_ProductionUnion();



    RETURN QUERY
       WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )
     , tmpMI AS   (SELECT MovementItem.ObjectId       AS ObjectId
                        , MILO_ReceiptProdModel.ObjectId AS ReceiptProdModelId
                        , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                        , MovementItem.Amount

                        , MovementItem.Id
                        , MovementItem.isErased
                        , MIString_Comment.ValueData  AS Comment

                        , Object_Insert.ValueData     AS InsertName
                        , MIDate_Insert.ValueData     AS InsertDate

                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased

                      LEFT JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                      LEFT JOIN MovementItemLinkObject AS MILO_ReceiptProdModel
                                                       ON MILO_ReceiptProdModel.MovementItemId = MovementItem.Id
                                                      AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()

                      LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                  ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                 AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

                      LEFT JOIN MovementItemDate AS MIDate_Insert
                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                AND MIDate_Insert.DescId = zc_MIDate_Insert()
                      LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                       ON MILO_Insert.MovementItemId = MovementItem.Id
                                                      AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                      LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                     )
      , tmpMIContainer AS (SELECT MIContainer.MovementItemId
                                , SUM (1 * MIContainer.Amount) AS Amount
                           FROM MovementItemContainer AS MIContainer
                           WHERE MIContainer.MovementId = inMovementId
                             AND MIContainer.DescId     = zc_MIContainer_Summ()
                           GROUP BY MIContainer.MovementItemId
                          )
            -- результат
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.ObjectId      AS ObjectId
              , Object_Object.ObjectCode   AS ObjectCode
              , zfCalc_ValueData_isErased (Object_Object.ValueData, Object_Object.isErased) AS ObjectName
              , CASE WHEN Object_Object.DescId = zc_Object_Goods() THEN 'Узел' ELSE ObjectDesc.ItemName END :: TVarChar AS DescName
              , ObjectString_Article.ValueData        AS Article
              , Object_ProdColor.ValueData            AS ProdColorName
              , ObjectString_Goods_Comment.ValueData  AS Comment_goods

              , Object_ReceiptProdModel.Id         AS ReceiptProdModelId
              , Object_ReceiptProdModel.ObjectCode AS ReceiptProdModelCode
              , Object_ReceiptProdModel.ValueData  AS ReceiptProdModelName

              , MovementItem.Amount ::TFloat
              , (tmpMIContainer.Amount / CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount ELSE 1 END) ::TFloat AS Price
              , tmpMIContainer.Amount :: TFloat AS Summ

              , MovementItem.Comment ::TVarChar
              , MovementItem.isErased

              , MovementItem.InsertName
              , MovementItem.InsertDate

              , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Object.isErased)       AS CIN
              , zfCalc_ValueData_isErased (ObjectString_EngineNum.ValueData, Object_Object.isErased) AS EngineNum
              , Object_Engine.ValueData AS EngineName

              , Movement_OrderClient.Id                                               AS MovementId_OrderClient
              , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) :: TVarChar AS InvNumber_OrderClient
              , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
              , Movement_OrderClient.OperDate                                         AS OperDate_OrderClient
              , Object_From.ValueData                                                 AS FromName_OrderClient
              , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)       AS ProductName_OrderClient
              , zfCalc_ValueData_isErased (ObjectString_CIN_Ord.ValueData, Object_Product.isErased) AS CIN_OrderClient

              , ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) :: Integer AS Ord

            FROM tmpMI AS MovementItem
                 LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = MovementItem.Id

                 LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId
                 LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

                 LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = MovementItem.ReceiptProdModelId

                 LEFT JOIN ObjectString AS ObjectString_CIN
                                        ON ObjectString_CIN.ObjectId = MovementItem.ObjectId
                                       AND ObjectString_CIN.DescId   = zc_ObjectString_Product_CIN()
                 LEFT JOIN ObjectString AS ObjectString_EngineNum
                                        ON ObjectString_EngineNum.ObjectId = MovementItem.ObjectId
                                       AND ObjectString_EngineNum.DescId   = zc_ObjectString_Product_EngineNum()
                 LEFT JOIN ObjectLink AS ObjectLink_Engine
                                      ON ObjectLink_Engine.ObjectId = MovementItem.ObjectId
                                     AND ObjectLink_Engine.DescId   = zc_ObjectLink_Product_Engine()
                 LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId

                 LEFT JOIN ObjectString AS ObjectString_Article
                                        ON ObjectString_Article.ObjectId = MovementItem.ObjectId
                                       AND ObjectString_Article.DescId   = zc_ObjectString_Article()
                 LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                        ON ObjectString_Goods_Comment.ObjectId = MovementItem.ObjectId
                                       AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                      ON ObjectLink_Goods_ProdColor.ObjectId = MovementItem.ObjectId
                                     AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                 LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                 -- OrderClient
                 LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MovementItem.MovementId_OrderClient

                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                 LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                              ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                             AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                 LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

                 LEFT JOIN ObjectString AS ObjectString_CIN_Ord
                                        ON ObjectString_CIN_Ord.ObjectId = Object_Product.Id
                                       AND ObjectString_CIN_Ord.DescId = zc_ObjectString_Product_CIN()
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.23         * add Movement_OrderClient
 12.07.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_ProductionUnion_Master (inMovementId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MI_ProductionUnion_Master (inMovementId:= 218, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
