-- Function: gpUpdate_MI_PersonalService_CardSecond()
--рабочая
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
   DECLARE vbMemberId_check Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен';
     END IF;

-- !!!тест 
IF vbUserId = 5 AND 1=0
THEN
    PERFORM gpUnComplete_Movement_PersonalService (inMovementId:= inMovementId, inSession:= inSession);
END IF;
 
     -- определяем <Месяц начислений>
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate()));

     -- определяем <Ведомость> - что б выбрать только этих Сотрудников
     vbPersonalServiceListId := (SELECT MLO_PersonalServiceList.ObjectId 
                                 FROM MovementLinkObject AS MLO_PersonalServiceList
                                 WHERE MLO_PersonalServiceList.MovementId = inMovementId
                                   AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList());


     -- Проверка, у каждого сотрудника с zc_ObjectLink_Personal_PersonalServiceListCardSecond должен быть isMain
     vbMemberId_check:=
          (WITH -- Сотрудники ВСЕ
                tmpPersonal_all AS (SELECT ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId AS PersonalId
                                         , ObjectLink_Personal_Unit.ChildObjectId                     AS UnitId
                                         , ObjectLink_Personal_Member.ChildObjectId                   AS MemberId
                                         , ObjectLink_Personal_Position.ChildObjectId                 AS PositionId
                                         , zc_Enum_InfoMoney_60101()                                  AS InfoMoneyId  -- 60101 Заработная плата
                                         , ObjectLink_Personal_PersonalServiceList.ChildObjectId      AS PersonalServiceListId
                                         , ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId AS PersonalServiceListId_CardSecond
                                         , ObjectBoolean_isMain.ValueData                             AS isMain
                                    FROM ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                         INNER JOIN Object AS Object_Personal ON Object_Personal.Id       = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                                             AND Object_Personal.isErased = FALSE
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                               ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                              AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                         INNER JOIN Object AS Object_Member ON Object_Member.Id       = ObjectLink_Personal_Member.ChildObjectId
                                                                           AND Object_Member.isErased = FALSE
                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_isMain
                                                                 ON ObjectBoolean_isMain.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                                AND ObjectBoolean_isMain.DescId   = zc_ObjectBoolean_Personal_Main()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                              ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                             AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                              ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                             AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                              ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                             AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                    WHERE ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId > 0
                                      AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId        = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
                                   )
           SELECT tmp.MemberId
           FROM (SELECT DISTINCT tmpPersonal_all.MemberId FROM tmpPersonal_all WHERE tmpPersonal_all.PersonalServiceListId_CardSecond = vbPersonalServiceListId) AS tmp
                LEFT JOIN (SELECT DISTINCT tmpPersonal_all.MemberId FROM tmpPersonal_all WHERE tmpPersonal_all.isMain = TRUE
                          ) AS tmp_check ON tmp_check.MemberId = tmp.MemberId
           WHERE tmp_check.MemberId IS NULL
           LIMIT 1
          );
     IF vbMemberId_check > 0 THEN
       RAISE EXCEPTION 'Ошибка.Для Соотрудника <%> с признаком <Основное место работы = ДА> не заполнено <Ведомость начисления(Карта Ф2)>.', lfGet_Object_ValueData (vbMemberId_check);
     END IF;
     



     -- новые данные - MovementItem
     CREATE TEMP TABLE _tmpMI (MovementItemId Integer, MemberId Integer, PersonalId Integer, UnitId Integer, PositionId Integer, InfoMoneyId Integer, PersonalServiceListId Integer, FineSubjectId Integer, UnitId_FineSubject Integer, SummCardSecondRecalc TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpMI (MovementItemId, MemberId, PersonalId, UnitId, PositionId, InfoMoneyId, PersonalServiceListId, FineSubjectId, UnitId_FineSubject, SummCardSecondRecalc)
           WITH -- Сотрудники ВСЕ
                tmpPersonal_all AS (SELECT ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId AS PersonalId
                                         , ObjectLink_Personal_Unit.ChildObjectId                     AS UnitId
                                         , ObjectLink_Personal_Member.ChildObjectId                   AS MemberId
                                         , ObjectLink_Personal_Position.ChildObjectId                 AS PositionId
                                         , zc_Enum_InfoMoney_60101()                                  AS InfoMoneyId  -- 60101 Заработная плата
                                         , ObjectLink_Personal_PersonalServiceList.ChildObjectId      AS PersonalServiceListId
                                         , ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId AS PersonalServiceListId_CardSecond
                                         , ObjectBoolean_isMain.ValueData                             AS isMain
                                    FROM ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                         INNER JOIN Object AS Object_Personal ON Object_Personal.Id       = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                                             AND Object_Personal.isErased = FALSE
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                               ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                              AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                         INNER JOIN Object AS Object_Member ON Object_Member.Id       = ObjectLink_Personal_Member.ChildObjectId
                                                                           AND Object_Member.isErased = FALSE
                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_isMain
                                                                 ON ObjectBoolean_isMain.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                                AND ObjectBoolean_isMain.DescId   = zc_ObjectBoolean_Personal_Main()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                              ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                             AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                              ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                             AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                              ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                             AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
                                    WHERE ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId > 0
                                      AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId        = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
                                   )
                -- все Физ лица - по ним все варианты Personal возьмем из Container
              , tmpMember AS (SELECT DISTINCT tmpPersonal_all.MemberId, tmpPersonal_all.InfoMoneyId
                              FROM tmpPersonal_all
                              WHERE tmpPersonal_all.PersonalServiceListId_CardSecond = vbPersonalServiceListId
                                AND tmpPersonal_all.isMain                = TRUE
                             )
                -- Сотрудники - такие варианты Personal - убрать из Container, т.к. они будут в другой PersonalServiceListId
              , tmpPersonal_not AS (SELECT tmpPersonal_all.*
                                     FROM tmpPersonal_all
                                          INNER JOIN tmpMember ON tmpMember.MemberId = tmpPersonal_all.MemberId
                                     WHERE tmpPersonal_all.PersonalServiceListId_CardSecond <> vbPersonalServiceListId
                                    )
                -- Сотрудники из vbPersonalServiceListId - по ним варианты Personal - только то что в справочнике
              , tmpPersonal_only AS (SELECT tmpPersonal_all.*
                                     FROM tmpPersonal_all
                                          LEFT JOIN tmpMember ON tmpMember.MemberId = tmpPersonal_all.MemberId
                                     WHERE tmpPersonal_all.PersonalServiceListId_CardSecond = vbPersonalServiceListId
                                       AND tmpMember.MemberId                    IS NULL
                                    )
         , tmpContainer_all AS (SELECT CLO_ServiceDate.ContainerId              AS ContainerId
                                     , CLO_Personal.ObjectId                    AS PersonalId
                                     , CLO_Unit.ObjectId                        AS UnitId
                                     , CLO_Position.ObjectId                    AS PositionId
                                     , CLO_InfoMoney.ObjectId                   AS InfoMoneyId           -- 60101 Заработная плата
                                     , CLO_PersonalServiceList.ObjectId         AS PersonalServiceListId
                                     , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                FROM ContainerLinkObject AS CLO_ServiceDate
                                     INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                    ON CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                     INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                    ON CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                     INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                    ON CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                     INNER JOIN ContainerLinkObject AS CLO_Position
                                                                    ON CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                                     INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                                    ON CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_PersonalServiceList.DescId      = zc_ContainerLinkObject_PersonalServiceList()
                                     INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                           ON ObjectLink_Personal_Member.ObjectId      = CLO_Personal.ObjectId
                                                          AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                     LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                          ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = CLO_PersonalServiceList.ObjectId
                                                         AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
                                                         AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!вот он БН!!!
                                WHERE CLO_ServiceDate.ObjectId    = vbServiceDateId
                                  AND CLO_ServiceDate.DescId      = zc_ContainerLinkObject_ServiceDate()
                                  AND ObjectLink_PersonalServiceList_PaidKind.ObjectId IS NULL
                               )                                   
             , tmpPersonal AS (SELECT DISTINCT
                                      tmpContainer_all.PersonalId
                                    , tmpContainer_all.UnitId
                                    , tmpContainer_all.PositionId
                                    , tmpContainer_all.InfoMoneyId           -- 60101 Заработная плата
                                    , tmpContainer_all.PersonalServiceListId
                                    , tmpContainer_all.MemberId
                               FROM tmpMember
                                    INNER JOIN tmpContainer_all ON tmpContainer_all.MemberId    = tmpMember.MemberId
                                                               AND tmpContainer_all.InfoMoneyId = tmpMember.InfoMoneyId
                                    LEFT JOIN tmpPersonal_not ON tmpPersonal_not.PersonalId            = tmpContainer_all.PersonalId
                                                             AND tmpPersonal_not.UnitId                = tmpContainer_all.UnitId
                                                             AND tmpPersonal_not.PositionId            = tmpContainer_all.PositionId
                                                             AND tmpPersonal_not.InfoMoneyId           = tmpContainer_all.InfoMoneyId
                                                             AND tmpPersonal_not.PersonalServiceListId = tmpContainer_all.PersonalServiceListId
                               WHERE tmpPersonal_not.PersonalId IS NULL
                              UNION 
                               SELECT tmpPersonal_only.PersonalId
                                    , tmpPersonal_only.UnitId
                                    , tmpPersonal_only.PositionId
                                    , tmpPersonal_only.InfoMoneyId           -- 60101 Заработная плата
                                    , tmpPersonal_only.PersonalServiceListId
                                    , tmpPersonal_only.MemberId
                               FROM tmpPersonal_only
                              )
                -- текущие элементы
              , tmpMI AS (SELECT MovementItem.Id                                        AS MovementItemId
                               , MovementItem.ObjectId                                  AS PersonalId
                               , MILinkObject_Unit.ObjectId                             AS UnitId
                               , MILinkObject_Position.ObjectId                         AS PositionId
                               , MILinkObject_PersonalServiceList.ObjectId              AS PersonalServiceListId
                               , COALESCE (MILinkObject_FineSubject.ObjectId, 0)        AS FineSubjectId
                               , COALESCE (MILinkObject_UnitFineSubject.ObjectId, 0)    AS UnitId_FineSubject
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_Unit.ObjectId, MILinkObject_Position.ObjectId ORDER BY MovementItem.Id ASC) AS Ord
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                                ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_FineSubject
                                                                ON MILinkObject_FineSubject.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_FineSubject.DescId = zc_MILinkObject_FineSubject()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_UnitFineSubject
                                                                ON MILinkObject_UnitFineSubject.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_UnitFineSubject.DescId = zc_MILinkObject_UnitFineSubject()
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
                                  , tmpPersonal.MemberId                                  AS MemberId
                                  , COALESCE (tmpMI.FineSubjectId, 0)                     AS FineSubjectId
                                  , COALESCE (tmpMI.UnitId_FineSubject, 0)                AS UnitId_FineSubject
                             FROM tmpMI
                                  FULL JOIN tmpPersonal ON tmpPersonal.PersonalId            = tmpMI.PersonalId
                                                       AND tmpPersonal.PositionId            = tmpMI.PositionId
                                                       AND tmpPersonal.UnitId                = tmpMI.UnitId
                                                       AND tmpPersonal.PersonalServiceListId = tmpMI.PersonalServiceListId
                                                       AND tmpMI.Ord              = 1
                                  
                            )
         -- список Container - для поиска в проводках - сколько уже выплатили
       , tmpContainer AS (SELECT tmpContainer_all.ContainerId
                               , tmpMI.PersonalId
                               , tmpMI.UnitId
                               , tmpMI.PositionId
                               , tmpMI.InfoMoneyId
                               , tmpMI.PersonalServiceListId
                               , tmpMI.FineSubjectId
                               , tmpMI.UnitId_FineSubject
                          FROM tmpListPersonal AS tmpMI
                               INNER JOIN tmpContainer_all ON tmpContainer_all.PersonalId            = tmpMI.PersonalId
                                                          AND tmpContainer_all.UnitId                = tmpMI.UnitId
                                                          AND tmpContainer_all.PositionId            = tmpMI.PositionId
                                                          AND tmpContainer_all.InfoMoneyId           = tmpMI.InfoMoneyId
                                                          AND tmpContainer_all.PersonalServiceListId = tmpMI.PersonalServiceListId
                         )
   -- только проводки - сколько уже выплатили (Авансом)
 , tmpMIContainer_all AS (SELECT MIContainer.*
                               , tmpContainer.PersonalId
                               , tmpContainer.UnitId
                               , tmpContainer.PositionId
                               , tmpContainer.InfoMoneyId
                               , tmpContainer.PersonalServiceListId
                               , tmpContainer.FineSubjectId
                               , tmpContainer.UnitId_FineSubject
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
                               , tmp.PersonalServiceListId
                               , tmp.FineSubjectId
                               , tmp.UnitId_FineSubject
                          FROM (SELECT DISTINCT
                                       tmpMIContainer_all.MovementItemId
                                     , tmpMIContainer_all.PersonalId
                                     , tmpMIContainer_all.UnitId
                                     , tmpMIContainer_all.PositionId
                                     , tmpMIContainer_all.InfoMoneyId
                                     , tmpMIContainer_all.PersonalServiceListId
                                     , tmpMIContainer_all.FineSubjectId
                                     , tmpMIContainer_all.UnitId_FineSubject
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
                                 , tmp.PersonalServiceListId
                                 , tmp.FineSubjectId
                                 , tmp.UnitId_FineSubject
                         )
       -- только проводки - сколько уже выплатили (Авансом)
     , tmpMIContainer AS (SELECT SUM (COALESCE (CASE WHEN tmpMIContainer_all.MovementDescId = zc_Movement_BankAccount() THEN 0 ELSE tmpMIContainer_all.Amount END, 0))  AS Amount
                               , tmpMIContainer_all.PersonalId
                               , tmpMIContainer_all.UnitId
                               , tmpMIContainer_all.PositionId
                               , tmpMIContainer_all.InfoMoneyId
                               , tmpMIContainer_all.PersonalServiceListId
                               , tmpMIContainer_all.FineSubjectId
                               , tmpMIContainer_all.UnitId_FineSubject
                          FROM tmpMIContainer_all
                          GROUP BY tmpMIContainer_all.PersonalId
                                 , tmpMIContainer_all.UnitId
                                 , tmpMIContainer_all.PositionId
                                 , tmpMIContainer_all.InfoMoneyId
                                 , tmpMIContainer_all.PersonalServiceListId
                                 , tmpMIContainer_all.FineSubjectId
                                 , tmpMIContainer_all.UnitId_FineSubject 
                         )
            -- результат
            SELECT tmpListPersonal.MovementItemId
                 , tmpListPersonal.MemberId
                 , tmpListPersonal.PersonalId
                 , tmpListPersonal.UnitId
                 , tmpListPersonal.PositionId
                 , tmpListPersonal.InfoMoneyId
                 , tmpListPersonal.PersonalServiceListId
                 , tmpListPersonal.FineSubjectId
                 , tmpListPersonal.UnitId_FineSubject
                 , CASE WHEN -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0) > 0
                                  -- т.к. в проводках долг с минусом
                             THEN -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0)
                        ELSE 0
                   END AS SummCardSecondRecalc
            FROM tmpListPersonal
                 LEFT JOIN tmpMIContainer ON tmpMIContainer.PersonalId            = tmpListPersonal.PersonalId
                                         AND tmpMIContainer.UnitId                = tmpListPersonal.UnitId
                                         AND tmpMIContainer.PositionId            = tmpListPersonal.PositionId
                                         AND tmpMIContainer.InfoMoneyId           = tmpListPersonal.InfoMoneyId
                                         AND tmpMIContainer.PersonalServiceListId = tmpListPersonal.PersonalServiceListId
                 LEFT JOIN tmpSummCard ON tmpSummCard.PersonalId            = tmpListPersonal.PersonalId
                                      AND tmpSummCard.UnitId                = tmpListPersonal.UnitId
                                      AND tmpSummCard.PositionId            = tmpListPersonal.PositionId
                                      AND tmpSummCard.InfoMoneyId           = tmpListPersonal.InfoMoneyId
                                      AND tmpSummCard.PersonalServiceListId = tmpListPersonal.PersonalServiceListId
                                      AND tmpSummCard.FineSubjectId         = tmpListPersonal.FineSubjectId
                                      AND tmpSummCard.UnitId_FineSubject     = tmpListPersonal.UnitId_FineSubject
            WHERE tmpListPersonal.MovementItemId > 0 
               OR -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0) > 0 -- !!! т.е. если есть долг по ЗП
          ;
 
