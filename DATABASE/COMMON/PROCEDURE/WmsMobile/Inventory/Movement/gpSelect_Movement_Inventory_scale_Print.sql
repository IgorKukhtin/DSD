-- Function: gpSelect_Movement_Inventory_scale_Print - Инвентаризация (сканирование паспорта)

--DROP FUNCTION IF EXISTS gpSelect_Movement_Inventory_scale_Print (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Inventory_scale_Print (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Inventory_scale_Print(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inMovementId       Integer   , --
    IN inisTara           Boolean   , -- показывать или не тару - сейчас в группировке
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     OPEN Cursor1 FOR
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                          )

        -- Документы zc_Movement_WeighingProduction - здесь данные сканирование Паспорта - КПК
      , tmpMovement AS (SELECT
                             Movement.Id               AS Id
                           , CASE WHEN Movement.StatusId <> zc_Enum_Status_Complete() THEN '***'||Movement.InvNumber ELSE Movement.InvNumber END AS InvNumber
                           , Movement.OperDate         AS OperDate
                        FROM Movement
                             INNER JOIN tmpStatus ON Movement.StatusId = tmpStatus.StatusId
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
                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                          AND Movement.DescId = zc_Movement_WeighingProduction()
                          AND (Movement.Id = inMovementId OR inMovementId = 0)
                       )
        -- Элементы zc_Movement_WeighingProduction - здесь данные сканирование Паспорта - КПК
      , tmpMI AS (SELECT MovementItem.*
                  FROM tmpMovement AS Movement
                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased = FALSE
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
                                                         )
                      )
        -- данные в Партии - Паспорта
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

       -- данные по таре
     , tmpMI_Tara AS (WITH
                 tmp AS (SELECT MovementItem.MovementId
                              , MovementItem.Id
                              -- данные Партии - Паспорта
                              , MovementItem_passport.MovementId            AS MovementId_pas 
                              , MIFloat_MovementItemId.ValueData ::Integer  AS MovementItemId_pas
                       
                         from tmpMI AS MovementItem
                              -- Партия - Паспорт
                              LEFT JOIN tmpMIFloat AS MIFloat_MovementItemId
                                                   ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                  AND MIFloat_MovementItemId.DescId         = zc_MIFloat_MovementItemId()
                             -- данные в Партии - Паспорта
                             LEFT JOIN MovementItem AS MovementItem_passport ON MovementItem_passport.Id = MIFloat_MovementItemId.ValueData :: Integer
                         WHERE inisTara = TRUE
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
           , MovementItem.Id                 AS MovementItemId
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , Object_GoodsKind.Id                         AS GoodsKindId
           , Object_GoodsKind.ValueData                  AS GoodsKindName
           , Object_Measure.ValueData                    AS MeasureName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
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
           , MovementItem.Amount   
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() 
                  THEN CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 THEN ROUND (MovementItem.Amount / ObjectFloat_Weight.ValueData, 0) ELSE 0 END
                  ELSE 0
             END ::TFloat AS Amount_sh
             -- ИТОГО Вес тары - факт
           , MIFloat_WeightTare.ValueData AS WeightTare

             -- Поддон
           , Object_Box_1.ValueData                               AS BoxName_1
           , tmpMIFloat_CountTare1_passport.ValueData  :: Integer AS CountTare_1
           , (tmpMIFloat_WeightTare1_passport.ValueData * tmpMIFloat_CountTare1_passport.ValueData)           AS WeightTare_1
           
             -- Все Ящики
           , ( CASE WHEN COALESCE (Object_Box_2.ValueData,'') <> '' THEN Object_Box_2.ValueData ELSE '' END
             ||CASE WHEN COALESCE (Object_Box_3.ValueData,'') <> '' THEN chr(13)||Object_Box_3.ValueData ELSE '' END
             ||CASE WHEN COALESCE (Object_Box_4.ValueData,'') <> '' THEN chr(13)||Object_Box_4.ValueData ELSE '' END
             ||CASE WHEN COALESCE (Object_Box_5.ValueData,'') <> '' THEN chr(13)||Object_Box_5.ValueData ELSE '' END
             ) ::TVarChar   AS BoxName_2_5   --выводим названия всех ящиков

           , ( COALESCE (tmpMIFloat_CountTare2_passport.ValueData,0)
              +COALESCE (tmpMIFloat_CountTare3_passport.ValueData,0)
              +COALESCE (tmpMIFloat_CountTare4_passport.ValueData,0)
              +COALESCE (tmpMIFloat_CountTare5_passport.ValueData,0)) :: Integer AS CountTare_2_5    --ИТОГО Кол-во Ящиков
             
           , (COALESCE (tmpMIFloat_CountTare2_passport.ValueData, 0) * COALESCE (tmpMIFloat_WeightTare2_passport.ValueData, 0)
            + COALESCE (tmpMIFloat_CountTare3_passport.ValueData, 0) * COALESCE (tmpMIFloat_WeightTare3_passport.ValueData, 0)
            + COALESCE (tmpMIFloat_CountTare4_passport.ValueData, 0) * COALESCE (tmpMIFloat_WeightTare4_passport.ValueData, 0)
            + COALESCE (tmpMIFloat_CountTare5_passport.ValueData, 0) * COALESCE (tmpMIFloat_WeightTare5_passport.ValueData, 0)
             ) :: TFloat ::TFloat AS WeightTare_2_5    --ИТОГО вес ящиков

           , tmpMIFloat_CountPack.ValueData  :: Integer AS CountPack
           , (tmpMIFloat_CountPack.ValueData * tmpMIFloat_WeightPack.ValueData) ::TFloat AS WeightPack_calc

              -- Протокол
           , MIDate_Insert.ValueData    AS InsertDate
           , MIDate_Update.ValueData    AS UpdateDate

        FROM tmpMovement AS Movement
            INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

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

            -- ИТОГО Вес тары - факт
            LEFT JOIN tmpMIFloat AS MIFloat_WeightTare
                                 ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                AND MIFloat_WeightTare.DescId         = zc_MIFloat_WeightTare()

            -- Партия - Паспорт
            LEFT JOIN tmpMIFloat AS MIFloat_MovementItemId
                                 ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                AND MIFloat_MovementItemId.DescId         = zc_MIFloat_MovementItemId()

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
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_CountPack
                                         ON tmpMIFloat_CountPack.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_CountPack.DescId         = zc_MIFloat_CountPack()

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
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_WeightPack
                                         ON tmpMIFloat_WeightPack.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_WeightPack.DescId         = zc_MIFloat_WeightPack()
 
           -- № паспорта
           LEFT JOIN tmpMIFloat_passport AS tmpMIFloat_PartionNum_passport
                                         ON tmpMIFloat_PartionNum_passport.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                        AND tmpMIFloat_PartionNum_passport.DescId         = zc_MIFloat_PartionNum()

           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                 ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight() 

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
      UNION
         SELECT Movement.Id                     AS Id
           , Movement.InvNumber              AS InvNumber
           , Movement.OperDate               AS OperDate
           , MovementItem.Id                 AS MovementItemId
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , 0                                           AS GoodsKindId
           , '' ::TVarChar                               AS GoodsKindName
           , Object_Measure.ValueData                    AS MeasureName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             -- партия - дата
           , NULL ::TDateTime        AS PartionGoodsDate
             -- Ш/К - паспорт
           , (zfFormat_BarCode (zc_BarCodePref_MI(), tmpMI_Tara.MovementItemId_pas :: Integer)
           || zfCalc_SummBarCode (zfFormat_BarCode (zc_BarCodePref_MI(), tmpMI_Tara.MovementItemId_pas :: Integer)) :: TVarChar
             ) :: TVarChar AS MovementItemId_passport

             -- № паспорта
           , NULL :: Integer AS PartionNum

             -- Ячейка хранения
           , 0                    AS PartionCellId
           , '' ::TVarChar        AS PartionCellName

             -- Вес нетто
           , 0 ::TFloat AS Amount   
           , tmpMI_Tara.CountTare  ::TFloat AS Amount_sh
             -- ИТОГО Вес тары - факт
           , 0 ::TFloat AS WeightTare

             -- Поддон
           , '' ::TVarChar   AS BoxName_1
           , 0  :: Integer   AS CountTare_1
           , 0  ::TFloat     AS WeightTare_1

             -- Все Ящики
           , '' ::TVarChar   AS BoxName_2_5       --выводим названия всех ящиков
           , 0  ::Integer    AS CountTare_2_5     --ИТОГО Кол-во Ящиков
           , 0  ::TFloat     AS WeightTare_2_5    --ИТОГО вес ящиков

           , 0  ::Integer AS CountPack
           , 0  ::TFloat  AS WeightPack_calc
                           
              -- Протокол
          -- , MIDate_Insert.ValueData    AS InsertDate
          --, MIDate_Update.ValueData    AS UpdateDate
                
             -- Протокол       
           , NULL ::TDateTime    AS InsertDate
           , NULL ::TDateTime    AS UpdateDate

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
            */
 
           LEFT JOIN ObjectFloat AS OF_Weight
                                 ON OF_Weight.ObjectId = Object_Goods.Id
                                AND OF_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           LEFT JOIN ObjectLink AS OL_Measure
                                ON OL_Measure.ObjectId = Object_Goods.Id
                               AND OL_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Measure.ChildObjectId
        WHERE inisTara = TRUE

                    
        --ORDER BY MIDate_Insert.ValueData 
          ;
     RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.03.24                                        *
*/

-- тест
-- select * from gpSelect_Movement_Inventory_scale_Print (inStartDate := ('02.03.2024')::TDateTime , inEndDate := ('28.03.2025')::TDateTime , inMovementId := 0 ,  inSession := '9457');
-- FETCH ALL "<unnamed portal 6>";