-- Function: gpComplete_SelectAll_Sybase_ALL()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase (TDateTime, TDateTime, Boolean, Boolean);
DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase (TDateTime, TDateTime, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsSale             Boolean   , --
    IN inIsBefoHistoryCost  Boolean   , --
    IN inGroupId            Integer     -- -1:Все 0:ф.Днепр 1:ф.Киев 2:остальные филиалы
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar, BranchCode Integer, BranchName TVarChar, MovementDescId Integer, MovementDescCode TVarChar, MovementDescItemName TVarChar
              )
AS
$BODY$
  DECLARE vbIsSale Boolean;
  DECLARE vbIsReturnIn Boolean;
BEGIN
    -- IF inGroupId <=0 THEN
    --    inIsBefoHistoryCost:= FALSE;
    --    inGroupId:= 0;
    -- END IF;

IF inIsBefoHistoryCost = TRUE
THEN
    inGroupId:= -1;
-- ELSE
--    inGroupId:= -1; -- Все
--  inGroupId:=  0; -- ф.Днепр
--  inGroupId:=  1; -- ф.Киев
--  inGroupId:=  2; -- филиал Одесса
--  inGroupId:=  3; -- остальные филиалы
--  inGroupId:=  4; -- продажа/возврат - ф.Днепр
END IF;


