-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderClient(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� (�������)
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , --
    IN inDiscountTax         TFloat    , --
    IN inDiscountNextTax     TFloat    , --
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inPaidKindId          Integer   , -- ��
    IN inProductId           Integer   , -- �����
    IN inMovementId_Invoice  Integer, 
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumberPoint Integer;
   DECLARE vbMI_Id Integer;
   DECLARE vbMovementId_Invoice Integer;
   DECLARE vbisComplete_Invoice Boolean;
BEGIN

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderClient(), inInvNumber, inOperDate, NULL, inUserId);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <��>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Product(), ioId, inProductId);

     -- ��������� �������� <���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <% ������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), ioId, inDiscountTax);
     -- ��������� �������� <% ������ ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), ioId, inDiscountNextTax);     

     -- ��������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- ��������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

  --------
 
 /*    --- ������� ����������� ����
     vbMovementId_Invoice := (SELECT MovementLinkMovement.MovementChildId
                              FROM MovementLinkMovement
                              WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                                AND MovementLinkMovement.MovementId = ioId
                              );
     --���� ���� �������� �� ����� � ������ ������� ������ �� ��� �������� 
     IF COALESCE (vbMovementId_Invoice,0) <> COALESCE (inMovementId_Invoice,0) AND COALESCE (vbMovementId_Invoice,0) <> 0
     THEN
         vbisComplete_Invoice := FALSE;
         -- ����������� ��������
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_Invoice AND Movement.StatusId = zc_Enum_Status_Complete())
         THEN
             PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Invoice
                                          , inUserId     := inUserId);
             vbisComplete_Invoice := TRUE;
         END IF;

         PERFORM lpInsertUpdate_Movement (Movement.Id, zc_Movement_Invoice(), Movement.InvNumber, Movement.OperDate, NULL, inUserId)
         FROM Movement
         WHERE Movement.Id = vbMovementId_Invoice
           AND Movement.DescId = zc_Movement_Invoice();

         --���� �������� ���� ��� �������� ����� ��� ��������
         IF vbisComplete_Invoice = TRUE
         THEN
              -- 5.3. �������� ��������
              IF inUserId = lpCheckRight (inUserId ::TVarChar, zc_Enum_Process_Complete_Invoice())
              THEN
                   PERFORM lpComplete_Movement_Invoice (inMovementId := vbMovementId_Invoice
                                                      , inUserId     := inUserId);
              END IF;
         END IF;
     END IF;
  -----------
     -- ��������� ����� � ���������� <����>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);

     --��������� ����� ��������� <����> � ���������� <������> ��������� ParentId � �����
     IF COALESCE (inMovementId_Invoice,0) <> 0
     THEN
         vbisComplete_Invoice := FALSE;
          -- ����������� ��������
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_Invoice AND Movement.StatusId = zc_Enum_Status_Complete())
         THEN
             PERFORM lpUnComplete_Movement (inMovementId := inMovementId_Invoice
                                          , inUserId     := inUserId);
             vbisComplete_Invoice := TRUE;
         END IF;

         PERFORM lpInsertUpdate_Movement (Movement.Id, zc_Movement_Invoice(), Movement.InvNumber, Movement.OperDate, ioId, inUserId)
         FROM Movement
         WHERE Movement.Id = inMovementId_Invoice
           AND Movement.DescId = zc_Movement_Invoice();

         --���� �������� ���� ��� �������� ����� ��� ��������
         IF vbisComplete_Invoice = TRUE
         THEN
              -- 5.3. �������� ��������
              IF inUserId = lpCheckRight (inUserId ::TVarChar, zc_Enum_Process_Complete_Invoice())
              THEN
                   PERFORM lpComplete_Movement_Invoice (inMovementId := inMovementId_Invoice
                                                      , inUserId     := inUserId);
              END IF;
         END IF;
     END IF;
  -----------
*/
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);


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


     IF inProductId > 0
     THEN
         -- ���� ������ ���. � ������, �������  - ��������������, �� ������� �������
         vbMI_Id := (SELECT MovementItem.Id 
                     FROM MovementItem 
                     WHERE MovementItem.MovementId = ioId
                       AND MovementItem.isErased = FALSE
                       AND MovementItem.DescId = zc_MI_Master()
                       AND MovementItem.ObjectId = inProductId
                    );
         -- ��������� ����� � �������� �����
         PERFORM lpInsertUpdate_MovementItem_OrderClient (ioId            := vbMI_Id
                                                        , inMovementId    := ioId
                                                        , inGoodsId       := inProductId
                                                        , inAmount        := 1  ::TFloat
                                                        , ioOperPrice     := gpSelect.Basis_summ
                                                        , inOperPriceList := gpSelect.Basis_summ_orig
                                                        , inCountForPrice := 1  ::TFloat
                                                        , inComment       := '' ::TVarChar
                                                        , inUserId        := inUserId
                                                        )
         FROM gpSelect_Object_Product (FALSE, FALSE, inUserId :: TVarChar) AS gpSelect
         WHERE gpSelect.MovementId_OrderClient = ioId;
     END IF;
                                                      
                                                      
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.02.21         *
 15.02.21         *
*/

-- ����
--