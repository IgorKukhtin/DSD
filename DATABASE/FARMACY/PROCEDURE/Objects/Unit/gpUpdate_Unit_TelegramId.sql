-- Function: gpUpdate_Unit_TelegramId()

DROP FUNCTION IF EXISTS gpUpdate_Unit_TelegramId(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_TelegramId(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inTelegramId          TVarChar  ,    -- ID ������ � Telegram	
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
      
   -- ID ������ � Telegram
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_TelegramId(), inId, TRIM(inTelegramId));

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.11.21                                                       *
*/

-- select * from gpUpdate_Unit_TelegramId(inId := 10779386 , inTelegramId := '2089181519' ,  inSession := '3');