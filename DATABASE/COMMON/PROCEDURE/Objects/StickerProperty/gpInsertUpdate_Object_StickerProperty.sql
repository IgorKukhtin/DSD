-- Function: gpInsertUpdate_Object_StickerProperty()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerProperty(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TBlob, TFloat, TFloat,TFloat,TFloat,TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerProperty(
 INOUT ioId                  Integer   , -- ���� ������� <�����>
    IN inCode                Integer   , -- ��� ������� <�����>
    IN inComment             TVarChar  , -- ����������
    IN inJuridicalId         Integer   , -- ������ ��.����, ����.����, ����������
    IN inGoodsId             Integer   , -- �����
    IN inStickerPropertyFileId       Integer   , -- 
    IN inStickerPropertyGroupName    TVarChar  , -- 
    IN inStickerPropertyTypeName     TVarChar  , -- 
    IN inStickerPropertyTagName      TVarChar  , -- 
    IN inStickerPropertySortName     TVarChar  , -- 
    IN inStickerPropertyNormName     TVarChar  , -- 
    IN inInfo                TBlob     , -- 
    IN inValue1              TFloat    , -- �������� ����
    IN inValue2              TFloat    , -- �������� ����
    IN inValue3              TFloat    , --
    IN inValue4              TFloat    , --
    IN inValue5              TFloat    , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbCode              Integer;   
   DECLARE vbStickerPropertyGroupId    Integer;
   DECLARE vbStickerPropertyTypeId     Integer;
   DECLARE vbStickerPropertyTagId      Integer;
   DECLARE vbStickerPropertySortId     Integer;
   DECLARE vbStickerPropertyNormId     Integer;
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
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_Goods(), ioId, inGoodsId);
   -- ��������� ���� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertyFile(), ioId, inStickerPropertyFileId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_StickerProperty_Info(), ioId, inInfo);
   
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
   
   -- �������� ����� "��� �������� (������)"
   -- ���� �� ������� ��������� ����� ������� � ����������
   vbStickerPropertyGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPropertyGroup() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerPropertyGroupName)));
   IF COALESCE (vbStickerPropertyGroupId, 0) = 0 AND COALESCE (inStickerPropertyGroupName, '')<> ''
   THEN
       -- ���������� ����� �������
       vbStickerPropertyGroupId := gpInsertUpdate_Object_StickerPropertyGroup (ioId     := 0
                                                             , inCode   := lfGet_ObjectCode(0, zc_Object_StickerPropertyGroup()) 
                                                             , inName   := TRIM(inStickerPropertyGroupName)
                                                             , inComment:= '' ::TVarChar
                                                             , inSession:= inSession
                                                              );
   END IF; 

   -- �������� ����� "������ ������������ ��������"
   -- ���� �� ������� ��������� ����� ������� � ����������
   vbStickerPropertyTypeId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPropertyType() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerPropertyTypeName)));
   IF COALESCE (vbStickerPropertyTypeId, 0) = 0 AND COALESCE (inStickerPropertyTypeName, '')<> ''
   THEN
       -- ���������� ����� �������
       vbStickerPropertyTypeId := gpInsertUpdate_Object_StickerPropertyType (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode(0, zc_Object_StickerPropertyType()) 
                                                           , inName   := TRIM(inStickerPropertyTypeName)
                                                           , inComment:= '' ::TVarChar
                                                           , inSession:= inSession
                                                            );
   END IF;

   -- �������� ����� "�������� ��������"
   -- ���� �� ������� ��������� ����� ������� � ����������
   vbStickerPropertyTagId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPropertyTag() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerPropertyTagName)));
   IF COALESCE (vbStickerPropertyTagId, 0) = 0 AND COALESCE (inStickerPropertyTagName, '')<> ''
   THEN
       -- ���������� ����� �������
       vbStickerPropertyTagId := gpInsertUpdate_Object_StickerPropertyTag (ioId     := 0
                                                         , inCode   := lfGet_ObjectCode(0, zc_Object_StickerPropertyTag()) 
                                                         , inName   := TRIM(inStickerPropertyTagName)
                                                         , inComment:= '' ::TVarChar
                                                         , inSession:= inSession
                                                          );
   END IF;

   -- �������� ����� " 	��������� ��������"
   -- ���� �� ������� ��������� ����� ������� � ����������
   vbStickerPropertySortId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPropertySort() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerPropertySortName)));
   IF COALESCE (vbStickerPropertySortId, 0) = 0 AND COALESCE (inStickerPropertySortName, '')<> ''
   THEN
       -- ���������� ����� �������
       vbStickerPropertySortId := gpInsertUpdate_Object_StickerPropertySort (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode(0, zc_Object_StickerPropertySort()) 
                                                           , inName   := TRIM(inStickerPropertySortName)
                                                           , inComment:= '' ::TVarChar
                                                           , inSession:= inSession
                                                            );
   END IF;

   -- �������� ����� "�� ��� ����"
   -- ���� �� ������� ��������� ����� ������� � ����������
   vbStickerPropertyNormId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPropertyNorm() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerPropertyNormName)));
   IF COALESCE (vbStickerPropertyNormId, 0) = 0 AND COALESCE (inStickerPropertyNormName, '')<> ''
   THEN
       -- ���������� ����� �������
       vbStickerPropertyNormId := gpInsertUpdate_Object_StickerPropertyNorm (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode(0, zc_Object_StickerPropertyNorm()) 
                                                           , inName   := TRIM(inStickerPropertyNormName)
                                                           , inComment:= '' ::TVarChar
                                                           , inSession:= inSession
                                                            );
   END IF;
  

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertyGroup(), ioId, vbStickerPropertyGroupId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertyType(), ioId, vbStickerPropertyTypeId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertyTag(), ioId, vbStickerPropertyTagId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertySort(), ioId, vbStickerPropertySortId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertyNorm(), ioId, vbStickerPropertyNormId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
 
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.10.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_StickerProperty (ioId:=0, inCode:=-1, inName:= 'TEST-StickerProperty', ... , inSession:= '2')
