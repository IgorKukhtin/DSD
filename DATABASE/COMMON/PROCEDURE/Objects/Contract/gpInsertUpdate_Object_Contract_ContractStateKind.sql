-- Function: gpInsertUpdate_Object_Contract_ContractStateKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract_ContractStateKind (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract_ContractStateKind(
    IN inContractId             Integer ,       -- ���� ������� <�������>
    IN inContractStateKindCode  Integer ,     -- ��������� ��������
   OUT outContractStateKindCode Integer ,
   OUT outContractStateKindName TVarChar,
    IN inSession                TVarChar       -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbContractStateKindId Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());

   SELECT
        Object_ContractStateKind.Id  
      , Object_ContractStateKind.ObjectCode
      , Object_ContractStateKind.ValueData INTO vbContractStateKindId, outContractStateKindCode, outContractStateKindName   
      
   FROM OBJECT AS Object_ContractStateKind
                              
  WHERE Object_ContractStateKind.DescId = zc_Object_ContractStateKind()
    AND Object_ContractStateKind.ObjectCode = inContractStateKindCode;

   -- ��������� ����� � <��������� ��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractStateKind(), inContractId, vbContractStateKindId);   
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inContractId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.05.14                                        * add lpCheckRight
 25.02.14                                        * add inIsUpdate and inIsErased
 13.02.14                        * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Contract_ContractStateKind ()
