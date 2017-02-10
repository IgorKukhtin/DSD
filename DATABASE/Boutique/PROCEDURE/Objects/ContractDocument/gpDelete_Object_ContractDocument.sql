-- Function: lpDelete_Object(integer, tvarchar)

DROP FUNCTION IF EXISTS gpDelete_Object_ContractDocument(integer, tvarchar);

CREATE OR REPLACE FUNCTION gpDelete_Object_ContractDocument(
     IN inId integer, 
     IN inSession tvarchar)
RETURNS void AS
$BODY$
BEGIN

  -- �.�. � lpDelete_Object ������������
  -- DELETE FROM ObjectLink WHERE ChildObjectId = inId;
  -- �.�. � lpDelete_Object ������������
  DELETE FROM ObjectBLOB WHERE ObjectId = inId;

  PERFORM lpDelete_Object(inId, inSession);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_ContractDocument(integer, tvarchar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.02.14                        *
*/
