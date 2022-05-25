-- Function: gpUpdate_Object_GoodsByGoodsKind_Sticker (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpUpdate_Object_GoodsByGoodsKind_Sticker (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsByGoodsKind_Sticker(
    IN inId                      Integer  , -- ���� ������� <�����>
    IN inWeightPackageSticker    TFloat   , -- ��� 1-��� ������
    IN inSession                 TVarChar 
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_GoodsByGoodsKind_Sticker());


   -- �������� - ��� � ����� ������ �� �����
   IF vbUserId = 5
   THEN
       RAISE EXCEPTION '������.��� ���� - ��� � ����� ������ �� �����.';
   END IF;


   -- �������� - ��� � ����� ������ �� �����
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� ����������� �� ����������.';
   END IF;

   -- ��������� �������� <��� 1-��� ������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker(), inId, inWeightPackageSticker);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.02.18         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_GoodsByGoodsKind_Sticker (inId:= 1, inWeightPackageSticker:=0, inUserId:= 2)