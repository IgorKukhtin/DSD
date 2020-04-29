 -- Function: gpUpdate_Object_Goods_AssetProd()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_AssetProd (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_AssetProd(
    IN inId                  Integer,    --
    IN inAssetProdId         Integer,    --
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
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_AssetProd(), inId, inAssetProdId);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
END;
$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.04.20         *
*/
