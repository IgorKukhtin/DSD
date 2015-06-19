-- Function: lpInsertUpdate_Movement_QualityDoc (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_QualityDoc (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_QualityDoc (Integer, Integer, Integer, TDateTime, TDateTime, Integer, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_QualityDoc(
 INOUT ioId                         Integer   , -- ���� ������� <��������>
    IN inMovementId_master          Integer   , -- 
    IN inMovementId_child           Integer   , -- 
    IN inOperDateIn                 TDateTime , -- ���� � ��� ������������
    IN inOperDateOut                TDateTime , -- ���� ������������
    IN inCarId                      Integer   , -- ����������
    IN inQualityNumber              TVarChar  , --
    IN inCertificateNumber          TVarChar  , --
    IN inOperDateCertificate        TDateTime , --
    IN inCertificateSeries          TVarChar  , --
    IN inCertificateSeriesNumber    TVarChar  , --
    IN inUserId                     Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- ���������� ���� ������� and OperDate
     IF inMovementId_child <> 0
     THEN
         -- �������� ������������� inMovementId_child
         vbAccessKeyId:= (SELECT Movement.AccessKeyId FROM Movement WHERE Movement.Id = inMovementId_child);
         -- ���� ������������� inMovementId_child
         vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_child);
     END IF;

     -- ��������
     IF COALESCE (inMovementId_master, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� <� ���. ������������ ������������� - ���������>.';
     END IF;
     -- ��������
     IF COALESCE (inMovementId_child, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� <� ���. (�����)>.';
     END IF;


     -- 1. ����������� ��������
     IF ioId > 0
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := inUserId);
     END IF;


      -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId
                                    , zc_Movement_QualityDoc()
                                      -- ����� ��� ��� ��� ��� ��� +1
                                    , CASE WHEN ioId <> 0 THEN (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId) ELSE CAST (NEXTVAL ('movement_qualitydoc_seq') AS TVarChar) END
                                    , vbOperDate
                                    , NULL
                                    , vbAccessKeyId
                                     );

     -- ��������� �������� <���� � ��� ������������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateIn(), ioId, inOperDateIn);
     -- ��������� �������� <���� ������������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateOut(), ioId, inOperDateOut);

     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Car(), ioId, inCarId);

     -- ���������� �����
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), ioId, inMovementId_master);
     -- ���������� �����
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), ioId, inMovementId_child);

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateCertificate(), ioId, inOperDateCertificate);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateNumber(), ioId, inCertificateNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeries(), ioId, inCertificateSeries);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeriesNumber(), ioId, inCertificateSeriesNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_QualityNumber(), ioId, inQualityNumber);


     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := ioId
                                , inDescId     := zc_Movement_QualityDoc()
                                , inUserId     := inUserId
                                 );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.05.15         * add...
 22.05.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_QualityDoc (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
