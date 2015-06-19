-- Function: lpInsertUpdate_Movement_QualityDoc (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_QualityDoc (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_QualityDoc (Integer, Integer, Integer, TDateTime, TDateTime, Integer, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_QualityDoc(
 INOUT ioId                         Integer   , -- Ключ объекта <Документ>
    IN inMovementId_master          Integer   , -- 
    IN inMovementId_child           Integer   , -- 
    IN inOperDateIn                 TDateTime , -- Дата і час виготовлення
    IN inOperDateOut                TDateTime , -- Дата відвантаження
    IN inCarId                      Integer   , -- Автомобиль
    IN inQualityNumber              TVarChar  , --
    IN inCertificateNumber          TVarChar  , --
    IN inOperDateCertificate        TDateTime , --
    IN inCertificateSeries          TVarChar  , --
    IN inCertificateSeriesNumber    TVarChar  , --
    IN inUserId                     Integer     -- Пользователь
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- определяем ключ доступа and OperDate
     IF inMovementId_child <> 0
     THEN
         -- значение соответствует inMovementId_child
         vbAccessKeyId:= (SELECT Movement.AccessKeyId FROM Movement WHERE Movement.Id = inMovementId_child);
         -- дата соответствует inMovementId_child
         vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_child);
     END IF;

     -- проверка
     IF COALESCE (inMovementId_master, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен <№ док. Качественное удостоверение - параметры>.';
     END IF;
     -- проверка
     IF COALESCE (inMovementId_child, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен <№ док. (склад)>.';
     END IF;


     -- 1. Распроводим Документ
     IF ioId > 0
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := inUserId);
     END IF;


      -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId
                                    , zc_Movement_QualityDoc()
                                      -- номер или тот что был или +1
                                    , CASE WHEN ioId <> 0 THEN (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId) ELSE CAST (NEXTVAL ('movement_qualitydoc_seq') AS TVarChar) END
                                    , vbOperDate
                                    , NULL
                                    , vbAccessKeyId
                                     );

     -- сохранили свойство <Дата і час виготовлення>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateIn(), ioId, inOperDateIn);
     -- сохранили свойство <Дата відвантаження>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateOut(), ioId, inOperDateOut);

     -- сохранили связь с <Автомобиль>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Car(), ioId, inCarId);

     -- установили связь
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), ioId, inMovementId_master);
     -- установили связь
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), ioId, inMovementId_child);

     -- сохранили свойства
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateCertificate(), ioId, inOperDateCertificate);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateNumber(), ioId, inCertificateNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeries(), ioId, inCertificateSeries);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeriesNumber(), ioId, inCertificateSeriesNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_QualityNumber(), ioId, inQualityNumber);


     -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := ioId
                                , inDescId     := zc_Movement_QualityDoc()
                                , inUserId     := inUserId
                                 );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.05.15         * add...
 22.05.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_QualityDoc (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
