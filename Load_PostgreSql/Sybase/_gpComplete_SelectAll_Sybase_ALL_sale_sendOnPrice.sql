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
     -- Результат
          /*, tmp_new as  (with tmp_1 AS (SELECT Container.*
                                          FROM Container
                                               INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                              ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                                             AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                             AND ContainerLinkObject_Unit.ObjectId IN (zc_Unit_RK(), 8451, 8458, 8450) -- ЦЕХ пакування + Склад База ГП + Дільниця термічної обробки
                                                                             --AND ContainerLinkObject_Unit.ObjectId IN (8451) -- 8447
                                                                           --AND ContainerLinkObject_Unit.ObjectId IN (select ObjectId from ObjectLink where DescId = zc_ObjectLink_Unit_Parent() AND ChildObjectId = 8460) -- Возвраты общие
                                          WHERE Container.DescId = zc_Container_Count()
                                            AND Container.ObjectId in (3569176  -- 953
                                                                     , 4026174  -- 202 + 4457
                                                                     , 3902     -- 2269
                                                                     , 4507487  -- 1716
                                                                     , 10442610 -- 2489
                                                                      )
                                         )
                              , tmp_2 AS (SELECT Container.*
                                          FROM Container
                                          WHERE Container.DescId = zc_Container_Summ()
                                            AND Container.ParentId in (SELECT tmp_1.Id FROM tmp_1)
                                         )
                          SELECT tmp_2.Id AS ContainerId
                          FROM tmp_2
                          )
*/                          
     , tmpMovContainer AS (SELECT DISTINCT Movement.Id AS MovementId
                                                     FROM Movement
                                                          --INNER JOIN MovementItem  ON MovementItem.MovementId = Movement.Id
                                                          --                        AND MovementItem.isErased   = FALSE
                                                          -- INNER JOIN tmpGoodsContainer  ON tmpGoodsContainer.GoodsId = MovementItem.ObjectId
                                                          INNER JOIN MovementItemContainer  ON MovementItemContainer.MovementId = Movement.Id
                                                                                           AND MovementItemContainer.ContainerId IN
(
200197,
6477731
--SELECT DISTINCT tmp_new.ContainerId FROM tmp_new
)
                          -- !!!
                         -- AND MovementItemContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ReturnIn())
                          --!!!
                          
                                                     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                                    )
  /*   , tmpMovContainer AS (SELECT DISTINCT Movement.*
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                                         AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                                         AND MLO_From.ObjectId   = zc_Unit_RK()
                                INNER JOIN MovementItem  ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     IN (zc_MI_Master(), zc_MI_Child())
                                                        AND MovementItem.isErased   = FALSE
                                                        AND MovementItem.ObjectId   IN (3169    -- 534 Ковбаса С/К УКРАЇНСЬКА в/г ТМ Ашан
                                                                                      , 658379  -- 944 Ковбаса С/К БРАУНШВЕЙГСЬКА в/ґ ТМ Хіт продукт
                                                                                      , 426182  -- 2230 Ковбаса С/К ЗЕРНИСТА в/ґ 370 г/шт ТМ Алан
                                                                                      , 2651    -- 173 Ковбаса С/К ЗЕРНИСТА в/ґ ТМ Алан
                                                                                      , 7836    -- 275 Ковбаса С/К СЕРВЕЛАТ в/ґ ТМ Премія
                                                                                       )

                           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND Movement.DescId   IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_Inventory(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Sale())
                          )
*/
   /*, tmpGoods AS (select GoodsId, GoodsKindId
                  from gpSelect_Object_GoodsByGoodsKind( inSession := '5') AS gpSelect
                  where (GoodsKindName ilike 'нар. 200' or GoodsKindName ilike 'нар. 180' or GoodsKindName ilike 'нар. 150')
                    and isOrder = true
                 )*/
     -- 
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
       -- 1.1. From: Sale + !!!SendOnPrice!!!
     SELECT distinct Movement.Id AS MovementId
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

          /*JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.isErased   = FALSE
          JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
          JOIN tmpGoods ON tmpGoods.GoodsId     = MovementItem.ObjectId
                       AND tmpGoods.GoodsKindId = MILinkObject_GoodsKind.ObjectId*/

  /*     join  MovementLinkMovement
                    on MovementLinkMovement.MovementChildId = Movement.Id
                      AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Production()
                      and MovementLinkMovement.MovementId > 0 */

          -- INNER JOIN tmpMovContainer ON tmpMovContainer.MovementId = Movement.Id

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
--      AND Movement.DescId IN (zc_Movement_Loss())
--      AND Movement.DescId IN (zc_Movement_Send())
        AND Movement.DescId IN (zc_Movement_SendOnPrice())
--      AND Movement.DescId IN (zc_Movement_Sale())
--      AND Movement.DescId IN (zc_Movement_Inventory(), zc_Movement_SendOnPrice(), zc_Movement_Loss(), zc_Movement_Sale())
       -- AND Movement.DescId IN (zc_Movement_Inventory())
       -- AND Movement.DescId IN (zc_Movement_ReturnIn())
--      AND Movement.DescId IN (zc_Movement_ProductionUnion())
--      AND Movement.DescId IN (zc_Movement_SendOnPrice())
       AND Movement.StatusId = zc_Enum_Status_Complete()
--       AND (MLO_To.ObjectId = zc_Unit_RK())
       AND MLO_From.ObjectId = zc_Unit_RK()
    --   AND MLO_To.ObjectId IN (zc_Unit_RK(), 8462 , 8461, 256716, 1387416)


    ) AS tmp
    LEFT JOIN Movement ON Movement.Id = tmp.MovementId
    LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId


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
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.08.2023', inEndDate:= '31.08.2023', inIsSale:= TRUE, inIsBefoHistoryCost:= FALSE, inGroupId:= 0)
