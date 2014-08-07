-- Function: gpInsertUpdate_Movement_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIComdoc (TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDIComdoc(
    IN inOrderInvNumber      TVarChar  , -- ����� ������ �����������
    IN inOrderOperDate       TDateTime , -- ���� ������ �����������
    IN inPartnerInvNumber    TVarChar  , -- ����� ��������� � �����������
    IN inPartnerOperDate     TDateTime , -- ���� ��������� � �����������
    IN inInvNumberTax        TVarChar  , -- ����� ��������� � �����������
    IN inOperDateTax         TDateTime , -- ���� ��������� � �����������
    IN inOKPO                TVarChar  , -- 
    IN inJurIdicalName       TVarChar  , --
    IN inDesc                TVarChar  , -- ��� ���������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (MovementId Integer, GoodsPropertyId Integer) -- ������������� �������
AS
$BODY$
   DECLARE vbMovementId      Integer;
   DECLARE vbGoodsPropertyId Integer;

   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
   DECLARE vbDescCode TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDIComdoc());
     vbUserId:= lpGetUserBySession (inSession);

     -- ����� ��������� � ������� EDI
     vbMovementId:= (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementString AS MovementString_OKPO
                                                    ON MovementString_OKPO.MovementId =  Movement.Id
                                                   AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                   AND MovementString_OKPO.ValueData = inOKPO
                     WHERE Movement.DescId = zc_Movement_EDI() 
                       AND Movement.InvNumber = inOrderInvNumber
                       AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                    );

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementId, 0) = 0;

     IF COALESCE (vbMovementId, 0) = 0
     THEN
          -- ��������� <��������>
          vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
          -- ��������� <����>
          PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), vbMovementId, inOKPO);

     END IF;

     -- ���������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), vbMovementId, inPartnerOperDate);
     -- ���������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), vbMovementId, inPartnerInvNumber);

     -- ���������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateTax(), vbMovementId, inOperDateTax);
     -- ���������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberTax(), vbMovementId, inInvNumberTax);

     -- ���������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_JurIdicalName(), vbMovementId, inJurIdicalName);

     IF inDesc = 'Sale' THEN
        SELECT MovementDesc.Code INTO vbDescCode FROM MovementDesc WHERE Id = zc_Movement_Sale();
     ELSE
        SELECT MovementDesc.Code INTO vbDescCode FROM MovementDesc WHERE Id = zc_Movement_ReturnIn();
     END IF;   

     -- ���������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, vbDescCode);

     -- ��������� ��������� ���������
     vbGoodsPropertyId:= lpUpdate_Movement_EDIComdoc_Params (inMovementId    := vbMovementId
                                                           , inSaleOperDate  := inPartnerOperDate
                                                           , inOrderInvNumber:= inOrderInvNumber
                                                           , inOKPO          := inOKPO
                                                           , inUserId        := vbUserId);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

     -- ��������� ��������
     PERFORM lpInsert_Movement_EDIEvents (vbMovementId, '�������� COMDOC �� EDI', vbUserId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, vbIsInsert);

     -- ���������
     RETURN QUERY 
     SELECT vbMovementId, vbGoodsPropertyId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.07.14                                        * ALL
 29.05.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