-- inIsBefoHistoryCost:= TRUE;


     -- !!!НУЖНЫ ли ПРОДАЖИ!!!
     vbIsSale:= -- если последний 1 день месяца
                DATE_TRUNC ('MONTH', CURRENT_DATE + INTERVAL '1 DAY')  > (DATE_TRUNC ('MONTH', CURRENT_DATE))
                -- или прошлый период
             OR DATE_TRUNC ('MONTH', inStartDate) < (DATE_TRUNC ('MONTH', CURRENT_DATE))
                -- или Суббота
             OR EXTRACT (DOW FROM CURRENT_DATE) = 6
             --OR EXTRACT (DOW FROM CURRENT_DATE) = 0
                -- или
             OR EXTRACT (DAY FROM CURRENT_DATE) <= 15
             --OR 1=1
             OR inGroupId = 4
                ;

    -- RAISE EXCEPTION 'Ошибка.<%>', inIsSale, vbIsSale;


     -- !!!НУЖНЫ ли ВОЗВРАТЫ!!!
     vbIsReturnIn:= -- если последние 2 дня месяца
                    DATE_TRUNC ('MONTH', CURRENT_DATE + INTERVAL '2 DAY')  > (DATE_TRUNC ('MONTH', CURRENT_DATE))
                    -- или vbIsSale
                 OR vbIsSale = TRUE
               --OR 1=1
                   ;


     -- !!!ВРЕМЕННО!!!
     /*IF inStartDate >= '01.02.2018' THEN
          return;
     END IF;*/

     /*IF inIsBefoHistoryCost = TRUE THEN
          return;
     END IF;*/

     -- !!!Замена!!!
     -- inIsBefoHistoryCost:= FALSE;
     -- !!!Замена!!!
     /*IF inIsSale = TRUE
     THEN
         inIsBefoHistoryCost:= FALSE;
     END IF;*/


     -- Результат
     RETURN QUERY
     WITH tmpUnit AS (/*SELECT 8411 AS UnitId, NULL AS isMain -- Склад гп ф.Киев
                UNION SELECT 8413 AS UnitId, NULL AS isMain  -- ф. Кр.Рог
                UNION SELECT 8415 AS UnitId, NULL AS isMain  -- ф. Черкассы ( Кировоград)
                UNION SELECT 8417 AS UnitId, NULL AS isMain  -- ф. Николаев (Херсон)
                UNION SELECT 8421 AS UnitId, NULL AS isMain  -- ф. Донецк
                UNION SELECT 8425 AS UnitId, NULL AS isMain  -- ф. Харьков
                UNION SELECT 301309 AS UnitId, NULL AS isMain  -- Склад ГП ф.Запорожье
                -- UNION SELECT 309599 AS UnitId, NULL AS isMain  -- Склад возвратов ф.Запорожье
                UNION SELECT 18341 AS UnitId, NULL AS isMain  -- ф. Никополь
                UNION SELECT 8419 AS UnitId, NULL AS isMain  -- ф. Крым
                UNION SELECT 8423 AS UnitId, NULL AS isMain  -- ф. Одесса
                UNION SELECT 346093  AS UnitId, NULL AS isMain  -- Склад ГП ф.Одесса
                -- UNION SELECT 346094  AS UnitId, NULL AS isMain  -- Склад возвратов ф.Одесса

                UNION SELECT tmp.UnitId, NULL AS isMain FROM lfSelect_Object_Unit_byGroup (8446) AS tmp -- ЦЕХ колбаса+дел-сы
                UNION SELECT tmp.UnitId, NULL AS isMain FROM lfSelect_Object_Unit_byGroup (8454) AS tmp -- Склад специй и запчастей

                UNION */SELECT tmp.UnitId, NULL AS isMain FROM lfSelect_Object_Unit_byGroup (8432) AS tmp -- 30000 - Общепроизводственные
               )
       -- tmpUnit AS (SELECT tmp.UnitId, NULL AS isMain FROM lfSelect_Object_Unit_byGroup (8439) AS tmp) -- 31050 - Участок мясного сырья
       -- tmpUnit AS (SELECT tmp.UnitId, NULL AS isMain FROM lfSelect_Object_Unit_byGroup (8459) AS tmp) -- 32022 - Склад Реализации
     , tmpUnit_pack AS (SELECT 8451 AS UnitId, NULL AS isMain  -- Цех Упаковки
                  UNION SELECT 8450 AS UnitId, NULL AS isMain  -- ЦЕХ копчения
                       )
     , tmpUnit_branch AS (SELECT ObjectLink.ObjectId AS UnitId, NULL AS isMain
                               , Object_Branch.ObjectCode AS BranchCode
                               , Object_Branch.ValueData  AS BranchName
                          FROM ObjectLink
                               LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink.ChildObjectId
                          WHERE  ObjectLink.DescId = zc_ObjectLink_Unit_Branch()
                             AND ObjectLink.ChildObjectId > 0
                             AND ObjectLink.ChildObjectId <> zc_Branch_Basis()
                             AND (inGroupId < 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы
                               OR inGroupId = 0
                               OR inGroupId = 4
                               OR (inGroupId = 1 AND ObjectLink.ChildObjectId IN (8379     -- филиал Киев
                                                                              --, 3080683  -- филиал Львов
                                                                                 )
                                  )
                               OR (inGroupId = 2 AND ObjectLink.ChildObjectId IN (--8373     -- филиал Николаев (Херсон)
                                                                                  8374     -- филиал Одесса
                                                                                 )
                                  )
                               OR (inGroupId = 3 AND ObjectLink.ChildObjectId NOT IN (8379     -- филиал Киев
                                                                                  --, 3080683  -- филиал Львов
                                                                                  --, 8373     -- филиал Николаев (Херсон)
                                                                                    , 8374     -- филиал Одесса
                                                                                     )
                                  ))
                             -- AND ObjectLink.ChildObjectId = 8379       -- филиал Киев
                             -- AND ObjectLink.ChildObjectId = 3080683    -- филиал Львов
                             -- AND ObjectLink.ChildObjectId = 8374       -- филиал Одесса
                        /*SELECT 301309 AS UnitId, NULL AS isMain  -- Склад ГП ф.Запорожье
                    UNION SELECT 309599 AS UnitId, NULL AS isMain  -- Склад возвратов ф.Запорожье
                    UNION SELECT 346093  AS UnitId, NULL AS isMain  -- Склад ГП ф.Одесса
                    UNION SELECT 346094  AS UnitId, NULL AS isMain  -- Склад возвратов ф.Одесса

                    UNION SELECT 8413 AS UnitId, NULL AS isMain  -- Склад ГП ф.Кривой Рог
                    UNION SELECT 428366 AS UnitId, NULL AS isMain  -- Склад возвратов ф.Кривой Рог

                    UNION SELECT 8411 AS UnitId, NULL AS isMain  -- Склад ГП ф.Киев
                    UNION SELECT 428365 AS UnitId, NULL AS isMain  -- Склад возвратов ф.Киев

                    UNION SELECT 8415 AS UnitId, NULL AS isMain  -- Склад ГП ф.Черкассы (Кировоград)
                    UNION SELECT 428363 AS UnitId, NULL AS isMain  -- Склад возвратов ф.Черкассы (Кировоград)

                    UNION SELECT 8417 AS UnitId, NULL AS isMain  -- Склад ГП ф.Николаев (Херсон)
                    UNION SELECT 428364 AS UnitId, NULL AS isMain  -- Склад возвратов ф.Николаев (Херсон)

                    UNION SELECT 8425 AS UnitId, NULL AS isMain  -- Склад ГП ф.Харьков
                    UNION SELECT 409007 AS UnitId, NULL AS isMain  -- Склад возвратов ф.Харьков*/
                   )
     -- , tmp1 AS (SELECT DISTINCT HistoryCost.ContainerId FROM HistoryCost WHERE ('01.04.2016' BETWEEN StartDate AND EndDate) AND ABS (Price) = 1.1234 AND CalcSumm > 1000000)
     -- , tmp_err AS (SELECT DISTINCT MovementItemContainer.MovementId FROM tmp1 INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = tmp1.ContainerId AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate)

     , tmpContainer AS (SELECT 1250361 AS ContainerId
                       UNION
                        SELECT 1736845 AS ContainerId
                       )
     , tmpGoodsContainer AS (/*SELECT DISTINCT CLO.ObjectId AS GoodsId
                               FROM tmpContainer
                                    INNER JOIN ContainerLinkObject AS CLO
                                                                   ON CLO.ContainerId = tmpContainer.ContainerId
                                                                 AND CLO.DescId       = zc_ContainerLinkObject_Goods()*/
                             SELECT 5662  AS GoodsId
                            UNION
                             SELECT 3902   AS GoodsId
                            UNION
                             SELECT 607384   AS GoodsId
                            UNION
                             SELECT 1076606   AS GoodsId

--                             SELECT 8296254   AS GoodsId -- 94183
--                             SELECT 2365   AS GoodsId -- 135
                            )
            /*, tmp_new as  (SELECT CLO.ContainerId FROM ContainerLinkObject AS CLO
                           WHERE CLO.DescId  = zc_ContainerLinkObject_Goods() AND CLO.ObjectId IN (4077)
                          )

     , tmpMovContainer AS (SELECT DISTINCT Movement.Id AS MovementId
                           FROM Movement
                                --INNER JOIN MovementItem  ON MovementItem.MovementId = Movement.Id
                                --                        AND MovementItem.isErased   = FALSE
                                -- INNER JOIN tmpGoodsContainer  ON tmpGoodsContainer.GoodsId = MovementItem.ObjectId
                                INNER JOIN MovementItemContainer  ON MovementItemContainer.MovementId = Movement.Id
                                                                 AND MovementItemContainer.ContainerId IN (SELECT DISTINCT tmp_new.ContainerId FROM tmp_new)
-- !!!
--AND MovementItemContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ReturnIn()
--                                           , zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Inventory(), zc_Movement_Sale())
--!!!

                           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                          )*/

     , tmpInv_main AS (
                       -- 1.1. From: Sale + !!!NOT SendOnPrice!!!
                       SELECT DISTINCT tmpUnit_from.UnitId
                       FROM Movement
                            LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                                    AND MLO_From.DescId = zc_MovementLinkObject_From()
                            LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId

                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset()) -- , zc_Movement_SendOnPrice()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND (tmpUnit_from.UnitId > 0
                           OR Movement.DescId = zc_Movement_SaleAsset()
                             )
                         AND 1=0

                      UNION
                       -- 1.3. To: ReturnIn
                       SELECT tmpUnit_To.UnitId
                       FROM Movement
                            LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                                  AND MLO_To.DescId = zc_MovementLinkObject_To()
                            LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId
                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.DescId IN (zc_Movement_ReturnIn())
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND tmpUnit_To.UnitId > 0
                         AND 1=0
                      )

     -- Результат
     SELECT tmp.MovementId
          , tmp.OperDate
          , (tmp.InvNumber || ' - ' || CASE WHEN tmp.BranchCode IN (1)     THEN tmp.BranchCode
                                            WHEN tmp.BranchCode IN (2, 12) THEN tmp.BranchCode + 100
                                            ELSE COALESCE (tmp.BranchCode, 0) + 1000
                                       END :: TVarChar) :: TVarChar AS InvNumber
          , tmp.Code
          , tmp.ItemName
          , CASE WHEN tmp.BranchCode IN (1)     THEN tmp.BranchCode
                 WHEN tmp.BranchCode IN (2, 12) THEN tmp.BranchCode + 100
                 ELSE tmp.BranchCode + 1000
            END :: Integer AS BranchCode
          , tmp.BranchName
          , Movement.DescId AS MovementDescId
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM (
     -- 1.0. zc_Movement_IncomeCost
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_IncomeCost())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inGroupId <= 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы

    UNION
     -- 1.0. zc_Movement_Income
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
          INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                   AND MLO_From.DescId = zc_MovementLinkObject_From()
          INNER JOIN Object AS Object_From ON Object_From.Id     = MLO_From.ObjectId
                                          AND Object_From.DescId = zc_Object_Unit()
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Income())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inGroupId <= 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы

    UNION
     -- 1.1. From: Sale + !!!NOT SendOnPrice!!!
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset()) -- , zc_Movement_SendOnPrice()
       AND Movement.StatusId = zc_Enum_Status_Complete()
       -- !!!здесь второй раз!!!
       AND inIsBefoHistoryCost = FALSE
       --
       AND (tmpUnit_from.UnitId > 0
         OR Movement.DescId = zc_Movement_SaleAsset()
       --OR tmpUnit_To.UnitId > 0
           )

       -- AND inGroupId = 4 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы

       -- *** 1.работает вся продажа - если текущий период
       AND inGroupId <= 0

       -- *** 2.отдельно РК - если прошлый период
       /*AND ((inGroupId = 4 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы
         AND Object_From.Id = 8459 -- Розподільчий комплекс
            )
         OR (inGroupId <= 0
         AND Object_From.Id <> 8459 -- Розподільчий комплекс
            )
           )*/

       -- AND Object_From.Id in (8459, 8462, 8461, 256716, 1387416) -- Розподільчий комплекс + Склад Брак + Склад Возвратов + Склад УТИЛЬ + Склад Утиль-сроки
       -- AND Object_From.Id <> 8459 -- Розподільчий комплекс

       -- !!!НУЖНЫ ли ПРОДАЖИ!!!
       AND (vbIsSale = TRUE OR Movement.DescId = zc_Movement_SaleAsset())

    UNION
     -- 1.2. From: Loss
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN tmpUnit        AS tmpUnit_from        ON tmpUnit_from.UnitId        = MLO_From.ObjectId
          LEFT JOIN tmpUnit_branch AS tmpUnit_branch_from ON tmpUnit_branch_from.UnitId = MLO_From.ObjectId

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Loss(), zc_Movement_LossAsset())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
       -- AND (tmpUnit_from.UnitId > 0)
       AND (tmpUnit_branch_from.UnitId IS NULL OR Movement.DescId = zc_Movement_LossAsset())
       AND inGroupId <= 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы

    UNION
     -- 1.3. To: ReturnIn
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_ReturnIn())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       -- !!!здесь второй раз!!!
       AND inIsBefoHistoryCost = FALSE
       --
       AND (tmpUnit_To.UnitId > 0)

       -- здесь все для inGroupId = 4
       -- AND inGroupId = 4 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы

       -- *** 1.здесь ВСЕ для inGroupId = 0 - если текущий период
       AND inGroupId <= 0


       -- *** 2.здесь отдельно для inGroupId = 4 остальное для inGroupId = 0 - если прошлый период
       /*AND ((inGroupId = 4
         AND Object_To.Id IN (8459, 8462, 8461, 256716, 1387416) -- Розподільчий комплекс + Склад Брак + Склад Возвратов + Склад УТИЛЬ + Склад Утиль-сроки
            )
         OR (inGroupId <= 0
         AND Object_To.Id NOT IN (8459, 8462, 8461, 256716, 1387416) -- Розподільчий комплекс + Склад Брак + Склад Возвратов + Склад УТИЛЬ + Склад Утиль-сроки
            )
           )*/

       -- AND 1=0
       -- AND Object_To.Id

       -- !!!НУЖНЫ ли ВОЗВРАТЫ!!!
       AND vbIsReturnIn = TRUE

    UNION
     -- 1.4. From: ReturnOut
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_ReturnOut())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
       AND (tmpUnit_from.UnitId > 0)
       AND inGroupId <= 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы

     -- !!!Internal - PACK!!!
    UNION
     -- 1.5. Send + ProductionUnion
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          LEFT JOIN tmpUnit_pack AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit_pack AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion())
       AND inIsBefoHistoryCost = FALSE
       AND (tmpUnit_from.UnitId > 0 AND tmpUnit_To.UnitId IS NULL)
     --AND ((tmpUnit_from.UnitId > 0 AND tmpUnit_To.UnitId IS NULL AND Movement.DescId = zc_Movement_Send())
     --  OR (tmpUnit_from.UnitId > 0 AND Movement.DescId = zc_Movement_ProductionUnion()))
       AND inGroupId <= 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы

     -- !!!Internal!!!
    UNION
     -- 2.1. Send + ProductionUnion + ProductionSeparate
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId
          LEFT JOIN tmpUnit_pack AS tmpUnit_pack_from ON tmpUnit_pack_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit_pack As tmpUnit_pack_To ON tmpUnit_pack_To.UnitId = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
       -- AND inIsBefoHistoryCost = TRUE -- !!!***
       -- AND tmpUnit_pack_from.UnitId IS NULL AND tmpUnit_pack_To.UnitId IS NULL -- !!!***
       AND inGroupId <= 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы

    UNION
     -- 2.2. !!!Internal - SendOnPrice!!!
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId

          LEFT JOIN tmpUnit_branch ON tmpUnit_branch.UnitId = MLO_From.ObjectId

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_SendOnPrice())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       -- AND inIsBefoHistoryCost = TRUE -- !!!***
       --***** AND (tmpUnit_from.UnitId > 0 OR tmpUnit_To.UnitId > 0)
       AND tmpUnit_branch.UnitId IS NULL
       AND inGroupId <= 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы

    UNION
     -- 3. !!!Inventory!!!
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , tmpUnit_branch.BranchCode
          , tmpUnit_branch.BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT  JOIN tmpUnit_branch ON tmpUnit_branch.UnitId = MLO_From.ObjectId

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.DescId IN (zc_Movement_Inventory())
    -- AND inIsBefoHistoryCost = FALSE
       AND (inGroupId < 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы
         OR (inGroupId = 0 AND tmpUnit_branch.UnitId IS NULL)
         OR (inGroupId > 0 AND tmpUnit_branch.UnitId IS NOT NULL)
           )
       AND inGroupId <> 4


     -- !!!BRANCH!!!
    UNION
     -- 4.1. From: Sale + SendOnPrice
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , tmpUnit_branch.BranchCode
          , tmpUnit_branch.BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          INNER JOIN tmpUnit_branch ON tmpUnit_branch.UnitId = MLO_From.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
       --*** AND (inIsSale           = TRUE OR Movement.DescId = zc_Movement_SendOnPrice())
       AND inGroupId <> 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы
       AND inGroupId <> 4
       -- !!!НУЖНЫ ли ПРОДАЖИ!!!
       AND (vbIsSale = TRUE OR Movement.DescId = zc_Movement_SendOnPrice())

    UNION
     -- 4.2. From: Loss
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , tmpUnit_branch.BranchCode
          , tmpUnit_branch.BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          INNER JOIN tmpUnit_branch ON tmpUnit_branch.UnitId = MLO_From.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Loss())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
       AND inGroupId <> 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы
       AND inGroupId <> 4

    UNION
     -- 4.3. To: ReturnIn
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , tmpUnit_branch.BranchCode
          , tmpUnit_branch.BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          INNER JOIN tmpUnit_branch ON tmpUnit_branch.UnitId = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_ReturnIn())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE -- *****?????
       AND inGroupId <> 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы
       AND inGroupId <> 4
       -- !!!НУЖНЫ ли ВОЗВРАТЫ!!!
       AND vbIsReturnIn = TRUE

    UNION
     -- 4.4. To: Peresort
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , tmpUnit_branch_from.BranchCode
          , tmpUnit_branch_from.BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          INNER JOIN tmpUnit_branch AS tmpUnit_branch_from ON tmpUnit_branch_from.UnitId = MLO_From.ObjectId
          INNER JOIN tmpUnit_branch AS tmpUnit_branch_to ON tmpUnit_branch_to.UnitId = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_ProductionUnion())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       -- AND inIsBefoHistoryCost = TRUE -- *****
       AND inGroupId <> 0 -- -1:Все 0+4:ф.Днепр 1:ф.Киев 2+3:остальные филиалы
       AND inGroupId <> 4
       AND inGroupId <> -1

