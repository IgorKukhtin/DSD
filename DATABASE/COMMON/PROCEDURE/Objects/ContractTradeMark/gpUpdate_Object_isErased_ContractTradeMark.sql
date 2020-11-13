-- Function: gpUpdate_Object_isErased_ContractTradeMark (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_ContractTradeMark (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_ContractTradeMark(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_ContractTradeMark());

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_isErased_ContractTradeMark (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.11.20         *
*/
