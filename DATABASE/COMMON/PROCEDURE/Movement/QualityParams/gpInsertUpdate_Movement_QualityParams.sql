-- Function: gpInsertUpdate_Movement_QualityParams()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_QualityParams (Integer, TVarChar, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TBlob, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_QualityParams (Integer, TVarChar, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TBlob, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_QualityParams(
 INOUT ioId                         Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber                  TVarChar  , -- Номер документа
    IN inOperDate                   TDateTime , -- Дата документа
    IN inOperDateCertificate        TDateTime , --
    IN inCertificateNumber          TVarChar  , --
    IN inCertificateSeries          TVarChar  , --
    IN inCertificateSeriesNumber    TVarChar  , --
    IN inExpertPrior                TVarChar  , --
    IN inExpertLast                 TVarChar  , --
    IN inQualityNumber              TVarChar  , --
    IN inComment                    TBlob     , --
    IN inQualityId                  Integer   ,
    IN inRetailId                   Integer   , -- Торговая сеть
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate_find TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_QualityParams());


     -- Проверка
     IF COALESCE (inQualityId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Качественное удостоверение>.';
     END IF;

     -- замена
     IF inRetailId > 0
     THEN
         inRetailId:= NULL;
     END IF;

     -- Проверка - в один день может быть только один документ для одного <Качественное удостоверение>
     IF EXISTS (SELECT Movement.OperDate
                FROM Movement
                     INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                                  AND MovementLinkObject.DescId = zc_MovementLinkObject_Quality()
                                                  AND MovementLinkObject.ObjectId = inQualityId
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                                  ON MovementLinkObject_Retail.MovementId = Movement.Id
                                                 AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                WHERE Movement.DescId = zc_Movement_QualityParams()
                  AND Movement.OperDate = inOperDate
                  AND MovementLinkObject_Retail.ObjectId = COALESCE (inRetailId, 0)
                  AND Movement.Id <> COALESCE (ioId, 0))
     THEN
         IF inRetailId <> 0
         THEN RAISE EXCEPTION 'Ошибка.Такое качественное удостоверение <%> за <%> для торговой сети <%> уже существует.Дублирование запрещено.', lfGet_Object_ValueData (inQualityId), DATE (inOperDate), lfGet_Object_ValueData (inRetailId);
         ELSE RAISE EXCEPTION 'Ошибка.Такое качественное удостоверение <%> за <%> уже существует.Дублирование запрещено.', lfGet_Object_ValueData (inQualityId), DATE (inOperDate);
         END IF;
     END IF;

     -- поиск "последней" даты для проверки
     vbOperDate_find:= (SELECT Movement.OperDate
                        FROM Movement
                             INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                                          AND MovementLinkObject.DescId = zc_MovementLinkObject_Quality()
                                                          AND MovementLinkObject.ObjectId = inQualityId
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                                          ON MovementLinkObject_Retail.MovementId = Movement.Id
                                                         AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                        WHERE Movement.DescId = zc_Movement_QualityParams()
                          AND MovementLinkObject_Retail.ObjectId = COALESCE (inRetailId, 0)
                        ORDER BY Movement.OperDate DESC
                        LIMIT 1
                       );
     -- Проверка - новый документ должен быть датой вперед для одного <Качественное удостоверение>
     IF COALESCE (ioId, 0) = 0 AND inOperDate <= vbOperDate_find
     THEN
         IF inRetailId <> 0
         THEN RAISE EXCEPTION 'Ошибка.Новое качественное удостоверение <%> для торговой сети <%> должно быть позже <%>.', lfGet_Object_ValueData (inQualityId), DATE (vbOperDate_find), lfGet_Object_ValueData (inRetailId);
         ELSE RAISE EXCEPTION 'Ошибка.Новое качественное удостоверение <%> должно быть позже <%>.', lfGet_Object_ValueData (inQualityId), DATE (vbOperDate_find);
         END IF;
         
     END IF;


     -- 1. Распроводим Документ
     IF ioId > 0 -- AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_TransportGoods())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_QualityParams(), inInvNumber, inOperDate, NULL);

     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateCertificate(), ioId, inOperDateCertificate);

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateNumber(), ioId, inCertificateNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeries(), ioId, inCertificateSeries);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeriesNumber(), ioId, inCertificateSeriesNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_ExpertPrior(), ioId, inExpertPrior);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_ExpertLast(), ioId, inExpertLast);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_QualityNumber(), ioId, inQualityNumber);

     PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Comment(), ioId, inComment);

     -- сохранили связь с Quality
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Quality(), ioId, inQualityId);
     -- сохранили связь с <Торговая сеть>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailId);

     -- 5.2. проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := ioId
                                , inDescId     := zc_Movement_QualityParams()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.02.15                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_QualityParams (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
