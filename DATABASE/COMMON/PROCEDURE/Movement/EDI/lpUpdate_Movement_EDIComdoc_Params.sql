-- Function: lpUpdate_Movement_EDIComdoc_Params()

DROP FUNCTION IF EXISTS lpUpdate_Movement_EDIComdoc_Params (Integer, TDateTime, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Movement_EDIComdoc_Params (Integer, TDateTime, TVarChar, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Movement_EDIComdoc_Params (Integer, TDateTime, TVarChar, TVarChar, TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_EDIComdoc_Params(
    IN inMovementId       Integer   , --
    IN inPartnerOperDate  TDateTime , -- ���� ��������� � �����������
    IN inPartnerInvNumber TVarChar  , -- ����� ��������� � �����������
    IN inOrderInvNumber   TVarChar  , -- ����� ������ �����������
    IN inOKPO             TVarChar  , -- 
    IN inIsCheck          Boolean   , -- 
    IN inUserId           Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbPartnerId         Integer;
   DECLARE vbGLNPlace          TVarChar;
   DECLARE vbInvNumberSaleLink TVarChar;
   DECLARE vbOperDateSaleLink  TDateTime;

   DECLARE vbMovementId_Master Integer;
   DECLARE vbMovementId_Child  Integer;
   DECLARE vbGoodsPropertyId   Integer;
   DECLARE vbJuridicalId       Integer;
   DECLARE vbContractId        Integer;
   DECLARE vbPriceWithVAT      Boolean;
   DECLARE vbVATPercent        TFloat;
BEGIN
     -- !!!����������!!!
     vbPriceWithVAT:= FALSE;
     vbVATPercent  := 20;


     -- !!!��� ��� �������!!!
     IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_Sale() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
     THEN

         -- ����� GLN ����� ��������
         vbGLNPlace:= (SELECT MovementString.ValueData FROM MovementString WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_GLNPlaceCode());
         -- ��������
         IF 1=1 AND inIsCheck = TRUE AND COALESCE (vbGLNPlace, '') = ''
         THEN
             RAISE EXCEPTION '������.�� ���������� <GLN ����� ��������> � ��������� EDI � <%> �� <%> (%).', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId)), inMovementId;
         END IF;
         -- ��������
         IF inPartnerOperDate IS NULL
         THEN
             RAISE EXCEPTION '������.�� ����������� <���� ��������� (EDI)> � ��������� EDI � <%> �� <%> (%).', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId)), inMovementId;
         END IF;

         -- �������� ��������, ��� ���������� ����������
         IF COALESCE (vbGLNPlace, '') = '' AND inOrderInvNumber <> ''
         THEN
             IF inUserId = 5 
                AND 1 < (SELECT COUNT(*)
                         FROM MovementString AS MovementString_InvNumberOrder
                              INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberOrder.MovementId
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                     AND MovementDate_OperDatePartner.ValueData BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                              INNER JOIN Movement ON Movement.Id = MovementString_InvNumberOrder.MovementId
                                                 AND Movement.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                                                 AND Movement.DescId = zc_Movement_Sale()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                              INNER JOIN ObjectString ON ObjectString.ObjectId = MovementLinkObject_To.ObjectId
                                                     AND ObjectString.DescId = zc_ObjectString_Partner_GLNCode()
                                                     AND ObjectString.ValueData <> ''
                         WHERE MovementString_InvNumberOrder.ValueData = inOrderInvNumber
                           AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                        )
             THEN
                  RAISE EXCEPTION '������.vbGLNPlace = <%> %<%> %<%>.'
                                 , vbGLNPlace
                                 , CHR (13), inOrderInvNumber
                                 , CHR (13), inPartnerOperDate
                                  ;
             END IF;

             -- ����� GLN ����� �������� �� ��������� �������
             vbGLNPlace:= (SELECT ObjectString.ValueData
                           FROM MovementString AS MovementString_InvNumberOrder
                                INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                        ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberOrder.MovementId
                                                       AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                       AND MovementDate_OperDatePartner.ValueData BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                                INNER JOIN Movement ON Movement.Id = MovementString_InvNumberOrder.MovementId
                                                   AND Movement.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                                                   AND Movement.DescId = zc_Movement_Sale()
                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                INNER JOIN ObjectString ON ObjectString.ObjectId = MovementLinkObject_To.ObjectId
                                                       AND ObjectString.DescId = zc_ObjectString_Partner_GLNCode()
                                                       AND ObjectString.ValueData <> ''
                           WHERE MovementString_InvNumberOrder.ValueData = inOrderInvNumber
                             AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                           GROUP BY ObjectString.ValueData
                          );
             -- ��������� ��� GLN - ����� �������� � ��������� EDI
             IF vbGLNPlace <> ''
             THEN
                 PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNPlaceCode(), inMovementId, vbGLNPlace);
             END IF;

         END IF; -- if COALESCE (vbGLNPlace, '') = ''

         -- ������ ���� ���������� ������� � ������� ������
         IF   TRIM (inOrderInvNumber) <> ''
          AND EXISTS (SELECT Movement.Id
                    FROM MovementString AS MovementString_InvNumberOrder
                         INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                 ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberOrder.MovementId
                                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                AND MovementDate_OperDatePartner.ValueData BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                         INNER JOIN Movement ON Movement.Id = MovementString_InvNumberOrder.MovementId
                                            AND Movement.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                                            AND Movement.DescId = zc_Movement_Sale()
                    WHERE MovementString_InvNumberOrder.ValueData = inOrderInvNumber
                      AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                   )
         THEN
             -- ����� ����� ��������
             vbPartnerId:= (SELECT MIN (ObjectString.ObjectId) FROM ObjectString WHERE ObjectString.DescId = zc_ObjectString_Partner_GLNCode() AND ObjectString.ValueData = vbGLNPlace);
             -- ��������
             IF COALESCE (vbPartnerId, 0) = 0 AND vbGLNPlace <> ''
             THEN
                 RAISE EXCEPTION '������.�� ������ ���������� �� ��������� <GLN ����� ��������> = <%> � ��������� EDI � <%> �� <%> (%) (%).', vbGLNPlace, (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId)), vbPartnerId, inMovementId;
             END IF;
         END IF;

         -- ����� ������ ����������
         vbInvNumberSaleLink:= (SELECT MovementString.ValueData FROM MovementString WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_InvNumberSaleLink());
         vbOperDateSaleLink:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDateSaleLink());

         -- !!!��� �� vbInvNumberSaleLink + inGLNPlace, �.�. �� ������ ����� ��������� + ����� ��������!!!
         IF vbInvNumberSaleLink <> ''
         THEN
             -- ����� ��������� <������� ����������> � <��������� ���������>
             SELECT Movement.Id, Movement_DocumentMaster.Id, MovementLinkObject_Contract.ObjectId
                    INTO vbMovementId_Master, vbMovementId_Child, vbContractId
             FROM Movement
                  INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                          ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                         AND MovementDate_OperDatePartner.ValueData BETWEEN (vbOperDateSaleLink - (INTERVAL '0 DAY')) AND (vbOperDateSaleLink + (INTERVAL '0 DAY'))
                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                               AND MovementLinkObject_To.ObjectId IN (SELECT ObjectString.ObjectId FROM ObjectString WHERE ObjectString.DescId = zc_ObjectString_Partner_GLNCode() AND ObjectString.ValueData = vbGLNPlace) -- vbPartnerId
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
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             WHERE Movement.InvNumber = vbInvNumberSaleLink
               AND Movement.StatusId = zc_Enum_Status_Complete()
               AND Movement.DescId = zc_Movement_Sale();

             -- �������� - ������ �����
             IF 1 = 1 AND inIsCheck = TRUE AND COALESCE (vbMovementId_Master, 0) = 0
             THEN
                  RAISE EXCEPTION '������.%�� ������� ��������� ������� � <%> �� <%>%��� ����� �������� GLN <%> (%) � ���� <%>%� ��������� EDI � <%> �� <%> .', chr(13), vbInvNumberSaleLink, DATE (vbOperDateSaleLink), chr(13), vbGLNPlace, lfGet_Object_ValueData (vbPartnerId), inOKPO, chr(13), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
             END IF;
             -- �������� - ������ �����
             IF COALESCE (vbMovementId_Child, 0) = 0 AND vbMovementId_Master <> 0 AND EXISTS (SELECT MovementString.MovementId FROM MovementString WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_InvNumberTax() AND TRIM (MovementString.ValueData) <> '')
             THEN
                  RAISE EXCEPTION '������.%�� ������� ��������� � ��������� ������� � <%> �� <%>%��� ����� �������� GLN <%> (%) � ���� = <%>,% � ��������� EDI � <%> �� <%> . <%> (%) (%)'
                                 , CHR (13), vbInvNumberSaleLink, DATE (vbOperDateSaleLink), CHR (13), vbGLNPlace, lfGet_Object_ValueData (vbPartnerId), inOKPO
                                 , CHR (13), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                                 , CHR (13), vbMovementId_Master, (SELECT MovementString.MovementId FROM MovementString WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_InvNumberTax())
                                  ;
             END IF;

         ELSE
         IF TRIM (inOrderInvNumber) <> ''
         THEN
             -- ����� ��������� <������� ����������> � <��������� ���������>
             SELECT Movement.Id, Movement_DocumentMaster.Id, MovementLinkObject_Contract.ObjectId
                    INTO vbMovementId_Master, vbMovementId_Child, vbContractId
             FROM MovementString AS MovementString_InvNumberOrder
                  INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                          ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberOrder.MovementId
                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                         AND MovementDate_OperDatePartner.ValueData BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                  INNER JOIN Movement ON Movement.Id = MovementString_InvNumberOrder.MovementId
                                     AND Movement.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                                     AND Movement.DescId = zc_Movement_Sale()

                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                               AND (MovementLinkObject_To.ObjectId IN (SELECT ObjectString.ObjectId FROM ObjectString WHERE ObjectString.DescId = zc_ObjectString_Partner_GLNCode() AND ObjectString.ValueData = vbGLNPlace) -- vbPartnerId
                                                 OR COALESCE (vbPartnerId, 0) = 0)
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
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             WHERE MovementString_InvNumberOrder.ValueData = inOrderInvNumber
               AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder();

             -- �������� - ����� ������ ������ ���� ������ � ����� ���������
             IF EXISTS (SELECT Movement.Id
                        FROM MovementString AS MovementString_InvNumberOrder
                             INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                     ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberOrder.MovementId
                                                    AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                    AND MovementDate_OperDatePartner.ValueData BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                             INNER JOIN Movement ON Movement.Id = MovementString_InvNumberOrder.MovementId
                                                AND Movement.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()
                                                AND Movement.DescId = zc_Movement_Sale()
                                                AND Movement.Id <> vbMovementId_Master
                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                          AND (MovementLinkObject_To.ObjectId IN (SELECT ObjectString.ObjectId FROM ObjectString WHERE ObjectString.DescId = zc_ObjectString_Partner_GLNCode() AND ObjectString.ValueData = vbGLNPlace) -- vbPartnerId
                                                            OR COALESCE (vbPartnerId, 0) = 0)
                        WHERE MovementString_InvNumberOrder.ValueData = inOrderInvNumber
                          AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder())
             THEN
                 RAISE EXCEPTION '������.� ������ <%> ������ ���� ���������� ������ � ����� ��������� �������.', inOrderInvNumber;
             END IF;

         END IF;
         END IF;

         -- ������� ����� � ������� ����������> !!!������ ��������!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_Sale() AND MovementChildId = inMovementId;
         -- ������� ����� � <��������� ���������> !!!������ ��������!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_Tax() AND MovementChildId = inMovementId;

         -- ������ ������
         IF vbMovementId_Master <> 0
         THEN
             -- ��������� ����� � <������� ����������> !!!������ ��������!!!
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Sale(), vbMovementId_Master, inMovementId);
         END IF;
         -- ������ ������
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
         SELECT Movement.Id, Movement_DocumentMaster.Id, MovementLinkObject_Contract.ObjectId
                INTO vbMovementId_Master, vbMovementId_Child, vbContractId
         FROM MovementString AS MovementString_InvNumberPartner
              INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  MovementString_InvNumberPartner.MovementId
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                     AND MovementDate_OperDatePartner.ValueData BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
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
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
         WHERE MovementString_InvNumberPartner.ValueData = inPartnerInvNumber
           AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner();

         -- ������� ����� � <������� ����������> !!!������ ��������!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_MasterEDI() AND MovementChildId = inMovementId;
         -- ������� ����� � <������������� � ��������� ���������> !!!������ ��������!!!
         DELETE FROM MovementLinkMovement WHERE DescId = zc_MovementLinkMovement_ChildEDI() AND MovementChildId = inMovementId;

         -- ������ ������
         IF vbMovementId_Master <> 0
         THEN
             -- ��������� ����� � <������� ����������> !!!������ ��������!!!
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_MasterEDI(), vbMovementId_Master, inMovementId);
         END IF;
         -- ������ ������
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


     IF (inOKPO <> '')
     THEN
         -- ����� �� ���� �� ����
         vbJuridicalId := (SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_View WHERE OKPO = inOKPO);

         -- ����� <������������� �������>
         -- vbGoodsPropertyId := (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Juridical_GoodsProperty() AND ObjectId = vbJuridicalId);
         vbGoodsPropertyId := zfCalc_GoodsPropertyId (vbContractId, vbJuridicalId, vbPartnerId);

     END IF;

     -- ��������� <�� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), inMovementId, vbJuridicalId);
     -- ��������� <�������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), inMovementId, vbGoodsPropertyId);
     -- ��������� <ContractId>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementId, vbContractId);

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
 02.04.15                                        * add vbPartnerId
 14.10.14                                        * add ������ ������
 07.08.14                                        * add !!!��� ��� ��������!!!
 31.07.14                                        * add !!!��� ��� �������!!!
 20.07.14                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_Movement_EDIComdoc_Params (inMovementId:= 0, inOrderInvNumber:= '-1', inOKPO:= 1, inUserId:= zfCalc_UserAdmin())
