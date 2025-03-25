-- Function: gpGet_MovementItem_Inventory_mobile()

DROP FUNCTION IF EXISTS gpGet_MovementItem_Inventory_mobile (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_Inventory_mobile(
    IN inBarCode             TVarChar  , -- штрихкод
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementItemId       Integer
              -- Товар              
             , GoodsId              Integer
             , GoodsCode            Integer
             , GoodsName            TVarChar
              -- Вид                
             , GoodsKindId          Integer
             , GoodsKindName        TVarChar
               --
             , MeasureId            Integer
             , MeasureName          TVarChar
                                    
               -- Вес 1 шт
             , Weight               TFloat
               -- Вес 1-ой упаковки - справочно
             , WeightPackageSticker TFloat

               -- Вес нетто
             , Amount               TFloat
               -- Шт                
             , Amount_sh            TFloat
               -- Ячейка хранения
             , PartionCellId        Integer
             , PartionCellName      TVarChar
               -- партия            
             , PartionGoodsDate     TDateTime
               -- № паспорта        
             , PartionNum           Integer
               -- Поддон            
             , BoxId_1              Integer
             , BoxName_1            TVarChar
             , CountTare_1          Integer
             , WeightTare_1         TFloat
               -- Ящик              
             , BoxId_2              Integer
             , BoxName_2            TVarChar
             , CountTare_2          Integer
             , WeightTare_2         TFloat
               -- Ящик              
             , BoxId_3              Integer
             , BoxName_3            TVarChar
             , CountTare_3          Integer
             , WeightTare_3         TFloat
               -- Ящик              
             , BoxId_4              Integer
             , BoxName_4            TVarChar
             , CountTare_4          Integer
             , WeightTare_4         TFloat
               -- Ящик              
             , BoxId_5              Integer
             , BoxName_5            TVarChar
             , CountTare_5          Integer
             , WeightTare_5         TFloat

               -- ИТОГО Кол-во Ящиков
             , CountTare_calc       Integer

               -- Количество упаковок
             , CountPack            Integer
               -- Вес 1-ой упаковки
             , WeightPack           TFloat

               -- ИТОГО Вес всех Ящиков + Поддон + Упаковка
             , WeightTare_calc      TFloat
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbMovementDescId Integer;
   DECLARE vbPartionNum     TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- если надо найти
     IF COALESCE (inBarCode,'') <> ''
     THEN

         -- по коду
         IF CHAR_LENGTH (inBarCode) < 12
         THEN
              --
              vbPartionNum:= zfConvert_StringToFloat (inBarCode);

              --
              vbMovementItemId:= (SELECT MIF.MovementItemId FROM MovementItemFloat AS MIF WHERE MIF.DescId = zc_MIFloat_PartionNum() AND MIF.ValueData = vbPartionNum);

         -- иначе по штрихкоду
         ELSE
             --
             vbMovementItemId:= (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, LENGTH (zc_BarCodePref_MI()) + 1, 13-LENGTH (zc_BarCodePref_MI()) - 1)));
         END IF;

     END IF;

     -- надо найти
     vbMovementDescId:= (SELECT Movement.DescId FROM MovementItem JOIN Movement ON Movement.Id = MovementItem.MovementId WHERE MovementItem.Id = vbMovementItemId);


     -- Проверка
     IF COALESCE (vbMovementItemId, 0) = 0 OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = vbMovementItemId AND MovementItem.isErased = FALSE)
     THEN
        --
         RAISE EXCEPTION 'Ошибка.Паспорт  с % = <%> не найден.'
                        , CASE WHEN CHAR_LENGTH (inBarCode) < 12 THEN 'Номером' ELSE 'штрих кодом' END
                        , inBarCode;
     END IF;


     -- Результат
     RETURN QUERY
        WITH --
             tmpMIF_CountTare AS (SELECT MIF.*
                                  FROM MovementItemFloat AS MIF
                                  WHERE MIF.MovementItemId = vbMovementItemId
                                    AND MIF.DescId IN (zc_MIFloat_CountTare1()
                                                     , zc_MIFloat_CountTare2()
                                                     , zc_MIFloat_CountTare3()
                                                     , zc_MIFloat_CountTare4()
                                                     , zc_MIFloat_CountTare5()
                                                     , zc_MIFloat_CountPack()
                                                     , zc_MIFloat_HeadCount()
                                                      )
                                 )
           , tmpMIF_WeightTare AS (SELECT MIF.*
                                  FROM MovementItemFloat AS MIF
                                  WHERE MIF.MovementItemId = vbMovementItemId
                                    AND MIF.DescId IN (zc_MIFloat_WeightTare1()
                                                     , zc_MIFloat_WeightTare2()
                                                     , zc_MIFloat_WeightTare3()
                                                     , zc_MIFloat_WeightTare4()
                                                     , zc_MIFloat_WeightTare5()
                                                     , zc_MIFloat_WeightPack()
                                                      )
                                 )
           , tmpMILO_Box AS (SELECT MILO.*
                             FROM MovementItemLinkObject AS MILO
                             WHERE MILO.MovementItemId = vbMovementItemId
                               AND MILO.DescId IN (zc_MILinkObject_Box1()
                                                 , zc_MILinkObject_Box2()
                                                 , zc_MILinkObject_Box3()
                                                 , zc_MILinkObject_Box4()
                                                 , zc_MILinkObject_Box5()
                                                  )
                            )
             --
           , tmpMI_Tare AS (SELECT tmpMILO_Box.MovementItemId                AS MovementItemId
                                 , tmpMILO_Box.ObjectId                      AS BoxId
                                 , Object_Box.ValueData                      AS BoxName
                                 , tmpMIF_CountTare.ValueData                AS CountTare
                                 , COALESCE (tmpMIF_WeightTare.ValueData, 0) AS WeightTare
                                   -- DescId
                                 , tmpMILO_Box.DescId                        AS DescId_box
                            FROM tmpMILO_Box
                                 INNER JOIN tmpMIF_CountTare ON tmpMIF_CountTare.MovementItemId = tmpMILO_Box.MovementItemId
                                                            AND tmpMIF_CountTare.ValueData      > 0
                                                            AND tmpMIF_CountTare.DescId = CASE tmpMILO_Box.DescId
                                                                                               WHEN zc_MILinkObject_Box1() THEN zc_MIFloat_CountTare1()
                                                                                               WHEN zc_MILinkObject_Box2() THEN zc_MIFloat_CountTare2()
                                                                                               WHEN zc_MILinkObject_Box3() THEN zc_MIFloat_CountTare3()
                                                                                               WHEN zc_MILinkObject_Box4() THEN zc_MIFloat_CountTare4()
                                                                                               WHEN zc_MILinkObject_Box5() THEN zc_MIFloat_CountTare5()
                                                                                          END
                                 LEFT JOIN tmpMIF_WeightTare ON tmpMIF_WeightTare.MovementItemId = tmpMILO_Box.MovementItemId
                                                            AND tmpMIF_WeightTare.DescId = CASE tmpMILO_Box.DescId
                                                                                                WHEN zc_MILinkObject_Box1() THEN zc_MIFloat_WeightTare1()
                                                                                                WHEN zc_MILinkObject_Box2() THEN zc_MIFloat_WeightTare2()
                                                                                                WHEN zc_MILinkObject_Box3() THEN zc_MIFloat_WeightTare3()
                                                                                                WHEN zc_MILinkObject_Box4() THEN zc_MIFloat_WeightTare4()
                                                                                                WHEN zc_MILinkObject_Box5() THEN zc_MIFloat_WeightTare5()
                                                                                           END
                                 LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMILO_Box.ObjectId
                            WHERE tmpMILO_Box.ObjectId > 0
                           )
     , tmpGoodsByGoodsKind AS (SELECT MovementItem.Id AS MovementItemId
                                    , COALESCE (ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.ValueData, 0) AS WeightPackageSticker
                               FROM MovementItem
                                    INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                          ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = MovementItem.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                          ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = MILinkObject_GoodsKind.ObjectId
                                    LEFT JOIN ObjectFloat AS ObjectFloat_GoodsByGoodsKind_WeightPackageSticker
                                                          ON ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.DescId    = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker()
                               WHERE MovementItem.Id = vbMovementItemId
                              )
        -- Результат
        SELECT
               MovementItem.Id                                     AS MovementItemId
             , Object_Goods.Id                                     AS GoodsId
             , Object_Goods.ObjectCode                             AS GoodsCode
             , Object_Goods.ValueData                              AS GoodsName
             , Object_GoodsKind.Id                                 AS GoodsKindId
             , Object_GoodsKind.ValueData                          AS GoodsKindName
             , Object_Measure.Id                                   AS MeasureId
             , Object_Measure.ValueData                            AS MeasureName
                                                                   
               -- Вес 1 шт
             , OF_Weight.ValueData                                 AS Weight 
               -- Вес 1-ой упаковки - справочно
             , tmpGoodsByGoodsKind.WeightPackageSticker :: TFloat  AS WeightPackageSticker

