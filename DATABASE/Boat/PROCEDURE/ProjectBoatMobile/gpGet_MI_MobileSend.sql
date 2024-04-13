-- Function: gpGet_MI_MobileSend()

DROP FUNCTION IF EXISTS gpGet_MI_MobileSend (Integer, Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_MobileSend(
    IN inDetailId          Integer    , -- Ключ объекта <Строка сканирования>
    IN inGoodsId           Integer    , -- вариант когда вібирают товар из справочника
    IN inPartionCellId     Integer    , --
    IN inPartNumber        TVarChar   , --
    IN inAmount            TFloat     , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             , Article            TVarChar
             , PartNumber         TVarChar
             , GoodsGroupId       Integer
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName     TVarChar
             , PartnerId          Integer
             , PartnerName        TVarChar
             , PartionCellId      Integer
             , PartionCellName    TVarChar
             , Price              TFloat
             , Amount             TFloat
             , TotalCount         TFloat
             , AmountRemains      TFloat             
             , FromId             Integer
             , FromCode           Integer
             , FromName           TVarChar
             , ToId               Integer
             , ToCode             Integer
             , ToName             TVarChar
              )
AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbMovementId Integer;
  DECLARE vbGoodsId    Integer;
  DECLARE vbFromId     Integer;
  DECLARE vbToId       Integer;
  DECLARE vbOperDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     
     IF COALESCE (inDetailId, 0) = 0
     THEN
       vbMovementId := 0;
       vbFromId := 0;
       vbToId := 0;
       vbGoodsId := 0;
     ELSE
       SELECT MovementItem.MovementId
       INTO vbMovementId
       FROM MovementItem
       WHERE MovementItem.ID = inDetailId;

       -- Данные для остатков
       SELECT Movement.OperDate, Movement.ObjectId, MLO_From.ObjectId, MLO_To.ObjectId
       INTO vbOperDate, vbGoodsId, vbFromId, vbToId
       FROM Movement
            LEFT JOIN MovementLinkObject AS MLO_From
                                         ON MLO_From.MovementId = Movement.Id
                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MLO_To
                                         ON MLO_To.MovementId = Movement.Id
                                        AND MLO_To.DescId     = zc_MovementLinkObject_To()
       WHERE Movement.Id = vbMovementId;
     END IF;



     -- Результат
     RETURN QUERY
       WITH
       tmpRemains AS (SELECT Container.ObjectId                           AS GoodsId
                           , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                           , SUM (Container.Amount)                       AS Remains
                      FROM Container
                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                       AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                      WHERE Container.WhereObjectId = vbFromId
                        AND Container.DescId        = zc_Container_Count()
                        AND Container.ObjectId      = inGoodsId
                        AND COALESCE (MIString_PartNumber.ValueData, '') = COALESCE (inPartNumber,'')
                      GROUP BY Container.ObjectId
                             , COALESCE (MIString_PartNumber.ValueData, '')
                     )
          , tmpMI AS (SELECT MI.ObjectId                                   AS GoodsId
                           , COALESCE (MIString_PartNumber.ValueData, '')  AS PartNumber
                           , MAX(MILO_PartionCell.ObjectId)::Integer       AS PartionCellId      --сохраненый или переданный из шапки документа
                           , SUM (MI.Amount)                               AS Amount
                      FROM MovementItem AS MI
                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = MI.Id
                                                       AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

                           LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                            ON MILO_PartionCell.MovementItemId = MI.Id
                                                           AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()
                      WHERE MI.MovementId = vbMovementId
                        AND MI.DescId     = zc_MI_Master()
                        AND MI.ObjectId   = inGoodsId
                        AND MI.isErased   = FALSE
                        AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                      GROUP BY MI.ObjectId
                             , COALESCE (MIString_PartNumber.ValueData, '')
                     )
          , tmpMIDetail AS (SELECT MI.ObjectId                                      AS GoodsId
                                 , COALESCE (MIString_PartNumber.ValueData, '')     AS PartNumber
                                 , SUM (CASE WHEN MI.Id <> COALESCE(inDetailId, 0)
                                             THEN MI.Amount END)                    AS Amount
                                 , MAX(MI.Id)                                       AS MaxID  
                            FROM MovementItem AS MI
                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                                             AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

                            WHERE MI.MovementId = vbMovementId
                              AND MI.DescId     = zc_MI_Detail()
                              AND MI.ObjectId   = inGoodsId
                              AND MI.isErased   = FALSE
                              AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                            GROUP BY MI.ObjectId
                                   , COALESCE (MIString_PartNumber.ValueData, '')                                  
                           )
            -- все
          , tmpReceiptGoods AS (SELECT Object_ReceiptGoods_find_View.GoodsId
                                       -- это узел (да/нет)
                                     , Object_ReceiptGoods_find_View.isReceiptGoods_group
                                       -- все из чего собирается + узлы
                                     , Object_ReceiptGoods_find_View.isReceiptGoods
                                       -- Опция (да/нет) - Участвует в опциях
                                     , Object_ReceiptGoods_find_View.isProdOptions
                         
                                       -- в каком ОДНОМ Узле/Модель лодки Детали/узлы участвуют в сборке, т.е. что собирается
                                     , Object_ReceiptGoods_find_View.GoodsId_receipt
                                       -- в каком ОДНОМ Узле/Модель лодки Детали/узлы участвуют в сборке, т.е. что собирается
                                     , Object_ReceiptGoods_find_View.GoodsName_receipt
                                       -- в каких ВСЕХ Узлах/Моделях лодки Детали/узлы участвуют в сборке, т.е. что собирается
                                     , Object_ReceiptGoods_find_View.GoodsName_receipt_all
                         
                                       -- На каком участке происходит расход Узла/Детали на сборку
                                     , Object_ReceiptGoods_find_View.UnitId_receipt
                                     , Object_ReceiptGoods_find_View.UnitName_receipt
                                       -- На каком участке происходит расход Детали на сборку ПФ
                                     , Object_ReceiptGoods_find_View.UnitId_child_receipt
                                     , Object_ReceiptGoods_find_View.UnitName_child_receipt
                                       -- На каком участке происходит сборка Узла
                                     , Object_ReceiptGoods_find_View.UnitId_parent_receipt
                                     , Object_ReceiptGoods_find_View.UnitName_parent_receipt
              
                                FROM Object_ReceiptGoods_find_View
                                WHERE Object_ReceiptGoods_find_View.GoodsId = inGoodsId
                               )
          , tmpDate AS (SELECT Object_Goods.Id 
                             , Object_Goods.ObjectCode  
                             , Object_Goods.ValueData 

                             , CASE WHEN COALESCE (vbGoodsId, 0) = inGoodsId AND COALESCE(vbFromId, 0) <> 0 
                                         THEN vbFromId
                                    -- узел Стеклопластик + Опция
                                    WHEN tmpReceiptGoods.isReceiptGoods_group = TRUE AND tmpReceiptGoods.isProdOptions = TRUE
                                         -- Склад Основной
                                         THEN 35139

                                    -- Опция
                                    WHEN tmpReceiptGoods.isProdOptions = TRUE
                                         -- Склад Основной
                                         THEN 35139

                                    -- узел
                                    WHEN tmpReceiptGoods.isReceiptGoods_group = TRUE
                                         -- Склад Основной
                                         THEN 35139

                                    -- Деталь + НЕ Узел + есть Unit-ПФ
                                    WHEN tmpReceiptGoods.isReceiptGoods = TRUE AND tmpReceiptGoods.isReceiptGoods_group = FALSE AND tmpReceiptGoods.UnitName_child_receipt <> ''
                                         THEN tmpReceiptGoods.UnitId_child_receipt

                                    -- Участок сборки Hypalon
                                    WHEN tmpReceiptGoods.UnitId_receipt = 38875
                                         THEN tmpReceiptGoods.UnitId_receipt

                                    -- Участок UPHOLSTERY
                                    WHEN tmpReceiptGoods.UnitId_receipt = 253225
                                         THEN tmpReceiptGoods.UnitId_receipt

                                    -- Склад Основной
                                    ELSE 35139

                               END  :: Integer AS FromId
                             , COALESCE(CASE WHEN COALESCE (vbGoodsId, 0) = inGoodsId AND COALESCE(vbToId, 0) <> 0 THEN vbToId END
                                      , tmpReceiptGoods.UnitID_receipt
                                      , tmpReceiptGoods.UnitId_child_receipt
                                      , tmpReceiptGoods.UnitId_parent_receipt
                                      , 33347) AS ToId
                                
                         FROM Object AS Object_Goods

                              -- это
                              LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = Object_Goods.Id
                              
                         WHERE Object_Goods.Id = inGoodsId)
           
           
           SELECT Object_Goods.Id                             AS GoodsId
                , Object_Goods.ObjectCode                     AS GoodsCode
                , Object_Goods.ValueData                      AS GoodsName
                , ObjectString_Article.ValueData              AS Article
                , COALESCE (TRIM(inPartNumber),'') ::TVarChar AS PartNumber
                , Object_GoodsGroup.Id                        AS GoodsGroupId
                , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                , Object_GoodsGroup.ValueData                 AS GoodsGroupName
                , Object_Partner.Id                           AS PartnerId
                , Object_Partner.ValueData                    AS PartnerName
                , Object_PartionCell.Id                       AS PartionCellId
                , Object_PartionCell.ValueData                AS PartionCellName
                , (SELECT lpGet.ValuePrice FROM lpGet_MovementItem_PriceList (vbOperDate, inGoodsId, vbUserId) AS lpGet) :: TFloat  AS Price

                , COALESCE (inAmount, 1)                                          :: TFloat AS Amount
                , COALESCE (tmpMI.Amount, tmpMIDetail.Amount, 0)                  :: TFloat AS TotalCount
                , COALESCE (tmpRemains.Remains, 0)                                :: TFloat AS AmountRemains

                , Object_Goods.FromId
                , Object_From.ObjectCode                      AS FromCode
                , Object_From.ValueData                       AS FromName
                , Object_Goods.ToId
                , Object_ToId.ObjectCode                      AS ToCode
                , Object_ToId.ValueData                       AS ToName
                  
           FROM tmpDate AS Object_Goods
                LEFT JOIN tmpRemains ON tmpRemains.GoodsId    = Object_Goods.Id
                                    AND tmpRemains.PartNumber = COALESCE (inPartNumber,'')
                LEFT JOIN tmpMI ON tmpMI.GoodsId    = Object_Goods.Id
                               AND tmpMI.PartNumber = COALESCE (inPartNumber,'')
                LEFT JOIN tmpMIDetail ON tmpMIDetail.GoodsId    = Object_Goods.Id
                                     AND tmpMIDetail.PartNumber = COALESCE (inPartNumber,'')

                LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                 ON MILO_PartionCell.MovementItemId = COALESCE(NULLIF(inDetailId, 0), tmpMIDetail.MaxId)
                                                AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                     ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()

                LEFT JOIN Object AS Object_Partner    ON Object_Partner.Id    = ObjectLink_Goods_Partner.ChildObjectId
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                LEFT JOIN Object AS Object_From ON Object_From.Id = Object_Goods.FromId
                LEFT JOIN Object AS Object_ToId ON Object_ToId.Id = Object_Goods.ToId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = Object_Goods.Id
                                      AND ObjectString_Article.DescId = zc_ObjectString_Article()


                LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = COALESCE (tmpMI.PartionCellId, MILO_PartionCell.ObjectId, inPartionCellId)
                
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.03.24                                                       *
*/

-- тест
-- 

select * from gpGet_MI_MobileSend(inDetailId := 0, inGoodsId := 261920 , inPartionCellId := 0 , inPartNumber := '', inAmount := 1 ,  inSession := '5');