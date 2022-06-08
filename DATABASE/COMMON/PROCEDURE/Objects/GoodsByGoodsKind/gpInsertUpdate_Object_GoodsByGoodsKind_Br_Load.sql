--
--gpInsertUpdate_Object_GoodsByGoodsKind_Br_Load
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsByGoodsKind_Br_Load (Integer, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_Br_Load(
    IN inGoodsCode          Integer,       -- ��� ������������ ������
    IN inGoodsName          TVarChar,      -- �������� ������������ ������
    IN inGoodsKindName      TVarChar,      -- ��� ������������ ������
    IN inGoodsCode_Br       Integer,       -- ��� ������ ��������
    IN inGoodsName_Br       TVarChar,      -- �������� ������ ��������
    IN inGoodsKindName_Br   TVarChar,      -- ��� ������ ��������
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsId Integer; 
  DECLARE vbGoodsSubId_Br Integer;
  DECLARE vbGoodsKindId Integer;
  DECLARE vbGoodsKindSubSendId_Br Integer;
  DECLARE vbGoodsByGoodsKindId Integer;
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
   vbGoodsSubId_Br  := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode_Br AND Object.DescId = zc_Object_Goods());
   -- ������� ��� ������
   vbGoodsKindId    := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind());
   vbGoodsKindSubSendId_Br := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName_Br) AND Object.DescId = zc_Object_GoodsKind());
               
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

   
   -- ��������� ����� � <������ (����������� �� �������� - ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsSub_Br(), vbGoodsByGoodsKindId, vbGoodsSubId_Br);
   -- ��������� ����� � <���� ������� (�������.����������� �� �������� - ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br(), vbGoodsByGoodsKindId, vbGoodsKindSubSendId_Br);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.06.22         *
*/

-- ����
--