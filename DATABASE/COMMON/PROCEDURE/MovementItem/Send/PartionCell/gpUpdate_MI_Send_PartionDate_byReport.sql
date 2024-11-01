-- Function: gpUpdate_MI_Send_PartionDate_byReport()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_PartionDate_byReport (Integer, Integer,Integer,Integer,TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_PartionDate_byReport(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId        Integer   , -- Ключ объекта <Элемент документа> 
    IN inGoodsId               Integer  ,
    IN inGoodsKindId           Integer  ,
    IN inPartionGoodsDate      TDateTime , -- Дата партии
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send_PartionDate_byReport());

     IF COALESCE (inMovementItemId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.%Изменение Даты партии возможно в режиме <По документам>.', CHR (13);
     END IF;
     
     IF EXISTS (SELECT 1
                FROM MovementItemLinkObject AS MILO_PartionCell
                WHERE MILO_PartionCell.MovementItemId = inMovementItemId
                  AND MILO_PartionCell.ObjectId       > 0
                  AND MILO_PartionCell.ObjectId       NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  AND MILO_PartionCell.DescId         IN (zc_MILinkObject_PartionCell_1()
                                                        , zc_MILinkObject_PartionCell_2()
                                                        , zc_MILinkObject_PartionCell_3()
                                                        , zc_MILinkObject_PartionCell_4()
                                                        , zc_MILinkObject_PartionCell_5()
                                                        , zc_MILinkObject_PartionCell_6()
                                                        , zc_MILinkObject_PartionCell_7()
                                                        , zc_MILinkObject_PartionCell_8()
                                                        , zc_MILinkObject_PartionCell_9()
                                                        , zc_MILinkObject_PartionCell_10()
                                                        , zc_MILinkObject_PartionCell_11()
                                                        , zc_MILinkObject_PartionCell_12()
                                                        , zc_MILinkObject_PartionCell_13()
                                                        , zc_MILinkObject_PartionCell_14()
                                                        , zc_MILinkObject_PartionCell_15()
                                                        , zc_MILinkObject_PartionCell_16()
                                                        , zc_MILinkObject_PartionCell_17()
                                                        , zc_MILinkObject_PartionCell_18()
                                                        , zc_MILinkObject_PartionCell_19()
                                                        , zc_MILinkObject_PartionCell_20()
                                                        , zc_MILinkObject_PartionCell_21()
                                                        , zc_MILinkObject_PartionCell_22()
                                                         )
               )
     THEN
         RAISE EXCEPTION 'Ошибка.%Изменение партии возможно если не заполнены места хранения.', CHR (13);
     END IF;

     -- меняем параметр
     IF inPartionGoodsDate <= '01.01.2010' THEN inPartionGoodsDate:= NULL; END IF;
     
     -- сохранили свойство <Дата партии>
     IF COALESCE (inPartionGoodsDate, zc_DateStart()) <> zc_DateStart() OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = inMovementItemId AND MID.DescId = zc_MIDate_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inMovementItemId, inPartionGoodsDate); 
     END IF;

     -- сохранили протокол
     --PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.01.24         *
*/

-- тест
--