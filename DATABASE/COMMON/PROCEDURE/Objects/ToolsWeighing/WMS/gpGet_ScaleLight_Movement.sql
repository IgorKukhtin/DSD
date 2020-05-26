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
    IN inSession               TVarChar      -- сессия пользователя
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

             , Count_box           Integer   -- сколько линий для ящиков - 1,2 или 3
             , GoodsTypeKindId_Sh  Integer   -- Id - есть ли ШТ.
             , GoodsTypeKindId_Nom Integer   -- Id - есть ли НОМ.
             , GoodsTypeKindId_Ves Integer   -- Id - есть ли ВЕС
             , WmsCode_Sh          TVarChar  -- Код ВМС - ШТ.
             , WmsCode_Nom         TVarChar  -- Код ВМС - НОМ.
             , WmsCode_Ves         TVarChar  -- Код ВМС - ВЕС

             , WeightMin           TFloat    -- минимальный вес 1шт. - !!!временно
             , WeightMax           TFloat    -- максимальный вес 1шт.- !!!временно

             , WeightMin_Sh        TFloat   -- минимальный вес 1шт.
             , WeightMin_Nom       TFloat   --
             , WeightMin_Ves       TFloat   --
             , WeightMax_Sh        TFloat   -- максимальный вес 1шт.
             , WeightMax_Nom       TFloat   --
             , WeightMax_Ves       TFloat   --

               -- 1-ая линия - Всегда этот цвет
             , GoodsTypeKindId_1  Integer    -- выбранный тип для этого ЦВЕТА
             , BarCodeBoxId_1     Integer    -- Id для Ш/К ящика
             , BoxCode_1          Integer    -- код для Ш/К ящика
             , BoxBarCode_1       TVarChar   -- Ш/К ящика
          -- , WeightOnBoxTotal_1 TFloat     -- Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
          -- , CountOnBoxTotal_1  TFloat     -- шт итого накопительно (в незакрытом ящике) - НЕ информативно!
          -- , WeightTotal_1      TFloat     -- Вес итого накопительный (в закрытых ящиках) - информативно
          -- , CountTotal_1       TFloat     -- шт итого накопительный (в закрытых ящиках) - информативно
          -- , BoxTotal_1         TFloat     -- ящиков итого (закрытых) - информативно

             , BoxId_1            Integer    -- Id ящика
             , BoxName_1          TVarChar   -- название ящика Е2 или Е3
             , BoxWeight_1        TFloat     -- Вес самого ящика
             , WeightOnBox_1      TFloat     -- вложенность - Вес
             , CountOnBox_1       TFloat     -- Вложенность - шт (НЕ информативно!)

               -- 2-ая линия - Всегда этот цвет
             , GoodsTypeKindId_2  Integer    -- выбранный тип для этого ЦВЕТА
             , BarCodeBoxId_2     Integer    -- Id для Ш/К ящика
             , BoxCode_2          Integer    -- код для Ш/К ящика
             , BoxBarCode_2       TVarChar   -- Ш/К ящика
          -- , WeightOnBoxTotal_2 TFloat     -- Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
          -- , CountOnBoxTotal_2  TFloat     -- шт итого накопительно (в незакрытом ящике) - НЕ информативно!
          -- , WeightTotal_2      TFloat     -- Вес итого накопительный (в закрытых ящиках) - информативно
          -- , CountTotal_2       TFloat     -- шт итого накопительный (в закрытых ящиках) - информативно
          -- , BoxTotal_2         TFloat     -- ящиков итого (закрытых) - информативно

             , BoxId_2            Integer    -- Id ящика
             , BoxName_2          TVarChar   -- название ящика Е2 или Е3
             , BoxWeight_2        TFloat     -- Вес самого ящика
             , WeightOnBox_2      TFloat     -- вложенность - Вес
             , CountOnBox_2       TFloat     -- Вложенность - шт (НЕ информативно!)

               -- 3-ья линия - Всегда этот цвет
             , GoodsTypeKindId_3  Integer    -- выбранный тип для этого ЦВЕТА
             , BarCodeBoxId_3     Integer    -- Id для Ш/К ящика
             , BoxCode_3          Integer    -- код для Ш/К ящика
             , BoxBarCode_3       TVarChar   -- Ш/К ящика
          -- , WeightOnBoxTotal_3 TFloat     -- Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
          -- , CountOnBoxTotal_3  TFloat     -- шт итого накопительно (в незакрытом ящике) - НЕ информативно!
          -- , WeightTotal_3      TFloat     -- Вес итого накопительный (в закрытых ящиках) - информативно
          -- , CountTotal_3       TFloat     -- шт итого накопительный (в закрытых ящиках) - информативно
          -- , BoxTotal_3         TFloat     -- ящиков итого (закрытых) - информативно

             , BoxId_3            Integer    -- Id ящика
             , BoxName_3          TVarChar   -- название ящика Е2 или Е3
             , BoxWeight_3        TFloat     -- Вес самого ящика
             , WeightOnBox_3      TFloat     -- вложенность - Вес
             , CountOnBox_3       TFloat     -- Вложенность - шт (НЕ информативно!)
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       WITH tmpMovement AS (-- если inMovementId = 0, тогда - последний не закрытый
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
                            -- или "следующий" не закрытый, т.е. <> inMovementId, для inIsNext = TRUE
                            SELECT Movement.*
                            FROM (SELECT (inOperDate - INTERVAL '0 DAY') AS StartDate, (inOperDate + INTERVAL '0 DAY') AS EndDate WHERE inIsNext = TRUE) AS tmp
                                 INNER JOIN wms_Movement_WeighingProduction AS Movement
                                         ON Movement.OperDate BETWEEN tmp.StartDate AND tmp.EndDate
                                        AND Movement.StatusId    = zc_Enum_Status_UnComplete()
                                        AND Movement.UserId      = vbUserId
                                        AND Movement.PlaceNumber = inPlaceNumber
                            WHERE Movement.Id <> inMovementId
                            -- LIMIT 2 -- если больше 1-ого то типа ошибка
                           UNION
                            -- или inMovementId если он тоже не закрытый, для inIsNext = FALSE
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
                               -- Вес самого ящика                   
                             , ObjectFloat_Box_Weight.ValueData      AS BoxWeight
                               -- вложенность - Вес                  
                             , ObjectFloat_WeightOnBox.ValueData     AS WeightOnBox
                               -- Вложенность - шт (НЕ информативно!)
                             , ObjectFloat_CountOnBox.ValueData      AS CountOnBox
                        FROM -- нашли Ящик
                             ObjectLink AS OL_GoodsPropertyBox_Goods
                             INNER JOIN ObjectLink AS OL_GoodsPropertyBox_GoodsKind
                                                   ON OL_GoodsPropertyBox_GoodsKind.ObjectId      = OL_GoodsPropertyBox_Goods.ObjectId
                                                  AND OL_GoodsPropertyBox_GoodsKind.ChildObjectId = (SELECT tmpMovement.GoodsKindId FROM tmpMovement LIMIT 1)
                                                  AND OL_GoodsPropertyBox_GoodsKind.DescId        = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
                             -- ограничили - E2 + E3
                             INNER JOIN ObjectLink AS OL_GoodsPropertyBox_Box
                                                   ON OL_GoodsPropertyBox_Box.ObjectId = OL_GoodsPropertyBox_Goods.ObjectId
                                                  AND OL_GoodsPropertyBox_Box.DescId   = zc_ObjectLink_GoodsPropertyBox_Box()
                                                  AND OL_GoodsPropertyBox_Box.ChildObjectId IN (zc_Box_E2(), zc_Box_E3())

                             LEFT JOIN Object AS Object_Box ON Object_Box.Id = OL_GoodsPropertyBox_Box.ChildObjectId
                             -- Вес самого ящика
                             LEFT JOIN ObjectFloat AS ObjectFloat_Box_Weight
                                                   ON ObjectFloat_Box_Weight.ObjectId = Object_Box.Id
                                                  AND ObjectFloat_Box_Weight.DescId   = zc_ObjectFloat_Box_Weight()
                             -- вложенность в Ящик
                             LEFT JOIN ObjectFloat AS ObjectFloat_WeightOnBox
                                                   ON ObjectFloat_WeightOnBox.ObjectId = OL_GoodsPropertyBox_Goods.ObjectId
                                                  AND ObjectFloat_WeightOnBox.DescId   = zc_ObjectFloat_GoodsPropertyBox_WeightOnBox()
                             LEFT JOIN ObjectFloat AS ObjectFloat_CountOnBox
                                                   ON ObjectFloat_CountOnBox.ObjectId = OL_GoodsPropertyBox_Goods.ObjectId
                                                  AND ObjectFloat_CountOnBox.DescId   = zc_ObjectFloat_GoodsPropertyBox_CountOnBox()

                        WHERE OL_GoodsPropertyBox_Goods.ChildObjectId = (SELECT tmpMovement.GoodsId FROM tmpMovement LIMIT 1)
                          AND OL_GoodsPropertyBox_Goods.DescId        = zc_ObjectLink_GoodsPropertyBox_Goods()
                       )

      -- Результат
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

             -- сколько линий для ящиков - 1,2 или 3
           , (CASE WHEN Movement.GoodsTypeKindId_1 > 0 THEN 1 ELSE 0 END
            + CASE WHEN Movement.GoodsTypeKindId_2 > 0 THEN 1 ELSE 0 END
            + CASE WHEN Movement.GoodsTypeKindId_3 > 0 THEN 1 ELSE 0 END
             ) :: Integer AS Count_box

             -- Id - есть ли ШТ.
           , CASE WHEN Movement.GoodsTypeKindId_1 = zc_Enum_GoodsTypeKind_Sh()
                    OR Movement.GoodsTypeKindId_2 = zc_Enum_GoodsTypeKind_Sh()
                    OR Movement.GoodsTypeKindId_3 = zc_Enum_GoodsTypeKind_Sh()
                  THEN zc_Enum_GoodsTypeKind_Sh()
                  ELSE 0
             END AS GoodsTypeKindId_Sh 
             -- Id - есть ли НОМ.  
           , CASE WHEN Movement.GoodsTypeKindId_1 = zc_Enum_GoodsTypeKind_Nom()
                    OR Movement.GoodsTypeKindId_2 = zc_Enum_GoodsTypeKind_Nom()
                    OR Movement.GoodsTypeKindId_3 = zc_Enum_GoodsTypeKind_Nom()
                  THEN zc_Enum_GoodsTypeKind_Nom()
                  ELSE 0
             END AS GoodsTypeKindId_Nom
             -- Id - есть ли ВЕС
           , CASE WHEN Movement.GoodsTypeKindId_1 = zc_Enum_GoodsTypeKind_Ves()
                    OR Movement.GoodsTypeKindId_2 = zc_Enum_GoodsTypeKind_Ves()
                    OR Movement.GoodsTypeKindId_3 = zc_Enum_GoodsTypeKind_Ves()
                  THEN zc_Enum_GoodsTypeKind_Ves()
                  ELSE 0
             END AS GoodsTypeKindId_Ves

           , tmpGoods.WmsCode_Sh           -- Код ВМС - ШТ.
           , tmpGoods.WmsCode_Nom          -- Код ВМС - НОМ.
           , tmpGoods.WmsCode_Ves          -- Код ВМС - ВЕС

           , tmpGoods.WeightMin            -- минимальный вес 1шт. - !!!временно
           , tmpGoods.WeightMax            -- максимальный вес 1шт.- !!!временно

           , tmpGoods.WeightMin_Sh
           , tmpGoods.WeightMin_Nom
           , tmpGoods.WeightMin_Ves
           , tmpGoods.WeightMax_Sh
           , tmpGoods.WeightMax_Nom
           , tmpGoods.WeightMax_Ves

             -- 1-ая линия - Всегда этот цвет
           , Movement.GoodsTypeKindId_1                      -- выбранный тип для этого ЦВЕТА
           , Movement.BarCodeBoxId_1                         -- Id для Ш/К ящика
           , Object_BarCodeBox_1.ObjectCode AS BoxCode_1     -- код для Ш/К ящика
           , Object_BarCodeBox_1.ValueData  AS BoxBarCode_1  -- Ш/К ящика
        -- , WeightOnBoxTotal_1 TFloat     -- Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
        -- , CountOnBoxTotal_1  TFloat     -- шт итого накопительно (в незакрытом ящике) - НЕ информативно!
        -- , WeightTotal_1      TFloat     -- Вес итого накопительный (в закрытых ящиках) - информативно
        -- , CountTotal_1       TFloat     -- шт итого накопительный (в закрытых ящиках) - информативно
        -- , BoxTotal_1         TFloat     -- ящиков итого (закрытых) - информативно

           , tmpGoods.BoxId_1                  -- Id ящика
           , tmpGoods.BoxName_1                -- название ящика Е2 или Е3
           , tmpGoods.BoxWeight_1              -- Вес самого ящика
           , tmpGoods.WeightOnBox_1            -- вложенность - по Весу - !средняя!
           , tmpGoods.CountOnBox_1             -- Вложенность - шт (НЕ информативно!)

             -- 2-ая линия - Всегда этот цвет
           , Movement.GoodsTypeKindId_2                      -- выбранный тип для этого ЦВЕТА
           , Movement.BarCodeBoxId_2                         -- Id для Ш/К ящика
           , Object_BarCodeBox_2.ObjectCode AS BoxCode_2     -- код для Ш/К ящика
           , Object_BarCodeBox_2.ValueData  AS BoxBarCode_2  -- Ш/К ящика
        -- , WeightOnBoxTotal_2 TFloat     -- Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
        -- , CountOnBoxTotal_2  TFloat     -- шт итого накопительно (в незакрытом ящике) - НЕ информативно!
        -- , WeightTotal_2      TFloat     -- Вес итого накопительный (в закрытых ящиках) - информативно
        -- , CountTotal_2       TFloat     -- шт итого накопительный (в закрытых ящиках) - информативно
        -- , BoxTotal_2         TFloat     -- ящиков итого (закрытых) - информативно

           , tmpGoods.BoxId_2                  -- Id ящика
           , tmpGoods.BoxName_2                -- название ящика Е2 или Е3
           , tmpGoods.BoxWeight_2              -- Вес самого ящика
           , tmpGoods.WeightOnBox_2            -- вложенность - по Весу - !средняя!
           , tmpGoods.CountOnBox_2             -- Вложенность - шт (НЕ информативно!)

             -- 3-ья линия - Всегда этот цвет
           , Movement.GoodsTypeKindId_3                      -- выбранный тип для этого ЦВЕТА
           , Movement.BarCodeBoxId_3                         -- Id для Ш/К ящика
           , Object_BarCodeBox_3.ObjectCode AS BoxCode_3     -- код для Ш/К ящика
           , Object_BarCodeBox_3.ValueData  AS BoxBarCode_3  -- Ш/К ящика
        -- , WeightOnBoxTotal_3 TFloat     -- Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
        -- , CountOnBoxTotal_3  TFloat     -- шт итого накопительно (в незакрытом ящике) - НЕ информативно!
        -- , WeightTotal_3      TFloat     -- Вес итого накопительный (в закрытых ящиках) - информативно
        -- , CountTotal_3       TFloat     -- шт итого накопительный (в закрытых ящиках) - информативно
        -- , BoxTotal_3         TFloat     -- ящиков итого (закрытых) - информативно

           , tmpGoods.BoxId_3                  -- Id ящика
           , tmpGoods.BoxName_3                -- название ящика Е2 или Е3
           , tmpGoods.BoxWeight_3              -- Вес самого ящика
           , tmpGoods.WeightOnBox_3            -- вложенность - по Весу - !средняя!
           , tmpGoods.CountOnBox_3             -- Вложенность - шт (НЕ информативно!)

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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_ScaleLight_Movement (0, 1, CURRENT_TIMESTAMP, FALSE, NULL, zfCalc_UserAdmin())
-- SELECT * FROM gpGet_ScaleLight_Movement (0, 1, CURRENT_TIMESTAMP, FALSE, NULL, zfCalc_UserAdmin())
