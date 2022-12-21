--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsByGoodsKind_GoodsKindNew_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_GoodsKindNew_Load(
    IN inGoodsCode          Integer,       -- ��� ������������ ������
    IN inGoodsName          TVarChar,      -- �������� ������������ ������
    IN inGoodsKindName      TVarChar,      -- ��� ������������ ������
    IN inGoodsKindNewName   TVarChar,      -- ��� ������ �����
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsId Integer; 
  DECLARE vbGoodsKindId Integer;
  DECLARE vbGoodsByGoodsKindId Integer;
  DECLARE vbGoodsKindNewId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind());
   
   IF COALESCE (inGoodsCode,0) = 0
   THEN
       RETURN;
   END IF;
   
   
   --������� ������
   vbGoodsId        := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods());
   -- ������� ��� ������
   vbGoodsKindId    := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind());
   
   --�������� 
   IF COALESCE (vbGoodsId,0) = 0 THEN RAISE EXCEPTION '������.�� ������ ����� (%) %', inGoodsCode, inGoodsName; END IF;
   IF COALESCE (vbGoodsKindId,0) = 0 THEN RAISE EXCEPTION '������.�� ������ ��� ������ %, ����� (%) %', inGoodsKindName, inGoodsCode, inGoodsName; END IF;
               
   --�������  GoodsByGoodsKindId
   vbGoodsByGoodsKindId := (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                            FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                 LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                      ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                     AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                            WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                              AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = vbGoodsId
                              AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (vbGoodsKindId, 0)
                            );
   --��������
   IF COALESCE (vbGoodsByGoodsKindId,0) = 0 THEN RAISE EXCEPTION '������.�� ������� ����� ����� (%) % � ��� ������ %', inGoodsCode, inGoodsName, inGoodsKindName; END IF;
       
   --������� ����� ����� ��� ������ , ���� ��� ��� �������
   vbGoodsKindNewId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindNewName) AND Object.DescId = zc_Object_GoodsKindNew());
   
   IF COALESCE (vbGoodsKindNewId,0) = 0 
   THEN
       --������� ��� ������ �����
       vbGoodsKindNewId := gpInsertUpdate_Object_GoodsKindNew (0, 0, inGoodsKindNewName, inSession);
   END IF;
   
   
   -- ��������� �������� <zc_ObjectBoolean_GoodsByGoodsKind_GoodsKindNew>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_GoodsKindNew(), vbGoodsByGoodsKindId, vbGoodsKindNewId);
  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.12.22         *
*/

-- ����
--