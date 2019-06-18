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
   DECLARE vbLinkGoodsId Integer;
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
  
     -- ��������  �����-����
     IF COALESCE (inBarCode, '') <> ''
     THEN
        PERFORM zfCheck_BarCode(inBarCode, True);
     END IF;

     -- !!!��� �� ��������!!!
     vbCode:= (SELECT ObjectCode FROM Object WHERE Id = inId);

     -- !!!����� �� ���� - vbCode!!!
     vbMainGoodsId:= (SELECT Object_Goods_Main_View.Id FROM Object_Goods_Main_View  WHERE Object_Goods_Main_View.GoodsCode = vbCode);

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
     ELSE
          -- ��������� �������������
          IF EXISTS(SELECT ObjectLink_LinkGoods_Goods.ObjectId
                    FROM ObjectLink AS ObjectLink_Goods_Object
                         JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                         ON ObjectLink_LinkGoods_Goods.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                                        AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                         JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                         ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                        AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                        AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId <> vbMainGoodsId
                   WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                     AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                     AND ObjectLink_Goods_Object.ObjectId = vbBarCodeGoodsId)             
          THEN
             RAISE EXCEPTION '�����-��� "%" ����������� � ������� ������..', inBarCode;
          END IF;
     END IF;       

     /*IF NOT EXISTS (SELECT 1 FROM Object_LinkGoods_View 
                    WHERE ObjectId = zc_Enum_GlobalConst_BarCode() 
                      AND GoodsId = vbBarCodeGoodsId 
                      AND GoodsMainId = vbMainGoodsId) 
     THEN
          PERFORM gpInsertUpdate_Object_LinkGoods(0, vbMainGoodsId, vbBarCodeGoodsId, inSession);
     END IF; */    
      
     SELECT ObjectLink_LinkGoods_Goods.ObjectId
     INTO vbLinkGoodsId 
     FROM ObjectLink AS ObjectLink_LinkGoods_Goods
      JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                      ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                     AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                     AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = vbMainGoodsId
     WHERE ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
     AND ObjectLink_LinkGoods_Goods.ChildObjectId = vbBarCodeGoodsId;
     
     IF COALESCE (vbLinkGoodsId, 0) = 0
     THEN
         vbLinkGoodsId:= gpInsertUpdate_Object_LinkGoods (0, vbMainGoodsId, vbBarCodeGoodsId, inSession);
     END IF;  
     
/*     IF COALESCE (vbLinkGoodsId, 0) <> 0  
     THEN -- ������ �������� ����� "����� �����-��� -> ������� �����"
      PERFORM lpDelete_Object(ObjectLink_LinkGoods_Goods.ObjectId, zfCalc_UserAdmin())     
      FROM ObjectLink AS ObjectLink_Goods_Object
           JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                           ON ObjectLink_LinkGoods_Goods.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                          AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                          AND ObjectLink_LinkGoods_Goods.ObjectId <> vbLinkGoodsId
           JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                           ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                          AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                          AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = vbMainGoodsId
      WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
        AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode();
     END IF;
*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 11.07.17         *
*/

-- ����
-- select * from gpUpdate_Object_Goods_BarCode(inId := 3690795 , inBarCode := '' ,  inSession := '3');