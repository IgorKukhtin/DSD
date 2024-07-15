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
     IF COALESCE (inPartionCellId, zc_PartionCell_RK()) IN (0, zc_PartionCell_RK())
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
                                                                                                    END
                                                   AND MIBoolean_PartionCell_Close.ValueData      = TRUE
            
                      INNER JOIN MovementItem ON MovementItem.Id       = MILO.MovementItemId
                                             AND MovementItem.DescId   = zc_MI_Master()
                                             AND MovementItem.isErased = FALSE
                      LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                      LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                       ON MILO_GoodsKind.MovementItemId = MILO.MovementItemId
                                                      AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
            
                 WHERE MILO.DescId   IN (zc_MILinkObject_PartionCell_1(), zc_MILinkObject_PartionCell_2(), zc_MILinkObject_PartionCell_3(), zc_MILinkObject_PartionCell_4(), zc_MILinkObject_PartionCell_5()
                                       , zc_MILinkObject_PartionCell_6(), zc_MILinkObject_PartionCell_7(), zc_MILinkObject_PartionCell_8(), zc_MILinkObject_PartionCell_9(), zc_MILinkObject_PartionCell_10()
                                       , zc_MILinkObject_PartionCell_11(), zc_MILinkObject_PartionCell_12()
                                        )
                   AND MILO.ObjectId = inPartionCellId
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
