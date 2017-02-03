-- Function: gpInsertUpdate_MovementItem_MobileBills()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_MobileBills (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_MobileBills (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_MobileBills(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMobileEmployeeId    Integer   , -- Номер телефона
 INOUT ioAmount              TFloat    , -- Сумма итого
 INOUT ioCurrMonthly         TFloat    , -- 
    IN inCurrNavigator       TFloat    , -- 
    IN inPrevNavigator       TFloat    , -- 
    IN inLimit               TFloat    , -- 
    IN inPrevLimit           TFloat    , -- 
    IN inDutyLimit           TFloat    , -- 
    IN inOverlimit           TFloat    , -- 
    IN inPrevMonthly         TFloat    , -- 
   -- IN inRegionId            Integer   , --
    IN inEmployeeId          Integer   , --
    IN inPrevEmployeeId      Integer   , --
    IN inMobileTariffId      Integer   , --
    IN inPrevMobileTariffId  Integer   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_MobileBills());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF COALESCE (ioCurrMonthly,0) = 0 THEN
         ioCurrMonthly:= (SELECT COALESCE(ObjectFloat_Monthly.ValueData,0)   ::TFloat  AS Monthly 
                          FROM ObjectFloat AS ObjectFloat_Monthly
                          WHERE ObjectFloat_Monthly.ObjectId = inMobileTariffId
                            AND ObjectFloat_Monthly.DescId = zc_ObjectFloat_MobileTariff_Monthly()
                          );
      END IF;
     
     ioAmount:= (ioCurrMonthly+inCurrNavigator+inOverlimit) ::TFloat;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_MobileBills( ioId                 := ioId
                                                    , inMovementId         := inMovementId
                                                    , inMobileEmployeeId   := inMobileEmployeeId
                                                    , inAmount             := ioAmount 
                                                    , inCurrMonthly        := ioCurrMonthly
                                                    , inCurrNavigator      := inCurrNavigator
                                                    , inPrevNavigator      := inPrevNavigator
                                                    , inLimit              := inLimit
                                                    , inPrevLimit          := inPrevLimit
                                                    , inDutyLimit          := inDutyLimit
                                                    , inOverlimit          := inOverlimit
                                                    , inPrevMonthly        := inPrevMonthly
                                                    --, inRegionId           := inRegionId
                                                    , inEmployeeId         := inEmployeeId
                                                    , inPrevEmployeeId     := inPrevEmployeeId
                                                    , inMobileTariffId     := inMobileTariffId
                                                    , inPrevMobileTariffId := inPrevMobileTariffId
                                                    , inUserId             := vbUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.02.17         * del inRegionId
 27.09.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_MobileBills(ioId := 0 , inMovementId := 4353249 , inMobileEmployeeId := 670584 , ioAmount := 0 , ioCurrMonthly := 0 , inCurrNavigator := 0 , inPrevNavigator := 0 , inLimit := 100 , inPrevLimit := 0 , inDutyLimit := 0 , inOverlimit := 0 , inPrevMonthly := 0 , inRegionId := 0 , inEmployeeId := 617411 , inPrevEmployeeId := 0 , inMobileTariffId := 669910 , inPrevMobileTariffId := 0 ,  inSession := '5');
