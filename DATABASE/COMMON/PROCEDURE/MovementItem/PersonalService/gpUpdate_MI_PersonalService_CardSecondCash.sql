-- Function: gpUpdate_MI_PersonalService_CardSecondCash()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_CardSecondCash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_CardSecondCash(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbServiceDateId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE(inMovementId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен';
     END IF;
 
     -- определяем <Месяц начислений>
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate()));

     CREATE TEMP TABLE _tmpContainer (MovementItemId Integer, PersonalId Integer, UnitId Integer, PositionId Integer, InfoMoneyId Integer, SummRemains TFloat) ON COMMIT DROP;
         --
         INSERT INTO _tmpContainer (MovementItemId, PersonalId, UnitId, PositionId, InfoMoneyId, SummRemains)
             WITH       
                 tmpSummNalog AS (SELECT CLO_Unit.ObjectId     AS UnitId
                                        , CLO_Position.ObjectId AS PositionId
                                        , CLO_Personal.ObjectId AS PersonalId
                                        , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_PersonalService_Nalog() THEN MIContainer.Amount ELSE 0 END) AS SummNalog
                                   FROM MovementItemContainer AS MIContainer
                                        LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                      ON CLO_Unit.ContainerId = MIContainer.ContainerId
                                                                     AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                        LEFT JOIN ContainerLinkObject AS CLO_Position
                                                                      ON CLO_Position.ContainerId = MIContainer.ContainerId
                                                                     AND CLO_Position.DescId = zc_ContainerLinkObject_Position()
                                        LEFT JOIN ContainerLinkObject AS CLO_Personal
                                                                      ON CLO_Personal.ContainerId = MIContainer.ContainerId
                                                                     AND CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                   WHERE MIContainer.MovementId = inMovementId
                                     AND MIContainer.DescId     = zc_MIContainer_Summ()
                                     AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_PersonalService_Nalog())
                                   GROUP BY CLO_Unit.ObjectId
                                          , CLO_Position.ObjectId
                                          , CLO_Personal.ObjectId
                                  )
               , tmpMI AS (
                      SELECT SUM (COALESCE (MIFloat_SummService.ValueData, 0))      AS SummService
                                   , SUM (COALESCE (MIFloat_SummToPay.ValueData, 0) - COALESCE (tmpSummNalog.SummNalog, 0) + COALESCE (MIFloat_SummNalog.ValueData, 0)
                                        - COALESCE (MIFloat_SummCard.ValueData, 0)
                                        - COALESCE (MIFloat_SummCardSecond.ValueData, 0)
                                         ) AS SummToPay_cash
                                   , SUM (COALESCE (MIFloat_SummToPay.ValueData, 0)  - COALESCE (tmpSummNalog.SummNalog, 0) + COALESCE (MIFloat_SummNalog.ValueData, 0)
                                         ) AS SummToPay

                                   , MovementItem.ObjectId                                  AS PersonalId
                                   , MILinkObject_Unit.ObjectId                             AS UnitId
                                   , MILinkObject_Position.ObjectId                         AS PositionId
                                   , MILinkObject_InfoMoney.ObjectId                        AS InfoMoneyId
                                   , MLO_PersonalServiceList.ObjectId                       AS PersonalServiceListId
                                   , MovementItem.Id                                        AS MovementItemId
                              FROM Movement
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                                   LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                                ON MLO_PersonalServiceList.MovementId = Movement.Id
                                                               AND MLO_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                    ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                    ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                    ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummToPay
                                                               ON MIFloat_SummToPay.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummToPay.DescId = zc_MIFloat_SummToPay()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummService
                                                               ON MIFloat_SummService.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummService.DescId = zc_MIFloat_SummService()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                                               ON MIFloat_SummCard.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecond
                                                               ON MIFloat_SummCardSecond.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummCardSecond.DescId = zc_MIFloat_SummCardSecond()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummNalog
                                                               ON MIFloat_SummNalog.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummNalog.DescId = zc_MIFloat_SummNalog()

                                   LEFT JOIN tmpSummNalog ON tmpSummNalog.PersonalId = MovementItem.ObjectId
                                                         AND tmpSummNalog.UnitId     = MILinkObject_Unit.ObjectId
                                                         AND tmpSummNalog.PositionId = MILinkObject_Position.ObjectId

                              WHERE Movement.Id = inMovementId
                                AND Movement.StatusId = zc_Enum_Status_Complete()

                              GROUP BY MovementItem.ObjectId
                                     , MILinkObject_Unit.ObjectId
                                     , MILinkObject_Position.ObjectId
                                     , MILinkObject_InfoMoney.ObjectId
                                     , MLO_PersonalServiceList.ObjectId
                                     , MovementItem.Id 
                             )

           , tmpContainer AS (
               SELECT CLO_ServiceDate.ContainerId
                                   , tmpMI.PersonalId
                                   , tmpMI.UnitId
                                   , tmpMI.PositionId
                                   , tmpMI.InfoMoneyId
                              FROM tmpMI
                                   INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                                  ON CLO_ServiceDate.ObjectId = vbServiceDateId
                                                                 AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate()
                                   INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                  ON CLO_Personal.ObjectId = tmpMI.PersonalId
                                                                 AND CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                                                 AND CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                  ON CLO_InfoMoney.ObjectId = tmpMI.InfoMoneyId
                                                                 AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                 AND CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                  ON CLO_Unit.ObjectId = tmpMI.UnitId
                                                                 AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                 AND CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_Position
                                                                  ON CLO_Position.ObjectId = tmpMI.PositionId
                                                                 AND CLO_Position.DescId = zc_ContainerLinkObject_Position()
                                                                 AND CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                                  ON CLO_PersonalServiceList.ObjectId = tmpMI.PersonalServiceListId
                                                                 AND CLO_PersonalServiceList.DescId = zc_ContainerLinkObject_PersonalServiceList()
                                                                 AND CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                             )
         , tmpMIContainer AS (SELECT SUM (COALESCE (MIContainer.Amount, 0))  AS Amount
                                    , tmpContainer.PersonalId
                                    , tmpContainer.UnitId
                                    , tmpContainer.PositionId
                                    , tmpContainer.InfoMoneyId
                              FROM tmpContainer
                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                   AND MIContainer.DescId = zc_MIContainer_Summ()
                              GROUP BY tmpContainer.PersonalId
                                      , tmpContainer.UnitId
                                      , tmpContainer.PositionId
                                      , tmpContainer.InfoMoneyId
                             )
                -- результат
                SELECT tmpMI.MovementItemId 
                      , tmpMI.PersonalId
                      , tmpMI.UnitId
                      , tmpMI.PositionId
                      , tmpMI.InfoMoneyId
                     , (COALESCE (tmpMI.SummToPay_cash, 0) - COALESCE (tmpMIContainer.Amount, 0) ) :: TFloat AS SummRemains
                FROM tmpMI
                     LEFT JOIN tmpMIContainer ON tmpMIContainer.PersonalId  = tmpMI.PersonalId
                                             AND tmpMIContainer.UnitId      = tmpMI.UnitId
                                             AND tmpMIContainer.PositionId  = tmpMI.PositionId
                                             AND tmpMIContainer.InfoMoneyId = tmpMI.InfoMoneyId;
 

     -- cохранили свойство
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecondCash(), _tmpContainer.MovementItemId, _tmpContainer.SummRemains);
     FROM _tmpContainer
     WHERE COALESCE (_tmpContainer.SummRemains,0) <> 0;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.06.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecondCash (inMovementId :=0, inSession :='3':: TVarChar)

