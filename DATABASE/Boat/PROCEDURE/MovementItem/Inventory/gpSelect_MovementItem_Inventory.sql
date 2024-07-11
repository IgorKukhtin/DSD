-- Function: gpSelect_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PartionId Integer--, IdBarCode TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, ArticleVergl TVarChar, Article_all TVarChar , EAN TVarChar 
             , GoodsGroupNameFull TVarChar, GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar
             , Amount TFloat, AmountScan TFloat, AmountRemains TFloat, AmountDiff TFloat, AmountRemains_curr TFloat
             , Price TFloat
             , Price_find TFloat
             , EKPrice TFloat
             , isPrice_diff Boolean, isPrice_goods Boolean
             , Summa TFloat
             , PartNumber TVarChar
             , Comment TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , OperDate_protocol TDateTime, UserName_protocol TVarChar
             , Ord Integer
             , isErased Boolean
             , MovementId_OrderClient Integer, InvNumber_OrderClient TVarChar, InvNumberFull_OrderClient TVarChar, OperDate_OrderClient TDateTime
             , FromName TVarChar, ProductName TVarChar, CIN TVarChar  
             , PartionCellId Integer, PartionCellCode Integer, PartionCellName TVarChar
           
               -- Сборка (да/нет) - Участвует в сборке Узла/Модели
             , isReceiptGoods Boolean
               -- Опция (да/нет) - Участвует в опциях
             , isProdOptions Boolean
               --
             , isNotMaster   Boolean
             , isDiffAmount  Boolean
             , Amount_master TFloat
             , Amount_scan   TFloat

             , Color_Scan Integer
              )
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbUnitId   Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Данные для остатков
     SELECT Movement.OperDate, Movement.StatusId, MLO_Unit.ObjectId
            INTO vbOperDate, vbStatusId, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = inMovementId
                                      AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId;


     -- Результат такой
     RETURN QUERY
       WITH tmpMIScan AS (SELECT MAX (MovementItem.Id) AS MovementItemId_max
                               , MovementItem.ObjectId AS GoodsId
                               , SUM(MovementItem.Amount)::TFloat             AS Amount
                               , MAX (COALESCE (MIFloat_Price.ValueData, 0))  AS Price
                               , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                          FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                               JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                AND MovementItem.DescId     = zc_MI_Scan()
                                                AND MovementItem.isErased   = tmpIsErased.isErased

                               LEFT JOIN MovementItemString AS MIString_PartNumber
                                                            ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                           AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                               
                          GROUP BY MovementItem.ObjectId
                                 , COALESCE (MIString_PartNumber.ValueData, '')
                         )
          , tmpMIMaster AS (SELECT MovementItem.Id
                                 , MovementItem.ObjectId AS GoodsId
                                 , MovementItem.PartionId
                                 , MovementItem.Amount
                                 , COALESCE (MIFloat_Price.ValueData, 0)        AS Price
                                 , COALESCE (MIString_Comment.ValueData,'')     AS Comment
                                 , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                                 , MILinkObject_Partner.ObjectId                AS PartnerId
                                 , MILO_PartionCell.ObjectId                    AS PartionCellId
                                 , MovementItem.isErased
                                 , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                 JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = tmpIsErased.isErased
                                 LEFT JOIN MovementItemString AS MIString_Comment
                                                              ON MIString_Comment.MovementItemId = MovementItem.Id
                                                             AND MIString_Comment.DescId = zc_MIString_Comment()
                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                                  ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()

                                LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                            ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                           AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

                                LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                                 ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                                                AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()
                           )
                           
          , tmpMI AS (SELECT COALESCE (tmpMIMaster.Id, tmpMIScan.MovementItemId_max)      AS Id
                           , COALESCE(tmpMIMaster.GoodsId, tmpMIScan.GoodsId)             AS GoodsId
                           , tmpMIMaster.PartionId
                           , COALESCE(tmpMIMaster.Amount, tmpMIScan.Amount)               AS Amount
                           , tmpMIScan.Amount                                             AS AmountScan
                           , COALESCE(tmpMIMaster.Price, tmpMIScan.Price)                 AS Price
                           , tmpMIMaster.Comment
                           , COALESCE(tmpMIMaster.PartNumber, tmpMIScan.PartNumber)       AS PartNumber
                           , tmpMIMaster.PartnerId
                           , COALESCE(tmpMIMaster.PartionCellId, MILO_PartionCell.ObjectId) AS PartionCellId
                           , tmpMIMaster.isErased
                           , tmpMIMaster.MovementId_OrderClient
                           , CASE WHEN tmpMIMaster.Id IS NULL THEN TRUE ELSE FALSE END AS isNotMaster
                           , CASE WHEN COALESCE (tmpMIMaster.Amount, 0) <> COALESCE(tmpMIScan.Amount, 0) THEN TRUE ELSE FALSE END AS isDiffAmount
                           , tmpMIMaster.Amount AS Amount_master
                           , tmpMIScan.Amount   AS Amount_scan
                      FROM tmpMIMaster
                      
                           FULL JOIN tmpMIScan ON tmpMIScan.GoodsId    = tmpMIMaster.GoodsId
                                              AND tmpMIScan.PartNumber = tmpMIMaster.PartNumber

                           LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                            ON MILO_PartionCell.MovementItemId = tmpMIScan.MovementItemId_max
                                                           AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()
                      )
                     
          , tmpPL AS (SELECT Movement.Id            AS MovementId
                           , Movement.OperDate      AS OperDate
                           , MLO_Partner.ObjectId   AS PartnerId
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MLO_Partner
                                                         ON MLO_Partner.MovementId = Movement.Id
                                                        AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                                                        -- если надо по поставщику
                                                        --AND MLO_Partner.ObjectId   IN (SELECT DISTINCT tmpMI.PartnerId FROM tmpMI)
                      WHERE Movement.OperDate BETWEEN DATE_TRUNC ('YEAR', vbOperDate - INTERVAL '24 MONTH') AND vbOperDate
                        AND Movement.DescId    = zc_Movement_PriceList()
                        AND Movement.StatusId  = zc_Enum_Status_Complete()
                     )
     , tmpPL_item AS (SELECT tmp.MovementId
                           , tmp.OperDate
                           , tmp.PartnerId
                           , tmp.GoodsId
                           , tmp.ValuePrice
                           , tmp.Ord
                           , tmp.Ord_partner
                      FROM (SELECT tmpPL.MovementId
                                 , tmpPL.OperDate
                                 , tmpPL.PartnerId
                                 , MovementItem.ObjectId  AS GoodsId
                                 , MovementItem.Amount    AS ValuePrice
                                   -- № п/п
                                 , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY tmpPL.OperDate DESC, tmpPL.MovementId DESC) AS Ord
                                   -- № п/п
                                 , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, tmpPL.PartnerId ORDER BY tmpPL.OperDate DESC, tmpPL.MovementId DESC) AS Ord_partner
                            FROM tmpPL
                                 INNER JOIN MovementItem ON MovementItem.MovementId = tmpPL.MovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                                        AND MovementItem.Amount     <> 0
                                 INNER JOIN tmpMI ON tmpMI.GoodsId = MovementItem.ObjectId
                           ) AS tmp
                      WHERE tmp.Ord = 1 OR tmp.Ord_partner = 1
                     )
     , tmpRemains AS (SELECT Container.Id       AS ContainerId
                           , Container.ObjectId AS GoodsId
                           , Container.Amount
                           , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                                         THEN COALESCE (MIContainer.Amount, 0)
                                                                    WHEN MIContainer.OperDate > vbOperDate
                                                                         THEN COALESCE (MIContainer.Amount, 0)
                                                                    ELSE 0
                                                               END)
                                                        , 0) AS Remains
                           , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                      FROM Container
                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                       AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                           LEFT JOIN MovementItemContainer AS MIContainer
                                                           ON MIContainer.ContainerId =  Container.Id
                                                          AND MIContainer.OperDate    >= vbOperDate
                                                          AND vbStatusId              =  zc_Enum_Status_Complete()
                      WHERE Container.WhereObjectId = vbUnitId
                        AND Container.DescId        = zc_Container_Count()
                        AND Container.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                      GROUP BY Container.Id
                             , Container.ObjectId
                             , Container.Amount
                             , COALESCE (MIString_PartNumber.ValueData, '')
                      HAVING Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                                         THEN COALESCE (MIContainer.Amount, 0)
                                                                    WHEN MIContainer.OperDate > vbOperDate
                                                                         THEN COALESCE (MIContainer.Amount, 0)
                                                                    ELSE 0
                                                               END)
                                                        , 0) <> 0
                          OR Container.Amount <> 0
                     )
     , tmpMIContainer AS (SELECT MIContainer.MovementItemId
                               , STRING_AGG (COALESCE (Object_Partner.ValueData, MIContainer.PartionId :: TVarChar, 'нет партии'), ';') AS PartnerName
                          FROM MovementItemContainer AS MIContainer
                               LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId  = MIContainer.PartionId
                               LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = Object_PartionGoods.FromId
                          WHERE MIContainer.MovementId = inMovementId
                            AND MIContainer.DescId     = zc_MIContainer_Count()
                          GROUP BY MIContainer.MovementItemId
                         )
        , tmpProtocol AS (SELECT MovementItemProtocol.*
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate DESC) AS Ord
                          FROM MovementItemProtocol
                          WHERE MovementItemProtocol.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
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
                                     -- узел
                                   , ObjectLink_ReceiptGoods_Object.ChildObjectId          AS GoodsId_to
                                     -- узел - ПФ
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

         -- если Сборка
       , tmpReceiptGoods AS (-- Сборка Модели + Узлов
                             SELECT DISTINCT tmpReceiptGoods_all.GoodsId_from AS GoodsId
                             FROM tmpReceiptGoods_all
                             WHERE tmpReceiptGoods_all.GoodsId_from > 0
                            UNION
                             -- Узлы
                             SELECT DISTINCT tmpReceiptGoods_all.GoodsId_to AS GoodsId
                             FROM tmpReceiptGoods_all
                             WHERE tmpReceiptGoods_all.GoodsId_to > 0
                            UNION
                             -- Узлы - ПФ
                             SELECT DISTINCT tmpReceiptGoods_all.GoodsId_child AS GoodsId
                             FROM tmpReceiptGoods_all
                             WHERE tmpReceiptGoods_all.GoodsId_child > 0
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

       -- Результат
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           --, zfFormat_BarCode (zc_BarCodePref_Object(), ObjectString_EAN.ValueData) AS IdBarCode
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , CASE WHEN Object_Goods.isErased = TRUE THEN '***удален ' || Object_Goods.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
           , ObjectString_Article.ValueData      AS Article 
           , ObjectString_ArticleVergl.ValueData AS ArticleVergl 
           , zfCalc_Article_all (COALESCE (ObjectString_Article.ValueData, '') || '_' || COALESCE (ObjectString_ArticleVergl.ValueData, '')) AS Article_all
           , ObjectString_EAN.ValueData          AS EAN
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.Id                        AS GoodsGroupId
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , Object_Measure.ValueData                    AS MeasureName

           , tmpMI.Amount                                               AS Amount
           , tmpMI.AmountScan                                           AS AmountScan
           , tmpRemains.Remains                                ::TFloat AS AmountRemains
           , (tmpMI.Amount - COALESCE (tmpRemains.Remains, 0)) ::TFloat AS AmountDiff
           , tmpRemains.Amount                                 ::TFloat AS AmountRemains_curr
             -- цена вх.
           , tmpMI.Price                                             ::TFloat AS Price
             -- найдена цена вх. в прайсах
           , COALESCE (tmpPL_item.ValuePrice, tmpPL_item_all.ValuePrice) ::TFloat AS Price_find
             -- цена вх. - товар
           , ObjectFloat_Goods_EKPrice.ValueData ::TFloat AS EKPrice
             -- другой поставщик
           , CASE WHEN tmpPL_item.GoodsId IS NULL AND tmpPL_item_all.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPrice_diff
             -- из товара
           , CASE WHEN tmpPL_item.GoodsId IS NULL AND tmpPL_item_all.GoodsId IS NULL AND ObjectFloat_Goods_EKPrice.ValueData > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPrice_goods

           , (tmpMI.Amount * tmpMI.Price) ::TFloat AS Summa

           , tmpMI.PartNumber             ::TVarChar
           , tmpMI.Comment                ::TVarChar

           , Object_Partner.Id                           AS PartnerId
           , COALESCE (Object_Partner.ValueData, '***' || tmpMIContainer.PartnerName) :: TVarChar AS PartnerName

           , tmpProtocol.OperDate  AS OperDate_protocol
           , Object_User.ValueData AS UserName_protocol

           , ROW_NUMBER() OVER (ORDER BY tmpMI.Id ASC) :: Integer AS Ord
           , tmpMI.isErased
           
           , Movement_OrderClient.Id                                   AS MovementId_OrderClient
           , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) :: TVarChar AS InvNumber_OrderClient
           , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
           , Movement_OrderClient.OperDate                             AS OperDate_OrderClient
           , Object_From.ValueData                      AS FromName 
           , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
           , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN

           , Object_PartionCell.Id         ::Integer  AS PartionCellId
           , Object_PartionCell.ObjectCode ::Integer  AS PartionCellCode
           , Object_PartionCell.ValueData  ::TVarChar AS PartionCellName
           
             -- Сборка (да/нет) - Участвует в сборке Узла/Модели
           , CASE WHEN tmpReceiptGoods.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods
               -- Опция (да/нет) - Участвует в опциях
           , CASE WHEN tmpProdOptions.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isProdOptions

           , tmpMI.isNotMaster   :: Boolean
           , tmpMI.isDiffAmount  :: Boolean
           , tmpMI.Amount_master :: TFloat
           , tmpMI.Amount_scan   :: TFloat

           , CASE WHEN COALESCE(tmpMI.Id, 0) = 0 THEN zc_Color_Blue() ELSE zc_Color_Black() END AS Color_Scan

       FROM tmpMI

            LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = tmpMI.GoodsId
            LEFT JOIN tmpProdOptions ON tmpProdOptions.GoodsId = tmpMI.GoodsId

            LEFT JOIN tmpPL_item ON tmpPL_item.GoodsId     = tmpMI.GoodsId
                                AND tmpPL_item.PartnerId   = tmpMI.PartnerId
                                AND tmpPL_item.Ord_partner = 1
            LEFT JOIN tmpPL_item AS tmpPL_item_all
                                 ON tmpPL_item_all.GoodsId     = tmpMI.GoodsId
                                AND tmpPL_item_all.Ord_partner = 1

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = tmpMI.PartionCellId

            LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpMI.Id
                                 AND tmpProtocol.Ord            = 1
            LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId

            LEFT JOIN ObjectLink AS OL_Goods_GoodsGroup
                                 ON OL_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id  = OL_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS OL_Goods_Measure
                                 ON OL_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_EKPrice
                                  ON ObjectFloat_Goods_EKPrice.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Goods_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                   ON ObjectString_ArticleVergl.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_ArticleVergl.DescId   = zc_ObjectString_ArticleVergl()
            LEFT JOIN ObjectString AS ObjectString_EAN
                                   ON ObjectString_EAN.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_EAN.DescId   = zc_ObjectString_EAN()
            LEFT JOIN (SELECT tmpRemains.GoodsId, tmpRemains.PartNumber, SUM (tmpRemains.Amount) AS Amount, SUM (tmpRemains.Remains) AS Remains
                       FROM tmpRemains
                       GROUP BY tmpRemains.GoodsId, tmpRemains.PartNumber
                      ) AS tmpRemains ON tmpRemains.GoodsId    = tmpMI.GoodsId
                                     AND tmpRemains.PartNumber = tmpMI.PartNumber

            LEFT JOIN ObjectLink AS OL_Goods_Partner
                                 ON OL_Goods_Partner.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()

            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId  = tmpMI.Id  
            
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = COALESCE (tmpMI.PartnerId, Object_PartionGoods.FromId, OL_Goods_Partner.ChildObjectId)

            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = tmpMI.Id

            LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = tmpMI.MovementId_OrderClient
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
            
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.03.24                                                       *
 08.01.24         *
 17.02.22         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId := 3179 , inIsErased := 'False' ,  inSession := zfCalc_UserAdmin());
