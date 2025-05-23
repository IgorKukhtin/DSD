-- Function: gpSelect_MovementItem_Send()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send (
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartNumber TVarChar
             , Amount TFloat, Amount_unit TFloat
             , OperPrice TFloat
             , CountForPrice TFloat
             , TotalOperPrice TFloat

             , EAN                TVarChar
             , Article            TVarChar
             , ArticleVergl       TVarChar
             , Article_all        TVarChar
             , GoodsGroupName     TVarChar
             , GoodsGroupNameFull TVarChar
             , MeasureName        TVarChar
             , ProdColorName      TVarChar
             , Comment_goods      TVarChar

             , isOn Boolean
             , Comment TVarChar
             , PartnerName TVarChar
             , MovementId_OrderClient Integer, InvNumber_OrderClient Integer, InvNumberFull_OrderClient TVarChar, OperDate_OrderClient TDateTime
             , FromName TVarChar, ProductName TVarChar, CIN TVarChar

             , PartionCellId Integer, PartionCellCode Integer, PartionCellName TVarChar

             , InsertName TVarChar, InsertDate TDateTime
             , OperDate_protocol TDateTime, UserName_protocol TVarChar
             , Ord Integer
               -- Сборка (да/нет) - Участвует в сборке Узла/Модели
             , isReceiptGoods Boolean
               -- Опция (да/нет) - Участвует в опциях
             , isProdOptions  Boolean
               --
             , isErased Boolean
             , Color_Scan Integer
             )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbToId         Integer;
  DECLARE vbFromId       Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId := lpGetUserBySession (inSession);

    SELECT MovementLinkObject_From.ObjectId        AS FromId
         , MovementLinkObject_To.ObjectId          AS ToId
    INTO vbFromId
       , vbToId
    FROM Movement AS Movement_Send
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement_Send.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement_Send.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

    WHERE Movement_Send.Id = inMovementId
      AND Movement_Send.DescId = zc_Movement_Send();



    IF inShowAll = TRUE
    THEN
        RETURN QUERY
          WITH tmpIsErased AS (SELECT FALSE AS isErased
                              UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )
       , tmpMIScan AS (SELECT MovementItem.ObjectId AS GoodsId
                            , SUM (MovementItem.Amount)::TFloat                     AS Amount
                            , COALESCE (MIString_PartNumber.ValueData, '')          AS PartNumber
                            , MAX (MovementItem.Id)                                 AS MaxID
                            , COALESCE (MIFloat_MovementId.ValueData, 0) :: Integer AS MovementId_OrderClient
                       FROM tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Scan()
                                             AND MovementItem.isErased   = tmpIsErased.isErased

                            LEFT JOIN MovementItemString AS MIString_PartNumber
                                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                        AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

                       GROUP BY MovementItem.ObjectId
                              , COALESCE (MIString_PartNumber.ValueData, '')
                              , COALESCE (MIFloat_MovementId.ValueData, 0)
                      )
       , tmpMIMaster AS (SELECT MovementItem.ObjectId                           AS GoodsId
                              , MovementItem.Amount

                              , MovementItem.Id
                              , MovementItem.isErased
                              , MIString_PartNumber.ValueData AS PartNumber
                              , COALESCE (MIFloat_MovementId.ValueData, 0) :: Integer AS MovementId_OrderClient
                         FROM tmpIsErased
                             JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased   = tmpIsErased.isErased

                             LEFT JOIN MovementItemString AS MIString_PartNumber
                                                          ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                         AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                         ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                        )

       -- остатки
     /*, tmpContainer_All AS (SELECT Container.*
                            FROM Container
                             WHERE (Container.WhereObjectId = vbFromId OR COALESCE (vbFromId,0) = 0)
                               AND COALESCE(Container.Amount,0) <> 0
                               AND Container.DescId = zc_Container_Count()
                            )*/

      -- если Товар участвует в сборке
    , tmpReceiptGoods_all AS (-- Сборка Модели
                              SELECT ObjectLink_ReceiptProdModelChild_Object.ChildObjectId AS GoodsId_from
                                   , 0 AS GoodsId_to
                                   , 0 AS GoodsId_child
                              FROM Object AS Object_ReceiptProdModel
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_ReceiptProdModel
                                                         ON ObjectLink_ReceiptProdModelChild_ReceiptProdModel.ChildObjectId = Object_ReceiptProdModel.Id
                                                        AND ObjectLink_ReceiptProdModelChild_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                   INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id       = ObjectLink_ReceiptProdModelChild_ReceiptProdModel.ObjectId
                                                                                    AND Object_ReceiptProdModelChild.isErased = FALSE
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_Object
                                                         ON ObjectLink_ReceiptProdModelChild_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                        AND ObjectLink_ReceiptProdModelChild_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()



                              WHERE Object_ReceiptProdModel.DescId   = zc_Object_ReceiptProdModelChild()
                                AND Object_ReceiptProdModel.isErased = FALSE

                             UNION ALL
                              -- Сборка узлов
                              SELECT ObjectLink_ReceiptGoodsChild_Object.ChildObjectId     AS GoodsId_from
                                   , ObjectLink_ReceiptGoods_Object.ChildObjectId          AS GoodsId_to
                                   , ObjectLink_ReceiptGoodsChild_GoodsChild.ChildObjectId AS GoodsId_child
                              FROM Object AS Object_ReceiptGoods
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                         ON ObjectLink_ReceiptGoods_Object.ObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_ReceiptGoods_Object.DescId   = zc_ObjectLink_ReceiptGoods_Object()

                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                                         ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                   INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                                                AND Object_ReceiptGoodsChild.isErased = FALSE
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_Object
                                                         ON ObjectLink_ReceiptGoodsChild_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                        AND ObjectLink_ReceiptGoodsChild_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()

                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_GoodsChild
                                                        ON ObjectLink_ReceiptGoodsChild_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_ReceiptGoodsChild_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()

                              WHERE Object_ReceiptGoods.DescId   = zc_Object_ReceiptGoods()
                                AND Object_ReceiptGoods.isErased = FALSE
                             )
         -- если Товар участвует в сборке
       , tmpReceiptGoods AS (-- Сборка Модели
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_from AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_from > 0
                             UNION
                              -- Сборка узлов
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_to AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_to > 0
                             )
         -- Опции
       , tmpProdOptions AS (SELECT DISTINCT ObjectLink_ProdOptions_Goods.ChildObjectId AS GoodsId
                            FROM Object AS Object_ProdOptions
                                 INNER JOIN ObjectLink AS ObjectLink_ProdOptions_Goods
                                                       ON ObjectLink_ProdOptions_Goods.ObjectId = Object_ProdOptions.Id
                                                      AND ObjectLink_ProdOptions_Goods.DescId   = zc_ObjectLink_ProdOptions_Goods()
                            WHERE Object_ProdOptions.DescId   = zc_Object_ProdOptions()
                              AND Object_ProdOptions.isErased = FALSE
                           )
       -- партии товаров на остатке
     , tmpObject_PartionGoods AS (SELECT Object_Goods.Id                           AS ObjectId
                                       , ObjectLink_Goods_Measure.ChildObjectId    AS MeasureId
                                       , ObjectLink_Goods_GoodsGroup.ChildObjectId AS GoodsGroupId
                                       , 0 AS EKPrice
                                  FROM Object AS Object_Goods
                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                            ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                            ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                                           AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                  WHERE Object_Goods.DescId = zc_Object_Goods()

                                    AND Object_Goods.isErased = FALSE
                                    -- отключил!
                                    --AND 1=0
                                  )

       , tmpMI AS (SELECT COALESCE (MovementItem.GoodsId, tmpMIScan.GoodsId)           AS GoodsId
                        , COALESCE (MovementItem.Amount, tmpMIScan.Amount)   :: TFloat AS Amount

                        , MovementItem.Id
                        , MovementItem.isErased
                        , COALESCE (MovementItem.PartNumber, tmpMIScan.PartNumber)     AS PartNumber
                        , MIString_Comment.ValueData          AS Comment

                        , Object_Insert.ValueData             AS InsertName
                        , MIDate_Insert.ValueData             AS InsertDate

                        , COALESCE(MovementItem.MovementId_OrderClient, tmpMIScan.MovementId_OrderClient) AS MovementId_OrderClient

                        , Object_PartionCell.Id         AS PartionCellId
                        , Object_PartionCell.ObjectCode AS PartionCellCode
                        , Object_PartionCell.ValueData  AS PartionCellName
                   FROM tmpMIMaster AS MovementItem

                       FULL JOIN tmpMIScan ON tmpMIScan.GoodsId                = MovementItem.GoodsId
                                          AND tmpMIScan.PartNumber             = MovementItem.PartNumber
                                          AND tmpMIScan.MovementId_OrderClient = MovementItem.MovementId_OrderClient

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

                       LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                        ON MILO_PartionCell.MovementItemId = COALESCE(MovementItem.Id, tmpMIScan.MaxID)
                                                       AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()
                       LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = MILO_PartionCell.ObjectId
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

                         )
       -- партии
     , tmpMI_Child AS (SELECT MovementItem.ParentId
                            , SUM (MovementItem.Amount) AS Amount
                            , SUM (MovementItem.Amount * (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice)) AS TotalOperPrice
                       FROM tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
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
                0                          AS Id
              , Object_Goods.Id            AS GoodsId
              , Object_Goods.ObjectCode    AS GoodsCode
              , Object_Goods.ValueData     AS GoodsName
              , NULL::TVarChar             AS PartNumber

              , CAST (NULL AS TFloat)      AS Amount
              , CAST (NULL AS TFloat)      AS Amount_unit
              , tmpObject_PartionGoods.EKPrice ::TFloat AS OperPrice
              , 1 ::TFloat AS CountForPrice
              , CAST (NULL AS TFloat)      AS TotalOperPrice
                --
              , ObjectString_EAN.ValueData            AS EAN
              , ObjectString_Article.ValueData        AS Article
              , ObjectString_ArticleVergl.ValueData   AS ArticleVergl
              , zfCalc_Article_all (COALESCE (ObjectString_Article.ValueData, '') || '_' || COALESCE (ObjectString_ArticleVergl.ValueData, '')) ::TVarChar AS Article_all
              , Object_GoodsGroup.ValueData           AS GoodsGroupName
              , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
              , Object_Measure.ValueData              AS MeasureName
              , Object_ProdColor.ValueData            AS ProdColorName
              , ObjectString_Goods_Comment.ValueData  AS Comment_goods


              , FALSE ::Boolean            AS isOn
              , NULL::TVarChar             AS Comment
              , NULL::TVarChar             AS PartnerName

              , 0                          AS MovementId_OrderClient
              , 0    ::Integer             AS InvNumber_OrderClient
              , ''   ::TVarChar            AS InvNumberFull_OrderClient
              , NULL ::TDateTime           AS OperDate_OrderClient
              , ''   ::TVarChar            AS FromName
              , ''   ::TVarChar            AS ProductName
              , ''   ::TVarChar            AS CIN

              , 0    ::Integer             AS PartionCellId
              , 0    ::Integer             AS PartionCellCode
              , NULL::TVarChar             AS PartionCellName

              , NULL::TVarChar             AS InsertName
              , NULL::TDateTime            AS InsertDate

              , NULL::TDateTime            AS OperDate_protocol
              , NULL::TVarChar             AS UserName_protocol

              , 0     :: Integer           AS Ord
                -- Сборка (да/нет) - Участвует в сборке Узла/Модели
              , CASE WHEN tmpReceiptGoods.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods
                -- Опция (да/нет) - Участвует в опциях
              , CASE WHEN tmpProdOptions.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isProdOptions
                --
              , FALSE :: Boolean           AS isErased
              , zc_Color_Black()           AS Color_Scan

            FROM tmpObject_PartionGoods
                 LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpObject_PartionGoods.ObjectId
                 -- если Товар участвует в сборке
                 LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = tmpObject_PartionGoods.ObjectId
                 -- если Опции
                 LEFT JOIN tmpProdOptions ON tmpProdOptions.GoodsId = tmpObject_PartionGoods.ObjectId

                 LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpObject_PartionGoods.ObjectId
                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpObject_PartionGoods.GoodsGroupId
                 LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = tmpObject_PartionGoods.MeasureId

                 LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                        ON ObjectString_GoodsGroupFull.ObjectId = tmpObject_PartionGoods.ObjectId
                                       AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
                 LEFT JOIN ObjectString AS ObjectString_Article
                                        ON ObjectString_Article.ObjectId = tmpObject_PartionGoods.ObjectId
                                       AND ObjectString_Article.DescId = zc_ObjectString_Article()
                 LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                        ON ObjectString_ArticleVergl.ObjectId = tmpObject_PartionGoods.ObjectId
                                       AND ObjectString_ArticleVergl.DescId   = zc_ObjectString_ArticleVergl()
                 LEFT JOIN ObjectString AS ObjectString_EAN
                                        ON ObjectString_EAN.ObjectId = tmpObject_PartionGoods.ObjectId
                                       AND ObjectString_EAN.DescId = zc_ObjectString_EAN()

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
              , MovementItem.PartNumber       :: TVarChar

              , MovementItem.Amount           ::TFloat
              , tmpMI_Child.Amount            ::TFloat AS Amount_unit
              , CASE WHEN tmpMI_Child.Amount > 0
                     THEN tmpMI_Child.TotalOperPrice / tmpMI_Child.Amount
                     ELSE 0
                END :: TFloat AS OperPrice

              , 1 ::TFloat AS CountForPrice
              , tmpMI_Child.TotalOperPrice :: TFloat AS TotalOperPrice

               --
              , tmpGoodsParams.EAN
              , tmpGoodsParams.Article
              , ObjectString_ArticleVergl.ValueData AS ArticleVergl
              , zfCalc_Article_all (COALESCE (tmpGoodsParams.Article, '') || '_' || COALESCE (ObjectString_ArticleVergl.ValueData, '')) ::TVarChar AS Article_all
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureName
              , Object_ProdColor.ValueData            AS ProdColorName
              , ObjectString_Goods_Comment.ValueData  AS Comment_goods

              , (NOT MovementItem.isErased) ::Boolean AS isOn
              , MovementItem.Comment    :: TVarChar AS Comment
              , NULL                    :: TVarChar AS PartnerName

              , Movement_OrderClient.Id                                   AS MovementId_OrderClient
              , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) AS InvNumber_OrderClient
              , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
              , Movement_OrderClient.OperDate                             AS OperDate_OrderClient
              , Object_From.ValueData                      AS FromName
              , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
              , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN

              , MovementItem.PartionCellId   ::Integer
              , MovementItem.PartionCellCode ::Integer
              , MovementItem.PartionCellName ::TVarChar

              , MovementItem.InsertName
              , MovementItem.InsertDate

              , tmpProtocol.OperDate  AS OperDate_protocol
              , Object_User.ValueData AS UserName_protocol

              , ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) :: Integer AS Ord
                -- Сборка (да/нет) - Участвует в сборке Узла/Модели или в опциях
              , CASE WHEN tmpReceiptGoods.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods
                -- Опция (да/нет) - Участвует в опциях
              , CASE WHEN tmpProdOptions.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isProdOptions
                --
              , MovementItem.isErased

              , CASE WHEN COALESCE(MovementItem.Id, 0) = 0 THEN zc_Color_Blue() ELSE zc_Color_Black() END AS Color_Scan

            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId

                 -- если Товар участвует в сборке + Опции
                 LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = MovementItem.GoodsId
                 -- если Опции
                 LEFT JOIN tmpProdOptions ON tmpProdOptions.GoodsId = MovementItem.GoodsId

                 LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
                 LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = MovementItem.Id
                                      AND tmpProtocol.Ord            = 1
                 LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId

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

                 LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                        ON ObjectString_ArticleVergl.ObjectId = Object_Goods.Id
                                       AND ObjectString_ArticleVergl.DescId   = zc_ObjectString_ArticleVergl()
            ;
    ELSE
       RETURN QUERY
         WITH tmpIsErased AS (SELECT FALSE AS isErased
                             UNION ALL
                              SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                             )
       , tmpMIScan AS (SELECT MovementItem.ObjectId AS GoodsId
                            , SUM (MovementItem.Amount)::TFloat                     AS Amount
                            , COALESCE (MIString_PartNumber.ValueData, '')          AS PartNumber
                            , MAX (MovementItem.Id)                                 AS MaxID
                            , COALESCE (MIFloat_MovementId.ValueData, 0) :: Integer AS MovementId_OrderClient
                       FROM tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Scan()
                                             AND MovementItem.isErased   = tmpIsErased.isErased

                            LEFT JOIN MovementItemString AS MIString_PartNumber
                                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                        AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

                       GROUP BY MovementItem.ObjectId
                              , COALESCE (MIString_PartNumber.ValueData, '')
                              , COALESCE (MIFloat_MovementId.ValueData, 0)
                      )
       , tmpMIMaster AS (SELECT MovementItem.ObjectId                           AS GoodsId
                              , MovementItem.Amount

                              , MovementItem.Id
                              , MovementItem.isErased
                              , MIString_PartNumber.ValueData AS PartNumber
                              , COALESCE (MIFloat_MovementId.ValueData, 0) :: Integer AS MovementId_OrderClient
                         FROM tmpIsErased
                             JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased   = tmpIsErased.isErased

                             LEFT JOIN MovementItemString AS MIString_PartNumber
                                                          ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                         AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                         ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                        )



       , tmpMI AS (SELECT COALESCE (MovementItem.GoodsId, tmpMIScan.GoodsId)           AS GoodsId
                        , COALESCE (MovementItem.Amount, tmpMIScan.Amount)   ::TFloat  AS Amount

                        , MovementItem.Id
                        , MovementItem.isErased
                        , COALESCE(MovementItem.PartNumber, tmpMIScan.PartNumber)      AS PartNumber
                        , MIString_Comment.ValueData          AS Comment

                        , Object_Insert.ValueData             AS InsertName
                        , MIDate_Insert.ValueData             AS InsertDate

                        , COALESCE(MovementItem.MovementId_OrderClient, tmpMIScan.MovementId_OrderClient) AS MovementId_OrderClient

                        , Object_PartionCell.Id         AS PartionCellId
                        , Object_PartionCell.ObjectCode AS PartionCellCode
                        , Object_PartionCell.ValueData  AS PartionCellName
                   FROM tmpMIMaster AS MovementItem

                       FULL JOIN tmpMIScan ON tmpMIScan.GoodsId                = MovementItem.GoodsId
                                          AND tmpMIScan.PartNumber             = MovementItem.PartNumber
                                          AND tmpMIScan.MovementId_OrderClient = MovementItem.MovementId_OrderClient


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

                       LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                        ON MILO_PartionCell.MovementItemId = COALESCE(MovementItem.Id, tmpMIScan.MaxID)
                                                       AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()
                       LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = MILO_PartionCell.ObjectId
                  )



     -- если Товар участвует в сборке
   , tmpReceiptGoods_all AS (-- Сборка Модели
                              SELECT ObjectLink_ReceiptProdModelChild_Object.ChildObjectId AS GoodsId_from
                                   , 0 AS GoodsId_to
                                   , 0 AS GoodsId_child
                              FROM Object AS Object_ReceiptProdModel
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_ReceiptProdModel
                                                         ON ObjectLink_ReceiptProdModelChild_ReceiptProdModel.ChildObjectId = Object_ReceiptProdModel.Id
                                                        AND ObjectLink_ReceiptProdModelChild_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                   INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id       = ObjectLink_ReceiptProdModelChild_ReceiptProdModel.ObjectId
                                                                                    AND Object_ReceiptProdModelChild.isErased = FALSE
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_Object
                                                         ON ObjectLink_ReceiptProdModelChild_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                        AND ObjectLink_ReceiptProdModelChild_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()



                              WHERE Object_ReceiptProdModel.DescId   = zc_Object_ReceiptProdModelChild()
                                AND Object_ReceiptProdModel.isErased = FALSE

                             UNION ALL
                              -- Сборка узлов
                              SELECT ObjectLink_ReceiptGoodsChild_Object.ChildObjectId     AS GoodsId_from
                                   , ObjectLink_ReceiptGoods_Object.ChildObjectId          AS GoodsId_to
                                   , ObjectLink_ReceiptGoodsChild_GoodsChild.ChildObjectId AS GoodsId_child
                              FROM Object AS Object_ReceiptGoods
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                         ON ObjectLink_ReceiptGoods_Object.ObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_ReceiptGoods_Object.DescId   = zc_ObjectLink_ReceiptGoods_Object()

                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                                         ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                   INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                                                AND Object_ReceiptGoodsChild.isErased = FALSE
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_Object
                                                         ON ObjectLink_ReceiptGoodsChild_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                        AND ObjectLink_ReceiptGoodsChild_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()

                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_GoodsChild
                                                        ON ObjectLink_ReceiptGoodsChild_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_ReceiptGoodsChild_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()

                              WHERE Object_ReceiptGoods.DescId   = zc_Object_ReceiptGoods()
                                AND Object_ReceiptGoods.isErased = FALSE
                             )
         -- если Товар участвует в сборке
       , tmpReceiptGoods AS (-- Сборка Модели
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_from AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_from > 0
                             UNION
                              -- Сборка узлов
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_to AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_to > 0
                             )
         -- Опции
       , tmpProdOptions AS (SELECT DISTINCT ObjectLink_ProdOptions_Goods.ChildObjectId AS GoodsId
                            FROM Object AS Object_ProdOptions
                                 INNER JOIN ObjectLink AS ObjectLink_ProdOptions_Goods
                                                       ON ObjectLink_ProdOptions_Goods.ObjectId = Object_ProdOptions.Id
                                                      AND ObjectLink_ProdOptions_Goods.DescId   = zc_ObjectLink_ProdOptions_Goods()
                            WHERE Object_ProdOptions.DescId   = zc_Object_ProdOptions()
                              AND Object_ProdOptions.isErased = FALSE
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
                               , ObjectFloat_EKPrice.ValueData :: TFloat AS EKPrice

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
                         )
       -- партии
     , tmpMI_Child AS (SELECT MovementItem.ParentId
                            , SUM (MovementItem.Amount) AS Amount
                            , SUM (MovementItem.Amount * (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice)) AS TotalOperPrice
                            , STRING_AGG (COALESCE (Object_Partner.ValueData, ''), ';') AS PartnerName
                       FROM tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
                            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = Object_PartionGoods.FromId
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
              , MovementItem.PartNumber ::TVarChar

              , MovementItem.Amount           ::TFloat
              , tmpMI_Child.Amount            ::TFloat AS Amount_unit
              , CASE WHEN tmpMI_Child.Amount > 0
                     THEN tmpMI_Child.TotalOperPrice / tmpMI_Child.Amount
                     ELSE tmpGoodsParams.EKPrice
                END :: TFloat AS OperPrice
              , 1 ::TFloat AS CountForPrice

              , tmpMI_Child.TotalOperPrice :: TFloat AS TotalOperPrice

                --
              , tmpGoodsParams.EAN
              , tmpGoodsParams.Article
              , ObjectString_ArticleVergl.ValueData AS ArticleVergl
              , zfCalc_Article_all (COALESCE (tmpGoodsParams.Article, '') || '_' || COALESCE (ObjectString_ArticleVergl.ValueData, '')) ::TVarChar AS Article_all
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureName
              , Object_ProdColor.ValueData            AS ProdColorName
              , ObjectString_Goods_Comment.ValueData  AS Comment_goods

              , (NOT MovementItem.isErased) ::Boolean AS isOn
              , MovementItem.Comment    :: TVarChar   AS Comment
              , tmpMI_Child.PartnerName :: TVarChar   AS PartnerName

              , Movement_OrderClient.Id                                   AS MovementId_OrderClient
              , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) AS InvNumber_OrderClient
              , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
              , Movement_OrderClient.OperDate                             AS OperDate_OrderClient
              , Object_From.ValueData                      AS FromName
              , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
              , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN

              , MovementItem.PartionCellId   ::Integer
              , MovementItem.PartionCellCode ::Integer
              , MovementItem.PartionCellName ::TVarChar

              , MovementItem.InsertName
              , MovementItem.InsertDate

              , tmpProtocol.OperDate  AS OperDate_protocol
              , Object_User.ValueData AS UserName_protocol

              , ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) :: Integer AS Ord
                -- Сборка (да/нет) - Участвует в сборке Узла/Модели или в опциях
              , CASE WHEN tmpReceiptGoods.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods
                -- Опция (да/нет) - Участвует в опциях
              , CASE WHEN tmpProdOptions.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isProdOptions
                --
              , MovementItem.isErased

              , CASE WHEN COALESCE(MovementItem.Id, 0) = 0 THEN zc_Color_Blue() ELSE zc_Color_Black() END AS Color_Scan

            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId
                 -- если Товар участвует в сборке + Опции
                 LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = MovementItem.GoodsId
                 -- если Опции
                 LEFT JOIN tmpProdOptions ON tmpProdOptions.GoodsId = MovementItem.GoodsId

                 LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id

                 LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = MovementItem.Id
                                      AND tmpProtocol.Ord            = 1
                 LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId

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

                 LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                        ON ObjectString_ArticleVergl.ObjectId = Object_Goods.Id
                                       AND ObjectString_ArticleVergl.DescId = zc_ObjectString_ArticleVergl()
            ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.04.24                                                       *
 09.01.24         *
 15.12.22         *
 04.10.21         *
 16.09.21         * isOn
 06.04.21         * BasisPrice
 15.02.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Send (inMovementId:= 3214  , inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
