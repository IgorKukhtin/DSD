-- Function: lpSelect_Object_wms_SKU()
-- 4.1.1.1 ���������� ������� <sku>

DROP FUNCTION IF EXISTS lpSelect_wms_Object_SKU ();

CREATE OR REPLACE FUNCTION lpSelect_wms_Object_SKU(
)
RETURNS TABLE (ObjectId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsTypeKindId Integer, GoodsTypeKindCode Integer, GoodsTypeKindName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
               -- ��� 1-�� ��.
             , WeightMin TFloat
             , WeightMax TFloat
             , WeightAvg TFloat
               -- ������� 1-�� ��.
             , Height    TFloat
             , Length    TFloat
             , Width     TFloat
               -- ���� (E2/E3)
             , GoodsPropertyBoxId Integer
             , BoxId Integer, BoxCode Integer, BoxName TVarChar
             , WeightOnBox    TFloat -- ���-�� ��. � ��. (E2/E3)
             , CountOnBox     TFloat -- ���-�� ��. � ��. (E2/E3)
             , BoxVolume      TFloat -- ����� ��., �3. (E2/E3)
             , BoxWeight      TFloat -- ��� ������� ��. (E2/E3)
             , BoxHeight      TFloat -- ������ ��. (E2/E3)
             , BoxLength      TFloat -- ����� ��. (E2/E3)
             , BoxWidth       TFloat -- ������ ��. (E2/E3)
             , WeightGross    TFloat -- ��� ������ ������� ����� "�� ???" (E2/E3)
             , WeightAvgGross TFloat -- ��� ������ ������� ����� "�� �������� ����" (E2/E3)
             , WeightAvgNet   TFloat -- ��� ����� ������� ����� "�� �������� ����" (E2/E3)
             , WeightMaxGross TFloat -- ��� ������ ������� ����� "�� ������������� ����" (E2/E3)
             , WeightMaxNet   TFloat -- ��� ����� ������� ����� "�� ������������� ����" (E2/E3)

             , sku_id       Integer  -- ***���������� ��� ������ � �������� ����������� �����������
             , sku_code     Integer  -- ����������, ��������-�������� ��� ������ ��� ����������� � �������� ������.
             , name         TVarChar -- ������������ ������ � �������� ����������� �����������
             , product_life Integer  -- ���� �������� ������ � ������.
              )
AS
$BODY$
   DECLARE vbName_Sh  TVarChar;
   DECLARE vbName_Nom TVarChar;
   DECLARE vbName_Ves TVarChar;
