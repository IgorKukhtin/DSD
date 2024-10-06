-- Function: lpInsertUpdate_MovementItem_PersonalService_item()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);*/
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);*/
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TVarChar, TVarChar
                                                                        , Integer, Integer, Integer, Integer, Integer, Integer);*/
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService_item (Integer, Integer, Integer, Boolean
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                        , TVarChar, TVarChar
                                                                        , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalService_item(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPersonalId          Integer   , -- Сотрудники
    IN inisMain              Boolean   , -- Основное место работы

    IN inSummService         TFloat    , -- Сумма начислено
    IN inSummCardRecalc      TFloat    , -- Карта БН (ввод) - 1ф.
    IN inSummCardSecondRecalc TFloat    , -- Карта БН (ввод) - 2ф.
    IN inSummCardSecondCash  TFloat    , -- Карта БН (касса) - 2ф.
    IN inSummAvCardSecondRecalc TFloat    , -- Карта БН (ввод) - 2ф. аванс
    IN inSummNalogRecalc     TFloat    , -- Налоги - удержания с ЗП (ввод)
    IN inSummNalogRetRecalc  TFloat    , -- Налоги - возмещение к ЗП (ввод)
    IN inSummMinus           TFloat    , -- Сумма удержания
    IN inSummAdd             TFloat    , -- Сумма премия
    IN inSummAddOthRecalc    TFloat    , -- Сумма премия (ввод для распределения)
    
    IN inSummHoliday         TFloat    , -- Сумма отпускные    
    IN inSummSocialIn        TFloat    , -- Сумма соц выплаты (из зарплаты)
    IN inSummSocialAdd       TFloat    , -- Сумма соц выплаты (доп. зарплате)
    IN inSummChildRecalc     TFloat    , -- Алименты - удержание (ввод)
    IN inSummMinusExtRecalc  TFloat    , -- Удержания сторон. юр.л. (ввод)
    
    IN inSummFine               TFloat , -- штраф
    IN inSummFineOthRecalc      TFloat , -- штраф (ввод для распределения)
    IN inSummHosp               TFloat , -- больничный
    IN inSummHospOthRecalc      TFloat , -- больничный (ввод для распределения)

    IN inSummCompensationRecalc TFloat , -- компенсация (ввод)
    IN inSummAuditAdd           TFloat , -- Сумма доплата за аудит
    IN inSummHouseAdd           TFloat , -- Сумма доплата за жилье
    IN inSummAvanceRecalc       TFloat , -- авнс

    IN inNumber              TVarChar  , -- № исполнительного листа
    IN inComment             TVarChar  , -- 
    IN inInfoMoneyId         Integer   , -- Статьи назначения
    IN inUnitId              Integer   , -- Подразделение
    IN inPositionId          Integer   , -- Должность
    IN inMemberId            Integer   , -- Физ лицо (кому начисляют алименты)
    IN inPersonalServiceListId   Integer   , -- Ведомость начисления
    IN inFineSubjectId          Integer   , -- вид нарушения
    IN inUnitFineSubjectId      Integer   , -- Кем налагается взыскание
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
BEGIN
     -- сохранили
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MovementItem_PersonalService (ioId                     := ioId
                                                     , inMovementId             := inMovementId
                                                     , inPersonalId             := inPersonalId
                                                     , inIsMain                 := inIsMain

                                                     , inSummService            := inSummService
                                                     , inSummCardRecalc         := inSummCardRecalc
                                                     , inSummCardSecondRecalc   := inSummCardSecondRecalc
                                                     , inSummCardSecondCash     := inSummCardSecondCash
                                                     , inSummAvCardSecondRecalc := inSummAvCardSecondRecalc
                                                     , inSummNalogRecalc        := inSummNalogRecalc
                                                     , inSummNalogRetRecalc     := inSummNalogRetRecalc
                                                     , inSummMinus              := inSummMinus
                                                     , inSummAdd                := inSummAdd
                                                     , inSummAddOthRecalc       := inSummAddOthRecalc

                                                     , inSummHoliday            := inSummHoliday
                                                     , inSummSocialIn           := inSummSocialIn
                                                     , inSummSocialAdd          := inSummSocialAdd
                                                     , inSummChildRecalc        := inSummChildRecalc
                                                     , inSummMinusExtRecalc     := inSummMinusExtRecalc
                                                     , inSummFine               := inSummFine
                                                     , inSummFineOthRecalc      := inSummFineOthRecalc
                                                     , inSummHosp               := inSummHosp
                                                     , inSummHospOthRecalc      := inSummHospOthRecalc
                                                     , inSummCompensationRecalc := inSummCompensationRecalc
                                                     , inSummAuditAdd           := inSummAuditAdd
                                                     , inSummHouseAdd           := inSummHouseAdd
                                                     , inSummAvanceRecalc       := inSummAvanceRecalc

                                                     , inNumber                 := inNumber
                                                     , inComment                := inComment
                                                     , inInfoMoneyId            := inInfoMoneyId
                                                     , inUnitId                 := inUnitId
                                                     , inPositionId             := inPositionId
                                                     , inMemberId               := inMemberId
                                                     , inPersonalServiceListId  := inPersonalServiceListId
                                                     , inFineSubjectId          := inFineSubjectId
                                                     , inUnitFineSubjectId      := inUnitFineSubjectId
                                                     , inUserId                 := inUserId
                                                      ) AS tmp;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.10.19         * замена inSummFine, inSummHosp на inSummFineRecalc, inSummHospRecalc
 05.01.18         * add inSummNalogRetRecalc
 20.06.17         * add inSummCardSecondCash
 20.04.16         * add inSummHoliday
 22.05.15                                        *
*/

-- тест
-- 