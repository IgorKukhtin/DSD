-- Function: gpInsertUpdate_Object_GoodsPropertyValue_External()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue_External(Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyValue_External(
    IN inId                  Integer   ,    -- ���� ������� <�������� ������� ������� ��� ��������������>
    IN inArticleExternal     TVarChar  ,    -- ������� � ���� ����������
    IN inNameExternal        TVarChar  ,    -- �������� ����, ����,�� (��)
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Update_Object_GoodsPropertyValue_External());

   -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ��������.';
   END IF;
  
   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_ArticleExternal(), inId, inArticleExternal);
   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_NameExternal(), inId, inNameExternal);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsPropertyValue_External()

