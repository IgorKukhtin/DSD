-- Function: gpInsertUpdate_MI_FinalSUA()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_FinalSUA (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_FinalSUA(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inUnitId              Integer   , -- Подразделение
    IN inAmount              TFloat    , -- Количество
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;


     -- сохранили
    ioId := lpInsertUpdate_MI_FinalSUA (ioId                 := ioId
                                     , inMovementId         := inMovementId
                                     , inGoodsId            := inGoodsId
                                     , inUnitId             := inUnitId
                                     , inAmount             := inAmount
                                     , inUserId             := vbUserId
                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_FinalSUA (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 11.02.21                                                                      *
*/

-- тест
-- select * from gpInsertUpdate_MI_FinalSUA(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');