-- Function: gpInsertUpdate_Movement_QualityNumber (Integer, Integer, TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_QualityNumber (Integer, TVarChar, TDateTime, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);

-- Function: gpinsertupdate_movement_qualitynumber(integer, tvarchar, tdatetime, tvarchar, tvarchar, tdatetime, tvarchar, tvarchar, tvarchar)

-- DROP FUNCTION gpinsertupdate_movement_qualitynumber(integer, tvarchar, tdatetime, tvarchar, tvarchar, tdatetime, tvarchar, tvarchar, tvarchar);

CREATE OR REPLACE FUNCTION gpinsertupdate_movement_qualitynumber(
    INOUT ioid integer,
    IN ininvnumber tvarchar,
    IN inoperdate tdatetime,
    IN inqualitynumber tvarchar,
    IN incertificatenumber tvarchar,
    IN inoperdatecertificate tdatetime,
    IN incertificateseries tvarchar,
    IN incertificateseriesnumber tvarchar,
    IN insession tvarchar)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_QualityNumber());
     vbUserId:= lpGetUserBySession (inSession);


 
     -- ��������
     IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.DescId = zc_Movement_QualityNumber() AND Movement.OperDate = inOperDate AND Movement.Id <> COALESCE (ioId, 0))
     THEN
         RAISE EXCEPTION '������. �� ���� <%> ��� ������ �������� <������������ ������������� (������)>.', DATE (inOperDate);
     END IF;
 
     -- ��������� <��������>
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 16.03.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_QualityNumber (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
