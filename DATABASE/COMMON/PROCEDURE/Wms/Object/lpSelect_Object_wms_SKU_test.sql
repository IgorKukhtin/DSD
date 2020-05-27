-- Function: lpSelect_Object_wms_SKU_test()
-- 4.1.1.1 Справочник товаров <sku>

DROP FUNCTION IF EXISTS lpSelect_Object_wms_SKU_test ();

CREATE OR REPLACE FUNCTION lpSelect_Object_wms_SKU_test(
)
RETURNS TABLE (ObjectId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsTypeKindId Integer, GoodsTypeKindCode Integer, GoodsTypeKindName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , MeasureId Integer, MeasureName TVarChar
               -- Вес 1-ой ед.
             , WeightMin TFloat
             , WeightMax TFloat
             , WeightAvg TFloat
               -- размеры 1-ой ед.
             , Height    TFloat
             , Length    TFloat
             , Width     TFloat
               -- Ящик (E2/E3)
             , GoodsPropertyBoxId Integer
             , BoxId Integer, BoxCode Integer, BoxName TVarChar
             , WeightOnBox    TFloat -- Кол-во кг. в ящ. (E2/E3)
             , CountOnBox     TFloat -- Кол-во ед. в ящ. (E2/E3)
             , BoxVolume      TFloat -- Объем ящ., м3. (E2/E3)
             , BoxWeight      TFloat -- Вес самогно ящ. (E2/E3)
             , BoxHeight      TFloat -- Высота ящ. (E2/E3)
             , BoxLength      TFloat -- Длина ящ. (E2/E3)
             , BoxWidth       TFloat -- Ширина ящ. (E2/E3)
             , WeightGross    TFloat -- Вес брутто полного ящика "по ???" (E2/E3)
             , WeightAvgGross TFloat -- Вес брутто полного ящика "по среднему весу" (E2/E3)
             , WeightAvgNet   TFloat -- Вес нетто полного ящика "по среднему весу" (E2/E3)
             , WeightMaxGross TFloat -- Вес брутто полного ящика "по МАКСИМАЛЬНОМУ весу" (E2/E3)
             , WeightMaxNet   TFloat -- Вес нетто полного ящика "по МАКСИМАЛЬНОМУ весу" (E2/E3)

             , sku_id       Integer  -- ***Уникальный код товара в товарном справочнике предприятия
             , sku_code     Integer  -- Уникальный, человеко-читаемый код товара для отображения в экранных формах.
             , name         TVarChar -- Наименование товара в товарном справочнике предприятия
             , product_life Integer  -- Срок годности товара в сутках.

             , MovementId   Integer
             , InvNumber    TVarChar
             , OperDate     TDateTime
             , OperDatePartner_sale TDateTime
             , FromId       Integer
             , DescId_from  Integer
             , FromName     TVarChar
             , Amount_Order TFloat
              )
