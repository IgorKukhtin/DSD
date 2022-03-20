-- Function: lpInsert_Movement_Tax_isAutoPrepay()

DROP FUNCTION IF EXISTS lpInsert_Movement_Tax_isAutoPrepay (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Tax_isAutoPrepay(
    IN inId                  Integer   , -- ���� ������� <�������� ���������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ���������� ���������
    IN inInvNumberBranch     TVarChar  , -- ����� �������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inisAuto              Boolean   , -- �������������
    IN inChecked             Boolean   , -- ��������
    IN inDocument            Boolean   , -- ���� �� ����������� ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inAmount              TFloat    , -- ����� ����������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPartnerId           Integer   , -- ����������
    IN inContractId          Integer   , -- ��������
    IN inDocumentTaxKindId   Integer   , -- ��� ������������ ���������� ���������
    IN inUserId              Integer     -- ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbBranchId Integer;
BEGIN

    -- ��������� ��������
    SELECT tmp.ioId
           INTO inId
    FROM lpInsertUpdate_Movement_Tax (inId, inInvNumber, inInvNumberPartner, inInvNumberBranch, inOperDate
                                    , inChecked, inDocument, inPriceWithVAT, inVATPercent
                                    , inFromId, inToId, inPartnerId, inContractId, inDocumentTaxKindId, inUserId
                                     ) AS tmp;    

    -- ����������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inId
                                         , (SELECT STRING_AGG (Object_PersonalCollation.ValueData, ';')
                                            FROM (SELECT DISTINCT ObjectLink_Contract_PersonalCollation.ChildObjectId AS PersonalId_collation
                                                  FROM Object_Contract_View
                                                       LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                                                            ON ObjectLink_Contract_PersonalCollation.ObjectId = Object_Contract_View.ContractId 
                                                                           AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
                                                  WHERE Object_Contract_View.JuridicalId = inToId
                                                    AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                    AND Object_Contract_View.InfoMoneyId         = zc_Enum_InfoMoney_30101() -- ������ + ��������� + ������� ���������
                                                    AND Object_Contract_View.isErased            = FALSE
                                                    
                                                 ) AS tmp
                                                 LEFT JOIN Object AS Object_PersonalCollation ON Object_PersonalCollation.Id = tmp.PersonalId_collation
                                           )
                                          );

    -- ��������� �������� <�������������>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), inId, inisAuto);

    --������ ��������� 
    PERFORM lpInsertUpdate_MovementItem_Tax (ioId                 := 0
                                           , inMovementId         := inId
                                           , inGoodsId            := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = 4 AND Object.DescId = zc_Object_Goods())
                                           , inAmount             := inAmount
                                           , inPrice              := 1
                                           , ioCountForPrice      := 1
                                           , inGoodsKindId        := NULL
                                           , inUserId             := inUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.12.21         *
*/

-- ����
--