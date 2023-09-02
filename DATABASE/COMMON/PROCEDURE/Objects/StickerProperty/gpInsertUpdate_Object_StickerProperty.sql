-- Function: gpInsertUpdate_Object_StickerProperty()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerProperty(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Boolean, TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerProperty(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerProperty(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerProperty(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerProperty(
 INOUT ioId                  Integer   , -- ���� ������� <>
    IN inCode                Integer   , -- ��� ������� <>
    IN inComment             TVarChar  , -- ����������
    IN inStickerId           Integer   , -- ������ ��.����, ����.����, ����������
    IN inGoodsKindId         Integer   , -- �����
    IN inStickerFileId       Integer   , --
    IN inStickerFileId_70_70 Integer   , --
    IN inStickerSkinName     TVarChar  , --
    IN inStickerPackName     TVarChar  , --
    IN inBarCode             TVarChar  , --
    IN inFix                 Boolean   , --
    IN inValue1              TFloat    , --
    IN inValue2              TFloat    , --
    IN inValue3              TFloat    , --
    IN inValue4              TFloat    , --
    IN inValue5              TFloat    , --
    IN inValue6              TFloat    , --
    IN inValue7              TFloat    , --
    IN inValue8              TFloat    , --
    IN inValue9              TFloat    , --
    IN inValue10             TFloat    , --
    IN inValue11             TFloat    , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbCode              Integer;
   DECLARE vbStickerSkinId     Integer;
   DECLARE vbStickerPackId     Integer;
   DECLARE vbIsUpdate          Boolean;

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_StickerProperty());

   -- !!! ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_StickerProperty());

   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StickerProperty(), vbCode);

--       RAISE EXCEPTION '������.�������� <������ �������> ������ ���� �����������.';

   -- ���������� <�������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StickerProperty(), vbCode, COALESCE (inComment, ''));

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_Sticker(), ioId, inStickerId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_GoodsKind(), ioId, inGoodsKindId);
   -- ��������� ���� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerFile(), ioId, inStickerFileId);
   -- ��������� ���� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerFile_70_70(), ioId, inStickerFileId_70_70);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_StickerProperty_BarCode(), ioId, inBarCode);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerProperty_Fix(), ioId, inFix);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value1(), ioId, inValue1);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value2(), ioId, inValue2);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value3(), ioId, inValue3);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value4(), ioId, inValue4);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value5(), ioId, inValue5);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value6(), ioId, inValue6);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value7(), ioId, inValue7);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value8(), ioId, inValue8);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value9(), ioId, inValue9);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value10(), ioId, inValue10);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value11(), ioId, inValue11);


   -- �������� "��������"
   IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_StickerSkin() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerSkinName)) AND TRIM (inStickerSkinName) <> '')
   THEN
         RAISE EXCEPTION '������.�� ��������� �������� �������� <%>', inStickerSkinName;
   END IF;
   -- �����
   vbStickerSkinId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerSkin() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerSkinName)) AND TRIM (inStickerSkinName) <> '');
   IF COALESCE (vbStickerSkinId, 0) = 0 AND COALESCE (inStickerSkinName, '') <> ''
   THEN
       -- ���� �� ����� - ��������� ����� ������� � ����������
       vbStickerSkinId := gpInsertUpdate_Object_StickerSkin (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode (0, zc_Object_StickerSkin())
                                                           , inName   := TRIM (inStickerSkinName)
                                                           , inComment:= ''
                                                           , inSession:= inSession
                                                            );
   END IF;

   -- �������� "��� ���������"
   IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_StickerPack() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerPackName)) AND TRIM (inStickerPackName) <> '')
   THEN
         RAISE EXCEPTION '������.�� ��������� �������� ��� ��������� <%>', inStickerPackName;
   END IF;
   -- �����
   vbStickerPackId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPack() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerPackName)) AND TRIM (inStickerPackName) <> '');
   IF COALESCE (vbStickerPackId, 0) = 0 AND COALESCE (inStickerPackName, '') <> ''
   THEN
       -- ���� �� ����� - ��������� ����� ������� � ����������
       vbStickerPackId := gpInsertUpdate_Object_StickerPack (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode (0, zc_Object_StickerPack())
                                                           , inName   := TRIM (inStickerPackName)
                                                           , inComment:= ''
                                                           , inSession:= inSession
                                                            );
   END IF;

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerSkin(), ioId, vbStickerSkinId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPack(), ioId, vbStickerPackId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.09.23         *
 24.10.17         *
*/

-- ����
--