AS
$BODY$
BEGIN

     -- Результат
     RETURN QUERY
        WITH tmpGoods AS (SELECT *
                          FROM lpSelect_wms_Object_SKU() AS tmp
                          WHERE -- !!!Есть Ящик!!!
                                tmp.GoodsPropertyBoxId > 0
                                -- !!!Есть Вес!!!
                            AND tmp.WeightMin > 0 AND tmp.WeightMax > 0
                                -- Доходы + Продукция + Тушенка
                            AND tmp.InfoMoneyId <> zc_Enum_InfoMoney_30102()  
                         -- AND tmp.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves()
                            AND tmp.sku_id IN (27154672, 27154682)
                         -- AND tmp.sku_code     :: Integer  -- Уникальный, человеко-читаемый код товара для отображения в экранных формах.
                         )
            -- этим покупателям ставим лучшую Категорию
          , tmpPartnerTag AS (SELECT Object.Id AS PartnerTagId
                                -- , zc_Enum_GoodsTypeKind_Nom() AS GoodsTypeKind
                              FROM Object
                              WHERE Object.DescId = zc_Object_PartnerTag()
                                AND Object.Id IN (/*310821 -- 1;"експорт"
                                              , 310822 -- 2;"роздрібна мережа";f
                                                , 310823 -- 3;"HoReCa";f
                                                , 310824 -- 4;"супермаркет";f
                                                , 310825 -- 5;"тендери";f
                                              , */310826 -- 6;"роздрібна торгівля";f
                                              , 310827 -- 7;"дистриб`ютор";f
                                                 )
                             )
        , tmpMovement_all AS (SELECT Movement.Id                                       AS MovementId
                                   , Movement.OperDate                                 AS OperDate
                                   , Movement.InvNumber                                AS InvNumber
                                   , (MovementDate_OperDatePartner.ValueData + (COALESCE (ObjectFloat_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner_sale
                                   , COALESCE (MovementLinkObject_From.ObjectId, 0)    AS FromId
                                   , COALESCE (Object_From.DescId, 0)                  AS DescId_from
                                   , COALESCE (Object_From.ValueData, '')              AS FromName
                                   , COALESCE (MovementString_Comment.ValueData, '')   AS Comment
                                   , MovementItem.Id                                   AS MovementItemId
                                   , MovementItem.ObjectId                             AS GoodsId
                                   , MILO_GoodsKind.ObjectId                           AS GoodsKindId
                                   , OL_Goods_Measure.ChildObjectId                    AS MeasureId
                                   , MovementItem.Amount + COALESCE (MIF_AmountSecond.ValueData, 0) AS Amount
                                 --, 1 AS Amount
                                     -- расчетная Категорию -некоторым ставим лучшую 
                                   , CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                           AND tmpPartnerTag.PartnerTagId > 0
                                               THEN zc_Enum_GoodsTypeKind_Sh()
                                          WHEN tmpPartnerTag.PartnerTagId > 0
                                               THEN zc_Enum_GoodsTypeKind_Nom()
                                          ELSE zc_Enum_GoodsTypeKind_Ves()
                                     END AS GoodsTypeKindId_calc
                                   , tmpPartnerTag.PartnerTagId AS PartnerTagId_find
                                -- , COALESCE (OL_Partner_Juridical.ChildObjectId, 0)  AS JuridicalId
                                     -- № п/п
                                   , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId
                                                                   , MILO_GoodsKind.ObjectId
                                                                   , CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                           AND tmpPartnerTag.PartnerTagId > 0
                                                                               THEN zc_Enum_GoodsTypeKind_Sh()
                                                                          WHEN tmpPartnerTag.PartnerTagId > 0
                                                                               THEN zc_Enum_GoodsTypeKind_Nom()
                                                                          ELSE zc_Enum_GoodsTypeKind_Ves()
                                                                     END
                                                        ORDER BY MovementItem.Amount + COALESCE (MIF_AmountSecond.ValueData, 0) ASC
                                                       ) AS Ord
                             FROM Movement
                                  LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                         ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                        AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                  LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                  LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount
                                                        ON ObjectFloat_DocumentDayCount.ObjectId = MovementLinkObject_From.ObjectId
                                                       AND ObjectFloat_DocumentDayCount.DescId   = zc_ObjectFloat_Partner_DocumentDayCount()
                                  LEFT JOIN ObjectLink AS OL_Partner_PartnerTag
                                                       ON OL_Partner_PartnerTag.ObjectId = MovementLinkObject_From.ObjectId
                                                      AND OL_Partner_PartnerTag.DescId   = zc_ObjectLink_Partner_PartnerTag()
                                --LEFT JOIN ObjectLink AS OL_Partner_Juridical
                                --                     ON OL_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                --                    AND OL_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                  LEFT JOIN MovementString AS MovementString_Comment
                                                           ON MovementString_Comment.MovementId = Movement.Id
                                                          AND MovementString_Comment.DescId     = zc_MovementString_Comment()
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                       -- AND MovementItem.Amount     > 0
                                                         AND MovementItem.isErased   = FALSE
                                  LEFT JOIN ObjectLink AS OL_Goods_Measure
                                                       ON OL_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                      AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                                  LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                   ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN MovementItemFloat AS MIF_AmountSecond
                                                              ON MIF_AmountSecond.MovementItemId = MovementItem.Id
                                                             AND MIF_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                                  LEFT JOIN tmpPartnerTag ON tmpPartnerTag.PartnerTagId = OL_Partner_PartnerTag.ChildObjectId

                                  INNER JOIN tmpGoods ON tmpGoods.GoodsId     = MovementItem.ObjectId
                                                     AND tmpGoods.GoodsKindId = MILO_GoodsKind.ObjectId

                             WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '12 DAY' AND CURRENT_DATE - INTERVAL '1 DAY'
                               AND Movement.DescId   = zc_Movement_OrderExternal()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND MovementLinkObject_To.ObjectId = 8459 -- Склад Реализации
                             --AND Movement.InvNumber IN ('980741') -- 952893
                               AND MovementItem.Amount + COALESCE (MIF_AmountSecond.ValueData, 0) > 0
                               AND MovementItem.Amount + COALESCE (MIF_AmountSecond.ValueData, 0) <= 50
                               -- Способ обработки заказа (может быть пустое): Оптовый
                             --AND tmpPartnerTag.PartnerTagId > 0
                            )
        , tmpRes_goods AS (SELECT tmpGoods.GoodsId, tmpGoods.GoodsKindId
                           FROM tmpGoods
                                LEFT JOIN tmpMovement_all ON tmpMovement_all.GoodsId               = tmpGoods.GoodsId
                                                         AND tmpMovement_all.GoodsKindId          = tmpGoods.GoodsKindId
                                                         -- расчетная Категория - некоторым ставим лучшую 
                                                         AND tmpMovement_all.GoodsTypeKindId_calc = tmpGoods.GoodsTypeKindId
                                                         -- только 1-ый с миним. кол-вом
                                                         AND tmpMovement_all.Ord                  = 1
                                LEFT JOIN tmpMovement_all AS tmpMovement_all_find_1
                                                          ON tmpMovement_all_find_1.GoodsId              = tmpGoods.GoodsId
                                                         AND tmpMovement_all_find_1.GoodsKindId          = tmpGoods.GoodsKindId
                                                         -- расчетная Категория - некоторым ставим лучшую 
                                                         AND CASE WHEN tmpMovement_all_find_1.GoodsTypeKindId_calc = zc_Enum_GoodsTypeKind_Ves()
                                                                       THEN zc_Enum_GoodsTypeKind_Nom()
                                                                  WHEN tmpMovement_all_find_1.GoodsTypeKindId_calc = zc_Enum_GoodsTypeKind_Nom()
                                                                       THEN zc_Enum_GoodsTypeKind_Sh()
                                                             END = tmpGoods.GoodsTypeKindId
                                                         -- только 1-ый с миним. кол-вом
                                                         AND tmpMovement_all_find_1.Ord                  = 1
                                                         --
                                                         AND tmpMovement_all.GoodsId IS NULL
                                LEFT JOIN tmpMovement_all AS tmpMovement_all_find_2
                                                          ON tmpMovement_all_find_2.GoodsId              = tmpGoods.GoodsId
                                                         AND tmpMovement_all_find_2.GoodsKindId          = tmpGoods.GoodsKindId
                                                         -- расчетная Категория - некоторым ставим лучшую 
                                                         AND CASE WHEN tmpMovement_all_find_2.GoodsTypeKindId_calc = zc_Enum_GoodsTypeKind_Ves()
                                                                       THEN zc_Enum_GoodsTypeKind_Sh()
                                                             END = tmpGoods.GoodsTypeKindId
                                                         -- только 1-ый с миним. кол-вом
                                                         AND tmpMovement_all_find_2.Ord                  = 1
                                                         --
                                                         AND tmpMovement_all.GoodsId        IS NULL
                                                         AND tmpMovement_all_find_1.GoodsId IS NULL

                           WHERE COALESCE (tmpMovement_all.GoodsId, tmpMovement_all_find_1.GoodsId, tmpMovement_all_find_2.GoodsId) > 0
                           ORDER BY COALESCE (tmpMovement_all.Amount, tmpMovement_all_find_1.Amount, tmpMovement_all_find_2.Amount) DESC, tmpGoods.GoodsId, tmpGoods.GoodsKindId
                           LIMIT 10
                          )
          , tmpRes_mov AS (SELECT DISTINCT tmpMovement_all.MovementId
                           FROM tmpRes_goods AS tmpGoods
                                INNER JOIN tmpMovement_all ON tmpMovement_all.GoodsId              = tmpGoods.GoodsId
                                                          AND tmpMovement_all.GoodsKindId          = tmpGoods.GoodsKindId
                                                          -- расчетная Категория - некоторым ставим лучшую 
                                                        --AND tmpMovement_all.GoodsTypeKindId_calc = tmpGoods.GoodsTypeKindId
                           ORDER BY 1
                           LIMIT 2
                          )
        -- Результат
        SELECT DISTINCT
               tmpGoods.ObjectId
             , tmpGoods.GoodsId, tmpGoods.GoodsCode, tmpGoods.GoodsName
             , tmpGoods.GoodsKindId, tmpGoods.GoodsKindCode, tmpGoods.GoodsKindName
             , tmpGoods.GoodsTypeKindId, tmpGoods.GoodsTypeKindCode, tmpGoods.GoodsTypeKindName
             , tmpGoods.GoodsGroupId, tmpGoods.GoodsGroupName, tmpGoods.GoodsGroupNameFull
             , tmpGoods.MeasureId, tmpGoods.MeasureName

               -- Вес 1-ой ед.
             , tmpGoods.WeightMin
             , tmpGoods.WeightMax
             , tmpGoods.WeightAvg
               -- размеры 1-ой ед.
             , tmpGoods.Height
             , tmpGoods.Length
             , tmpGoods.Width

               -- Ящик (E2/E3)
             , tmpGoods.GoodsPropertyBoxId
             , tmpGoods.BoxId, tmpGoods.BoxCode, tmpGoods.BoxName

               -- *заменили - Кол-во кг. в ящ. (E2/E3) - тоже что и WeightAvgNet
             , tmpGoods.WeightOnBox

             , tmpGoods.CountOnBox               -- Кол-во ед. в ящ. (E2/E3)
             , tmpGoods.BoxVolume                -- Объем ящ., м3. (E2/E3)
             , tmpGoods.BoxWeight                -- Вес самого ящ. (E2/E3)
             , tmpGoods.BoxHeight                -- Высота ящ. (E2/E3)
             , tmpGoods.BoxLength                -- Длина ящ. (E2/E3)
             , tmpGoods.BoxWidth                 -- Ширина ящ. (E2/E3)

               -- *заменили - Вес брутто полного ящика "??? по среднему весу" (E2/E3)
             , tmpGoods.WeightGross

               -- *заменили - Вес брутто полного ящика "по среднему весу" (E2/E3)
             , tmpGoods.WeightAvgGross

               -- *заменили - Вес нетто полного ящика "по среднему весу" (E2/E3) - тоже что и WeightOnBox
             , tmpGoods.WeightAvgNet

               -- ***заменили - Вес брутто полного ящика "по МАКСИМАЛЬНОМУ весу" (E2/E3)
             , tmpGoods.WeightMaxGross

               -- ***заменили - Вес нетто полного ящика "по МАКСИМАЛЬНОМУ весу" (E2/E3) - тоже что и WeightOnBox
             , tmpGoods.WeightMaxNet

             , tmpGoods.sku_id       :: Integer  -- ***Уникальный код товара в товарном справочнике предприятия
             , tmpGoods.sku_code     :: Integer  -- Уникальный, человеко-читаемый код товара для отображения в экранных формах.
             , tmpGoods.name         :: TVarChar -- Наименование товара в товарном справочнике предприятия
             , tmpGoods.product_life :: Integer  -- Срок годности товара в сутках.

             , tmpMovement_all.MovementId
             , tmpMovement_all.InvNumber
             , tmpMovement_all.OperDate             :: TDateTime
             , tmpMovement_all.OperDatePartner_sale :: TDateTime
             , tmpMovement_all.FromId               :: Integer
             , tmpMovement_all.DescId_from          :: Integer
             , tmpMovement_all.FromName             :: TVarChar
             , tmpMovement_all.Amount               :: TFloat

        FROM tmpGoods
             INNER JOIN tmpMovement_all ON tmpMovement_all.GoodsId     = tmpGoods.GoodsId
                                       AND tmpMovement_all.GoodsKindId = tmpGoods.GoodsKindId
             INNER JOIN tmpRes_goods ON tmpRes_goods.GoodsId     = tmpMovement_all.GoodsId
                                    AND tmpRes_goods.GoodsKindId = tmpMovement_all.GoodsKindId
             INNER JOIN tmpRes_mov   ON tmpRes_mov.MovementId = tmpMovement_all.MovementId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.19                                       *
*/
-- тест
-- SELECT distinct goodscode, GoodsKindName FROM lpSelect_Object_wms_SKU_test() ORDER BY 1
-- SELECT distinct MovementId FROM lpSelect_Object_wms_SKU_test() ORDER BY 1
-- SELECT * FROM lpSelect_Object_wms_SKU_test() ORDER BY GoodsId
