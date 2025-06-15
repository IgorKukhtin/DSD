-- Function: gpInsertUpdate_Movement_Tax()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Tax(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
 INOUT ioInvNumber           TVarChar  , -- ����� ���������
 INOUT ioInvNumberPartner    TVarChar  , -- ����� ���������� ���������
    IN inInvNumberBranch     TVarChar  , -- ����� �������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inChecked             Boolean   , -- ��������
    IN inDocument            Boolean   , -- ���� �� ����������� ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ��� 
    IN inCorrSumm             TFloat   , -- ������������� ����� ���������� ��� ������������ ����������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPartnerId           Integer   , -- ����������
    IN inContractId          Integer   , -- ��������
    IN inDocumentTaxKindId   Integer   , -- ��� ������������ ���������� ���������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCorrSumm TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());


     -- ��������� <��������>
     SELECT tmp.ioId
          , tmp.ioInvNumber
          , tmp.ioInvNumberPartner
            INTO ioId, ioInvNumber, ioInvNumberPartner
     FROM lpInsertUpdate_Movement_Tax (ioId, ioInvNumber, ioInvNumberPartner, inInvNumberBranch, inOperDate
                                     , inChecked, inDocument, inPriceWithVAT, inVATPercent
                                     , inFromId, inToId, inPartnerId, inContractId, inDocumentTaxKindId, vbUserId
                                      ) AS tmp;

     -- ������� "����������� �������"
     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
       AND NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.isErased = FALSE) -- AND ObjectId = inDocumentTaxKindId
     THEN
         PERFORM lpInsertUpdate_MovementItem_Tax (ioId                 := 0
                                                , inMovementId         := ioId
                                                , inGoodsId            := 2117  -- inDocumentTaxKindId
                                                , inAmount             := 0
                                                , inPrice              := 0
                                                , ioCountForPrice      := 1
                                                , inGoodsKindId        := zc_GoodsKind_Basis() -- NULL
                                                , inUserId             := vbUserId
                                                 );

     END IF;

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment); 
     

     -- ��������
     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()
    AND COALESCE (inCorrSumm, 0) <> COALESCE ((SELECT SUM (COALESCE (MF.ValueData, 0))
                                               FROM MovementLinkMovement AS MLM
                                                    -- ���. �������
                                                    INNER JOIN Movement ON Movement.Id       = MLM.MovementId
                                                                       -- �� ������
                                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                    INNER JOIN MovementFloat AS MF 
                                                                             ON MF.MovementId = MLM.MovementId
                                                                            AND MF.DescId     = zc_MovementFloat_CorrSumm()
                                               WHERE MLM.MovementChildId = ioId
                                                 AND MLM.DescId          = zc_MovementLinkMovement_Master()
                                             ), 0)

     THEN
         RAISE EXCEPTION '������.� ��������� ��������� � <%> �� <%>%����� ������������� = <%>%�� ����� ���������� �� ����� ������������� = <%>%� ��������� �������.'
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = ioId)
                       , CHR (13)
                       , zfConvert_FloatToString (inCorrSumm)
                       , CHR (13)
                       , zfConvert_FloatToString ((SELECT SUM (COALESCE (MF.ValueData, 0))
                                                   FROM MovementLinkMovement AS MLM
                                                        -- ��� �������
                                                        INNER JOIN Movement ON Movement.Id       = MLM.MovementId
                                                                           -- �� ������
                                                                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                        INNER JOIN MovementFloat AS MF 
                                                                                 ON MF.MovementId = MLM.MovementId
                                                                                AND MF.DescId     = zc_MovementFloat_CorrSumm()
                                                   WHERE MLM.MovementChildId = ioId
                                                     AND MLM.DescId          = zc_MovementLinkMovement_Master()
                                                 ))
                       , CHR (13)
                        ;
     END IF;


     -- ����� ���� ��������, ���� ����� ��������� ���������� �� ��������
     vbCorrSumm:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_CorrSumm());

     -- ���� ���� ��������� + ��������
     IF COALESCE (vbCorrSumm,0) <> COALESCE (inCorrSumm,0)
     THEN
         -- ��������
         IF ABS (inCorrSumm) > 10
         THEN
             RAISE EXCEPTION '������.� ��������� ��������� ����� ������������� �� ����� ���� ������ 10 ���.';
         END IF;

         -- ��������� �������� <������������� ����� ���������� ��� ������������ ����������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CorrSumm(), ioId, inCorrSumm);
         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.06.25         * CorrSumm
 10.07.14                                        * add zc_Enum_DocumentTaxKind_Prepay
 02.05.14                                        * add io...
 24.04.14                                                       * add ioInvNumberBranch
 30.03.14                                        * add ioInvNumberPartner
 16.03.14                                        * add inPartnerId
 11.02.14                                                         *  - registred
 09.02.14                                                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Tax (ioId:= 0, ioInvNumber:= '-1',ioInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inSession:= '2')