-- ************
-- если Перемещение с Упак -> РК = здесь всегда ШТ
-- если Инвентаризация - Подготовка = здесь всегда ВЕС
-- ************

               -- Вес нетто
             , CASE WHEN vbMovementDescId = zc_Movement_WeighingProduction() AND OL_Measure.ChildObjectId = zc_Measure_Sh()
                         -- если Перемещение с Упак -> РК = переводим из ШТ в ВЕС
                         THEN MovementItem.Amount * (COALESCE (OF_Weight.ValueData, 0) + COALESCE (tmpGoodsByGoodsKind.WeightPackageSticker, 0))

                    WHEN vbMovementDescId = zc_Movement_WeighingPartner() AND OL_Measure.ChildObjectId = zc_Measure_Sh() AND MIFloat_HeadCount.ValueData > 0
                         -- если Инвентаризация - Подготовка = здесь сохранено в ШТ и переводим в ВЕС
                         THEN MIFloat_HeadCount.ValueData * (COALESCE (OF_Weight.ValueData, 0) + COALESCE (tmpGoodsByGoodsKind.WeightPackageSticker, 0))

                    -- Иначе Инвентаризация - Подготовка = здесь всегда ВЕС
                    ELSE MovementItem.Amount

               END :: TFloat AS Amount

               -- Шт
             , CAST (CASE WHEN vbMovementDescId = zc_Movement_WeighingProduction() AND OL_Measure.ChildObjectId = zc_Measure_Sh()
                               -- если Перемещение с Упак -> РК = здесь всегда ШТ
                               THEN MovementItem.Amount
      
                          WHEN vbMovementDescId = zc_Movement_WeighingPartner() AND OL_Measure.ChildObjectId = zc_Measure_Sh() AND MIFloat_HeadCount.ValueData > 0
                               -- если Инвентаризация - Подготовка = здесь сохранено в ШТ
                               THEN MIFloat_HeadCount.ValueData
      
                          WHEN vbMovementDescId = zc_Movement_WeighingPartner() AND OL_Measure.ChildObjectId = zc_Measure_Sh() AND OF_Weight.ValueData > 0
                               -- если Инвентаризация - Подготовка = переводим из ВЕС в ШТ
                               THEN MovementItem.Amount / (COALESCE (OF_Weight.ValueData, 0) + COALESCE (tmpGoodsByGoodsKind.WeightPackageSticker, 0))
      
                          ELSE 0
      
                     END AS NUMERIC (16, 0)
                    ) :: TFloat AS Amount_sh

               -- Ячейка хранения
             , Object_PartionCell.Id                     AS PartionCellId
             , Object_PartionCell.ValueData              AS PartionCellName
               -- партия - Дата
             , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) AS PartionGoodsDate
               -- № паспорта
             , MIFloat_PartionNum.ValueData :: Integer   AS PartionNum
               -- Поддон
             , tmpMI_Tare_1.BoxId           :: Integer   AS BoxId_1
             , tmpMI_Tare_1.BoxName         :: TVarChar  AS BoxName_1
             , tmpMI_Tare_1.CountTare       :: Integer   AS CountTare_1
             , tmpMI_Tare_1.WeightTare      :: TFloat    AS WeightTare_1

               -- Ящик
             , tmpMI_Tare_2.BoxId           :: Integer   AS BoxId_1
             , (tmpMI_Tare_2.BoxName  || ' (' || zfConvert_FloatToString (tmpMI_Tare_1.CountTare) || 'кг.)')        :: TVarChar  AS BoxName_2
             , tmpMI_Tare_2.CountTare       :: Integer   AS CountTare_2
             , tmpMI_Tare_2.WeightTare      :: TFloat    AS WeightTare_2

               -- Ящик
             , tmpMI_Tare_3.BoxId           :: Integer   AS BoxId_3
             , (tmpMI_Tare_3.BoxName  || ' (' || zfConvert_FloatToString (tmpMI_Tare_1.CountTare) || 'кг.)')         :: TVarChar  AS BoxName_3
             , tmpMI_Tare_3.CountTare       :: Integer   AS CountTare_3
             , tmpMI_Tare_3.WeightTare      :: TFloat    AS WeightTare_3

               -- Ящик
             , tmpMI_Tare_4.BoxId           :: Integer   AS BoxId_4
             , (tmpMI_Tare_4.BoxName  || ' (' || zfConvert_FloatToString (tmpMI_Tare_1.CountTare) || 'кг.)')        :: TVarChar  AS BoxName_4
             , tmpMI_Tare_4.CountTare       :: Integer   AS CountTare_4
             , tmpMI_Tare_4.WeightTare      :: TFloat    AS WeightTare_4

               -- Ящик
             , tmpMI_Tare_5.BoxId           :: Integer   AS BoxId_5
             , (tmpMI_Tare_5.BoxName  || ' (' || zfConvert_FloatToString (tmpMI_Tare_1.CountTare) || 'кг.)')        :: TVarChar  AS BoxName_5
             , tmpMI_Tare_5.CountTare       :: Integer   AS CountTare_5
             , tmpMI_Tare_5.WeightTare      :: TFloat    AS WeightTare_5

               -- ИТОГО Кол-во Ящиков
             , (COALESCE (tmpMI_Tare_2.CountTare, 0)
              + COALESCE (tmpMI_Tare_3.CountTare, 0)
              + COALESCE (tmpMI_Tare_4.CountTare, 0)
              + COALESCE (tmpMI_Tare_5.CountTare, 0)
               ) :: Integer AS CountTare_calc

               -- Количество упаковок
             , COALESCE (tmpMIF_CountPack.ValueData, 0)  :: Integer AS CountPack
               -- Вес 1-ой упаковки
             , COALESCE (tmpMIF_WeightPack.ValueData, 0) :: TFloat  AS WeightPack

               -- ИТОГО Вес
             , (-- Поддон
                COALESCE (tmpMI_Tare_1.CountTare, 0) * COALESCE (tmpMI_Tare_1.WeightTare, 0)
                -- + все Ящики
              + COALESCE (tmpMI_Tare_2.CountTare, 0) * COALESCE (tmpMI_Tare_2.WeightTare, 0)
              + COALESCE (tmpMI_Tare_3.CountTare, 0) * COALESCE (tmpMI_Tare_3.WeightTare, 0)
              + COALESCE (tmpMI_Tare_4.CountTare, 0) * COALESCE (tmpMI_Tare_4.WeightTare, 0)
              + COALESCE (tmpMI_Tare_5.CountTare, 0) * COALESCE (tmpMI_Tare_5.WeightTare, 0)
                -- + Упаковка
              + COALESCE (tmpMIF_CountPack.ValueData, 0) * COALESCE (tmpMIF_WeightPack.ValueData, 0)
               ) :: TFloat AS WeightTare_calc

        FROM MovementItem
             LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.MovementItemId = MovementItem.Id

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             LEFT JOIN MovementItemFloat AS MIFloat_PartionNum
                                         ON MIFloat_PartionNum.MovementItemId = MovementItem.Id
                                        AND MIFloat_PartionNum.DescId = zc_MIFloat_PartionNum()

             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                       AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
             LEFT JOIN Movement ON Movement.Id =  MovementItem.MovementId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell
                                              ON MILinkObject_PartionCell.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PartionCell.DescId = zc_MILinkObject_PartionCell()
             LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = MILinkObject_PartionCell.ObjectId

             LEFT JOIN ObjectFloat AS OF_Weight
                                   ON OF_Weight.ObjectId = Object_Goods.Id
                                  AND OF_Weight.DescId = zc_ObjectFloat_Goods_Weight()
             LEFT JOIN ObjectLink AS OL_Measure
                                  ON OL_Measure.ObjectId = Object_Goods.Id
                                 AND OL_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Measure.ChildObjectId

             -- если Инвентаризация - Подготовка = здесь сохранено в ШТ
             LEFT JOIN tmpMIF_CountTare AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId         = zc_MIFloat_HeadCount()
             -- Количество упаковок
             LEFT JOIN tmpMIF_CountTare AS tmpMIF_CountPack
                                        ON tmpMIF_CountPack.MovementItemId = MovementItem.Id
                                       AND tmpMIF_CountPack.DescId         = zc_MIFloat_CountPack()
             -- Вес 1-ой упаковки
             LEFT JOIN tmpMIF_WeightTare AS tmpMIF_WeightPack
                                         ON tmpMIF_WeightPack.MovementItemId = MovementItem.Id
                                        AND tmpMIF_WeightPack.DescId         = zc_MIFloat_WeightPack()

             LEFT JOIN tmpMI_Tare AS tmpMI_Tare_1 ON tmpMI_Tare_1.MovementItemId = MovementItem.Id
                                                 AND tmpMI_Tare_1.DescId_box     = zc_MILinkObject_Box1()
             LEFT JOIN tmpMI_Tare AS tmpMI_Tare_2 ON tmpMI_Tare_2.MovementItemId = MovementItem.Id
                                                 AND tmpMI_Tare_2.DescId_box     = zc_MILinkObject_Box2()
             LEFT JOIN tmpMI_Tare AS tmpMI_Tare_3 ON tmpMI_Tare_3.MovementItemId = MovementItem.Id
                                                 AND tmpMI_Tare_3.DescId_box     = zc_MILinkObject_Box3()
             LEFT JOIN tmpMI_Tare AS tmpMI_Tare_4 ON tmpMI_Tare_4.MovementItemId = MovementItem.Id
                                                 AND tmpMI_Tare_4.DescId_box     = zc_MILinkObject_Box4()
             LEFT JOIN tmpMI_Tare AS tmpMI_Tare_5 ON tmpMI_Tare_5.MovementItemId = MovementItem.Id
                                                 AND tmpMI_Tare_5.DescId_box     = zc_MILinkObject_Box5()

        WHERE MovementItem.Id     = vbMovementItemId
          AND MovementItem.DescId = zc_MI_Master()
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.25                                        *
*/

-- тест
-- SELECT * FROM gpGet_MovementItem_Inventory_mobile ('7', zfCalc_UserAdmin())
-- SELECT * FROM gpGet_MovementItem_Inventory_mobile ('2033196375483', zfCalc_UserAdmin())
-- SELECT * FROM gpGet_MovementItem_Inventory_mobile ('2033196671547', zfCalc_UserAdmin())
