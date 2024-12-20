-- Function: gpSelect_MI_OrderInternal_Master()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal (Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternal_Master (Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternal_Master (
    IN inMovementId             Integer,   -- ключ Документа   
    IN inMovementId_OrderClient Integer,   -- заказ клиента
    IN inShowAll                Boolean,   --
    IN inIsErased               Boolean,   --
    IN inSession                TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, DescName TVarChar
             , Amount TFloat, Amount_unit TFloat
             , EAN TVarChar
             , Article TVarChar, Article_all TVarChar
             , GoodsGroupName TVarChar
             , GoodsGroupNameFull TVarChar
             , MeasureName TVarChar
             , ProdColorName_goods TVarChar
             , Comment_goods TVarChar
             , Comment TVarChar 
             , UnitId Integer, UnitName TVarChar
             , MovementId_OrderClient Integer, InvNumber_OrderClient TVarChar, InvNumberFull_OrderClient TVarChar, OperDate_OrderClient TDateTime
             , FromName TVarChar, ProductName TVarChar, CIN TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , OperDate_protocol TDateTime, UserName_protocol TVarChar
             , Ord Integer
             , isEnabled Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbToId         Integer;
  DECLARE vbFromId       Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);


    IF inShowAll = TRUE -- OR inMovementId_OrderClient > 0
    THEN
        RETURN QUERY
        WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )

     , tmpMI AS   (SELECT MovementItem.ObjectId   AS GoodsId
                        , MovementItem.Amount 
                        , MovementItem.Id
                        , MovementItem.isErased
                        , MIString_Comment.ValueData    AS Comment
 
                        , Object_Insert.ValueData     AS InsertName
                        , MIDate_Insert.ValueData     AS InsertDate
                        , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                        , MILinkObject_Unit.ObjectId  AS UnitId
                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased

                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                       ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
            
                      LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                  ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                 AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

                      LEFT JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                      LEFT JOIN MovementItemDate AS MIDate_Insert
                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                AND MIDate_Insert.DescId = zc_MIDate_Insert()
                      LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                       ON MILO_Insert.MovementItemId = MovementItem.Id
                                                      AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                      LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                     )
     -- Заказ клиента - zc_MI_Detail
   , tmpOrderClient_Detail AS (SELECT DISTINCT
                                       MovementItem.MovementId           AS MovementId_order
                                      -- "виртуальный" узел
                                     , MILinkObject_Goods_basis.ObjectId AS GoodsId
                                      -- узел
                                     , MILinkObject_Goods.ObjectId       AS GoodsId_master
                                     , 1                                 AS Amount
                                FROM Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Detail()
                                                            AND MovementItem.isErased   = FALSE
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                      ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                                      ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                                WHERE Movement.Id = inMovementId_OrderClient
                                  AND Movement.DescId = zc_Movement_OrderClient()
                               )
       -- Заказ клиента - zc_MI_Child
     , tmpOrderClient_Child AS (SELECT MovementItem.MovementId AS MovementId_order
                                     , MovementItem.ObjectId   AS GoodsId
                                     , MovementItem.Amount     AS Amount
                                FROM Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Child()
                                                            AND MovementItem.isErased   = FALSE
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                                      ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                                WHERE Movement.Id = inMovementId_OrderClient
                                  AND Movement.DescId = zc_Movement_OrderClient()
                                  AND MovementItem.Amount > 0
                                  AND MILinkObject_ProdOptions.ObjectId IS NULL
                                  -- если этот узел собирается
                                  AND MovementItem.ObjectId IN (SELECT tmpOrderClient_Detail.GoodsId_master FROM tmpOrderClient_Detail)

                               UNION
                                -- добавили "виртуальные" узел
                                SELECT DISTINCT
                                       tmpOrderClient_Detail.MovementId_order
                                     , tmpOrderClient_Detail.GoodsId
                                     , tmpOrderClient_Detail.Amount
                                FROM tmpOrderClient_Detail
                                WHERE tmpOrderClient_Detail.GoodsId > 0
                               )

     , tmpGoodsParams AS (SELECT tmpGoods.GoodsId
                               , ObjectString_EAN.ValueData         AS EAN
                               , ObjectString_Article.ValueData     AS Article
                               , Object_GoodsGroup.Id               AS GoodsGroupId
                               , Object_GoodsGroup.ValueData        AS GoodsGroupName
                               , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                               , Object_Measure.Id                  AS MeasureId
                               , Object_Measure.ValueData           AS MeasureName

                                 -- Цена вх. без НДС
                               , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
                                 -- Цена вх. с НДС
                               , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                    * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)) ::TFloat AS EKPriceWVAT

                          FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI
                          UNION SELECT DISTINCT tmpOrderClient_Child.GoodsId FROM tmpOrderClient_Child      
                                ) AS tmpGoods
                              LEFT JOIN ObjectString AS ObjectString_Article
                                                     ON ObjectString_Article.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_Article.DescId = zc_ObjectString_Article()

                              LEFT JOIN ObjectString AS ObjectString_EAN
                                                     ON ObjectString_EAN.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_EAN.DescId = zc_ObjectString_EAN()

                              LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                     ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                              LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                    ON ObjectFloat_EKPrice.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                   ON ObjectLink_Goods_TaxKind.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                              LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                    ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                   AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                          )
       -- резерв
     , tmpMI_Child AS (SELECT MovementItem.ParentId
                            , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Child()
                         AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ParentId
                      )
        , tmpProtocol AS (SELECT MovementItemProtocol.*
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate DESC) AS Ord
                          FROM MovementItemProtocol
                          WHERE MovementItemProtocol.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                         )

            SELECT
                0                          AS Id
              , Object_Goods.Id            AS GoodsId
              , Object_Goods.ObjectCode    AS GoodsCode
              , Object_Goods.ValueData     AS GoodsName 
              , CASE WHEN Object_Goods.DescId = zc_Object_Goods() THEN 'Узел' ELSE ObjectDesc.ItemName END :: TVarChar AS DescName

              , CAST (1 AS TFloat)      AS Amount
              , CAST (NULL AS TFloat)      AS Amount_unit
                --
              , tmpGoodsParams.EAN
              , tmpGoodsParams.Article
              , zfCalc_Article_all (tmpGoodsParams.Article) ::TVarChar AS Article_all
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureName
              , Object_ProdColor.ValueData            AS ProdColorName_goods
              , ObjectString_Goods_Comment.ValueData  AS Comment_goods

              , NULL::TVarChar             AS Comment

              , 0                          AS UnitId
              , ''   ::TVarChar            AS UnitName

              , Movement_OrderClient.Id                                   AS MovementId_OrderClient
              , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) :: TVarChar AS InvNumber_OrderClient
              , ('№ ' || Movement_OrderClient.InvNumber || ' от ' || zfConvert_DateToString (Movement_OrderClient.OperDate) :: TVarChar ) :: TVarChar  AS InvNumberFull_OrderClient
              , Movement_OrderClient.OperDate                             AS OperDate_OrderClient
              , Object_From.ValueData                      AS FromName 
              , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
              , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN

              , NULL::TVarChar             AS InsertName
              , NULL::TDateTime            AS InsertDate

              , NULL::TDateTime            AS OperDate_protocol
              , NULL::TVarChar             AS UserName_protocol

              , 0     :: Integer           AS Ord
              , FALSE :: Boolean           AS isEnabled
              , FALSE :: Boolean           AS isErased

            FROM tmpOrderClient_Child
                LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpOrderClient_Child.GoodsId

                LEFT JOIN Object AS Object_Goods      ON Object_Goods.Id = tmpOrderClient_Child.GoodsId 
                LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
                LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpOrderClient_Child.GoodsId
                
                LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = inMovementId_OrderClient
                 
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                             ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                            AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId  

                LEFT JOIN ObjectString AS ObjectString_CIN
                                       ON ObjectString_CIN.ObjectId = Object_Product.Id
                                      AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

                 LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                        ON ObjectString_Goods_Comment.ObjectId = Object_Goods.Id
                                       AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()
                 LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                      ON ObjectLink_ProdColor.ObjectId = Object_Goods.Id
                                     AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                 LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId

            WHERE tmpMI.GoodsId IS NULL
          UNION ALL
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName 
              , CASE WHEN Object_Goods.DescId = zc_Object_Goods() THEN 'Узел' ELSE ObjectDesc.ItemName END :: TVarChar AS DescName

              , MovementItem.Amount           ::TFloat
              , tmpMI_Child.Amount            ::TFloat AS Amount_unit
            
               --
              , tmpGoodsParams.EAN
              , tmpGoodsParams.Article
              , zfCalc_Article_all (tmpGoodsParams.Article) ::TVarChar AS Article_all
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureName
              , Object_ProdColor.ValueData            AS ProdColorName_goods
              , ObjectString_Goods_Comment.ValueData  AS Comment_goods

              , MovementItem.Comment    :: TVarChar AS Comment

              , Object_Unit.Id                      AS UnitId
              , Object_Unit.ValueData               AS UnitName

              , Movement_OrderClient.Id                                   AS MovementId_OrderClient
              , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) :: TVarChar AS InvNumber_OrderClient
              , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
              , Movement_OrderClient.OperDate                             AS OperDate_OrderClient
              , Object_From.ValueData                      AS FromName 
              , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
              , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN

              , MovementItem.InsertName
              , MovementItem.InsertDate

              , tmpProtocol.OperDate  AS OperDate_protocol
              , Object_User.ValueData AS UserName_protocol

              , ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) :: Integer AS Ord
              , TRUE :: Boolean AS isEnabled
              , MovementItem.isErased

            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId
                 LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
                 LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = MovementItem.Id
                                      AND tmpProtocol.Ord            = 1
                 LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId
                 
                 LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.UnitId
                 
                 LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MovementItem.MovementId_OrderClient
                 
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                 LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                              ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                             AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                 LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId  

                 LEFT JOIN ObjectString AS ObjectString_CIN
                                        ON ObjectString_CIN.ObjectId = Object_Product.Id
                                       AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

                 LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                        ON ObjectString_Goods_Comment.ObjectId = Object_Goods.Id
                                       AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()
                 LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                      ON ObjectLink_ProdColor.ObjectId = Object_Goods.Id
                                     AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                 LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId
            ;
  
    ELSE
  
       RETURN QUERY
       WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )
       , tmpMI AS (SELECT MovementItem.ObjectId       AS GoodsId
                        , MovementItem.Amount
                        , MovementItem.Id
                        , MovementItem.isErased
                        , Object_Insert.ValueData     AS InsertName
                        , MIDate_Insert.ValueData     AS InsertDate                
                        , MIString_Comment.ValueData  AS Comment
                        , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                        , MILinkObject_Unit.ObjectId  AS UnitId
                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased

                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                       ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()

                      LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                  ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                 AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

                      LEFT JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                      LEFT JOIN MovementItemDate AS MIDate_Insert
                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                AND MIDate_Insert.DescId = zc_MIDate_Insert()
                      LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                       ON MILO_Insert.MovementItemId = MovementItem.Id
                                                      AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                      LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                     )

     , tmpGoodsParams AS (SELECT tmpGoods.GoodsId
                               , ObjectString_EAN.ValueData         AS EAN
                               , ObjectString_Article.ValueData     AS Article
                               , Object_GoodsGroup.Id               AS GoodsGroupId
                               , Object_GoodsGroup.ValueData        AS GoodsGroupName
                               , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                               , Object_Measure.Id                  AS MeasureId
                               , Object_Measure.ValueData           AS MeasureName

                                 -- Цена вх. без НДС
                               , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
                                 -- Цена вх. с НДС
                               , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                    * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)) ::TFloat AS EKPriceWVAT
                                    
                          FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods
                              LEFT JOIN ObjectString AS ObjectString_Article
                                                     ON ObjectString_Article.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_Article.DescId = zc_ObjectString_Article()

                              LEFT JOIN ObjectString AS ObjectString_EAN
                                                     ON ObjectString_EAN.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_EAN.DescId = zc_ObjectString_EAN()

                              LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                     ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                              LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                    ON ObjectFloat_EKPrice.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                   ON ObjectLink_Goods_TaxKind.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                              LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                    ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                   AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                          )

       --резерв
     , tmpMI_Child AS (SELECT MovementItem.ParentId
                            , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Child()
                         AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ParentId
                      )

     , tmpProtocol AS (SELECT MovementItemProtocol.*
                              -- № п/п
                            , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate DESC) AS Ord
                       FROM MovementItemProtocol
                       WHERE MovementItemProtocol.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                      )

            -- Результат
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName
              , CASE WHEN Object_Goods.DescId = zc_Object_Goods() THEN 'Узел' ELSE ObjectDesc.ItemName END :: TVarChar AS DescName
              , MovementItem.Amount           ::TFloat
              , tmpMI_Child.Amount            ::TFloat AS Amount_unit
              --
              , tmpGoodsParams.EAN
              , tmpGoodsParams.Article 
              , zfCalc_Article_all (tmpGoodsParams.Article) ::TVarChar AS Article_all
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureName
              , Object_ProdColor.ValueData            AS ProdColorName_goods
              , ObjectString_Goods_Comment.ValueData  AS Comment_goods

              , MovementItem.Comment    ::TVarChar

              , Object_Unit.Id                      AS UnitId
              , Object_Unit.ValueData               AS UnitName

              , Movement_OrderClient.Id                                   AS MovementId_OrderClient
              , zfConvert_StringToNumber (Movement_OrderClient.InvNumber):: TVarChar AS InvNumber_OrderClient 
              , ('№ ' || Movement_OrderClient.InvNumber || ' от ' || zfConvert_DateToString (Movement_OrderClient.OperDate) :: TVarChar ) :: TVarChar  AS InvNumberFull_OrderClient
              , Movement_OrderClient.OperDate                             AS OperDate_OrderClient
              , Object_From.ValueData                      AS FromName 
              , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
              , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,Object_Product.isErased) AS CIN

              , MovementItem.InsertName
              , MovementItem.InsertDate

              , tmpProtocol.OperDate  AS OperDate_protocol
              , Object_User.ValueData AS UserName_protocol

              , ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) :: Integer AS Ord
              , TRUE :: Boolean AS isEnabled
              , MovementItem.isErased

            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId
                 LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id

                 LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = MovementItem.Id
                                      AND tmpProtocol.Ord            = 1
                 LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId

                 LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.UnitId

                 LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MovementItem.MovementId_OrderClient

                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                 LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                              ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                             AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                 LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId  

                 LEFT JOIN ObjectString AS ObjectString_CIN
                                        ON ObjectString_CIN.ObjectId = Object_Product.Id
                                       AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

                 LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                        ON ObjectString_Goods_Comment.ObjectId = Object_Goods.Id
                                       AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()
                 LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                      ON ObjectLink_ProdColor.ObjectId = Object_Goods.Id
                                     AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                 LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId
            ;
    END IF;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.12.22         *
 23.12.22         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderInternal_Master (inMovementId:= 0, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MI_OrderInternal_Master (inMovementId:= 218 , inMovementId_OrderClient:= 662, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