/*
     -- !!!Inventory!!!
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  AS BranchCode
          , '' AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          INNER JOIN tmpInv_main ON tmpInv_main.UnitId = MLO_From.ObjectId

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.DescId IN (zc_Movement_Inventory())
*/

/*     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          JOIN MovementLinkMovement on MovementLinkMovement.MovementChildId = Movement.Id AND MovementLinkMovement.Descid = zc_MovementLinkMovement_Production()
          JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
        --JOIN Movement AS Movement2 ON Movement2.Id       = MovementLinkMovement.MovementId
        --                          AND Movement2.StatusId = zc_Enum_Status_UnComplete()

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_Loss(), zc_Movement_SendOnPrice())
       AND Movement.StatusId = zc_Enum_Status_Complete()
*/

    ) AS tmp
    LEFT JOIN Movement ON Movement.Id = tmp.MovementId
    LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

    --INNER JOIN tmpMovContainer ON tmpMovContainer.MovementId = tmp.MovementId

    -- WHERE tmp.MovementId >= 2212722 OR tmp.Code = 'zc_Movement_Inventory'
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.11.14                                        *
*/
/*
create table dba._pgMovementReComlete
     MovementId integer
    ,OperDate date
    ,InvNumber TVarCharMedium
    ,Code  TVarCharMedium
    ,ItemName TVarCharMedium
 ,primary key (MovementId)
*/
/*
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM (SELECT MovementItemContainer.MovementId
           FROM Container
                INNER JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                               ON ContainerLO_ProfitLoss.ContainerId = Container.Id
                                              AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                              AND ContainerLO_ProfitLoss.ObjectId = 0
                INNER JOIN MovementItemContainer
                        ON MovementItemContainer.ContainerId = Container.Id
                       AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
           WHERE Container.ObjectId = zc_Enum_Account_100301() -- прибыль текущего периода
           GROUP BY MovementItemContainer.MovementId
          ) AS tmp
          LEFT JOIN Movement ON Movement.Id = tmp.MovementId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
*/
-- тест
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.03.2019', inEndDate:= '31.03.2019', inIsSale:= TRUE, inIsBefoHistoryCost:= TRUE, inGroupId:= -1)
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.03.2019', inEndDate:= '31.03.2019', inIsSale:= TRUE, inIsBefoHistoryCost:= FALSE, inGroupId:= -1)
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.06.2019', inEndDate:= '30.06.2019', inIsSale:= TRUE, inIsBefoHistoryCost:= TRUE, inGroupId:= -1)
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.12.2024', inEndDate:= '31.12.2024', inIsSale:= TRUE, inIsBefoHistoryCost:= TRUE, inGroupId:= 0)
