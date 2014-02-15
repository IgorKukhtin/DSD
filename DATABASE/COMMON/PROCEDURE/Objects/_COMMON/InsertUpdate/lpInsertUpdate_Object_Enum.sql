-- Function: lpInsertUpdate_Object_Enum() - ������ �� �� ....

-- DROP FUNCTION lpInsertUpdate_Object_Enum (IN inId Integer, IN inDescId Integer, IN inCode Integer, IN inName TVarChar, IN inEnumName TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Enum(
    IN inId           Integer   ,    -- <���� �������>
    IN inDescId       Integer   , 
    IN inCode         Integer   , 
    IN inName         TVarChar  ,
    IN inEnumName     TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbCode Integer;   
BEGIN

   -- !!! ����������� ������� �������� ������������ !!!
   -- �������� ������������ inEnumName


   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   vbCode:= lfGet_ObjectCode (inCode, inDescId);

   -- ��������� <������>
   inId := lpInsertUpdate_Object (inId, inDescId, vbCode, inName);

   -- ��������� �������� <Enum>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), inId, inEnumName);

END;$BODY$ LANGUAGE PLPGSQL;
ALTER FUNCTION lpInsertUpdate_Object_Enum (Integer, Integer, Integer, TVarChar, TVarChar) OWNER TO POSTGRES;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.06.13                                        *

*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_Enum (inId:= 0, inDescId:= zc_Object_Goods(), inCode:= -1, inName:= 'test-goods-enum', inEnumName:= 'zc_test_goods_enum');
