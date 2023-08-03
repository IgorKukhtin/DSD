-- Function: gpSelect_Object_ReceiptGoodsChild_ProdColorPatternNo()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoodsChild_ProdColorPatternNo (Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoodsChild_ProdColorPatternNo(
    IN inReceiptGoodsId  Integer,
    IN inReceiptLevelId  Integer,
    IN inIsShowAll       Boolean,       --
    IN inIsErased        Boolean,       -- ������� �������� ��������� �� / ��� 
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, NPP Integer, NPP_calc Integer, Comment TVarChar
             , Value NUMERIC (16, 8), Value_child NUMERIC (16, 8), Value_service NUMERIC (16, 8), ForCount TFloat
             , ReceiptGoodsId Integer, ReceiptGoodsName TVarChar
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar, DescName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar , Article_all TVarChar
             , ProdColorName TVarChar
             , Comment_goods TVarChar
             , MeasureName TVarChar
             , MaterialOptionsId Integer, MaterialOptionsName TVarChar
             , ReceiptLevelId Integer, ReceiptLevelName TVarChar
             , GoodsChildId Integer, GoodsChildName TVarChar

               -- ���� ��. ��� ��� - �����/������
             , EKPrice TFloat
               -- ���� ��. � ���, �� 2-� ������ - �����/������
             , EKPriceWVAT TFloat
               -- ����� ��. ��� ���, �� 2-� ������ - �����/������
             , EKPrice_summ TFloat
               -- ����� ��. � ���, �� 2-� ������ - �����/������
             , EKPriceWVAT_summ TFloat
               --
             , Color_value Integer
             , Color_Level Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbTaxKindValue_basis TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptGoodsChild());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������� % ���!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());

     -- ���������
     RETURN QUERY
     SELECT 
           Object_ReceiptGoodsChild.Id              AS Id
         , ObjectFloat_NPP.ValueData     :: Integer AS NPP
         , ROW_NUMBER() OVER (PARTITION BY Object_ReceiptGoods.Id ORDER BY ObjectFloat_NPP.ValueData, Object_ReceiptGoodsChild.Id ASC) :: Integer AS NPP_calc
         , Object_ReceiptGoodsChild.ValueData       AS Comment

         , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE Null END :: NUMERIC (16, 8) AS Value
         , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() AND Object_GoodsChild.Id > 0 THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE Null END :: NUMERIC (16, 8) AS Value_child
         , CASE WHEN ObjectDesc.Id =  zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE Null END :: NUMERIC (16, 8) AS Value_service
         , ObjectFloat_ForCount.ValueData :: TFloat AS ForCount

         , Object_ReceiptGoods.Id        ::Integer  AS ReceiptGoodsId
         , Object_ReceiptGoods.ValueData ::TVarChar AS ReceiptGoodsName
         
         , Object_Object.Id               ::Integer  AS ObjectId
         , Object_Object.ObjectCode       ::Integer  AS ObjectCode
         , Object_Object.ValueData        ::TVarChar AS ObjectName
         , ObjectDesc.ItemName            ::TVarChar AS DescName

         , Object_Insert.ValueData                  AS InsertName
         , Object_Update.ValueData                  AS UpdateName
         , ObjectDate_Insert.ValueData              AS InsertDate
         , ObjectDate_Update.ValueData              AS UpdateDate
         , Object_ReceiptGoodsChild.isErased        AS isErased

         , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
         , ObjectString_Article.ValueData        ::TVarChar  AS Article 
         , zfCalc_Article_all (ObjectString_Article.ValueData) ::TVarChar AS Article_all
         , Object_ProdColor.ValueData            :: TVarChar AS ProdColorName
         , ObjectString_Goods_Comment.ValueData              AS Comment_goods
         , Object_Measure.ValueData              ::TVarChar  AS MeasureName

         , Object_MaterialOptions.Id          ::Integer  AS MaterialOptionsId
         , Object_MaterialOptions.ValueData   ::TVarChar AS MaterialOptionsName

         , Object_ReceiptLevel.Id                        AS ReceiptLevelId
         , Object_ReceiptLevel.ValueData      ::TVarChar AS ReceiptLevelName

         , Object_GoodsChild.Id                          AS GoodsChildId
         , Object_GoodsChild.ValueData        ::TVarChar AS GoodsChildName

           -- ���� ��. ��� ��� - �����/������
         , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
           -- ������ ���� ��. � ���, �� 2-� ������ - �����/������
         , zfCalc_SummWVAT (COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData), vbTaxKindValue_basis) AS EKPriceWVAT

           -- ����� ��. ��� ���, �� 2-� ������ - �����/������
         , zfCalc_SummIn (ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END
                        , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData)
                        , 1) AS EKPrice_summ
           -- ����� ��. � ���, �� 2-� ������ - �����/������
         , zfCalc_SummWVAT (zfCalc_SummIn (ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END
                                         , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData)
                                         , 1)
                          , vbTaxKindValue_basis) AS EKPriceWVAT_summ

        , 15138790 /*zc_Color_Pink()*/     ::Integer                  AS Color_value                          --  ��� ��� Value
        , CASE WHEN ObjectDesc.Id = zc_Object_ReceiptService() THEN 15073510  -- ���������
               ELSE  zc_Color_Blue() --zc_Color_Black()
          END                              ::Integer                  AS Color_Level

     FROM Object AS Object_ReceiptGoodsChild

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                               ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()

          LEFT JOIN ObjectLink AS ObjectLink_Object
                               ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

          -- NPP
          LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                                ON ObjectFloat_NPP.ObjectId = Object_ReceiptGoodsChild.Id
                               AND ObjectFloat_NPP.DescId   = zc_ObjectFloat_ReceiptGoodsChild_NPP()

          -- �������� � ������
          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value() 
          LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                               AND ObjectFloat_ForCount.DescId = zc_ObjectFloat_ReceiptGoodsChild_ForCount()

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                               ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
          LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                               ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
          LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                               ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
          LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptLevel.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                               ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
          LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = ObjectLink_GoodsChild.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN ObjectDate AS ObjectDate_Update
                               ON ObjectDate_Update.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()

          --
          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Object.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Object.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                 ON ObjectString_Goods_Comment.ObjectId = Object_Object.Id
                                AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          -- ���� ��. ��� ��� - �����
          LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                ON ObjectFloat_EKPrice.ObjectId = Object_Object.Id
                               AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
          -- ���� ��. ��� ��� - ������
          LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                ON ObjectFloat_ReceiptService_EKPrice.ObjectId = Object_Object.Id
                               AND ObjectFloat_ReceiptService_EKPrice.DescId   = zc_ObjectFloat_ReceiptService_EKPrice()

     WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
      AND (Object_ReceiptGoodsChild.isErased = FALSE OR inIsErased = TRUE)
      -- ��� ���� ���������
      AND ObjectLink_ProdColorPattern.ChildObjectId IS NULL
      AND (ObjectLink_ReceiptLevel.ChildObjectId = inReceiptLevelId OR inReceiptLevelId = 0)  
      AND (ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId OR inReceiptGoodsId = 0)
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.05.23         * add inReceiptGoodsId
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReceiptGoodsChild_ProdColorPatternNo (0, 0, false, false, zfCalc_UserAdmin())
