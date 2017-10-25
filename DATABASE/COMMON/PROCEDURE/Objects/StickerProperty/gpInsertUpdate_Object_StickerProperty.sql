-- Function: gpInsertUpdate_Object_StickerProperty()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerProperty(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, Boolean, TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerProperty(
 INOUT ioId                  Integer   , -- ���� ������� <>
    IN inCode                Integer   , -- ��� ������� <>
    IN inComment             TVarChar  , -- ����������
    IN inStickerId           Integer   , -- ������ ��.����, ����.����, ����������
    IN inGoodsKindId         Integer   , -- �����
    IN inStickerFileId       Integer   , -- 
    IN inStickerSkinName     TVarChar  , -- 
    IN inStickerPackName     TVarChar  , -- 
    IN inFix                 Boolean     , -- 
    IN inValue1              TFloat    , -- 
    IN inValue2              TFloat    , -- 
    IN inValue3              TFloat    , --
    IN inValue4              TFloat    , --
    IN inValue5              TFloat    , --
    IN inValue6              TFloat    , --
    IN inValue7              TFloat    , --
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
   vbCode:=lfGet_ObjectCode (inCode, zc_Object_StickerProperty());
   
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
     
   -- �������� ����� "��������"
   -- ���� �� ������� ��������� ����� ������� � ����������
   vbStickerSkinId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerSkin() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerSkinName)));
   IF COALESCE (vbStickerSkinId, 0) = 0 AND COALESCE (inStickerSkinName, '')<> ''
   THEN
       -- ���������� ����� �������
       vbStickerSkinId := gpInsertUpdate_Object_StickerSkin (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode(0, zc_Object_StickerSkin()) 
                                                           , inName   := TRIM(inStickerSkinName)
                                                           , inComment:= '' ::TVarChar
                                                           , inSession:= inSession
                                                            );
   END IF; 

   -- �������� ����� "��� ���������"
   -- ���� �� ������� ��������� ����� ������� � ����������
   vbStickerPackId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPack() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerPackName)));
   IF COALESCE (vbStickerPackId, 0) = 0 AND COALESCE (inStickerPackName, '')<> ''
   THEN
       -- ���������� ����� �������
       vbStickerPackId := gpInsertUpdate_Object_StickerPack (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode(0, zc_Object_StickerPack()) 
                                                           , inName   := TRIM(inStickerPackName)
                                                           , inComment:= '' ::TVarChar
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
 24.10.17         *
*/

-- ����
-- 