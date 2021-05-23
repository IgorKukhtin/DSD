-- Function: gpUpdateObject_GoodsGroup_UKTZED()

DROP FUNCTION IF EXISTS gpUpdateObject_GoodsGroup_UKTZED (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_GoodsGroup_UKTZED(
    IN inId                  Integer   , -- ���� ������� <�����>
    IN inUKTZED              TVarChar  , -- ��� ������ �� ��� ���
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectString_GoodsGroup_UKTZED());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_UKTZED(), inId, inUKTZED);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.01.17         *
*/


-- ����
-- SELECT * FROM gpUpdateObject_Goods_UKTZED (ioId:= 275079, inUKTZED:= '456/45', inSession:= '2')
