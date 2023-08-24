-- Function: gpInsertUpdate_Object_Contract_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract_From_Excel (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract_From_Excel(
    IN inContractName       TVarChar   , -- 
    IN inContractTagName    TVarChar   , -- 
    IN inPaidKindName       TVarChar   , -- 
    IN inJuridicalName      TVarChar   , --
    IN inInfoMoneyName      TVarChar   ,  
    IN inStartDate          TDateTime  ,
    IN inEndDate            TDateTime  ,
    IN inSession            TVarChar     -- ������ ������������
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbContractId_find Integer;
    DECLARE vbContractTagId Integer;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbJuridicalId Integer;
    DECLARE vbInfoMoneyId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

    -- ��������
    IF COALESCE(inContractName, '') = ''
    THEN
        RETURN;
    END IF;
    
    IF COALESCE (TRIM (inContractTagName), '') <> ''
    THEN 
         -- ����� ��������
         vbContractTagId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ContractTag() AND UPPER (Object.ValueData) = TRIM(UPPER (inContractTagName)) LIMIT 1);
         IF COALESCE (vbContractTagId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� ������� �������� <%> �� �������.', inContractTagName;
         END IF;
    END IF;
    
    IF COALESCE (TRIM (inPaidKindName), '') <> ''
    THEN 
         -- ����� ��
         vbPaidKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PaidKind() AND UPPER(Object.ValueData) = TRIM (UPPER(inPaidKindName)) LIMIT 1);
         IF COALESCE (vbPaidKindId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� ����� ������ <%> �� �������.', inPaidKindName;
         END IF;
    END IF;

    IF COALESCE (TRIM (inJuridicalName), '') <> ''
    THEN 
         -- ����� ��.����
         vbJuridicalId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Juridical() AND UPPER (Object.ValueData) = TRIM(UPPER (inJuridicalName)) LIMIT 1);
         IF COALESCE (vbJuridicalId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� ����������� ���� <%> �� �������.', inJuridicalName;
         END IF;
    END IF;

    IF COALESCE (TRIM (inInfoMoneyName), '') <> ''
    THEN 
         -- ����� ��
         vbInfoMoneyId := (SELECT Object.InfoMoneyId FROM Object_InfoMoney_View AS Object WHERE UPPER (Object.InfoMoneyName_all) = TRIM(UPPER (inInfoMoneyName)) LIMIT 1);
         IF COALESCE (vbInfoMoneyId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� �� ������ ���������� <%> �� �������.', inInfoMoneyName;
         END IF;
    END IF;

    vbContractId_find:= (SELECT tmp_View.ContractId
                         FROM Object_Contract_View AS tmp_View
                         WHERE tmp_View.JuridicalId = vbJuridicalId
                           AND tmp_View.PaidKindId  = vbPaidKindId
                           AND tmp_View.InfoMoneyId = vbInfoMoneyId
                           AND tmp_View.InvNumber   = TRIM(inContractName)
                        );
    -- � ���������, ���� �� �� �. ���� ����� ��� (����� + �� + �� + ��-�), ����� ��������� � �������  
    IF vbContractId_find > 0 AND 1=1
    THEN
        RAISE EXCEPTION '������.������� <%> ��� <%> �� <%> �� ������ <%> ��� ����������.', inContractName, inJuridicalName, inPaidKindName, inInfoMoneyName;
    END IF;

    -- ��������� ����� �������
    PERFORM gpInsertUpdate_Object_Contract (ioId                 := vbContractId_find             -- ���� ������� <�������>
                                          , inCode               := COALESCE ((SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbContractId_find)
                                                                            , lfGet_ObjectCode (0, zc_Object_Contract())
                                                                             ) ::Integer
                                          , inInvNumber          := TRIM (inContractName)::TVarChar      -- ����� ��������
                                          , inInvNumberArchive   := NULL           ::TVarChar      -- ����� �������������
                                          , inComment            := NULL           ::TVarChar      -- ����������
                                          , inBankAccountExternal:= NULL           ::TVarChar      -- �.���� (���.������)
                                          , inBankAccountPartner := NULL           ::TVarChar      -- �.���� (��.������)
                                          , inGLNCode            := NULL           ::TVarChar      -- ��� GLN  
                                          , inPartnerCode        := NULL           ::TVarChar      -- ��� ����������
                                          , inTerm               := NULL           ::Tfloat        -- ������ �����������
                                          , inDayTaxSummary      := NULL           ::Tfloat        -- ���-�� ���� ��� ������� ���������, ���� �������� = 0, ����� ����� �� 1 �����
                                          , inSigningDate        := inStartDate    ::TDateTime    -- ���� ���������� ��������
                                          , inStartDate          := inStartDate    ::TDateTime    -- ���� � ������� ��������� �������
                                          , inEndDate            := inEndDate      ::TDateTime    -- ���� �� ������� ��������� �������    
                                          , inJuridicalId        := vbJuridicalId  ::Integer      -- ����������� ����
                                          , inJuridicalBasisId   := zc_Juridical_Basis()           ::Integer      -- ������� ����������� ����
                                          , inJuridicalDocumentId:= NULL           ::Integer      -- ����������� ���� (������ ���.)
                                          , inJuridicalInvoiceId := NULL           ::Integer      -- ����������� ���� (������ ���. - ��������� �����������)
                                          , inInfoMoneyId        := vbInfoMoneyId           ::Integer      -- �� ������ ����������
                                          , inContractKindId     := NULL           ::Integer      -- ��� ��������
                                          , inPaidKindId         := vbPaidKindId   ::Integer      -- ��� ����� ������
                                          , inPersonalId         := NULL           ::Integer      -- ��������� (������������ ����)
                                          , inPersonalTradeId    := NULL           ::Integer      -- ��������� (��������)
                                          , inPersonalCollationId:= NULL           ::Integer      -- ��������� (������)
                                          , inPersonalSigningId  := NULL           ::Integer      -- ��������� (���������)
                                          , inBankAccountId      := NULL           ::Integer      -- ��������� ���� (���.������)
                                          , inContractTagId      := vbContractTagId::Integer      -- ������� ��������
                                          , inAreaContractId     := NULL           ::Integer      -- ������
                                          , inContractArticleId  := NULL           ::Integer      -- ������� ��������
                                          , inContractStateKindId:= NULL           ::Integer      -- ��������� ��������
                                          , inContractTermKindId := NULL           ::Integer      -- ���� ����������� ��������� 
                                          , inCurrencyId         := zc_Enum_Currency_Basis()   ::Integer      -- ������
                                          , inBankId             := NULL           ::Integer      -- ���� (���.������)
                                          , inBranchId           := NULL           ::Integer      -- ������ (������� ���)
                                          , inIsDefault          := FALSE          ::Boolean      -- �� ��������� (��� ��. ��������)
                                          , inIsDefaultOut       := FALSE          ::Boolean      -- �� ��������� (��� ���. ��������)
                                          , inIsStandart         := FALSE          ::Boolean      -- �������
                                          , inIsPersonal         := FALSE          ::Boolean      -- ��������� �������
                                          , inIsUnique           := TRUE           ::Boolean      -- !!!��� �����������!!!
                                          , inIsRealEx           := TRUE           ::Boolean      -- ��� �����
                                          , inIsNotVat           := FALSE          ::Boolean      -- ��� ��� 
                                          , inPriceListPromoId   := NULL           ::Integer      -- �����-����(���������)
                                          , inStartPromo         := NULL           ::TDateTime    -- ���� ������ �����
                                          , inEndPromo           := NULL           ::TDateTime    -- ���� ��������� �����
                                          , inSession            := inSession      ::TVarChar     -- ������ ������������ 
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.08.23         *
*/

-- ����