-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer,Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer,Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderClient(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� (�������)
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , --
    IN inDiscountTax         TFloat    , --
    IN inDiscountNextTax     TFloat    , --
 INOUT ioSummTax             TFloat    , -- C���� ������������������ ������, ��� ���
 INOUT ioSummReal            TFloat    , -- ����� ������������������ �����, � ������ ���� ������, ��� ����������, ����� ������� ��� ���
    IN inTransportSumm_load  TFloat    , -- ���������
    IN inTransportSumm       TFloat    , -- ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inPaidKindId          Integer   , -- ��
    IN inTaxKindId           Integer  ,  --
    IN inProductId           Integer   , -- �����
    IN inMovementId_Invoice  Integer,
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumberPoint Integer;
   DECLARE vbMI_Id Integer;
   DECLARE vbMovementId_Invoice Integer;
   DECLARE vbisComplete_Invoice Boolean;
BEGIN
     -- ��������
     IF COALESCE (inFromId, 0) = 0 AND COALESCE (inFromId, 0) <> -1
     THEN
         RAISE EXCEPTION '������.������ ���� ��������� <Kunden>(%).', inFromId;
     END IF;

     -- ��������
     IF COALESCE (inVATPercent, 0) <> COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                 FROM ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 WHERE ObjectFloat_TaxKind_Value.ObjectId = inTaxKindId
                                                   AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()
                                                ), 0)
     THEN
         RAISE EXCEPTION '������.�������� <% ���> � ��������� �� ������������� �������� <��� ���>.', '%' ;
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderClient(), inInvNumber, inOperDate, NULL, inUserId);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� ����� � <�� ���� (� ���������)>
     IF COALESCE (inFromId, 0) <> -1 THEN PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId); END IF;
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <��>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Product(), ioId, inProductId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_TaxKind(), ioId, inTaxKindId);

     -- ��������� �������� <���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <% ������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), ioId, inDiscountTax);
     -- ��������� �������� <% ������ ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), ioId, inDiscountNextTax);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm_load(), ioId, inTransportSumm_load);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm(), ioId, inTransportSumm);
     
     -- ��������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- ��������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� ����� � ���������� <����>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);

     IF vbIsInsert = TRUE AND inProductId > 0
     THEN
         -- ��������� ����� �������� <NPP>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), ioId
                                             , 1 + COALESCE ((SELECT MAX (COALESCE (MovementFloat.ValueData, 0))
                                                              FROM MovementFloat
                                                                   INNER JOIN Movement ON Movement.Id     = MovementFloat.MovementId
                                                                                      AND Movement.DescId = zc_Movement_OrderClient()
                                                                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                              WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                                                             ), 0));

         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateBegin(), inProductId, inOperDate + INTERVAL '3 MONTH');

     END IF;

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

         IF EXISTS (SELECT 1 FROM gpSelect_Object_Product (ioId, FALSE, FALSE, inUserId :: TVarChar) AS gpSelect WHERE gpSelect.MovementId_OrderClient = ioId AND gpSelect.Basis_summ > 0)
         THEN
             -- ��������� ����� � �������� �����
             vbMI_Id:= (WITH gpSelect AS (SELECT gpSelect.Basis_summ_pl, gpSelect.Basis_summ_orig_pl, gpSelect.Basis_summ1_orig_pl
                                          FROM gpSelect_Object_Product (ioId, FALSE, FALSE, inUserId :: TVarChar) AS gpSelect
                                          WHERE gpSelect.MovementId_OrderClient = ioId
                                         )
                        -- ���������
                        SELECT tmp.ioId
                        FROM lpInsertUpdate_MovementItem_OrderClient (ioId            := vbMI_Id
                                                                    , inMovementId    := ioId
                                                                    , inGoodsId       := inProductId
                                                                    , inAmount        := COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = vbMI_Id), 1)
                                                                      -- ����� ����� ������� ��� ��� - �� ����� �������� (Basis+options)
                                                                    , ioOperPrice     := (SELECT gpSelect.Basis_summ_pl       FROM gpSelect)
                                                                      -- ����� ����� ������� ��� ��� - ��� ������ (Basis+options)
                                                                    , inOperPriceList := (SELECT gpSelect.Basis_summ_orig_pl  FROM gpSelect)
                                                                      -- ����� ����� ������� ��� ��� - ��� ������ (Basis)
                                                                    , inBasisPrice    := (SELECT gpSelect.Basis_summ1_orig_pl FROM gpSelect)
                                                                      --
                                                                    , inCountForPrice := 1  ::TFloat
                                                                    , inComment       := COALESCE ((SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbMI_Id AND MIS.DescId = zc_MIString_Comment()), '')
                                                                    , inUserId        := inUserId
                                                                     ) AS tmp
                       );
             -- ��������� ��������
             PERFORM lpInsert_MovementItemProtocol (vbMI_Id, inUserId, vbIsInsert);

         END IF;


         -- ����������� �������� �����
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (ioId);


         -- ������ ����� !!!���������!!!
         /*IF ioSummReal > 0
         THEN
             ioSummTax:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_TotalSumm()), 0)
                       - ioSummReal
                        ;
         ELSE
             ioSummReal:= 0;
         END IF;*/
         
         ioSummReal:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_TotalSumm()), 0) - ioSummTax; 

         -- ��������� �������� <C���� ������������������ ������, ��� ���>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTax(), ioId, ioSummTax);
         -- ��������� �������� <����� ������������������ �����, � ������ ���� ������, ��� ����������, ����� ������� ��� ���>
         --PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReal(), ioId, ioSummReal);  --���������

     ELSE
         -- ����������� �������� ����� �� ���������
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (ioId);

     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.04.24         * inTransportSumm
 16.03.24         *
 01.06.23         * inTransportSumm_load
 15.05.23         *
 23.02.21         *
 15.02.21         *
*/

-- ����
--