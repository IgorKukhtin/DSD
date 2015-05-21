-- Function: lpInsertUpdate_Movement_TransportGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransportGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TransportGoods(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inMovementId_Sale     Integer   , -- 
    IN inInvNumberMark       TVarChar  , -- 
    IN inCarId               Integer   , -- Автомобиль
    IN inCarTrailerId        Integer   , -- Автомобиль (прицеп)
    IN inPersonalDriverId    Integer   , -- Сотрудник (водитель)
    IN inRouteId             Integer   , -- 
    IN inMemberId1           Integer   , -- отримав водій/експедитор
    IN inMemberId2           Integer   , -- Бухгалтер (відповідальна особа вантажовідправника)
    IN inMemberId3           Integer   , -- Відпуск дозволив
    IN inMemberId4           Integer   , -- Здав (відповідальна особа вантажовідправника)
    IN inMemberId5           Integer   , -- Прийняв водій/експедитор
    IN inMemberId6           Integer   , -- Здав водій/експедитор
    IN inMemberId7           Integer   , -- Прийняв (відповідальна особа вантажоодержувача) 
    IN inUserId              Integer     -- Пользователь
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- определяем ключ доступа
     IF inMovementId_Sale <> 0
     THEN
         vbAccessKeyId:= (SELECT AccessKeyId FROM Movement WHERE Id = inMovementId_Sale);
     ELSE
         IF ioId <> 0
         THEN vbAccessKeyId:= (SELECT AccessKeyId FROM Movement WHERE Id = ioId);
         ELSE vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TransportGoods());
         END IF;
     END IF;


     -- проверка
     IF inOperDate IS NULL
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлена <Дата документа>.';
     END IF;

     -- проверка
     IF 1=0 AND COALESCE (inMovementId_Sale, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен <№ док. (склад)>.';
     END IF;


     -- 1. Распроводим Документ
     IF ioId > 0 -- AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_TransportGoods())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := inUserId);
     END IF;


      -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransportGoods(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <номер пломби>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberMark(), ioId, inInvNumberMark);

     -- сохранили связь с <Автомобиль>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Car(), ioId, inCarId);
     -- сохранили связь с <Автомобиль (прицеп)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarTrailer(), ioId, inCarTrailerId);
     -- сохранили связь с <Сотрудник (водитель)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), ioId, inPersonalDriverId);
     -- сохранили связь с <Маршрут>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Route(), ioId, inRouteId);

     -- сохранили связь с <отримав водій/експедитор>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member1(), ioId, inMemberId1);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member2(), ioId, inMemberId2);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member3(), ioId, inMemberId3);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member4(), ioId, inMemberId4);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member5(), ioId, inMemberId5);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member6(), ioId, inMemberId6);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member7(), ioId, inMemberId7);


     -- установили связь у <Продажа покупателю> на этот документ <Товаро-транспортная накладная>
     IF inMovementId_Sale <> 0 
     THEN PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_TransportGoods(), inMovementId_Sale, ioId);
     END IF;

     -- удалили связь у "других" <Продажа покупателю> на этот документ <Товаро-транспортная накладная>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_TransportGoods(), MovementLinkMovement.MovementId, NULL)
     FROM MovementLinkMovement
     WHERE MovementLinkMovement.MovementChildId = ioId
       AND MovementLinkMovement.DescId = zc_MovementLinkMovement_TransportGoods()
       AND MovementLinkMovement.MovementId <> inMovementId_Sale
    ;

     -- 5.2. проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := ioId
                                , inDescId     := zc_Movement_TransportGoods()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 28.03.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_TransportGoods (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
