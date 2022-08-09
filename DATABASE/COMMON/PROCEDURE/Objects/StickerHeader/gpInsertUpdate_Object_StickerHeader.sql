-- Function: gpInsertUpdate_Object_StickerHeader()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerHeader(Integer, Integer, TVarChar, Text, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerHeader(
 INOUT ioId                    Integer   ,     -- ���� ������� <�������� ����> 
    IN inCode                  Integer   ,     -- ��� �������  
    IN inName                  TVarChar  ,     -- �������� ������� 
    IN inInfo                  Text      ,     -- 
    IN inisDefault             Boolean   ,     --
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StickerHeader());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_StickerHeader());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_StickerHeader(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StickerHeader(), inCode);
  
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StickerHeader(), inCode, inName);
   
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_StickerHeader_Info(), ioId, inInfo);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerHeader_Default(), ioId, inisDefault);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.08.22         *
*/

-- ����
-- 