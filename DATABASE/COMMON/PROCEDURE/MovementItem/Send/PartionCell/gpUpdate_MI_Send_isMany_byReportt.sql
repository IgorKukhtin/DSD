-- Function: gpUpdate_MI_Send_isMany_byReport()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_isMany_byReport (Integer, Integer,Integer,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_isMany_byReport(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId        Integer   , -- Ключ объекта <Элемент документа> 
    IN inPartionCellNum        Integer   , -- номер ячейки по которой несколько партий
    IN inisMany                Boolean   , -- Дата партии
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
           vbDescId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Send_isMany_byReport());

     IF COALESCE (inMovementItemId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.%Изменение параметра <Несколько партий> возможно в режиме <По документам>.', CHR (13);
     END IF;
     

     IF COALESCE (inPartionCellNum,0) = 0
     THEN 
         RAISE EXCEPTION 'Ошибка.%Номер ячейки не определен.', CHR (13);
     END IF;     
     
     vbDescId := CASE WHEN inPartionCellNum = 1 THEN zc_MIBoolean_PartionCell_Many_1()
                      WHEN inPartionCellNum = 2 THEN zc_MIBoolean_PartionCell_Many_2()
                      WHEN inPartionCellNum = 3 THEN zc_MIBoolean_PartionCell_Many_3()
                      WHEN inPartionCellNum = 4 THEN zc_MIBoolean_PartionCell_Many_4()
                      WHEN inPartionCellNum = 5 THEN zc_MIBoolean_PartionCell_Many_5()
                      WHEN inPartionCellNum = 6 THEN zc_MIBoolean_PartionCell_Many_6()
                      WHEN inPartionCellNum = 7 THEN zc_MIBoolean_PartionCell_Many_7()
                      WHEN inPartionCellNum = 8 THEN zc_MIBoolean_PartionCell_Many_8()
                      WHEN inPartionCellNum = 9 THEN zc_MIBoolean_PartionCell_Many_9()
                      WHEN inPartionCellNum = 10 THEN zc_MIBoolean_PartionCell_Many_10()
                      WHEN inPartionCellNum = 11 THEN zc_MIBoolean_PartionCell_Many_11()
                      WHEN inPartionCellNum = 12 THEN zc_MIBoolean_PartionCell_Many_12()
                      WHEN inPartionCellNum = 13 THEN zc_MIBoolean_PartionCell_Many_13()
                      WHEN inPartionCellNum = 14 THEN zc_MIBoolean_PartionCell_Many_14()
                      WHEN inPartionCellNum = 15 THEN zc_MIBoolean_PartionCell_Many_15()
                      WHEN inPartionCellNum = 16 THEN zc_MIBoolean_PartionCell_Many_16()
                      WHEN inPartionCellNum = 17 THEN zc_MIBoolean_PartionCell_Many_17()
                      WHEN inPartionCellNum = 18 THEN zc_MIBoolean_PartionCell_Many_18()
                      WHEN inPartionCellNum = 19 THEN zc_MIBoolean_PartionCell_Many_19()
                      WHEN inPartionCellNum = 20 THEN zc_MIBoolean_PartionCell_Many_20()
                      WHEN inPartionCellNum = 21 THEN zc_MIBoolean_PartionCell_Many_21()
                      WHEN inPartionCellNum = 22 THEN zc_MIBoolean_PartionCell_Many_22()
                 END ::Integer;
                      
     -- сохранили
     PERFORM lpInsertUpdate_MovementItemBoolean (vbDescId, inMovementItemId, inisMany); 
 
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);     
     
     if vbUserId = 9457 
     then
         RAISE EXCEPTION 'Test. Ok';
     end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.05.25         *
*/

-- тест
--