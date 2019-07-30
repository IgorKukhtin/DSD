-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderFinanceProperty (Integer, Integer, Integer, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderFinanceProperty(
 INOUT ioId                      Integer   ,   	-- ���� ������� <>
    IN inOrderFinanceId          Integer   ,    -- 
    IN inObjectId                Integer   ,    -- 
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderFinanceProperty());
   vbUserId := lpGetUserBySession (inSession); 
  
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderFinanceProperty(), 0, '');

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderFinanceProperty_OrderFinance(), ioId, inOrderFinanceId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderFinanceProperty_Object(), ioId, inObjectId);   


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.07.19         * 

*/

-- ����
--