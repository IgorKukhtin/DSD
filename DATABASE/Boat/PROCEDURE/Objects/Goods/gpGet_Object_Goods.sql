-- Function: gpGet_Object_Goods()

DROP FUNCTION IF EXISTS gpGet_Object_Goods (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Goods (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Goods (Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Goods (Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
    IN inId          Integer,       -- ����� 
    IN inPriceListId Integer,
    IN inMaskId      Integer   ,    -- id ��� �����������
    IN inArticle     TVarChar  ,
    IN inName        TVarChar  ,    
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Article TVarChar, ArticleVergl TVarChar, EAN TVarChar, ASIN TVarChar, MatchCode TVarChar
             , FeeNumber TVarChar, GoodsGroupNameFull TVarChar
             , Comment TVarChar
             , PartnerDate TDateTime
             , isArc Boolean
             , Feet TFloat, Metres TFloat
             , Weight TFloat
             , AmountMin TFloat, AmountRefer TFloat
             , AmountRemains TFloat
             , EKPrice TFloat, EmpfPrice TFloat
             , BasisPrice TFloat 
             , StartDate_price TDateTime

             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , GoodsTagId Integer, GoodsTagName TVarChar
             , GoodsTypeId  Integer, GoodsTypeName TVarChar
             , GoodsSizeId  Integer, GoodsSizeName TVarChar
             , ProdColorId Integer, ProdColorName TVarChar
             , PartnerId Integer, PartnerName   TVarChar
             , UnitId Integer, UnitName TVarChar
             , DiscountPartnerId Integer, DiscountPartnerName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , EngineId Integer, EngineName TVarChar
             
              )
AS
$BODY$
   DECLARE vbPriceWithVAT Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Goods());

     -- ����������
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());



   IF ((COALESCE (inId, 0) = 0) AND (COALESCE (inMaskId, 0) = 0))
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Goods()) AS Code
           , COALESCE (inName, '')      ::TVarChar  AS Name
           , COALESCE (inArticle,'')    ::TVarChar  AS Article
           , CAST ('' as TVarChar) AS ArticleVergl
           , CAST ('' as TVarChar) AS EAN
           , CAST ('' as TVarChar) AS ASIN
           , CAST ('' as TVarChar) AS MatchCode
           , CAST ('' as TVarChar) AS FeeNumber
           , CAST ('' as TVarChar) AS GoodsGroupNameFull
           , CAST ('' as TVarChar) AS Comment
           , CAST (NULL AS TDateTime) AS PartnerDate
           , FALSE      :: Boolean AS isArc

           , CAST (0 as TFloat)    AS Feet
           , CAST (0 as TFloat)    AS Metres 
           , CAST (0 as TFloat)    AS Weight

           , CAST (0 as TFloat)    AS AmountMin
           , CAST (0 as TFloat)    AS AmountRefer
           , CAST (0 as TFloat)    AS AmountRemains
           , CAST (0 as TFloat)    AS EKPrice
           , CAST (0 as TFloat)    AS EmpfPrice  
           , CAST (0 as TFloat)    AS BasisPrice
           , CAST (Null AS TDateTime) AS StartDate_price

           , CAST (0 as Integer)      AS GoodsGroupId
           , CAST ('' as TVarChar)    AS GoodsGroupName
           , CAST (0 as Integer)      AS MeasureId
           , CAST ('' as TVarChar)    AS MeasureName
           , CAST (0 as Integer)      AS GoodsTagId
           , CAST ('' as TVarChar)    AS GoodsTagName
           , CAST (0 as Integer)      AS GoodsTypeId
           , CAST ('' as TVarChar)    AS GoodsTypeName
           , CAST (0 as Integer)      AS GoodsSizeId
           , CAST ('' as TVarChar)    AS GoodsSizeName
           , CAST (0 as Integer)      AS ProdColorId
           , CAST ('' as TVarChar)    AS ProdColorName
           , CAST (0 as Integer)      AS PartnerId
           , CAST ('' as TVarChar)    AS PartnerName
           , CAST (0 as Integer)      AS UnitId
           , CAST ('' as TVarChar)    AS UnitName
           , CAST (0 as Integer)      AS DiscountPartnerId
           , CAST ('' as TVarChar)    AS DiscountPartnerName
           , CAST (0 as Integer)      AS TaxKindId
           , CAST ('' as TVarChar)    AS TaxKindName
           , CAST (0 as Integer)      AS InfoMoneyId
           , CAST ('' as TVarChar)    AS InfoMoneyName
           , CAST (0 as Integer)      AS EngineId
           , CAST ('' as TVarChar)    AS EngineName
           ;
   ELSE
       RETURN QUERY 
       WITH
           tmpPriceBasis AS (SELECT tmp.GoodsId
                                  , tmp.StartDate
                                  , tmp.ValuePrice
                             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId   --zc_PriceList_Basis()
                                                                      , inOperDate   := CURRENT_DATE) AS tmp
                            )

           -- ������� �������
         , tmpRemains AS (SELECT Container.ObjectId            AS GoodsId
                               , SUM (Container.Amount)        AS Remains
                          FROM Container
                          WHERE Container.WhereObjectId = 35139 -- ����� ��������
                            AND Container.DescId        = zc_Container_Count()
                            AND Container.Amount <> 0
                            AND Container.ObjectId = inId
                          GROUP BY Container.ObjectId
                          HAVING SUM (Container.Amount) <> 0
                         )
       ---
       SELECT CASE WHEN inMaskId <> 0 THEN 0 ELSE Object_Goods.Id END ::Integer AS Id
            , CASE WHEN inMaskId <> 0 THEN lfGet_ObjectCode(0, zc_Object_Goods()) ELSE Object_Goods.ObjectCode END ::Integer AS Code
            , Object_Goods.ValueData              AS Name
            , ObjectString_Article.ValueData      AS Article
            , ObjectString_ArticleVergl.ValueData AS ArticleVergl
            , ObjectString_EAN.ValueData          AS EAN
            , ObjectString_ASIN.ValueData         AS ASIN
            , ObjectString_MatchCode.ValueData    AS MatchCode
            , ObjectString_FeeNumber.ValueData    AS FeeNumber
            , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , ObjectString_Comment.ValueData      AS Comment

