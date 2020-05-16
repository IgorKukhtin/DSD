 -- Function: gpInsertUpdate_Object_Goods_AssetProd()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_AssetProd (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_AssetProd(
    IN inId                  Integer,    --
    IN inAssetProdId         Integer,    --
    IN inCountReceipt        TFloat , -- ����� ������ 
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
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountReceipt(), inId, inCountReceipt);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
END;
$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.05.20         *
*/
