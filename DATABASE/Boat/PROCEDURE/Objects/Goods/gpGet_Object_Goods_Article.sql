--
DROP FUNCTION IF EXISTS gpGet_Object_Goods_Article (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Goods_Article(
    IN inGoodsGroupId    Integer ,
    IN inGoodsId         Integer ,
 INOUT ioArticle        TVarChar,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());
   vbUserId:= lpGetUserBySession (inSession);

   --���� ����� ��������, �� ������ �� ������
   IF COALESCE (inGoodsId,0) <> 0
   THEN
        RETURN;
   END IF;

    --��������� �������
    --zc_ObjectString_Article = AGL + ��� ������ + ��������� ��� � Article �� ���� ������ + 1, �.�. ��� AGL-33-255 ����� ������ ���� AGL-33-256, ����� insert zc_Object_ReceiptGoods
    ioArticle := (SELECT ('AGL-' ||tmp.ObjectCode||'-'||tmp.Article_max + 1) :: TVarChar
                  FROM (SELECT Object_GoodsGroup.ObjectCode
                             , Max (zfConvert_StringToFloat ( RIGHT (ObjectString_Article.ValueData, 3))) ::integer AS Article_max
                        FROM Object AS Object_Goods
                             INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                                  AND ObjectLink_Goods_GoodsGroup.ChildObjectId = inGoodsGroupId
                             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                             LEFT JOIN ObjectString AS ObjectString_Article
                                                    ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                   AND ObjectString_Article.DescId = zc_ObjectString_Article()

                        WHERE Object_Goods.DescId = zc_Object_Goods()
 					    GROUP BY Object_GoodsGroup.ObjectCode
 	                    ) AS tmp
                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.06.22         *
*/

-- ����
--