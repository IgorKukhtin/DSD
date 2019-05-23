-- Function: gpGet_Scale_GoodsLight()

DROP FUNCTION IF EXISTS gpGet_Scale_GoodsLight (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_GoodsLight(
    IN inGoodsId     Integer    , --
    IN inGoodsKindId Integer    ,
    IN inSession     TVarChar     -- ������ ������������
)
RETURNS TABLE (GoodsId             Integer
             , GoodsCode           Integer
             , GoodsName           TVarChar
             , GoodsKindId         Integer
             , GoodsKindCode       Integer
             , GoodsKindName       TVarChar
             , MeasureId           Integer
             , MeasureCode         Integer
             , MeasureName         TVarChar

             , GoodsTypeKindId_Sh  Integer  -- Id - ���� �� ��.  - �����
             , GoodsTypeKindId_Nom Integer  -- Id - ���� �� ���. - �������
             , GoodsTypeKindId_Ves Integer  -- Id - ���� �� ���  - ���

             , WmsCode_Sh          TVarChar -- ��� ��� - ��.
             , WmsCode_Nom         TVarChar -- ��� ��� - ���.
             , WmsCode_Ves         TVarChar -- ��� ��� - ���
             , WeightMin           TFloat   -- ����������� ��� 1��.
             , WeightMax           TFloat   -- ������������ ��� 1��.

          -- , GoodsTypeKindId_1   Integer  -- ������� - 1-�� �����
          -- , BoxCode_1           Integer  --
          -- , BoxBarCode_1        TVarChar --
          -- , WeightOnBoxTotal_1  TFloat   --
          -- , CountOnBoxTotal_1   TFloat   --
             , BoxId_1             Integer  --
             , BoxName_1           TVarChar --
             , BoxWeight_1         TFloat   -- ��� ������ �����
             , WeightOnBox_1       TFloat   -- ����������� - ���
             , CountOnBox_1        TFloat   -- ����������� - �� (������������?)

          -- , GoodsTypeKindId_2   Integer  -- ������� - 2-�� �����
          -- , BoxCode_2           Integer  --
          -- , BoxBarCode_2        TVarChar --
          -- , WeightOnBoxTotal_2  TFloat   --
          -- , CountOnBoxTotal_2   TFloat   --
             , BoxId_2             Integer  --
             , BoxName_2           TVarChar --
             , BoxWeight_2         TFloat   -- ��� ������ �����
             , WeightOnBox_2       TFloat   -- ����������� - ���
             , CountOnBox_2        TFloat   -- ����������� - �� (������������?)

          -- , GoodsTypeKindId_3   Integer  -- ������� - 3-�� �����
          -- , BoxCode_3           Integer  --
          -- , BoxBarCode_3        TVarChar --
          -- , WeightOnBoxTotal_3  TFloat   --
          -- , CountOnBoxTotal_2   TFloat   --
             , BoxId_3             Integer  --
             , BoxName_3           TVarChar --
             , BoxWeight_3         TFloat   -- ��� ������ �����
             , WeightOnBox_3       TFloat   -- ����������� - ���
             , CountOnBox_3        TFloat   -- ����������� - �� (������������?)
              )
AS
$BODY$
   DECLARE vbUserId          Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    --
    RETURN QUERY
      -- ���������
      SELECT Object_Goods.Id             AS GoodsId
           , Object_Goods.ObjectCode     AS GoodsCode
           , Object_Goods.ValueData      AS GoodsName
           , Object_GoodsKind.Id         AS GoodsKindId
           , Object_GoodsKind.ObjectCode AS GoodsKindCode
           , Object_GoodsKind.ValueData  AS GoodsKindName
           , Object_Measure.Id           AS MeasureId
           , Object_Measure.ObjectCode   AS MeasureCode
           , Object_Measure.ValueData    AS MeasureName

             -- Id - ���� �� ��.
           , COALESCE (OL_GoodsTypeKind_Sh.ChildObjectId,  0) AS GoodsTypeKindId_Sh
             -- Id - ���� �� ���.
           , COALESCE (OL_GoodsTypeKind_Nom.ChildObjectId, 0) AS GoodsTypeKindId_Nom
             -- Id - ���� �� ���
           , COALESCE (OL_GoodsTypeKind_Ves.ChildObjectId, 0) AS GoodsTypeKindId_Ves

             -- ��� ��� - ��.
           , CASE WHEN OL_GoodsTypeKind_Sh.ChildObjectId <> 0
                  THEN REPEAT ('0', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                    || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                    || '1'
                  ELSE ''
             END :: TVarChar AS WmsCode_Sh
             -- ��� ��� - ���.
           , CASE WHEN OL_GoodsTypeKind_Nom.ChildObjectId <> 0
                  THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                     || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                 --  || '.'
                     || '2'
                  ELSE ''
             END :: TVarChar AS WmsCode_Nom
             -- ��� ��� - ���
           , CASE WHEN OL_GoodsTypeKind_Ves.ChildObjectId  <> 0
                  THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                     || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                  -- || '.'
                     || '3'
                  ELSE ''
             END :: TVarChar AS WmsCode_Ves

             -- ����������� ��� 1��.
           , COALESCE (ObjectFloat_WeightMin.ValueData,0) :: TFloat AS WeightMin
             -- ������������ ��� 1��.
           , COALESCE (ObjectFloat_WeightMax.ValueData,0) :: TFloat AS WeightMax

             -- ������� - 1-�� �����
        -- , 0  :: Integer  AS GoodsTypeKindId_1
        -- , 0  :: Integer  AS BoxCode_1
        -- , '' :: TVarChar AS BoxBarCode_1
        -- , 0  :: TFloat   AS WeightOnBoxTotal_1
        -- , 0  :: TFloat   AS CountOnBoxTotal_1
             -- ����
           , Object_Box.Id                      AS BoxId_1
           , Object_Box.ValueData               AS BoxName_1
             -- ��� ������ �����
           , ObjectFloat_Box_Weight.ValueData   AS BoxWeight_1
             -- ����������� - ���
           , ObjectFloat_WeightOnBox.ValueData  AS WeightOnBox_1
             -- ����������� - �� (������������?)
           , ObjectFloat_CountOnBox.ValueData   AS CountOnBox_1

             -- ������� - 2-�� �����
        -- , 0  :: Integer  AS GoodsTypeKindId_2
        -- , 0  :: Integer  AS BoxCode_2
        -- , '' :: TVarChar AS BoxBarCode_2
        -- , 0  :: TFloat   AS WeightOnBoxTotal_2
        -- , 0  :: TFloat   AS CountOnBoxTotal_2
             -- ����
           , Object_Box.Id                      AS BoxId_2
           , Object_Box.ValueData               AS BoxName_2
             -- ��� ������ �����
           , ObjectFloat_Box_Weight.ValueData   AS BoxWeight_2
             -- ����������� - ���
           , ObjectFloat_WeightOnBox.ValueData  AS WeightOnBox_2
             -- ����������� - �� (������������?)
           , ObjectFloat_CountOnBox.ValueData   AS CountOnBox_2

             -- ������� - 3-�� �����
        -- , 0  :: Integer  AS GoodsTypeKindId_3
        -- , 0  :: Integer  AS BoxCode_3
        -- , '' :: TVarChar AS BoxBarCode_3
        -- , 0  :: TFloat   AS WeightOnBoxTotal_3
        -- , 0  :: TFloat   AS CountOnBoxTotal_3
             -- ����
           , Object_Box.Id                      AS BoxId_3
           , Object_Box.ValueData               AS BoxName_3
             -- ��� ������ �����
           , ObjectFloat_Box_Weight.ValueData   AS BoxWeight_3
             -- ����������� - ���
           , ObjectFloat_WeightOnBox.ValueData  AS WeightOnBox_3
             -- ����������� - �� (������������?)
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

           LEFT JOIN ObjectLink AS OL_GoodsTypeKind_Sh
                                ON OL_GoodsTypeKind_Sh.ObjectId = Object_GoodsByGoodsKind.Id
                               AND OL_GoodsTypeKind_Sh.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh()
           LEFT JOIN ObjectLink AS OL_GoodsTypeKind_Nom
                                ON OL_GoodsTypeKind_Nom.ObjectId = Object_GoodsByGoodsKind.Id
                               AND OL_GoodsTypeKind_Nom.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom()
           LEFT JOIN ObjectLink AS OL_GoodsTypeKind_Ves
                                ON OL_GoodsTypeKind_Ves.ObjectId = Object_GoodsByGoodsKind.Id
                               AND OL_GoodsTypeKind_Ves.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves()
           LEFT JOIN ObjectLink AS OL_Goods_Measure
                                ON OL_Goods_Measure.ObjectId = OL_Goods.ChildObjectId
                               AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()

           LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = OL_Goods.ChildObjectId
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = OL_GoodsKind.ChildObjectId
           LEFT JOIN Object AS Object_Measure   ON Object_Measure.Id   = OL_Goods_Measure.ChildObjectId

           LEFT JOIN ObjectFloat AS ObjectFloat_WmsCode
                                 ON ObjectFloat_WmsCode.ObjectId = Object_GoodsByGoodsKind.Id
                                AND ObjectFloat_WmsCode.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()
           LEFT JOIN ObjectFloat AS ObjectFloat_WeightMin
                                 ON ObjectFloat_WeightMin.ObjectId = Object_GoodsByGoodsKind.Id
                                AND ObjectFloat_WeightMin.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightMin()
           LEFT JOIN ObjectFloat AS ObjectFloat_WeightMax
                                 ON ObjectFloat_WeightMax.ObjectId = Object_GoodsByGoodsKind.Id
                                AND ObjectFloat_WeightMax.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightMax()
           -- ����� ����
           INNER JOIN ObjectLink AS OL_GoodsPropertyBox_Goods
                                 ON OL_GoodsPropertyBox_Goods.ChildObjectId = inGoodsId
                                AND OL_GoodsPropertyBox_Goods.DescId        = zc_ObjectLink_GoodsPropertyBox_Goods()
           INNER JOIN ObjectLink AS OL_GoodsPropertyBox_GoodsKind
                                 ON OL_GoodsPropertyBox_GoodsKind.ObjectId      = OL_GoodsPropertyBox_Goods.ObjectId
                                AND OL_GoodsPropertyBox_GoodsKind.ChildObjectId = inGoodsKindId
                                AND OL_GoodsPropertyBox_GoodsKind.DescId        = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
           LEFT JOIN ObjectLink AS OL_GoodsPropertyBox_Box
                                ON OL_GoodsPropertyBox_Box.ObjectId = OL_GoodsPropertyBox_Goods.ObjectId
                               AND OL_GoodsPropertyBox_Box.DescId   = zc_ObjectLink_GoodsPropertyBox_Box()
           LEFT JOIN Object AS Object_Box ON Object_Box.Id = OL_GoodsPropertyBox_Box.ChildObjectId
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
-- SELECT * FROM gpGet_Scale_GoodsLight (inGoodsId:= 2153, inGoodsKindId:= 8352, inSession:= zfCalc_UserAdmin())
