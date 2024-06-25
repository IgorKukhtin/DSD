--
--gpInsertUpdate_Object_GoodsByGoodsKindPeresort_Load
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsByGoodsKindPeresort_Load (Integer, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKindPeresort_Load(
    IN inGoodsCode_in          Integer,       -- ��� ������������ ������
    IN inGoodsName_in          TVarChar,      -- �������� ������������ ������
    IN inGoodsKindName_in      TVarChar,      -- ��� ������������ ������
    IN inGoodsCode_out            Integer,       -- ��� ������ ��������
    IN inGoodsName_out            TVarChar,      -- �������� ������ ��������
    IN inGoodsKindName_out        TVarChar,      -- ��� ������ ��������
    IN inSession                 TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId             Integer;
  DECLARE vbGoodsId_in       Integer; 
  DECLARE vbGoodsId_out         Integer;
  DECLARE vbGoodsKindId_in   Integer;
  DECLARE vbGoodsKindId_out     Integer;
  DECLARE vbGoodsByGoodsKindPeresortId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind());
   
   IF COALESCE (inGoodsCode_in,0) = 0
   THEN
       RETURN;
   END IF;
   
   
   --������� ������
   vbGoodsId_in := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode_in AND Object.DescId = zc_Object_Goods());
   vbGoodsId_out   := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode_out AND Object.DescId = zc_Object_Goods());
   -- ������� ��� ������
   vbGoodsKindId_in := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName_in) AND Object.DescId = zc_Object_GoodsKind());
   vbGoodsKindId_out   := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName_out) AND Object.DescId = zc_Object_GoodsKind());

   -- ��������
   IF COALESCE (vbGoodsId_in,0)      = 0 THEN RAISE EXCEPTION '������.�������� ����� <(%) %> �� ������.', inGoodsCode_in, inGoodsName_in; END IF;
   IF COALESCE (vbGoodsId_out,0)     = 0 THEN RAISE EXCEPTION '������.�������� ����� <(%) %> �� ������.', inGoodsCode_out, inGoodsName_out; END IF;
   IF COALESCE (vbGoodsKindId_in,0)  = 0 THEN RAISE EXCEPTION '������.�������� ��� ������ <%> �� ������.', inGoodsKindName_in; END IF;
   IF COALESCE (vbGoodsKindId_out,0) = 0 THEN RAISE EXCEPTION '������.�������� ��� ������ <%> �� ������.', inGoodsKindName_out; END IF;
               
   --�������  GoodsByGoodsKindId
   vbGoodsByGoodsKindPeresortId := (SELECT ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                    FROM ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_Goods_in
                                         LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in
                                                              ON ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in.ObjectId = ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                                             AND ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in()
                      
                                         INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_Goods_out
                                                               ON ObjectLink_GoodsByGoodsKindPeresort_Goods_out.ObjectId = ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                                              AND ObjectLink_GoodsByGoodsKindPeresort_Goods_out.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_out()
                                                              AND ObjectLink_GoodsByGoodsKindPeresort_Goods_out.ChildObjectId = vbGoodsId_out
                                         
                                         LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out
                                                              ON ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out.ObjectId = ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                                             AND ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out()
                                         LEFT JOIN Object AS Object_GoodsKind_out ON Object_GoodsKind_out.Id = ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out.ChildObjectId          
                                    WHERE ObjectLink_GoodsByGoodsKindPeresort_Goods_in.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_in()
                                      AND ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ChildObjectId = vbGoodsId_in
                                      AND COALESCE (ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in.ChildObjectId, 0) = COALESCE (vbGoodsKindId_in, 0)
                                      AND COALESCE (ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out.ChildObjectId,0) = COALESCE (vbGoodsKindId_out,0)
                                      );

   
   IF vbUserId = 9457 THEN RAISE EXCEPTION 'Test.OK'; END IF;
   
   
   -- ���������
   PERFORM gpInsertUpdate_Object_GoodsByGoodsKindPeresort(ioId              := COALESCE (vbGoodsByGoodsKindPeresortId,0) ::Integer   -- ���� ������� <�����>
                                                        , inGoodsId_in      := vbGoodsId_in      ::Integer                           -- ����� (����������� - ������)
                                                        , inGoodsKindId_in  := vbGoodsKindId_in  ::Integer                           -- ��� ������ (����������� - ������)
                                                        , inGoodsId_out     := vbGoodsId_out     ::Integer                           -- ����� (����������� - ������)
                                                        , inGoodsKindId_out := vbGoodsKindId_out ::Integer                           -- ��� ������ (����������� - ������)
                                                        , inSession         := inSession
                                                        );  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.06.24         *
*/

-- ����
--