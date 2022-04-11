-- Function: lpInsert_Movement_TaxCorrective_isAutoPrepay()

DROP FUNCTION IF EXISTS lpInsert_Movement_TaxCorrective_isAutoPrepay (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsert_Movement_TaxCorrective_isAutoPrepay (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_TaxCorrective_isAutoPrepay(
    IN inId                    Integer   , -- ���� ������� <�������� TaxCorrective>
    IN inInvNumber             TVarChar  , -- ����� ���������
    IN inInvNumberPartner      TVarChar  , -- ����� ���������� ���������
    IN inInvNumberBranch       TVarChar  , -- ����� �������
    IN inOperDate              TDateTime , -- ���� ���������
    IN inisAuto                Boolean   , -- �������������
    IN inChecked               Boolean   , -- ��������
    IN inDocument              Boolean   , -- ���� �� ����������� ��������
    IN inPriceWithVAT          Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent            TFloat    , -- % ���
    IN inAmount                TFloat    , -- ����� ����������
    IN inFromId                Integer   , -- �� ���� (� ���������)
    IN inToId                  Integer   , -- ���� (� ���������)
    IN inPartnerId             Integer   , -- ����������
    IN inContractId            Integer   , -- ��������
    IN inDocumentTaxKindId     Integer   , -- ��� ������������ ��������� TaxCorrective
    IN inPersonalCollationName TVarChar  ,
    IN inUserId                Integer     -- ������������
)


RETURNS VOID AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbBranchId Integer;
BEGIN

    -- ��������� ��������
    inId:= (SELECT tmp.ioId
            FROM lpInsertUpdate_Movement_TaxCorrective (inId, inInvNumber, inInvNumberPartner, inInvNumberBranch, inOperDate
                                                      , inChecked, inDocument, inPriceWithVAT, inVATPercent
                                                      , inFromId, inToId, inPartnerId, inContractId, inDocumentTaxKindId, inUserId
                                                       ) AS tmp);

    -- ��������� �������� <�������������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inId, inPersonalCollationName);
    -- ��������� �������� <�������������>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), inId, inisAuto);

    --������ ��������� 
    PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                     , inMovementId         := inId
                                                     , inGoodsId            := 2117 -- ��� 4 -- inDocumentTaxKindId
                                                     , inAmount             := inAmount
                                                     , inPrice              := 1
                                                     , inPriceTax_calc      := 1
                                                     , ioCountForPrice      := 1
                                                     , inGoodsKindId        := zc_GoodsKind_Basis()
                                                     , inUserId             := inUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.12.21         *
*/

-- ����
--