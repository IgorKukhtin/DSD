-- Function: gpGet_ScaleLight_Goods()

DROP FUNCTION IF EXISTS gpGet_Scale_GoodsLight (Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_ScaleLight_Goods (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_ScaleLight_Goods (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ScaleLight_Goods(
    IN inGoodsId     Integer    , --
    IN inGoodsKindId Integer    ,
    IN inIs_test     Boolean     , --
    IN inSession     TVarChar     -- ������ ������������
)
RETURNS TABLE (GoodsId               Integer
             , GoodsCode             Integer
             , GoodsName             TVarChar
             , GoodsKindId           Integer
             , GoodsKindCode         Integer
             , GoodsKindName         TVarChar

             , GoodsId_sh            Integer
             , GoodsCode_sh          Integer
             , GoodsName_sh          TVarChar
             , GoodsKindId_sh        Integer
             , GoodsKindCode_sh      Integer
             , GoodsKindName_sh      TVarChar

             , MeasureId             Integer
             , MeasureCode           Integer
             , MeasureName           TVarChar

             , Count_box             Integer  -- ������� ����� ��� ������ - 1,2 ��� 3
             , GoodsTypeKindId_Sh    Integer  -- Id - ���� �� ��.  - �����
             , GoodsTypeKindId_Nom   Integer  -- Id - ���� �� ���. - �������
             , GoodsTypeKindId_Ves   Integer  -- Id - ���� �� ���  - ���

             , WmsCode_Sh            TVarChar -- ��� ��� - ��.
             , WmsCode_Nom           TVarChar -- ��� ��� - ���.
             , WmsCode_Ves           TVarChar -- ��� ��� - ���

             , WeightMin             TFloat   -- ����������� ��� 1��.  - !!!��������
             , WeightMax             TFloat   -- ������������ ��� 1��. - !!!��������

             , WeightMin_Sh          TFloat   -- ����������� ��� 1��.
             , WeightMin_Nom         TFloat   --
             , WeightMin_Ves         TFloat   --
             , WeightMax_Sh          TFloat   -- ������������ ��� 1��.
             , WeightMax_Nom         TFloat   --
             , WeightMax_Ves         TFloat   --

             , GoodsTypeKindId_1     Integer  -- ������� - 1-�� �����
          -- , BarCodeBoxId_1        Integer  --
          -- , BoxCode_1             Integer  --
          -- , BoxBarCode_1          TVarChar --
          -- , WeightOnBoxTotal_1    TFloat   --
          -- , CountOnBoxTotal_1     TFloat   --
             , BoxId_1               Integer  --
             , BoxName_1             TVarChar --
             , BoxWeight_1           TFloat   -- ��� ������ �����
             , WeightOnBox_1         TFloat   -- ����������� - �� ����
             , CountOnBox_1          TFloat   -- ����������� - �� (�� ������������! - ���� �������, ���������� ����� �� ����� ��������)

             , GoodsTypeKindId_2     Integer  -- ������� - 2-�� �����
          -- , BarCodeBoxId_2        Integer  --
          -- , BoxCode_2             Integer  --
          -- , BoxBarCode_2          TVarChar --
          -- , WeightOnBoxTotal_2    TFloat   --
          -- , CountOnBoxTotal_2     TFloat   --
             , BoxId_2               Integer  --
             , BoxName_2             TVarChar --
             , BoxWeight_2           TFloat   -- ��� ������ �����
             , WeightOnBox_2         TFloat   -- ����������� - �� ����
             , CountOnBox_2          TFloat   -- ����������� - �� (�� ������������! - ���� �������, ���������� ����� �� ����� ��������)

             , GoodsTypeKindId_3     Integer  -- ������� - 3-�� �����
          -- , BarCodeBoxId_3        Integer  --
          -- , BoxCode_3             Integer  --
          -- , BoxBarCode_3          TVarChar --
          -- , WeightOnBoxTotal_3    TFloat   --
          -- , CountOnBoxTotal_2     TFloat   --
             , BoxId_3               Integer  --
             , BoxName_3             TVarChar --
             , BoxWeight_3           TFloat   -- ��� ������ �����
             , WeightOnBox_3         TFloat   -- ����������� - �� ����
             , CountOnBox_3          TFloat   -- ����������� - �� (�� ������������! - ���� �������, ���������� ����� �� ����� ��������)
              )
AS
$BODY$
   DECLARE vbUserId          Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);


    --
    RETURN QUERY
      WITH -- ����� ������ ���� - �� ��������� "�������"
           tmpObject_sh AS (SELECT OL_Goods.ObjectId                    AS GoodsByGoodsKindId
                                 , OL_Goods.ChildObjectId               AS GoodsId
                                 , OL_GoodsKind.ChildObjectId           AS GoodsKindId
                                   -- ��������� "�������"
                                 , OL_Goods_find.ObjectId               AS GoodsByGoodsKindId_sh
                                   -- ����� + ��� �� ��������� "�������"
                                 , Object_Goods_Sh.Id                   AS GoodsId_sh
                                 , Object_Goods_Sh.ObjectCode           AS GoodsCode_sh
                                 , Object_Goods_Sh.ValueData            AS GoodsName_sh
                                 , Object_GoodsKind_Sh.Id               AS GoodsKindId_sh
                                 , Object_GoodsKind_Sh.ObjectCode       AS GoodsKindCode_sh
                                 , Object_GoodsKind_Sh.ValueData        AS GoodsKindName_sh
                                   -- ��-��
                                 , ObjectFloat_WmsCode_Sh.ValueData     AS WmsCode_sh
                                 , ObjectFloat_CountOnBox_Sh.ValueData  AS CountOnBox_sh
                                 , ObjectFloat_WeightOnBox_Sh.ValueData AS WeightOnBox_sh

                            FROM ObjectLink AS OL_Goods
                                 INNER JOIN ObjectLink AS OL_GoodsKind
                                                       ON OL_GoodsKind.ObjectId      = OL_Goods.ObjectId
                                                      AND OL_GoodsKind.ChildObjectId = inGoodsKindId
                                                      AND OL_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                 -- ������ ���� - �� ��������� "�������"
                                 INNER JOIN ObjectLink AS OL_Goods_Sh
                                                       ON OL_Goods_Sh.ObjectId = OL_Goods.ObjectId
                                                      AND OL_Goods_Sh.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods_Sh()
                                 INNER JOIN ObjectLink AS OL_GoodsKind_Sh
                                                       ON OL_GoodsKind_Sh.ObjectId = OL_Goods.ObjectId
                                                      AND OL_GoodsKind_Sh.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind_Sh()
                                 -- ����� ��-� �� ��������� "�������"
                                 INNER JOIN ObjectLink AS OL_Goods_find
                                                       ON OL_Goods_find.ChildObjectId = OL_Goods_Sh.ChildObjectId
                                                      AND OL_Goods_find.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                 INNER JOIN ObjectLink AS OL_GoodsKind_find
                                                       ON OL_GoodsKind_find.ObjectId      = OL_Goods_find.ObjectId
                                                      AND OL_GoodsKind_find.ChildObjectId = OL_GoodsKind_Sh.ChildObjectId
                                                      AND OL_GoodsKind_find.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                 -- ��� ��� - ��� ������� ...
                                 LEFT JOIN ObjectFloat AS ObjectFloat_WmsCode_Sh
                                                       ON ObjectFloat_WmsCode_Sh.ObjectId = OL_Goods_find.ObjectId
                                                      AND ObjectFloat_WmsCode_Sh.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()

                                 -- ����� ����
                                 INNER JOIN ObjectLink AS OL_GoodsPropertyBox_Goods
                                                       ON OL_GoodsPropertyBox_Goods.ChildObjectId = OL_Goods_Sh.ChildObjectId
                                                      AND OL_GoodsPropertyBox_Goods.DescId        = zc_ObjectLink_GoodsPropertyBox_Goods()
                                 INNER JOIN ObjectLink AS OL_GoodsPropertyBox_GoodsKind
                                                       ON OL_GoodsPropertyBox_GoodsKind.ObjectId      = OL_GoodsPropertyBox_Goods.ObjectId
                                                      AND OL_GoodsPropertyBox_GoodsKind.ChildObjectId = OL_GoodsKind_Sh.ChildObjectId
                                                      AND OL_GoodsPropertyBox_GoodsKind.DescId        = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
                                 -- ���������� - E2 + E3
                                 INNER JOIN ObjectLink AS OL_GoodsPropertyBox_Box
                                                       ON OL_GoodsPropertyBox_Box.ObjectId = OL_GoodsPropertyBox_Goods.ObjectId
                                                      AND OL_GoodsPropertyBox_Box.DescId   = zc_ObjectLink_GoodsPropertyBox_Box()
                                                      AND OL_GoodsPropertyBox_Box.ChildObjectId IN (zc_Box_E2(), zc_Box_E3())
                                 -- ����������� � ����
                                 LEFT JOIN ObjectFloat AS ObjectFloat_WeightOnBox_Sh
                                                       ON ObjectFloat_WeightOnBox_Sh.ObjectId = OL_GoodsPropertyBox_Goods.ObjectId
                                                      AND ObjectFloat_WeightOnBox_Sh.DescId   = zc_ObjectFloat_GoodsPropertyBox_WeightOnBox()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_CountOnBox_Sh
                                                       ON ObjectFloat_CountOnBox_Sh.ObjectId = OL_GoodsPropertyBox_Goods.ObjectId
                                                      AND ObjectFloat_CountOnBox_Sh.DescId   = zc_ObjectFloat_GoodsPropertyBox_CountOnBox()
      
                                 -- ����� + ���
                                 LEFT JOIN Object AS Object_Goods_Sh     ON Object_Goods_Sh.Id     = OL_Goods_Sh.ChildObjectId
                                 LEFT JOIN Object AS Object_GoodsKind_Sh ON Object_GoodsKind_Sh.Id = OL_GoodsKind_Sh.ChildObjectId

                            WHERE OL_Goods.ChildObjectId = inGoodsId
                              AND OL_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                           )
         , tmpRes AS (SELECT Object_Goods.Id                 AS GoodsId
                           , Object_Goods.ObjectCode         AS GoodsCode
                           , Object_Goods.ValueData          AS GoodsName
                           , Object_GoodsKind.Id             AS GoodsKindId
                           , Object_GoodsKind.ObjectCode     AS GoodsKindCode
                           , Object_GoodsKind.ValueData      AS GoodsKindName

                           , tmpObject_sh.GoodsId_sh
                           , tmpObject_sh.GoodsCode_sh
                           , tmpObject_sh.GoodsName_sh
                           , tmpObject_sh.GoodsKindId_sh
                           , tmpObject_sh.GoodsKindCode_sh
                           , tmpObject_sh.GoodsKindName_sh

                           , Object_Measure.Id               AS MeasureId
                           , Object_Measure.ObjectCode       AS MeasureCode
                           , Object_Measure.ValueData        AS MeasureName

                             -- Id - ���� �� ��.
                           , COALESCE (OL_GoodsTypeKind_Sh.ChildObjectId,  0) AS GoodsTypeKindId_Sh
                             -- Id - ���� �� ���.
                           , COALESCE (OL_GoodsTypeKind_Nom.ChildObjectId, 0) AS GoodsTypeKindId_Nom
                             -- Id - ���� �� ���
                           , COALESCE (OL_GoodsTypeKind_Ves.ChildObjectId, 0) AS GoodsTypeKindId_Ves

                             -- ��� ��� - ��. - !!!������
                           , CASE WHEN OL_GoodsTypeKind_Sh.ChildObjectId <> 0
                                  THEN REPEAT ('0', 3 - LENGTH ((COALESCE (tmpObject_sh.WmsCode_Sh, ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar))
                                    || (COALESCE (tmpObject_sh.WmsCode_Sh, ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                    || '1'
                                  ELSE ''
                             END :: TVarChar AS WmsCode_Sh

                             -- ��� ��� - ���.
                           , CASE WHEN OL_GoodsTypeKind_Nom.ChildObjectId <> 0
                                  THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                                     || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                     || '2'
                                  ELSE ''
                             END :: TVarChar AS WmsCode_Nom

                             -- ��� ��� - ���
                           , CASE WHEN OL_GoodsTypeKind_Ves.ChildObjectId  <> 0
                                  THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                                     || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                     || '3'
                                  ELSE ''
                             END :: TVarChar AS WmsCode_Ves

                             -- ����������� ��� 1��. - !!!��������
                           , CASE WHEN OL_GoodsTypeKind_Sh.ChildObjectId  > 0
                                       THEN COALESCE (ObjectFloat_Avg_Sh.ValueData  * (1 - ObjectFloat_Tax_Sh.ValueData  / 100), 0)
                                  WHEN OL_GoodsTypeKind_Nom.ChildObjectId > 0
                                       THEN COALESCE (ObjectFloat_Avg_Nom.ValueData * (1 - ObjectFloat_Tax_Nom.ValueData / 100), 0)
                                  WHEN OL_GoodsTypeKind_Ves.ChildObjectId > 0
                                       THEN COALESCE (ObjectFloat_Avg_Ves.ValueData * (1 - ObjectFloat_Tax_Ves.ValueData / 100), 0)
                                  ELSE 0
                             END  :: TFloat AS WeightMin
                         --, COALESCE (ObjectFloat_WeightMin.ValueData,0) :: TFloat AS WeightMin

                             -- ������������ ��� 1��. - !!!��������
                           , CASE WHEN OL_GoodsTypeKind_Sh.ChildObjectId  > 0
                                       THEN COALESCE (ObjectFloat_Avg_Sh.ValueData  * (1 + ObjectFloat_Tax_Sh.ValueData  / 100), 0)
                                  WHEN OL_GoodsTypeKind_Nom.ChildObjectId > 0
                                       THEN COALESCE (ObjectFloat_Avg_Nom.ValueData * (1 + ObjectFloat_Tax_Nom.ValueData / 100), 0)
                                  WHEN OL_GoodsTypeKind_Ves.ChildObjectId > 0
                                       THEN COALESCE (ObjectFloat_Avg_Ves.ValueData * (1 + ObjectFloat_Tax_Ves.ValueData / 100), 0)
                                  ELSE 0
                             END  :: TFloat AS WeightMax
                         --, COALESCE (ObjectFloat_WeightMax.ValueData,0) :: TFloat AS WeightMax

                             -- ����������� ��� 1��. - ��� ���������
                           , COALESCE (ObjectFloat_Avg_Sh.ValueData  * (1 - ObjectFloat_Tax_Sh.ValueData  / 100), 0) :: TFloat AS WeightMin_sh
                           , COALESCE (ObjectFloat_Avg_Nom.ValueData * (1 - ObjectFloat_Tax_Nom.ValueData / 100), 0) :: TFloat AS WeightMin_Nom
                           , COALESCE (ObjectFloat_Avg_Ves.ValueData * (1 - ObjectFloat_Tax_Ves.ValueData / 100), 0) :: TFloat AS WeightMin_Ves
                             -- ������������ ��� 1��. - ��� ���������
                           , COALESCE (ObjectFloat_Avg_Sh.ValueData  * (1 + ObjectFloat_Tax_Sh.ValueData  / 100), 0) :: TFloat AS WeightMax_sh
                           , COALESCE (ObjectFloat_Avg_Nom.ValueData * (1 + ObjectFloat_Tax_Nom.ValueData / 100), 0) :: TFloat AS WeightMax_Nom
                           , COALESCE (ObjectFloat_Avg_Ves.ValueData * (1 + ObjectFloat_Tax_Ves.ValueData / 100), 0) :: TFloat AS WeightMax_Ves

                             -- ������� - 1-�� �����
                        -- , 0  :: Integer  AS GoodsTypeKindId_1
                        -- , 0  :: Integer  AS BarCodeBoxId_1
                        -- , 0  :: Integer  AS BoxCode_1
                        -- , '' :: TVarChar AS BoxBarCode_1
                        -- , 0  :: TFloat   AS WeightOnBoxTotal_1
                        -- , 0  :: TFloat   AS CountOnBoxTotal_1
                             -- ����
                           , Object_Box.Id                      AS BoxId_1
                           , Object_Box.ValueData               AS BoxName_1
                             -- ��� ������ �����
                           , ObjectFloat_Box_Weight.ValueData   AS BoxWeight_1

                             -- ����������� - �� ���� - !�������! - !!!������
                         --, CASE WHEN COALESCE (tmpObject_sh.CountOnBox_sh, ObjectFloat_CountOnBox.ValueData) > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                           , CASE WHEN COALESCE (tmpObject_sh.CountOnBox_sh, ObjectFloat_CountOnBox.ValueData) > 0 AND ObjectFloat_Avg_Sh.ValueData > 0
                                    -- THEN ObjectFloat_CountOnBox.ValueData * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                                       THEN COALESCE (tmpObject_sh.CountOnBox_sh, ObjectFloat_CountOnBox.ValueData) * ObjectFloat_Avg_Sh.ValueData
                                  ELSE COALESCE (tmpObject_sh.WeightOnBox_sh, ObjectFloat_WeightOnBox.ValueData)
                             END                      :: TFloat AS WeightOnBox_1

                             -- ����������� - ��. (�� ������������!) - !!!������
                           , COALESCE (tmpObject_sh.CountOnBox_sh, ObjectFloat_CountOnBox.ValueData) :: TFloat AS CountOnBox_1

                             -- ������� - 2-�� �����
                        -- , 0  :: Integer  AS GoodsTypeKindId_2
                        -- , 0  :: Integer  AS BarCodeBoxId_2
                        -- , 0  :: Integer  AS BoxCode_2
                        -- , '' :: TVarChar AS BoxBarCode_2
                        -- , 0  :: TFloat   AS WeightOnBoxTotal_2
                        -- , 0  :: TFloat   AS CountOnBoxTotal_2
                             -- ����
                           , Object_Box.Id                      AS BoxId_2
                           , Object_Box.ValueData               AS BoxName_2
                             -- ��� ������ �����
                           , ObjectFloat_Box_Weight.ValueData   AS BoxWeight_2

                             -- ����������� - �� ���� - !�������!
                         --, CASE WHEN ObjectFloat_CountOnBox.ValueData > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                           , CASE WHEN ObjectFloat_CountOnBox.ValueData > 0 AND ObjectFloat_Avg_Nom.ValueData > 0
                                    -- THEN ObjectFloat_CountOnBox.ValueData * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                                       THEN ObjectFloat_CountOnBox.ValueData * ObjectFloat_Avg_Nom.ValueData
                                  ELSE ObjectFloat_WeightOnBox.ValueData
                             END                      :: TFloat AS WeightOnBox_2

                             -- ����������� - ��. (�� ������������!)
                           , ObjectFloat_CountOnBox.ValueData   AS CountOnBox_2

                             -- ������� - 3-�� �����
                        -- , 0  :: Integer  AS GoodsTypeKindId_3
                        -- , 0  :: Integer  AS BarCodeBoxId_3
                        -- , 0  :: Integer  AS BoxCode_3
                        -- , '' :: TVarChar AS BoxBarCode_3
                        -- , 0  :: TFloat   AS WeightOnBoxTotal_3
                        -- , 0  :: TFloat   AS CountOnBoxTotal_3
                             -- ����
                           , Object_Box.Id                      AS BoxId_3
                           , Object_Box.ValueData               AS BoxName_3
                             -- ��� ������ �����
                           , ObjectFloat_Box_Weight.ValueData   AS BoxWeight_3

                             -- ����������� - �� ���� - !�������!
                         --, CASE WHEN ObjectFloat_CountOnBox.ValueData > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                           , CASE WHEN ObjectFloat_CountOnBox.ValueData > 0 AND ObjectFloat_Avg_Ves.ValueData > 0
                                    -- THEN ObjectFloat_CountOnBox.ValueData * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                                       THEN ObjectFloat_CountOnBox.ValueData * ObjectFloat_Avg_Ves.ValueData
                                  ELSE ObjectFloat_WeightOnBox.ValueData
                             END                      :: TFloat AS WeightOnBox_3

                             -- ����������� - ��. (�� ������������!)
                           , ObjectFloat_CountOnBox.ValueData   AS CountOnBox_3

                      FROM Object AS Object_GoodsByGoodsKind
                           INNER JOIN ObjectLink AS OL_Goods
                                                 ON OL_Goods.ObjectId      = Object_GoodsByGoodsKind.Id
                                                AND OL_Goods.ChildObjectId = inGoodsId
                                                AND OL_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                           INNER JOIN ObjectLink AS OL_GoodsKind
                                                 ON OL_GoodsKind.ObjectId      = Object_GoodsByGoodsKind.Id
                                                AND OL_GoodsKind.ChildObjectId = inGoodsKindId
                                                AND OL_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                           -- ���������
                           LEFT JOIN ObjectLink AS OL_GoodsTypeKind_Sh
                                                ON OL_GoodsTypeKind_Sh.ObjectId = Object_GoodsByGoodsKind.Id
                                               AND OL_GoodsTypeKind_Sh.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh()
                           LEFT JOIN ObjectLink AS OL_GoodsTypeKind_Nom
                                                ON OL_GoodsTypeKind_Nom.ObjectId = Object_GoodsByGoodsKind.Id
                                               AND OL_GoodsTypeKind_Nom.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom()
                           LEFT JOIN ObjectLink AS OL_GoodsTypeKind_Ves
                                                ON OL_GoodsTypeKind_Ves.ObjectId = Object_GoodsByGoodsKind.Id
                                               AND OL_GoodsTypeKind_Ves.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves()
                           --
                           LEFT JOIN ObjectLink AS OL_Goods_Measure
                                                ON OL_Goods_Measure.ObjectId = OL_Goods.ChildObjectId
                                               AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()

                           LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = OL_Goods.ChildObjectId
                           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = OL_GoodsKind.ChildObjectId
                           LEFT JOIN Object AS Object_Measure   ON Object_Measure.Id   = OL_Goods_Measure.ChildObjectId

                           -- ������ ���� - �� ��������� "�������"
                           LEFT JOIN tmpObject_sh ON tmpObject_sh.GoodsByGoodsKindId   = Object_GoodsByGoodsKind.Id
                                                 -- !!! ������ ��� "�������"
                                                 AND OL_GoodsTypeKind_Sh.ChildObjectId > 0

                           -- ��� ��� - ��� ������� ...
                           LEFT JOIN ObjectFloat AS ObjectFloat_WmsCode
                                                 ON ObjectFloat_WmsCode.ObjectId = Object_GoodsByGoodsKind.Id
                                                AND ObjectFloat_WmsCode.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()
                           -- ������� ��� 1��.
                           LEFT JOIN ObjectFloat AS ObjectFloat_Avg_Sh
                                                 ON ObjectFloat_Avg_Sh.ObjectId = Object_GoodsByGoodsKind.Id
                                                AND ObjectFloat_Avg_Sh.DescId   = zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Avg_Nom
                                                 ON ObjectFloat_Avg_Nom.ObjectId = Object_GoodsByGoodsKind.Id
                                                AND ObjectFloat_Avg_Nom.DescId   = zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Avg_Ves
                                                 ON ObjectFloat_Avg_Ves.ObjectId = Object_GoodsByGoodsKind.Id
                                                AND ObjectFloat_Avg_Ves.DescId   = zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves()
                           -- % ���������� ���� 1��.
                           LEFT JOIN ObjectFloat AS ObjectFloat_Tax_Sh
                                                 ON ObjectFloat_Tax_Sh.ObjectId = Object_GoodsByGoodsKind.Id
                                                AND ObjectFloat_Tax_Sh.DescId   = zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Tax_Nom
                                                 ON ObjectFloat_Tax_Nom.ObjectId = Object_GoodsByGoodsKind.Id
                                                AND ObjectFloat_Tax_Nom.DescId   = zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Tax_Ves
                                                 ON ObjectFloat_Tax_Ves.ObjectId = Object_GoodsByGoodsKind.Id
                                                AND ObjectFloat_Tax_Ves.DescId   = zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves()

                           -- ����� ����
                           INNER JOIN ObjectLink AS OL_GoodsPropertyBox_Goods
                                                 ON OL_GoodsPropertyBox_Goods.ChildObjectId = inGoodsId
                                                AND OL_GoodsPropertyBox_Goods.DescId        = zc_ObjectLink_GoodsPropertyBox_Goods()
                           INNER JOIN ObjectLink AS OL_GoodsPropertyBox_GoodsKind
                                                 ON OL_GoodsPropertyBox_GoodsKind.ObjectId      = OL_GoodsPropertyBox_Goods.ObjectId
                                                AND OL_GoodsPropertyBox_GoodsKind.ChildObjectId = inGoodsKindId
                                                AND OL_GoodsPropertyBox_GoodsKind.DescId        = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
                           -- ���������� - E2 + E3
                           INNER JOIN ObjectLink AS OL_GoodsPropertyBox_Box
                                                 ON OL_GoodsPropertyBox_Box.ObjectId = OL_GoodsPropertyBox_Goods.ObjectId
                                                AND OL_GoodsPropertyBox_Box.DescId   = zc_ObjectLink_GoodsPropertyBox_Box()
                                                AND OL_GoodsPropertyBox_Box.ChildObjectId IN (zc_Box_E2(), zc_Box_E3())

                           LEFT JOIN Object AS Object_Box ON Object_Box.Id = OL_GoodsPropertyBox_Box.ChildObjectId
                           -- ��� ������ �����
                           LEFT JOIN ObjectFloat AS ObjectFloat_Box_Weight
                                                 ON ObjectFloat_Box_Weight.ObjectId = Object_Box.Id
                                                AND ObjectFloat_Box_Weight.DescId   = zc_ObjectFloat_Box_Weight()
                           -- ����������� � ����
                           LEFT JOIN ObjectFloat AS ObjectFloat_WeightOnBox
                                                 ON ObjectFloat_WeightOnBox.ObjectId = OL_GoodsPropertyBox_Goods.ObjectId
                                                AND ObjectFloat_WeightOnBox.DescId   = zc_ObjectFloat_GoodsPropertyBox_WeightOnBox()
                           LEFT JOIN ObjectFloat AS ObjectFloat_CountOnBox
                                                 ON ObjectFloat_CountOnBox.ObjectId = OL_GoodsPropertyBox_Goods.ObjectId
                                                AND ObjectFloat_CountOnBox.DescId   = zc_ObjectFloat_GoodsPropertyBox_CountOnBox()

                      WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind()
                     )
       -- ������� ��������� ������� ����, �� ������ ������ � LIMIT 1
     , tmpNpp_all AS (SELECT zc_Enum_GoodsTypeKind_Sh()  AS GoodsTypeKindId, CASE WHEN tmpRes.GoodsTypeKindId_Sh  > 0 THEN 10 ELSE 500 END AS Npp FROM tmpRes
                     UNION
                      SELECT zc_Enum_GoodsTypeKind_Nom() AS GoodsTypeKindId, CASE WHEN tmpRes.GoodsTypeKindId_Nom > 0 THEN 20 ELSE 200 END AS Npp FROM tmpRes
                     UNION
                      SELECT zc_Enum_GoodsTypeKind_Ves() AS GoodsTypeKindId, CASE WHEN tmpRes.GoodsTypeKindId_Ves > 0 THEN 30 ELSE 300 END AS Npp FROM tmpRes
                     )
           -- �������� � �/� - �� ����������� 1,2,3
         , tmpNpp AS (SELECT tmpNpp_all.GoodsTypeKindId, tmpNpp_all.Npp, ROW_NUMBER() OVER (ORDER BY tmpNpp_all.Npp ASC) AS Ord FROM tmpNpp_all)

      -- ���������
      SELECT tmpRes.GoodsId
           , tmpRes.GoodsCode
           , tmpRes.GoodsName
           , tmpRes.GoodsKindId
           , tmpRes.GoodsKindCode
           , tmpRes.GoodsKindName

           , tmpRes.GoodsId_sh
           , tmpRes.GoodsCode_sh
           , tmpRes.GoodsName_sh
           , tmpRes.GoodsKindId_sh
           , tmpRes.GoodsKindCode_sh
           , tmpRes.GoodsKindName_sh

           , tmpRes.MeasureId
           , tmpRes.MeasureCode
           , tmpRes.MeasureName

             -- ������� ����� ��� ������ - 1,2 ��� 3
           , (CASE WHEN tmpRes.GoodsTypeKindId_Sh  > 0 THEN 1 ELSE 0 END
            + CASE WHEN tmpRes.GoodsTypeKindId_Nom > 0 THEN 1 ELSE 0 END
            + CASE WHEN tmpRes.GoodsTypeKindId_Ves > 0 THEN 1 ELSE 0 END
             ) :: Integer AS Count_box

             -- Id - ���� �� ��.
           , tmpRes.GoodsTypeKindId_Sh
             -- Id - ���� �� ���.
           , tmpRes.GoodsTypeKindId_Nom
             -- Id - ���� �� ���
           , tmpRes.GoodsTypeKindId_Ves

             -- ��� ��� - ��.
           , tmpRes.WmsCode_Sh
             -- ��� ��� - ���.
           , tmpRes.WmsCode_Nom
             -- ��� ��� - ���
           , tmpRes.WmsCode_Ves

             -- ����������� ��� 1��. - !!!��������
           , tmpRes.WeightMin
             -- ������������ ��� 1��.- !!!��������
           , tmpRes.WeightMax

           , tmpRes.WeightMin_Sh
           , tmpRes.WeightMin_Nom
           , tmpRes.WeightMin_Ves
           , tmpRes.WeightMax_Sh
           , tmpRes.WeightMax_Nom
           , tmpRes.WeightMax_Ves

             -- ������� - 1-�� ����� - � 1 �� ����������
           , CASE WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.GoodsTypeKindId_Sh
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.GoodsTypeKindId_Nom
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.GoodsTypeKindId_Ves

                  WHEN tmpNpp_3.Npp = 500
                       THEN -1
                  WHEN tmpNpp_3.Npp = 200
                       THEN -2
                  WHEN tmpNpp_3.Npp = 300
                       THEN -3

             END :: Integer AS GoodsTypeKindId_1
        -- , 0  :: Integer  AS BarCodeBoxId_1
        -- , 0  :: Integer  AS BoxCode_1
        -- , '' :: TVarChar AS BoxBarCode_1
        -- , 0  :: TFloat   AS WeightOnBoxTotal_1
        -- , 0  :: TFloat   AS CountOnBoxTotal_1
        -- , 0  :: TFloat   AS WeightTotal_1
        -- , 0  :: TFloat   AS CountTotal_1
        -- , 0  :: TFloat   AS BoxTotal_1
             -- ����
           , CASE WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.BoxId_1
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.BoxId_2
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.BoxId_3
             END :: Integer AS BoxId_1
           , CASE WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.BoxName_1
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.BoxName_2
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.BoxName_3
             END :: TVarChar AS BoxName_1
             -- ��� ������ �����
           , CASE WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.BoxWeight_1
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.BoxWeight_2
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.BoxWeight_3
             END :: TFloat AS BoxWeight_1
             -- ����������� - �� ����
           , CASE WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.WeightOnBox_1
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.WeightOnBox_2
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.WeightOnBox_3
             END :: TFloat AS WeightOnBox_1
             -- ����������� - �� (�� ������������!)
           , CASE WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.CountOnBox_1
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.CountOnBox_2
                  WHEN tmpNpp_1.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.CountOnBox_3
             END :: TFloat AS CountOnBox_1

             -- ������� - 2-�� ����� - � 2 �� ����������
           , CASE WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.GoodsTypeKindId_Sh
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.GoodsTypeKindId_Nom
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.GoodsTypeKindId_Ves

                  WHEN tmpNpp_3.Npp = 500
                       THEN -1
                  WHEN tmpNpp_3.Npp = 200
                       THEN -2
                  WHEN tmpNpp_3.Npp = 300
                       THEN -3

             END :: Integer AS GoodsTypeKindId_2
        -- , 0  :: Integer  AS BarCodeBoxId_2
        -- , 0  :: Integer  AS BoxCode_2
        -- , '' :: TVarChar AS BoxBarCode_2
        -- , 0  :: TFloat   AS WeightOnBoxTotal_2
        -- , 0  :: TFloat   AS CountOnBoxTotal_2
        -- , 0  :: TFloat   AS WeightTotal_2
        -- , 0  :: TFloat   AS CountTotal_2
        -- , 0  :: TFloat   AS BoxTotal_2
             -- ����
           , CASE WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.BoxId_1
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.BoxId_2
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.BoxId_3
             END :: Integer AS BoxId_2
           , CASE WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.BoxName_1
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.BoxName_2
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.BoxName_3
             END :: TVarChar AS BoxName_2
             -- ��� ������ �����
           , CASE WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.BoxWeight_1
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.BoxWeight_2
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.BoxWeight_3
             END :: TFloat AS BoxWeight_2
             -- ����������� - �� ����
           , CASE WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.WeightOnBox_1
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.WeightOnBox_2
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.WeightOnBox_3
             END :: TFloat AS WeightOnBox_2
             -- ����������� - �� (�� ������������!)
           , CASE WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.CountOnBox_1
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.CountOnBox_2
                  WHEN tmpNpp_2.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.CountOnBox_3
             END :: TFloat AS CountOnBox_2


             -- ������� - 3-�� ����� - � 3 �� ����������
           , CASE WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.GoodsTypeKindId_Sh
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.GoodsTypeKindId_Nom
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.GoodsTypeKindId_Ves

                  WHEN tmpNpp_3.Npp = 500
                       THEN -1
                  WHEN tmpNpp_3.Npp = 200
                       THEN -2
                  WHEN tmpNpp_3.Npp = 300
                       THEN -3

             END :: Integer AS GoodsTypeKindId_3
        -- , 0  :: Integer  AS BarCodeBoxId_3
        -- , 0  :: Integer  AS BoxCode_3
        -- , '' :: TVarChar AS BoxBarCode_3
        -- , 0  :: TFloat   AS WeightOnBoxTotal_3
        -- , 0  :: TFloat   AS CountOnBoxTotal_3
        -- , 0  :: TFloat   AS WeightTotal_3
        -- , 0  :: TFloat   AS CountTotal_3
        -- , 0  :: TFloat   AS BoxTotal_3
             -- ����
           , CASE WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.BoxId_1
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.BoxId_2
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.BoxId_3
             END :: Integer AS BoxId_3
           , CASE WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.BoxName_1
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.BoxName_2
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.BoxName_3
             END :: TVarChar AS BoxName_3
             -- ��� ������ �����
           , CASE WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.BoxWeight_1
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.BoxWeight_2
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.BoxWeight_3
             END :: TFloat AS BoxWeight_3
             -- ����������� - �� ����
           , CASE WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.WeightOnBox_1
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.WeightOnBox_2
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.WeightOnBox_3
             END :: TFloat AS WeightOnBox_3
             -- ����������� - �� (�� ������������!)
           , CASE WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Sh
                       THEN tmpRes.CountOnBox_1
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Nom
                       THEN tmpRes.CountOnBox_2
                  WHEN tmpNpp_3.GoodsTypeKindId = tmpRes.GoodsTypeKindId_Ves
                       THEN tmpRes.CountOnBox_3
             END :: TFloat AS CountOnBox_3

      FROM tmpRes
           -- ������� �� ����� ����� ����� ��������� "�������������" ��� "�� �������������" 
           LEFT JOIN tmpNpp AS tmpNpp_1 ON tmpNpp_1.Ord = 1
           LEFT JOIN tmpNpp AS tmpNpp_2 ON tmpNpp_2.Ord = 2
           LEFT JOIN tmpNpp AS tmpNpp_3 ON tmpNpp_3.Ord = 3
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.05.19                                        *
*/

-- ����
-- SELECT GoodsTypeKindId_Sh, GoodsTypeKindId_Nom, GoodsTypeKindId_Ves, GoodsTypeKindId_1, GoodsTypeKindId_2, GoodsTypeKindId_3 FROM gpGet_ScaleLight_Goods (inGoodsId:= 2153, inGoodsKindId:= 8352, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpGet_ScaleLight_Goods (inGoodsId:= 2153, inGoodsKindId:= 8352, inIs_test:= NULL, inSession:= zfCalc_UserAdmin())
