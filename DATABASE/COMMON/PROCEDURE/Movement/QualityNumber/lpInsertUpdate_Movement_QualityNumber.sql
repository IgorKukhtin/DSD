-- Function: lpInsertUpdate_Movement_QualityNumber (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_QualityNumber (Integer, TVarChar, TDateTime, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpinsertupdate_movement_qualitynumber(
    INOUT ioid integer,
    IN ininvnumber tvarchar,
    IN inoperdate tdatetime,
    IN inqualitynumber tvarchar,
    IN incertificatenumber tvarchar,
    IN inoperdatecertificate tdatetime,
    IN incertificateseries tvarchar,
    IN incertificateseriesnumber tvarchar,
    IN inuserid integer)
  RETURNS integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
   
     -- 1. Распроводим Документ
     IF ioId > 0
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := inUserId);
     END IF;


      -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_QualityNumber(), inInvNumber, inOperDate, NULL, vbAccessKeyId
                                     );

     -- сохранили свойства
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateCertificate(), ioId, inOperDateCertificate);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateNumber(), ioId, inCertificateNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeries(), ioId, inCertificateSeries);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeriesNumber(), ioId, inCertificateSeriesNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_QualityNumber(), ioId, inQualityNumber);


     -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := ioId
                                , inDescId     := zc_Movement_QualityNumber()
                                , inUserId     := inUserId
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
-- SELECT * FROM lpInsertUpdate_Movement_QualityNumber (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
