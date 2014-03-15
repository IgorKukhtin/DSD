-- Function: gpInsertUpdate_Object_ContractCondition(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition(Integer, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition(Integer, TVarChar, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition(Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractCondition(
 INOUT ioId                        Integer   , -- ���� ������� <������� ��������>
    IN inComment                   TVarChar  , -- ����������
    IN inValue                     TFloat    , -- ��������
    IN inContractId                Integer   , -- �������
    IN inContractConditionKindId   Integer   , -- ���� ������� ��������� 
    IN inBonusKindId               Integer   , -- ���� �������
    IN inInfoMoneyId               Integer   , -- ������ ����������
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ContractCondition()());
   vbUserId:= lpGetUserBySession (inSession);
   
    -- ��������
   IF COALESCE (inContractId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ����������.';
   END IF;

   
   -- ���������� <�������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractCondition(), 0, inComment);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractCondition_Value(), ioId, inValue);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_Contract(), ioId, inContractId);   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_ContractConditionKind(), ioId, inContractConditionKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_BonusKind(), ioId, inBonusKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_InfoMoney(), ioId, inInfoMoneyId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.03.14         * add InfoMoney
 25.02.14                                        * add inIsUpdate and inIsErased
 19.02.14         * add inBonusKindId, inComment
 16.11.13         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ContractCondition (ioId:=0, inValue:=100, inContractId:=5, inContractConditionKindId:=6, inSession:='2')
