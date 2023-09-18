 -- Function: gpInsertUpdate_Object_Goods_Group_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_Group_From_Excel (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_Group_From_Excel(
    IN inGoodsGroupId        Integer   ,
    IN inGoodsCode           Integer   , -- ��� ������� <�����>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGroupNameFull TVarChar; 
   DECLARE vbIsAsset Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpGetUserBySession (inSession); 
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Goods_GoodsGroup());

     --��������
     IF COALESCE (inGoodsGroupId,0) = 0
     THEN
         RAISE EXCEPTION '������. ����� ������ �� �������.'; 
     END IF;
     
     -- !!!������ ��� - ����������!!!
     IF COALESCE (inGoodsCode, 0) = 0 THEN
        RETURN; -- !!!�����!!!
     END IF;


     -- !!!����� �� ������!!!
     vbGoodsId:= (SELECT Object_Goods.Id
                  FROM Object AS Object_Goods
                  WHERE Object_Goods.ObjectCode = inGoodsCode
                    AND Object_Goods.DescId     = zc_Object_Goods()
                    AND inGoodsCode > 0
                 );
     -- ��������
     IF COALESCE (vbGoodsId, 0) = 0 THEN
        RETURN;
        RAISE EXCEPTION '������.�� ������ ����� � ��� = <%> .', inGoodsCode;
     END IF;

   
   -- �������� �������� <������ �������� ������>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());
   vbIsAsset:= lfGet_Object_GoodsGroup_isAsset (inGoodsGroupId);

   -- ��������� ����� � <������� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), vbGoodsId, inGoodsGroupId);
   -- ��������� �������� <������ �������� ������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), vbGoodsId, vbGroupNameFull);
   -- �������� �������� <������� - ��>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Asset(), vbGoodsId, vbIsAsset);

   
   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION '����. ��. <%>', vbGoodsId; 
   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.23         *
*/

-- ����
--select * from gpInsertUpdate_Object_Goods_Group_From_Excel(inGoodsGroupId := 1858 , inGoodsCode:=38 , inSession := '9457');
