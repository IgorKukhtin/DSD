-- Function: lpInsertUpdate_Movement_Send()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Boolean, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Boolean, Integer, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Send(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inComment             TVarChar   , -- Примечание
    IN inChecked             Boolean   , -- Проверен
    IN inisComplete          Boolean   , -- Собрано фармацевтом
    IN inNumberSeats         Integer   , -- Количество мест
    IN inDriverSunId         Integer   , -- Водитель получивший товар
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF COALESCE ((SELECT MovementBoolean_Deferred.ValueData FROM MovementBoolean  AS MovementBoolean_Deferred
                  WHERE MovementBoolean_Deferred.MovementId = ioId
                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()), FALSE) = TRUE
        AND EXISTS(SELECT 1
                   FROM Movement
                        INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                        INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                   WHERE Movement.Id = ioId
                     AND (Movement.OperDate <> inOperDate OR MovementLinkObject_From.ObjectId <> COALESCE(inFromId, 0) OR MovementLinkObject_To.ObjectId <> COALESCE(inToId, 0)))
     THEN
          RAISE EXCEPTION 'Ошибка.Документ отложен, корректировка запрещена!';
     END IF;
     
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     IF COALESCE (ioId, 0) = 0 AND CURRENT_DATE >= '01.01.2024' AND COALESCE(inToId, 0) <> 11299914 AND 
        NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN 
       RAISE EXCEPTION 'Ошибка. Создание перемещений запрещено..';             
     END IF;    

     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Send());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Send(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Complete(), ioId, inisComplete);

     -- сохранили свойство <Количество мест>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NumberSeats(), ioId, inNumberSeats);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummSend (ioId);

     -- сохранили связь с <Водитель получивший товар>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DriverSun(), ioId, inDriverSunId);

    -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = FALSE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 15.11.16         * inisComplete
 28.06.16         *
 20.03.16         *
 29.07.15                                                                       *
 */

/*
select  Movement.*
             -- сохранили свойство <Дата создания>
             , lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), a.Id, mp1.OperDate)
             -- сохранили свойство <Пользователь (создание)>
             , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), a.Id, mp1.UserId)


             , lpInsertUpdate_MovementDate (zc_MovementDate_Update(), a.Id, mp2.OperDate)
             -- сохранили свойство <Пользователь (создание)>
             , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), a.Id, mp2.UserId)
from (
SELECT Movement.Id, min (MovementProtocol.Id) as id1, max (MovementProtocol.Id) as id2
FROM Movement
            LEFT JOIN MovementProtocol on MovementProtocol.MovementId = Movement.Id
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
where Movement.descId = zc_Movement_Send()
   and MLO_Insert.MovementId is null
--   and Movement.OperDate < '01.07.2016'
group by Movement.Id
) as a
            LEFT JOIN Movement on Movement.Id = a.Id
            LEFT JOIN MovementProtocol as mp1  on mp1.Id = a.Id1
            LEFT JOIN MovementProtocol as mp2  on mp2.Id = a.Id2 and  a.Id1 <> a.Id2

*/
-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Send (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')