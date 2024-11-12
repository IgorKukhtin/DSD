-- Function: gpInsertUpdate_Object_Contract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Integer, Integer, TDateTime, TDateTime, TVarChar);

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, TDateTime, TDateTime, TVarChar);
*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, TDateTime, TDateTime, TVarChar);
                                                      */
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Integer, TDateTime, TDateTime, TVarChar);*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Integer, TDateTime, TDateTime, TVarChar);*/

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, TDateTime, TDateTime, TVarChar);*/

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, TDateTime, TDateTime, TVarChar);*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean
                                                      , Integer, TDateTime, TDateTime, TVarChar);*/
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean
                                                      , Integer, TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract(
 INOUT ioId                  Integer,       -- ���� ������� <�������>
    IN inCode                Integer,       -- ���
    IN inInvNumber           TVarChar,      -- ����� ��������
    IN inInvNumberArchive    TVarChar,      -- ����� �������������
    IN inComment             TVarChar,      -- ����������
    IN inBankAccountExternal TVarChar,      -- �.���� (���.������)
    IN inBankAccountPartner  TVarChar,      -- �.���� (��.������)
    IN inGLNCode             TVarChar,      -- ��� GLN  
    IN inPartnerCode         TVarChar,      -- ��� ����������
    IN inTerm                Tfloat  ,      -- ������ �����������
    IN inDayTaxSummary       Tfloat  ,      -- ���-�� ���� ��� ������� ���������, ���� �������� = 0, ����� ����� �� 1 �����

    IN inSigningDate         TDateTime,     -- ���� ���������� ��������
    IN inStartDate           TDateTime,     -- ���� � ������� ��������� �������
    IN inEndDate             TDateTime,     -- ���� �� ������� ��������� �������    
    
    IN inJuridicalId         Integer  ,     -- ����������� ����
    IN inJuridicalBasisId    Integer  ,     -- ������� ����������� ����
    IN inJuridicalDocumentId Integer  ,     -- ����������� ���� (������ ���.)
    IN inJuridicalInvoiceId  Integer  ,     -- ����������� ���� (������ ���. - ��������� �����������)
    
    IN inInfoMoneyId         Integer  ,     -- �� ������ ����������
    IN inContractKindId      Integer  ,     -- ��� ��������
    IN inPaidKindId          Integer  ,     -- ��� ����� ������
    --IN inGoodsPropertyId     Integer  ,     -- �������������� ������� �������

    IN inPersonalId          Integer  ,     -- ��������� (������������ ����)
    IN inPersonalTradeId     Integer  ,     -- ��������� (��������)
    IN inPersonalCollationId Integer  ,     -- ��������� (������)
    IN inPersonalSigningId   Integer  ,     -- ��������� (���������)
    IN inBankAccountId       Integer  ,     -- ��������� ���� (���.������)
    IN inContractTagId       Integer  ,     -- ������� ��������
    
    IN inAreaContractId      Integer  ,     -- ������
    IN inContractArticleId   Integer  ,     -- ������� ��������
    IN inContractStateKindId Integer  ,     -- ��������� ��������
    IN inContractTermKindId  Integer  ,     -- ���� ����������� ��������� 
    IN inCurrencyId          Integer  ,     -- ������
    IN inBankId              Integer  ,     -- ���� (���.������)
    IN inBranchId            Integer  ,     -- ������ (������� ���)
    IN inisDefault           Boolean  ,     -- �� ��������� (��� ��. ��������)
    IN inisDefaultOut        Boolean  ,     -- �� ��������� (��� ���. ��������)
    IN inisStandart          Boolean  ,     -- �������

    IN inisPersonal          Boolean  ,     -- ��������� �������
    IN inisUnique            Boolean  ,     -- ��� �����������3
    IN inisRealEx            Boolean  ,     -- ��� �����
    IN inisNotVat            Boolean  ,     -- ��� ��� 
    IN inisNotTareReturning  Boolean  ,     -- ��� �������� ����
    IN inisMarketNot         Boolean  ,     -- ����������� ������ ���������

    --IN inPriceListId         Integer   ,    -- �����-����
    IN inPriceListPromoId    Integer   ,    -- �����-����(���������)
    IN inStartPromo          TDateTime ,    -- ���� ������ �����
    IN inEndPromo            TDateTime ,    -- ���� ��������� �����

    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());

   /*
   IF ioId <> 0 
        -- �������� ����� ���
   THEN vbCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); 
        -- �����, ���������� ��� ��� ���������+1
   ELSE vbCode:= inCode; -- lfGet_ObjectCode (inCode, zc_Object_Contract()); 
   END IF;*/

   IF COALESCE (ioId, 0) = 0 AND EXISTS (SELECT ObjectCode FROM Object WHERE ObjectCode = inCode AND DescId = zc_Object_Contract())
   THEN 
       -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
       vbCode:= lfGet_ObjectCode (0, zc_Object_Contract());
   ELSE
       -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
       vbCode:= lfGet_ObjectCode (inCode, zc_Object_Contract());
   END IF;

   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Contract(), vbCode);

   -- �������� <����� ��������>
   IF TRIM (COALESCE (inInvNumber, '')) = '' 
   THEN
       RAISE EXCEPTION '������. �������� <����� ��������> ������ ���� �����������.';
  END IF;

   -- �������� ������������ ��� �������� <����� ��������>
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Contract(), inInvNumber);


