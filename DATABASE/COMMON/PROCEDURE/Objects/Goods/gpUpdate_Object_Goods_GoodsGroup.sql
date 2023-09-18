 -- Function: gpUpdate_Object_Goods_GoodsGroup()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_GoodsGroup (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_GoodsGroup(
    IN inId                  Integer   ,
    IN inGoodsGroupId        Integer   ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGroupNameFull TVarChar; 
   DECLARE vbIsAsset Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpGetUserBySession (inSession); 
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Goods_GoodsGroup());

   IF COALESCE (inGoodsGroupId,0) = 0
   THEN
       RAISE EXCEPTION '������. ����� ������ �� �������.'; 
   END IF;
   
   
   -- �������� �������� <������ �������� ������>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());
   vbIsAsset:= lfGet_Object_GoodsGroup_isAsset (inGoodsGroupId);

   -- ��������� ����� � <������� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), inId, inGoodsGroupId);
   -- ��������� �������� <������ �������� ������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), inId, vbGroupNameFull);
   -- �������� �������� <������� - ��>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Asset(), inId, vbIsAsset);
          
   
   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION '����. ��.'; 
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
--
