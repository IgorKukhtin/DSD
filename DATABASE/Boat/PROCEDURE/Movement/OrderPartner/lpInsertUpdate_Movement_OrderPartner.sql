-- Function: gpInsertUpdate_Movement_OrderPartner()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderPartner (Integer, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat
                                                            , Integer, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderPartner(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� (�������)
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , --
    IN inDiscountTax         TFloat    , --
    IN inDiscountNextTax     TFloat    , --
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inPaidKindId          Integer   , -- ��
    IN inMovementId_Invoice  Integer, 
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId_Invoice Integer;
   DECLARE vbisComplete_Invoice Boolean;
BEGIN
     -- ��������
     IF COALESCE (inToId, 0) = 0
     THEN
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ���� ��������� <Lieferanten>.' :: TVarChar
                                               , inProcedureName := 'lpInsertUpdate_Movement_OrderPartner'
                                               , inUserId        := vbUserId
                                                );
     END IF;

     -- ��������
     IF COALESCE (inVATPercent, 0) <> COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                 FROM ObjectLink AS OL_Partner_TaxKind
                                                      LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                                            ON ObjectFloat_TaxKind_Value.ObjectId = OL_Partner_TaxKind.ChildObjectId 
                                                                           AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()   
                                                 WHERE OL_Partner_TaxKind.ObjectId = inToId
                                                   AND OL_Partner_TaxKind.DescId   = zc_ObjectLink_Partner_TaxKind()
                                                ), 0)
     THEN
         RAISE EXCEPTION '������.�������� <% ���> � ��������� = <%> �� ������������� �������� � ���������� = <%>.'
                       , '%'
                       , zfConvert_FloatToString (inVATPercent)
                       , zfConvert_FloatToString (COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                             FROM ObjectLink AS OL_Partner_TaxKind
                                                                  LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                                                        ON ObjectFloat_TaxKind_Value.ObjectId = OL_Partner_TaxKind.ChildObjectId 
                                                                                       AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()   
                                                             WHERE OL_Partner_TaxKind.ObjectId = inToId
                                                               AND OL_Partner_TaxKind.DescId   = zc_ObjectLink_Partner_TaxKind()
                                                            ), 0))
                        ;
     END IF;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderPartner(), inInvNumber, inOperDate, NULL, inUserId);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <��>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

     -- ��������� �������� <���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <% ������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), ioId, inDiscountTax);
     -- ��������� �������� <% ������ ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), ioId, inDiscountNextTax);     

     -- 
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- ��������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- ��������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

  --------

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


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     --- ������� ����������� ����
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

     -- ��������� ����� � ���������� <����>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);

     --��������� ����� ��������� <����> � ���������� <����� ����������> ��������� ParentId � �����
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


     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);                                        
                                                      
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.06.21         *
 12.04.21         *
*/

-- ����
--