-- Function: gpInsertUpdate_MovementItem_ServiceItemAdd()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
 
CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ServiceItemAdd(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- отдел 
    IN inInfoMoneyId         Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
 INOUT ioNumStartDate        Integer , --
 INOUT ioNumEndDate          Integer , -- 
 INOUT ioNumYearStart        Integer , --
 INOUT ioNumYearEnd          Integer , -- 
    IN inAmount              TFloat    , --  
   OUT outDateStart          TDateTime , --
   OUT outDateEnd            TDateTime , --
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

     --дата документа
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     
     --если не ввели возвращаем тек месяц
     IF COALESCE (ioNumStartDate,0) = 0
     THEN 
         ioNumStartDate := EXTRACT (MONTH FROM vbOperDate);
     END IF;
     IF COALESCE (ioNumEndDate,0) = 0
     THEN 
         ioNumEndDate := EXTRACT (MONTH FROM vbOperDate);
     END IF;     

     IF COALESCE (ioNumYearStart,0) = 0
     THEN 
         ioNumYearStart := EXTRACT (YEAR FROM vbOperDate);
     END IF;
     IF COALESCE (ioNumYearEnd,0) = 0
     THEN 
         ioNumYearEnd := EXTRACT (YEAR FROM vbOperDate);
     END IF;
        
     IF (ioNumStartDate > ioNumEndDate) AND (ioNumYearStart = ioNumYearEnd)          -- outDateStart не может же быть позже outEndDate
     THEN 
         ioNumYearEnd := ioNumYearStart +1;
     END IF;

     outDateStart:= ('01.'||ioNumStartDate||'.'||ioNumYearStart) ::TDateTime;
     outDateEnd  := ((('01.'||ioNumEndDate||'.'||ioNumYearEnd) ::TDateTime) + INTERVAL '1 MONTH' -  INTERVAL '1 Day');
     
     
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