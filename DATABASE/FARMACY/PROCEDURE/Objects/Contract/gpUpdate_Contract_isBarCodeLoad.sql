-- Function: gpUpdate_Contract_isBarCodeLoad()

DROP FUNCTION IF EXISTS gpUpdate_Contract_isBarCodeLoad(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Contract_isBarCodeLoad(
    IN inId                  Integer   ,    -- ���� ������� <>
    IN inisBarCodeLoad           Boolean   ,    -- 
   OUT outisBarCodeLoad          Boolean   ,
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
   outisBarCodeLoad:= NOT inisBarCodeLoad;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_BarCodeLoad(), inId, outisBarCodeLoad);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.02.21                                                       *
*/
--select * from gpUpdate_Contract_isBarCodeLoad(inId := 1393106 , inisBarCodeLoad := 'False' ,  inSession := '3');