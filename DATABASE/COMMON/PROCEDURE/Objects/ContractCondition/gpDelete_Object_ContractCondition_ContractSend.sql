-- Function: gpDelete_Object_ContractCondition_ContractSend(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_ContractCondition_ContractSend (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpDelete_Object_ContractCondition_ContractSend(
    IN inId                        Integer   , -- ���� ������� <������� ��������>
   OUT outContractSendName         TVarChar  , -- 
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   
    -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN;
   END IF;

    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_ContractSend(), inId, NULL);   
 
   outContractSendName := ''::TVarChar;
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.01.21         *
*/

-- ����
-- 