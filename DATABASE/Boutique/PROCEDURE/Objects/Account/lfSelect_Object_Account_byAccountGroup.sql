-- Function: lfSelect_Object_Account_byAccountGroup (Integer)

-- DROP FUNCTION lfSelect_Object_Account_byAccountGroup (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Account_byAccountGroup (IN inAccountGroupId Integer)
RETURNS TABLE  (AccountId Integer)  
  AS
$BODY$
BEGIN

     -- �������� ������ ��� ����������� ������ (�� ����� ���� ��� ��� �����������)
     RETURN QUERY
     SELECT ObjectId AS AccountId FROM ObjectLink WHERE ChildObjectId = inAccountGroupId AND DescId = zc_ObjectLink_Account_AccountGroup();

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.09.13         *
*/

-- ����
-- SELECT * FROM lfSelect_Object_Account_byAccountGroup (zc_Enum_AccountGroup_20000())
