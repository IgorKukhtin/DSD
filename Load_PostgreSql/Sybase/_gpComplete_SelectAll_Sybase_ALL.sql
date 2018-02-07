-- Function: gpComplete_SelectAll_Sybase_ALL()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase (TDateTime, TDateTime, Boolean, Boolean);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
    IN inIsSale             Boolean   , -- 
    IN inIsBefoHistoryCost  Boolean
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar
              )
AS
$BODY$
BEGIN

-- inIsBefoHistoryCost:= TRUE;

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
                          FROM ObjectLink
                          WHERE  ObjectLink.DescId = zc_ObjectLink_Unit_Branch()
                             AND ObjectLink.ChildObjectId > 0 
                             AND ObjectLink.ChildObjectId <> zc_Branch_Basis()
                             -- AND ObjectLink.ChildObjectId = 8379 -- филиал Киев
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

     -- Результат
     SELECT tmp.MovementId
          , tmp.OperDate
          , tmp.InvNumber
          , tmp.Code
          , tmp.ItemName
     FROM (
     -- 1.1. From: Sale + !!!NOT SendOnPrice!!!
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
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
       AND Movement.DescId IN (zc_Movement_Sale()) -- , zc_Movement_SendOnPrice()
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
       --*** AND inIsSale            = TRUE
       AND (tmpUnit_from.UnitId > 0/* OR tmpUnit_To.UnitId > 0*/)

    UNION
     -- 1.2. From: Loss
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
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
       AND Movement.DescId IN (zc_Movement_Loss())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
       -- AND (tmpUnit_from.UnitId > 0)

    UNION
     -- 1.3. To: ReturnIn
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
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
       AND inIsBefoHistoryCost = FALSE
       AND (tmpUnit_To.UnitId > 0)

    UNION
     -- 1.4. From: ReturnOut
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
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

     -- !!!Internal - PACK!!!
    UNION
     -- 1.5. Send + ProductionUnion
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
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
       /*AND ((tmpUnit_from.UnitId > 0 AND tmpUnit_To.UnitId IS NULL AND Movement.DescId = zc_Movement_Send())
         OR (tmpUnit_from.UnitId > 0 AND Movement.DescId = zc_Movement_ProductionUnion())
           )*/

     -- !!!Internal!!!
    UNION
     -- 2.1. Send + ProductionUnion + ProductionSeparate
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
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
       AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
       -- AND inIsBefoHistoryCost = TRUE -- !!!***
       -- AND tmpUnit_pack_from.UnitId IS NULL AND tmpUnit_pack_To.UnitId IS NULL -- !!!***

    UNION
     -- 2.2. !!!Internal - SendOnPrice!!!
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
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
       AND Movement.DescId IN (zc_Movement_SendOnPrice())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       -- AND inIsBefoHistoryCost = TRUE -- !!!***
       --***** AND (tmpUnit_from.UnitId > 0 OR tmpUnit_To.UnitId > 0)

    UNION
     -- 3. !!!Inventory!!!
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.DescId IN (zc_Movement_Inventory())
       -- AND inIsBefoHistoryCost = FALSE


     -- !!!BRANCH!!!
    UNION
     -- 4.1. From: Sale + SendOnPrice
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
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
    UNION
     -- 4.2. From: Loss
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
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
    UNION
     -- 4.3. To: ReturnIn
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
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
    UNION
     -- 4.4. To: Peresort
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
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
    ) AS tmp
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
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.01.2017', inEndDate:= '31.01.2017', inIsSale:= TRUE, inIsBefoHistoryCost:= TRUE)
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.01.2017', inEndDate:= '31.01.2017', inIsSale:= TRUE, inIsBefoHistoryCost:= FALSE)
