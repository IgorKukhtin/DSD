-- Function: gpInsertUpdate_Movement_QualityDoc_byTransport ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_QualityDoc_byTransport (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_QualityDoc_byTransport(
    IN inMovementId_Sale               Integer  , --
    IN inMovementId_QualityDoc         Integer  ,
   OUT outMovementId_QualityDoc        Integer  ,
    IN inMovementId_Transport          Integer  ,
    IN inSession                       TVarChar    -- сессия пользователя

)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId       Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     --проверка 
     IF COALESCE (inMovementId_Transport,0) = 0
     THEN   
          RAISE EXCEPTION 'Ошибка. Не выбран документ Путевого листа'; 
     END IF;

     -- если нет ТТН - создаем
     outMovementId_QualityDoc:= 
                              gpInsertUpdate_Movement_QualityDoc (ioId                     := tmpQualityDoc.Id
                                                                , inMovementId_Sale        := inMovementId_Sale
                                                                , inOperDateIn             := tmpQualityDoc.OperDateIn
                                                                , inOperDateOut            := tmpQualityDoc.OperDateOut
                                                                , inCarId                  := (SELECT MLO.ObjectId                      --машина з Шляхового листа
                                                                                               FROM MovementLinkObject AS MLO
                                                                                               WHERE MLO.MovementId = inMovementId_Transport
                                                                                                 AND MLO.DescId = zc_MovementLinkObject_Car()
                                                                                               )
                                                                , inQualityNumber          := tmpQualityDoc.QualityNumber
                                                                , inCertificateNumber      := tmpQualityDoc.CertificateNumber
                                                                , inOperDateCertificate    := tmpQualityDoc.OperDateCertificate
                                                                , inCertificateSeries      := tmpQualityDoc.CertificateSeries
                                                                , inCertificateSeriesNumber:= tmpQualityDoc.CertificateSeriesNumber
                                                                , inSession                := inSession
                                                                 )
                              FROM gpGet_Movement_QualityDoc (inMovementId      := inMovementId_QualityDoc :: Integer  
                                                            , inMovementId_Sale := inMovementId_Sale  :: Integer
                                                            , inSession         := inSession) AS tmpQualityDoc     
                        ;

   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION 'Тест. Ок. <%>', outMovementId_QualityDoc; 
   END IF;   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.10.23         *
*/

-- тест
--