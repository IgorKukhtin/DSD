 -- Function: gpInsertUpdate_Object_StickerFile()

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerFile (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerFile(
   INOUT ioId                       Integer,     -- ��
      IN incode                     Integer,     -- ��� 
      IN inName                     TVarChar,    -- ������������ 
      IN inJuridicalId              Integer,     --
      IN inTradeMarkId              Integer,     --
      IN inLanguageName             TVarChar,    --
      IN inComment                  TVarChar,    -- ����������
      IN inisDefault                Boolean ,    --
      IN inSession                  TVarChar     -- ������������
      )
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbCode_calc  Integer;
   DECLARE vbLanguageId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_StickerFile());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_StickerFile()); 
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_StickerFile(), inName);
   -- �������� ���� ������������ ��� �������� <��� >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StickerFile(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StickerFile(), vbCode_calc, inName);
   
   -- ��������� ��-�� <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_StickerFile_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerFile_Default(), ioId, inisDefault);

    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerFile_Juridical(), ioId, inJuridicalId);
    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerFile_TradeMark(), ioId, inTradeMarkId);
   

   -- �������� ����� "������ ������������ ��������"
   -- ���� �� ������� ��������� ����� ������� � ����������
   vbLanguageId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Language() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inLanguageName)));
   IF COALESCE (vbLanguageId, 0) = 0 AND COALESCE (inLanguageName, '')<> ''
   THEN
       -- ���������� ����� �������
       vbLanguageId := gpInsertUpdate_Object_Language (ioId     := 0
                                                     , inCode   := lfGet_ObjectCode(0, zc_Object_Language()) 
                                                     , inName   := TRIM(inLanguageName)
                                                     , inComment:= '' ::TVarChar
                                                     , inSession:= inSession
                                                      );
   END IF;

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerFile_Language(), ioId, vbLanguageId);
    
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.10.17         *
*/

-- ����
-- 
