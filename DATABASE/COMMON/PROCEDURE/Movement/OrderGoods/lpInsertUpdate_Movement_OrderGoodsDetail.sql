-- Function: lpInsertUpdate_Movement_OrderGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderGoodsDetail (Integer, Integer, TDateTime, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderGoodsDetail(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- ключ Документа OrderGoods
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDateStart       TDateTime , -- 
    IN inOperDateEnd         TDateTime , -- 
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- !!! 5 НЕДЕЛЬ  от последнего дня пред месяца.!!!
     vbStartDate := (DATE_TRUNC ('MONTH',inOperDate) - ((5 * 7) :: TVarChar || ' DAY') :: INTERVAL) ::TDateTime;
     vbEndDate   := (DATE_TRUNC ('MONTH',inOperDate) - INTERVAL '1 DAY')  ::TDateTime;

     -- Проверка
     IF (inOperDateStart + (((5 * 7 - 1) :: Integer) :: TVarChar || ' DAY') :: INTERVAL) <> inOperDateEnd
     THEN
         RAISE EXCEPTION 'Период с <%> по <%> должен быть кратен 5 недель. ( c <%> по <%>)'
                                                                                          , zfConvert_DateToString (inOperDateStart)
                                                                                          , zfConvert_DateToString (inOperDateEnd)
                                                                                          , zfConvert_DateToString (vbStartDate)
                                                                                          , zfConvert_DateToString (vbEndDate)
                        ;
         -- 'Повторите действие через 3 мин.'
     END IF;


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId
                                    , zc_Movement_OrderGoodsDetail()
                                    , '*' || COALESCE ((SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inParentId), '')
                                    , inOperDate
                                    , inParentId
                                     );

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);


     -- сохранили протокол
     --PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.21         *
*/

-- тест
-- 