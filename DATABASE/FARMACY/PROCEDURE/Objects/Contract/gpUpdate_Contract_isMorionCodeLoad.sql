-- Function: gpUpdate_Contract_isMorionCodeLoad()

DROP FUNCTION IF EXISTS gpUpdate_Contract_isMorionCodeLoad(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Contract_isMorionCodeLoad(
    IN inId                  Integer   ,    -- ���� ������� <>
    IN inisMorionCodeLoad        Boolean   ,    -- 
   OUT outisMorionCodeLoad       Boolean   ,
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
   outisMorionCodeLoad:= NOT inisMorionCodeLoad;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_MorionCodeLoad(), inId, outisMorionCodeLoad);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.02.21                                                       *
*/
--select * from gpUpdate_Contract_isMorionCodeLoad(inId := 1393106 , inisMorionCodeLoad := 'False' ,  inSession := '3');