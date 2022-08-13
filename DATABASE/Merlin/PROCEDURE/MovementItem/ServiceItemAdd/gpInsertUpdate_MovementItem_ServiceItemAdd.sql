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
    IN inIsOne               Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbOperDate       TDateTime;
   DECLARE vbDateStart_base TDateTime;
   DECLARE vbDateEnd_base   TDateTime;
   DECLARE vbAmount_base    TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ServiceItemAdd());

     -- дата документа
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- нашли Базовые условия
     SELECT gpSelect.DateStart, gpSelect.DateEnd, gpSelect.Amount, CASE WHEN inCommentInfoMoneyId > 0 THEN inCommentInfoMoneyId ELSE gpSelect.CommentInfoMoneyId END
            INTO vbDateStart_base, vbDateEnd_base, vbAmount_base, inCommentInfoMoneyId
     FROM gpSelect_MovementItem_ServiceItem_onDate (inOperDate:= vbOperDate, inUnitId:= inUnitId, inInfoMoneyId :=inInfoMoneyId, inSession:= inSession) AS gpSelect
     WHERE vbOperDate BETWEEN gpSelect.DateStart AND gpSelect.DateEnd
    ;
     -- проверка
     IF COALESCE (vbAmount_base, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Базовыве условия не найдены.';
     END IF;

     -- если надо только заполнить
     IF ioId > 0
     THEN
         -- если не ввели Год, возвращаем из базовых условий
         IF COALESCE (ioNumYearStart,0) = 0
         THEN
             ioNumYearStart := EXTRACT (YEAR FROM vbDateStart_base) - 2000;
         END IF;
         -- если не ввели Год
         IF COALESCE (ioNumYearEnd,0) = 0
         THEN
             ioNumYearEnd := EXTRACT (YEAR FROM vbDateEnd_base) - 2000;
         END IF;

         -- если не ввели № месяца, возвращаем из базовых условий
         IF COALESCE (ioNumStartDate,0) = 0
         THEN
             ioNumStartDate := EXTRACT (MONTH FROM vbDateStart_base);
         END IF;
         -- если не ввели № месяца
         IF COALESCE (ioNumEndDate,0) = 0
         THEN
             ioNumEndDate := EXTRACT (MONTH FROM vbDateEnd_base);
         END IF;
     END IF;

     -- если надо заполнить из базовых условий
     IF COALESCE (ioId, 0) = 0 AND (COALESCE (ioNumYearStart,0) = 0 OR COALESCE (ioNumStartDate,0) = 0)
     THEN
         -- Год
         IF COALESCE (ioNumYearStart,0) = 0 THEN ioNumYearStart:= EXTRACT (YEAR FROM vbDateStart_base) - 2000; END IF;
         -- Месяц
         IF COALESCE (ioNumStartDate,0) = 0 THEN ioNumStartDate:= EXTRACT (MONTH FROM vbDateStart_base); END IF;

         IF inIsOne = TRUE
         THEN
             -- Год
             ioNumYearEnd:= ioNumYearStart;
             -- Месяц
             ioNumEndDate:= ioNumStartDate;
         ELSE
             -- Год
             IF COALESCE (ioNumYearEnd,0) = 0 THEN ioNumYearEnd:= EXTRACT (YEAR FROM vbDateEnd_base) - 2000; END IF;
             -- Месяц
             IF COALESCE (ioNumEndDate,0) = 0 THEN ioNumEndDate:= EXTRACT (MONTH FROM vbDateEnd_base); END IF;
         END IF;

     ELSE
         -- проверка
         IF COALESCE (ioNumYearStart, 0) > 100 OR COALESCE (ioNumYearStart, 0) < 10 THEN
            RAISE EXCEPTION 'Ошибка.Значение <Год с...> не попадает в диапазон двухзначного числа.';
         END IF;
         -- проверка
         IF COALESCE (ioNumYearEnd, 0) > 100 OR COALESCE (ioNumYearEnd, 0) < 10 THEN
            RAISE EXCEPTION 'Ошибка.Значение <Год по...> не попадает в диапазон двухзначного числа.';
         END IF;

         -- Проверка StartDate - попадает в диапазон базовых условий
         IF ('01.'||ioNumStartDate||'.'||(2000 + ioNumYearStart)) ::TDateTime < vbDateStart_base
         THEN
            RAISE EXCEPTION 'Ошибка.Начальная дата = <%> не может быть раньше начальной даты в базовом условии = <%>.'
                          , zfConvert_DateToString (('01.'||ioNumStartDate||'.'||(2000 + ioNumYearStart)) ::TDateTime)
                          , zfConvert_DateToString (vbDateStart_base)
                           ;
         END IF;

         -- Проверка EndDate - попадает в диапазон базовых условий
         IF ((('01.'||ioNumEndDate||'.'||(2000 + ioNumYearEnd)) ::TDateTime) + INTERVAL '1 MONTH' -  INTERVAL '1 Day') > vbDateEnd_base
         THEN
            RAISE EXCEPTION 'Ошибка.Начальная дата = <%> не может быть раньше начальной даты в базовом условии = <%>.'
                          , zfConvert_DateToString (('01.'||ioNumEndDate||'.'||(2000 + ioNumYearEnd)) ::TDateTime + INTERVAL '1 MONTH' -  INTERVAL '1 Day')
                          , zfConvert_DateToString (vbDateEnd_base)
                           ;
         END IF;

     END IF;

     -- если за 1 месяц тогда переопределяем месяц окончания  = месяцу начала
     IF inIsOne = TRUE
     THEN
         ioNumEndDate := ioNumStartDate;
     END IF;

     IF (ioNumStartDate > ioNumEndDate) AND (ioNumYearStart = ioNumYearEnd)          -- outDateStart не может же быть позже outEndDate
     THEN
         ioNumYearEnd := ioNumYearStart + 1;
     END IF;

     -- проверка
     IF COALESCE (ioNumYearStart, 0) > 100 OR COALESCE (ioNumYearStart, 0) < 10 THEN
        RAISE EXCEPTION 'Ошибка.Значение <Год с...> не попадает в диапазон двухзначного числа.';
     END IF;
     -- проверка
     IF COALESCE (ioNumYearEnd, 0) > 100 OR COALESCE (ioNumYearEnd, 0) < 10 THEN
        RAISE EXCEPTION 'Ошибка.Значение <Год по...> не попадает в диапазон двухзначного числа.';
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