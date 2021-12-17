-- Function: gpInsert_MovementItem_Pretension()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Pretension(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Pretension(
 INOUT ioMovementId          Integer   , -- Ключ объекта <Документ>
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inParentId            Integer   , -- Приходная накладная
    IN inMIParentId          Integer   , -- ссылка на родителя
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inReasonDifferencesId Integer   , -- причину разногласия
    IN inAmountIncome        TFloat    , -- Количество приход
    IN inAmountManual        TFloat    , -- Факт. кол-во
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementIncomeId Integer;
   DECLARE vbAmountIncome TFloat;
   DECLARE vbAmountOther TFloat;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     --vbUserId := inSession;
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Pretension());
     
     IF COALESCE (inAmount, 0) = 0 OR COALESCE (inReasonDifferencesId, 0) = 0
     THEN
       RETURN;
     END IF;
     
     IF COALESCE (ioMovementId, 0) = 0
     THEN
 
       ioMovementId := lpInsertUpdate_Movement_Pretension(0
                                                        , CAST (NEXTVAL ('movement_Pretension_seq') AS TVarChar) 
                                                        , CURRENT_DATE
                                                        , inFromId
                                                        , inToId
                                                        , inParentId
                                                        , ''
                                                        , vbUserId);     
     END IF;
     
     PERFORM lpInsertUpdate_MovementItem_Pretension(0, ioMovementId, inMIParentId, inGoodsId, inAmount, inReasonDifferencesId, inAmountIncome, inAmountManual, True, vbUserId);

     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm_Pretension (ioMovementId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.12.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsert_MovementItem_Pretension ()