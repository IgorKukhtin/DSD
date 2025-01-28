-- Function: lpCheck_MI_Send_PartionCell()

DROP FUNCTION IF EXISTS lpCheck_MI_Send_PartionCell (Integer, Integer, Integer, TDateTime, Integer);


CREATE OR REPLACE FUNCTION lpCheck_MI_Send_PartionCell(
    IN inPartionCellId         Integer  ,
    IN inGoodsId               Integer  ,
    IN inGoodsKindId           Integer  ,
    IN inPartionGoodsDate      TDateTime , --
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
BEGIN
     IF COALESCE (inPartionCellId, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
     THEN
         RETURN 0;
     ELSE
         -- Проверка - в ячейке только одна партия
         RETURN (SELECT MILO.MovementItemId
                 FROM MovementItemLinkObject AS MILO
                      LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                 ON MIDate_PartionGoods.MovementItemId = MILO.MovementItemId
                                                AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
            
                      LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close
                                                    ON MIBoolean_PartionCell_Close.MovementItemId = MILO.MovementItemId
                                                   AND MIBoolean_PartionCell_Close.DescId         = CASE WHEN MILO.DescId = zc_MILinkObject_PartionCell_1()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_1()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_2()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_2()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_3()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_3()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_4()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_4()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_5()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_5()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_6()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_6()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_7()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_7()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_8()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_8()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_9()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_9()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_10()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_10()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_11()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_11()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_12()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_12()

                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_13()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_13()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_14()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_14()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_15()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_15()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_16()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_16()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_17()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_17()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_18()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_18()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_19()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_19()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_20()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_20()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_21()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_21()
                                                                                                         WHEN MILO.DescId = zc_MILinkObject_PartionCell_22()
                                                                                                              THEN zc_MIBoolean_PartionCell_Close_22()

                                                                                                    END
                                                   AND MIBoolean_PartionCell_Close.ValueData      = TRUE
            
                      INNER JOIN MovementItem ON MovementItem.Id       = MILO.MovementItemId
                                             AND MovementItem.DescId   = zc_MI_Master()
                                             AND MovementItem.isErased = FALSE
                      LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                      LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                       ON MILO_GoodsKind.MovementItemId = MILO.MovementItemId
                                                      AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
            
                      INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                                   AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                   AND MovementLinkObject_To.ObjectId   IN (zc_Unit_RK())

                 WHERE MILO.DescId   IN (zc_MILinkObject_PartionCell_1(), zc_MILinkObject_PartionCell_2(), zc_MILinkObject_PartionCell_3(), zc_MILinkObject_PartionCell_4(), zc_MILinkObject_PartionCell_5()
                                       , zc_MILinkObject_PartionCell_6(), zc_MILinkObject_PartionCell_7(), zc_MILinkObject_PartionCell_8(), zc_MILinkObject_PartionCell_9(), zc_MILinkObject_PartionCell_10()
                                       , zc_MILinkObject_PartionCell_11(), zc_MILinkObject_PartionCell_12(), zc_MILinkObject_PartionCell_13(), zc_MILinkObject_PartionCell_14(), zc_MILinkObject_PartionCell_15()
                                       , zc_MILinkObject_PartionCell_16(), zc_MILinkObject_PartionCell_17(), zc_MILinkObject_PartionCell_18(), zc_MILinkObject_PartionCell_19(), zc_MILinkObject_PartionCell_20()
                                       , zc_MILinkObject_PartionCell_21(), zc_MILinkObject_PartionCell_22()
                                        )
                   AND MILO.ObjectId = inPartionCellId
                   -- Перемещение + Взвешивание
                   AND (Movement.DescId = zc_Movement_Send()
                     OR (Movement.DescId = zc_Movement_WeighingProduction() AND Movement.StatusId = zc_Enum_Status_UnComplete())
                       )
                   -- партия открыта
                   AND MIBoolean_PartionCell_Close.MovementItemId IS NULL
                   -- в ячейке другой товар или ....
                   AND (MovementItem.ObjectId   <> inGoodsId
                     OR MILO_GoodsKind.ObjectId <> inGoodsKindId
                     OR COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) <> inPartionGoodsDate
                       )
                 LIMIT 1
                );

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.02.24                                        *
*/

-- тест
-- SELECT * FROM lpCheck_MI_Send_PartionCell (inPartionCellId:= 10239266 , inGoodsId:= 2116, inGoodsKindId:= 8346 , inPartionGoodsDate:= CURRENT_DATE, inUserId:= 5)
