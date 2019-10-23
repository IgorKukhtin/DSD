-- Function: gpUpdate_Object_Retail_IsOrderMin()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_IsOrderMin (Integer, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_IsOrderMin(
    IN inId                  Integer   ,  -- ���� ������� <> 
    IN inIsOrderMin          boolean   , 
   OUT outIsOrderMin          boolean   , 
    IN inSession             TVarChar     -- ������ ������������
)
  RETURNS boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_IsOrderMin());

   outIsOrderMin:= NOT inIsOrderMin;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Retail_isOrderMin(), inId, outIsOrderMin);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.10.19         *
*/

-- ����
--