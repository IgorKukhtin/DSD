-- Function: gpInsertUpdate_MI_ReestrStart()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReestrStart (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReestrStart(
  INOUT ioId                  Integer   , -- ���� ������� <��������>
   --OUT outInvNumber           TVarChar  , -- ����� ���������
    IN inBarCode              TVarChar  , 
    IN inOperDate             TDateTime , -- ���� ���������
    IN inCarId                Integer   , -- ����������
    IN inPersonalDriverId     Integer   , -- ��������� (��������)
    IN inMemberId             Integer   , -- ���������� ����(����������)
    IN inDocumentId_Transport Integer   , -- ������� ����/���������� ������� ���������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMIId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Reestr());
     
    IF COALESCE (inBarCode, '') <> '' THEN 

       IF COALESCE (ioId, 0) = 0 THEN 
         -- ���� ��� ������ 
         IF COALESCE (inDocumentId_Transport, 0) <> 0 THEN 
           ioId := ( SELECT MLM_Transport.MovementId AS Id
                     FROM MovementLinkMovement AS MLM_Transport
                     WHERE MLM_Transport.DescId = zc_MovementLinkMovement_Transport()
                       AND MLM_Transport.MovementChildId = inDocumentId_Transport);
         ELSE
           IF COALESCE (inCarId, 0) <> 0 THEN 
              ioId := ( SELECT Movement.Id AS Id
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Car
                                     ON MovementLinkObject_Car.MovementId = Movement.Id
                                    AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                                    AND MovementLinkObject_Car.ObjectId = inCarId
                        WHERE Movement.OperDate = inOperDate  AND Movement.DescId = zc_Movement_Reestr()
                        );
           END IF;
         END IF;

         -- ���� ���.����� �� ������ ������� ����� ��������
         IF COALESCE (outId, 0) = 0 THEN 
            ioId:= lpInsertUpdate_Movement_Reestr (ioId               := 0
                                                 , inInvNumber        := inInvNumber
                                                 , inOperDate         := inOperDate
                                                 , inCarId            := inCarId
                                                 , inPersonalDriverId := inPersonalDriverId
                                                 , inMemberId         := inMemberId
                                                 , inDocumentId_Transport := inDocumentId_Transport
                                                 , inUserId           := vbUserId
                                                 ) AS tmp;
         ELSE
            ioId:= lpInsertUpdate_Movement_Reestr (ioId               := outId
                                                 , inInvNumber        := inInvNumber
                                                 , inOperDate         := inOperDate
                                                 , inCarId            := MovementLinkObject_Car.ObjectId
                                                 , inPersonalDriverId := MovementLinkObject_PersonalDriver.ObjectId
                                                 , inMemberId         := MovementLinkObject_Member.ObjectId
                                                 , inDocumentId_Transport := MovementLinkMovement_Transport.MovementChildId 
                                                 , inUserId           := vbUserId
                                                  ) 
                   FROM Movement
                       LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                                      ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                                     AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                    ON MovementLinkObject_Car.MovementId = Movement.Id
                                                   AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                    ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                                   AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                    ON MovementLinkObject_Member.MovementId = Movement.Id
                                                   AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                   WHERE  Movement.id = outId;
         END IF;
       END IF; 

       -- ��������� <������� ���������>
       vbMIId := lpInsertUpdate_MovementItem (0, zc_MI_Master(), vbUserId, ioId, Null, NULL);
       -- ��������� <����� ������������ ���� "�������� �� ������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbMIId, CURRENT_TIMESTAMP);

       -- ��������� �������� ��������� ������� <� �������� ����� � ������� ���������>
       PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), CAST (inBarCode AS integer), vbMIId);
       -- ��������� ����� � <��������� �� �������>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), zc_Enum_ReestrKind_PartnerOut());

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 22.10.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ReestrStart (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