--          , COALESCE (ObjectDate_PartnerDate.ValueData, CURRENT_DATE)  :: TDateTime AS PartnerDate
            , ObjectDate_PartnerDate.ValueData              :: TDateTime AS PartnerDate
            , COALESCE (ObjectBoolean_Arc.ValueData, FALSE) :: Boolean AS isArc

            , ObjectFloat_Feet.ValueData    ::TFloat AS Feet
            , ObjectFloat_Metres.ValueData  ::TFloat AS Metres
            , ObjectFloat_Weight.ValueData  ::TFloat AS Weight

            , ObjectFloat_Min.ValueData          AS AmountMin
            , ObjectFloat_Refer.ValueData        AS AmountRefer
            --������� �� ��. ������
            , tmpRemains.Remains ::TFloat        AS AmountRemains

            , ObjectFloat_EKPrice.ValueData      AS EKPrice
            , ObjectFloat_EmpfPrice.ValueData    AS EmpfPrice

              -- ���� ������� ��� ���
            , CASE WHEN vbPriceWithVAT = FALSE
                   THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                   ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
              END ::TFloat AS BasisPrice

            , tmpPriceBasis.StartDate ::TDateTime AS StartDate_price

            , Object_GoodsGroup.Id               AS GoodsGroupId
            , Object_GoodsGroup.ValueData        AS GoodsGroupName
            , Object_Measure.Id                  AS MeasureId
            , Object_Measure.ValueData           AS MeasureName
            , Object_GoodsTag.Id                 AS GoodsTagId
            , Object_GoodsTag.ValueData          AS GoodsTagName
            , Object_GoodsType.Id                AS GoodsTypeId
            , Object_GoodsType.ValueData         AS GoodsTypeName
            , Object_GoodsSize.Id                AS GoodsSizeId
            , Object_GoodsSize.ValueData         AS GoodsSizeName
            , Object_ProdColor.Id                AS ProdColorId
            , Object_ProdColor.ValueData         AS ProdColorName
            , Object_Partner.Id                  AS PartnerId
            , Object_Partner.ValueData           AS PartnerName
            , Object_Unit.Id                     AS UnitId
            , Object_Unit.ValueData              AS UnitName
            , Object_DiscountPartner.Id           AS DiscountPartnerId
            , Object_DiscountPartner.ValueData    AS DiscountPartnerName
            , Object_TaxKind.Id                  AS TaxKindId
            , Object_TaxKind.ValueData           AS TaxKindName
            , Object_InfoMoney_View.InfoMoneyId
            , Object_InfoMoney_View.InfoMoneyName
            , Object_Engine.Id                   AS EngineId
            , Object_Engine.ValueData            AS EngineName
       FROM Object AS Object_Goods
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Goods.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Goods_Comment()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                  ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
             LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                  ON ObjectLink_Goods_GoodsType.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
             LEFT JOIN Object AS Object_GoodsType ON Object_GoodsType.Id = ObjectLink_Goods_GoodsType.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                  ON ObjectLink_Goods_GoodsSize.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
             LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = ObjectLink_Goods_GoodsSize.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                  ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
             LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                  ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Goods_Partner.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Unit
                                  ON ObjectLink_Goods_Unit.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Unit.DescId = zc_ObjectLink_Goods_Unit()
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Goods_Unit.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_DiscountPartner
                                  ON ObjectLink_Goods_DiscountPartner.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_DiscountPartner.DescId = zc_ObjectLink_Goods_DiscountPartner()
             LEFT JOIN Object AS Object_DiscountPartner ON Object_DiscountPartner.Id = ObjectLink_Goods_DiscountPartner.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                  ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
             LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                  ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                 AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Engine
                                  ON ObjectLink_Goods_Engine.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Engine.DescId = zc_ObjectLink_Goods_Engine()
             LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Goods_Engine.ChildObjectId

             LEFT JOIN ObjectDate AS ObjectDate_PartnerDate
                                  ON ObjectDate_PartnerDate.ObjectId = Object_Goods.Id
                                 AND ObjectDate_PartnerDate.DescId = zc_ObjectDate_Goods_PartnerDate()

             LEFT JOIN ObjectFloat AS ObjectFloat_Min
                                   ON ObjectFloat_Min.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Min.DescId   = zc_ObjectFloat_Goods_Min()
             LEFT JOIN ObjectFloat AS ObjectFloat_Refer
                                   ON ObjectFloat_Refer.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Refer.DescId   = zc_ObjectFloat_Goods_Refer()
             LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                   ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
             LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                   ON ObjectFloat_EmpfPrice.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()

             LEFT JOIN ObjectFloat AS ObjectFloat_Feet
                                   ON ObjectFloat_Feet.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Feet.DescId   = zc_ObjectFloat_Goods_Feet()
             LEFT JOIN ObjectFloat AS ObjectFloat_Metres
                                   ON ObjectFloat_Metres.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Metres.DescId   = zc_ObjectFloat_Goods_Metres()
             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Arc
                                     ON ObjectBoolean_Arc.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Arc.DescId = zc_ObjectBoolean_Goods_Arc()

             LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                    ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
             LEFT JOIN ObjectString AS ObjectString_FeeNumber
                                    ON ObjectString_FeeNumber.ObjectId = Object_Goods.Id
                                   AND ObjectString_FeeNumber.DescId = zc_ObjectString_Goods_FeeNumber()

             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = Object_Goods.Id
                                   AND ObjectString_Article.DescId = zc_ObjectString_Article()
             LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                    ON ObjectString_ArticleVergl.ObjectId = Object_Goods.Id
                                   AND ObjectString_ArticleVergl.DescId = zc_ObjectString_ArticleVergl()
             LEFT JOIN ObjectString AS ObjectString_EAN
                                    ON ObjectString_EAN.ObjectId = Object_Goods.Id
                                   AND ObjectString_EAN.DescId = zc_ObjectString_EAN()
             LEFT JOIN ObjectString AS ObjectString_ASIN
                                    ON ObjectString_ASIN.ObjectId = Object_Goods.Id
                                   AND ObjectString_ASIN.DescId = zc_ObjectString_ASIN()
             LEFT JOIN ObjectString AS ObjectString_MatchCode
                                    ON ObjectString_MatchCode.ObjectId = Object_Goods.Id
                                   AND ObjectString_MatchCode.DescId = zc_ObjectString_MatchCode()
             
             LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

             LEFT JOIN tmpRemains ON 1 = 1
       WHERE Object_Goods.Id = CASE WHEN COALESCE (inId, 0) = 0 THEN COALESCE (inMaskId,0) ELSE inId END;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.10.25         * inArticle, inName
 26.09.25         * AmountRemains
 18.09.25         * add Weight
 28.03.24         * inPriceListId
 14.08.23         * inMaskId
 11.11.20         *
*/

-- ����
-- SELECT * FROM gpGet_Object_Goods (0, zc_PriceList_Basis(), 0, '3434', 'Test', '2')