-- Function: gpInsertUpdate_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalService(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPersonalId          Integer   , -- Сотрудники
    IN inisMain              Boolean   , -- Основное место работы
   OUT outAmount             TFloat    , -- Сумма (затраты)
   OUT outAmountToPay        TFloat    , -- Сумма к выплате (итог)
   OUT outAmountCash         TFloat    , -- Сумма к выплате из кассы
    IN inSummService         TFloat    , -- Сумма начислено
    IN inSummCardRecalc      TFloat    , -- Сумма на карточку (БН) для распределения    
    IN inSummMinus           TFloat    , -- Сумма удержания
    IN inSummAdd             TFloat    , -- Сумма премия
    IN inSummSocialIn        TFloat    , -- Сумма соц выплаты (из зарплаты)
    IN inSummSocialAdd       TFloat    , -- Сумма соц выплаты (доп. зарплате)
    IN inSummChild           TFloat    , -- Сумма алименты (удержание)    
    IN inComment             TVarChar  , -- 
    IN inInfoMoneyId         Integer   , -- Статьи назначения
    IN inUnitId              Integer   , -- Подразделение
    IN inPositionId          Integer   , -- Должность
    IN inMemberId            Integer   , -- юр.лицо
    IN inPersonalServiceListId Integer   , -- Ведомость начисления
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());

     -- сохранили
     SELECT tmp.ioId, tmp.outAmount, tmp.outAmountToPay, tmp.outAmountCash
        INTO ioId, outAmount, outAmountToPay, outAmountCash
     FROM lpInsertUpdate_MovementItem_PersonalService (ioId                 := ioId
                                                     , inMovementId         := inMovementId
                                                     , inPersonalId         := inPersonalId
                                                     , inIsMain             := inIsMain
                                                     , inSummService        := inSummService
                                                     , inSummCardRecalc     := inSummCardRecalc
                                                     , inSummMinus          := inSummMinus
                                                     , inSummAdd            := inSummAdd
                                                     , inSummSocialIn       := inSummSocialIn
                                                     , inSummSocialAdd      := inSummSocialAdd
                                                     , inSummChild          := inSummChild
                                                     , inComment            := inComment
                                                     , inInfoMoneyId        := inInfoMoneyId
                                                     , inUnitId             := inUnitId
                                                     , inPositionId         := inPositionId
                                                     , inMemberId           := inMemberId
                                                     , inPersonalServiceListId  := inPersonalServiceListId
                                                     , inUserId             := vbUserId
                                                      ) AS tmp;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.05.15         * add PersonalServiceList
 14.09.14                                        * add outAmountToPay
 02.10.14                                        * del inSummCard
 01.10.14         * add redmine 30.09
 14.09.14                                        * add out...
 11.09.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_PersonalService (ioId:= 0, inMovementId:= 258038 , inPersonalId:= 8473, inAmount:= 44, inSummService:= 20, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8426, inPositionId:=12431, inSession:= '2')
