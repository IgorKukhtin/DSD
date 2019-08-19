-- Function: lpSelect_Object_wms_SKU()
-- 4.1.1.1 ���������� ������� <sku>

DROP FUNCTION IF EXISTS lpSelect_Object_wms_SKU ();

CREATE OR REPLACE FUNCTION lpSelect_Object_wms_SKU(
)
RETURNS TABLE (ObjectId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsTypeKindId Integer, GoodsTypeKindCode Integer, GoodsTypeKindName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , MeasureId Integer, MeasureName TVarChar
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
        WITH tmpGoods_all AS (SELECT zfCalc_Text_replace (zfCalc_Text_replace (tmp.GoodsName, CHR(39), '`'), '"', '`') AS GoodsName_repl
                                   , *
                              FROM gpSelect_Object_GoodsByGoodsKind_VMC (inRetail1Id:= 0
                                                                       , inRetail2Id:= 0
                                                                       , inRetail3Id:= 0
                                                                       , inRetail4Id:= 0
                                                                       , inRetail5Id:= 0
                                                                       , inRetail6Id:= 0
                                                                       , inSession  := zfCalc_UserAdmin()
                                                                        ) AS tmp
                              WHERE tmp.GoodsId > 0 AND tmp.GoodsKindId > 0 
                             )
               , tmpGoods AS (-- �������
                              SELECT tmpGoods_all.Id * 10 + 1                                                              AS sku_id
                                   , tmpGoods_all.WmsCodeCalc_Sh                                                           AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Sh  AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , zc_Enum_GoodsTypeKind_Sh()                                                            AS GoodsTypeKindId
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.isGoodsTypeKind_Sh  = TRUE
                             UNION ALL
                              -- �����������
                              SELECT tmpGoods_all.Id * 10 + 2                                                              AS sku_id
                                   , tmpGoods_all.WmsCodeCalc_Nom                                                          AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Nom AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , zc_Enum_GoodsTypeKind_Nom()                                                           AS GoodsTypeKindId
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.isGoodsTypeKind_Nom = TRUE
                             UNION ALL
                              -- �������
                              SELECT tmpGoods_all.Id * 10 + 3                                                              AS sku_id
                                   , tmpGoods_all.WmsCodeCalc_Ves                                                          AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Ves AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , zc_Enum_GoodsTypeKind_Ves()                                                           AS GoodsTypeKindId
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.isGoodsTypeKind_Ves = TRUE
                             )
        -- ���������
        SELECT tmpGoods.Id AS ObjectId
             , tmpGoods.GoodsId, tmpGoods.Code AS GoodsCode, tmpGoods.GoodsName
             , tmpGoods.GoodsKindId, tmpGoods.GoodsKindCode, tmpGoods.GoodsKindName
             , Object_GoodsTypeKind.Id AS GoodsTypeKindId, Object_GoodsTypeKind.ObjectCode AS GoodsTypeKindCode, Object_GoodsTypeKind.ValueData AS GoodsTypeKindName
             , tmpGoods.GoodsGroupId, tmpGoods.GoodsGroupName, tmpGoods.GoodsGroupNameFull
             , tmpGoods.MeasureId, tmpGoods.MeasureName

               -- ��� 1-�� ��.
             , tmpGoods.WeightMin
             , tmpGoods.WeightMax
             , tmpGoods.WeightAvg
               -- ������� 1-�� ��.
             , tmpGoods.Height
             , tmpGoods.Length
             , tmpGoods.Width

               -- ���� (E2/E3)
             , tmpGoods.GoodsPropertyBoxId
             , tmpGoods.BoxId, tmpGoods.BoxCode, tmpGoods.BoxName
             , tmpGoods.WeightOnBox              -- ���-�� ��. � ��. (E2/E3)
             , tmpGoods.CountOnBox               -- ���-�� ��. � ��. (E2/E3)
             , tmpGoods.BoxVolume                -- ����� ��., �3. (E2/E3)
             , tmpGoods.BoxWeight                -- ��� ������� ��. (E2/E3)
             , tmpGoods.BoxHeight                -- ������ ��. (E2/E3)
             , tmpGoods.BoxLength                -- ����� ��. (E2/E3)
             , tmpGoods.BoxWidth                 -- ������ ��. (E2/E3)
             , tmpGoods.WeightGross              -- ��� ������ ������� ����� "�� ???" (E2/E3)
             , tmpGoods.WeightAvgGross           -- ��� ������ ������� ����� "�� �������� ����" (E2/E3)
             , tmpGoods.WeightAvgNet             -- ��� ����� ������� ����� "�� �������� ����" (E2/E3)

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
-- SELECT * FROM lpSelect_Object_wms_SKU() ORDER BY sku_code
