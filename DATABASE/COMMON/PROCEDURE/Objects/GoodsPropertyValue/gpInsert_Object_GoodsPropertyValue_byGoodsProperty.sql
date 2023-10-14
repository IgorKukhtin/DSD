-- Function: gpInsert_Object_GoodsPropertyValue_byGoodsProperty()

DROP FUNCTION IF EXISTS gpInsert_Object_GoodsPropertyValue_byGoodsProperty (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_GoodsPropertyValue_byGoodsProperty(
    IN inGoodsPropertyId       Integer   ,    -- ������������� ������� �������
    IN inGoodsPropertyId_mask  Integer   ,    -- ������������� ������� ������� - ������ ���������� ��������
    IN inSession               TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue());

   -- ��������
   IF COALESCE (inGoodsPropertyId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <������������� ������� �������>.';
   END IF;
   -- ��������
   IF COALESCE (inGoodsPropertyId_mask, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <������������� ������� �������> ��� �����������.';
   END IF;
  
   --��������� �������� �� ���������� ��������������
   PERFORM gpInsertUpdate_Object_GoodsPropertyValue (ioId             := 0                  :: Integer       -- ���� ������� <�������� ������� ������� ��� ��������������>
                                                   , inName           := tmp.Name           :: TVarChar      -- �������� ������(����������)
                                                   , inAmount         := tmp.Amount         :: TFloat        -- ���-�� ���� ��� ������������
                                                   , inBoxCount       := tmp.BoxCount       :: TFloat        -- ���-�� ������ � �����
                                                   , inBarCode        := tmp.BarCode        :: TVarChar      -- �����-���
                                                   , inArticle        := tmp.Article        :: TVarChar      -- �������
                                                   , inBarCodeGLN     := tmp.BarCodeGLN     :: TVarChar      -- �����-��� GLN
                                                   , inArticleGLN     := tmp.ArticleGLN     :: TVarChar      -- ������� GLN
                                                   , inGroupName      := tmp.GroupName      :: TVarChar      -- �������� ������
                                                   , inGoodsPropertyId:= inGoodsPropertyId  :: Integer       -- ������������� ������� �������
                                                   , inGoodsId        := tmp.GoodsId        :: Integer       -- ������
                                                   , inGoodsKindId    := tmp.GoodsKindId    :: Integer       -- ���� ������
                                                   , inGoodsBoxId     := tmp.GoodsBoxId     :: Integer       -- ������ (���������) 
                                                   , inGoodsKindSubId := tmp.GoodsKindSubId :: Integer       -- ��� ������ (���� ������ � ���������)
                                                   , inisGoodsKind    := tmp.isGoodsKind    :: Boolean       -- ��������� �������� � ����� ����� ���.
                                                   , inSession        := inSession          :: TVarChar
                                                   )
   FROM gpSelect_Object_GoodsPropertyValue (inGoodsPropertyId := inGoodsPropertyId_mask, inShowAll:= False, inSession := inSession) AS tmp

        LEFT JOIN (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                        , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                   FROM ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                        INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                              ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                             AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = inGoodsPropertyId
                                             AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                   WHERE ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                   ) AS tmpGoodsProperty ON tmpGoodsProperty.GoodsId     = tmp.GoodsId
                                        AND tmpGoodsProperty.GoodsKindId = tmp.GoodsKindId
   WHERE tmpGoodsProperty.GoodsId IS NULL; 
    

   if vbUserId = 5 OR vbUserId = 9457
   then
       RAISE EXCEPTION 'Test. Ok';
   end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.10.23         *
*/

-- ����
-- SELECT * FROM gpInsert_Object_GoodsPropertyValue_byGoodsProperty()

---SELECT * FROM gpSelect_Object_GoodsPropertyValue (inGoodsPropertyId := 8342227   , inShowAll:= False, inSession := '9457') AS tmp; 