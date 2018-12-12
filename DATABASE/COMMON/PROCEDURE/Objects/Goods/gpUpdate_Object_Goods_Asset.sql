 -- Function: gpUpdate_Object_Goods_Asset()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_Asset (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_Asset(
    IN inId                  Integer,    --
    IN inAssetId             Integer,    --
    IN inSession             TVarChar
)

RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());

     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Asset(), inId, inAssetId);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
END;
$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.12.18         *
*/
