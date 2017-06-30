-- Function: gpUpdate_Object_Contract()

DROP FUNCTION IF EXISTS gpUpdate_Object_Contract (Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Contract (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Contract (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Contract (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Contract (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Contract(
 INOUT ioId                  Integer,       -- ���� ������� <�������>
    
    IN inPersonalId          Integer  ,     -- ��������� (������������ ����)
    IN inPersonalTradeId     Integer  ,     -- ���������� (��������)
    IN inPersonalCollationId Integer  ,     -- ���������� (������)
    IN inBankAccountId       Integer  ,     -- ��������� �����(������ ���)
    IN inContractTagId       Integer  ,     -- ������� ��������
    IN inJuridicalDocumentId Integer  ,     -- ����������� ���� (������ ���.)
    IN inJuridicalInvoiceId  Integer  ,     -- ����������� ���� (������ ���. - ��������� �����������)
    IN inGoodsPropertyId     Integer  ,     -- �������������� ������� �������

    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Contract());

   -- ���������� <�������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- ��������� ����� � <���������� (������������ ����)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Personal(), ioId, inPersonalId);
   -- ��������� ����� � <���������� (��������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalTrade(), ioId, inPersonalTradeId);
   -- ��������� ����� � <���������� (������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalCollation(), ioId, inPersonalCollationId);

   -- ��������� ����� � <��������� �����(������ ���)>
   -- PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_BankAccount(), ioId, inBankAccountId);
   -- ��������� ����� � <������� ��������>
   -- PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractTag(), ioId, inContractTagId);

   -- ��������� ����� � <����������� ����(������ ���.)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalDocument(), ioId, inJuridicalDocumentId);  
   
   -- ��������� ����� � <����������� ����(������ ���.- ��������� �����������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalInvoice(), ioId, inJuridicalInvoiceId);  
 
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_GoodsProperty(), ioId, inGoodsPropertyId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.03.17         * inJuridicalInvoiceId
 06.05.15         * add GoodsProperty
 16.01.15         * add inJuridicalDocumentId
 14.08.14                                        * add inPersonalId
 22.04.14         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Contract ()
