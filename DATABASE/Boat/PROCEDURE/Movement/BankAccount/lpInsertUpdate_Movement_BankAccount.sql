-- Function: lpInsertUpdate_movement_BankAccount

DROP FUNCTION IF EXISTS lpInsertUpdate_movement_BankAccount(Integer, TVarChar, TVarChar, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_movement_BankAccount(
  INOUT ioId                   Integer, 
     IN inInvNumber            TVarChar, 
     IN inInvNumberPartner     TVarChar  , -- ����� ��������� (�������)
     IN inOperDate             TDateTime, 
     IN inAmount               TFloat, 
     IN inBankAccountId        Integer, 
     IN inMoneyPlaceId         Integer, 
     IN inMovementId_Invoice     Integer, 
     IN inComment              TVarChar, 
     IN inuserid               Integer)
  RETURNS Integer AS
$BODY$
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
/*
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inBankAccountId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ���������� �������� <��������� ����>.';
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inMoneyPlaceId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ���������� �������� <Lieferanten / Kunden>.';
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inMovementId_Invoice, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ���������� �������� <����>.';
     END IF;
      */

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankAccount(), inInvNumber, inOperDate, NULL, inUserId);
     -- ���������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner); 
     -- ��������� ����� � ���������� <����>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);


     -- ����� <������� ���������>
     vbMovementItemId:= (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master());

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inBankAccountId, NULL, ioId, inAmount, NULL);

     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);

     -- ����������
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);


     -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);


     -- ���������
     IF NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE)
        OR (1 = (SELECT COUNT(*) FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE)
        AND inMovementId_Invoice > 0
           )
     THEN
         PERFORM lpInsertUpdate_MI_BankAccount_Child (ioId                  := COALESCE ((SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE), 0)
                                                    , inParentId            := vbMovementItemId
                                                    , inMovementId          := ioId
                                                    , inMovementId_invoice  := inMovementId_Invoice
                                                    , inObjectId            := CASE WHEN inMoneyPlaceId > 0 THEN inMoneyPlaceId ELSE inBankAccountId END
                                                    , inAmount              := inAmount
                                                    , inComment             := ''
                                                    , inUserId              := inUserId
                                                     );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.02.21         * 
*/

-- ����
--
