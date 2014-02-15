-- Function: gpInsertUpdate_Object_ContractCondition(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition(Integer, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractCondition(
 INOUT ioId                        Integer   , -- ���� ������� <������� ��������>
    IN inValue                     TFloat    , -- ��������
    IN inContractId                Integer   , -- �������
    IN inContractConditionKindId   Integer   , -- ���� ������� ��������� 	
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
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractCondition(), 0, '');
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractCondition_Value(), ioId, inValue);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_Contract(), ioId, inContractId);   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_ContractConditionKind(), ioId, inContractConditionKindId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ContractCondition (Integer, TFloat, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.11.13         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ContractCondition (ioId:=0, inValue:=100, inContractId:=5, inContractConditionKindId:=6, inSession:='2')
    