/*
   -- �������� ����� <�����-����>
   IF COALESCE (ioId, 0) = 0 AND COALESCE (inPriceListId, 0) = 0
   THEN
       -- �����
       inPriceListId:= (SELECT ObjectLink_PriceList.ChildObjectId
                        FROM ObjectLink
                             INNER JOIN ObjectLink AS ObjectLink_InfoMoney
                                                   ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                                  AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                                  AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                             INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                   ON ObjectLink_PriceList.ObjectId = ObjectLink.ObjectId
                                                  AND ObjectLink_PriceList.ChildObjectId > 0
                                                  AND ObjectLink_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                             LEFT JOIN ObjectLink AS ObjectLink_ContractTag
                                                  ON ObjectLink_ContractTag.ObjectId = ObjectLink.ObjectId
                                                 AND ObjectLink_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                        WHERE ObjectLink.ChildObjectId = inJuridicalId
                          AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
                          AND COALESCE (ObjectLink_ContractTag.ChildObjectId, 0) = COALESCE (inContractTagId, 0)
                        LIMIT 1
                       );
   END IF;

   -- �������� - � ������ ��������� ����� ������ ���� �� ������
   IF COALESCE (inPriceListId, 0) = 0 AND EXISTS (SELECT 1
                                                  FROM ObjectLink
                                                       INNER JOIN ObjectLink AS ObjectLink_InfoMoney
                                                                             ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                                                            AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                                       INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                                             ON ObjectLink_PriceList.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_PriceList.ChildObjectId > 0
                                                                            AND ObjectLink_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                                  WHERE ObjectLink.ChildObjectId = inJuridicalId
                                                    AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
                                                  LIMIT 1
                                                 )
   THEN
       RAISE EXCEPTION '������.� ������� �������� ��� <�� ������ ����������> = <%> ������ ���� ���������� �����-���� = <%> ��� <%>.', lfGet_Object_ValueData (inInfoMoneyId)
                       , lfGet_Object_ValueData ((SELECT MAX (ObjectLink_PriceList.ChildObjectId)
                                                  FROM ObjectLink
                                                       INNER JOIN ObjectLink AS ObjectLink_InfoMoney
                                                                             ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                                                            AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                                       INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                                             ON ObjectLink_PriceList.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_PriceList.ChildObjectId > 0
                                                                            AND ObjectLink_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                                  WHERE ObjectLink.ChildObjectId = inJuridicalId
                                                    AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
                                                ))
                       , CASE WHEN           0 < (SELECT MIN (ObjectLink_PriceList.ChildObjectId)
                                                  FROM ObjectLink
                                                       INNER JOIN ObjectLink AS ObjectLink_InfoMoney
                                                                             ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                                                            AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                                       INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                                             ON ObjectLink_PriceList.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_PriceList.ChildObjectId > 0
                                                                            AND ObjectLink_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                                  WHERE ObjectLink.ChildObjectId = inJuridicalId
                                                    AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
                                                  HAVING MAX (ObjectLink_PriceList.ChildObjectId) <> MIN (ObjectLink_PriceList.ChildObjectId)
                                                )
                                  THEN
                         lfGet_Object_ValueData ((SELECT MIN (ObjectLink_PriceList.ChildObjectId)
                                                  FROM ObjectLink
                                                       INNER JOIN ObjectLink AS ObjectLink_InfoMoney
                                                                             ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                                                            AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                                       INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                                             ON ObjectLink_PriceList.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_PriceList.ChildObjectId > 0
                                                                            AND ObjectLink_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                                  WHERE ObjectLink.ChildObjectId = inJuridicalId
                                                    AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
                                                ))
                              ELSE '����� ������'
                         END
      ;
   END IF;
   */

   -- �������� ������������ <����� ��������> ��� !!!������!! ��. ���� � !!!�����!! ������
   IF TRIM (inInvNumber) <> '' AND TRIM (inInvNumber) <> '-' -- and inInvNumber <> '100398' and inInvNumber <> '877' and inInvNumber <> '24849' and inInvNumber <> '19' and inInvNumber <> '�/�' and inInvNumber <> '369/1' and inInvNumber <> '63/12' and inInvNumber <> '4600034104' and inInvNumber <> '19�'
   THEN
       IF EXISTS (SELECT ObjectLink.ChildObjectId
                  FROM ObjectLink
                       JOIN ObjectLink AS ObjectLink_InfoMoney
                                       ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                      AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                      AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                       JOIN Object ON Object.Id = ObjectLink.ObjectId
                                  AND TRIM (Object.ValueData) = TRIM (inInvNumber)
                  WHERE ObjectLink.ChildObjectId = inJuridicalId
                    AND ObjectLink.ObjectId <> COALESCE (ioId, 0)
                    AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical())
       THEN
           RAISE EXCEPTION '������. ����� �������� <%> ��� ���������� � <%>.', TRIM (inInvNumber), lfGet_Object_ValueData (inJuridicalId);
       END IF;
   END IF;

   -- ��������
   IF COALESCE (inJuridicalBasisId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<������� ����������� ����> �� �������.';
   END IF;
   IF COALESCE (inJuridicalBasisId, 0) <> zc_Juridical_Basis() AND vbUserId NOT IN (zfCalc_UserAdmin() :: Integer, zfCalc_UserMain())
   THEN
      RAISE EXCEPTION '������.������ ���� ������� <������� ����������� ����> = <%>.', lfGet_Object_ValueData_sh (zc_Juridical_Basis());
   END IF;
   -- ��������
   IF COALESCE (inJuridicalId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<����������� ����> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inInfoMoneyId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<�� ������ ����������> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inPaidKindId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<����� ������> �� �������.';
   END IF;
   -- ��������
   IF inPaidKindId = zc_Enum_PaidKind_FirstForm() AND NOT EXISTS (SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_View WHERE JuridicalId = inJuridicalId AND OKPO <> '')
   THEN
      RAISE EXCEPTION '������.� <����������� ����> �� ���������� <����>.';
   END IF;
   -- �������� ��� 
   IF COALESCE (inContractTagId, 0) = 0
      AND EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId
                                                                  AND InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100() -- ���������
                                                                                               , zc_Enum_InfoMoneyDestination_30200() -- ������ �����
                                                                                                ))
   THEN
       RAISE EXCEPTION '������.��� <%> ���������� ���������� <������� ��������>.', lfGet_Object_ValueData (inInfoMoneyId);
   END IF;

   -- ��������
   IF inSigningDate <> DATE_TRUNC ('DAY', inSigningDate) OR inStartDate <> DATE_TRUNC ('DAY', inStartDate) OR inEndDate <> DATE_TRUNC ('DAY', inEndDate) 
   THEN
       RAISE EXCEPTION '������.�������� ������ ����.';
   END IF;

   -- ��������
   IF COALESCE (inCurrencyId, 0) = 0
   THEN
       RAISE EXCEPTION '������.<������> �� �������.';
   END IF;


   -- ���������� <�������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Contract(), vbCode, TRIM (inInvNumber));

   -- ��������� �������� <����� ��������>
   -- PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_InvNumber(), ioId, inInvNumber);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Signing(), ioId, inSigningDate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Start(), ioId, inStartDate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_End(), ioId, inEndDate);

   -- ��������� �������� <����� �������������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_InvNumberArchive(), ioId, inInvNumberArchive);

   -- ��������� �������� <�����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_BankAccount(), ioId, inBankAccountExternal);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_BankAccountPartner(), ioId, inBankAccountPartner);

   -- ��������� �������� <��� GLN>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_GLNCode(), ioId, inGLNCode);
   -- ��������� �������� <��� ����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_PartnerCode(), ioId, inPartnerCode);


   --���� �� ������� �������� � ��� �����������  = ���������� ������ �������� 36
   IF inContractTermKindId =  zc_Enum_ContractTermKind_Long() AND COALESCE (inTerm,0) = 0
   THEN
       inTerm := 36;
   END IF;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Contract_Term(), ioId, inTerm);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Contract_DayTaxSummary(), ioId, inDayTaxSummary);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_Default(), ioId, inisDefault);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_DefaultOut(), ioId, inisDefaultOut);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_Standart(), ioId, inisStandart);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_Personal(), ioId, inisPersonal);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_Unique(), ioId, inisUnique);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_RealEx(), ioId, inisRealEx);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_NotVAT(), ioId, inisNotVat);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_NotTareReturning(), ioId, inisNotTareReturning);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_MarketNot(), ioId, inisMarketNot);
   
   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <������� ����������� �����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalBasis(), ioId, inJuridicalBasisId);
   -- ��������� ����� � <����������� ����(������ ���.)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalDocument(), ioId, inJuridicalDocumentId); 
   -- ��������� ����� � <����������� ����(������ ���.- ��������� �����������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalInvoice(), ioId, inJuridicalInvoiceId);  
   -- ��������� ����� � <������ ����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_InfoMoney(), ioId, inInfoMoneyId);
   -- ��������� ����� � <���� ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractKind(), ioId, inContractKindId);
   -- ��������� ����� � <���� ���� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PaidKind(), ioId, inPaidKindId);

   -- ��������� ����� � <>
   --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_GoodsProperty(), ioId, inGoodsPropertyId);

   -- ��������� ����� � <���������� (������������ ����)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Personal(), ioId, inPersonalId);
   
   -- ��������� ����� � <���������� (������������ ����)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Personal(), ioId, inPersonalId);

   -- ��������� ����� � <���������� (��������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalTrade(), ioId, inPersonalTradeId);
   -- ��������� ����� � <���������� (������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalCollation(), ioId, inPersonalCollationId);
   -- ��������� ����� � <���������� (���������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalSigning(), ioId, inPersonalSigningId);
   -- ��������� ����� � <��������� �����(������ ���)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_BankAccount(), ioId, inBankAccountId);
   -- ��������� ����� � <������� ��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractTag(), ioId, inContractTagId);
   
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_AreaContract(), ioId, inAreaContractId);
   -- ��������� ����� � <������� ��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractArticle(), ioId, inContractArticleId);
   -- ��������� ����� � <��������� ��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractStateKind(), ioId, inContractStateKindId);   
   -- ��������� ����� � <���� ����������� ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractTermKind(), ioId, inContractTermKindId);

   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Currency(), ioId, inCurrencyId);

   -- ��������� ����� � <����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Bank(), ioId, inBankId);

   -- ��������� ����� � <������ (������� ���)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Branch(), ioId, inBranchId);

   -- ��������� ����� � <>
   --PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_PriceList(), ioId, inPriceListId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_PriceListPromo(), ioId, inPriceListPromoId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_StartPromo(), ioId, DATE (inStartPromo));
      -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_EndPromo(), ioId, DATE (inEndPromo));
   
   
     -- !!!�����������!!! ������������ ����
    PERFORM lpInsertFind_Object_ContractKey (inJuridicalId_basis:= inJuridicalBasisId
                                           , inJuridicalId      := inJuridicalId
                                           , inInfoMoneyId      := inInfoMoneyId
                                           , inPaidKindId       := inPaidKindId
                                           , inContractTagId    := inContractTagId
                                           , inContractId_begin := ioId
                                            );

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.11.24         * inisMarketNot
 26.09.23         * inisNotTareReturning
 01.05.23         * inisNotVat
 21.03.22         * inisRealEx
 03.11.21         * inBranchId ������ (������� ���)
 27.05.21         * del inPriceListId
 
 04.02.19         * inBankAccountPartner
 18.01.19         * DefaultOut
 05.10.18         * add PartnerCode
 30.03.17         * inJuridicalInvoiceId
 03.03.17         * inDayTaxSummary
 13.04.16         *
 29.01.16         *
 20.01.16         *