BEGIN
     -- �������
     vbName_Sh := (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Sh());
     -- �����������
     vbName_Nom:= (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Nom());
     -- �������
     vbName_Ves:= (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Ves());


     -- ���������
     RETURN QUERY
        WITH tmpGoods_all AS (SELECT Object_Goods.ObjectCode          AS GoodsCode
                                   , Object_Goods.ValueData           AS GoodsName
                                   , zfCalc_Text_replace (zfCalc_Text_replace (Object_Goods.ValueData, CHR(39), '`'), '"', '`') AS GoodsName_repl
                                   , Object_GoodsKind.ObjectCode      AS GoodsKindCode
                                   , Object_GoodsKind.ValueData       AS GoodsKindName
                                   , Object_Measure.ValueData         AS MeasureName
                                   , Object_Box.ObjectCode            AS BoxCode
                                   , Object_Box.ValueData             AS BoxName
                                   , ObjectFloat_Volume.ValueData     AS BoxVolume
                                   , ObjectFloat_Height.ValueData     AS BoxHeight
                                   , ObjectFloat_Length.ValueData     AS BoxLength
                                   , ObjectFloat_Width.ValueData      AS BoxWidth
                                   , ObjectLink_Goods_GoodsGroup.ChildObjectId   AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                 AS GoodsGroupName
                                   , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                                   , View_InfoMoney.InfoMoneyGroupId
                                   , View_InfoMoney.InfoMoneyDestinationId
                                   , View_InfoMoney.InfoMoneyId
                                   , tmp.*
                              FROM wms_Object_GoodsByGoodsKind AS tmp
                                   LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmp.GoodsId
                                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmp.GoodsKindId
                                   LEFT JOIN Object AS Object_Measure   ON Object_Measure.Id   = tmp.MeasureId
                                   LEFT JOIN Object AS Object_Box       ON Object_Box.Id       = tmp.BoxId

                                   LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                                         ON ObjectFloat_Volume.ObjectId = tmp.BoxId
                                                        AND ObjectFloat_Volume.DescId   = zc_ObjectFloat_Box_Volume()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                                         ON ObjectFloat_Height.ObjectId = tmp.BoxId
                                                        AND ObjectFloat_Height.DescId   = zc_ObjectFloat_Box_Height()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Length
                                                         ON ObjectFloat_Length.ObjectId = tmp.BoxId
                                                        AND ObjectFloat_Length.DescId   = zc_ObjectFloat_Box_Length()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Width
                                                         ON ObjectFloat_Width.ObjectId = tmp.BoxId
                                                        AND ObjectFloat_Width.DescId   = zc_ObjectFloat_Box_Width()

                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                        ON ObjectLink_Goods_GoodsGroup.ObjectId = tmp.GoodsId
                                                       AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                   LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                          ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmp.GoodsId
                                                         AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                        ON ObjectLink_Goods_InfoMoney.ObjectId = tmp.GoodsId
                                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                              WHERE tmp.GoodsId > 0 AND tmp.GoodsKindId > 0 AND tmp.isErased = FALSE
                             )
               , tmpGoods AS (-- �������
                              SELECT tmpGoods_all.sku_id_Sh                                                                AS sku_id
                                   , tmpGoods_all.sku_code_Sh                                                              AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Sh  AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , tmpGoods_all.GoodsTypeKindId_Sh                                                       AS GoodsTypeKindId
                                   , tmpGoods_all.WeightMin_Sh                                                             AS WeightMin_real
                                   , tmpGoods_all.WeightMax_Sh                                                             AS WeightMax_real
                                   , tmpGoods_all.WeightAvg_Sh                                                             AS WeightAvg_real
                                   , tmpGoods_all.WeightOnBox_Sh                                                           AS WeightOnBox_real
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.GoodsTypeKindId_Sh  = zc_Enum_GoodsTypeKind_Sh()
                             UNION ALL
                              -- �����������
                              SELECT tmpGoods_all.sku_id_Nom                                                               AS sku_id
                                   , tmpGoods_all.sku_code_Nom                                                             AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Nom AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , tmpGoods_all.GoodsTypeKindId_Nom                                                      AS GoodsTypeKindId
                                   , tmpGoods_all.WeightMin_Nom                                                            AS WeightMin_real
                                   , tmpGoods_all.WeightMax_Nom                                                            AS WeightMax_real
                                   , tmpGoods_all.WeightAvg_Nom                                                            AS WeightAvg_real
                                   , tmpGoods_all.WeightOnBox_Nom                                                          AS WeightOnBox_real
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.GoodsTypeKindId_Nom = zc_Enum_GoodsTypeKind_Nom()
                             UNION ALL
                              -- �������
                              SELECT tmpGoods_all.sku_id_Ves                                                               AS sku_id
                                   , tmpGoods_all.sku_code_Ves                                                             AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Ves AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , tmpGoods_all.GoodsTypeKindId_Ves                                                      AS GoodsTypeKindId
                                   , tmpGoods_all.WeightMin_Ves                                                            AS WeightMin_real
                                   , tmpGoods_all.WeightMax_Ves                                                            AS WeightMax_real
                                   , tmpGoods_all.WeightAvg_Ves                                                            AS WeightAvg_real
                                   , tmpGoods_all.WeightOnBox_Ves                                                          AS WeightOnBox_real
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.GoodsTypeKindId_Ves = zc_Enum_GoodsTypeKind_Ves()
                             )
        -- ���������
        SELECT tmpGoods.ObjectId
             , tmpGoods.GoodsId, tmpGoods.GoodsCode, tmpGoods.GoodsName
             , tmpGoods.GoodsKindId, tmpGoods.GoodsKindCode, tmpGoods.GoodsKindName
             , Object_GoodsTypeKind.Id AS GoodsTypeKindId, Object_GoodsTypeKind.ObjectCode AS GoodsTypeKindCode, Object_GoodsTypeKind.ValueData AS GoodsTypeKindName
             , tmpGoods.GoodsGroupId, tmpGoods.GoodsGroupName, tmpGoods.GoodsGroupNameFull
             , tmpGoods.MeasureId, tmpGoods.MeasureName
             , tmpGoods.InfoMoneyGroupId, tmpGoods.InfoMoneyDestinationId, tmpGoods.InfoMoneyId

               -- ��� 1-�� ��.
             , tmpGoods.WeightMin_real AS WeightMin
             , tmpGoods.WeightMax_real AS WeightMax_real
             , tmpGoods.WeightAvg_real AS WeightAvg
               -- ������� 1-�� ��.
             , tmpGoods.Height
             , tmpGoods.Length
             , tmpGoods.Width

               -- ���� (E2/E3)
             , tmpGoods.GoodsPropertyBoxId
             , tmpGoods.BoxId, tmpGoods.BoxCode, tmpGoods.BoxName

               -- *�������� - ���-�� ��. � ��. (E2/E3) - ���� ��� � WeightAvgNet
             , tmpGoods.WeightOnBox_real AS WeightOnBox

             , tmpGoods.CountOnBox               -- ���-�� ��. � ��. (E2/E3)
             , tmpGoods.BoxVolume                -- ����� ��., �3. (E2/E3)
             , tmpGoods.BoxWeight                -- ��� ������ ��. (E2/E3)
             , tmpGoods.BoxHeight                -- ������ ��. (E2/E3)
             , tmpGoods.BoxLength                -- ����� ��. (E2/E3)
             , tmpGoods.BoxWidth                 -- ������ ��. (E2/E3)

               -- *�������� - ��� ������ ������� ����� "??? �� �������� ����" (E2/E3)
             , (tmpGoods.WeightOnBox_real + tmpGoods.BoxWeight) :: TFloat AS WeightGross

               -- *�������� - ��� ������ ������� ����� "�� �������� ����" (E2/E3)
             , (tmpGoods.WeightOnBox_real + tmpGoods.BoxWeight) :: TFloat AS WeightAvgGross

               -- *�������� - ��� ����� ������� ����� "�� �������� ����" (E2/E3) - ���� ��� � WeightOnBox
             , tmpGoods.WeightOnBox_real :: TFloat AS WeightAvgNet

               -- ***�������� - ��� ������ ������� ����� "�� ������������� ����" (E2/E3)
             , (CASE WHEN tmpGoods.CountOnBox > 0 AND tmpGoods.WeightMax_real > 0
                          THEN tmpGoods.CountOnBox * tmpGoods.WeightMax_real
                     ELSE tmpGoods.WeightOnBox_real
                END
              + tmpGoods.BoxWeight
               ) :: TFloat AS WeightMaxGross

               -- ***�������� - ��� ����� ������� ����� "�� ������������� ����" (E2/E3) - ���� ��� � WeightOnBox
             , (CASE WHEN tmpGoods.CountOnBox > 0 AND tmpGoods.WeightMax_real > 0
                          THEN tmpGoods.CountOnBox * tmpGoods.WeightMax_real
                     ELSE tmpGoods.WeightOnBox_real
                END
               ) :: TFloat AS WeightMaxNet

             , tmpGoods.sku_id       :: Integer  -- ***���������� ��� ������ � �������� ����������� �����������
             , tmpGoods.sku_code     :: Integer  -- ����������, ��������-�������� ��� ������ ��� ����������� � �������� ������.
             , tmpGoods.name         :: TVarChar -- ������������ ������ � �������� ����������� �����������
             , tmpGoods.product_life :: Integer  -- ���� �������� ������ � ������.

        FROM tmpGoods
             LEFT JOIN Object AS Object_GoodsTypeKind ON Object_GoodsTypeKind.Id = tmpGoods.GoodsTypeKindId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.19                                       *
*/
-- ����
-- SELECT * FROM lpSelect_wms_Object_SKU() where sku_id in (34570361, 34570391) ORDER BY sku_id
-- SELECT * FROM lpSelect_wms_Object_SKU() where sku_code = 2931 ORDER BY sku_id

