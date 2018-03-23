-- Function: zfSelect_DiscountSaleKind

DROP FUNCTION IF EXISTS zfSelect_DiscountSaleKind (TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfSelect_DiscountSaleKind(
    IN inOperDate           TDateTime , -- ���� ��������
    IN inUnitId             Integer   , -- �������������
    IN inGoodsId            Integer   , -- �����
    IN inClientId           Integer   , -- ����������
    IN inUserId             Integer     -- ������������
)
RETURNS TABLE (ChangePercent TFloat, DiscountSaleKindId Integer, DiscountSaleKindName TVarChar
              )
AS
$BODY$
   DECLARE vbIsDiscountTaxTwo Boolean;
BEGIN

     -- ���������� - ������������ �� zc_ObjectFloat_Client_DiscountTaxTwo
     IF 0 < 1 -- (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inUnitId AND OL.DescId = zc_ObjectLink_Unit_GoodsGroup())
     THEN
         -- ���� ������ ������� � ������ = ����� ��� ����
         IF (select 1532 /*1530*/) -- (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inUnitId AND OL.DescId = zc_ObjectLink_Unit_GoodsGroup())
            IN (-- !!! ����������� �� ��� ������ ����� !!!!
                 SELECT ObjectLink.ChildObjectId
                 FROM ObjectLink
                 WHERE ObjectLink.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                   AND ObjectLink.ObjectId = inGoodsId
                UNION ALL
                 -- 1-��
                 SELECT ObjectLink_Child1.ChildObjectId
                 FROM ObjectLink
                      JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ObjectId = ObjectLink.ChildObjectId
                                                          AND ObjectLink_Child1.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                 WHERE ObjectLink.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                   AND ObjectLink.ObjectId = inGoodsId
                UNION ALL
                 -- 2-��
                 SELECT ObjectLink_Child2.ChildObjectId
                 FROM ObjectLink
                      JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ObjectId = ObjectLink.ChildObjectId
                                                          AND ObjectLink_Child1.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                      JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ObjectId = ObjectLink_Child1.ChildObjectId
                                                          AND ObjectLink_Child2.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                 WHERE ObjectLink.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                   AND ObjectLink.ObjectId = inGoodsId
                UNION ALL
                 -- 3-��
                 SELECT ObjectLink_Child3.ChildObjectId
                 FROM ObjectLink
                      JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ObjectId = ObjectLink.ChildObjectId
                                                          AND ObjectLink_Child1.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                      JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ObjectId = ObjectLink_Child1.ChildObjectId
                                                          AND ObjectLink_Child2.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                      JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ObjectId = ObjectLink_Child2.ChildObjectId
                                                          AND ObjectLink_Child3.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                 WHERE ObjectLink.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                   AND ObjectLink.ObjectId = inGoodsId
                UNION ALL
                 -- 4-��
                 SELECT ObjectLink_Child4.ChildObjectId
                 FROM ObjectLink
                      JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ObjectId = ObjectLink.ChildObjectId
                                                          AND ObjectLink_Child1.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                      JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ObjectId = ObjectLink_Child1.ChildObjectId
                                                          AND ObjectLink_Child2.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                      JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ObjectId = ObjectLink_Child2.ChildObjectId
                                                          AND ObjectLink_Child3.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                      JOIN ObjectLink AS ObjectLink_Child4 ON ObjectLink_Child4.ObjectId = ObjectLink_Child3.ChildObjectId
                                                          AND ObjectLink_Child4.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                 WHERE ObjectLink.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                   AND ObjectLink.ObjectId = inGoodsId
                UNION ALL
                 -- 5-��
                 SELECT ObjectLink_Child5.ChildObjectId
                 FROM ObjectLink
                      JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ObjectId = ObjectLink.ChildObjectId
                                                          AND ObjectLink_Child1.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                      JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ObjectId = ObjectLink_Child1.ChildObjectId
                                                          AND ObjectLink_Child2.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                      JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ObjectId = ObjectLink_Child2.ChildObjectId
                                                          AND ObjectLink_Child3.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                      JOIN ObjectLink AS ObjectLink_Child4 ON ObjectLink_Child4.ObjectId = ObjectLink_Child3.ChildObjectId
                                                          AND ObjectLink_Child4.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                      JOIN ObjectLink AS ObjectLink_Child5 ON ObjectLink_Child5.ObjectId = ObjectLink_Child3.ChildObjectId
                                                          AND ObjectLink_Child5.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                 WHERE ObjectLink.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                   AND ObjectLink.ObjectId = inGoodsId
               )
         THEN
             vbIsDiscountTaxTwo:= TRUE;
         ELSE
             vbIsDiscountTaxTwo:= FALSE;
         END IF;
     ELSE
         vbIsDiscountTaxTwo:= FALSE;
     END IF;


     -- ���������
     RETURN QUERY
       WITH -- ������ - outlet
            tmpOutlet AS (SELECT ObjectFloat_DiscountTax.ValueData AS Tax, zc_Enum_DiscountSaleKind_Outlet() AS DiscountSaleKindId
                          FROM ObjectFloat AS ObjectFloat_DiscountTax
                          WHERE ObjectFloat_DiscountTax.DescId    = zc_ObjectFloat_Unit_DiscountTax()
                            AND ObjectFloat_DiscountTax.ObjectId  =  inUnitId
                            AND ObjectFloat_DiscountTax.ValueData <> 0
                         )
       -- ���������
       SELECT -- � ��������� Tax < 0 � ��� ������� outlet
              CASE WHEN tmp.Tax > 0 THEN tmp.Tax ELSE 0 END :: TFloat AS ChangePercent
              -- ���� ��� outlet - ������ �������� ���� �������
            , Object.Id        AS DiscountSaleKindId
              -- ��������
            , Object.ValueData AS DiscountSaleKindName

       FROM (SELECT tmp.Tax
                  , tmp.DiscountSaleKindId
                    --  � �/�
                  , ROW_NUMBER() OVER (ORDER BY tmp.Tax DESC, tmp.Num ASC) AS Ord

             FROM (-- ������ - ��������
                   SELECT 1 AS Num, COALESCE (tmp.ValuePrice, 0) AS Tax, zc_Enum_DiscountSaleKind_Period() AS DiscountSaleKindId
                   FROM gpGet_ObjectHistory_DiscountPeriodItem (inOperDate:= inOperDate, inUnitId:= inUnitId, inGoodsId:= inGoodsId, inSession:= inUserId :: TVarChar) AS tmp
                   WHERE tmp.ValuePrice > 0
                 UNION ALL
                   -- ������ - �������
                   SELECT 2 AS Num
                        , CASE WHEN vbIsDiscountTaxTwo = TRUE THEN ObjectFloat_DiscountTaxTwo.ValueData ELSE ObjectFloat_DiscountTax.ValueData END AS Tax
                        , zc_Enum_DiscountSaleKind_Client() AS DiscountSaleKindId -- �������
                   FROM Object
                        LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                              ON ObjectFloat_DiscountTax.ObjectId  = Object.Id
                                             AND ObjectFloat_DiscountTax.DescId    = zc_ObjectFloat_Client_DiscountTax()
                        LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTaxTwo
                                              ON ObjectFloat_DiscountTaxTwo.ObjectId = Object.Id
                                             AND ObjectFloat_DiscountTaxTwo.DescId   = zc_ObjectFloat_Client_DiscountTaxTwo()

                   WHERE Object.Id  = inClientId
                     AND CASE WHEN vbIsDiscountTaxTwo = TRUE THEN ObjectFloat_DiscountTaxTwo.ValueData ELSE ObjectFloat_DiscountTax.ValueData END > 0
                 UNION ALL
                   -- ������ - outlet
                   SELECT 0 AS Num, tmpOutlet.Tax, tmpOutlet.DiscountSaleKindId FROM tmpOutlet
                  ) AS tmp

            ) AS tmp
            LEFT JOIN tmpOutlet ON 1 = 1
            LEFT JOIN Object ON Object.Id = COALESCE (tmpOutlet.DiscountSaleKindId, tmp.DiscountSaleKindId)

       WHERE tmp.Ord = 1 -- !!!������� ������������!!!
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.05.17         *
*/

-- ����
-- SELECT * FROM zfSelect_DiscountSaleKind (inOperDate:='03.05.2017' ::TDateTime, inUnitId:= 230,  inGoodsId:=406 , inClientId:=459 ,inUserId:= zfCalc_UserAdmin() :: Integer);
