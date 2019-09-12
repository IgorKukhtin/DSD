-- Function: gpUpdate_Contract_isBarCode()

DROP FUNCTION IF EXISTS gpUpdate_Contract_isBarCode(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Contract_isBarCode(
    IN inId                  Integer   ,    -- ���� ������� <>
    IN inisBarCode           Boolean   ,    -- 
   OUT outisBarCode          Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Contract());

   -- ���������� �������
   outisBarCode:= NOT inisBarCode;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_BarCode(), inId, outisBarCode);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.09.19         *
*/
--select * from gpUpdate_Contract_isBarCode(inId := 1393106 , inisBarCode := 'False' ,  inSession := '3');