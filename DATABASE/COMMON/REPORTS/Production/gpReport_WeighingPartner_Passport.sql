-- Function: gpReport_WeighingPartner_Passport - Паспорт ГП (взвешивания)21:50 24.02.2025

DROP FUNCTION IF EXISTS gpReport_WeighingPartner_Passport (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_WeighingPartner_Passport(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, ItemName TVarChar, ItemName_inf TVarChar
             , InvNumber TVarChar, OperDate TDateTime, StatusCode Integer
             , MovementItemId Integer, BarCode TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar, GoodsKindName TVarChar
             , PartionGoodsDate TDateTime
             , UpdateDate TDateTime, InsertDate TDateTime, InsertName TVarChar
             , PartionCellName TVarChar
             , PartionNum      TFloat
             , Amount          TFloat
             , Amount_sh       TFloat
               -- если Инвентаризация - Подготовка = здесь сохранено в ШТ
             , Amount_sh_inv   TFloat

             , RealWeight      TFloat
             , CountTare1      TFloat
             , CountTare2      TFloat
             , CountTare3      TFloat
             , CountTare4      TFloat
             , CountTare5      TFloat
             , CountTare6      TFloat
             , CountTare7      TFloat
             , CountTare8      TFloat
             , CountTare9      TFloat
             , CountTare10     TFloat

             , WeightTare1     TFloat
             , WeightTare2     TFloat
             , WeightTare3     TFloat
             , WeightTare4     TFloat
             , WeightTare5     TFloat
             , WeightTare6     TFloat
             , WeightTare7     TFloat
             , WeightTare8     TFloat
             , WeightTare9     TFloat
             , WeightTare10    TFloat

             , BoxWeight1      TFloat
             , BoxWeight2      TFloat
             , BoxWeight3      TFloat
             , BoxWeight4      TFloat
             , BoxWeight5      TFloat
             , BoxWeight6      TFloat
             , BoxWeight7      TFloat
             , BoxWeight8      TFloat
             , BoxWeight9      TFloat
             , BoxWeight10     TFloat

             , BoxCountTotal   TFloat
             , BoxWeightTotal  TFloat

               --упаковка
             , CountPack       Integer
             , WeightPack      TFloat
             , WeightPack_calc TFloat

             , BoxName_1   TVarChar
             , BoxName_2   TVarChar
             , BoxName_3   TVarChar
             , BoxName_4   TVarChar
             , BoxName_5   TVarChar
             , BoxName_6   TVarChar
             , BoxName_7   TVarChar
             , BoxName_8   TVarChar
             , BoxName_9   TVarChar
             , BoxName_10  TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH
       tmpMovement AS (SELECT Movement.Id           AS MovementId
                            , Movement.InvNumber    AS InvNumber
                            , Movement.OperDate     AS OperDate
                            , Movement.StatusId
                            , Movement.DescId
                            , MovementDesc.ItemName AS ItemName
                            , NULL       :: Integer AS UserId
                        FROM Movement
                             INNER JOIN MovementFloat AS MovementFloat_BranchCode
                                                      ON MovementFloat_BranchCode.MovementId = Movement.Id
                                                     AND MovementFloat_BranchCode.DescId     = zc_MovementFloat_BranchCode()
                                                     AND MovementFloat_BranchCode.ValueData  = 115
                             -- Вид документа
                             LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                                     ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                                    AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
                             LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData :: Integer

                        WHERE Movement.DescId IN (zc_Movement_WeighingPartner())
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                      UNION
                       -- Перемещения на РК
                       SELECT DISTINCT
                              Movement.Id           AS MovementId
                            , Movement.InvNumber    AS InvNumber
                            , Movement.OperDate     AS OperDate
                            , Movement.StatusId
                            , Movement.DescId
                            , MovementDesc.ItemName AS ItemName
                            , MLO_User.ObjectId     AS UserId
                        FROM Movement
                             -- Вид документа - Перемещение
                             INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                      ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                     AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
                                                     AND MovementFloat_MovementDesc.ValueData  = zc_Movement_Send() :: TFloat
                             -- на РК
                             INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                                    AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                                    AND MLO_To.ObjectId   = zc_Unit_RK()
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                             -- с признаком Автоматически
                             INNER JOIN MovementItemBoolean AS MIB_isAuto
                                                            ON MIB_isAuto.MovementItemId = MovementItem.Id
                                                           AND MIB_isAuto.DescId         = zc_MIBoolean_isAuto()
                                                           AND MIB_isAuto.ValueData      = TRUE

                             LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData :: Integer

                             LEFT JOIN MovementLinkObject AS MLO_User
                                                          ON MLO_User.MovementId = Movement.Id
                                                         AND MLO_User.DescId     = zc_MovementLinkObject_User()

                       WHERE Movement.DescId IN (zc_Movement_WeighingProduction())
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                     )
     -- данные по таре в строку
   , tmpBox AS (SELECT MAX (tmp.BoxId_1) AS BoxId_1, MAX (tmp.BoxName_1) AS BoxName_1, MAX (tmp.BoxWeight1) AS BoxWeight1
                     , MAX (tmp.BoxId_2) AS BoxId_2, MAX (tmp.BoxName_2) AS BoxName_2, MAX (tmp.BoxWeight2) AS BoxWeight2
                     , MAX (tmp.BoxId_3) AS BoxId_3, MAX (tmp.BoxName_3) AS BoxName_3, MAX (tmp.BoxWeight3) AS BoxWeight3
                     , MAX (tmp.BoxId_4) AS BoxId_4, MAX (tmp.BoxName_4) AS BoxName_4, MAX (tmp.BoxWeight4) AS BoxWeight4
                     , MAX (tmp.BoxId_5) AS BoxId_5, MAX (tmp.BoxName_5) AS BoxName_5, MAX (tmp.BoxWeight5) AS BoxWeight5
                     , MAX (tmp.BoxId_6) AS BoxId_6, MAX (tmp.BoxName_6) AS BoxName_6, MAX (tmp.BoxWeight6) AS BoxWeight6
                     , MAX (tmp.BoxId_7) AS BoxId_7, MAX (tmp.BoxName_7) AS BoxName_7, MAX (tmp.BoxWeight7) AS BoxWeight7
                     , MAX (tmp.BoxId_8) AS BoxId_8, MAX (tmp.BoxName_8) AS BoxName_8, MAX (tmp.BoxWeight8) AS BoxWeight8
                     , MAX (tmp.BoxId_9) AS BoxId_9, MAX (tmp.BoxName_9) AS BoxName_9, MAX (tmp.BoxWeight9) AS BoxWeight9
                     , MAX (tmp.BoxId_10) AS BoxId_10, MAX (tmp.BoxName_10) AS BoxName_10, MAX (tmp.BoxWeight10) AS BoxWeight10
                FROM (
                      SELECT CASE WHEN spSelect.NPP = 1 THEN spSelect.Id ELSE 0 END    AS BoxId_1
                           , CASE WHEN spSelect.NPP = 1 THEN (spSelect.Name||' ('||CAST (spSelect.BoxWeight AS NUMERIC (16,2))||')') ELSE '' END AS BoxName_1
                           , CASE WHEN spSelect.NPP = 2 THEN spSelect.Id ELSE 0 END    AS BoxId_2
                           , CASE WHEN spSelect.NPP = 2 THEN (spSelect.Name||' ('||CAST (spSelect.BoxWeight AS NUMERIC (16,2))||')') ELSE '' END AS BoxName_2
                           , CASE WHEN spSelect.NPP = 3 THEN spSelect.Id ELSE 0 END    AS BoxId_3
                           , CASE WHEN spSelect.NPP = 3 THEN (spSelect.Name||' ('||CAST (spSelect.BoxWeight AS NUMERIC (16,2))||')') ELSE '' END AS BoxName_3
                           , CASE WHEN spSelect.NPP = 4 THEN spSelect.Id ELSE 0 END    AS BoxId_4
                           , CASE WHEN spSelect.NPP = 4 THEN (spSelect.Name||' ('||CAST (spSelect.BoxWeight AS NUMERIC (16,2))||')') ELSE '' END AS BoxName_4
                           , CASE WHEN spSelect.NPP = 5 THEN spSelect.Id ELSE 0 END    AS BoxId_5
                           , CASE WHEN spSelect.NPP = 5 THEN (spSelect.Name||' ('||CAST (spSelect.BoxWeight AS NUMERIC (16,2))||')') ELSE '' END AS BoxName_5
                           , CASE WHEN spSelect.NPP = 6 THEN spSelect.Id ELSE 0 END    AS BoxId_6
                           , CASE WHEN spSelect.NPP = 6 THEN (spSelect.Name||' ('||CAST (spSelect.BoxWeight AS NUMERIC (16,2))||')') ELSE '' END AS BoxName_6
                           , CASE WHEN spSelect.NPP = 7 THEN spSelect.Id ELSE 0 END    AS BoxId_7
                           , CASE WHEN spSelect.NPP = 7 THEN (spSelect.Name||' ('||CAST (spSelect.BoxWeight AS NUMERIC (16,2))||')') ELSE '' END AS BoxName_7
                           , CASE WHEN spSelect.NPP = 8 THEN spSelect.Id ELSE 0 END    AS BoxId_8
                           , CASE WHEN spSelect.NPP = 8 THEN (spSelect.Name||' ('||CAST (spSelect.BoxWeight AS NUMERIC (16,2))||')') ELSE '' END AS BoxName_8
                           , CASE WHEN spSelect.NPP = 9 THEN spSelect.Id ELSE 0 END    AS BoxId_9
                           , CASE WHEN spSelect.NPP = 9 THEN (spSelect.Name||' ('||CAST (spSelect.BoxWeight AS NUMERIC (16,2))||')') ELSE '' END AS BoxName_9
                           , CASE WHEN spSelect.NPP = 10 THEN spSelect.Id ELSE 0 END    AS BoxId_10
                           , CASE WHEN spSelect.NPP = 10 THEN (spSelect.Name||' ('||CAST (spSelect.BoxWeight AS NUMERIC (16,2))||')') ELSE '' END AS BoxName_10

                           , CASE WHEN spSelect.NPP = 1 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight1
                           , CASE WHEN spSelect.NPP = 2 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight2
                           , CASE WHEN spSelect.NPP = 3 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight3
                           , CASE WHEN spSelect.NPP = 4 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight4
                           , CASE WHEN spSelect.NPP = 5 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight5
                           , CASE WHEN spSelect.NPP = 6 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight6
                           , CASE WHEN spSelect.NPP = 7 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight7
                           , CASE WHEN spSelect.NPP = 8 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight8
                           , CASE WHEN spSelect.NPP = 9 THEN spSelect.BoxWeight ELSE 0 END    AS BoxWeight9
                           , CASE WHEN spSelect.NPP = 10 THEN spSelect.BoxWeight ELSE 0 END   AS BoxWeight10

                      FROM gpSelect_Object_Box (inSession) AS spSelect
                      ) AS tmp
                )

   , tmpMI AS (SELECT tmpMovement.*
                    , MovementItem.Id
                    , MovementItem.ObjectId
                    , MovementItem.Amount
               FROM tmpMovement
                     INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                     -- с признаком Автоматически
                     LEFT JOIN MovementItemBoolean AS MIB_isAuto
                                                   ON MIB_isAuto.MovementItemId = MovementItem.Id
                                                  AND MIB_isAuto.DescId         = zc_MIBoolean_isAuto()

               WHERE tmpMovement.DescId   = zc_Movement_WeighingPartner()
                  OR MIB_isAuto.ValueData = TRUE
              )

   , tmpMIFloat AS (SELECT *
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                      AND MovementItemFloat.DescId IN (zc_MIFloat_CountTare1()
                                                     , zc_MIFloat_CountTare2()
                                                     , zc_MIFloat_CountTare3()
                                                     , zc_MIFloat_CountTare4()
                                                     , zc_MIFloat_CountTare5()
                                                     , zc_MIFloat_RealWeight()
                                                     , zc_MIFloat_PartionNum()
                                                     , zc_MIFloat_HeadCount()
                                                     , zc_MIFloat_CountPack()
                                                     , zc_MIFloat_WeightPack()
                                                     , zc_MIFloat_WeightTare1()
                                                     , zc_MIFloat_WeightTare2()
                                                     , zc_MIFloat_WeightTare3()
                                                     , zc_MIFloat_WeightTare4()
                                                     , zc_MIFloat_WeightTare5()
                                                      )
                  )

   , tmpMILO AS (SELECT *
                 FROM MovementItemLinkObject
                 WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                   AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Box1()
                                                       , zc_MILinkObject_Box2()
                                                       , zc_MILinkObject_Box3()
                                                       , zc_MILinkObject_Box4()
                                                       , zc_MILinkObject_Box5()
                                                       , zc_MILinkObject_GoodsKind()
                                                       , zc_MILinkObject_PartionCell()
                                                       , zc_MILinkObject_Insert()
                                                        )
               )

   , tmpMIDate AS (SELECT *
                   FROM MovementItemDate
                   WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                     AND MovementItemDate.DescId IN (zc_MIDate_PartionGoods()
                                                   , zc_MIDate_Insert()
                                                   , zc_MIDate_Update()
                                                    )
                 )

   , tmpData AS (SELECT MovementItem.*
                      , zfFormat_BarCode (zc_BarCodePref_MI(), MovementItem.Id) AS BarCode
                      , MILinkObject_GoodsKind.ObjectId    AS GoodsKindId
                      , MILinkObject_PartionCell.ObjectId  AS PartionCellId

                      , CASE WHEN tmpBox.BoxId_1 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                             WHEN tmpBox.BoxId_1 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                             WHEN tmpBox.BoxId_1 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                             WHEN tmpBox.BoxId_1 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                             WHEN tmpBox.BoxId_1 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
                        END   ::TFloat AS CountTare1
                      , CASE WHEN tmpBox.BoxId_2 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                             WHEN tmpBox.BoxId_2 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                             WHEN tmpBox.BoxId_2 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                             WHEN tmpBox.BoxId_2 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                             WHEN tmpBox.BoxId_2 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
                        END   ::TFloat AS CountTare2
                      , CASE WHEN tmpBox.BoxId_3 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                             WHEN tmpBox.BoxId_3 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                             WHEN tmpBox.BoxId_3 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                             WHEN tmpBox.BoxId_3 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                             WHEN tmpBox.BoxId_3 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
                        END   ::TFloat AS CountTare3
                      , CASE WHEN tmpBox.BoxId_4 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                             WHEN tmpBox.BoxId_4 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                             WHEN tmpBox.BoxId_4 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                             WHEN tmpBox.BoxId_4 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                             WHEN tmpBox.BoxId_4 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
                        END   ::TFloat AS CountTare4
                      , CASE WHEN tmpBox.BoxId_5 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                             WHEN tmpBox.BoxId_5 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                             WHEN tmpBox.BoxId_5 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                             WHEN tmpBox.BoxId_5 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                             WHEN tmpBox.BoxId_5 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
                        END   ::TFloat AS CountTare5
                      , CASE WHEN tmpBox.BoxId_6 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                             WHEN tmpBox.BoxId_6 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                             WHEN tmpBox.BoxId_6 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                             WHEN tmpBox.BoxId_6 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                             WHEN tmpBox.BoxId_6 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
                        END   ::TFloat AS CountTare6
                      , CASE WHEN tmpBox.BoxId_7 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                             WHEN tmpBox.BoxId_7 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                             WHEN tmpBox.BoxId_7 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                             WHEN tmpBox.BoxId_7 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                             WHEN tmpBox.BoxId_7 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
                        END   ::TFloat AS CountTare7
                      , CASE WHEN tmpBox.BoxId_8 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                             WHEN tmpBox.BoxId_8 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                             WHEN tmpBox.BoxId_8 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                             WHEN tmpBox.BoxId_8 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                             WHEN tmpBox.BoxId_8 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
                        END   ::TFloat AS CountTare8
                      , CASE WHEN tmpBox.BoxId_9 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                             WHEN tmpBox.BoxId_9 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                             WHEN tmpBox.BoxId_9 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                             WHEN tmpBox.BoxId_9 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                             WHEN tmpBox.BoxId_9 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
                        END   ::TFloat AS CountTare9
                      , CASE WHEN tmpBox.BoxId_10 = MILinkObject_Box1.ObjectId THEN MIFloat_CountTare1.ValueData
                             WHEN tmpBox.BoxId_10 = MILinkObject_Box2.ObjectId THEN MIFloat_CountTare2.ValueData
                             WHEN tmpBox.BoxId_10 = MILinkObject_Box3.ObjectId THEN MIFloat_CountTare3.ValueData
                             WHEN tmpBox.BoxId_10 = MILinkObject_Box4.ObjectId THEN MIFloat_CountTare4.ValueData
                             WHEN tmpBox.BoxId_10 = MILinkObject_Box5.ObjectId THEN MIFloat_CountTare5.ValueData
                        END   ::TFloat AS CountTare10

                      , CASE WHEN tmpBox.BoxId_1 = MILinkObject_Box1.ObjectId THEN MIFloat_WeightTare1.ValueData
                             WHEN tmpBox.BoxId_1 = MILinkObject_Box2.ObjectId THEN MIFloat_WeightTare2.ValueData
                             WHEN tmpBox.BoxId_1 = MILinkObject_Box3.ObjectId THEN MIFloat_WeightTare3.ValueData
                             WHEN tmpBox.BoxId_1 = MILinkObject_Box4.ObjectId THEN MIFloat_WeightTare4.ValueData
                             WHEN tmpBox.BoxId_1 = MILinkObject_Box5.ObjectId THEN MIFloat_WeightTare5.ValueData
                        END   ::TFloat AS WeightTare1
                      , CASE WHEN tmpBox.BoxId_2 = MILinkObject_Box1.ObjectId THEN MIFloat_WeightTare1.ValueData
                             WHEN tmpBox.BoxId_2 = MILinkObject_Box2.ObjectId THEN MIFloat_WeightTare2.ValueData
                             WHEN tmpBox.BoxId_2 = MILinkObject_Box3.ObjectId THEN MIFloat_WeightTare3.ValueData
                             WHEN tmpBox.BoxId_2 = MILinkObject_Box4.ObjectId THEN MIFloat_WeightTare4.ValueData
                             WHEN tmpBox.BoxId_2 = MILinkObject_Box5.ObjectId THEN MIFloat_WeightTare5.ValueData
                        END   ::TFloat AS WeightTare2
                      , CASE WHEN tmpBox.BoxId_3 = MILinkObject_Box1.ObjectId THEN MIFloat_WeightTare1.ValueData
                             WHEN tmpBox.BoxId_3 = MILinkObject_Box2.ObjectId THEN MIFloat_WeightTare2.ValueData
                             WHEN tmpBox.BoxId_3 = MILinkObject_Box3.ObjectId THEN MIFloat_WeightTare3.ValueData
                             WHEN tmpBox.BoxId_3 = MILinkObject_Box4.ObjectId THEN MIFloat_WeightTare4.ValueData
                             WHEN tmpBox.BoxId_3 = MILinkObject_Box5.ObjectId THEN MIFloat_WeightTare5.ValueData
                        END   ::TFloat AS WeightTare3
                      , CASE WHEN tmpBox.BoxId_4 = MILinkObject_Box1.ObjectId THEN MIFloat_WeightTare1.ValueData
                             WHEN tmpBox.BoxId_4 = MILinkObject_Box2.ObjectId THEN MIFloat_WeightTare2.ValueData
                             WHEN tmpBox.BoxId_4 = MILinkObject_Box3.ObjectId THEN MIFloat_WeightTare3.ValueData
                             WHEN tmpBox.BoxId_4 = MILinkObject_Box4.ObjectId THEN MIFloat_WeightTare4.ValueData
                             WHEN tmpBox.BoxId_4 = MILinkObject_Box5.ObjectId THEN MIFloat_WeightTare5.ValueData
                        END   ::TFloat AS WeightTare4
                      , CASE WHEN tmpBox.BoxId_5 = MILinkObject_Box1.ObjectId THEN MIFloat_WeightTare1.ValueData
                             WHEN tmpBox.BoxId_5 = MILinkObject_Box2.ObjectId THEN MIFloat_WeightTare2.ValueData
                             WHEN tmpBox.BoxId_5 = MILinkObject_Box3.ObjectId THEN MIFloat_WeightTare3.ValueData
                             WHEN tmpBox.BoxId_5 = MILinkObject_Box4.ObjectId THEN MIFloat_WeightTare4.ValueData
                             WHEN tmpBox.BoxId_5 = MILinkObject_Box5.ObjectId THEN MIFloat_WeightTare5.ValueData
                        END   ::TFloat AS WeightTare5
                      , CASE WHEN tmpBox.BoxId_6 = MILinkObject_Box1.ObjectId THEN MIFloat_WeightTare1.ValueData
                             WHEN tmpBox.BoxId_6 = MILinkObject_Box2.ObjectId THEN MIFloat_WeightTare2.ValueData
                             WHEN tmpBox.BoxId_6 = MILinkObject_Box3.ObjectId THEN MIFloat_WeightTare3.ValueData
                             WHEN tmpBox.BoxId_6 = MILinkObject_Box4.ObjectId THEN MIFloat_WeightTare4.ValueData
                             WHEN tmpBox.BoxId_6 = MILinkObject_Box5.ObjectId THEN MIFloat_WeightTare5.ValueData
                        END   ::TFloat AS WeightTare6
                      , CASE WHEN tmpBox.BoxId_7 = MILinkObject_Box1.ObjectId THEN MIFloat_WeightTare1.ValueData
                             WHEN tmpBox.BoxId_7 = MILinkObject_Box2.ObjectId THEN MIFloat_WeightTare2.ValueData
                             WHEN tmpBox.BoxId_7 = MILinkObject_Box3.ObjectId THEN MIFloat_WeightTare3.ValueData
                             WHEN tmpBox.BoxId_7 = MILinkObject_Box4.ObjectId THEN MIFloat_WeightTare4.ValueData
                             WHEN tmpBox.BoxId_7 = MILinkObject_Box5.ObjectId THEN MIFloat_WeightTare5.ValueData
                        END   ::TFloat AS WeightTare7
                      , CASE WHEN tmpBox.BoxId_8 = MILinkObject_Box1.ObjectId THEN MIFloat_WeightTare1.ValueData
                             WHEN tmpBox.BoxId_8 = MILinkObject_Box2.ObjectId THEN MIFloat_WeightTare2.ValueData
                             WHEN tmpBox.BoxId_8 = MILinkObject_Box3.ObjectId THEN MIFloat_WeightTare3.ValueData
                             WHEN tmpBox.BoxId_8 = MILinkObject_Box4.ObjectId THEN MIFloat_WeightTare4.ValueData
                             WHEN tmpBox.BoxId_8 = MILinkObject_Box5.ObjectId THEN MIFloat_WeightTare5.ValueData
                        END   ::TFloat AS WeightTare8
                      , CASE WHEN tmpBox.BoxId_9 = MILinkObject_Box1.ObjectId THEN MIFloat_WeightTare1.ValueData
                             WHEN tmpBox.BoxId_9 = MILinkObject_Box2.ObjectId THEN MIFloat_WeightTare2.ValueData
                             WHEN tmpBox.BoxId_9 = MILinkObject_Box3.ObjectId THEN MIFloat_WeightTare3.ValueData
                             WHEN tmpBox.BoxId_9 = MILinkObject_Box4.ObjectId THEN MIFloat_WeightTare4.ValueData
                             WHEN tmpBox.BoxId_9 = MILinkObject_Box5.ObjectId THEN MIFloat_WeightTare5.ValueData
                        END   ::TFloat AS WeightTare9
                      , CASE WHEN tmpBox.BoxId_10 = MILinkObject_Box1.ObjectId THEN MIFloat_WeightTare1.ValueData
                             WHEN tmpBox.BoxId_10 = MILinkObject_Box2.ObjectId THEN MIFloat_WeightTare2.ValueData
                             WHEN tmpBox.BoxId_10 = MILinkObject_Box3.ObjectId THEN MIFloat_WeightTare3.ValueData
                             WHEN tmpBox.BoxId_10 = MILinkObject_Box4.ObjectId THEN MIFloat_WeightTare4.ValueData
                             WHEN tmpBox.BoxId_10 = MILinkObject_Box5.ObjectId THEN MIFloat_WeightTare5.ValueData
                        END   ::TFloat AS WeightTare10

                      , tmpBox.BoxWeight1 ::TFloat, tmpBox.BoxWeight2 ::TFloat, tmpBox.BoxWeight3 ::TFloat, tmpBox.BoxWeight4 ::TFloat, tmpBox.BoxWeight5 ::TFloat
                      , tmpBox.BoxWeight6 ::TFloat, tmpBox.BoxWeight7 ::TFloat, tmpBox.BoxWeight8 ::TFloat, tmpBox.BoxWeight9 ::TFloat, tmpBox.BoxWeight10 ::TFloat

                      , tmpBox.BoxId_1, tmpBox.BoxId_2, tmpBox.BoxId_3, tmpBox.BoxId_4, tmpBox.BoxId_5
                      , tmpBox.BoxId_6, tmpBox.BoxId_7, tmpBox.BoxId_8, tmpBox.BoxId_9, tmpBox.BoxId_10
                      , tmpBox.BoxName_1 ::TVarChar, tmpBox.BoxName_2 ::TVarChar, tmpBox.BoxName_3 ::TVarChar, tmpBox.BoxName_4 ::TVarChar, tmpBox.BoxName_5 ::TVarChar
                      , tmpBox.BoxName_6 ::TVarChar, tmpBox.BoxName_7 ::TVarChar, tmpBox.BoxName_8 ::TVarChar, tmpBox.BoxName_9 ::TVarChar, tmpBox.BoxName_10 ::TVarChar

                      , MIFloat_RealWeight.ValueData ::TFloat AS RealWeight
                      , MIFloat_PartionNum.ValueData          AS PartionNum

                        -- Количество упаковок
                      , tmpMIFloat_CountPack.ValueData   ::Integer AS CountPack
                        -- Вес 1-ой упаковки
                      , tmpMIFloat_WeightPack.ValueData  ::TFloat  AS WeightPack
                        -- если Инвентаризация - Подготовка = здесь сохранено в ШТ
                      , tmpMIFloat_HeadCount.ValueData   ::Integer AS HeadCount
                      

                      , COALESCE (MIDate_PartionGoods.ValueData, MovementItem.OperDate) :: TDateTime AS PartionGoodsDate
                      , MIDate_Insert.ValueData  AS InsertDate
                      , COALESCE (MovementItem.UserId, MILO_Insert.ObjectId) AS InsertId
                      , MIDate_Update.ValueData  AS UpdateDate

                 FROM tmpMI AS MovementItem
                     LEFT JOIN tmpBox ON 1=1

                     LEFT JOIN tmpMIFloat AS MIFloat_CountTare1
                                          ON MIFloat_CountTare1.MovementItemId = MovementItem.Id
                                         AND MIFloat_CountTare1.DescId = zc_MIFloat_CountTare1()
                     LEFT JOIN tmpMIFloat AS MIFloat_CountTare2
                                          ON MIFloat_CountTare2.MovementItemId = MovementItem.Id
                                         AND MIFloat_CountTare2.DescId = zc_MIFloat_CountTare2()
                     LEFT JOIN tmpMIFloat AS MIFloat_CountTare3
                                          ON MIFloat_CountTare3.MovementItemId = MovementItem.Id
                                         AND MIFloat_CountTare3.DescId = zc_MIFloat_CountTare3()
                     LEFT JOIN tmpMIFloat AS MIFloat_CountTare4
                                          ON MIFloat_CountTare4.MovementItemId = MovementItem.Id
                                         AND MIFloat_CountTare4.DescId = zc_MIFloat_CountTare4()
                     LEFT JOIN tmpMIFloat AS MIFloat_CountTare5
                                          ON MIFloat_CountTare5.MovementItemId = MovementItem.Id
                                         AND MIFloat_CountTare5.DescId = zc_MIFloat_CountTare5()

                     LEFT JOIN tmpMIFloat AS MIFloat_WeightTare1
                                          ON MIFloat_WeightTare1.MovementItemId = MovementItem.Id
                                         AND MIFloat_WeightTare1.DescId = zc_MIFloat_WeightTare1()
                     LEFT JOIN tmpMIFloat AS MIFloat_WeightTare2
                                          ON MIFloat_WeightTare2.MovementItemId = MovementItem.Id
                                         AND MIFloat_WeightTare2.DescId = zc_MIFloat_WeightTare2()
                     LEFT JOIN tmpMIFloat AS MIFloat_WeightTare3
                                          ON MIFloat_WeightTare3.MovementItemId = MovementItem.Id
                                         AND MIFloat_WeightTare3.DescId = zc_MIFloat_WeightTare3()
                     LEFT JOIN tmpMIFloat AS MIFloat_WeightTare4
                                          ON MIFloat_WeightTare4.MovementItemId = MovementItem.Id
                                         AND MIFloat_WeightTare4.DescId = zc_MIFloat_WeightTare4()
                     LEFT JOIN tmpMIFloat AS MIFloat_WeightTare5
                                          ON MIFloat_WeightTare5.MovementItemId = MovementItem.Id
                                         AND MIFloat_WeightTare5.DescId = zc_MIFloat_WeightTare5()

                     -- если Инвентаризация - Подготовка = здесь сохранено в ШТ
                     LEFT JOIN tmpMIFloat AS tmpMIFloat_HeadCount
                                          ON tmpMIFloat_HeadCount.MovementItemId = MovementItem.Id
                                         AND tmpMIFloat_HeadCount.DescId         = zc_MIFloat_HeadCount()
                     -- упаковка
                     LEFT JOIN tmpMIFloat AS tmpMIFloat_CountPack
                                          ON tmpMIFloat_CountPack.MovementItemId =  MovementItem.Id
                                         AND tmpMIFloat_CountPack.DescId         = zc_MIFloat_CountPack()
                     LEFT JOIN tmpMIFloat AS tmpMIFloat_WeightPack
                                          ON tmpMIFloat_WeightPack.MovementItemId =  MovementItem.Id
                                         AND tmpMIFloat_WeightPack.DescId         = zc_MIFloat_WeightPack()

                     LEFT JOIN tmpMIFloat AS MIFloat_PartionNum
                                          ON MIFloat_PartionNum.MovementItemId = MovementItem.Id
                                         AND MIFloat_PartionNum.DescId = zc_MIFloat_PartionNum()
                     LEFT JOIN tmpMIFloat AS MIFloat_RealWeight
                                          ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                         AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

                     LEFT JOIN tmpMIDate AS MIDate_PartionGoods
                                         ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                     LEFT JOIN tmpMIDate AS MIDate_Insert
                                         ON MIDate_Insert.MovementItemId = MovementItem.Id
                                        AND MIDate_Insert.DescId = zc_MIDate_Insert()
                     LEFT JOIN tmpMIDate AS MIDate_Update
                                         ON MIDate_Update.MovementItemId = MovementItem.Id
                                        AND MIDate_Update.DescId = zc_MIDate_Update()

                     LEFT JOIN tmpMILO AS MILO_Insert
                                       ON MILO_Insert.MovementItemId = MovementItem.Id
                                      AND MILO_Insert.DescId         = zc_MILinkObject_Insert()

                     LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     LEFT JOIN tmpMILO AS MILinkObject_PartionCell
                                       ON MILinkObject_PartionCell.MovementItemId = MovementItem.Id
                                      AND MILinkObject_PartionCell.DescId = zc_MILinkObject_PartionCell()

                     LEFT JOIN tmpMILO AS MILinkObject_Box1
                                       ON MILinkObject_Box1.MovementItemId = MovementItem.Id
                                      AND MILinkObject_Box1.DescId = zc_MILinkObject_Box1()
                     LEFT JOIN tmpMILO AS MILinkObject_Box2
                                       ON MILinkObject_Box2.MovementItemId = MovementItem.Id
                                      AND MILinkObject_Box2.DescId = zc_MILinkObject_Box2()
                     LEFT JOIN tmpMILO AS MILinkObject_Box3
                                       ON MILinkObject_Box3.MovementItemId = MovementItem.Id
                                      AND MILinkObject_Box3.DescId = zc_MILinkObject_Box3()
                     LEFT JOIN tmpMILO AS MILinkObject_Box4
                                       ON MILinkObject_Box4.MovementItemId = MovementItem.Id
                                      AND MILinkObject_Box4.DescId = zc_MILinkObject_Box4()
                     LEFT JOIN tmpMILO AS MILinkObject_Box5
                                       ON MILinkObject_Box5.MovementItemId = MovementItem.Id
                                      AND MILinkObject_Box5.DescId = zc_MILinkObject_Box5()
                  )
     , tmpGoodsByGoodsKind AS (SELECT MovementItem.Id AS MovementItemId
                                    , COALESCE (ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.ValueData, 0) AS WeightPackageSticker
                               FROM tmpData AS MovementItem
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                          ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = MovementItem.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                          ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = MovementItem.GoodsKindId
                                    LEFT JOIN ObjectFloat AS ObjectFloat_GoodsByGoodsKind_WeightPackageSticker
                                                          ON ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.DescId    = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker()
                              )
          -- РЕЗУЛЬТАТ
          SELECT tmpData.MovementId
               , tmpData.ItemName
               , MovementDesc.ItemName AS ItemName_inf
               , tmpData.InvNumber
               , tmpData.OperDate
               , Object_Status.ObjectCode AS StatusCode
               , tmpData.Id AS MovementItemId
               , (tmpData.BarCode || zfCalc_SummBarCode(tmpData.BarCode) :: TVarChar) :: TVarChar AS BarCode
               , Object_Goods.Id                   AS GoodsId
               , Object_Goods.ObjectCode ::Integer AS GoodsCode
               , Object_Goods.ValueData            AS GoodsName
               , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
               , Object_Measure.ValueData                    AS MeasureName
               , Object_GoodsKind.ValueData                  AS GoodsKindName
               , tmpData.PartionGoodsDate  ::TDateTime
               , tmpData.UpdateDate        ::TDateTime
               , tmpData.InsertDate        ::TDateTime
               , Object_Insert.ValueData  ::TVarChar AS InsertName
               , Object_PartionCell.ValueData ::TVarChar AS PartionCellName
               , tmpData.PartionNum     ::TFloat

-- ************
-- если Перемещение с Упак -> РК = здесь всегда ШТ
-- если Инвентаризация - Подготовка = здесь всегда ВЕС
-- ************

                 -- Вес нетто
               , CASE WHEN tmpData.DescId = zc_Movement_WeighingProduction() AND OL_Measure.ChildObjectId = zc_Measure_Sh()
                           -- если Перемещение с Упак -> РК = переводим из ШТ в ВЕС
                           THEN tmpData.Amount * (COALESCE (OF_Weight.ValueData, 0) + COALESCE (tmpGoodsByGoodsKind.WeightPackageSticker, 0))


                      WHEN tmpData.DescId = zc_Movement_WeighingPartner() AND OL_Measure.ChildObjectId = zc_Measure_Sh() AND tmpData.HeadCount > 0
                           -- если Инвентаризация - Подготовка = здесь сохранено в ШТ
                           THEN tmpData.HeadCount * (COALESCE (OF_Weight.ValueData, 0) + COALESCE (tmpGoodsByGoodsKind.WeightPackageSticker, 0))

                      -- Иначе Инвентаризация - Подготовка = здесь всегда ВЕС
                      ELSE tmpData.Amount

                 END :: TFloat AS Amount

                 -- Шт
             , CAST (CASE WHEN tmpData.DescId = zc_Movement_WeighingProduction() AND OL_Measure.ChildObjectId = zc_Measure_Sh()
                               -- если Перемещение с Упак -> РК = здесь всегда ШТ
                               THEN tmpData.Amount

                          WHEN tmpData.DescId = zc_Movement_WeighingPartner() AND OL_Measure.ChildObjectId = zc_Measure_Sh() AND tmpData.HeadCount > 0
                               -- если Инвентаризация - Подготовка = здесь сохранено в ШТ
                               THEN tmpData.HeadCount

                          WHEN tmpData.DescId = zc_Movement_WeighingPartner() AND OL_Measure.ChildObjectId = zc_Measure_Sh() AND OF_Weight.ValueData > 0
                               -- если Инвентаризация - Подготовка = переводим из ВЕС в ШТ
                               THEN tmpData.Amount / (COALESCE (OF_Weight.ValueData, 0) + COALESCE (tmpGoodsByGoodsKind.WeightPackageSticker, 0))

                          ELSE 0

                     END AS NUMERIC (16, 0)
                    ) :: TFloat AS Amount_sh
                    
                 -- если Инвентаризация - Подготовка = здесь сохранено в ШТ
               , tmpData.HeadCount      :: TFloat AS Amount_sh_inv

               , tmpData.RealWeight     ::TFloat
               , tmpData.CountTare1     ::TFloat
               , tmpData.CountTare2     ::TFloat
               , tmpData.CountTare3     ::TFloat
               , tmpData.CountTare4     ::TFloat
               , tmpData.CountTare5     ::TFloat
               , tmpData.CountTare6     ::TFloat
               , tmpData.CountTare7     ::TFloat
               , tmpData.CountTare8     ::TFloat
               , tmpData.CountTare9     ::TFloat
               , tmpData.CountTare10    ::TFloat

                 -- факт вес 1-ого Поддона / Ящика
               , tmpData.WeightTare1    ::TFloat
               , tmpData.WeightTare2    ::TFloat
               , tmpData.WeightTare3    ::TFloat
               , tmpData.WeightTare4    ::TFloat
               , tmpData.WeightTare5    ::TFloat
               , tmpData.WeightTare6    ::TFloat
               , tmpData.WeightTare7    ::TFloat
               , tmpData.WeightTare8    ::TFloat
               , tmpData.WeightTare9    ::TFloat
               , tmpData.WeightTare10   ::TFloat

                 -- информативно вес 1-ого Поддона / Ящика
               , tmpData.BoxWeight1 ::TFloat, tmpData.BoxWeight2 ::TFloat, tmpData.BoxWeight3 ::TFloat, tmpData.BoxWeight4 ::TFloat, tmpData.BoxWeight5 ::TFloat
               , tmpData.BoxWeight6 ::TFloat, tmpData.BoxWeight7 ::TFloat, tmpData.BoxWeight8 ::TFloat, tmpData.BoxWeight9 ::TFloat, tmpData.BoxWeight10 ::TFloat

               , (-- COALESCE (tmpData.CountTare1,0)
                  --+ COALESCE (tmpData.CountTare2,0)
                  0
                + COALESCE (tmpData.CountTare3,0)
                + COALESCE (tmpData.CountTare4,0)
                + COALESCE (tmpData.CountTare5,0)
                + COALESCE (tmpData.CountTare6,0)
                + COALESCE (tmpData.CountTare7,0)
                + COALESCE (tmpData.CountTare8,0)
                + COALESCE (tmpData.CountTare9,0)
                + COALESCE (tmpData.CountTare10,0)) ::TFloat AS BoxCountTotal

               , (-- Поддоны
                + COALESCE (tmpData.CountTare1,0) * COALESCE (tmpData.WeightTare1,0)
                + COALESCE (tmpData.CountTare2,0) * COALESCE (tmpData.WeightTare2,0)
                 -- + Ящики
                + COALESCE (tmpData.CountTare3,0) * COALESCE (tmpData.WeightTare3,0)
                + COALESCE (tmpData.CountTare4,0) * COALESCE (tmpData.WeightTare4,0)
                + COALESCE (tmpData.CountTare5,0) * COALESCE (tmpData.WeightTare5,0)
                + COALESCE (tmpData.CountTare6,0) * COALESCE (tmpData.WeightTare6,0)
                + COALESCE (tmpData.CountTare7,0) * COALESCE (tmpData.WeightTare7,0)
                + COALESCE (tmpData.CountTare8,0) * COALESCE (tmpData.WeightTare8,0)
                + COALESCE (tmpData.CountTare9,0) * COALESCE (tmpData.WeightTare9,0)
                + COALESCE (tmpData.CountTare10,0) * COALESCE (tmpData.WeightTare10,0)
                 -- + Упаковка
                + COALESCE (tmpData.CountPack, 0) * COALESCE (tmpData.WeightPack, 0)
                 ) ::TFloat AS BoxWeightTotal

                --упаковка
               , tmpData.CountPack         ::Integer
               , tmpData.WeightPack        ::TFloat
               , (tmpData.CountPack * tmpData.WeightPack) ::TFloat AS WeightPack_calc

               , tmpData.BoxName_1 ::TVarChar, tmpData.BoxName_2 ::TVarChar, tmpData.BoxName_3 ::TVarChar, tmpData.BoxName_4 ::TVarChar, tmpData.BoxName_5 ::TVarChar
               , tmpData.BoxName_6 ::TVarChar, tmpData.BoxName_7 ::TVarChar, tmpData.BoxName_8 ::TVarChar, tmpData.BoxName_9 ::TVarChar, tmpData.BoxName_10 ::TVarChar

          FROM tmpData
               LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.MovementItemId = tmpData.Id

               LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpData.StatusId
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.ObjectId
               LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
               LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = tmpData.PartionCellId
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = tmpData.InsertId

               LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                      ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                     AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

               LEFT JOIN ObjectFloat AS OF_Weight
                                     ON OF_Weight.ObjectId = Object_Goods.Id
                                    AND OF_Weight.DescId = zc_ObjectFloat_Goods_Weight()
               LEFT JOIN ObjectLink AS OL_Measure
                                    ON OL_Measure.ObjectId = Object_Goods.Id
                                   AND OL_Measure.DescId = zc_ObjectLink_Goods_Measure()
               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Measure.ChildObjectId

               LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.DescId
              ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.25         *
*/

-- тест
-- SELECT * FROM gpReport_WeighingPartner_Passport (inStartDate := ('02.02.2025')::TDateTime , inEndDate := ('02.02.2025')::TDateTime ,inSession := '5');
