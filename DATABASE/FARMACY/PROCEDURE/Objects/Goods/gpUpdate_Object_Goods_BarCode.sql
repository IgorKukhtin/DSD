-- Function: gpInsertUpdate_OgpUpdate_Object_Goods_BarCodebject_Goods()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_BarCode (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_BarCode(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inBarCode             TVarChar  ,    -- �����-��� �������������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId Integer;
   DECLARE vbCode Integer;
   DECLARE vbMainGoodsId Integer;
   DECLARE vbBarCodeGoodsId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������������ <�������� ����>
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     -- �������� <�������� ����> - !!!������ ��� Insert!!!
     IF COALESCE (vbObjectId, 0) <= 0 AND COALESCE (inId, 0) = 0 THEN
        RAISE EXCEPTION '� ������������ "%" �� ����������� �������� ����', lfGet_Object_ValueData (vbUserId);
     END IF;

     -- <���>
     IF COALESCE (inId, 0) = 0
     THEN
          RAISE EXCEPTION '����� ������ ���� ���������';
     END IF;
  
     -- !!!��� �� ��������!!!
      vbCode:= (SELECT ObjectCode FROM Object WHERE Id = inId);

     -- !!!����� �� ���� - vbCode!!!
     vbMainGoodsId:= (SELECT Object_Goods_Main_View.Id FROM Object_Goods_Main_View  WHERE Object_Goods_Main_View.GoodsCode = vbCode);

     IF COALESCE (inBarCode, '') <> '' 
     THEN
          -- ������������� ����� �� �����-�����
          SELECT Id INTO vbBarCodeGoodsId
          FROM Object_Goods_View 
          WHERE ObjectId = zc_Enum_GlobalConst_BarCode() 
            AND GoodsName = inBarCode;

          IF COALESCE (vbBarCodeGoodsId, 0) = 0 
          THEN
               -- ������� ����� ����, ������� ��� ���
               vbBarCodeGoodsId:= lpInsertUpdate_Object(0, zc_Object_Goods(), 0, inBarCode);
               PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Object(), vbBarCodeGoodsId, zc_Enum_GlobalConst_BarCode());
          END IF;       

          IF NOT EXISTS (SELECT 1 FROM Object_LinkGoods_View 
                         WHERE ObjectId = zc_Enum_GlobalConst_BarCode() 
                           AND GoodsId = vbBarCodeGoodsId 
                           AND GoodsMainId = vbMainGoodsId) 
          THEN
               PERFORM gpInsertUpdate_Object_LinkGoods(0, vbMainGoodsId, vbBarCodeGoodsId, inSession);
          END IF;     
      END IF;          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 11.07.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
