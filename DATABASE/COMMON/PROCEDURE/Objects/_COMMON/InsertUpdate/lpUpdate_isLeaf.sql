-- Function: lpUpdate_isLeaf() - ������ ������� �����\����� 

-- DROP FUNCTION lpUpdate_isLeaf (IN inCode Integer, IN inDescId Integer, IN inEnumName TVarChar);

CREATE OR REPLACE FUNCTION lpUpdate_isLeaf(
    IN inObjectId            Integer   , 
    IN inObjectLinkDescId    Integer   
)
RETURNS VOID AS
$BODY$
BEGIN
   -- ���� �� ������ ��� ������� ��� ������ �������� ���������
   IF (SELECT Count(*) FROM ObjectLink WHERE DescId = inObjectLinkDescId AND ChildObjectId = inObjectId) > 0 THEN
      -- ���������� �������� ����\����� 
      PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_isLeaf(), inObjectId, false);
   ELSE
      PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_isLeaf(), inObjectId, true);
   END IF;

END;$BODY$ LANGUAGE PLPGSQL;
ALTER FUNCTION lpUpdate_isLeaf (Integer, Integer) OWNER TO POSTGRES;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.07.13                          *

*/

-- ����
-- SELECT * FROM lpUpdate_Object_Enum_byCode (inCode:= 10100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_10100');
