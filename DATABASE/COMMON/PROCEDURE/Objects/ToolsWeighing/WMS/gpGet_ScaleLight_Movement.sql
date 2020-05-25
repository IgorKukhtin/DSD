-- Function: gpGet_ScaleLight_Movement()

DROP FUNCTION IF EXISTS gpGet_ScaleLight_Movement (Integer, Integer, TDateTime, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_ScaleLight_Movement (BigInt, Integer, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpGet_ScaleLight_Movement (BigInt, Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ScaleLight_Movement(
    IN inMovementId            BigInt      , --
    IN inPlaceNumber           Integer     , --
    IN inOperDate              TDateTime   , --
    IN inIsNext                Boolean     , --
    IN inIs_test               Boolean     , --
    IN inSession               TVarChar      -- ������ ������������
)
RETURNS TABLE (MovementId       Integer
           --  MovementId       BigInt
             , BarCode          TVarChar
             , InvNumber        TVarChar
             , OperDate         TDateTime

          -- , isProductionIn     Boolean
             , MovementDescNumber Integer

             , MovementDescId Integer
             , FromId         Integer, FromCode         Integer, FromName         TVarChar
             , ToId           Integer, ToCode           Integer, ToName           TVarChar
               --                                                                 
             , GoodsId        Integer, GoodsCode        Integer, GoodsName        TVarChar
             , GoodsKindId    Integer, GoodsKindCode    Integer, GoodsKindName    TVarChar
             , GoodsId_sh     Integer, GoodsCode_sh     Integer, GoodsName_sh     TVarChar
             , GoodsKindId_sh Integer, GoodsKindCode_sh Integer, GoodsKindName_sh TVarChar
             , MeasureId      Integer, MeasureCode      Integer, MeasureName      TVarChar

             , Count_box           Integer   -- ������� ����� ��� ������ - 1,2 ��� 3
             , GoodsTypeKindId_Sh  Integer   -- Id - ���� �� ��.
             , GoodsTypeKindId_Nom Integer   -- Id - ���� �� ���.
             , GoodsTypeKindId_Ves Integer   -- Id - ���� �� ���
             , WmsCode_Sh          TVarChar  -- ��� ��� - ��.
             , WmsCode_Nom         TVarChar  -- ��� ��� - ���.
             , WmsCode_Ves         TVarChar  -- ��� ��� - ���

             , WeightMin           TFloat    -- ����������� ��� 1��. - !!!��������
             , WeightMax           TFloat    -- ������������ ��� 1��.- !!!��������

             , WeightMin_Sh        TFloat   -- ����������� ��� 1��.
             , WeightMin_Nom       TFloat   --
             , WeightMin_Ves       TFloat   --
             , WeightMax_Sh        TFloat   -- ������������ ��� 1��.
             , WeightMax_Nom       TFloat   --
             , WeightMax_Ves       TFloat   --

               -- 1-�� ����� - ������ ���� ����
             , GoodsTypeKindId_1  Integer    -- ��������� ��� ��� ����� �����
             , BarCodeBoxId_1     Integer    -- Id ��� �/� �����
             , BoxCode_1          Integer    -- ��� ��� �/� �����
             , BoxBarCode_1       TVarChar   -- �/� �����
          -- , WeightOnBoxTotal_1 TFloat     -- ��� ����� ������������� (� ���������� �����) - ��� ���������� ����� �����
          -- , CountOnBoxTotal_1  TFloat     -- �� ����� ������������ (� ���������� �����) - �� ������������!
          -- , WeightTotal_1      TFloat     -- ��� ����� ������������� (� �������� ������) - ������������
          -- , CountTotal_1       TFloat     -- �� ����� ������������� (� �������� ������) - ������������
          -- , BoxTotal_1         TFloat     -- ������ ����� (��������) - ������������

             , BoxId_1            Integer    -- Id �����
             , BoxName_1          TVarChar   -- �������� ����� �2 ��� �3
             , BoxWeight_1        TFloat     -- ��� ������ �����
             , WeightOnBox_1      TFloat     -- ����������� - ���
             , CountOnBox_1       TFloat     -- ����������� - �� (�� ������������!)

               -- 2-�� ����� - ������ ���� ����
             , GoodsTypeKindId_2  Integer    -- ��������� ��� ��� ����� �����
             , BarCodeBoxId_2     Integer    -- Id ��� �/� �����
             , BoxCode_2          Integer    -- ��� ��� �/� �����
             , BoxBarCode_2       TVarChar   -- �/� �����
          -- , WeightOnBoxTotal_2 TFloat     -- ��� ����� ������������� (� ���������� �����) - ��� ���������� ����� �����
          -- , CountOnBoxTotal_2  TFloat     -- �� ����� ������������ (� ���������� �����) - �� ������������!
          -- , WeightTotal_2      TFloat     -- ��� ����� ������������� (� �������� ������) - ������������
          -- , CountTotal_2       TFloat     -- �� ����� ������������� (� �������� ������) - ������������
          -- , BoxTotal_2         TFloat     -- ������ ����� (��������) - ������������

             , BoxId_2            Integer    -- Id �����
             , BoxName_2          TVarChar   -- �������� ����� �2 ��� �3
             , BoxWeight_2        TFloat     -- ��� ������ �����
             , WeightOnBox_2      TFloat     -- ����������� - ���
             , CountOnBox_2       TFloat     -- ����������� - �� (�� ������������!)

               -- 3-�� ����� - ������ ���� ����
             , GoodsTypeKindId_3  Integer    -- ��������� ��� ��� ����� �����
             , BarCodeBoxId_3     Integer    -- Id ��� �/� �����
             , BoxCode_3          Integer    -- ��� ��� �/� �����
             , BoxBarCode_3       TVarChar   -- �/� �����
          -- , WeightOnBoxTotal_3 TFloat     -- ��� ����� ������������� (� ���������� �����) - ��� ���������� ����� �����
          -- , CountOnBoxTotal_3  TFloat     -- �� ����� ������������ (� ���������� �����) - �� ������������!
          -- , WeightTotal_3      TFloat     -- ��� ����� ������������� (� �������� ������) - ������������
          -- , CountTotal_3       TFloat     -- �� ����� ������������� (� �������� ������) - ������������
          -- , BoxTotal_3         TFloat     -- ������ ����� (��������) - ������������

             , BoxId_3            Integer    -- Id �����
             , BoxName_3          TVarChar   -- �������� ����� �2 ��� �3
             , BoxWeight_3        TFloat     -- ��� ������ �����
             , WeightOnBox_3      TFloat     -- ����������� - ���
             , CountOnBox_3       TFloat     -- ����������� - �� (�� ������������!)
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY
       WITH tmpMovement AS (-- ���� inMovementId = 0, ����� - ��������� �� ��������
                            SELECT Movement.*
                            FROM (SELECT Movement.*
                                  FROM (SELECT (inOperDate - INTERVAL '0 DAY') AS StartDate, (inOperDate + INTERVAL '0 DAY') AS EndDate WHERE COALESCE (inMovementId, 0) = 0) AS tmp
                                       INNER JOIN wms_Movement_WeighingProduction AS Movement
                                               ON Movement.OperDate BETWEEN tmp.StartDate AND tmp.EndDate
                                              AND Movement.StatusId    = zc_Enum_Status_UnComplete()
                                              AND Movement.UserId      = vbUserId
                                              AND Movement.PlaceNumber = inPlaceNumber
                                  ORDER BY Movement.Id DESC
                                  LIMIT 1
                                 ) AS Movement
                           UNION
                            -- ��� "���������" �� ��������, �.�. <> inMovementId, ��� inIsNext = TRUE
                            SELECT Movement.*
                            FROM (SELECT (inOperDate - INTERVAL '0 DAY') AS StartDate, (inOperDate + INTERVAL '0 DAY') AS EndDate WHERE inIsNext = TRUE) AS tmp
                                 INNER JOIN wms_Movement_WeighingProduction AS Movement
                                         ON Movement.OperDate BETWEEN tmp.StartDate AND tmp.EndDate
                                        AND Movement.StatusId    = zc_Enum_Status_UnComplete()
                                        AND Movement.UserId      = vbUserId
                                        AND Movement.PlaceNumber = inPlaceNumber
                            WHERE Movement.Id <> inMovementId
                            -- LIMIT 2 -- ���� ������ 1-��� �� ���� ������
                           UNION
                            -- ��� inMovementId ���� �� ���� �� ��������, ��� inIsNext = FALSE
                            SELECT Movement.*
                            FROM (SELECT inMovementId AS MovementId WHERE inMovementId > 0 AND inIsNext = FALSE) AS tmp
                                 INNER JOIN wms_Movement_WeighingProduction AS Movement
                                         ON Movement.Id          = tmp.MovementId
                                        AND Movement.StatusId    = zc_Enum_Status_UnComplete()
                                     -- AND Movement.UserId      = vbUserId
                                     -- AND Movement.PlaceNumber = inPlaceNumber
                           )
         , tmpGoods AS (SELECT * FROM gpGet_ScaleLight_Goods (inGoodsId     := (SELECT tmpMovement.GoodsId     FROM tmpMovement)
                                                            , inGoodsKindId := (SELECT tmpMovement.GoodsKindId FROM tmpMovement)
                                                            , inIs_test     := NULL
                                                            , inSession     := inSession
                                                             ))
           , tmpBox AS (SELECT OL_GoodsPropertyBox_Box.ChildObjectId AS BoxId
                             , Object_Box.ValueData                  AS BoxName
                               -- ��� ������ �����                   
                             , ObjectFloat_Box_Weight.ValueData      AS BoxWeight
                               -- ����������� - ���                  
                             , ObjectFloat_WeightOnBox.ValueData     AS WeightOnBox
                               -- ����������� - �� (�� ������������!)
                             , ObjectFloat_CountOnBox.ValueData      AS CountOnBox
                        FROM -- ����� ����
                             ObjectLink AS OL_GoodsPropertyBox_Goods
                             INNER JOIN ObjectLink AS OL_GoodsPropertyBox_GoodsKind
                                                   ON OL_GoodsPropertyBox_GoodsKind.ObjectId      = OL_GoodsPropertyBox_Goods.ObjectId
                                                  AND OL_GoodsPropertyBox_GoodsKind.ChildObjectId = (SELECT tmpMovement.GoodsKindId FROM tmpMovement LIMIT 1)
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

                        WHERE OL_GoodsPropertyBox_Goods.ChildObjectId = (SELECT tmpMovement.GoodsId FROM tmpMovement LIMIT 1)
                          AND OL_GoodsPropertyBox_Goods.DescId        = zc_ObjectLink_GoodsPropertyBox_Goods()
                       )

      -- ���������
      SELECT Movement.Id :: Integer                      AS MovementId
   -- SELECT Movement.Id                                 AS MovementId
           , '' ::TVarChar                                  AS BarCode
           , Movement.InvNumber                          AS InvNumber
           , Movement.OperDate                           AS OperDate

           , Movement.MovementDescNumber                 AS MovementDescNumber
           , Movement.MovementDescId                     AS MovementDescId
           , Object_From.Id                              AS FromId
           , Object_From.ObjectCode                      AS FromCode
           , Object_From.ValueData                       AS FromName
           , Object_To.Id                                AS ToId
           , Object_To.ObjectCode                        AS ToCode
           , Object_To.ValueData                         AS ToName

             --
           , tmpGoods.GoodsId, tmpGoods.GoodsCode, tmpGoods.GoodsName
           , tmpGoods.GoodsKindId, tmpGoods.GoodsKindCode, tmpGoods.GoodsKindName
           , tmpGoods.GoodsId_sh, tmpGoods.GoodsCode_sh, tmpGoods.GoodsName_sh
           , tmpGoods.GoodsKindId_sh, tmpGoods.GoodsKindCode_sh, tmpGoods.GoodsKindName_sh
           , tmpGoods.MeasureId, tmpGoods.MeasureCode, tmpGoods.MeasureName

             -- ������� ����� ��� ������ - 1,2 ��� 3
           , (CASE WHEN Movement.GoodsTypeKindId_1 > 0 THEN 1 ELSE 0 END
            + CASE WHEN Movement.GoodsTypeKindId_2 > 0 THEN 1 ELSE 0 END
            + CASE WHEN Movement.GoodsTypeKindId_3 > 0 THEN 1 ELSE 0 END
             ) :: Integer AS Count_box

             -- Id - ���� �� ��.
           , CASE WHEN Movement.GoodsTypeKindId_1 = zc_Enum_GoodsTypeKind_Sh()
                    OR Movement.GoodsTypeKindId_2 = zc_Enum_GoodsTypeKind_Sh()
                    OR Movement.GoodsTypeKindId_3 = zc_Enum_GoodsTypeKind_Sh()
                  THEN zc_Enum_GoodsTypeKind_Sh()
                  ELSE 0
             END AS GoodsTypeKindId_Sh 
             -- Id - ���� �� ���.  
           , CASE WHEN Movement.GoodsTypeKindId_1 = zc_Enum_GoodsTypeKind_Nom()
                    OR Movement.GoodsTypeKindId_2 = zc_Enum_GoodsTypeKind_Nom()
                    OR Movement.GoodsTypeKindId_3 = zc_Enum_GoodsTypeKind_Nom()
                  THEN zc_Enum_GoodsTypeKind_Nom()
                  ELSE 0
             END AS GoodsTypeKindId_Nom
             -- Id - ���� �� ���
           , CASE WHEN Movement.GoodsTypeKindId_1 = zc_Enum_GoodsTypeKind_Ves()
                    OR Movement.GoodsTypeKindId_2 = zc_Enum_GoodsTypeKind_Ves()
                    OR Movement.GoodsTypeKindId_3 = zc_Enum_GoodsTypeKind_Ves()
                  THEN zc_Enum_GoodsTypeKind_Ves()
                  ELSE 0
             END AS GoodsTypeKindId_Ves

           , tmpGoods.WmsCode_Sh           -- ��� ��� - ��.
           , tmpGoods.WmsCode_Nom          -- ��� ��� - ���.
           , tmpGoods.WmsCode_Ves          -- ��� ��� - ���

           , tmpGoods.WeightMin            -- ����������� ��� 1��. - !!!��������
           , tmpGoods.WeightMax            -- ������������ ��� 1��.- !!!��������

           , tmpGoods.WeightMin_Sh
           , tmpGoods.WeightMin_Nom
           , tmpGoods.WeightMin_Ves
           , tmpGoods.WeightMax_Sh
           , tmpGoods.WeightMax_Nom
           , tmpGoods.WeightMax_Ves

             -- 1-�� ����� - ������ ���� ����
           , Movement.GoodsTypeKindId_1                      -- ��������� ��� ��� ����� �����
           , Movement.BarCodeBoxId_1                         -- Id ��� �/� �����
           , Object_BarCodeBox_1.ObjectCode AS BoxCode_1     -- ��� ��� �/� �����
           , Object_BarCodeBox_1.ValueData  AS BoxBarCode_1  -- �/� �����
        -- , WeightOnBoxTotal_1 TFloat     -- ��� ����� ������������� (� ���������� �����) - ��� ���������� ����� �����
        -- , CountOnBoxTotal_1  TFloat     -- �� ����� ������������ (� ���������� �����) - �� ������������!
        -- , WeightTotal_1      TFloat     -- ��� ����� ������������� (� �������� ������) - ������������
        -- , CountTotal_1       TFloat     -- �� ����� ������������� (� �������� ������) - ������������
        -- , BoxTotal_1         TFloat     -- ������ ����� (��������) - ������������

           , tmpGoods.BoxId_1                  -- Id �����
           , tmpGoods.BoxName_1                -- �������� ����� �2 ��� �3
           , tmpGoods.BoxWeight_1              -- ��� ������ �����
           , tmpGoods.WeightOnBox_1            -- ����������� - �� ���� - !�������!
           , tmpGoods.CountOnBox_1             -- ����������� - �� (�� ������������!)

             -- 2-�� ����� - ������ ���� ����
           , Movement.GoodsTypeKindId_2                      -- ��������� ��� ��� ����� �����
           , Movement.BarCodeBoxId_2                         -- Id ��� �/� �����
           , Object_BarCodeBox_2.ObjectCode AS BoxCode_2     -- ��� ��� �/� �����
           , Object_BarCodeBox_2.ValueData  AS BoxBarCode_2  -- �/� �����
        -- , WeightOnBoxTotal_2 TFloat     -- ��� ����� ������������� (� ���������� �����) - ��� ���������� ����� �����
        -- , CountOnBoxTotal_2  TFloat     -- �� ����� ������������ (� ���������� �����) - �� ������������!
        -- , WeightTotal_2      TFloat     -- ��� ����� ������������� (� �������� ������) - ������������
        -- , CountTotal_2       TFloat     -- �� ����� ������������� (� �������� ������) - ������������
        -- , BoxTotal_2         TFloat     -- ������ ����� (��������) - ������������

           , tmpGoods.BoxId_2                  -- Id �����
           , tmpGoods.BoxName_2                -- �������� ����� �2 ��� �3
           , tmpGoods.BoxWeight_2              -- ��� ������ �����
           , tmpGoods.WeightOnBox_2            -- ����������� - �� ���� - !�������!
           , tmpGoods.CountOnBox_2             -- ����������� - �� (�� ������������!)

             -- 3-�� ����� - ������ ���� ����
           , Movement.GoodsTypeKindId_3                      -- ��������� ��� ��� ����� �����
           , Movement.BarCodeBoxId_3                         -- Id ��� �/� �����
           , Object_BarCodeBox_3.ObjectCode AS BoxCode_3     -- ��� ��� �/� �����
           , Object_BarCodeBox_3.ValueData  AS BoxBarCode_3  -- �/� �����
        -- , WeightOnBoxTotal_3 TFloat     -- ��� ����� ������������� (� ���������� �����) - ��� ���������� ����� �����
        -- , CountOnBoxTotal_3  TFloat     -- �� ����� ������������ (� ���������� �����) - �� ������������!
        -- , WeightTotal_3      TFloat     -- ��� ����� ������������� (� �������� ������) - ������������
        -- , CountTotal_3       TFloat     -- �� ����� ������������� (� �������� ������) - ������������
        -- , BoxTotal_3         TFloat     -- ������ ����� (��������) - ������������

           , tmpGoods.BoxId_3                  -- Id �����
           , tmpGoods.BoxName_3                -- �������� ����� �2 ��� �3
           , tmpGoods.BoxWeight_3              -- ��� ������ �����
           , tmpGoods.WeightOnBox_3            -- ����������� - �� ���� - !�������!
           , tmpGoods.CountOnBox_3             -- ����������� - �� (�� ������������!)

      FROM tmpMovement AS Movement
           LEFT JOIN Object AS Object_From ON Object_From.Id = Movement.FromId
           LEFT JOIN Object AS Object_To   ON Object_To.Id   = Movement.ToId

           LEFT JOIN Object AS Object_BarCodeBox_1 ON Object_BarCodeBox_1.Id = Movement.BarCodeBoxId_1
           LEFT JOIN Object AS Object_BarCodeBox_2 ON Object_BarCodeBox_2.Id = Movement.BarCodeBoxId_2
           LEFT JOIN Object AS Object_BarCodeBox_3 ON Object_BarCodeBox_3.Id = Movement.BarCodeBoxId_3

           LEFT JOIN tmpGoods ON 1=1
           LEFT JOIN tmpBox   ON 1=1
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.01.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_ScaleLight_Movement (0, 1, CURRENT_TIMESTAMP, FALSE, NULL, zfCalc_UserAdmin())
-- SELECT * FROM gpGet_ScaleLight_Movement (0, 1, CURRENT_TIMESTAMP, FALSE, NULL, zfCalc_UserAdmin())
