-- Function: gpInsertUpdate_Movement_GoodsQuality()

-- DROP FUNCTION gpInsertUpdate_Movement_GoodsQuality();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_GoodsQuality(
 INOUT ioId                         Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber                  TVarChar  , -- ����� ���������
    IN inOperDate                   TDateTime , -- ���� ���������
    IN inOperDateCertificate        TDateTime , --
    IN inCertificateNumber          TVarChar  , --
    IN inCertificateSeries          TVarChar  , --
    IN inCertificateSeriesNumber    TVarChar  , --
    IN inExpertPrior                TVarChar  , --
    IN inExpertLast                 TVarChar  , --
    IN inQualityNumber              TVarChar  , --
    IN inComment                    TBlob     , --
    IN inQualityId                  Integer   ,
    IN inSession                    TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_GoodsQuality());
     vbUserId := inSession;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_GoodsQuality(), inInvNumber, inOperDate, NULL);

     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateCertificate(), ioId, inOperDateCertificate);

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateNumber(), ioId, inCertificateNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeries(), ioId, inCertificateSeries);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeriesNumber(), ioId, inCertificateSeriesNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_ExpertPrior(), ioId, inExpertPrior);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_ExpertLast(), ioId, inExpertLast);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_QualityNumber(), ioId, inQualityNumber);

     PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Comment(), ioId, inComment);

     -- ��������� ����� � Quality
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Quality(), ioId, inQualityId);




     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.02.15                                                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_GoodsQuality (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
