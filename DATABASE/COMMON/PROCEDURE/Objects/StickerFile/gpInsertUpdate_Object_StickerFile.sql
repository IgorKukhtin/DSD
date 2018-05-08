 -- Function: gpInsertUpdate_Object_StickerFile()

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerFile (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerFile (Integer, Integer, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerFile (Integer, Integer, Integer, Integer, TVarChar, TVarChar
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerFile (Integer, Integer, Integer, Integer, TVarChar, TVarChar
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerFile(
   INOUT ioId                       Integer,     -- ��
      IN incode                     Integer,     -- ���
      IN inJuridicalId              Integer,     --
      IN inTradeMarkId              Integer,     --
      IN inLanguageName             TVarChar,    --
      IN inComment                  TVarChar,    -- ����������
      IN inWidth1                   TFloat, 
      IN inWidth2                   TFloat,
      IN inWidth3                   TFloat,
      IN inWidth4                   TFloat,
      IN inWidth5                   TFloat,
      IN inWidth6                   TFloat,
      IN inWidth7                   TFloat,
      IN inWidth8                   TFloat,
      IN inWidth9                   TFloat,
      IN inWidth10                  TFloat,
      IN inLevel1                   TFloat, 
      IN inLevel2                   TFloat,
      IN inLeft1                    TFloat, 
      IN inLeft2                    TFloat,
      IN inisDefault                Boolean ,    --
      IN inSession                  TVarChar     -- ������������
      )
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbCode_calc  Integer;
   DECLARE vbLanguageId Integer;
   DECLARE vbName       TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_StickerFile());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_StickerFile());

   vbName := TRIM (TRIM (inComment)
                || COALESCE ((SELECT ' ' || TRIM (Object.ValueData) FROM Object where Object.Id = inJuridicalId), '')
                || COALESCE ((SELECT ' ' || TRIM (Object.ValueData) FROM Object where Object.Id = inTradeMarkId), '')
                ||' - ' || TRIM (inLanguageName)
                  );

   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_StickerFile(), vbName);
   -- �������� ���� ������������ ��� �������� <��� >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StickerFile(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StickerFile(), vbCode_calc, vbName);

   -- ��������� ��-�� <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_StickerFile_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerFile_Default(), ioId, inisDefault);

    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerFile_Juridical(), ioId, inJuridicalId);
    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerFile_TradeMark(), ioId, inTradeMarkId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width1(), ioId, inWidth1);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width2(), ioId, inWidth2);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width3(), ioId, inWidth3);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width4(), ioId, inWidth4);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width5(), ioId, inWidth5);
      -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width6(), ioId, inWidth6);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width7(), ioId, inWidth7);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width8(), ioId, inWidth8);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width9(), ioId, inWidth9);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width10(), ioId, inWidth10);


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Level1(), ioId, inLevel1);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Level2(), ioId, inLevel2);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Left1(), ioId, inLeft1);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Left2(), ioId, inLeft2);
   

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
 08.05.18         *
 19.12.17         *
 23.10.17         *
*/

-- ����
--
