-- Function: gpInsertUpdate_MovementItem_ServiceItemAdd()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
 
CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ServiceItemAdd(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- отдел 
    IN inInfoMoneyId         Integer   , --
    IN inInfoMoneyId_top     Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
 INOUT ioNumStartDate        Integer , --
 INOUT ioNumEndDate          Integer , -- 
 INOUT ioNumYearStart        Integer , --
 INOUT ioNumYearEnd          Integer , -- 
    IN inAmount              TFloat    , --  
   OUT outDateStart          TDateTime , --
   OUT outDateEnd            TDateTime , --
   OUT outMonthNameStart     TDateTime ,
   OUT outMonthNameEnd       TDateTime ,  
    IN inisOne               Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ServiceItemAdd());

     -- дата документа
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
         
     --если не ввели возвращаем тек год
     IF COALESCE (ioNumYearStart,0) = 0
     THEN 
         ioNumYearStart := EXTRACT (YEAR FROM vbOperDate) - 2000;
     END IF;
     IF COALESCE (ioNumYearEnd,0) = 0
     THEN 
         ioNumYearEnd := EXTRACT (YEAR FROM ioNumYearStart) - 2000;
     END IF; 

     --если не ввели возвращаем тек месяц
     IF COALESCE (ioNumStartDate,0) = 0
     THEN 
         ioNumStartDate := EXTRACT (MONTH FROM vbOperDate);
     END IF;
     IF COALESCE (ioNumEndDate,0) = 0
     THEN 
         ioNumEndDate := EXTRACT (MONTH FROM ioNumStartDate);
     END IF;

     -- проверка - документ должен быть сохранен
     IF COALESCE (ioNumYearStart, 0) > 100 OR COALESCE (ioNumYearStart, 0) < 10 THEN
        RAISE EXCEPTION 'Ошибка.Значение <Год с...> не попадает в диапазон двухзначного числа.';
     END IF;
     -- проверка - документ должен быть сохранен
     IF COALESCE (ioNumYearEnd, 0) > 100 OR COALESCE (ioNumYearEnd, 0) < 10 THEN
        RAISE EXCEPTION 'Ошибка.Значение <Год по...> не попадает в диапазон двухзначного числа.';
     END IF;

     ---если галка 1 месяц тогда переопределяем месяц окончания  = месяцу начала 
     IF COALESCE (inisOne,FALSE) = TRUE 
     THEN   
         ioNumEndDate := ioNumStartDate;
     END IF; 
        
     IF (ioNumStartDate > ioNumEndDate) AND (ioNumYearStart = ioNumYearEnd)          -- outDateStart не может же быть позже outEndDate
     THEN 
         ioNumYearEnd := ioNumYearStart +1;
     END IF;

     outDateStart:= ('01.'||ioNumStartDate||'.'||(2000 + ioNumYearStart)) ::TDateTime;
     outDateEnd  := ((('01.'||ioNumEndDate||'.'||(2000 + ioNumYearEnd)) ::TDateTime) + INTERVAL '1 MONTH' -  INTERVAL '1 Day');
     
     outMonthNameStart:= outDateStart;
     outMonthNameEnd  := outDateEnd;
     
     IF COALESCE (inInfoMoneyId,0) = 0
     THEN
         inInfoMoneyId := inInfoMoneyId_top;
     END IF;
     
     ioId:= lpInsertUpdate_MovementItem_ServiceItemAdd (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inUnitId             := inUnitId
                                                      , inInfoMoneyId        := inInfoMoneyId
                                                      , inCommentInfoMoneyId := inCommentInfoMoneyId
                                                      , inDateStart          := outDateStart  
                                                      , inDateEnd            := outDateEnd
                                                      , inAmount             := inAmount
                                                      , inUserId             := vbUserId
                                                       );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.08.22         *
*/

-- тест
--