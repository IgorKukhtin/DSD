-- Function: 
DROP FUNCTION IF EXISTS gpUpdate_JuridicalSettings_isPriceClose(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_JuridicalSettings_isPriceClose(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inisPriceClose        Boolean   ,    -- ������ ������
   OUT outisPriceClose       Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   outisPriceClose:= NOT inisPriceClose;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalSettings_isPriceClose(), inId, inisPriceClose);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 07.10.18         *
*/