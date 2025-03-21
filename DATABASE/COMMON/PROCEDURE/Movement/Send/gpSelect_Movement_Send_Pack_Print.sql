-- Function: gpSelect_Movement_Send_Pack_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send_Pack_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Send_Pack_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_by     Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbGoodsPropertyId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send_Pack_Print());
     vbUserId:= lpGetUserBySession (inSession);


     -- Дата
     vbOperDate:= (SELECT Movement.OperDate
                   FROM Movement
                   WHERE Movement.Id = inMovementId
                  );
                         
     -- определяется параметр
     vbGoodsPropertyId:= 83955;   --Алан
     
-- RAISE EXCEPTION '<%>', lfGet_Object_ValueData (vbGoodsPropertyId);

     -- Данные: заголовок + строчная часть
     OPEN Cursor1 FOR
     WITH -- список всех Документов Взвешивания или одного - inMovementId_by
       tmpMovement AS (SELECT Movement.Id, Movement.ParentId
                       FROM Movement
                       WHERE Movement.ParentId = inMovementId
                         AND Movement.DescId = zc_Movement_WeighingProduction()
                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                         AND (Movement.Id = inMovementId_by OR COALESCE (inMovementId_by, 0) = 0)
                      )
     , tmpMovementCount AS (SELECT Count(*) AS WeighingCount
                            FROM Movement
                            WHERE Movement.ParentId = inMovementId
                              AND Movement.DescId = zc_Movement_WeighingProduction()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )
       -- список Вес гофроящика для товар + GoodsKindId
     , tmpObject_GoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                               -- Товар(гофроящик)
                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId, 0)  AS GoodsBoxId
                                               -- Вес гофроящика
                                             , COALESCE (ObjectFloat_Weight.ValueData, 0)                          AS GoodsBox_Weight
                                        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                                             ) AS tmpGoodsProperty
                                             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                             -- нашли гофроящик
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = Object_GoodsPropertyValue.Id
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
                                             -- Вес гофроящика
                                             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                                   ON ObjectFloat_Weight.ObjectId = ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId
                                                                  AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                                                                 
                                       )
        -- строчная часть документов Взвешивания или одного - inMovementId_by
     , tmpMI AS (WITH
                 tmp AS (SELECT MovementItem.*
                         FROM tmpMovement
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                         )
                  , tmpMILO AS (SELECT *
                                FROM MovementItemLinkObject
                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmp.Id FROM tmp)
                                   AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                )
                   SELECT MovementItem.MovementId                           AS MovementId
                        , MovementItem.Id                                   AS MI_Id
                        , MovementItem.ObjectId                             AS GoodsId
                        , MovementItem.Amount                               AS Amount
                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)     AS GoodsKindId
                   FROM tmp AS MovementItem
                       LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 )

     , tmpMI_Float AS (SELECT MovementItemFloat.*
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                         AND MovementItemFloat.DescId IN (zc_MIFloat_BoxCount(), zc_MIFloat_LevelNumber(), zc_MIFloat_BoxNumber(), zc_MIFloat_CountTare(), zc_MIFloat_WeightTare())
                        )
     , tmp_GoodsKind AS (SELECT MovementItemLinkObject.*
                         FROM MovementItemLinkObject
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                          AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                         )
     , tmpMovementItem AS (SELECT tmpMI.MovementId                           AS MovementId
                                , tmpMI.GoodsId                              AS GoodsId
                                , SUM (tmpMI.Amount) AS Amount
                                , SUM (tmpMI.Amount
                                     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END
                                      ) AS AmountWeight 
                                , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (tmpMI.Amount, 0) ELSE 0 END) AS AmountSh
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                , MAX (COALESCE (MIFloat_LevelNumber.ValueData, 0))   AS LevelNumber
                                , SUM (COALESCE (MIFloat_BoxCount.ValueData, 0))      AS BoxCount
                                , COUNT (*)                                           AS BoxCount_calc
                                , MAX (COALESCE (MIFloat_BoxNumber.ValueData, 0))     AS BoxNumber
                                 -- так считаем Кол-во Упаковок (пакетов)
                                , SUM (CASE WHEN MIFloat_WeightTare.ValueData < 0.1 THEN COALESCE (MIFloat_CountTare.ValueData, 0) ELSE 0 END) AS CountPackage_calc

                           FROM tmpMI

                                LEFT JOIN tmpMI_Float AS MIFloat_BoxCount
                                                      ON MIFloat_BoxCount.MovementItemId = tmpMI.MI_Id
                                                     AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                                LEFT JOIN tmpMI_Float AS MIFloat_BoxNumber
                                                      ON MIFloat_BoxNumber.MovementItemId = tmpMI.MI_Id
                                                     AND MIFloat_BoxNumber.DescId = zc_MIFloat_BoxNumber()
                                LEFT JOIN tmpMI_Float AS MIFloat_LevelNumber
                                                      ON MIFloat_LevelNumber.MovementItemId = tmpMI.MI_Id
                                                     AND MIFloat_LevelNumber.DescId = zc_MIFloat_LevelNumber()

                                LEFT JOIN tmpMI_Float AS MIFloat_CountTare
                                                      ON MIFloat_CountTare.MovementItemId = tmpMI.MI_Id
                                                     AND MIFloat_CountTare.DescId = zc_MIFloat_CountTare()
                                LEFT JOIN tmpMI_Float AS MIFloat_WeightTare
                                                      ON MIFloat_WeightTare.MovementItemId = tmpMI.MI_Id
                                                     AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

                                LEFT JOIN tmp_GoodsKind AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = tmpMI.MI_Id

                                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                      ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                                     AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                     ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                           GROUP BY tmpMI.MovementId, tmpMI.GoodsId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          )
       -- 
     , tmpMovementData AS (SELECT tmpMovementItem.*
                                , tmpMovement.ParentId AS ParentId_Movement
                           FROM tmpMovement
                                INNER JOIN tmpMovementItem ON tmpMovementItem.MovementId = tmpMovement.Id AND tmpMovementItem.Amount <> 0
                           )
       -- 
     , tmpMovementParent AS (SELECT Movement_Send.*
                             FROM (SELECT DISTINCT tmpMovementData.ParentId_Movement FROM tmpMovementData) AS tmpMovement
                                  LEFT JOIN Movement AS Movement_Send ON Movement_Send.Id = tmpMovement.ParentId_Movement
                             )

     , tmpMLO_From_To AS (SELECT *
                          FROM MovementLinkObject
                          WHERE MovementLinkObject.DescId IN (zc_MovementLinkObject_From(), zc_MovementLinkObject_To())
                            AND MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovementData.MovementId FROM tmpMovementData)
                           )

     , tmpMovementParam AS (SELECT tmpMovement.MovementId
                                 , Movement_Send.OperDate                      AS OperDate
                                 , Movement_Send.InvNumber                     AS InvNumber

                                 , Object_From.ValueData                       AS FromName
                                 , Object_To.ValueData                         AS ToName

                            FROM (SELECT DISTINCT tmpMovementData.MovementId, tmpMovementData.ParentId_Movement FROM tmpMovementData) AS tmpMovement
                                 LEFT JOIN tmpMLO_From_To AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = tmpMovement.MovementId
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                      ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     
                                 LEFT JOIN tmpMLO_From_To AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = tmpMovement.MovementId
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                 LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                     
                                 LEFT JOIN tmpMovementParent AS Movement_Send ON Movement_Send.Id = tmpMovement.ParentId_Movement
               )
 
     , tmpMovementFloat AS (SELECT MovementFloat.*
                            FROM MovementFloat
                            WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovementData.MovementId FROM tmpMovementData)
                              AND MovementFloat.DescId IN ( zc_MovementFloat_WeighingNumber(),zc_MovementFloat_TotalCountKg()) 
                            )
     -- свойства товара
     , tmpObjectLink AS (SELECT ObjectLink.*
                      FROM ObjectLink
                      WHERE ObjectLink.ObjectId IN (SELECT tmpMovementData.GoodsId FROM tmpMovementData)
                        AND ObjectLink.DescId IN (zc_ObjectLink_Goods_InfoMoney(), zc_ObjectLink_Goods_Measure())
                     )
     , tmpObjectString AS (SELECT ObjectString.*
                           FROM ObjectString
                           WHERE ObjectString.ObjectId IN (SELECT tmpMovementData.GoodsId FROM tmpMovementData)
                             AND ObjectString.DescId = zc_ObjectString_Goods_GroupNameFull()
                           )

      -- Результат
     SELECT tmpMovementItem.MovementId	                                            AS MovementId
           , CAST (ROW_NUMBER() OVER (PARTITION BY MovementFloat_WeighingNumber.ValueData, tmpMovementItem.MovementId ORDER BY MovementFloat_WeighingNumber.ValueData, tmpMovementItem.MovementId, ObjectString_Goods_GoodsGroupFull.ValueData, Object_Goods.ValueData, Object_GoodsKind.ValueData) AS Integer) AS NumOrder
           , tmpMovementParam.OperDate
           , MovementFloat_WeighingNumber.ValueData                                 AS WeighingNumber
           , (SELECT WeighingCount FROM tmpMovementCount) :: Integer                AS WeighingCount
           , tmpMovementParam.InvNumber
           , MovementFloat_TotalCountKg.ValueData                                   AS TotalCountKg

           , tmpMovementParam.FromName
           , tmpMovementParam.ToName

           , ObjectString_Goods_GoodsGroupFull.ValueData                            AS GoodsGroupNameFull
           , Object_Goods.ObjectCode                                                AS GoodsCode
           , (Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , Object_Goods.ValueData :: TVarChar AS GoodsName_two

           , Object_GoodsKind.ValueData                                             AS GoodsKindName
           , Object_Measure.ValueData                                               AS MeasureName

           , tmpMovementItem.LevelNumber                                            AS LevelNumber
           , CASE /*WHEN 1=1 THEN COALESCE (tmpMovementItem.BoxCount, 0)*/ WHEN COALESCE (tmpMovementItem.BoxCount, 0) = 0 AND tmpMovementItem.BoxCount_calc > 0 THEN tmpMovementItem.BoxCount_calc ELSE tmpMovementItem.BoxCount END :: Integer AS BoxCount
           , tmpMovementItem.BoxNumber

             -- Вес Товара - гофроящик
           , (COALESCE (tmpMovementItem.BoxCount, 0) * COALESCE (tmpObject_GoodsPropertyValue.GoodsBox_Weight, 0)):: TFloat AS BoxWeight

           , tmpMovementItem.Amount                                       :: TFloat AS Amount
           , tmpMovementItem.AmountWeight                                 :: TFloat AS AmountWeight
           , tmpMovementItem.AmountSh                                     :: TFloat AS AmountSh

             -- ВЕС Скидка + потери - ?хотя может быть надо было учесть ТОЛЬКО Скидку?
           , (tmpMovementItem.AmountWeight - tmpMovementItem.AmountWeight) :: TFloat AS AmountWeight_diff

             -- ВЕС БРУТТО - учитывается скидка за вес
           , (-- "чистый" вес "со склада" - ???почему по ТЗ скидка за вес НЕ должна учитываться???
              tmpMovementItem.AmountWeight
            + -- плюс Вес "гофроящиков"
              COALESCE (tmpMovementItem.BoxCount, 0) * COALESCE (tmpObject_GoodsPropertyValue.GoodsBox_Weight, 0)
            + -- плюс Вес Упаковок (пакетов)
              CASE WHEN tmpMovementItem.CountPackage_calc > 0
                       THEN tmpMovementItem.CountPackage_calc
                          * -- вес 1-ого пакета
                            COALESCE (ObjectFloat_WeightPackage.ValueData, 0)

                   WHEN COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/ > 0
                        THEN -- "чистый" вес "у покупателя" ДЕЛИМ НА вес в упаковке: "чистый" вес + вес 1-ого пакета МИНУС вес 1-ого пакета
                             CAST (tmpMovementItem.AmountWeight / (COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/) AS NUMERIC (16, 0))
                           * -- вес 1-ого пакета
                             COALESCE (ObjectFloat_WeightPackage.ValueData, 0)
                   ELSE 0
              END
             ) :: TFloat AS AmountWeightWithBox

             -- ВЕС БРУТТО
           , (-- "чистый" вес "у покупателя" - ???почему по ТЗ скидка за вес НЕ должна учитываться???
              tmpMovementItem.AmountWeight
            + -- плюс Вес "гофроящиков"
              COALESCE (tmpMovementItem.BoxCount, 0) * COALESCE (tmpObject_GoodsPropertyValue.GoodsBox_Weight, 0)
            + -- плюс Вес Упаковок (пакетов)
              CASE WHEN tmpMovementItem.CountPackage_calc > 0
                       THEN tmpMovementItem.CountPackage_calc
                           * -- вес 1-ого пакета
                             COALESCE (ObjectFloat_WeightPackage.ValueData, 0)

                  WHEN COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/ > 0
                        THEN -- "чистый" вес "у покупателя" ДЕЛИМ НА вес в упаковке: "чистый" вес + вес 1-ого пакета МИНУС вес 1-ого пакета
                             CAST (tmpMovementItem.AmountWeight / (COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/) AS NUMERIC (16, 0))
                           * -- вес 1-ого пакета
                             COALESCE (ObjectFloat_WeightPackage.ValueData, 0)
                   ELSE 0
              END
             ) :: TFloat AS AmountWeightWithBox

             -- Кол-во Упаковок (пакетов)
           , CASE WHEN tmpMovementItem.CountPackage_calc > 0
                       THEN tmpMovementItem.CountPackage_calc

                  WHEN COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/ > 0
                       THEN -- "чистый" вес "у покупателя" ДЕЛИМ НА вес в упаковке: "чистый" вес + вес 1-ого пакета МИНУС вес 1-ого пакета
                            CAST (tmpMovementItem.AmountWeight / (COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/) AS NUMERIC (16, 0))
                  ELSE 0
             END :: TFloat AS CountPackage_calc
             -- Вес Упаковок (пакетов)
           , CASE WHEN tmpMovementItem.CountPackage_calc > 0
                       THEN tmpMovementItem.CountPackage_calc
                          * -- вес 1-ого пакета
                            COALESCE (ObjectFloat_WeightPackage.ValueData, 0)

                  WHEN COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/ > 0
                       THEN -- "чистый" вес "у покупателя" ДЕЛИМ НА вес в упаковке: "чистый" вес + вес 1-ого пакета МИНУС вес 1-ого пакета
                            CAST (tmpMovementItem.AmountWeight / (COALESCE (ObjectFloat_WeightTotal.ValueData, 0) /*- COALESCE (ObjectFloat_WeightPackage.ValueData, 0)*/) AS NUMERIC (16, 0))
                          * -- вес 1-ого пакета
                            COALESCE (ObjectFloat_WeightPackage.ValueData, 0)
                  ELSE 0
             END :: TFloat AS WeightPackage_calc

           , 'Україна, м.Дніпро' :: TVarChar AS LoadingPlace

       FROM tmpMovementData AS tmpMovementItem
          LEFT JOIN tmpMovementParam ON tmpMovementParam.MovementId = tmpMovementItem.MovementId
          
          LEFT JOIN tmpMovementFloat AS MovementFloat_WeighingNumber
                                     ON MovementFloat_WeighingNumber.MovementId = tmpMovementItem.MovementId
                                    AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()
          LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                     ON MovementFloat_TotalCountKg.MovementId = tmpMovementItem.MovementId
                                    AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovementItem.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMovementItem.GoodsKindId

          LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId     = Object_Goods.Id
                                                AND tmpObject_GoodsPropertyValue.GoodsKindId = Object_GoodsKind.Id

          LEFT JOIN tmpObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id

          LEFT JOIN tmpObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          -- Товар и Вид товара
          LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpMovementItem.GoodsId
                                                AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpMovementItem.GoodsKindId
          -- вес 1-ого пакета
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightPackage.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker()
          -- вес в упаковке: "чистый" вес + вес 1-ого пакета
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()

       ORDER BY tmpMovementItem.MovementId
      ;
     RETURN NEXT Cursor1;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.03.25         *
*/

-- тест
--select * from gpSelect_Movement_Send_Pack_Print(inMovementId := 30755358  , inMovementId_by := 0 ,  inSession := '5');
--FETCH ALL "<unnamed portal 10>";