-- 05.05.15         * add   GoodsProperty
 12.02.15         * add StartPromo, EndPromo,
                        PriceList, PriceListPromo
 16.01.15         * add JuridicalDocument
 10.11.14         * add GLNCode               
 07.11.14         * ������ Area  �� AreaContract
 21.07.14                                        * add �������� <����� ��������>
 22.05.14         * add zc_ObjectBoolean_Contract_Personal
                        zc_ObjectBoolean_Contract_Unique
 08.05.14                                        * add lpCheckRight
 26.04.14                                        * add lpInsertFind_Object_ContractKey
 21.04.14         * add zc_ObjectLink_Contract_PersonalTrade
                        zc_ObjectLink_Contract_PersonalCollation
                        zc_ObjectLink_Contract_BankAccount
                        zc_ObjectLink_Contract_ContractTag
 17.04.14                                        * add TRIM
 19.03.14         * add inisStandart
 13.03.14         * add inisDefault
 05.01.14                                        * add �������� ������������ <����� ��������> ��� !!!������!! ��. ���� � !!!�����!! ������
 25.02.14                                        * add inIsUpdate and inIsErased
 21.02.14         * add Bank, BankAccount
 08.11.14                        *
 05.01.14                                        * add �������� ������������ <����� ��������> ��� !!!������!! ��. ����
 04.01.14                                        * add !!!inInvNumber not unique!!!
 14.11.13         * add from redmaine               
 21.10.13                                        * add vbCode
 20.10.13                                        * add from redmaine
 19.10.13                                        * del zc_ObjectString_Contract_InvNumber()
 22.07.13         * add  SigningDate, StartDate, EndDate              
 12.04.13                                        *
 16.06.13                                        * �������
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Contract ()
