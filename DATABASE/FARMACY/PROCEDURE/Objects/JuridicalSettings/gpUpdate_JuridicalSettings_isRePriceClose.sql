-- Function: 
DROP FUNCTION IF EXISTS gpUpdate_JuridicalSettings_isRePriceClose(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_JuridicalSettings_isRePriceClose(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inisRePriceClose      Boolean   ,    -- ������ ������ ��� ��������������
   OUT outisRePriceClose     Boolean   ,
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
   outisRePriceClose:= NOT inisRePriceClose;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalSettings_isRePriceClose(), inId, inisRePriceClose);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.10.18         *
*/