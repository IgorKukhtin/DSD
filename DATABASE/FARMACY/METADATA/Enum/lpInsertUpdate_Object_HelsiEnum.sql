-- Function: lpInsertUpdate_Object_HelsiEnum() - ������ �� �� ....

-- DROP FUNCTION lpInsertUpdate_Object_HelsiEnum (IN inId Integer, IN inDescId Integer, IN inCode Integer, IN inName TVarChar, IN inEnumName TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_HelsiEnum(
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
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_HelsiEnum(), inId, inEnumName);

END;$BODY$ LANGUAGE PLPGSQL;
ALTER FUNCTION lpInsertUpdate_Object_HelsiEnum (Integer, Integer, Integer, TVarChar, TVarChar) OWNER TO POSTGRES;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.04.19                                        *

*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_HelsiEnum (inId:= 0, inDescId:= zc_Object_Goods(), inCode:= -1, inName:= 'test-goods-enum', inEnumName:= 'zc_test_goods_enum');
