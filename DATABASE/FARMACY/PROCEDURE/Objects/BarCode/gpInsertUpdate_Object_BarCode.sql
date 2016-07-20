-- Function: gpInsertUpdate_Object_BarCode()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BarCode (Integer, Integer, TVarChar, Integer, Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BarCode(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������>
    IN inCode                    Integer   ,    -- ��� ������� <>
    IN inBarCodeName             TVarChar  ,    -- ��������
    IN inGoodsId                 Integer   ,    -- �����
    IN inObjectId                Integer   ,    -- ����������� � ��������� ���������� ����
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BarCode());

 -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_BarCode());
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_BarCode(), inBarCodeName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_BarCode(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BarCode(), vbCode_calc, inBarCodeName, inAccessKeyId:= NULL);


   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BarCode_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BarCode_Object(), ioId, inObjectId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.07.16         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BarCode ()                            
