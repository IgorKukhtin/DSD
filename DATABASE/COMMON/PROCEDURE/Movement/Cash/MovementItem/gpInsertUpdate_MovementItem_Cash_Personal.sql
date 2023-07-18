-- Function: gpInsertUpdate_MovementItem_Cash_Personal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Cash_Personal (Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Cash_Personal (Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Cash_Personal(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Parent   Integer   , -- Ключ объекта <Документ>
    IN inPersonalId          Integer   , -- Сотрудники
    IN inAmount              TFloat    , -- Сумма
   OUT outSummRemains        TFloat    , -- Остаток к выплате 
    IN inComment             TVarChar  , -- 
    IN inInfoMoneyId         Integer   , -- Статьи назначения
    IN inUnitId              Integer   , -- Подразделение
    IN inPositionId          Integer   , -- Должность
    IN inIsCalculated        Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());

     -- Проверка
     IF inAmount < 0 AND 1=0
     THEN
        RAISE EXCEPTION 'Ошибка.Для <%> сумма выплаты <%> не может быть отрицательной.', lfGet_Object_ValueData (inPersonalId), zfConvert_FloatToString (inAmount);
     END IF;


     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Cash_Personal (ioId                 := ioId
                                                     , inMovementId         := inMovementId
                                                     , inPersonalId         := inPersonalId
                                                     , inAmount             := inAmount
                                                     , inComment            := inComment
                                                     , inInfoMoneyId        := inInfoMoneyId
                                                     , inUnitId             := inUnitId
                                                     , inPositionId         := inPositionId
                                                     , inIsCalculated       := CASE WHEN inAmount < 0 THEN TRUE ELSE inIsCalculated END
                                                     , inUserId             := vbUserId
                                                      );
     -- вернули <Остаток к выплате>
     outSummRemains:= (SELECT tmp.SummRemains
                       FROM gpSelect_MovementItem_Cash_Personal (inMovementId     := inMovementId
                                                               , inParentId       := inMovementId_Parent
                                                               , inMovementItemId := ioId
                                                               , inShowAll        := FALSE
                                                               , inIsErased       := FALSE
                                                               , inSession        := inSession
                                                                )  AS tmp
                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.04.15                                        * all
 16.09.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Cash_Personal (ioId:= 0, inMovementId:= 258038 , inPersonalId:= 8473, inAmount:= 44, inSummService:= 20, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8426, inPositionId:=12431, inSession:= '2')
