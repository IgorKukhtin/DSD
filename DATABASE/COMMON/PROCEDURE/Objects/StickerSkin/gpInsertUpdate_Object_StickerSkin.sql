 -- Function: gpInsertUpdate_Object_StickerSkin()

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerSkin (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerSkin(
   INOUT ioId                       Integer,     -- ��
      IN incode                     Integer,     -- ��� 
      IN inName                     TVarChar,    -- ������������ 
      IN inComment                  TVarChar,    -- ����������
      IN inSession                  TVarChar     -- ������������
      )
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_StickerSkin());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_StickerSkin()); 
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_StickerSkin(), inName);
   -- �������� ���� ������������ ��� �������� <��� >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StickerSkin(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StickerSkin(), vbCode_calc, inName);
   
   -- ��������� ��-�� <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_StickerSkin_Comment(), ioId, inComment);

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
