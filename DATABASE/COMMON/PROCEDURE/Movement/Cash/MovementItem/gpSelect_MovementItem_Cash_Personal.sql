-- Function: gpSelect_MovementItem_Cash_Personal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Cash_Personal (Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Cash_Personal(
    IN inMovementId     Integer      , -- ключ Документа
    IN inParentId       Integer      , -- ключ Документа
    IN inMovementItemId Integer      , --
    IN inShowAll        Boolean      , --
    IN inIsErased       Boolean      , --
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PersonalId Integer, PersonalCode Integer, PersonalName TVarChar, INN TVarChar, isMain Boolean, isOfficial Boolean
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar, ServiceDate_mp TDateTime

             , Amount TFloat
             , SummService TFloat, SummToPay_cash TFloat, SummToPay TFloat, SummCard TFloat, SummCardSecond TFloat

             , SummAvCardSecond TFloat, SummCardSecondCash TFloat
             , SummCardSecond_all_00807 TFloat, SummCardSecond_diff_00807 TFloat
             , SummCardSecond_all_005 TFloat, SummCardSecond_diff_005 TFloat

             , SummNalog TFloat, SummMinus TFloat, SummFine TFloat, SummAdd TFloat, SummHoliday TFloat, SummHosp TFloat
             , SummSocialIn TFloat, SummSocialAdd TFloat, SummChild TFloat, SummMinusExt TFloat
             , SummTransport TFloat, SummTransportAdd TFloat, SummTransportAddLong TFloat, SummTransportTaxi TFloat, SummPhone TFloat
             , SummCompensation TFloat
             , SummAvance TFloat
             , AmountService_diff TFloat

             , Amount_current TFloat
               -- Аванс (выплачено)
             , Amount_avance TFloat
               -- Аванс (возврат)
             , Amount_avance_ret TFloat
               -- Другие (выплачено)
             , Amount_service TFloat
               -- 
             , SummRemains TFloat, SummCardSecondRemains TFloat
             , AmountCardSecond_avance TFloat
             , isCalculated Boolean
             , Comment TVarChar
             , PersonalServiceListId Integer
           --, PersonalServiceListId_calc Integer
             , MovementId_find Integer, ContainerId_find Integer
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbServiceDateId         Integer;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbServiceDate           TDateTime;
   DECLARE vbIsOnly                Boolean;
   DECLARE vbIsCardSecond          Boolean;
   DECLARE vbKoeffSummCardSecond   NUMERIC (16,10); 
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_Cash());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяем
     vbPersonalServiceListId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inParentId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList());

     -- !!!Проверка прав роль - Ограничение - нет вообще доступа к просмотру данных ЗП!!!
     IF NOT EXISTS (SELECT 1 FROM Object_PersonalServiceList_User_View WHERE Object_PersonalServiceList_User_View.UserId = vbUserId AND (Object_PersonalServiceList_User_View.PersonalServiceListId = vbPersonalServiceListId OR COALESCE (vbPersonalServiceListId, 0) = 0))
     THEN PERFORM lpCheck_UserRole_8813637 (vbUserId);
     END IF;


     -- !!!Проверка прав роль - Ограничение - нет доступа к просмотру ведомость Админ ЗП!!!
     PERFORM lpCheck_UserRole_11026035 (vbPersonalServiceListId, vbUserId);


     -- Блокируем ему просмотр
     IF vbUserId IN (/*9457    -- Климентьев К.И.
                   , */6131893 -- Черняєва О.А.
                    )
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


     -- определили данные из ведомости начисления
     SELECT --ObjectFloat_KoeffSummCardSecond.ValueData AS KoeffSummCardSecond  --Коэфф для выгрузки ведомости Банк 2ф.
            CAST (ObjectFloat_KoeffSummCardSecond.ValueData/ 1000 AS NUMERIC (16,10)) AS KoeffSummCardSecond  --Коэфф для выгрузки ведомости Банк 2ф.
            INTO vbKoeffSummCardSecond
     FROM ObjectFloat AS ObjectFloat_KoeffSummCardSecond
     WHERE ObjectFloat_KoeffSummCardSecond.ObjectId = vbPersonalServiceListId
       AND ObjectFloat_KoeffSummCardSecond.DescId   = zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond()
    ;
     -- если не внесен коєф. берем по умолчанию = 1.00807
     IF COALESCE (vbKoeffSummCardSecond,0) = 0
     THEN
         vbKoeffSummCardSecond := 1.00807;
     END IF;


     -- определяем <Месяц начислений>
     IF inParentId <> 0
     THEN
         vbServiceDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inParentId AND MovementDate.DescId = zc_MIDate_ServiceDate());
         vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= vbServiceDate);
     END IF;


     -- определяем - !!! НЕ схема премии!!!
     vbIsOnly:= -- одинаковые ведомости
              vbPersonalServiceListId = COALESCE ((SELECT MLO_PersonalServiceList.ObjectId
                                                   FROM MovementItem
                                                        LEFT JOIN MovementItemLinkObject AS MLO_PersonalServiceList
                                                                                         ON MLO_PersonalServiceList.MovementItemId = MovementItem.Id
                                                                                        AND MLO_PersonalServiceList.DescId         = zc_MILinkObject_MoneyPlace()
                                                   WHERE MovementItem.MovementId = inMovementId
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                 ))
              -- это НЕ БН для распределения
          AND zc_Enum_PaidKind_FirstForm() <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPersonalServiceListId AND OL.DescId = zc_ObjectLink_PersonalServiceList_PaidKind()), 0)
              -- НЕ основная Ведомость
          AND NOT EXISTS (SELECT 1 FROM Object JOIN ObjectLink AS OL ON OL.ObjectId = Object.Id AND OL.DescId = zc_ObjectLink_Personal_PersonalServiceList() AND OL.ChildObjectId = vbPersonalServiceListId WHERE Object.DescId = zc_Object_Personal() AND Object.isErased = FALSE)
          ;

     -- определяем - !!!ведомость Ф2!!!
     vbIsCardSecond:= EXISTS (SELECT 1
                              FROM Movement
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE

                                   LEFT JOIN MovementItemFloat AS MIFloat_SummService
                                                               ON MIFloat_SummService.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummService.DescId = zc_MIFloat_SummService()

                                   /*LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecond
                                                               ON MIFloat_SummCardSecond.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummCardSecond.DescId = zc_MIFloat_SummCardSecond()*/
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondRecalc
                                                               ON MIFloat_SummCardSecondRecalc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummCardSecondRecalc.DescId = zc_MIFloat_SummCardSecondRecalc()

                                   /*LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecond
                                                               ON MIFloat_SummAvCardSecond.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummAvCardSecond.DescId = zc_MIFloat_SummAvCardSecond()*/
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecondRecalc
                                                               ON MIFloat_SummAvCardSecondRecalc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummAvCardSecondRecalc.DescId = zc_MIFloat_SummAvCardSecondRecalc()

                                   /*LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondCash
                                                               ON MIFloat_SummCardSecondCash.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()*/

                                   /*LEFT JOIN MovementItemFloat AS MIFloat_SummAvance
                                                               ON MIFloat_SummAvance.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummAvance.DescId = zc_MIFloat_SummAvance()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummAvanceRecalc
                                                               ON MIFloat_SummAvanceRecalc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummAvanceRecalc.DescId         = zc_MIFloat_SummAvanceRecalc()*/
                              WHERE Movement.Id = inParentId
                              AND (MIFloat_SummCardSecondRecalc.ValueData <> 0
                                OR MIFloat_SummAvCardSecondRecalc.ValueData <> 0
                                  )
                             );


     -- Результат
     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)
    , tmpMI_Child AS (SELECT MovementItem.Id                          AS MovementItemId
                           , MovementItem.MovementId                  AS MovementId
                           , MovementItem.Amount                      AS Amount
                           , MovementItem.ObjectId                    AS PersonalId
                           , MILinkObject_Unit.ObjectId               AS UnitId
                           , MILinkObject_Position.ObjectId           AS PositionId
                           , MILinkObject_InfoMoney.ObjectId          AS InfoMoneyId
                           , MILinkObject_MoneyPlace.ObjectId         AS MoneyPlaceId
                           , MIDate_ServiceDate.ValueData             AS ServiceDate_mp
                           , MovementItem.isErased
                      FROM tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId = zc_MI_Child()
                                                  AND MovementItem.isErased = tmpIsErased.isErased
                                                  AND (MovementItem.Id = inMovementItemId OR COALESCE (inMovementItemId, 0) = 0)
                                                  AND MovementItem.Amount <> 0
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                            ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

                           LEFT JOIN MovementItem AS MI_Master
                                                  ON MI_Master.MovementId = inMovementId
                                                 AND MI_Master.DescId     = zc_MI_Master()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                            ON MILinkObject_MoneyPlace.MovementItemId = MI_Master.Id
                                                           AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                           LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                                      ON MIDate_ServiceDate.MovementItemId = MI_Master.Id
                                                     AND MIDate_ServiceDate.DescId         = zc_MIDate_ServiceDate()
                     )
          , tmpMI AS (SELECT tmpMI_Child.MovementItemId
                           , tmpMI_Child.Amount
                           , tmpMI_Child.PersonalId
                           , tmpMI_Child.UnitId
                           , tmpMI_Child.PositionId
                           , tmpMI_Child.InfoMoneyId
                           , tmpMI_Child.MoneyPlaceId
                           , tmpMI_Child.ServiceDate_mp
                           , tmpMI_Child.isErased
                      FROM tmpMI_Child

                     UNION ALL
                      SELECT MovementItem.Id                          AS MovementItemId
                           , -1 * MovementItem.Amount                 AS Amount
                           , MILinkObject_MoneyPlace.ObjectId         AS PersonalId
                           , MILinkObject_Unit.ObjectId               AS UnitId
                           , MILinkObject_Position.ObjectId           AS PositionId
                           , MILinkObject_InfoMoney.ObjectId          AS InfoMoneyId
                           , MILinkObject_MoneyPlace.ObjectId         AS MoneyPlaceId
                           , MIDate_ServiceDate.ValueData             AS ServiceDate_mp
                           , MovementItem.isErased
                      FROM tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = tmpIsErased.isErased
                                                  AND (MovementItem.Id = inMovementItemId OR COALESCE (inMovementItemId, 0) = 0)
                                                  AND MovementItem.Amount <> 0
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                            ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                            ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                           LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                                      ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                                     AND MIDate_ServiceDate.DescId         = zc_MIDate_ServiceDate()
                           LEFT JOIN tmpMI_Child ON tmpMI_Child.MovementId = inMovementId
                      WHERE tmpMI_Child.MovementId IS NULL
                     )
                , tmpSummNalog AS (SELECT CLO_Unit.ObjectId       AS UnitId
                                        , CLO_Position.ObjectId   AS PositionId
                                        , CLO_Personal.ObjectId   AS PersonalId
                                        , CLO_InfoMoney.ObjectId  AS InfoMoneyId
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
                                        LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                      ON CLO_InfoMoney.ContainerId = MIContainer.ContainerId
                                                                     AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                   WHERE MIContainer.MovementId = inParentId
                                     AND MIContainer.DescId     = zc_MIContainer_Summ()
                                     AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_PersonalService_Nalog())
                                   GROUP BY CLO_Unit.ObjectId
                                          , CLO_Position.ObjectId
                                          , CLO_Personal.ObjectId
                                          , CLO_InfoMoney.ObjectId
                                  )
          , tmpParent_all AS (SELECT SUM (CASE WHEN Movement.DescId = zc_Movement_PersonalTransport() THEN MovementItem.Amount ELSE COALESCE (MIFloat_SummService.ValueData, 0) END) AS SummService
                                   , SUM (CASE WHEN Movement.DescId = zc_Movement_PersonalTransport() THEN MovementItem.Amount + COALESCE (MIFloat_SummAvanceRecalc.ValueData, 0)
                                          ELSE COALESCE (MIFloat_SummToPay.ValueData, 0) /*- COALESCE (tmpSummNalog.SummNalog, 0)*/ + COALESCE (MIFloat_SummNalog.ValueData, 0)
                                             - COALESCE (MIFloat_SummCard.ValueData, 0)
                                             - COALESCE (MIFloat_SummCardSecond.ValueData, 0)
                                             - COALESCE (MIFloat_SummAvCardSecond.ValueData, 0)
                                             - COALESCE (MIFloat_SummCardSecondCash.ValueData, 0)
                                           --- COALESCE (MIFloat_SummAvance.ValueData, 0)
                                             + COALESCE (MIFloat_SummAvanceRecalc.ValueData, 0)
                                          END
                                         ) AS SummToPay_cash
                                   , SUM (CASE WHEN Movement.DescId = zc_Movement_PersonalTransport() THEN MovementItem.Amount
                                          ELSE COALESCE (MIFloat_SummToPay.ValueData, 0)  /*- COALESCE (tmpSummNalog.SummNalog, 0)*/ + COALESCE (MIFloat_SummNalog.ValueData, 0)
                                          END
                                         ) AS SummToPay
                                   , SUM (COALESCE (MIFloat_SummCard.ValueData, 0))         AS SummCard
                                   , SUM (COALESCE (MIFloat_SummCardSecond.ValueData, 0))   AS SummCardSecond
                                   , SUM (COALESCE (MIFloat_SummAvCardSecond.ValueData, 0)) AS SummAvCardSecond
                                   , SUM (COALESCE (MIFloat_SummCardSecondCash.ValueData, 0) + COALESCE (MIFloat_SummCardSecondRecalc.ValueData, 0) + COALESCE (MIFloat_SummAvCardSecondRecalc.ValueData, 0)) AS SummCardSecondCash
--                                 , SUM (COALESCE (MIFloat_SummNalog.ValueData, 0))        AS SummNalog
--                                 , SUM (COALESCE (tmpSummNalog.SummNalog, 0))             AS SummNalog
                                   , SUM (COALESCE (MIFloat_SummMinus.ValueData, 0))        AS SummMinus
                                   , SUM (COALESCE (MIFloat_SummFine.ValueData, 0))         AS SummFine
                                   , SUM (COALESCE (MIFloat_SummAdd.ValueData, 0))          AS SummAdd
                                   , SUM (COALESCE (MIFloat_SummAddOth.ValueData, 0))       AS SummAddOth
                                   , SUM (COALESCE (MIFloat_SummHoliday.ValueData, 0))      AS SummHoliday
                                   , SUM (COALESCE (MIFloat_SummHosp.ValueData, 0))         AS SummHosp
                                   , SUM (COALESCE (MIFloat_SummSocialIn.ValueData, 0))     AS SummSocialIn
                                   , SUM (COALESCE (MIFloat_SummSocialAdd.ValueData, 0))    AS SummSocialAdd
                                   , SUM (COALESCE (MIFloat_SummChild.ValueData, 0))        AS SummChild
                                   , SUM (COALESCE (MIFloat_SummMinusExt.ValueData, 0))     AS SummMinusExt
                                   , SUM (COALESCE (MIFloat_SummTransport.ValueData, 0))        AS SummTransport
                                   , SUM (COALESCE (MIFloat_SummTransportAdd.ValueData, 0))     AS SummTransportAdd
                                   , SUM (COALESCE (MIFloat_SummTransportAddLong.ValueData, 0)) AS SummTransportAddLong
                                   , SUM (COALESCE (MIFloat_SummTransportTaxi.ValueData, 0))    AS SummTransportTaxi
                                   , SUM (COALESCE (MIFloat_SummPhone.ValueData, 0))            AS SummPhone
                                   , SUM (COALESCE (MIFloat_SummCompensation.ValueData, 0))     AS SummCompensation
                                   , SUM (COALESCE (MIFloat_SummAvance.ValueData, 0) + COALESCE (MIFloat_SummAvanceRecalc.ValueData, 0)) AS SummAvance
                                   , SUM (COALESCE (MIFloat_SummAvanceRecalc.ValueData, 0)) AS SummAvanceRecalc
                                   , MovementItem.ObjectId                                  AS PersonalId
                                   , ObjectLink_Personal_Member.ChildObjectId               AS MemberId_Personal
                                   , MILinkObject_Unit.ObjectId                             AS UnitId
                                   , MILinkObject_Position.ObjectId                         AS PositionId
                                   , MILinkObject_InfoMoney.ObjectId                        AS InfoMoneyId

                                     -- замена - Премии производство (добавочная)
                                   , CASE WHEN MLO_PersonalServiceList.ObjectId = 445325 
                                               THEN MLO_PersonalServiceList.ObjectId
                                          ELSE COALESCE (ObjectLink_Personal_PersonalServiceList.ChildObjectId, MILO_PersonalServiceList.ObjectId, MLO_PersonalServiceList.ObjectId)
                                     END AS PersonalServiceListId
                                   , CASE WHEN MLO_PersonalServiceList.ObjectId = 445325 
                                               THEN 0
                                          ELSE COALESCE (MILO_PersonalServiceList.ObjectId, MLO_PersonalServiceList.ObjectId)
                                     END AS PersonalServiceListId_calc

                              FROM Movement
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND (MovementItem.isErased = FALSE OR inShowAll = TRUE)
                                                          -- AND MovementItem.Amount <> 0
                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                        ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                       AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                   LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                                ON MLO_PersonalServiceList.MovementId = Movement.Id
                                                               AND MLO_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                   LEFT JOIN MovementItemLinkObject AS MILO_PersonalServiceList
                                                                    ON MILO_PersonalServiceList.MovementItemId = MovementItem.Id
                                                                   AND MILO_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
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
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecond
                                                               ON MIFloat_SummAvCardSecond.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummAvCardSecond.DescId = zc_MIFloat_SummAvCardSecond()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondCash
                                                               ON MIFloat_SummCardSecondCash.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummNalog
                                                               ON MIFloat_SummNalog.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummNalog.DescId = zc_MIFloat_SummNalog()

                                   LEFT JOIN MovementItemFloat AS MIFloat_SummMinus
                                                               ON MIFloat_SummMinus.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummFine
                                                               ON MIFloat_SummFine.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummFine.DescId         = zc_MIFloat_SummFine()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                                               ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummAddOth
                                                               ON MIFloat_SummAddOth.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummAddOth.DescId = zc_MIFloat_SummAddOth()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummHoliday
                                                               ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummHosp
                                                               ON MIFloat_SummHosp.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummHosp.DescId         = zc_MIFloat_SummHosp()

                                   LEFT JOIN MovementItemFloat AS MIFloat_SummCompensation
                                                               ON MIFloat_SummCompensation.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummCompensation.DescId = zc_MIFloat_SummCompensation()

                                   LEFT JOIN MovementItemFloat AS MIFloat_SummSocialIn
                                                               ON MIFloat_SummSocialIn.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                                               ON MIFloat_SummSocialAdd.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummChild
                                                               ON MIFloat_SummChild.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummMinusExt
                                                               ON MIFloat_SummMinusExt.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummMinusExt.DescId = zc_MIFloat_SummMinusExt()

                                   LEFT JOIN MovementItemFloat AS MIFloat_SummTransport
                                                               ON MIFloat_SummTransport.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummTransport.DescId = zc_MIFloat_SummTransport()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummTransportAdd
                                                               ON MIFloat_SummTransportAdd.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummTransportAdd.DescId = zc_MIFloat_SummTransportAdd()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummTransportAddLong
                                                               ON MIFloat_SummTransportAddLong.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummTransportAddLong.DescId = zc_MIFloat_SummTransportAddLong()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummTransportTaxi
                                                               ON MIFloat_SummTransportTaxi.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummTransportTaxi.DescId = zc_MIFloat_SummTransportTaxi()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummPhone
                                                               ON MIFloat_SummPhone.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummPhone.DescId = zc_MIFloat_SummPhone()

                                   LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondRecalc
                                                               ON MIFloat_SummCardSecondRecalc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummCardSecondRecalc.DescId = zc_MIFloat_SummCardSecondRecalc()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecondRecalc
                                                               ON MIFloat_SummAvCardSecondRecalc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummAvCardSecondRecalc.DescId = zc_MIFloat_SummAvCardSecondRecalc()

                                   LEFT JOIN MovementItemFloat AS MIFloat_SummAvance
                                                               ON MIFloat_SummAvance.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummAvance.DescId = zc_MIFloat_SummAvance()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummAvanceRecalc
                                                               ON MIFloat_SummAvanceRecalc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummAvanceRecalc.DescId         = zc_MIFloat_SummAvanceRecalc()

                                   -- ограничение, если нужна только 1 запись
                                   LEFT JOIN (SELECT tmpMI.PersonalId, tmpMI.UnitId, tmpMI.PositionId, tmpMI.InfoMoneyId
                                              FROM tmpMI
                                              LIMIT 1
                                             ) AS tmp ON tmp.PersonalId   = MovementItem.ObjectId
                                                     AND tmp.UnitId       = MILinkObject_Unit.ObjectId
                                                     AND tmp.PositionId   = MILinkObject_Position.ObjectId
                                                     AND tmp.InfoMoneyId  = MILinkObject_InfoMoney.ObjectId
                                                     AND inMovementItemId > 0
                                   -- Замена
                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                                        ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId      = MovementItem.ObjectId
                                                       AND ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId = MLO_PersonalServiceList.ObjectId
                                                       AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId        = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                        ON ObjectLink_Personal_PersonalServiceList.ObjectId = MovementItem.ObjectId -- ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                       AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()

                              WHERE Movement.Id = inParentId
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                AND (tmp.PersonalId IS NOT NULL OR COALESCE (inMovementItemId, 0) = 0) -- ограничение, если нужна только 1 запись


                                AND (MovementItem.Amount <> 0
                                  OR MIFloat_SummService.ValueData <> 0
                                  OR MIFloat_SummAvanceRecalc.ValueData <> 0
                                  OR MIFloat_SummAvance.ValueData <> 0
                                  OR MIFloat_SummToPay.ValueData <> 0
                                  OR MIFloat_SummNalog.ValueData <> 0

                                  OR MIFloat_SummCard.ValueData <> 0
                                  OR MIFloat_SummCardSecond.ValueData <> 0
                                  OR MIFloat_SummAvCardSecond.ValueData <> 0
                                  OR MIFloat_SummCardSecondCash.ValueData <> 0
                                  OR MIFloat_SummCardSecondRecalc.ValueData <> 0
                                  OR MIFloat_SummAvCardSecondRecalc.ValueData <> 0

                                  OR MIFloat_SummMinus.ValueData <> 0
                                  OR MIFloat_SummFine.ValueData <> 0
                                  OR MIFloat_SummAdd.ValueData <> 0
                                  OR MIFloat_SummAddOth.ValueData <> 0
                                  OR MIFloat_SummHoliday.ValueData <> 0
                                  OR MIFloat_SummHosp.ValueData <> 0
                                  OR MIFloat_SummSocialIn.ValueData <> 0
                                  OR MIFloat_SummSocialAdd.ValueData <> 0
                                  OR MIFloat_SummChild.ValueData <> 0
                                  OR MIFloat_SummMinusExt.ValueData <> 0
                                  OR MIFloat_SummTransport.ValueData <> 0
                                  OR MIFloat_SummTransportAdd.ValueData <> 0
                                  OR MIFloat_SummTransportAddLong.ValueData <> 0
                                  OR MIFloat_SummTransportTaxi.ValueData <> 0
                                  OR MIFloat_SummPhone.ValueData <> 0
                                  OR MIFloat_SummCompensation.ValueData <> 0
                                  -- OR vbUserId = 5
                                  --OR inShowAll = TRUE
                                    )

                              GROUP BY MovementItem.ObjectId
                                     , MILinkObject_Unit.ObjectId
                                     , MILinkObject_Position.ObjectId
                                     , MILinkObject_InfoMoney.ObjectId
                                       -- замена - Премии производство (добавочная)
                                     , CASE WHEN MLO_PersonalServiceList.ObjectId = 445325 
                                                 THEN MLO_PersonalServiceList.ObjectId
                                            ELSE COALESCE (ObjectLink_Personal_PersonalServiceList.ChildObjectId, MILO_PersonalServiceList.ObjectId, MLO_PersonalServiceList.ObjectId)
                                       END
                                     , CASE WHEN MLO_PersonalServiceList.ObjectId = 445325 
                                                 THEN 0
                                            ELSE COALESCE (MILO_PersonalServiceList.ObjectId, MLO_PersonalServiceList.ObjectId)
                                       END

                                     , ObjectLink_Personal_Member.ChildObjectId
                             )
     , tmpMI_card_b2 AS (SELECT tmpParent_all.MemberId_Personal
                              , SUM (tmpParent_all.SummCardSecondCash) AS Summ_calc
                         FROM tmpParent_all
                         GROUP BY tmpParent_all.MemberId_Personal
                        )
              , tmpParent AS (SELECT tmpParent_all.SummService
                                   , tmpParent_all.SummToPay_cash - COALESCE (tmpSummNalog.SummNalog, 0) AS SummToPay_cash
                                   , tmpParent_all.SummToPay - COALESCE (tmpSummNalog.SummNalog, 0) AS SummToPay
                                   , tmpParent_all.SummCard
                                   , tmpParent_all.SummCardSecond
                                   , tmpParent_all.SummAvCardSecond
                                   , tmpParent_all.SummCardSecondCash
--                                 , tmpParent_all.SummNalog
                                   , COALESCE (tmpSummNalog.SummNalog, 0) AS SummNalog
                                   , tmpParent_all.SummMinus
                                   , tmpParent_all.SummFine
                                   , tmpParent_all.SummAdd
                                   , tmpParent_all.SummAddOth
                                   , tmpParent_all.SummHoliday
                                   , tmpParent_all.SummHosp
                                   , tmpParent_all.SummSocialIn
                                   , tmpParent_all.SummSocialAdd
                                   , tmpParent_all.SummChild
                                   , tmpParent_all.SummMinusExt
                                   , tmpParent_all.SummTransport
                                   , tmpParent_all.SummTransportAdd
                                   , tmpParent_all.SummTransportAddLong
                                   , tmpParent_all.SummTransportTaxi
                                   , tmpParent_all.SummPhone
                                   , tmpParent_all.SummCompensation
                                   , tmpParent_all.SummAvance
                                   , tmpParent_all.SummAvanceRecalc

                                   , tmpParent_all.PersonalId
                                   , tmpParent_all.MemberId_Personal
                                   , tmpParent_all.UnitId
                                   , tmpParent_all.PositionId
                                   , tmpParent_all.InfoMoneyId
                                   , tmpParent_all.PersonalServiceListId
                                 --, tmpParent_all.PersonalServiceListId_calc

                              FROM tmpParent_all
                                   LEFT JOIN tmpSummNalog ON tmpSummNalog.PersonalId  = tmpParent_all.PersonalId
                                                         AND tmpSummNalog.UnitId      = tmpParent_all.UnitId
                                                         AND tmpSummNalog.PositionId  = tmpParent_all.PositionId
                                                         AND tmpSummNalog.InfoMoneyId = tmpParent_all.InfoMoneyId
                             UNION
                              SELECT DISTINCT
                                     0 AS SummService
                                   , 0 AS SummToPay_cash
                                   , 0 AS SummToPay
                                   , 0 AS SummCard
                                   , 0 AS SummCardSecond
                                   , 0 AS SummAvCardSecond
                                   , 0 AS SummCardSecondCash
                                   , 0 AS SummNalog
                                   , 0 AS SummMinus
                                   , 0 AS SummFine
                                   , 0 AS SummAdd
                                   , 0 AS SummAddOth
                                   , 0 AS SummHoliday
                                   , 0 AS SummHosp
                                   , 0 AS SummSocialIn
                                   , 0 AS SummSocialAdd
                                   , 0 AS SummChild
                                   , 0 AS SummMinusExt
                                   , 0 AS SummTransport
                                   , 0 AS SummTransportAdd
                                   , 0 AS SummTransportAddLong
                                   , 0 AS SummTransportTaxi
                                   , 0 AS SummPhone
                                   , 0 AS SummCompensation
                                   , 0 AS SummAvance
                                   , 0 AS SummAvanceRecalc

                                   , CLO_Personal.ObjectId                    AS PersonalId
                                   , ObjectLink_Personal_Member.ChildObjectId AS MemberId_Personal
                                   , CLO_Unit.ObjectId                        AS UnitId
                                   , CLO_Position.ObjectId                    AS PositionId
                                   , CLO_InfoMoney.ObjectId                   AS InfoMoneyId
                                   , tmp.PersonalServiceListId
                                 --, tmp.PersonalServiceListId_calc


                              FROM (SELECT DISTINCT tmpParent_all.PersonalServiceListId, tmpParent_all.InfoMoneyId FROM tmpParent_all) AS tmp
                                   INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                                  ON CLO_PersonalServiceList.ObjectId    = tmp.PersonalServiceListId
                                                                 AND CLO_PersonalServiceList.DescId      = zc_ContainerLinkObject_PersonalServiceList()
                                   INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                                  ON CLO_ServiceDate.ObjectId    = vbServiceDateId
                                                                 AND CLO_ServiceDate.DescId      = zc_ContainerLinkObject_ServiceDate()
                                                                 AND CLO_ServiceDate.ContainerId = CLO_PersonalServiceList.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                  ON CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                                                 AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                   INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                  ON CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                                                 AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                                                 AND CLO_InfoMoney.ObjectId    = tmp.InfoMoneyId
                                   INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                  ON CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                                                 AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                   INNER JOIN ContainerLinkObject AS CLO_Position
                                                                  ON CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                                                 AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                                   LEFT JOIN tmpParent_all ON tmpParent_all.PersonalId            = CLO_Personal.ObjectId
                                                          AND tmpParent_all.UnitId                = CLO_Unit.ObjectId
                                                          AND tmpParent_all.PositionId            = CLO_Position.ObjectId
                                                          AND tmpParent_all.InfoMoneyId           = CLO_InfoMoney.ObjectId
                                                          AND tmpParent_all.PersonalServiceListId = tmp.PersonalServiceListId
                                   -- если у сотрудника "текущая" является ServiceListCardSecond
                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                                        ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId      = CLO_Personal.ObjectId
                                                       AND ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId = vbPersonalServiceListId
                                                       AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId        = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
                                   -- если он есть в текущих элементах
                                   LEFT JOIN (SELECT DISTINCT tmpMI.PersonalId, tmpMI.UnitId, tmpMI.PositionId, tmpMI.InfoMoneyId FROM tmpMI
                                             ) AS tmpMI ON tmpMI.PersonalId  = CLO_Personal.ObjectId
                                                       AND tmpMI.UnitId      = CLO_Unit.ObjectId
                                                       AND tmpMI.PositionId  = CLO_Position.ObjectId
                                                       AND tmpMI.InfoMoneyId = CLO_InfoMoney.ObjectId
                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                        ON ObjectLink_Personal_Member.ObjectId = CLO_Personal.ObjectId
                                                       AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                              WHERE tmpParent_all.PersonalId IS NULL
                                AND COALESCE (inMovementItemId, 0) = 0
                                AND (ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId > 0 OR tmpMI.PersonalId > 0)
                             )
           , tmpContainer AS (SELECT CLO_ServiceDate.ContainerId
                                   , tmpParent.PersonalId
                                   , tmpParent.UnitId
                                   , tmpParent.PositionId
                                   , tmpParent.InfoMoneyId
                                   , tmpParent.PersonalServiceListId
                              FROM tmpParent
                                   INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                                  ON CLO_ServiceDate.ObjectId = vbServiceDateId
                                                                 AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate()
                                   INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                  ON CLO_Personal.ObjectId = tmpParent.PersonalId
                                                                 AND CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                                                 AND CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                  ON CLO_InfoMoney.ObjectId = tmpParent.InfoMoneyId
                                                                 AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                 AND CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                  ON CLO_Unit.ObjectId = tmpParent.UnitId
                                                                 AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                 AND CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_Position
                                                                  ON CLO_Position.ObjectId = tmpParent.PositionId
                                                                 AND CLO_Position.DescId = zc_ContainerLinkObject_Position()
                                                                 AND CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                                  ON CLO_PersonalServiceList.ObjectId = tmpParent.PersonalServiceListId
                                                                 AND CLO_PersonalServiceList.DescId = zc_ContainerLinkObject_PersonalServiceList()
                                                                 AND CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                              -- !!! НЕ схема премии!!!
                              WHERE vbIsOnly = FALSE
                                --AND (vbPersonalServiceListId <> 445325 OR vbUserId <> 5)

                             UNION
                              SELECT CLO_ServiceDate.ContainerId
                                   , tmpParent.PersonalId
                                   , tmpParent.UnitId
                                   , tmpParent.PositionId
                                   , tmpParent.InfoMoneyId
                                   , tmpParent.PersonalServiceListId
                              FROM tmpParent_all AS tmpParent
                                   INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                                  ON CLO_ServiceDate.ObjectId = vbServiceDateId
                                                                 AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate()
                                   INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                  ON CLO_Personal.ObjectId = tmpParent.PersonalId
                                                                 AND CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                                                 AND CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                  ON CLO_InfoMoney.ObjectId = tmpParent.InfoMoneyId
                                                                 AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                 AND CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                  ON CLO_Unit.ObjectId = tmpParent.UnitId
                                                                 AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                 AND CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_Position
                                                                  ON CLO_Position.ObjectId = tmpParent.PositionId
                                                                 AND CLO_Position.DescId = zc_ContainerLinkObject_Position()
                                                                 AND CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                                  ON CLO_PersonalServiceList.ObjectId = tmpParent.PersonalServiceListId_calc
                                                                 AND CLO_PersonalServiceList.DescId = zc_ContainerLinkObject_PersonalServiceList()
                                                                 AND CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                              -- !!! НЕ схема премии!!!
                              WHERE vbIsOnly = FALSE
                                --AND (vbPersonalServiceListId <> 445325 OR vbUserId <> 5)
                             )
          /*tmpCash*/
         , tmpMIContainer AS (SELECT SUM (CASE WHEN MIContainer.MovementId = inMovementId AND MIContainer.MovementDescId = zc_Movement_Cash() THEN MIContainer.Amount ELSE 0 END) AS Amount_current
                                     -- Аванс (выплачено)
                                   , SUM (CASE WHEN MIContainer.MovementId <> inMovementId AND vbIsCardSecond = FALSE AND MIContainer.MovementDescId = zc_Movement_Cash() AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalAvance()) /*AND tmpContainer.isAvance = TRUE*/ AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END) AS Amount_avance
                                     -- Аванс (возврат)
                                   , SUM (CASE WHEN MIContainer.MovementId <> inMovementId AND vbIsCardSecond = FALSE AND MIContainer.MovementDescId = zc_Movement_Cash() AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalAvance()) /*AND tmpContainer.isAvance = TRUE*/ AND MIContainer.Amount < 0 THEN MIContainer.Amount ELSE 0 END) AS Amount_avance_ret

                                     -- Карта БН - 2ф.  (выплачено)
                                   , SUM (CASE WHEN MIContainer.MovementId <> inMovementId AND MIContainer.MovementDescId = zc_Movement_Cash() AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalCardSecond()) AND vbPersonalServiceListId = Object_PersonalServiceList.Id AND (COALESCE (Object_PersonalServiceList.ValueData, '') NOT ILIKE '%Аванс%' OR vbUserId = -5) THEN MIContainer.Amount ELSE 0 END) AS AmountCardSecond_avance
                                     -- Другие (выплачено)
                                   , SUM (CASE WHEN CLO_PersonalServiceList.ObjectId <> vbPersonalServiceListId and 1=1 then 0 WHEN MIContainer.MovementId <> inMovementId AND vbIsCardSecond = FALSE AND MIContainer.MovementDescId = zc_Movement_Cash() AND (MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Cash_PersonalService())THEN MIContainer.Amount ELSE 0 END) AS Amount_service

                                   , tmpContainer.PersonalId
                                   , tmpContainer.UnitId
                                   , tmpContainer.PositionId
                                   , tmpContainer.InfoMoneyId
                                   , tmpContainer.PersonalServiceListId
                                   , MAX (MIContainer.MovementId) AS MovementId_find
                                   , MAX (tmpContainer.ContainerId) AS ContainerId_find
                              FROM tmpContainer
                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId    = tmpContainer.ContainerId
                                                                   AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                                   AND MIContainer.MovementDescId = zc_Movement_Cash()
                                   LEFT JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                                 ON CLO_PersonalServiceList.ContainerId = MIContainer.ContainerId
                                                                AND CLO_PersonalServiceList.DescId     = zc_ContainerLinkObject_PersonalServiceList()
                                   LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                                   LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList_cash
                                                                ON MLO_PersonalServiceList_cash.MovementId = MIContainer.MovementId
                                                               AND MLO_PersonalServiceList_cash.DescId     = zc_MovementLinkObject_PersonalServiceList()

                                   LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                                ON MLO_PersonalServiceList.MovementId = Movement.ParentId
                                                               AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                   LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = COALESCE (MLO_PersonalServiceList_cash.ObjectId, MLO_PersonalServiceList.ObjectId)

                              GROUP BY tmpContainer.PersonalId
                                     , tmpContainer.UnitId
                                     , tmpContainer.PositionId
                                     , tmpContainer.InfoMoneyId
                                     , tmpContainer.PersonalServiceListId
                                   --, MIContainer.MovementDescId
                             )
       -- <Карта БН (округление) - 2ф>
     , tmpMIContainer_diff AS (SELECT SUM (MIContainer.Amount) AS AmountService_diff
                                   , tmpContainer.PersonalId
                                   , tmpContainer.UnitId
                                   , tmpContainer.PositionId
                                   , tmpContainer.InfoMoneyId
                                   , tmpContainer.PersonalServiceListId
                                   , MAX (MIContainer.MovementId) AS MovementId_find
                                   , MAX (tmpContainer.ContainerId) AS ContainerId_find
                              FROM tmpContainer
                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId    = tmpContainer.ContainerId
                                                                   AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                                   AND MIContainer.MovementDescId = zc_Movement_PersonalService()
                                                                   -- <Карта БН (округление) - 2ф>
                                                                   AND MIContainer.AnalyzerId     = zc_Enum_AnalyzerId_PersonalService_SummDiff()
                                                                   --and 1=0
                              GROUP BY tmpContainer.PersonalId
                                     , tmpContainer.UnitId
                                     , tmpContainer.PositionId
                                     , tmpContainer.InfoMoneyId
                                     , tmpContainer.PersonalServiceListId
                             )
         , tmpAvance_Only AS (SELECT MI_Child.ObjectId     AS PersonalId
                                   , SUM (CASE WHEN MI_Child.MovementId = inMovementId THEN 0 ELSE MI_Child.Amount END) AS Amount
                              FROM Movement
                                 /*INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                                 ON MLO_PersonalServiceList.MovementId = Movement.Id
                                                                AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                                AND MLO_PersonalServiceList.ObjectId   = vbPersonalServiceListId*/

                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = FALSE
                                   INNER JOIN MovementItemLinkObject AS MLO_PersonalServiceList
                                                                     ON MLO_PersonalServiceList.MovementItemId = MovementItem.Id
                                                                    AND MLO_PersonalServiceList.DescId         = zc_MILinkObject_MoneyPlace()
                                                                    AND MLO_PersonalServiceList.ObjectId       = vbPersonalServiceListId
                                   INNER JOIN MovementItemDate AS MIDate_ServiceDate
                                                               ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                                              AND MIDate_ServiceDate.DescId        = zc_MIDate_ServiceDate()
                                                              AND MIDate_ServiceDate.ValueData     = vbServiceDate
                                   INNER JOIN MovementItem AS MI_Child
                                                           ON MI_Child.MovementId = Movement.Id
                                                          AND MI_Child.DescId     = zc_MI_Child()
                                                          AND MI_Child.isErased   = FALSE


                              WHERE Movement.DescId   = zc_Movement_Cash()
                                AND Movement.StatusId = zc_Enum_Status_Complete()

                                -- !!!схема премии!!!
                                AND vbIsOnly = TRUE

                              GROUP BY MI_Child.ObjectId
                             )
             , tmpService AS (SELECT tmpParent.PersonalId
                                   , tmpParent.MemberId_Personal
                                   , tmpParent.UnitId
                                   , tmpParent.PositionId
                                   , tmpParent.InfoMoneyId
                                   , SUM (tmpParent.SummService) AS SummService
                                   , SUM (tmpParent.SummToPay_cash)               AS SummToPay_cash
                                   , SUM (tmpParent.SummToPay)                    AS SummToPay
                                   , SUM (tmpParent.SummCard)                     AS SummCard
                                   , SUM (tmpParent.SummCardSecond)               AS SummCardSecond
                                   , SUM (tmpParent.SummAvCardSecond)             AS SummAvCardSecond
                                   , SUM (tmpParent.SummCardSecondCash)           AS SummCardSecondCash
                                   , SUM (tmpParent.SummNalog)                    AS SummNalog
                                   , SUM (tmpParent.SummMinus)                    AS SummMinus
                                   , SUM (tmpParent.SummFine)                     AS SummFine
                                   , SUM (tmpParent.SummAdd)                      AS SummAdd
                                   , SUM (tmpParent.SummAddOth)                   AS SummAddOth
                                   , SUM (tmpParent.SummHoliday)                  AS SummHoliday
                                   , SUM (tmpParent.SummHosp)                     AS SummHosp
                                   , SUM (tmpParent.SummSocialIn)                 AS SummSocialIn
                                   , SUM (tmpParent.SummSocialAdd)                AS SummSocialAdd
                                   , SUM (tmpParent.SummChild)                    AS SummChild
                                   , SUM (tmpParent.SummMinusExt)                 AS SummMinusExt
                                   , SUM (tmpParent.SummTransport)                AS SummTransport
                                   , SUM (tmpParent.SummTransportAdd)             AS SummTransportAdd
                                   , SUM (tmpParent.SummTransportAddLong)         AS SummTransportAddLong
                                   , SUM (tmpParent.SummTransportTaxi)            AS SummTransportTaxi
                                   , SUM (tmpParent.SummPhone)                    AS SummPhone
                                   , SUM (tmpParent.SummCompensation)             AS SummCompensation
                                   , SUM (tmpParent.SummAvance)                   AS SummAvance
                                   , SUM (tmpParent.SummAvanceRecalc)             AS SummAvanceRecalc
                                   , SUM (tmpMIContainer.Amount_current)          AS Amount_current
                                   , SUM (tmpMIContainer.Amount_avance)           AS Amount_avance
                                   , SUM (tmpMIContainer.Amount_avance_ret)       AS Amount_avance_ret
                                   , SUM (tmpMIContainer.AmountCardSecond_avance) AS AmountCardSecond_avance
                                   , SUM (tmpMIContainer.Amount_service)          AS Amount_service
                                   , SUM (COALESCE (tmpMIContainer_diff.AmountService_diff, 0)) AS AmountService_diff
                                   , 0 AS PersonalServiceListId
                                   , MAX (tmpMIContainer.MovementId_find)         AS MovementId_find
                                   , MAX (tmpMIContainer.ContainerId_find)        AS ContainerId_find
                                -- , tmpParent.PersonalServiceListId
                                 --, tmpParent.PersonalServiceListId_calc
                              FROM tmpParent
                                   LEFT JOIN tmpMIContainer ON tmpMIContainer.PersonalId            = tmpParent.PersonalId
                                                           AND tmpMIContainer.UnitId                = tmpParent.UnitId
                                                           AND tmpMIContainer.PositionId            = tmpParent.PositionId
                                                           AND tmpMIContainer.InfoMoneyId           = tmpParent.InfoMoneyId
                                                           AND tmpMIContainer.PersonalServiceListId = tmpParent.PersonalServiceListId
                                   LEFT JOIN tmpMIContainer_diff ON tmpMIContainer_diff.PersonalId            = tmpParent.PersonalId
                                                                AND tmpMIContainer_diff.UnitId                = tmpParent.UnitId
                                                                AND tmpMIContainer_diff.PositionId            = tmpParent.PositionId
                                                                AND tmpMIContainer_diff.InfoMoneyId           = tmpParent.InfoMoneyId
                                                                AND tmpMIContainer_diff.PersonalServiceListId = tmpParent.PersonalServiceListId
                                                           
                              GROUP BY tmpParent.PersonalId
                                     , tmpParent.MemberId_Personal
                                     , tmpParent.UnitId
                                     , tmpParent.PositionId
                                     , tmpParent.InfoMoneyId
                             )
                , tmpData AS (SELECT tmpMI.MovementItemId
                                   , tmpMI.Amount
                                   , tmpMI.MoneyPlaceId
                                   , tmpMI.ServiceDate_mp
                                   , tmpService.SummService
                                   , tmpService.SummToPay_cash
                                   , tmpService.SummToPay
                                   , tmpService.SummCard
                                   , tmpService.SummCardSecond
                                   , tmpService.SummAvCardSecond
                                   , tmpService.SummCardSecondCash
                                   , tmpService.SummNalog
                                   , tmpService.SummMinus
                                   , tmpService.SummFine
                                   , tmpService.SummAdd
                                   , tmpService.SummAddOth
                                   , tmpService.SummHoliday
                                   , tmpService.SummHosp
                                   , tmpService.SummSocialIn
                                   , tmpService.SummSocialAdd
                                   , tmpService.SummChild
                                   , tmpService.SummMinusExt
                                   , tmpService.SummTransport
                                   , tmpService.SummTransportAdd
                                   , tmpService.SummTransportAddLong
                                   , tmpService.SummTransportTaxi
                                   , tmpService.SummPhone
                                   , tmpService.SummCompensation
                                   , tmpService.SummAvance
                                   , tmpService.SummAvanceRecalc
                                   , tmpService.Amount_current
                                   , tmpService.Amount_avance
                                   , tmpService.Amount_avance_ret
                                   , tmpService.AmountCardSecond_avance
                                   , tmpService.Amount_service
                                   , tmpService.AmountService_diff
                                   , COALESCE (tmpMI.PersonalId, tmpService.PersonalId)   AS PersonalId
                                   , COALESCE (tmpService.MemberId_Personal, 0)           AS MemberId_Personal
                                   , COALESCE (tmpMI.UnitId, tmpService.UnitId)           AS UnitId
                                   , COALESCE (tmpMI.PositionId, tmpService.PositionId)   AS PositionId
                                   , COALESCE (tmpMI.InfoMoneyId, tmpService.InfoMoneyId) AS InfoMoneyId
                                   , COALESCE (tmpMI.isErased, FALSE)                     AS isErased
                                   , COALESCE (tmpService.PersonalServiceListId, 0)       AS PersonalServiceListId
                                 --, COALESCE (tmpService.PersonalServiceListId_calc, 0)  AS PersonalServiceListId_calc
                                   , tmpService.MovementId_find
                                   , tmpService.ContainerId_find
                                     --
                                   , ROW_NUMBER() OVER (PARTITION BY COALESCE (tmpMI.PersonalId, tmpService.PersonalId) ORDER BY tmpService.SummAdd DESC) AS Ord
                                   , ROW_NUMBER() OVER (PARTITION BY COALESCE (tmpService.MemberId_Personal, 0) ORDER BY tmpService.SummCardSecondCash DESC) AS Ord_2
                              FROM tmpMI
                                   FULL JOIN tmpService ON tmpService.PersonalId  = tmpMI.PersonalId
                                                       AND tmpService.UnitId      = tmpMI.UnitId
                                                       AND tmpService.PositionId  = tmpMI.PositionId
                                                       AND tmpService.InfoMoneyId = tmpMI.InfoMoneyId
                             )

          -- определяем - !!!аванс - факт (другой алгоритм)!!!
        , tmpAvance_find AS (SELECT MovementItem.ObjectId     AS PersonalId
                                  , SUM (MovementItem.Amount) AS Amount
                             FROM Movement
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND MovementItem.isErased = FALSE
                                  INNER JOIN MovementItemLinkObject AS MLO_PersonalServiceList
                                                                    ON MLO_PersonalServiceList.MovementItemId = MovementItem.Id
                                                                   AND MLO_PersonalServiceList.DescId         = zc_MILinkObject_MoneyPlace()
                                                                   AND MLO_PersonalServiceList.ObjectId       = vbPersonalServiceListId
                                  INNER JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MLO_PersonalServiceList.ObjectId
                                                                                 AND Object_PersonalServiceList.ValueData ILIKE '%Аванс%'
                                  /*INNER JOIN MovementItemDate AS MIDate_ServiceDate
                                                              ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                                             AND MIDate_ServiceDate.DescId        = zc_MIDate_ServiceDate()
                                                             AND MIDate_ServiceDate.ValueData     = vbServiceDate*/

                             WHERE Movement.ParentId = inParentId
                               AND Movement.DescId   = zc_Movement_Cash()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                             GROUP BY MovementItem.ObjectId
                            )

       -- Результат
       SELECT tmpData.MovementItemId                  AS Id
            , Object_Personal.Id                      AS PersonalId
            , Object_Personal.ObjectCode              AS PersonalCode
            , Object_Personal.ValueData               AS PersonalName
            , ObjectString_Member_INN.ValueData       AS INN
            , COALESCE (ObjectBoolean_Personal_Main.ValueData, FALSE) :: Boolean   AS isMain
            , COALESCE (ObjectBoolean_Member_Official.ValueData, FALSE) :: Boolean AS isOfficial

            , Object_Unit.Id                          AS UnitId
            -- , (select sum(tmpMIContainer.Amount_avance)  from  tmpMIContainer) :: Integer
            , Object_Unit.ObjectCode                  AS UnitCode
            , Object_Unit.ValueData                   AS UnitName
            , Object_Position.Id                      AS PositionId
            , Object_Position.ValueData               AS PositionName
            , Object_PositionLevel.Id                 AS PositionLevelId
            , Object_PositionLevel.ValueData          AS PositionLevelName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
            , View_InfoMoney.InfoMoneyName_all
            
            , Object_MoneyPlace.Id                      AS MoneyPlaceId
            , Object_MoneyPlace.ValueData               AS MoneyPlaceName
            , tmpData.ServiceDate_mp                    AS ServiceDate_mp
            

            , tmpData.Amount           :: TFloat AS Amount
            , tmpData.SummService      :: TFloat AS SummService
              -- К выплате (из кассы) минус Карта БН (округление) - 2ф
            , (COALESCE (tmpData.SummToPay_cash, 0)  - COALESCE (tmpData.AmountService_diff, 0)) :: TFloat AS SummToPay_cash
              -- К выплате (итог)
            , (COALESCE (tmpData.SummToPay, 0)       - COALESCE (tmpData.AmountService_diff, 0)) :: TFloat AS SummToPay
              --
            , tmpData.SummCard         :: TFloat AS SummCard
            , tmpData.SummCardSecond   :: TFloat AS SummCardSecond
            , tmpData.SummAvCardSecond :: TFloat AS SummAvCardSecond
              -- Карта БН (касса)- 2ф.
            , tmpData.SummCardSecondCash  :: TFloat AS SummCardSecondCash

            , (FLOOR (100 * CAST (tmpData.SummCardSecondCash * vbKoeffSummCardSecond
                                 AS NUMERIC (16, 0))
                     ) / 100) :: TFloat AS SummCardSecond_all_00807
            , (FLOOR (100 * CAST (tmpData.SummCardSecondCash * vbKoeffSummCardSecond
                                 AS NUMERIC (16, 0))
                     ) / 100 - tmpData.SummCardSecondCash) :: TFloat AS SummCardSecond_diff_00807

            , CAST (CASE WHEN tmpMI_card_b2.Summ_calc < 4000
                               THEN 0
                          WHEN tmpMI_card_b2.Summ_calc <= 29999
                          THEN tmpMI_card_b2.Summ_calc
                          ELSE tmpMI_card_b2.Summ_calc + (tmpMI_card_b2.Summ_calc - 29999) * 0.005
                    END AS NUMERIC (16, 0)) :: TFloat AS SummCardSecond_all_005

            , (CAST (CASE WHEN tmpMI_card_b2.Summ_calc < 4000
                               THEN 0
                          WHEN tmpMI_card_b2.Summ_calc <= 29999
                          THEN tmpMI_card_b2.Summ_calc
                          ELSE tmpMI_card_b2.Summ_calc + (tmpMI_card_b2.Summ_calc - 29999) * 0.005
                    END AS NUMERIC (16, 0))
                  - CASE WHEN tmpMI_card_b2.Summ_calc < 4000
                               THEN 0
                          WHEN tmpMI_card_b2.Summ_calc <= 29999
                          THEN tmpMI_card_b2.Summ_calc
                          ELSE tmpMI_card_b2.Summ_calc
                    END) :: TFloat AS SummCardSecond_diff_005

              --
            , tmpData.SummNalog        :: TFloat AS SummNalog
            , tmpData.SummMinus        :: TFloat AS SummMinus
            , tmpData.SummFine         :: TFloat AS SummFine
            , (tmpData.SummAdd + tmpData.SummAddOth) :: TFloat AS SummAdd
            , tmpData.SummHoliday      :: TFloat AS SummHoliday
            , tmpData.SummHosp         :: TFloat AS SummHosp
            , tmpData.SummSocialIn     :: TFloat AS SummSocialIn
            , tmpData.SummSocialAdd    :: TFloat AS SummSocialAdd
            , tmpData.SummChild        :: TFloat AS SummChild
            , tmpData.SummMinusExt     :: TFloat AS SummMinusExt
            , tmpData.SummTransport        :: TFloat AS SummTransport
            , tmpData.SummTransportAdd     :: TFloat AS SummTransportAdd
            , tmpData.SummTransportAddLong :: TFloat AS SummTransportAddLong
            , tmpData.SummTransportTaxi    :: TFloat AS SummTransportTaxi
            , tmpData.SummPhone            :: TFloat AS SummPhone
            , tmpData.SummCompensation     :: TFloat AS SummCompensation
            , tmpData.SummAvance           :: TFloat AS SummAvance

              -- Карта БН (округление) - 2ф
            , tmpData.AmountService_diff   :: TFloat AS AmountService_diff

            , tmpData.Amount_current     :: TFloat AS Amount_current
 
              -- Аванс (выплачено)
            , (CASE WHEN tmpData.SummAvanceRecalc > 0 THEN 0 ELSE COALESCE (tmpData.Amount_avance, 0) END
             + COALESCE (tmpAvance_find.Amount, 0)
              ) :: TFloat AS Amount_avance

              -- Аванс (возврат)
            , tmpData.Amount_avance_ret  :: TFloat AS Amount_avance_ret

              -- Другие (выплачено)
            , (COALESCE (tmpData.Amount_service, 0) + COALESCE (tmpAvance_Only.Amount, 0)) :: TFloat AS Amount_service

              -- Ост. к выпл. из кассы
            , (COALESCE (tmpData.SummToPay_cash, 0)
               - CASE WHEN MIBoolean_Calculated.ValueData = TRUE THEN 0 ELSE COALESCE (tmpData.Amount, 0) END
               - COALESCE (tmpData.Amount_avance_ret, 0)
               - CASE WHEN tmpData.SummAvanceRecalc > 0 THEN 0 ELSE COALESCE (tmpData.Amount_avance, 0) END
               - COALESCE (tmpData.Amount_service, 0)
               -- !!!схема премии!!!
               - COALESCE (tmpAvance_Only.Amount, 0)
                 -- Карта БН (округление) - 2ф
               - COALESCE (tmpData.AmountService_diff, 0)
              ) :: TFloat AS SummRemains

              -- Ост. к выпл. Карта БН 2ф. 
            , (CASE WHEN tmpData.SummAvanceRecalc > 0 THEN 0
                    ELSE COALESCE (tmpData.SummCardSecond, 0)
                       + COALESCE (tmpData.SummAvCardSecond, 0)
                       + COALESCE (tmpData.SummCardSecondCash, 0)
                       - CASE WHEN MIBoolean_Calculated.ValueData = TRUE THEN COALESCE (tmpData.Amount, 0) ELSE 0 END
                         --
                       - CASE WHEN tmpData.SummCardSecondCash > 0 THEN 0 ELSE COALESCE (tmpData.AmountCardSecond_avance, 0) END

               END) :: TFloat AS SummCardSecondRemains

              -- Карта БН - 2ф.  (выплачено)
            , CASE WHEN tmpData.SummCardSecondCash > 0 THEN 0 ELSE COALESCE (tmpData.AmountCardSecond_avance, 0) END :: TFloat AS AmountCardSecond_avance

            , COALESCE (MIBoolean_Calculated.ValueData, FALSE) AS isCalculated
            , MIString_Comment.ValueData       AS Comment

            , tmpData.PersonalServiceListId      :: Integer AS PersonalServiceListId
          --, tmpData.PersonalServiceListId_calc :: Integer AS PersonalServiceListId_calc
            , tmpData.MovementId_find  :: Integer AS MovementId_find
            , tmpData.ContainerId_find :: Integer AS ContainerId_find
            , tmpData.isErased

       FROM tmpData
            LEFT JOIN tmpMI_card_b2 ON tmpMI_card_b2.MemberId_Personal = tmpData.MemberId_Personal
                                   AND tmpData.Ord_2                   = 1

            LEFT JOIN tmpAvance_Only ON tmpAvance_Only.PersonalId = tmpData.PersonalId
                                    AND tmpData.Ord               = 1

            -- !!!аванс - факт (другой алгоритм)!!!
            LEFT JOIN tmpAvance_find ON tmpAvance_find.PersonalId = tmpData.PersonalId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpData.MovementItemId
                                        AND MIString_Comment.DescId         = zc_MIString_Comment()
            LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                          ON MIBoolean_Calculated.MovementItemId = tmpData.MovementItemId
                                         AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()

            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpData.PersonalId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpData.PositionId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpData.InfoMoneyId
            
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = tmpData.MoneyPlaceId
            

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                    ON ObjectBoolean_Personal_Main.ObjectId = tmpData.PersonalId
                                   AND ObjectBoolean_Personal_Main.DescId = zc_ObjectBoolean_Personal_Main()
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = tmpData.PersonalId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
            LEFT JOIN ObjectString AS ObjectString_Member_INN
                                   ON ObjectString_Member_INN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                  AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Member_Official
                                    ON ObjectBoolean_Member_Official.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                   AND ObjectBoolean_Member_Official.DescId = zc_ObjectBoolean_Member_Official()
            LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                 ON ObjectLink_Personal_PositionLevel.ObjectId = tmpData.PersonalId
                                AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = ObjectLink_Personal_PositionLevel.ChildObjectId

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.02.21         * SummCompensation
 20.06.17         * add SummCardSecondCash
 04.04.15                                        * all
 16.09.14         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Cash_Personal (inMovementId:= 25173, inParentId:=0, inMovementItemId:= 0, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
