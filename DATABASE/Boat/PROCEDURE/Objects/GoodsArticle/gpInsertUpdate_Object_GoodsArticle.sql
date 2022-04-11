-- Function: gpInsertUpdate_Object_GoodsArticle()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsArticle(Integer, TVarChar, Integer, TVarChar);
CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsArticle(
 INOUT ioId                     Integer   , -- ���� ������� >
    IN inName                   TVarChar  , --
    IN inGoodsId                Integer,
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsArticle(), 0, inName, NULL);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsArticle_Goods(), ioId, inGoodsId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.04.22         *
*/

-- ����
--