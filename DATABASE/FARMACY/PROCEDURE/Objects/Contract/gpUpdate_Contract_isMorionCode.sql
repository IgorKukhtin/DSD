-- Function: gpUpdate_Contract_isMorionCode()

DROP FUNCTION IF EXISTS gpUpdate_Contract_isMorionCode(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Contract_isMorionCode(
    IN inId                  Integer   ,    -- ���� ������� <>
    IN inisMorionCode        Boolean   ,    -- 
   OUT outisMorionCode       Boolean   ,
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
   outisMorionCode:= NOT inisMorionCode;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_MorionCode(), inId, outisMorionCode);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.09.19         *
*/
--select * from gpUpdate_Contract_isMorionCode(inId := 1393106 , inisMorionCode := 'False' ,  inSession := '3');