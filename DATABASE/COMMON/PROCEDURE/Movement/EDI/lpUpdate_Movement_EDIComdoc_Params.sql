-- Function: lpUpdate_Movement_EDIComdoc_Params()

DROP FUNCTION IF EXISTS lpUpdate_Movement_EDIComdoc_Params (Integer, TDateTime, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Movement_EDIComdoc_Params (Integer, TDateTime, TVarChar, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_EDIComdoc_Params(
    IN inMovementId       Integer   , --
    IN inPartnerOperDate  TDateTime , -- ���� ��������� � �����������
    IN inPartnerInvNumber TVarChar  , -- ����� ��������� � �����������
    IN inOrderInvNumber   TVarChar  , -- ����� ������ �����������
    IN inOKPO             TVarChar  , -- 
    IN inUserId           Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbMovementId_Master Integer;
   DECLARE vbMovementId_Child  Integer;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbJuridicalId     Integer;
   DECLARE vbPriceWithVAT    Boolean;
   DECLARE vbVATPercent      TFloat;
BEGIN
     -- !!!����������!!!
     vbPriceWithVAT:= FALSE;
     vbVATPercent  := 20;


     IF (inOKPO <> '')
     THEN
         -- ����� �� ���� �� ����
         vbJuridicalId := (SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_View WHERE OKPO = inOKPO);

         -- ����� �������������� �������
         vbGoodsPropertyId := (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Juridical_GoodsProperty() AND ObjectId = vbJuridicalId);

     END IF;


     -- !!!��� ��� �������!!!
     IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_Sale() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
     THEN
         -- ����� ��������� <������� ����������> � <��������� ���������>
         SELECT Movement.Id, Movement_DocumentMaster.Id
                INTO vbMovementId_Master, vbMovementId_Child
         FROM MovementString AS MovementString_InvNumberOrder
              INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberOrder.MovementId
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                     AND MovementDate_OperDatePartner.ValueData = inPartnerOperDate
              INNER JOIN Movement ON Movement.Id = MovementString_InvNumberOrder.MovementId
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 AND Movement.DescId = zc_Movement_Sale()

              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
              INNER JOIN ObjectHistory_JuridicalDetails_View AS ViewHistory_JuridicalDetails
                                                             ON ViewHistory_JuridicalDetails.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                            AND ViewHistory_JuridicalDetails.OKPO = inOKPO
              LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                             ON MovementLinkMovement_Master.MovementId = Movement.Id
                                            AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
              LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                           AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
         WHERE MovementString_InvNumberOrder.ValueData = inOrderInvNumber
           AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder();

         --
         IF vbMovementId_Master <> 0
         THEN
             -- ��������� ����� � <������� ����������> !!!������ ��������!!!
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Sale(), vbMovementId_Master, inMovementId);
         END IF;

         IF vbMovementId_Child <> 0
         THEN
             -- ��������� ����� � <��������� ���������> !!!������ ��������!!!
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Tax(), vbMovementId_Child, inMovementId);
         END IF;

         -- ������� ����� � <������� ����������> !!!������ ��������!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_MasterEDI() AND MovementChildId = inMovementId;
         -- ������� ����� � <������������� � ��������� ���������> !!!������ ��������!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_ChildEDI() AND MovementChildId = inMovementId;

     END IF;


     -- !!!��� ��� ��������!!!
     IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_ReturnIn() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
     THEN
         -- ����� ��������� <������� ����������> � <������������� � ��������� ���������>
         SELECT Movement.Id, Movement_DocumentMaster.Id
                INTO vbMovementId_Master, vbMovementId_Child
         FROM MovementString AS MovementString_InvNumberPartner
              INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberPartner.MovementId
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                     AND MovementDate_OperDatePartner.ValueData = inPartnerOperDate
              INNER JOIN Movement ON Movement.Id = MovementString_InvNumberPartner.MovementId
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 AND Movement.DescId = zc_Movement_ReturnIn()

              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
              INNER JOIN ObjectHistory_JuridicalDetails_View AS ViewHistory_JuridicalDetails
                                                             ON ViewHistory_JuridicalDetails.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                            AND ViewHistory_JuridicalDetails.OKPO = inOKPO
              LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                             ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                            AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
              LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementId
                                                           AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
         WHERE MovementString_InvNumberPartner.ValueData = inPartnerInvNumber
           AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner();

         --
         IF vbMovementId_Master <> 0
         THEN
             -- ��������� ����� � <������� ����������> !!!������ ��������!!!
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_MasterEDI(), vbMovementId_Master, inMovementId);
         END IF;

         IF vbMovementId_Child <> 0
         THEN
             -- ��������� ����� � <������������� � ��������� ���������> !!!������ ��������!!!
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_ChildEDI(), vbMovementId_Child, inMovementId);
         END IF;

         -- ������� ����� � <������� ����������> !!!������ ��������!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_Sale() AND MovementChildId = inMovementId;
         -- ������� ����� � <��������� ���������> !!!������ ��������!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_Tax() AND MovementChildId = inMovementId;


     END IF;


     -- ��������� <�� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), inMovementId, vbJuridicalId);
     -- ��������� <�������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), inMovementId, vbGoodsPropertyId);

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
 07.08.14                                        * add !!!��� ��� ��������!!!
 31.07.14                                        * add !!!��� ��� �������!!!
 20.07.14                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_Movement_EDIComdoc_Params (inMovementId:= 0, inOrderInvNumber:= '-1', inOKPO:= 1, inUserId:= 2)
