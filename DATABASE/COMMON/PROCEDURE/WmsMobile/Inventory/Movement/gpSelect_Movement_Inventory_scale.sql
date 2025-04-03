-- Function: gpSelect_Movement_Inventory_scale - Инвентаризация (сканирование паспорта)

DROP FUNCTION IF EXISTS gpSelect_Movement_Inventory_scale (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Inventory_scale(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , MovementItemId Integer
             , MovementId_pas Integer, MovementItemId_pas Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , MeasureId Integer, MeasureName TVarChar
               -- партия - дата
             , PartionGoodsDate TDateTime
               -- Ш/К - паспорт
             , MovementItemId_passport TVarChar
               -- № паспорта
             , PartionNum        Integer
               -- Ячейка хранения
             , PartionCellId Integer, PartionCellName TVarChar

               -- Вес нетто
             , Amount            TFloat
               -- Шт
             , Amount_sh         TFloat
             
             , RealWeight        TFloat

               -- ИТОГО Вес тары - факт
             , WeightTare    TFloat

               -- Поддон
             , BoxId_1           Integer
             , BoxName_1         TVarChar
             , CountTare_1       Integer
             , WeightTare_1      TFloat
               -- Ящик
             , BoxId_2           Integer
             , BoxName_2         TVarChar
             , CountTare_2       Integer
             , WeightTare_2      TFloat
               -- Ящик
             , BoxId_3           Integer
             , BoxName_3         TVarChar
             , CountTare_3       Integer
             , WeightTare_3      TFloat
               -- Ящик
             , BoxId_4           Integer
             , BoxName_4         TVarChar
             , CountTare_4       Integer
             , WeightTare_4      TFloat
               -- Ящик
             , BoxId_5           Integer
             , BoxName_5         TVarChar
             , CountTare_5       Integer
             , WeightTare_5      TFloat

               -- ИТОГО Кол-во Ящиков
             , CountTare_calc    Integer
               -- ИТОГО Вес всех Ящиков - расчет
             , WeightTare_calc   TFloat
               --упаковка
             , CountPack         Integer
             , WeightPack        TFloat
             , WeightPack_calc   TFloat

               --
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                          )

        -- Документы zc_Movement_WeighingProduction - здесь данные сканирование Паспорта - КПК
      , tmpMovement AS (SELECT
                             Movement.Id               AS Id
                           , Movement.InvNumber        AS InvNumber
                           , Movement.OperDate         AS OperDate
                           , Object_Status.ObjectCode  AS StatusCode
                           , Object_Status.ValueData   AS StatusName
                        FROM tmpStatus
                             INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                AND Movement.DescId = zc_Movement_WeighingProduction()
                                                AND Movement.StatusId = tmpStatus.StatusId
                             -- Этот склад
                             INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                                      AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                                      AND MLO_From.ObjectId   = zc_Unit_RK()
                             -- Этот склад
                             INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                                    AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                                    AND MLO_To.ObjectId   = zc_Unit_RK()
                             -- Инвентаризация
                             INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                      ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                     AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
                                                     AND MovementFloat_MovementDesc.ValueData  = zc_Movement_Inventory() :: TFloat
                             -- Автоматический
                             INNER JOIN MovementBoolean AS MB_isAuto ON MB_isAuto.MovementId = Movement.Id
                                                                    AND MB_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                                    -- Автоматический, значит с КПК
                                                                    AND MB_isAuto.ValueData  = TRUE
                             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                       )
        -- Элементы zc_Movement_WeighingProduction - здесь данные сканирование Паспорта - КПК
      , tmpMI AS (SELECT MovementItem.*
                  FROM tmpMovement AS Movement
                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                 )
      , tmpMIDate AS (SELECT *
                      FROM MovementItemDate
                      WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        AND MovementItemDate.DescId IN (zc_MIDate_PartionGoods()
                                                      , zc_MIDate_Insert()
                                                      , zc_MIDate_Update()
                                                       )
                     )
      , tmpMIFloat AS (SELECT *
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                         AND MovementItemFloat.DescId IN (zc_MIFloat_MovementItemId()
                                                        , zc_MIFloat_WeightTare() 
                                                        , zc_MIFloat_RealWeight()
                                                         )
                      )
        -- данные в Партии Паспорта
      , tmpMIFloat_passport AS (SELECT *
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIFloat.ValueData :: Integer FROM tmpMIFloat WHERE tmpMIFloat.DescId IN (zc_MIFloat_MovementItemId()))
                                  AND MovementItemFloat.DescId IN (zc_MIFloat_CountTare1()
                                                                 , zc_MIFloat_CountTare2()
                                                                 , zc_MIFloat_CountTare3()
                                                                 , zc_MIFloat_CountTare4()
                                                                 , zc_MIFloat_CountTare5()
                                                                 , zc_MIFloat_WeightTare1()
                                                                 , zc_MIFloat_WeightTare2()
                                                                 , zc_MIFloat_WeightTare3()
                                                                 , zc_MIFloat_WeightTare4()
                                                                 , zc_MIFloat_WeightTare5()
                                                                 , zc_MIFloat_PartionNum()
                                                                 , zc_MIFloat_CountPack()
                                                                 , zc_MIFloat_WeightPack()
                                                                  )
                               )
        --
      , tmpMILO AS (SELECT *
                    FROM MovementItemLinkObject
                    WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                      AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()
                                                          , zc_MILinkObject_Insert()
                                                          , zc_MILinkObject_Update()
                                                           )
                   )
        -- данные в Партии - Паспорта
      , tmpMILO_passport AS (SELECT *
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIFloat.ValueData :: Integer FROM tmpMIFloat WHERE tmpMIFloat.DescId IN (zc_MIFloat_MovementItemId()))
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Box1()
                                                                   , zc_MILinkObject_Box2()
                                                                   , zc_MILinkObject_Box3()
                                                                   , zc_MILinkObject_Box4()
                                                                   , zc_MILinkObject_Box5()
                                                                   , zc_MILinkObject_PartionCell()
                                                                    )
                            )
     , tmpGoodsByGoodsKind AS (SELECT MovementItem.Id AS MovementItemId
                                    , COALESCE (ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.ValueData, 0) AS WeightPackageSticker
                               FROM tmpMI AS MovementItem
                                    INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                          ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = MovementItem.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                          ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = MILinkObject_GoodsKind.ObjectId
                                    LEFT JOIN ObjectFloat AS ObjectFloat_GoodsByGoodsKind_WeightPackageSticker
                                                          ON ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.DescId    = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker()
                              )

       -- данные по таре
     , tmpMI_Tara AS (WITH
                 tmp AS (SELECT MovementItem.MovementId
                              , MovementItem.Id
                              -- партия - дата
                              , MIDate_PartionGoods.ValueData               AS PartionGoodsDate
                              -- № паспорта
                              , tmpMIFloat_PartionNum_passport.ValueData :: Integer AS PartionNum 
                              -- данные Партии - Паспорта
                              , MovementItem_passport.MovementId            AS MovementId_pas 
                              , MIFloat_MovementItemId.ValueData ::Integer  AS MovementItemId_pas
                                -- Ячейка хранения
                              , Object_PartionCell.Id                    AS PartionCellId
                              , Object_PartionCell.ValueData ::TVarChar  AS PartionCellName                         
                         from tmpMI AS MovementItem
                              -- партия - Дата
                              LEFT JOIN tmpMIDate AS MIDate_PartionGoods
                                                  ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                 AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                                                 --не нужно
                                                 AND 1=0
                              -- Партия - Паспорт
                              LEFT JOIN tmpMIFloat AS MIFloat_MovementItemId
                                                   ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                  AND MIFloat_MovementItemId.DescId         = zc_MIFloat_MovementItemId()
                             -- данные в Партии - Паспорта
                             LEFT JOIN MovementItem AS MovementItem_passport ON MovementItem_passport.Id = MIFloat_MovementItemId.ValueData :: Integer

                             -- № паспорта
                             LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_PartionNum_passport
                                                           ON tmpMIFloat_PartionNum_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                                          AND tmpMIFloat_PartionNum_passport.DescId         = zc_MIFloat_PartionNum() 
                                                          --не нужно
                                                          AND 1=0
                             -- Ячейка хранения
                             LEFT JOIN tmpMILO_passport AS tmpMILO_PartionCell_passport
                                                        ON tmpMILO_PartionCell_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                                       AND tmpMILO_PartionCell_passport.DescId         = zc_MILinkObject_PartionCell()
                                                       --не нужно
                                                       AND 1=0
                             LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = tmpMILO_PartionCell_passport.ObjectId
                         )

               , tmp2 AS (
                          SELECT tmp.*
                               , tmpMILO_Box_passport.ObjectId AS BoxId
                               , tmpMIFloat_CountTare_passport.ValueData AS CountTare
                          FROM tmp
                                     -- данные в Партии - Паспорта
                                     INNER JOIN tmpMILO_passport AS tmpMILO_Box_passport
                                                                ON tmpMILO_Box_passport.MovementItemId = tmp.MovementItemId_pas
                                                               AND tmpMILO_Box_passport.DescId         = zc_MILinkObject_Box1()
                                                               AND COALESCE (tmpMILO_Box_passport.ObjectId,0) <> 0
                                     -- данные в Партии - Паспорта
                                     LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountTare_passport
                                                                   ON tmpMIFloat_CountTare_passport.MovementItemId = tmp.MovementItemId_pas
                                                                  AND tmpMIFloat_CountTare_passport.DescId         = zc_MIFloat_CountTare1()
                          UNION
                          SELECT tmp.*
                               , tmpMILO_Box_passport.ObjectId AS BoxId
                               , tmpMIFloat_CountTare_passport.ValueData AS CountTare
                          FROM tmp
                                     -- данные в Партии - Паспорта
                                     INNER JOIN tmpMILO_passport AS tmpMILO_Box_passport
                                                                ON tmpMILO_Box_passport.MovementItemId = tmp.MovementItemId_pas
                                                               AND tmpMILO_Box_passport.DescId         = zc_MILinkObject_Box2()
                                                               AND COALESCE (tmpMILO_Box_passport.ObjectId,0) <> 0
                                     -- данные в Партии - Паспорта
                                     LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountTare_passport
                                                                   ON tmpMIFloat_CountTare_passport.MovementItemId = tmp.MovementItemId_pas
                                                                  AND tmpMIFloat_CountTare_passport.DescId         = zc_MIFloat_CountTare2()
                          UNION
                          SELECT tmp.*
                               , tmpMILO_Box_passport.ObjectId AS BoxId
                               , tmpMIFloat_CountTare_passport.ValueData AS CountTare
                          FROM tmp
                                     -- данные в Партии - Паспорта
                                     INNER JOIN tmpMILO_passport AS tmpMILO_Box_passport
                                                                 ON tmpMILO_Box_passport.MovementItemId = tmp.MovementItemId_pas
                                                                AND tmpMILO_Box_passport.DescId         = zc_MILinkObject_Box3()
                                                                AND COALESCE (tmpMILO_Box_passport.ObjectId,0) <> 0
                                     -- данные в Партии - Паспорта
                                     LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountTare_passport
                                                                   ON tmpMIFloat_CountTare_passport.MovementItemId = tmp.MovementItemId_pas
                                                                  AND tmpMIFloat_CountTare_passport.DescId         = zc_MIFloat_CountTare3()
                          UNION
                          SELECT tmp.*
                               , tmpMILO_Box_passport.ObjectId AS BoxId
                               , tmpMIFloat_CountTare_passport.ValueData AS CountTare
                          FROM tmp
                                     -- данные в Партии - Паспорта
                                     INNER JOIN tmpMILO_passport AS tmpMILO_Box_passport
                                                                 ON tmpMILO_Box_passport.MovementItemId = tmp.MovementItemId_pas
                                                                AND tmpMILO_Box_passport.DescId         = zc_MILinkObject_Box4()
                                                                AND COALESCE (tmpMILO_Box_passport.ObjectId,0) <> 0
                                     -- данные в Партии - Паспорта
                                     LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountTare_passport
                                                                   ON tmpMIFloat_CountTare_passport.MovementItemId = tmp.MovementItemId_pas
                                                                  AND tmpMIFloat_CountTare_passport.DescId         = zc_MIFloat_CountTare4()
                          UNION
                          SELECT tmp.*
                               , tmpMILO_Box_passport.ObjectId AS BoxId
                               , tmpMIFloat_CountTare_passport.ValueData AS CountTare
                          FROM tmp
                                     -- данные в Партии - Паспорта
                                     INNER JOIN tmpMILO_passport AS tmpMILO_Box_passport
                                                                ON tmpMILO_Box_passport.MovementItemId = tmp.MovementItemId_pas
                                                               AND tmpMILO_Box_passport.DescId         = zc_MILinkObject_Box5()
                                                               AND COALESCE (tmpMILO_Box_passport.ObjectId,0) <> 0
                                     -- данные в Партии - Паспорта
                                     LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountTare_passport
                                                                   ON tmpMIFloat_CountTare_passport.MovementItemId = tmp.MovementItemId_pas
                                                                  AND tmpMIFloat_CountTare_passport.DescId         = zc_MIFloat_CountTare5()
                          )
                 SELECT tmp2.*
                      , ObjectLink_Goods.ChildObjectId AS GoodsId
                 FROM tmp2
                      LEFT JOIN ObjectLink AS ObjectLink_Goods
                                           ON ObjectLink_Goods.ObjectId = tmp2.BoxId
                                          AND ObjectLink_Goods.DescId = zc_ObjectLink_Box_Goods()
                      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId
                 )

        -- Результат
        SELECT
             Movement.Id                     AS Id
           , Movement.InvNumber              AS InvNumber
           , Movement.OperDate               AS OperDate
           , Movement.StatusCode             AS StatusCode
           , Movement.StatusName             AS StatusName

           , MovementItem.Id                             AS MovementItemId
            -- данные Партии - Паспорта
           , MovementItem_passport.MovementId            AS MovementId_pas
           , MIFloat_MovementItemId.ValueData ::Integer  AS MovementItemId_pas

           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsKind.Id                         AS GoodsKindId
           , Object_GoodsKind.ValueData                  AS GoodsKindName
           , Object_Measure.Id                           AS MeasureId
           , Object_Measure.ValueData                    AS MeasureName

             -- партия - дата
           , MIDate_PartionGoods.ValueData        AS PartionGoodsDate

             -- Ш/К - паспорт
           , (zfFormat_BarCode (zc_BarCodePref_MI(), MIFloat_MovementItemId.ValueData :: Integer)
           || zfCalc_SummBarCode (zfFormat_BarCode (zc_BarCodePref_MI(), MIFloat_MovementItemId.ValueData :: Integer)) :: TVarChar
             ) :: TVarChar AS MovementItemId_passport

             -- № паспорта
           , tmpMIFloat_PartionNum_passport.ValueData :: Integer AS PartionNum

             -- Ячейка хранения
           , Object_PartionCell.Id                    AS PartionCellId
           , Object_PartionCell.ValueData ::TVarChar  AS PartionCellName

             -- Вес нетто
           , CASE WHEN OL_Measure.ChildObjectId = zc_Measure_Sh()
                       -- переводим из ШТ в ВЕС
                       THEN MovementItem.Amount * (COALESCE (OF_Weight.ValueData, 0) + COALESCE (tmpGoodsByGoodsKind.WeightPackageSticker, 0))
                  ELSE MovementItem.Amount
             END :: TFloat AS Amount

             -- Шт
           , CASE WHEN OL_Measure.ChildObjectId = zc_Measure_Sh()
                       THEN MovementItem.Amount
                  ELSE 0
             END :: TFloat AS Amount_sh

           --
           , MIFloat_RealWeight.ValueData              ::TFloat   AS RealWeight
           
             -- ИТОГО Вес тары - факт
           , MIFloat_WeightTare.ValueData AS WeightTare

             -- Поддон
           , Object_Box_1.Id                                      AS BoxId_1
           , Object_Box_1.ValueData                               AS BoxName_1
           , tmpMIFloat_CountTare1_passport.ValueData  :: Integer AS CountTare_1
           , tmpMIFloat_WeightTare1_passport.ValueData            AS WeightTare_1
             -- Ящик
           , Object_Box_2.Id                                      AS BoxId_2
           , Object_Box_2.ValueData                               AS BoxName_2
           , tmpMIFloat_CountTare2_passport.ValueData  :: Integer AS CountTare_2
           , tmpMIFloat_WeightTare2_passport.ValueData            AS WeightTare_2
             -- Ящик
           , Object_Box_3.Id                                      AS BoxId_3
           , Object_Box_3.ValueData                               AS BoxName_3
           , tmpMIFloat_CountTare3_passport.ValueData  :: Integer AS CountTare_3
           , tmpMIFloat_WeightTare3_passport.ValueData            AS WeightTare_3
             -- Ящик
           , Object_Box_4.Id                                      AS BoxId_4
           , Object_Box_4.ValueData                               AS BoxName_4
           , tmpMIFloat_CountTare4_passport.ValueData  :: Integer AS CountTare_4
           , tmpMIFloat_WeightTare4_passport.ValueData            AS WeightTare_4
             -- Ящик
           , Object_Box_5.Id                                      AS BoxId_5
           , Object_Box_5.ValueData                               AS BoxName_5
           , tmpMIFloat_CountTare5_passport.ValueData  :: Integer AS CountTare_5
           , tmpMIFloat_WeightTare5_passport.ValueData            AS WeightTare_5

             -- ИТОГО Кол-во Ящиков
           , (COALESCE (tmpMIFloat_CountTare2_passport.ValueData, 0)
            + COALESCE (tmpMIFloat_CountTare3_passport.ValueData, 0)
            + COALESCE (tmpMIFloat_CountTare4_passport.ValueData, 0)
            + COALESCE (tmpMIFloat_CountTare5_passport.ValueData, 0)
             ) :: Integer AS CountTare_calc
             -- ИТОГО Вес всех Ящиков - расчет
           , (COALESCE (tmpMIFloat_CountTare2_passport.ValueData, 0) * COALESCE (tmpMIFloat_WeightTare2_passport.ValueData, 0)
            + COALESCE (tmpMIFloat_CountTare3_passport.ValueData, 0) * COALESCE (tmpMIFloat_WeightTare3_passport.ValueData, 0)
            + COALESCE (tmpMIFloat_CountTare4_passport.ValueData, 0) * COALESCE (tmpMIFloat_WeightTare4_passport.ValueData, 0)
            + COALESCE (tmpMIFloat_CountTare5_passport.ValueData, 0) * COALESCE (tmpMIFloat_WeightTare5_passport.ValueData, 0)
             ) :: TFloat AS WeightTare_calc


           , tmpMIFloat_CountPack.ValueData   ::Integer AS CountPack
           , tmpMIFloat_WeightPack.ValueData  ::TFloat  AS WeightPack
           , (tmpMIFloat_CountPack.ValueData * tmpMIFloat_WeightPack.ValueData) ::TFloat AS WeightPack_calc

             -- Протокол
           , Object_Insert.ValueData    AS InsertName
           , Object_Update.ValueData    AS UpdateName
           , MIDate_Insert.ValueData    AS InsertDate
           , MIDate_Update.ValueData    AS UpdateDate

           , MovementItem.isErased      AS isErased

        FROM tmpMovement AS Movement
            INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

            LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.MovementItemId = MovementItem.Id

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN tmpMILO AS MILO_GoodsKind
                              ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                             AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId

            -- партия - Дата
            LEFT JOIN tmpMIDate AS MIDate_PartionGoods
                                ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                               AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()

            -- Протокол
            LEFT JOIN tmpMIDate AS MIDate_Insert
                                ON MIDate_Insert.MovementItemId = MovementItem.Id
                               AND MIDate_Insert.DescId         = zc_MIDate_Insert()
            LEFT JOIN tmpMIDate AS MIDate_Update
                                ON MIDate_Update.MovementItemId = MovementItem.Id
                               AND MIDate_Update.DescId         = zc_MIDate_Update()

            -- Протокол
            LEFT JOIN tmpMILO AS MILO_Insert
                              ON MILO_Insert.MovementItemId = MovementItem.Id
                             AND MILO_Insert.DescId         = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

            -- Протокол
            LEFT JOIN tmpMILO AS MILO_Update
                              ON MILO_Update.MovementItemId = MovementItem.Id
                             AND MILO_Update.DescId         = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

            -- ИТОГО Вес тары - факт
            LEFT JOIN tmpMIFloat AS MIFloat_WeightTare
                                 ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                AND MIFloat_WeightTare.DescId         = zc_MIFloat_WeightTare()

            LEFT JOIN tmpMIFloat AS MIFloat_RealWeight
                                 ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

            -- Партия - Паспорт
            LEFT JOIN tmpMIFloat AS MIFloat_MovementItemId
                                 ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                AND MIFloat_MovementItemId.DescId         = zc_MIFloat_MovementItemId()

           -- данные в Партии - Паспорта
           LEFT JOIN MovementItem AS MovementItem_passport ON MovementItem_passport.Id = MIFloat_MovementItemId.ValueData :: Integer
           -- LEFT JOIN Movement AS Movement_passport ON Movement_passport.Id = MovementItem_passport.MovementId

           -- данные в Партии - Паспорта
           LEFT JOIN tmpMILO_passport AS tmpMILO_Box1_passport
                                      ON tmpMILO_Box1_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                     AND tmpMILO_Box1_passport.DescId         = zc_MILinkObject_Box1()
           LEFT JOIN Object AS Object_Box_1 ON Object_Box_1.Id = tmpMILO_Box1_passport.ObjectId

           LEFT JOIN tmpMILO_passport AS tmpMILO_Box2_passport
                                      ON tmpMILO_Box2_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                     AND tmpMILO_Box2_passport.DescId         = zc_MILinkObject_Box2()
           LEFT JOIN Object AS Object_Box_2 ON Object_Box_2.Id = tmpMILO_Box2_passport.ObjectId

           LEFT JOIN tmpMILO_passport AS tmpMILO_Box3_passport
                                      ON tmpMILO_Box3_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                     AND tmpMILO_Box3_passport.DescId         = zc_MILinkObject_Box3()
           LEFT JOIN Object AS Object_Box_3 ON Object_Box_3.Id = tmpMILO_Box3_passport.ObjectId

           LEFT JOIN tmpMILO_passport AS tmpMILO_Box4_passport
                                      ON tmpMILO_Box4_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                     AND tmpMILO_Box4_passport.DescId         = zc_MILinkObject_Box4()
           LEFT JOIN Object AS Object_Box_4 ON Object_Box_4.Id = tmpMILO_Box4_passport.ObjectId

           LEFT JOIN tmpMILO_passport AS tmpMILO_Box5_passport
                                      ON tmpMILO_Box5_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                     AND tmpMILO_Box5_passport.DescId         = zc_MILinkObject_Box5()
           LEFT JOIN Object AS Object_Box_5 ON Object_Box_5.Id = tmpMILO_Box5_passport.ObjectId

           -- Ячейка хранения
           LEFT JOIN tmpMILO_passport AS tmpMILO_PartionCell_passport
                                      ON tmpMILO_PartionCell_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                     AND tmpMILO_PartionCell_passport.DescId         = zc_MILinkObject_PartionCell()
           LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = tmpMILO_PartionCell_passport.ObjectId

           -- данные в Партии - Паспорта
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountTare1_passport
                                         ON tmpMIFloat_CountTare1_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_CountTare1_passport.DescId         = zc_MIFloat_CountTare1()
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountTare2_passport
                                         ON tmpMIFloat_CountTare2_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_CountTare2_passport.DescId         = zc_MIFloat_CountTare2()
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountTare3_passport
                                         ON tmpMIFloat_CountTare3_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_CountTare3_passport.DescId         = zc_MIFloat_CountTare3()
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountTare4_passport
                                         ON tmpMIFloat_CountTare4_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_CountTare4_passport.DescId         = zc_MIFloat_CountTare4()
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountTare5_passport
                                         ON tmpMIFloat_CountTare5_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_CountTare5_passport.DescId         = zc_MIFloat_CountTare5()

           -- данные в Партии - Паспорта
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_WeightTare1_passport
                                         ON tmpMIFloat_WeightTare1_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_WeightTare1_passport.DescId         = zc_MIFloat_WeightTare1()
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_WeightTare2_passport
                                         ON tmpMIFloat_WeightTare2_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_WeightTare2_passport.DescId         = zc_MIFloat_WeightTare2()
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_WeightTare3_passport
                                         ON tmpMIFloat_WeightTare3_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_WeightTare3_passport.DescId         = zc_MIFloat_WeightTare3()
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_WeightTare4_passport
                                         ON tmpMIFloat_WeightTare4_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_WeightTare4_passport.DescId         = zc_MIFloat_WeightTare4()
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_WeightTare5_passport
                                         ON tmpMIFloat_WeightTare5_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_WeightTare5_passport.DescId         = zc_MIFloat_WeightTare5()

           -- упаковка
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountPack
                                         ON tmpMIFloat_CountPack.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_CountPack.DescId         = zc_MIFloat_CountPack()
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_WeightPack
                                         ON tmpMIFloat_WeightPack.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_WeightPack.DescId         = zc_MIFloat_WeightPack()

           -- № паспорта
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_PartionNum_passport
                                         ON tmpMIFloat_PartionNum_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_PartionNum_passport.DescId         = zc_MIFloat_PartionNum()
           --
           LEFT JOIN ObjectFloat AS OF_Weight
                                 ON OF_Weight.ObjectId = Object_Goods.Id
                                AND OF_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           LEFT JOIN ObjectLink AS OL_Measure
                                ON OL_Measure.ObjectId = Object_Goods.Id
                               AND OL_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Measure.ChildObjectId
       UNION
        SELECT
             Movement.Id                     AS Id
           , Movement.InvNumber              AS InvNumber
           , Movement.OperDate               AS OperDate
           , Movement.StatusCode             AS StatusCode
           , Movement.StatusName             AS StatusName

           , MovementItem.Id                             AS MovementItemId
            -- данные Партии - Паспорта
           , tmpMI_Tara.MovementId_pas
           , tmpMI_Tara.MovementItemId_pas

           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , 0                                           AS GoodsKindId
           , '' ::TVarChar                               AS GoodsKindName
           , Object_Measure.Id                           AS MeasureId
           , Object_Measure.ValueData                    AS MeasureName

             -- партия - дата
           , tmpMI_Tara.PartionGoodsDate        AS PartionGoodsDate

             -- Ш/К - паспорт
           , (zfFormat_BarCode (zc_BarCodePref_MI(), tmpMI_Tara.MovementItemId_pas)
           || zfCalc_SummBarCode (zfFormat_BarCode (zc_BarCodePref_MI(), tmpMI_Tara.MovementItemId_pas)) :: TVarChar
             ) :: TVarChar AS MovementItemId_passport

             -- № паспорта
           , tmpMI_Tara.PartionNum :: Integer AS PartionNum

             -- Ячейка хранения
           , tmpMI_Tara.PartionCellId
           , tmpMI_Tara.PartionCellName ::TVarChar  AS PartionCellName

             -- Вес нетто
           , 0 :: TFloat AS Amount

             -- Шт
           , tmpMI_Tara.CountTare :: TFloat AS Amount_sh

           --
           , 0 ::TFloat   AS RealWeight
           
             -- ИТОГО Вес тары - факт
           , 0 ::TFloat AS WeightTare

             -- Поддон
           , 0               AS BoxId_1
           , ''::TVarChar   AS BoxName_1
           , 0  :: Integer   AS CountTare_1
           , 0  ::TFloat             AS WeightTare_1
             -- Ящик
           , 0                AS BoxId_2
           , ''::TVarChar    AS BoxName_2
           , 0  :: Integer    AS CountTare_2
           , 0  ::TFloat              AS WeightTare_2
             -- Ящик
           , 0                AS BoxId_3
           , ''::TVarChar    AS BoxName_3
           , 0  :: Integer    AS CountTare_3
           , 0  ::TFloat              AS WeightTare_3
             -- Ящик
           , 0                AS BoxId_4
           , ''::TVarChar    AS BoxName_4
           , 0  :: Integer    AS CountTare_4
           , 0  ::TFloat              AS WeightTare_4
             -- Ящик
           , 0                AS BoxId_5
           , '' ::TVarChar    AS BoxName_5
           , 0  :: Integer    AS CountTare_5
           , 0  ::TFloat              AS WeightTare_5

             -- ИТОГО Кол-во Ящиков
           , 0 :: Integer AS CountTare_calc
             -- ИТОГО Вес всех Ящиков - расчет
           , 0 :: TFloat AS WeightTare_calc


           , 0  ::Integer AS CountPack
           , 0  ::TFloat  AS WeightPack
           , 0  ::TFloat AS WeightPack_calc

             -- Протокол       
           , '' ::TVarChar       AS InsertName
           , '' ::TVarChar       AS UpdateName
           , NULL ::TDateTime    AS InsertDate
           , NULL ::TDateTime    AS UpdateDate

           , MovementItem.isErased      AS isErased

        FROM tmpMovement AS Movement
            INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

            LEFT JOIN tmpMI_Tara ON tmpMI_Tara.Id = MovementItem.Id

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Tara.GoodsId
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            -- Протокол
            /*LEFT JOIN tmpMIDate AS MIDate_Insert
                                ON MIDate_Insert.MovementItemId = MovementItem.Id
                               AND MIDate_Insert.DescId         = zc_MIDate_Insert()
            LEFT JOIN tmpMIDate AS MIDate_Update
                                ON MIDate_Update.MovementItemId = MovementItem.Id
                               AND MIDate_Update.DescId         = zc_MIDate_Update()

            -- Протокол
            LEFT JOIN tmpMILO AS MILO_Insert
                              ON MILO_Insert.MovementItemId = MovementItem.Id
                             AND MILO_Insert.DescId         = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

            -- Протокол
            LEFT JOIN tmpMILO AS MILO_Update
                              ON MILO_Update.MovementItemId = MovementItem.Id
                             AND MILO_Update.DescId         = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId
            */
 
           LEFT JOIN ObjectFloat AS OF_Weight
                                 ON OF_Weight.ObjectId = Object_Goods.Id
                                AND OF_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           LEFT JOIN ObjectLink AS OL_Measure
                                ON OL_Measure.ObjectId = Object_Goods.Id
                               AND OL_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Measure.ChildObjectId

          ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.02.24                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Inventory_scale (inStartDate:= '01.02.2025', inEndDate:= '28.02.2025', inIsErased := 'True', inSession := zfCalc_UserAdmin())
