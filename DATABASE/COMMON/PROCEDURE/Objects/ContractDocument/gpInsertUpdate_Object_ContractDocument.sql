-- Function: gpInsertUpdate_Object_ContractDocument(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractDocument(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractDocument(
 INOUT ioId                        Integer   , -- ���� ������� <�������� ��������>
    IN inDocumentName              TVarChar  , -- ����
    IN inContractId                Integer   , -- �������
    IN inContractDocumentData      TBlob     , -- ���� ��������� 	
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ContractCondition()());
   vbUserId := inSession;
   
    -- ��������
   IF COALESCE (inContractId, 0) = 0
   THEN
       RAISE EXCEPTION '������! ������� �� ����������!';
   END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractDocument(), 0, inDocumentName);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_ContractDocument_Data(), ioId, inContractDocumentData);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractDocument_Contract(), ioId, inContractId);   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ContractDocument (Integer, TVarChar, Integer, TBlob, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.12.13                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ContractDocument (ioId:=0, inValue:=100, inContractId:=5, inContractConditionKindId:=6, inSession:='2')
    