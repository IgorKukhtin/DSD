-- Function: gpInsertUpdate_Object_TelegramGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TelegramGroup(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TelegramGroup(
 INOUT ioId               Integer   ,     -- ���� ������� <�������> 
    IN inCode             Integer   ,     -- ��� �������  
    IN inName             TVarChar  ,     -- �������� ������� 
    IN inTelegramId       TVarChar  ,     -- ������ ����������� � �������� �����
    IN inTelegramBotToken TVarChar  ,     -- ����� ����������� �������� ���� � �������� �����
    IN inSession          TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_TelegramGroup());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_TelegramGroup());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_TelegramGroup(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_TelegramGroup(), inCode);


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TelegramGroup(), inCode, inName);
         
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_TelegramGroup_Id(), ioId, inTelegramId);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_TelegramGroup_BotToken(), ioId, inTelegramBotToken);

   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.09.22         *
*/

-- ����
--