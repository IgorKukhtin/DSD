-- Function: gpComplete_SelectAll_Sybase()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase (TDateTime, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
    IN inIsBefoHistoryCost  Boolean
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
     WITH tmpUnit AS (SELECT 8411 AS UnitId, FALSE AS isMain -- Склад гп ф.Киев
                UNION SELECT 8413 AS UnitId, FALSE AS isMain  -- ф. Кр.Рог
                UNION SELECT 8415 AS UnitId, FALSE AS isMain  -- ф. Черкассы ( Кировоград)
                UNION SELECT 8417 AS UnitId, FALSE AS isMain  -- ф. Николаев (Херсон)
                UNION SELECT 8421 AS UnitId, FALSE AS isMain  -- ф. Донецк
                UNION SELECT 8425 AS UnitId, FALSE AS isMain  -- ф. Харьков
                UNION SELECT 301309 AS UnitId, FALSE AS isMain  -- Склад ГП ф.Запорожье
                UNION SELECT 18341 AS UnitId, FALSE AS isMain  -- ф. Никополь
                UNION SELECT 8419 AS UnitId, FALSE AS isMain  -- ф. Крым
                UNION SELECT 8423 AS UnitId, FALSE AS isMain  -- ф. Одесса

                UNION SELECT Id AS UnitId, TRUE AS isMain FROM Object WHERE DescId = zc_Object_Unit() AND ObjectCode IN (31053, 31055, 31056, 31057  -- +,+ 31053 - Участок Бойни +,+ 31055 Склад МИНУСОВКА +,+ 31056 Склад ОХЛАЖДЕНКА +,+ 31057 Склад реализации мясо
                                                                                                                       , 32031, 32032, 32033 --  +,- 32031 - Склад Возвратов +,- 32032 - Склад Брак +,- 32033 - Склад УТИЛЬ
                                                                                                                       , 32022 -- Склад реализации
                                                                                                                        )
               )
     -- 1. From: Sale + SendOnPrice
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM Movement
          JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                             AND MLO_From.DescId = zc_MovementLinkObject_From()
          -- !!! JOIN tmpUnit ON tmpUnit.UnitId = MLO_From.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
    UNION
     -- 2. From: Loss
     /*SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM Movement
          JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                             AND MLO_From.DescId = zc_MovementLinkObject_From()
          -- !!! JOIN tmpUnit ON tmpUnit.UnitId = MLO_From.ObjectId AND isMain = FALSE
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Loss())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
    UNION*/
     -- 3. To: ReturnIn
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM Movement
          JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
          -- !!! JOIN tmpUnit ON tmpUnit.UnitId = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_ReturnIn())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
    UNION
     -- 4. To: SendOnPrice
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM Movement
          JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
          -- !!! JOIN tmpUnit ON tmpUnit.UnitId = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_SendOnPrice())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE -- !!!!!!!
    UNION
     -- 5. From: ReturnOut
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM Movement
          JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                             AND MLO_From.DescId = zc_MovementLinkObject_From()
          -- !!! JOIN tmpUnit ON tmpUnit.UnitId = MLO_From.ObjectId AND isMain = TRUE
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_ReturnOut())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
     -- !!!Internal!!!
    UNION
     -- 5. Send + ProductionUnion + ProductionSeparate
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM Movement
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
       AND Movement.StatusId = zc_Enum_Status_Complete()
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
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inIsBefoHistoryCost:= FALSE)
