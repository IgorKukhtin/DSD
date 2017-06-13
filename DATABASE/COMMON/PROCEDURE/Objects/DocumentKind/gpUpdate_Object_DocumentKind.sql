-- Function: gpUpdate_Object_DocumentKind()

DROP FUNCTION IF EXISTS gpUpdate_Object_DocumentKind (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DocumentKind(
    IN inId                  Integer  , -- ���� ������� <���� ����������>
    IN inGoodsId             Integer  , -- ��� ������ �� ��� ���
    IN inGoodsKindId         Integer  , -- ������� ���������������� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_DocumentKind());
     
     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DocumentKind_Goods(), inId, inGoodsId);
     -- ��������� ����� � <����� �������>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DocumentKind_GoodsKind(), inId, inGoodsKindId);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.06.17         *
*/


-- ����
-- SELECT * FROM gpUpdate_Object_DocumentKind (ioId:= 275079, inGoodsId:= 0, inGoodsKindId:= 0, inSession:= '2')
