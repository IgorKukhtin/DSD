-- Function: lpUpdate_Movement_EDIComdoc_Params()

DROP FUNCTION IF EXISTS lpUpdate_Movement_EDIComdoc_Params (Integer, TDateTime, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_EDIComdoc_Params(
    IN inMovementId      Integer   , --
    IN inSaleOperDate    TDateTime , -- ���� ��������� � �����������
    IN inOrderInvNumber  TVarChar  , -- ����� ������ �����������
    IN inOKPO            TVarChar  , -- 
    IN inUserId          Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbMovementId_Sale Integer;
   DECLARE vbMovementId_Tax  Integer;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbJurIdicalId     Integer;
   DECLARE vbPriceWithVAT    Boolean;
   DECLARE vbVATPercent      TFloat;
BEGIN
     -- !!!����������!!!
     vbPriceWithVAT:= FALSE;
     vbVATPercent  := 20;


     IF (inOKPO <> '')
     THEN
         -- ����� �� ���� �� ����
         vbJurIdicalId := (SELECT JurIdicalId FROM ObjectHistory_JurIdicalDetails_View WHERE OKPO = inOKPO);

         -- ����� �������������� �������
         vbGoodsPropertyId := (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_JurIdical_GoodsProperty() AND ObjectId = vbJurIdicalId);

     END IF;


     -- ����� ��������� <������� ����������> � <��������� ���������>
     SELECT Movement.Id, Movement_DocumentMaster.Id
            INTO vbMovementId_Sale, vbMovementId_Tax
     FROM MovementString AS MovementString_InvNumberOrder
          INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                  ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberOrder.MovementId
                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                 AND MovementDate_OperDatePartner.ValueData = inSaleOperDate
          INNER JOIN Movement ON Movement.Id = MovementString_InvNumberOrder.MovementId
                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                             AND Movement.DescId = zc_Movement_Sale()

          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          INNER JOIN ObjectLink AS ObjectLink_Partner_JurIdical
                                ON ObjectLink_Partner_JurIdical.ObjectId = MovementLinkObject_To.ObjectId
                               AND ObjectLink_Partner_JurIdical.DescId = zc_ObjectLink_Partner_JurIdical()
          INNER JOIN ObjectHistory_JurIdicalDetails_View AS ViewHistory_JurIdicalDetails
                                                         ON ViewHistory_JurIdicalDetails.JurIdicalId = ObjectLink_Partner_JurIdical.ChildObjectId
                                                        AND ViewHistory_JurIdicalDetails.OKPO = inOKPO
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementId = Movement.Id
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                       AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
     WHERE MovementString_InvNumberOrder.ValueData = inOrderInvNumber
       AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder();


     -- ��������� ��������� ���������
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_JurIdical(), inMovementId, vbJurIdicalId);
     -- ���������
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), inMovementId, vbGoodsPropertyId);

     IF vbMovementId_Sale <> 0
     THEN
         -- ��������� ����� � <������� ����������>
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Sale(), vbMovementId_Sale, inMovementId);
     END IF;

     IF vbMovementId_Tax <> 0
     THEN
         -- ��������� ����� � <��������� ���������>
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Tax(), vbMovementId_Tax, inMovementId);
     END IF;

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), inMovementId, vbPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inMovementId, vbVATPercent);

     -- ���������
     RETURN vbGoodsPropertyId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.07.14                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_Movement_EDIComdoc_Params (inMovementId:= 0, inOrderInvNumber:= '-1', inOKPO:= 1, inUserId:= 2)
