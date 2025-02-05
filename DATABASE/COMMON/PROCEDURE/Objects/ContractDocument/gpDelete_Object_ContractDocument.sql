-- Function: gpDelete_Object_ContractDocument(integer, tvarchar)

DROP FUNCTION IF EXISTS gpDelete_Object_ContractDocument(integer, tvarchar);

CREATE OR REPLACE FUNCTION gpDelete_Object_ContractDocument(
     IN inId integer, 
     IN inSession tvarchar)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- ��� �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- �.�. � lp Delete_Object ������������
   -- DELETE FROM ObjectLink WHERE ChildObjectId = inId;
   -- �.�. � lp Delete_Object ������������

   -- DELETE FROM ObjectBLOB WHERE ObjectId = inId;
   -- PERFORM lp Delete_Object(inId, inSession);
   
   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inId, inUserId:= vbUserId);
  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.02.14                        *
*/
