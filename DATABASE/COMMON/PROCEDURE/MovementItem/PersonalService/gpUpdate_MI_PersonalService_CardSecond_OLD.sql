-- Function: gpUpdate_MI_PersonalService_CardSecond()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_CardSecond (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_CardSecond(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbServiceDateId Integer;
   DECLARE vbPersonalServiceListId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен';
     END IF;
 
     -- определяем <Месяц начислений>
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate()));

     -- определяем <Ведомость> - что б выбрать только этих Сотрудников
     vbPersonalServiceListId := (SELECT MLO_PersonalServiceList.ObjectId 
                                 FROM MovementLinkObject AS MLO_PersonalServiceList
                                 WHERE MLO_PersonalServiceList.MovementId = inMovementId
                                   AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList());

     -- новые данные - MovementItem
     CREATE TEMP TABLE _tmpMI (MovementItemId Integer, PersonalId Integer, UnitId Integer, PositionId Integer, InfoMoneyId Integer, PersonalServiceListId Integer, SummCardSecondRecalc TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpMI (MovementItemId, PersonalId, UnitId, PositionId, InfoMoneyId, PersonalServiceListId, SummCardSecondRecalc)
           WITH -- все Сотрудники из vbPersonalServiceListId - по ним и будет формироваться Инфа
                tmpPersonal_all AS (SELECT ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId AS PersonalId
                                         , ObjectLink_Personal_Unit.ChildObjectId                     AS UnitId
                                         , ObjectLink_Personal_Member.ChildObjectId                   AS MemberId
                                         , ObjectLink_Personal_Position.ChildObjectId                 AS PositionId
                                         , zc_Enum_InfoMoney_60101()                                  AS InfoMoneyId  -- 60101 Заработная плата
                                         , ObjectLink_Personal_PersonalServiceList.ChildObjectId      AS PersonalServiceListId
                                    FROM ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                              ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                             AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                              ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                             AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                              ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                             AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                              ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                             AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                    WHERE ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId = vbPersonalServiceListId
                                      AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId        = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
                                   )
              , tmpPersonal AS (SELECT tmpPersonal_all.PersonalId
                                     , tmpPersonal_all.UnitId
                                     , tmpPersonal_all.PositionId
                                     , tmpPersonal_all.InfoMoneyId  -- 60101 Заработная плата
                                     , tmpPersonal_all.PersonalServiceListId
                                FROM tmpPersonal_all
                             /*  UNION
                                SELECT ObjectLink_Personal_Member.ObjectId                        AS PersonalId
                                     , ObjectLink_Personal_Unit.ChildObjectId                     AS UnitId
                                     , ObjectLink_Personal_Position.ChildObjectId                 AS PositionId
                                     , zc_Enum_InfoMoney_60101()                                  AS InfoMoneyId  -- 60101 Заработная плата
                                     , ObjectLink_Personal_PersonalServiceList.ChildObjectId      AS PersonalServiceListId
                                FROM tmpPersonal_all
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                          ON ObjectLink_Personal_Member.ChildObjectId = tmpPersonal_all.MemberId
                                                         AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                                          ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId      = ObjectLink_Personal_Member.ObjectId
                                                         AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId        = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
                                                         AND ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId = vbPersonalServiceListId

                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                          ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                         AND ObjectLink_Personal_Position.DescId   = zc_ObjectLink_Personal_Position()
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                          ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                         AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                          ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                         AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
                                WHERE ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId IS NULL*/
                               )
                -- текущие элементы
              , tmpMI AS (SELECT MovementItem.Id                                        AS MovementItemId
                               , MovementItem.ObjectId                                  AS PersonalId
                               , MILinkObject_Unit.ObjectId                             AS UnitId
                               , MILinkObject_Position.ObjectId                         AS PositionId
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_Unit.ObjectId, MILinkObject_Position.ObjectId ORDER BY MovementItem.Id ASC) AS Ord
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                         )
         -- нашли Сотрудникам - существующие MovementItemId, причем ТОЛЬКО ОДИН
       , tmpListPersonal AS (SELECT tmpMI.MovementItemId                                  AS MovementItemId
                                  , COALESCE (tmpPersonal.PersonalId,  tmpMI.PersonalId)  AS PersonalId
                                  , COALESCE (tmpPersonal.UnitId,      tmpMI.UnitId)      AS UnitId
                                  , COALESCE (tmpPersonal.PositionId,  tmpMI.PositionId)  AS PositionId
                                    -- если здесь пусто - значит это лишний элемент
                                  , tmpPersonal.InfoMoneyId                               AS InfoMoneyId
                                    -- если здесь пусто - значит это лишний элемент
                                  , tmpPersonal.PersonalServiceListId                     AS PersonalServiceListId
                             FROM tmpMI
                                  FULL JOIN tmpPersonal ON tmpPersonal.PersonalId = tmpMI.PersonalId
                                                       AND tmpPersonal.PositionId = tmpMI.PositionId
                                                       AND tmpPersonal.UnitId     = tmpMI.UnitId
                                                       AND tmpMI.Ord              = 1
                                  
                            )
         -- список Container - для поиска в проводках - сколько уже выплатили
       , tmpContainer AS (SELECT CLO_ServiceDate.ContainerId
                               , tmpMI.PersonalId
                               , tmpMI.UnitId
                               , tmpMI.PositionId
                               , tmpMI.InfoMoneyId
                          FROM tmpListPersonal AS tmpMI
                               INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                              ON CLO_ServiceDate.ObjectId = vbServiceDateId
                                                             AND CLO_ServiceDate.DescId   = zc_ContainerLinkObject_ServiceDate()
                               INNER JOIN ContainerLinkObject AS CLO_Personal
                                                              ON CLO_Personal.ObjectId    = tmpMI.PersonalId
                                                             AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                                             AND CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                               INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                              ON CLO_InfoMoney.ObjectId    = tmpMI.InfoMoneyId
                                                             AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                                             AND CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                               INNER JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ObjectId    = tmpMI.UnitId
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                             AND CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                               INNER JOIN ContainerLinkObject AS CLO_Position
                                                              ON CLO_Position.ObjectId    = tmpMI.PositionId
                                                             AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                                                             AND CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                               INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                              ON CLO_PersonalServiceList.ObjectId    = tmpMI.PersonalServiceListId
                                                             AND CLO_PersonalServiceList.DescId      = zc_ContainerLinkObject_PersonalServiceList()
                                                             AND CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                         )
   -- только проводки - сколько уже выплатили (Авансом)
 , tmpMIContainer_all AS (SELECT MIContainer.*
                               , tmpContainer.PersonalId
                               , tmpContainer.UnitId
                               , tmpContainer.PositionId
                               , tmpContainer.InfoMoneyId
                          FROM tmpContainer
                               INNER JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                               AND MIContainer.DescId      = zc_MIContainer_Summ()
                         )
       -- только 
     , tmpSummCard AS (SELECT SUM (COALESCE (MIFloat_SummCard.ValueData, 0))  AS Amount
                               , tmp.PersonalId
                               , tmp.UnitId
                               , tmp.PositionId
                               , tmp.InfoMoneyId
                          FROM (SELECT DISTINCT
                                       tmpMIContainer_all.MovementItemId
                                     , tmpMIContainer_all.PersonalId
                                     , tmpMIContainer_all.UnitId
                                     , tmpMIContainer_all.PositionId
                                     , tmpMIContainer_all.InfoMoneyId
                                FROM tmpMIContainer_all
                                WHERE tmpMIContainer_all.MovementDescId = zc_Movement_PersonalService()
                               ) AS tmp
                               INNER JOIN MovementItemFloat AS MIFloat_SummCard
                                                            ON MIFloat_SummCard.MovementItemId = tmp.MovementItemId
                                                           AND MIFloat_SummCard.DescId         = zc_MIFloat_SummCard()
                          GROUP BY tmp.PersonalId
                                 , tmp.UnitId
                                 , tmp.PositionId
                                 , tmp.InfoMoneyId
                         )
       -- только проводки - сколько уже выплатили (Авансом)
     , tmpMIContainer AS (SELECT SUM (COALESCE (CASE WHEN tmpMIContainer_all.MovementDescId = zc_Movement_BankAccount() THEN 0 ELSE tmpMIContainer_all.Amount END, 0))  AS Amount
                               , tmpMIContainer_all.PersonalId
                               , tmpMIContainer_all.UnitId
                               , tmpMIContainer_all.PositionId
                               , tmpMIContainer_all.InfoMoneyId
                          FROM tmpMIContainer_all
                          GROUP BY tmpMIContainer_all.PersonalId
                                 , tmpMIContainer_all.UnitId
                                 , tmpMIContainer_all.PositionId
                                 , tmpMIContainer_all.InfoMoneyId
                         )
            -- результат
            SELECT tmpListPersonal.MovementItemId
                 , tmpListPersonal.PersonalId
                 , tmpListPersonal.UnitId
                 , tmpListPersonal.PositionId
                 , tmpListPersonal.InfoMoneyId
                 , tmpListPersonal.PersonalServiceListId
                 , CASE WHEN -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0) > 0
                                  -- т.к. в проводках долг с минусом
                             THEN -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0)
                        ELSE 0
                   END AS SummCardSecondRecalc
            FROM tmpListPersonal
                 LEFT JOIN tmpMIContainer ON tmpMIContainer.PersonalId  = tmpListPersonal.PersonalId
                                         AND tmpMIContainer.UnitId      = tmpListPersonal.UnitId
                                         AND tmpMIContainer.PositionId  = tmpListPersonal.PositionId
                                         AND tmpMIContainer.InfoMoneyId = tmpListPersonal.InfoMoneyId
                 LEFT JOIN tmpSummCard ON tmpSummCard.PersonalId  = tmpListPersonal.PersonalId
                                      AND tmpSummCard.UnitId      = tmpListPersonal.UnitId
                                      AND tmpSummCard.PositionId  = tmpListPersonal.PositionId
                                      AND tmpSummCard.InfoMoneyId = tmpListPersonal.InfoMoneyId
            WHERE tmpListPersonal.MovementItemId > 0 
               OR -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0) > 0 -- !!! т.е. если есть долг по ЗП
          ;
 
     -- сохраняем элементы
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                 := _tmpMI.MovementItemId
                                                        , inMovementId         := inMovementId
                                                        , inPersonalId         := _tmpMI.PersonalId
                                                        , inIsMain             := COALESCE (ObjectBoolean_Main.ValueData, FALSE)
                                                        , inSummService        := 0
                                                        , inSummCardRecalc     := 0
                                                        , inSummCardSecondRecalc:= _tmpMI.SummCardSecondRecalc
                                                        , inSummCardSecondCash := 0
                                                        , inSummNalogRecalc    := 0
                                                        , inSummNalogRetRecalc := 0
                                                        , inSummMinus          := 0
                                                        , inSummAdd            := 0
                                                        , inSummAddOthRecalc   := 0
                                                        , inSummHoliday        := 0
                                                        , inSummSocialIn       := 0
                                                        , inSummSocialAdd      := 0
                                                        , inSummChildRecalc    := 0
                                                        , inSummMinusExtRecalc := 0
                                                        , inComment            := ''
                                                        , inInfoMoneyId        := _tmpMI.InfoMoneyId
                                                        , inUnitId             := _tmpMI.UnitId
                                                        , inPositionId         := _tmpMI.PositionId
                                                        , inMemberId           := NULL
                                                        , inPersonalServiceListId := _tmpMI.PersonalServiceListId
                                                        , inUserId             := vbUserId
                                                         )
     FROM _tmpMI
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = _tmpMI.PersonalId
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
     ;
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.06.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId :=0, inSession :='3':: TVarChar)
