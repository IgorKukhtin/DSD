-- Function: lpUpdate_Object_Enum_byCode() - ������ �� �� ....

-- DROP FUNCTION lpUpdate_Object_Enum_byCode (IN inCode Integer, IN inDescId Integer, IN inEnumName TVarChar);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Enum_byCode(
    IN inCode         Integer   , 
    IN inDescId       Integer   , 
    IN inEnumName     TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbCodeDesc TVarChar;
BEGIN

   -- !!! ����������� ������� �������� ������������ !!!
   -- �������� ������������ inEnumName


   -- ���������� �� ���� <������>
   SELECT Id INTO vbId FROM Object WHERE ObjectCode = inCode AND DescId = inDescId;

   IF COALESCE (vbId, 0) = 0
   THEN
       return;
       SELECT Code INTO vbCodeDesc FROM ObjectDesc WHERE Id = inDescId;
       RAISE EXCEPTION '�� ������ Id � lpUpdate_Object_Enum_byCode inCode = "%" ��� inEnumName = "%" � ����������� "%" inDescId = "%"', inCode, inEnumName, vbCodeDesc, inDescId;
   END IF;

   -- ��������� �������� <Enum>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbId, inEnumName);

END;$BODY$ LANGUAGE PLPGSQL;
ALTER FUNCTION lpUpdate_Object_Enum_byCode (Integer, Integer, TVarChar) OWNER TO POSTGRES;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.07.13                                        *

*/

-- ����
-- SELECT * FROM lpUpdate_Object_Enum_byCode (inCode:= 10100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_10100');
