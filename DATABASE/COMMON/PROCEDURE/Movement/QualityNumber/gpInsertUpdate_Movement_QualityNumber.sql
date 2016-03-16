-- Function: gpInsertUpdate_Movement_QualityNumber (Integer, Integer, TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_QualityNumber (Integer, TVarChar, TDateTime, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_QualityNumber(
 INOUT ioId                         Integer   , -- Ключ объекта <Документ>
    IN inInvNumber                  TVarChar  , -- Номер документа
    IN inOperDate                   TDateTime , -- Дата документа
    IN inQualityNumber              TVarChar  , --
    IN inCertificateNumber          TVarChar  , --
    IN inOperDateCertificate        TDateTime , --
    IN inCertificateSeries          TVarChar  , --
    IN inCertificateSeriesNumber    TVarChar  , --
    IN inSession                    TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_QualityNumber());
     vbUserId:= lpGetUserBySession (inSession);


 
    -- проверка
     IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.DescId = zc_Movement_QualityNumber() and Movement.OperDate = inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка. За дату <%> уже создан документ <Качественное удостоверение (номера)>.', inOperDate ::Date ;
     END IF;
 
     -- сохранили <Документ>
     ioId :=lpInsertUpdate_Movement_QualityNumber (ioId  
                                                 , inInvNumber              := inInvNumber
                                                 , inOperDate               := inOperDate              
                                                 , inQualityNumber          := inQualityNumber
                                                 , inCertificateNumber      := inCertificateNumber
                                                 , inOperDateCertificate    := inOperDateCertificate
                                                 , inCertificateSeries      := inCertificateSeries
                                                 , inCertificateSeriesNumber:= inCertificateSeriesNumber
                                                 , inUserId                 := vbUserId
                                                   );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.03.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_QualityNumber (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