-- RAISE EXCEPTION '<%>', (select count(*) from _tmpMI where _tmpMI.MemberId = 239655);


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
                                                        , inSummFine           := 0
                                                        , inSummFineOthRecalc  := 0
                                                        , inSummHosp           := 0
                                                        , inSummHospOthRecalc  := 0
                                                        , inSummCompensationRecalc := 0
                                                        , inSummAuditAdd           := 0
                                                        , inComment            := ''
                                                        , inInfoMoneyId        := _tmpMI.InfoMoneyId
                                                        , inUnitId             := _tmpMI.UnitId
                                                        , inPositionId         := _tmpMI.PositionId
                                                        , inMemberId           := NULL
                                                        , inPersonalServiceListId := _tmpMI.PersonalServiceListId
                                                        , inFineSubjectId      := _tmpMI.FineSubjectId
                                                        , inUnitFineSubjectId  := _tmpMI.UnitId_FineSubject
                                                        , inUserId             := vbUserId
                                                         )
     FROM _tmpMI
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = _tmpMI.PersonalId
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
     ;

     -- Проверка
     IF EXISTS (SELECT 1
                FROM MovementItem
                     JOIN MovementItemLinkObject AS MILO_PersonalServiceList
                                                 ON MILO_PersonalServiceList.MovementItemId = MovementItem.Id
                                                AND MILO_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
                     INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                           ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = MILO_PersonalServiceList.ObjectId
                                          AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
                                          AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!вот он БН!!!
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                --AND MovementItem.Amount     > 0
               )
     THEN
         RAISE EXCEPTION 'Ошибка. В распределнии БН найдена ведомость <%>.'
                       , lfGet_Object_ValueData_sh ((SELECT MILO_PersonalServiceList.ObjectId
                                                     FROM MovementItem
                                                          JOIN MovementItemLinkObject AS MILO_PersonalServiceList
                                                                                      ON MILO_PersonalServiceList.MovementItemId = MovementItem.Id
                                                                                     AND MILO_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
                                                          INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                                                ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = MILO_PersonalServiceList.ObjectId
                                                                               AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
                                                                               AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!вот он БН!!!
                                                     WHERE MovementItem.MovementId = inMovementId
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                                     --AND MovementItem.Amount     > 0
                                                     LIMIT 1
                                                    ));
     END IF;
     
/*
RAISE EXCEPTION '<%  >  %', (select count(*) 
from _tmpMI where _tmpMI.MemberId = 239655)
, ( select count(*)  FROM MovementItem
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                               ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                              AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                                              AND ObjectLink_Personal_Member.ChildObjectId   = 239655
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
);
*/

-- !!!тест 
-- PERFORM gpComplete_Movement_PersonalService (inMovementId:= inMovementId, inSession:= inSession);
-- RAISE EXCEPTION 'ок' ;
IF vbUserId = 5
THEN
    RAISE EXCEPTION 'Ошибка.test=ok';
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.06.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId:= 12977959, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId:= 12950764, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId:= 12950244, inSession:= zfCalc_UserAdmin())

-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId:= 12665399, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId:= 12667151, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId:= 12703415, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId:= 12713906, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId:= 12726220, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId:= 12739783, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId:= 12739807, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId:= 12768253, inSession:= zfCalc_UserAdmin())
