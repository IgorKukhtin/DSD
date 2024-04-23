-- Function: gpGet_MI_MobileInventory()

DROP FUNCTION IF EXISTS gpGet_MI_MobileInventory (Integer, Integer, Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_MobileInventory(
    IN inMovementId        Integer    , -- Ключ объекта <Документ>
    IN inScanId            Integer    , -- Ключ объекта <Строка сканирования>
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
              )
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbUnitId   Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Данные для остатков
     SELECT Movement.OperDate, MLO_Unit.ObjectId
            INTO vbOperDate, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = inMovementId
                                      AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId;


     -- Результат
     RETURN QUERY
       WITH
       tmpRemains AS (SELECT Container.ObjectId                           AS GoodsId
                           --, COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                           , SUM (Container.Amount)                       AS Remains
                      FROM Container
                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                       AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                      WHERE Container.WhereObjectId = vbUnitId
                        AND Container.DescId        = zc_Container_Count()
                        AND Container.ObjectId      = inGoodsId
                        --AND COALESCE (MIString_PartNumber.ValueData, '') = COALESCE (inPartNumber,'')
                      GROUP BY Container.ObjectId
                             --, COALESCE (MIString_PartNumber.ValueData, '')
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
                      WHERE MI.MovementId = inMovementId
                        AND MI.DescId     = zc_MI_Master()
                        AND MI.ObjectId   = inGoodsId
                        AND MI.isErased   = FALSE
                        AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                      GROUP BY MI.ObjectId
                             , COALESCE (MIString_PartNumber.ValueData, '')
                     )
          , tmpMIScan AS (SELECT MI.ObjectId                                      AS GoodsId
                                 , COALESCE (MIString_PartNumber.ValueData, '')     AS PartNumber
                                 , SUM (CASE WHEN MI.Id <> COALESCE(inScanId, 0)
                                             THEN MI.Amount END)                    AS Amount
                                 , MAX(MI.Id)                                       AS MaxID  
                            FROM MovementItem AS MI
                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                                             AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

                            WHERE MI.MovementId = inMovementId
                              AND MI.DescId     = zc_MI_Scan()
                              AND MI.ObjectId   = inGoodsId
                              AND MI.isErased   = FALSE
                              AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                            GROUP BY MI.ObjectId
                                   , COALESCE (MIString_PartNumber.ValueData, '')                                  
                           )

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
                , COALESCE (tmpMI.Amount, tmpMIScan.Amount, 0)                    :: TFloat AS TotalCount
                , COALESCE (tmpRemains.Remains, 0)                                :: TFloat AS AmountRemains


           FROM Object AS Object_Goods
                LEFT JOIN tmpRemains ON tmpRemains.GoodsId    = Object_Goods.Id
                                    --AND tmpRemains.PartNumber = COALESCE (inPartNumber,'')
                LEFT JOIN tmpMI ON tmpMI.GoodsId    = Object_Goods.Id
                               AND tmpMI.PartNumber = COALESCE (inPartNumber,'')
                LEFT JOIN tmpMIScan ON tmpMIScan.GoodsId    = Object_Goods.Id
                                     AND tmpMIScan.PartNumber = COALESCE (inPartNumber,'')

                LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                 ON MILO_PartionCell.MovementItemId = COALESCE(NULLIF(inScanId, 0), tmpMIScan.MaxId)
                                                AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                     ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()

                LEFT JOIN Object AS Object_Partner    ON Object_Partner.Id    = ObjectLink_Goods_Partner.ChildObjectId
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = Object_Goods.Id
                                      AND ObjectString_Article.DescId = zc_ObjectString_Article()


                LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = COALESCE (tmpMI.PartionCellId, MILO_PartionCell.ObjectId, inPartionCellId)
                
           WHERE Object_Goods.Id = inGoodsId
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
-- select * from gpGet_MI_MobileInventory(inMovementId := 3179 , inScanId := 0, inGoodsId := 261920 , inPartionCellId := 0 , inPartNumber := '', inAmount := 1 ,  inSession := '5');