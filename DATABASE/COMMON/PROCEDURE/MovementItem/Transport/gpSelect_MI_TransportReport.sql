-- Function: gpSelect_MI_TransportReport (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MI_TransportReport (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_TransportReport(
    IN inMovementId    Integer      , -- Ключ Master <Документ>
    IN inShowAll     Boolean      , -- 
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (StatusId Integer, StatusCode Integer, StatusName TVarChar
             , KindName TVarChar
             , Amount_20401 TFloat
             , Amount_Start TFloat, Amount_In TFloat, Amount_Out TFloat, Amount_End TFloat
              )
AS
$BODY$
  DECLARE vbOperDate TDateTime;
  DECLARE vbStatusId Integer;
  DECLARE vbCarId Integer;
  DECLARE vbPersonalId Integer;
  DECLARE vbMemberId Integer;
BEGIN

     -- параметры из путевого
     SELECT OperDate, Movement.StatusId INTO vbOperDate, vbStatusId FROM Movement WHERE Id = inMovementId AND DescId = zc_Movement_Transport();
     vbCarId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Car());
     vbPersonalId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PersonalDriver());
     vbMemberId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbPersonalId AND DescId = zc_ObjectLink_Personal_Member());

     --
     RETURN QUERY 
       SELECT
             tmpAll.StatusId
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , CAST (tmpKind.KindName AS TVarChar) AS KindName

           , CAST (tmpAll.Amount_20401 AS TFloat) AS Amount_20401
           , CAST (tmpAll.Amount_Start AS TFloat) AS Amount_Start
           , CAST (tmpAll.Amount_In    AS TFloat) AS Amount_In
           , CAST (tmpAll.Amount_Out   AS TFloat) AS Amount_Out
           , CAST (tmpAll.Amount_End   AS TFloat) AS Amount_End

             -- 1. Денежные средства
       FROM (SELECT -1 AS KindId
                  , tmpMemberMoney.StatusId
                  , SUM (tmpMemberMoney.Amount_20401) AS Amount_20401
                  , SUM (tmpMemberMoney.Amount_Start) AS Amount_Start
                  , SUM (tmpMemberMoney.Amount_In)    AS Amount_In
                  , SUM (tmpMemberMoney.Amount_Out)   AS Amount_Out
                  , SUM (tmpMemberMoney.Amount_Start + tmpMemberMoney.Amount_In - tmpMemberMoney.Amount_Out) AS Amount_End

                   -- Проводки суммовые - Приход денег Автомобиль(Подотчет) !!!это документ - Расход денег с подотчета на подотчет!!!
             FROM (SELECT zc_Enum_Status_Complete() AS StatusId
                        , 0 AS Amount_Start
                        , SUM (MIContainer.Amount) AS Amount_In
                        , 0 AS Amount_Out
                        , 0 AS Amount_20401
                   FROM Movement
                        JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.MovementId = Movement.Id
                                                  AND MIContainer.DescId = zc_MIContainer_Summ()
                        JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                                 ON ContainerLinkObject_Car.ContainerId = MIContainer.ContainerId
                                                AND ContainerLinkObject_Car.DescId      = zc_ContainerLinkObject_Car()
                                                AND ContainerLinkObject_Car.ObjectId    = vbCarId
                        JOIN ContainerLinkObject AS ContainerLinkObject_Member
                                                 ON ContainerLinkObject_Member.ContainerId = MIContainer.ContainerId
                                                AND ContainerLinkObject_Member.DescId      = zc_ContainerLinkObject_Member()
                                                AND ContainerLinkObject_Member.ObjectId    = vbMemberId
                        JOIN Container ON Container.Id = MIContainer.ContainerId
                                                                 -- Ограничили списком счетов: (30500) Дебиторы + сотрудники (подотчетные лица) + (20400) Общефирменные + ГСМ
                                      AND Container.ObjectId IN (SELECT AccountId FROM Object_Account_View WHERE AccountDirectionId = zc_Enum_AccountDirection_30500() AND InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400())
                                      AND Container.DescId = zc_Container_Summ()
                   WHERE Movement.OperDate = vbOperDate
                     AND Movement.DescId = zc_Movement_PersonalSendCash()
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                  UNION ALL
                   -- Проводки суммовые - Списание денег на Автомобиль(Подотчет) !!!это документ - Расход денег с подотчета на подотчет!!!
                   SELECT zc_Enum_Status_Complete() AS StatusId
                        , 0 AS Amount_Start
                        , 0 AS Amount_In
                        , 0 AS Amount_Out
                        , -1 * SUM (MIContainer.Amount) AS Amount_20401
                   FROM Movement
                        JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.MovementId = Movement.Id
                                                  AND MIContainer.DescId = zc_MIContainer_Summ()
                        JOIN MovementItemLinkObject AS MILinkObject_Car
                                                    ON MILinkObject_Car.MovementItemId = MIContainer.MovementItemId
                                                   AND MILinkObject_Car.DescId         = zc_ContainerLinkObject_Car()
                                                   AND MILinkObject_Car.ObjectId       = vbCarId
                        JOIN MovementItem AS MI ON MI.Id = MIContainer.MovementItemId
                                               AND MI.ObjectId = vbCarId
                   WHERE Movement.OperDate = vbOperDate
                     AND Movement.DescId = zc_Movement_PersonalSendCash()
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                  UNION ALL
                   -- Элементы не проведенные - Приход+Списание денег на Автомобиль(Подотчет) !!!это документ - Расход денег с подотчета на подотчет!!!
                   SELECT Movement.StatusId
                        , 0 AS Amount_Start
                        , SUM (CASE WHEN MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_21201() THEN MovementItem.Amount ELSE 0 END) AS Amount_In
                        , 0 AS Amount_Out
                        , SUM (CASE WHEN MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_20401() THEN MovementItem.Amount ELSE 0 END) AS Amount_20401
                   FROM Movement
                        JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.ObjectId   = vbPersonalId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                        JOIN MovementItemLinkObject AS MILinkObject_Car
                                                    ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Car.DescId         = zc_MILinkObject_Car()
                                                   AND MILinkObject_Car.ObjectId       = vbCarId
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                         ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                   WHERE Movement.OperDate = vbOperDate
                     AND Movement.DescId = zc_Movement_PersonalSendCash()
                     AND Movement.StatusId = zc_Enum_Status_UnComplete()
                   GROUP BY Movement.StatusId
                  UNION ALL
                   -- Начальный остаток денег Автомобиль(Подотчет) !!!это документ - Путевой лист!!!
                   SELECT vbStatusId AS StatusId
                        , MovementFloat.ValueData AS Amount_Start
                        , 0 AS Amount_In
                        , 0 AS Amount_Out
                        , 0 AS Amount_20401
                   FROM MovementFloat
                   WHERE DescId = zc_MovementFloat_StartSummCash()
                     AND MovementId = inMovementId
                  UNION ALL
                   -- Проводки суммовые - Расход денег Автомобиль (Подотчет) !!!это документ - Приход от поставщика (Заправка авто) !!!
                   SELECT zc_Enum_Status_Complete() AS StatusId
                        , 0 AS Amount_Start
                        , 0 AS Amount_In
                        , -1 * SUM (MIContainer.Amount) AS Amount_Out
                        , 0 AS Amount_20401
                   FROM Movement
                        JOIN MovementItemContainer AS MIContainer ON MIContainer.MovementId = Movement.Id
                        JOIN Container ON Container.Id = MIContainer.ContainerId
                                                                 -- Ограничили списком счетов: (30500) Дебиторы + сотрудники (подотчетные лица) + (20400) Общефирменные + ГСМ
                                      AND Container.ObjectId IN (SELECT AccountId FROM Object_Account_View WHERE AccountDirectionId = zc_Enum_AccountDirection_30500() AND InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400())
                                      AND Container.DescId = zc_Container_Summ()
                   WHERE Movement.ParentId = inMovementId
                     AND Movement.DescId = zc_Movement_Income()
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                   HAVING SUM (MIContainer.Amount) <> 0 

                  ) AS tmpMemberMoney
             GROUP BY tmpMemberMoney.StatusId

            UNION ALL
             -- 2. Топливо
             SELECT tmpFuel.FuelId AS KindId
                  , tmpFuel.StatusId
                  , 0 AS Amount_20401
                  , SUM (tmpFuel.Amount_Start) AS Amount_Start
                  , SUM (tmpFuel.Amount_In)    AS Amount_In
                  , SUM (tmpFuel.Amount_Out)   AS Amount_Out
                  , SUM (tmpFuel.Amount_Start + tmpFuel.Amount_In - tmpFuel.Amount_Out) AS Amount_End

                   -- Проводки количественные или Элементы - Приход Топливо !!!это документ - Приход от поставщика (Заправка авто) !!!
             FROM (SELECT Movement.StatusId
                        , COALESCE (Container.ObjectId, ObjectLink_Goods_Fuel.ChildObjectId) AS FuelId
                        , 0 AS Amount_Start
                        , SUM (COALESCE (MIContainer.Amount, COALESCE (MI.Amount, 0))) AS Amount_In
                        , 0 AS Amount_Out
                   FROM Movement
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                        LEFT JOIN Object AS ObjectFrom ON ObjectFrom.Id = MovementLinkObject_From.ObjectId

                        LEFT JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.MovementId = Movement.Id
                                                       AND MIContainer.DescId = zc_MIContainer_Count()
                                                       AND MIContainer.isActive = TRUE
                        -- если есть проводки, данные берем у аналитики
                        LEFT JOIN Container ON Container.Id = MIContainer.ContainerId
                        -- если не проведен, данные берем у элементов
                        LEFT JOIN MovementItem AS MI ON MI.MovementId = Movement.Id
                                                    AND MI.DescId = zc_MI_Master()
                                                    AND MI.isErased = FALSE
                                                    AND Movement.StatusId = zc_Enum_Status_UnComplete()
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                             ON ObjectLink_Goods_Fuel.ObjectId = MI.ObjectId
                                            AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                   WHERE Movement.ParentId = inMovementId
                     AND Movement.DescId = zc_Movement_Income()
                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                     -- AND COALESCE (ObjectFrom.DescId, 0) <> zc_Object_TicketFuel()
                   GROUP BY Movement.StatusId
                          , Container.ObjectId
                          , ObjectLink_Goods_Fuel.ChildObjectId
                   
                  UNION ALL
                   -- Начальный остаток топлива в автомобиле !!!это документ - Путевой лист!!!
                   SELECT vbStatusId  AS StatusId
                        , MI.ObjectId AS FuelId
                        , COALESCE (MIFloat_StartAmountFuel.ValueData, 0) AS Amount_Start
                        , 0 AS Amount_In
                        , 0 AS Amount_Out
                   FROM MovementItem AS MI
                        JOIN MovementItem AS MI_Parent ON MI_Parent.Id = MI.ParentId AND MI_Parent.isErased = FALSE
                        LEFT JOIN MovementItemFloat AS MIFloat_StartAmountFuel
                                                    ON MIFloat_StartAmountFuel.MovementItemId = MI.Id
                                                   AND MIFloat_StartAmountFuel.DescId = zc_MIFloat_StartAmountFuel()
                   WHERE MI.MovementId = inMovementId
                     AND MI.DescId     = zc_MI_Child()
                     AND MI.isErased   = FALSE

                  UNION ALL
                   -- Проводки количественные(!!ВСЕ!!!)- Расход топлива Автомобиль !!!это документ - Путевой лист!!!
                   SELECT zc_Enum_Status_Complete() AS StatusId
                        , Container.ObjectId AS FuelId
                        , 0 AS Amount_Start
                        , 0 AS Amount_In
                        , -1 * SUM (MIContainer.Amount) AS Amount_Out
                   FROM MovementItemContainer AS MIContainer
                        LEFT JOIN Container ON Container.Id = MIContainer.ContainerId
                   WHERE MIContainer.DescId = zc_MIContainer_Count()
                     AND MIContainer.MovementId = inMovementId
                   GROUP BY Container.ObjectId
                   HAVING SUM (MIContainer.Amount) <> 0

                  ) AS tmpFuel
             GROUP BY tmpFuel.FuelId
                    , tmpFuel.StatusId

            UNION ALL
             -- 3.Талоны
             SELECT -2 AS KindId
                  , tmpTicketFuel.StatusId
                  , 0 AS Amount_20401
                  , SUM (tmpTicketFuel.Amount_Start) AS Amount_Start
                  , SUM (tmpTicketFuel.Amount_In)    AS Amount_In
                  , SUM (tmpTicketFuel.Amount_Out)   AS Amount_Out
                  , SUM (tmpTicketFuel.Amount_Start + tmpTicketFuel.Amount_In - tmpTicketFuel.Amount_Out) AS Amount_End

                   -- Элементы - Приход Талонов !!!это документ - Внутренее перемещение!!!
             FROM (SELECT Movement.StatusId
                        , 0 AS Amount_Start
                        , SUM (COALESCE (MI.Amount, 0)) AS Amount_In
                        , 0 AS Amount_Out
                   FROM Movement
                        JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.ObjectId   = vbPersonalId
                                               AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                        LEFT JOIN MovementItem AS MI ON MI.MovementId = Movement.Id
                                                    AND MI.DescId = zc_MI_Master()
                                                    AND MI.isErased = FALSE
                                                    AND MI.ObjectId IN (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_TicketFuel_Goods())
                        JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MI.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                                   AND MILinkObject_Asset.ObjectId = vbCarId
                   WHERE Movement.OperDate = vbOperDate
                     AND Movement.DescId = zc_Movement_Send()
                     AND Movement.StatusId = zc_Enum_Status_UnComplete()
                   GROUP BY Movement.StatusId
                  UNION ALL
                   -- Проводки количественные - Приход Талонов !!!это документ - Внутренее перемещение!!!
                   SELECT Movement.StatusId
                        , 0 AS Amount_Start
                        , SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_In
                        , 0 AS Amount_Out
                   FROM ObjectLink AS ObjectLink_TicketFuel_Goods
                        JOIN Container ON Container.ObjectId = ObjectLink_TicketFuel_Goods.ChildObjectId
                                      AND Container.DescId = zc_Container_Count()
                        JOIN ContainerLinkObject AS ContainerLinkObject_Asset
                                                 ON ContainerLinkObject_Asset.ContainerId = Container.Id
                                                AND ContainerLinkObject_Asset.DescId      = zc_ContainerLinkObject_Car()
                                                AND ContainerLinkObject_Asset.ObjectId    = vbCarId
                        JOIN ContainerLinkObject AS ContainerLinkObject_Member
                                                 ON ContainerLinkObject_Member.ContainerId = Container.Id
                                                AND ContainerLinkObject_Member.DescId      = zc_ContainerLinkObject_Member()
                                                AND ContainerLinkObject_Member.ObjectId    = vbMemberId

                        LEFT JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.ContainerId = Container.Id
                                                       AND MIContainer.OperDate    = vbOperDate
                                                       AND MIContainer.isActive    = TRUE
                        JOIN Movement ON Movement.Id = MIContainer.MovementId
                                     AND Movement.DescId = zc_Movement_Send()

                   WHERE ObjectLink_TicketFuel_Goods.DescId = zc_ObjectLink_TicketFuel_Goods()
                   GROUP BY Movement.StatusId

                  UNION ALL
                   -- Проводки количественные или Элементы - Расход Талонов !!!это документ - Приход от поставщика (Заправка авто) !!!
                   SELECT Movement.StatusId
                        , 0 AS Amount_Start
                        , 0 AS Amount_In
                        , SUM (COALESCE (-1 * MIContainer.Amount, COALESCE (MI.Amount, 0))) AS Amount_Out
                   FROM Movement
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                        LEFT JOIN Object AS ObjectFrom ON ObjectFrom.Id = MovementLinkObject_From.ObjectId

                        LEFT JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.MovementId = Movement.Id
                                                       AND MIContainer.DescId     = zc_MIContainer_Count()
                                                       AND MIContainer.isActive   = FALSE
                        -- если есть проводки, данные берем у аналитики
                        LEFT JOIN Container ON Container.Id = MIContainer.ContainerId
                        -- если не проведен, данные берем у элементов
                        LEFT JOIN MovementItem AS MI ON MI.MovementId = Movement.Id
                                                    AND MI.DescId = zc_MI_Master()
                                                    AND MI.isErased = FALSE
                                                    AND Movement.StatusId = zc_Enum_Status_UnComplete()
                   WHERE Movement.ParentId = inMovementId
                     AND Movement.DescId = zc_Movement_Income()
                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                     AND COALESCE (ObjectFrom.DescId, 0) = zc_Object_TicketFuel()
                   GROUP BY Movement.StatusId
                          , Container.ObjectId
                   
                  UNION ALL
                   -- Начальный остаток талонов на топливо Сотрудник (водитель) !!!это документ - Путевой лист!!!
                   SELECT vbStatusId AS StatusId
                        , MovementFloat.ValueData AS Amount_Start
                        , 0 AS Amount_In
                        , 0 AS Amount_Out
                   FROM MovementFloat
                   WHERE DescId = zc_MovementFloat_StartAmountTicketFuel()
                     AND MovementId = inMovementId
                  ) AS tmpTicketFuel
             GROUP BY tmpTicketFuel.StatusId

            ) AS tmpAll
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpAll.StatusId
            LEFT JOIN (SELECT -1 AS KindId,  '1.Денежные средства' AS KindName
                      UNION ALL 
                       SELECT Id AS KindId,  '2.'||ValueData AS KindName FROM Object WHERE DescId = zc_Object_Fuel()
                      UNION ALL 
                       SELECT -2 AS KindId,  '3.Талоны' AS KindName
                      ) AS tmpKind ON tmpKind.KindId = tmpAll.KindId
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MI_TransportReport (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.14                                        * add MI_Parent
 21.12.13                                        * Personal -> Member
 26.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MI_TransportReport (inMovementId:= 492, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
