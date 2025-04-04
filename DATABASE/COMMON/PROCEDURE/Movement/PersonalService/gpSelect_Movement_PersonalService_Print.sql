-- Function: gpSelect_Movement_PersonalService_Print()

--DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_Print (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_Print (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService_Print(
    IN inMovementId    Integer  , -- ключ Документа
    IN inIsShowAll     Boolean  ,
    IN inIsList        Boolean  , --для печати - данных из грида
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbServiceDateId         Integer;
    DECLARE vbPersonalServiceListId Integer;
    DECLARE vbServiceDate           TDateTime;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Проверка прав роль - Ограничение просмотра данных ЗП!!!
     PERFORM lpCheck_UserRole_8813637 (vbUserId);


     -- Блокируем ему просмотр
     IF 1=0 AND vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


     IF zc_Enum_Status_Erased() = (SELECT StatusId FROM Movement WHERE Id = inMovementId)
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = (SELECT DescId FROM Movement WHERE Id = inMovementId)), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
     END IF;
     IF zc_Enum_Status_UnComplete() = (SELECT StatusId FROM Movement WHERE Id = inMovementId)
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = (SELECT DescId FROM Movement WHERE Id = inMovementId)), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
     END IF;


     vbServiceDate:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MIDate_ServiceDate());
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= vbServiceDate);
     vbPersonalServiceListId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList());

     -- !!!Проверка прав роль - Ограничение - нет доступа к просмотру ведомость Админ ЗП!!!
     PERFORM lpCheck_UserRole_11026035 (vbPersonalServiceListId, vbUserId);


     --
     OPEN Cursor1 FOR
       SELECT
             Movement.Id                                     AS Id
           , Movement.InvNumber                              AS InvNumber
           , Movement.OperDate                               AS OperDate

           , MovementDate_ServiceDate.ValueData              AS ServiceDate

           , MovementString_Comment.ValueData                AS Comment
           , Object_PersonalServiceList.Id                   AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData            AS PersonalServiceListName

           , CASE WHEN COALESCE (Object_MemberHeadManager.ValueData, '') <> '' THEN zfConvert_FIO (Object_MemberHeadManager.ValueData, 2, FALSE) ELSE '' /*'Махота Д.П.'*/    END  AS MemberHeadManagerName
           , CASE WHEN COALESCE (Object_MemberManager.ValueData, '') <> ''     THEN zfConvert_FIO (Object_MemberManager.ValueData, 2, FALSE)     ELSE '' /*'Крыхта В.Н.'*/    END  AS MemberManagerName
           , CASE WHEN COALESCE (Object_MemberBookkeeper.ValueData, '') <> ''  THEN zfConvert_FIO (Object_MemberBookkeeper.ValueData, 2, FALSE)  ELSE '' /*'Нагорнова Т.С.'*/ END  AS MemberBookkeeperName

           , Object_Juridical.Id                             AS JuridicalId
           , Object_Juridical.ValueData                      AS JuridicalName

           , (COALESCE (MovementFloat_TotalSummService.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummAdd.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummAddOth.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummAuditAdd.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummHoliday.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummHosp.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummHospOth.ValueData, 0)
            + CAST (COALESCE (MovementFloat_TotalSummCompensation.ValueData, 0) AS NUMERIC (16, 2))
            -- + COALESCE (MovementFloat_TotalSummSocialAdd.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummHouseAdd.ValueData, 0)
              -- плюс за санобработка
            + COALESCE (MovementFloat_TotalSummMedicdayAdd.ValueData, 0)
              -- минус за прогул
            - COALESCE (MovementFloat_TotalSummSkip.ValueData, 0)
             ) :: TFloat AS TotalSummService
              -- !!!временно!!!
           , (COALESCE (MovementFloat_TotalSummMinus.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummFine.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummFineOth.ValueData, 0)
             ) ::TFloat AS TotalSummMinus

           , (COALESCE (MovementFloat_TotalSummFine.ValueData, 0) + COALESCE (MovementFloat_TotalSummFineOth.ValueData, 0)) :: TFloat AS TotalSummFine
           , MovementFloat_TotalSummCard.ValueData           AS TotalSummCard

           , (COALESCE (MovementFloat_TotalSummCardSecond.ValueData, 0) + COALESCE (MovementFloat_TotalSummCardSecondRecalc.ValueData, 0)
             ) :: TFloat AS TotalSummCardSecond

           , MovementFloat_TotalSummCardSecondCash.ValueData AS TotalSummCardSecondCash
           , MovementFloat_TotalSummNalog.ValueData          AS TotalSummNalog
           , MovementFloat_TotalSummNalogRet.ValueData       AS TotalSummNalogRet
           , MovementFloat_TotalSummChild.ValueData          AS TotalSummChild
           , MovementFloat_TotalSummMinusExt.ValueData       AS TotalSummMinusExt
           , (COALESCE (MovementFloat_TotalSummToPay.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCard.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCardSecond.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummAvCardSecond.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCardSecondCash.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummMinusExt.ValueData, 0)
             ) :: TFloat AS TotalSummCash

           , MovementFloat_TotalSummTransport.ValueData        AS TotalSummTransport
           , MovementFloat_TotalSummTransportAdd.ValueData     AS TotalSummTransportAdd
           , MovementFloat_TotalSummTransportAddLong.ValueData AS TotalSummTransportAddLong
           , MovementFloat_TotalSummTransportTaxi.ValueData    AS TotalSummTransportTaxi
           , MovementFloat_TotalSummPhone.ValueData            AS TotalSummPhone

           , CASE WHEN Object_PersonalServiceList.Id  IN (293428, 301885) THEN 'Допл. за ревизию' ELSE 'Возмещ. налоги грн' END :: TVarChar AS AuditColumnName --293428;"Ведомость СБ  + 301885;"Ведомость охрана - заменить название колонки на "допл. за ревизию"
       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

             LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_MemberHeadManager
                                 ON ObjectLink_PersonalServiceList_MemberHeadManager.ObjectId = Object_PersonalServiceList.Id
                                AND ObjectLink_PersonalServiceList_MemberHeadManager.DescId = zc_ObjectLink_PersonalServiceList_MemberHeadManager()
            LEFT JOIN Object AS Object_MemberHeadManager ON Object_MemberHeadManager.Id = ObjectLink_PersonalServiceList_MemberHeadManager.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_MemberManager
                                 ON ObjectLink_PersonalServiceList_MemberManager.ObjectId = Object_PersonalServiceList.Id
                                AND ObjectLink_PersonalServiceList_MemberManager.DescId = zc_ObjectLink_PersonalServiceList_MemberManager()
            LEFT JOIN Object AS Object_MemberManager ON Object_MemberManager.Id = ObjectLink_PersonalServiceList_MemberManager.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_MemberBookkeeper
                                 ON ObjectLink_PersonalServiceList_MemberBookkeeper.ObjectId = Object_PersonalServiceList.Id
                                AND ObjectLink_PersonalServiceList_MemberBookkeeper.DescId = zc_ObjectLink_PersonalServiceList_MemberBookkeeper()
            LEFT JOIN Object AS Object_MemberBookkeeper ON Object_MemberBookkeeper.Id = ObjectLink_PersonalServiceList_MemberBookkeeper.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummToPay
                                    ON MovementFloat_TotalSummToPay.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummToPay.DescId = zc_MovementFloat_TotalSummToPay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummService
                                    ON MovementFloat_TotalSummService.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummService.DescId = zc_MovementFloat_TotalSummService()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                    ON MovementFloat_TotalSummCard.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecond
                                    ON MovementFloat_TotalSummCardSecond.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCardSecond.DescId = zc_MovementFloat_TotalSummCardSecond()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecondRecalc
                                    ON MovementFloat_TotalSummCardSecondRecalc.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummCardSecondRecalc.DescId = zc_MovementFloat_TotalSummCardSecondRecalc()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAvCardSecond
                                    ON MovementFloat_TotalSummAvCardSecond.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAvCardSecond.DescId = zc_MovementFloat_TotalSummAvCardSecond()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAvCardSecondRecalc
                                    ON MovementFloat_TotalSummAvCardSecondRecalc.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummAvCardSecondRecalc.DescId = zc_MovementFloat_TotalSummAvCardSecondRecalc()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecondCash
                                    ON MovementFloat_TotalSummCardSecondCash.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCardSecondCash.DescId = zc_MovementFloat_TotalSummCardSecondCash()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummNalog
                                    ON MovementFloat_TotalSummNalog.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummNalog.DescId = zc_MovementFloat_TotalSummNalog()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummNalogRet
                                    ON MovementFloat_TotalSummNalogRet.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummNalogRet.DescId = zc_MovementFloat_TotalSummNalogRet()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMinus
                                    ON MovementFloat_TotalSummMinus.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummMinus.DescId = zc_MovementFloat_TotalSummMinus()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummFine
                                    ON MovementFloat_TotalSummFine.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummFine.DescId     = zc_MovementFloat_TotalSummFine()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummFineOth
                                    ON MovementFloat_TotalSummFineOth.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummFineOth.DescId     = zc_MovementFloat_TotalSummFineOth()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAdd
                                    ON MovementFloat_TotalSummAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAdd.DescId = zc_MovementFloat_TotalSummAdd()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAddOth
                                    ON MovementFloat_TotalSummAddOth.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAddOth.DescId = zc_MovementFloat_TotalSummAddOth()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHoliday
                                    ON MovementFloat_TotalSummHoliday.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHoliday.DescId = zc_MovementFloat_TotalSummHoliday()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAuditAdd
                                    ON MovementFloat_TotalSummAuditAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAuditAdd.DescId = zc_MovementFloat_TotalSummAuditAdd()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHouseAdd
                                    ON MovementFloat_TotalSummHouseAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHouseAdd.DescId = zc_MovementFloat_TotalSummHouseAdd()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMedicdayAdd
                                    ON MovementFloat_TotalSummMedicdayAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummMedicdayAdd.DescId = zc_MovementFloat_TotalSummMedicdayAdd()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummSkip
                                    ON MovementFloat_TotalSummSkip.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummSkip.DescId = zc_MovementFloat_TotalSummSkip()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHosp
                                    ON MovementFloat_TotalSummHosp.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHosp.DescId     = zc_MovementFloat_TotalSummHosp()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHospOth
                                    ON MovementFloat_TotalSummHospOth.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHospOth.DescId     = zc_MovementFloat_TotalSummHospOth()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCompensation
                                    ON MovementFloat_TotalSummCompensation.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCompensation.DescId     = zc_MovementFloat_TotalSummCompensation()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChild
                                    ON MovementFloat_TotalSummChild.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummChild.DescId = zc_MovementFloat_TotalSummChild()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMinusExt
                                    ON MovementFloat_TotalSummMinusExt.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummMinusExt.DescId = zc_MovementFloat_TotalSummMinusExt()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTransport
                                    ON MovementFloat_TotalSummTransport.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummTransport.DescId = zc_MovementFloat_TotalSummTransport()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTransportAdd
                                    ON MovementFloat_TotalSummTransportAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummTransportAdd.DescId = zc_MovementFloat_TotalSummTransportAdd()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTransportAddLong
                                    ON MovementFloat_TotalSummTransportAddLong.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummTransportAddLong.DescId = zc_MovementFloat_TotalSummTransportAddLong()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTransportTaxi
                                    ON MovementFloat_TotalSummTransportTaxi.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummTransportTaxi.DescId = zc_MovementFloat_TotalSummTransportTaxi()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPhone
                                    ON MovementFloat_TotalSummPhone.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPhone.DescId = zc_MovementFloat_TotalSummPhone()

       WHERE Movement.Id = inMovementId
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       WITH tmpMIContainer_all AS (SELECT MIContainer.MovementItemId
                                        , CLO_Unit.ObjectId                        AS UnitId
                                        , CLO_Position.ObjectId                    AS PositionId
                                        , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                        , (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_PersonalService_Nalog()    THEN  1 * MIContainer.Amount ELSE 0 END) AS SummNalog
                                        , (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_PersonalService_NalogRet() THEN -1 * MIContainer.Amount ELSE 0 END) AS SummNalogRet
                                        , MIContainer.AnalyzerId
                                   FROM MovementItemContainer AS MIContainer
                                        LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                      ON CLO_Unit.ContainerId = MIContainer.ContainerId
                                                                     AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                        LEFT JOIN ContainerLinkObject AS CLO_Position
                                                                      ON CLO_Position.ContainerId = MIContainer.ContainerId
                                                                     AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                                        LEFT JOIN ContainerLinkObject AS CLO_Personal
                                                                      ON CLO_Personal.ContainerId = MIContainer.ContainerId
                                                                     AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                        LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                             ON ObjectLink_Personal_Member.ObjectId = CLO_Personal.ObjectId
                                                            AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                   WHERE MIContainer.MovementId = inMovementId
                                     AND MIContainer.DescId     = zc_MIContainer_Summ()
                                     AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_PersonalService_Nalog(), zc_Enum_AnalyzerId_PersonalService_NalogRet())
	                          )
      -- <Карта БН (округление) - 2ф>
    , tmpMIContainer_find_diff AS (SELECT MIContainer.MovementItemId
                                        , MIContainer.ContainerId
                                        , ROW_NUMBER() OVER (PARTITION BY MIContainer.ContainerId ORDER BY ABS (MIContainer.Amount) DESC) AS Ord
                                   FROM MovementItemContainer AS MIContainer
                                        INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                       ON CLO_Unit.ContainerId = MIContainer.ContainerId
                                                                      AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                        INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                       ON CLO_Personal.ContainerId = MIContainer.ContainerId
                                                                      AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                   WHERE MIContainer.MovementId = inMovementId
                                     AND MIContainer.DescId     = zc_MIContainer_Summ()
                                     AND (MIContainer.Amount <> 0) --  OR vbUserId = 5
	                          )
      -- <Карта БН (округление) - 2ф>
    , tmpMIContainer_diff AS (SELECT -1 * SUM (CASE WHEN MIContainer.OperDate < vbServiceDate + INTERVAL '1 MONTH' THEN MIContainer.Amount ELSE 0 END) AS AmountService_diff_start
                                   , 1 * SUM (CASE WHEN MIContainer.OperDate >= vbServiceDate + INTERVAL '1 MONTH' THEN MIContainer.Amount ELSE 0 END) AS AmountService_diff_end
                                   , tmpMIContainer_find_diff.MovementItemId
                              FROM tmpMIContainer_find_diff
                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId    = tmpMIContainer_find_diff.ContainerId
                                                                   AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                                   AND MIContainer.MovementDescId = zc_Movement_PersonalService()
                                                                   -- <Карта БН (округление) - 2ф>
                                                                   AND MIContainer.AnalyzerId     = zc_Enum_AnalyzerId_PersonalService_SummDiff()
                                                                   --and 1=0
                              WHERE tmpMIContainer_find_diff.Ord = 1
                                -- AND vbUserId = 5
                              GROUP BY tmpMIContainer_find_diff.MovementItemId
                             )
        , tmpMIContainer_find AS (SELECT tmpMIContainer_all.*
                                        , ROW_NUMBER() OVER (PARTITION BY tmpMIContainer_all.MemberId ORDER BY ABS (tmpMIContainer_all.SummNalog) DESC) AS Ord
                                   FROM tmpMIContainer_all
                                   WHERE tmpMIContainer_all.AnalyzerId IN (zc_Enum_AnalyzerId_PersonalService_Nalog())
	                          )
          , tmpMIContainer AS (SELECT /*tmpMIContainer_all.UnitId
                                    , tmpMIContainer_all.PositionId
                                    ,*/ tmpMIContainer_all.MemberId
                                    , SUM (tmpMIContainer_all.SummNalog)    :: TFloat AS SummNalog
                                    , SUM (tmpMIContainer_all.SummNalogRet) :: TFloat AS SummNalogRet
                                    , CASE WHEN inIsShowAll = TRUE THEN tmpMIContainer_all.PositionId ELSE 0 END AS PositionId
                               FROM tmpMIContainer_all
                               GROUP BY /*tmpMIContainer_all.UnitId
                                      , tmpMIContainer_all.PositionId
                                      ,*/ tmpMIContainer_all.MemberId
                                      , CASE WHEN inIsShowAll = TRUE THEN tmpMIContainer_all.PositionId ELSE 0 END
                              )

      , tmpMI_all AS (SELECT MovementItem.Id                            AS MovementItemId
                           , MovementItem.Amount
                           , MovementItem.ObjectId                      AS PersonalId
                           , MILinkObject_Unit.ObjectId                 AS UnitId
                           , MILinkObject_Position.ObjectId             AS PositionId

                           -- , MILinkObject_Member.ObjectId               AS MemberId
                           , ObjectLink_Personal_Member.ChildObjectId   AS MemberId -- MemberId_Personal
                           , MILinkObject_PersonalServiceList.ObjectId  AS PersonalServiceListId

                           , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId ORDER BY CASE WHEN MIBoolean_Main.ValueData = TRUE THEN 1 ELSE 2 END, MovementItem.Amount DESC) AS Ord --  № п/п

                           , COALESCE (MIBoolean_Main.ValueData, FALSE) AS isMain

                           , COALESCE (tmpMIContainer_diff.AmountService_diff_start, 0) AS AmountService_diff_start
                           , COALESCE (tmpMIContainer_diff.AmountService_diff_end, 0)   AS AmountService_diff_end

                           , COALESCE (MIFloat_SummToPay.ValueData, 0)
                             -- <Карта БН (округление) - 2ф>
                           + COALESCE (tmpMIContainer_diff.AmountService_diff_start, 0)
                             AS SummToPay

                           , COALESCE (MIFloat_SummNalog.ValueData, 0)        AS SummNalog
                           , COALESCE (MIFloat_SummNalogRet.ValueData, 0)     AS SummNalogRet
                           , COALESCE (MIFloat_SummCard.ValueData, 0)         AS SummCard

                           , COALESCE (MIFloat_SummCardSecond.ValueData, 0) + COALESCE (MIFloat_SummCardSecondRecalc.ValueData, 0) AS SummCardSecond
                           , COALESCE (MIFloat_SummCardSecondCash.ValueData, 0) AS SummCardSecondCash

                           , COALESCE (MIFloat_SummService.ValueData, 0)
                             -- <Карта БН (округление) - 2ф>
                         --+ COALESCE (tmpMIContainer_diff.AmountService_diff, 0)
                             AS SummService

                           , COALESCE (MIFloat_SummAdd.ValueData, 0)          AS SummAdd
                           , COALESCE (MIFloat_SummAddOth.ValueData, 0)       AS SummAddOth
                             --
                           , COALESCE (MIFloat_SummAuditAdd.ValueData, 0)     AS SummAuditAdd
                             -- плюс за санобработка
                           , COALESCE (MIFloat_SummMedicdayAdd.ValueData, 0)  AS SummMedicdayAdd
                             -- минус за прогул
                           , COALESCE (MIFloat_SummSkip.ValueData, 0)         AS SummSkip
                             --
                           , COALESCE (MIFloat_SummHoliday.ValueData, 0)      AS SummHoliday
                           , COALESCE (MIFloat_SummHosp.ValueData, 0)         AS SummHosp
                           , COALESCE (MIFloat_SummHospOth.ValueData, 0)      AS SummHospOth
                           , CAST (COALESCE (MIFloat_SummCompensation.ValueData, 0) AS NUMERIC (16, 2)) AS SummCompensation

                           , COALESCE (MIFloat_SummMinus.ValueData, 0)        AS SummMinus
                           , COALESCE (MIFloat_SummFine.ValueData, 0)         AS SummFine
                           , COALESCE (MIFloat_SummFineOth.ValueData, 0)      AS SummFineOth
                           , COALESCE (MIFloat_SummChild.ValueData, 0)        AS SummChild
                           , COALESCE (MIFloat_SummMinusExt.ValueData, 0)     AS SummMinusExt

                           , COALESCE (MIFloat_SummTransportAdd.ValueData, 0) + COALESCE (MIFloat_SummTransportAddLong.ValueData, 0) AS SummTransportAdd
                           , COALESCE (MIFloat_SummTransport.ValueData, 0)     AS SummTransport
                           , COALESCE (MIFloat_SummTransportTaxi.ValueData, 0) AS SummTransportTaxi
                           , COALESCE (MIFloat_SummPhone.ValueData, 0)         AS SummPhone
                           , COALESCE (MIFloat_SummHouseAdd.ValueData, 0)      AS SummHouseAdd
                           , COALESCE (MIFloat_SummAvance.ValueData, 0) + COALESCE (MIFloat_SummAvanceRecalc.ValueData, 0)
                           + COALESCE (MIFloat_SummAvCardSecond.ValueData, 0) + COALESCE (MIFloat_SummAvCardSecondRecalc.ValueData, 0)
                             AS SummAvance

                           , MIString_Comment.ValueData         AS Comment

                      FROM MovementItem
                           -- <Карта БН (округление) - 2ф>
                           LEFT JOIN tmpMIContainer_diff ON tmpMIContainer_diff.MovementItemId = MovementItem.Id

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                            ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                           /*LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                                            ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Member.DescId = zc_MILinkObject_Member()*/
                           LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                            ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()

                           LEFT JOIN MovementItemString AS MIString_Comment
                                                        ON MIString_Comment.MovementItemId = MovementItem.Id
                                                       AND MIString_Comment.DescId = zc_MIString_Comment()

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
                           LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondRecalc
                                                       ON MIFloat_SummCardSecondRecalc.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummCardSecondRecalc.DescId = zc_MIFloat_SummCardSecondRecalc()

                           LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecond
                                                       ON MIFloat_SummAvCardSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummAvCardSecond.DescId = zc_MIFloat_SummAvCardSecond()
                                                    --AND 1=0
                           LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecondRecalc
                                                       ON MIFloat_SummAvCardSecondRecalc.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummAvCardSecondRecalc.DescId = zc_MIFloat_SummAvCardSecondRecalc()
                                                    --AND 1=0

                           LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondCash
                                                       ON MIFloat_SummCardSecondCash.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummNalog
                                                       ON MIFloat_SummNalog.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummNalog.DescId = zc_MIFloat_SummNalog()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRet
                                                       ON MIFloat_SummNalogRet.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummNalogRet.DescId = zc_MIFloat_SummNalogRet()

                           LEFT JOIN MovementItemFloat AS MIFloat_SummMinus
                                                       ON MIFloat_SummMinus.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummFine
                                                       ON MIFloat_SummFine.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummFine.DescId         = zc_MIFloat_SummFine()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummFineOth
                                                       ON MIFloat_SummFineOth.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummFineOth.DescId         = zc_MIFloat_SummFineOth()

                           LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                                       ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummAddOth
                                                       ON MIFloat_SummAddOth.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummAddOth.DescId = zc_MIFloat_SummAddOth()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummHoliday
                                                       ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()

                           LEFT JOIN MovementItemFloat AS MIFloat_SummAuditAdd
                                                       ON MIFloat_SummAuditAdd.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummAuditAdd.DescId = zc_MIFloat_SummAuditAdd()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummMedicdayAdd
                                                       ON MIFloat_SummMedicdayAdd.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummMedicdayAdd.DescId = zc_MIFloat_SummMedicdayAdd()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummSkip
                                                       ON MIFloat_SummSkip.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummSkip.DescId = zc_MIFloat_SummSkip()

                           LEFT JOIN MovementItemFloat AS MIFloat_SummHosp
                                                       ON MIFloat_SummHosp.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummHosp.DescId         = zc_MIFloat_SummHosp()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummHospOth
                                                       ON MIFloat_SummHospOth.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummHospOth.DescId         = zc_MIFloat_SummHospOth()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummCompensation
                                                       ON MIFloat_SummCompensation.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummCompensation.DescId         = zc_MIFloat_SummCompensation()

                           LEFT JOIN MovementItemFloat AS MIFloat_SummTransportAdd
                                                       ON MIFloat_SummTransportAdd.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummTransportAdd.DescId = zc_MIFloat_SummTransportAdd()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummTransportAddLong
                                                       ON MIFloat_SummTransportAddLong.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummTransportAddLong.DescId = zc_MIFloat_SummTransportAddLong()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummTransport
                                                       ON MIFloat_SummTransport.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummTransport.DescId = zc_MIFloat_SummTransport()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummTransportTaxi
                                                       ON MIFloat_SummTransportTaxi.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummTransportTaxi.DescId = zc_MIFloat_SummTransportTaxi()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummPhone
                                                       ON MIFloat_SummPhone.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummPhone.DescId = zc_MIFloat_SummPhone()

                         /*  LEFT JOIN MovementItemFloat AS MIFloat_SummSocialIn
                                                       ON MIFloat_SummSocialIn.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                                       ON MIFloat_SummSocialAdd.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()    */
                           LEFT JOIN MovementItemFloat AS MIFloat_SummChild
                                                       ON MIFloat_SummChild.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummMinusExt
                                                       ON MIFloat_SummMinusExt.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummMinusExt.DescId = zc_MIFloat_SummMinusExt()

                           LEFT JOIN MovementItemFloat AS MIFloat_SummHouseAdd
                                                       ON MIFloat_SummHouseAdd.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummHouseAdd.DescId = zc_MIFloat_SummHouseAdd()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummAvance
                                                       ON MIFloat_SummAvance.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummAvance.DescId = zc_MIFloat_SummAvance()
                                                      AND 1=0
                           LEFT JOIN MovementItemFloat AS MIFloat_SummAvanceRecalc
                                                       ON MIFloat_SummAvanceRecalc.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummAvanceRecalc.DescId         = zc_MIFloat_SummAvanceRecalc()
                                                      AND 1=0

                           LEFT JOIN MovementItemBoolean AS MIBoolean_Main
                                                         ON MIBoolean_Main.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_Main.DescId = zc_MIBoolean_Main()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId = zc_MI_Master()
                        AND MovementItem.isErased = FALSE
                     )

          , tmpMIChild AS (SELECT MovementItem.ParentId    AS ParentId
                                , SUM(MIFloat_WorkTimeHoursOne.ValueData) AS WorkTimeHoursOne
                           FROM MovementItem
                              LEFT JOIN MovementItemFloat AS MIFloat_WorkTimeHoursOne
                                                          ON MIFloat_WorkTimeHoursOne.MovementItemId = MovementItem.Id
                                                         AND MIFloat_WorkTimeHoursOne.DescId = zc_MIFloat_WorkTimeHoursOne()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId = zc_MI_Child()
                             AND MovementItem.isErased = FALSE
                           GROUP BY MovementItem.ParentId
                       )

       --- все строки документа или выбранные, если печать из грида
      , tmpMI_list AS (SELECT DISTINCT
                              tmpMI_all.PersonalId
                            , tmpMI_all.UnitId
                            , tmpMI_all.PositionId
                            , tmpMI_all.MemberId
                            , tmpMI_all.PersonalServiceListId
                       FROM tmpMI_all
                       WHERE inIsList = FALSE
                     UNION
                       SELECT DISTINCT
                              tmpMI_all.PersonalId
                            , tmpMI_all.UnitId
                            , tmpMI_all.PositionId
                            , tmpMI_all.MemberId
                            , tmpMI_all.PersonalServiceListId
                       FROM tmpMI_all
                            INNER JOIN (SELECT OP.ObjectId AS MovementItemId
                                        FROM Object_Print AS OP
                                        WHERE OP.UserId = vbUserId
                                          AND OP.ReportKindId = inMovementId) AS tmpOP ON tmpOP.MovementItemId = tmpMI_all.MovementItemId
                       WHERE inIsList = TRUE
                       )
          , tmpMI AS (SELECT tmpMI_all_find.PersonalId
                           , tmpMI_all_find.UnitId
                           , tmpMI_all_find.PositionId

                           , tmpMI_all_find.MemberId
                           , tmpMI_all_find.PersonalServiceListId
                           , tmpMI_all_find.isMain
                           , tmpMI_all_find.Comment

                           , SUM (tmpMI_all.Amount)           AS Amount

                           , SUM (tmpMI_all.AmountService_diff_start) AS AmountService_diff_start
                           , SUM (tmpMI_all.AmountService_diff_end)   AS AmountService_diff_end

                           , SUM (tmpMI_all.SummToPay)        AS SummToPay
                           , SUM (tmpMI_all.SummNalog)        AS SummNalog
                           , SUM (tmpMI_all.SummNalogRet)     AS SummNalogRet
                           , SUM (tmpMI_all.SummCard)         AS SummCard
                           , SUM (tmpMI_all.SummCardSecond)   AS SummCardSecond
                           , SUM (tmpMI_all.SummCardSecondCash) AS SummCardSecondCash
                           , SUM (tmpMI_all.SummService)      AS SummService
                           , SUM (tmpMI_all.SummAdd)          AS SummAdd
                           , SUM (tmpMI_all.SummAddOth)       AS SummAddOth
                           , SUM (tmpMI_all.SummHoliday)      AS SummHoliday
                           , SUM (tmpMI_all.SummHosp)         AS SummHosp
                           , SUM (tmpMI_all.SummHospOth)      AS SummHospOth
                           , SUM (tmpMI_all.SummCompensation) AS SummCompensation
                           , SUM (tmpMI_all.SummAuditAdd)     AS SummAuditAdd
                           , SUM (tmpMI_all.SummMedicdayAdd)  AS SummMedicdayAdd
                           , SUM (tmpMI_all.SummSkip)         AS SummSkip

                           , SUM (tmpMI_all.SummMinus)        AS SummMinus
                           , SUM (tmpMI_all.SummFine)         AS SummFine
                           , SUM (tmpMI_all.SummFineOth)      AS SummFineOth
                           , SUM (tmpMI_all.SummChild)        AS SummChild
                           , SUM (tmpMI_all.SummMinusExt)     AS SummMinusExt

                           , SUM (tmpMI_all.SummTransportAdd)  AS SummTransportAdd
                           , SUM (tmpMI_all.SummTransport)     AS SummTransport
                           , SUM (tmpMI_all.SummTransportTaxi) AS SummTransportTaxi
                           , SUM (tmpMI_all.SummPhone)         AS SummPhone
                           , SUM (tmpMI_all.SummHouseAdd)      AS SummHouseAdd
                           , SUM (tmpMI_all.SummAvance)        AS SummAvance
                           , SUM (COALESCE (tmpMIChild.WorkTimeHoursOne, 0)) ::TFloat AS WorkTimeHoursOne_child

                      FROM tmpMI_all As tmpMI_all_find
                           LEFT JOIN tmpMI_all ON tmpMI_all.MemberId = tmpMI_all_find.MemberId
                           LEFT JOIN tmpMIChild ON tmpMIChild.ParentId = tmpMI_all.MovementItemId
                      WHERE tmpMI_all_find.Ord = 1 AND inIsShowAll = FALSE
                      GROUP BY tmpMI_all_find.PersonalId
                             , tmpMI_all_find.UnitId
                             , tmpMI_all_find.PositionId
                             , tmpMI_all_find.MemberId
                             , tmpMI_all_find.PersonalServiceListId
                             , tmpMI_all_find.isMain
                             , tmpMI_all_find.Comment
                    UNION ALL
                      SELECT tmpMI_all.PersonalId
                           , tmpMI_all.UnitId
                           , tmpMI_all.PositionId

                           , tmpMI_all.MemberId
                           , tmpMI_all.PersonalServiceListId
                           , tmpMI_all.isMain
                           , tmpMI_all.Comment

                           , SUM (tmpMI_all.Amount)           AS Amount

                           , SUM (tmpMI_all.AmountService_diff_start) AS AmountService_diff_start
                           , SUM (tmpMI_all.AmountService_diff_end)   AS AmountService_diff_end

                           , SUM (tmpMI_all.SummToPay)        AS SummToPay
                           , SUM (tmpMI_all.SummNalog)        AS SummNalog
                           , SUM (tmpMI_all.SummNalogRet)     AS SummNalogRet
                           , SUM (tmpMI_all.SummCard)         AS SummCard
                           , SUM (tmpMI_all.SummCardSecond)   AS SummCardSecond
                           , SUM (tmpMI_all.SummCardSecondCash) AS SummCardSecondCash
                           , SUM (tmpMI_all.SummService)      AS SummService
                           , SUM (tmpMI_all.SummAdd)          AS SummAdd
                           , SUM (tmpMI_all.SummAddOth)       AS SummAddOth
                           , SUM (tmpMI_all.SummHoliday)      AS SummHoliday
                           , SUM (tmpMI_all.SummHosp)         AS SummHosp
                           , SUM (tmpMI_all.SummHospOth)      AS SummHospOth
                           , SUM (tmpMI_all.SummCompensation) AS SummCompensation
                           , SUM (tmpMI_all.SummAuditAdd)     AS SummAuditAdd
                           , SUM (tmpMI_all.SummMedicdayAdd)  AS SummMedicdayAdd
                           , SUM (tmpMI_all.SummSkip)         AS SummSkip

                           , SUM (tmpMI_all.SummMinus)        AS SummMinus
                           , SUM (tmpMI_all.SummFine)         AS SummFine
                           , SUM (tmpMI_all.SummFineOth)      AS SummFineOth
                           , SUM (tmpMI_all.SummChild)        AS SummChild
                           , SUM (tmpMI_all.SummMinusExt)     AS SummMinusExt

                           , SUM (tmpMI_all.SummTransportAdd)  AS SummTransportAdd
                           , SUM (tmpMI_all.SummTransport)     AS SummTransport
                           , SUM (tmpMI_all.SummTransportTaxi) AS SummTransportTaxi
                           , SUM (tmpMI_all.SummPhone)         AS SummPhone
                           , SUM (tmpMI_all.SummHouseAdd)      AS SummHouseAdd
                           , SUM (tmpMI_all.SummAvance)        AS SummAvance

                           , SUM (COALESCE (tmpMIChild.WorkTimeHoursOne, 0)) ::TFloat AS WorkTimeHoursOne_child

                      FROM tmpMI_all
                           LEFT JOIN tmpMIChild ON tmpMIChild.ParentId = tmpMI_all.MovementItemId
                      WHERE inIsShowAll = TRUE
                      GROUP BY tmpMI_all.PersonalId
                             , tmpMI_all.UnitId
                             , tmpMI_all.PositionId
                             , tmpMI_all.MemberId
                             , tmpMI_all.PersonalServiceListId
                             , tmpMI_all.isMain
                             , tmpMI_all.Comment
                     )
          , tmpUserAll AS (SELECT DISTINCT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId) -- Документы-меню (управленцы) AND <> Рудик Н.В.
          , tmpPersonal AS (SELECT View_Personal.isMain
                                 , View_Personal.PersonalId
                                 , View_Personal.UnitId
                                 , View_Personal.PositionId
                                 , View_Personal.MemberId -- AS MemberId_Personal
                                 , ObjectLink_Personal_PersonalServiceList.ChildObjectId AS PersonalServiceListId -- !!!берем это поле т.к. есть ограничение по БН!!!
                                 , ROW_NUMBER() OVER (PARTITION BY View_Personal.MemberId ORDER BY CASE WHEN View_Personal.isMain = TRUE THEN 1 ELSE 2 END) AS Ord --  № п/п
                            FROM (SELECT UnitId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE UnitId_PersonalService <> 0 AND UserId = vbUserId
                                 UNION
                                  -- Админ видит ВСЕХ
                                  SELECT Object.Id AS UnitId_PersonalService FROM tmpUserAll INNER JOIN Object ON Object.DescId = zc_Object_Unit()
                                 ) AS View_RoleAccessKeyGuide
                                 INNER JOIN Object_Personal_View AS View_Personal ON View_Personal.UnitId = View_RoleAccessKeyGuide.UnitId_PersonalService

                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                      ON ObjectLink_Personal_PersonalServiceList.ObjectId = View_Personal.PersonalId
                                                     AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                                     --AND vbIsSummCardRecalc = TRUE -- !!!т.е. если это БН!!!

                                 JOIN tmpMI ON tmpMI.MemberId = View_Personal.MemberId
                                           -- AND tmpMI.UnitId     = View_Personal.UnitId
                                           -- AND tmpMI.PositionId = View_Personal.PositionId

                            WHERE tmpMI.PersonalId IS NULL
                           )
       , tmpContainer_pay AS (SELECT DISTINCT
                                     CLO_ServiceDate.ContainerId
                                   , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                   , CLO_Position.ObjectId                    AS PositionId
                                   , CLO_Unit.ObjectId                        AS UnitId
                              FROM ContainerLinkObject AS CLO_PersonalServiceList
                                   INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                                  ON CLO_ServiceDate.ObjectId    = vbServiceDateId
                                                                 AND CLO_ServiceDate.DescId      = zc_ContainerLinkObject_ServiceDate()
                                                                 AND CLO_ServiceDate.ContainerId = CLO_PersonalServiceList.ContainerId

                                   INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                  ON CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                                                 AND CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                         ON ObjectLink_Personal_Member.ObjectId = CLO_Personal.ObjectId
                                                        AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                   LEFT JOIN ContainerLinkObject AS CLO_Position
                                                                 ON CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                                                AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                                   LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                 ON CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                                                AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                              WHERE CLO_PersonalServiceList.ObjectId = vbPersonalServiceListId
                                AND CLO_PersonalServiceList.DescId   = zc_ContainerLinkObject_PersonalServiceList()
                             )
/*     , tmpMIContainer_pay_all AS (SELECT tmpContainer_pay.MemberId
                                       , tmpContainer_pay.PositionId
                                       , tmpContainer_pay.UnitId
                                       , MIContainer.*

                                  FROM tmpContainer_pay
                                       INNER JOIN MovementItemContainer AS MIContainer
                                                                        ON MIContainer.ContainerId    = tmpContainer_pay.ContainerId
                                                                       AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                                       AND MIContainer.MovementDescId = zc_Movement_Cash()
                                 )
     , tmpAvance_ps AS (SELECT MovementItem.MovementId                               AS MovementId
                             , Object.ValueData                                      AS PersonalServiceListName
                             , ObjectLink_PersonalServiceList_PaidKind.ChildObjectId AS PaidKindId
                        FROM MovementItem
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                              ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                             LEFT JOIN Object ON Object.Id = MILinkObject_MoneyPlace.ObjectId
                             LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                  ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                 AND ObjectLink_PersonalServiceList_PaidKind.DescId   = zc_ObjectLink_PersonalServiceList_PaidKind()
                        WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMIContainer_pay_all.MovementId FROM tmpMIContainer_pay_all)
                          AND MovementItem.DescId     = zc_MI_Master()
                          AND MovementItem.isErased   = FALSE
                        --AND vbUserId = 5
                       )*/

     , tmpMIContainer_pay AS (SELECT -- Amount_avance
                                     -- SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalAvance()) THEN MIContainer.Amount ELSE 0 END) AS Amount_avance
                                     SUM (CASE WHEN (/*MIContainer.Amount = 2000 OR*/ MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalAvance()/*, zc_Enum_AnalyzerId_Cash_PersonalCardSecond()*/)) AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END
                                          -- аванс по ведомости
                                          /*+ CASE WHEN ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()
                                                 AND MIContainer.MovementDescId = zc_Movement_Cash()
                                                 AND Object.ValueData ILIKE '%АВАНС%'
                                                 AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_Cash_PersonalAvance()
                                               --AND vbUserId = 5

                                                     THEN MIContainer.Amount
                                                ELSE 0
                                           END*/
                                         ) AS Amount_avance

                                     -- Amount_avance_ret
                                   , SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalAvance()/*, zc_Enum_AnalyzerId_Cash_PersonalCardSecond()*/) AND MIContainer.Amount < 0 THEN MIContainer.Amount ELSE 0 END
                                         ) AS Amount_avance_ret

                                     -- Amount_service
                                   , SUM (CASE WHEN /*MIContainer.Amount <> 2000 AND*/ MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalService()) THEN MIContainer.Amount ELSE 0 END
                                          -- аванс по ведомости
                                          /*- CASE WHEN ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()
                                                 AND MIContainer.MovementDescId = zc_Movement_Cash()
                                                 AND Object.ValueData ILIKE '%АВАНС%'
                                                 AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_Cash_PersonalAvance()
                                               --AND vbUserId = 5

                                                     THEN MIContainer.Amount
                                                ELSE 0
                                           END*/
                                         ) AS Amount_service

                                   , tmpContainer_pay.MemberId
                                   , CASE WHEN inIsShowAll = TRUE THEN tmpContainer_pay.PositionId ELSE 0 END AS PositionId
                                   , CASE WHEN inIsShowAll = TRUE THEN tmpContainer_pay.UnitId     ELSE 0 END AS UnitId
                              FROM tmpContainer_pay
                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId    = tmpContainer_pay.ContainerId
                                                                   AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                                   AND MIContainer.MovementDescId = zc_Movement_Cash()
                                   /*LEFT JOIN MovementItem ON MovementItem.MovementId = MIContainer.MovementId
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = FALSE
                                                       --AND vbUserId = 5

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                   LEFT JOIN Object ON Object.Id = MILinkObject_MoneyPlace.ObjectId
                                   LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                        ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                       AND ObjectLink_PersonalServiceList_PaidKind.DescId   = zc_ObjectLink_PersonalServiceList_PaidKind()*/

                              GROUP BY tmpContainer_pay.MemberId
                                     , CASE WHEN inIsShowAll = TRUE THEN tmpContainer_pay.PositionId ELSE 0 END
                                     , CASE WHEN inIsShowAll = TRUE THEN tmpContainer_pay.UnitId     ELSE 0 END
                             )
     , tmpMember_findPersonal AS (SELECT * FROM  lfSelect_Object_Member_findPersonal (inSession))
          , tmpAll AS (SELECT tmpMI.Amount, tmpMI.PersonalId, tmpMI.UnitId, tmpMI.PositionId, tmpMI.MemberId , tmpMI.PersonalServiceListId
                            , tmpMI.isMain
                            , tmpMI.Comment
                            , tmpMI.Amount

                            , tmpMI.AmountService_diff_start
                            , tmpMI.AmountService_diff_end
                            , tmpMI.SummToPay
                            , tmpMI.SummNalog
                            , tmpMI.SummNalogRet
                            , tmpMI.SummCard
                            , tmpMI.SummCardSecond
                            , tmpMI.SummCardSecondCash
                            , tmpMI.SummService
                            , tmpMI.SummAdd
                            , tmpMI.SummAddOth
                            , tmpMI.SummHoliday
                            , tmpMI.SummHosp
                            , tmpMI.SummHospOth
                            , tmpMI.SummCompensation
                            , tmpMI.SummAuditAdd
                            , tmpMI.SummMedicdayAdd
                            , tmpMI.SummSkip

                            , tmpMI.SummMinus
                            , tmpMI.SummFine
                            , tmpMI.SummFineOth
                            , tmpMI.SummChild
                            , tmpMI.SummMinusExt

                            , tmpMI.SummTransportAdd
                            , tmpMI.SummTransport
                            , tmpMI.SummTransportTaxi
                            , tmpMI.SummPhone
                            , tmpMI.SummHouseAdd
                            , tmpMI.SummAvance
                            , tmpMI.WorkTimeHoursOne_child

                            , ROW_NUMBER() OVER (PARTITION BY tmpMI.MemberId ORDER BY tmpMI.SummToPay DESC) AS Ord

                       FROM tmpMI
                      UNION ALL
                       SELECT 0 AS Amount, tmpPersonal.PersonalId, tmpPersonal.UnitId, tmpPersonal.PositionId, tmpPersonal.MemberId, tmpPersonal.PersonalServiceListId
                            , tmpPersonal.isMain
                            , '' AS Comment
                            , 0 AS Amount

                            , 0 AS AmountService_diff_start
                            , 0 AS AmountService_diff_end
                            , 0 AS SummToPay
                            , 0 AS SummNalog
                            , 0 AS SummNalogRet
                            , 0 AS SummCard
                            , 0 AS SummCardSecond
                            , 0 AS SummCardSecondCash
                            , 0 AS SummService
                            , 0 AS SummAdd
                            , 0 AS SummAddOth
                            , 0 AS SummHoliday
                            , 0 AS SummHosp
                            , 0 AS SummHospOth
                            , 0 AS SummCompensation
                            , 0 AS SummAuditAdd
                            , 0 AS SummMedicdayAdd
                            , 0 AS SummSkip

                            , 0 AS SummMinus
                            , 0 AS SummFine
                            , 0 AS SummFineOth
                            , 0 AS SummChild
                            , 0 AS SummMinusExt

                            , 0 AS SummTransportAdd
                            , 0 AS SummTransport
                            , 0 AS SummTransportTaxi
                            , 0 AS SummPhone
                            , 0 AS SummHouseAdd
                            , 0 AS SummAvance
                            , 0 AS WorkTimeHoursOne_child

                            , 1 AS Ord

                        FROM tmpPersonal
                        WHERE tmpPersonal.Ord = 1
                      UNION ALL
                       SELECT DISTINCT
                              0 AS Amount, tmpMember_findPersonal.PersonalId, tmpMember_findPersonal.UnitId, tmpMIContainer_pay.PositionId, tmpMIContainer_pay.MemberId
                            , tmpMember_findPersonal.PersonalServiceListId
                            , tmpMember_findPersonal.isMain
                            , '' AS Comment
                            , 0 AS Amount

                            , 0 AS AmountService_diff_start
                            , 0 AS AmountService_diff_end
                            , 0 AS SummToPay
                            , 0 AS SummNalog
                            , 0 AS SummNalogRet
                            , 0 AS SummCard
                            , 0 AS SummCardSecond
                            , 0 AS SummCardSecondCash
                            , 0 AS SummService
                            , 0 AS SummAdd
                            , 0 AS SummAddOth
                            , 0 AS SummHoliday
                            , 0 AS SummHosp
                            , 0 AS SummHospOth
                            , 0 AS SummCompensation
                            , 0 AS SummAuditAdd
                            , 0 AS SummMedicdayAdd
                            , 0 AS SummSkip

                            , 0 AS SummMinus
                            , 0 AS SummFine
                            , 0 AS SummFineOth
                            , 0 AS SummChild
                            , 0 AS SummMinusExt

                            , 0 AS SummTransportAdd
                            , 0 AS SummTransport
                            , 0 AS SummTransportTaxi
                            , 0 AS SummPhone
                            , 0 AS SummHouseAdd
                            , 0 AS SummAvance
                            , 0 AS WorkTimeHoursOne_child

                            , 1 AS Ord

                        FROM tmpMIContainer_pay
                             LEFT JOIN tmpMember_findPersonal ON tmpMember_findPersonal.MemberId = tmpMIContainer_pay.MemberId
                             LEFT JOIN tmpMI ON tmpMI.MemberId = tmpMIContainer_pay.MemberId
                             LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmpMIContainer_pay.MemberId
                                                  AND tmpPersonal.Ord = 1
                        WHERE tmpMI.MemberId IS NULL AND tmpPersonal.MemberId IS NULL
                      )
       /*, tmpContainer_pay AS (SELECT DISTINCT
                                     CLO_ServiceDate.ContainerId
                                   , tmpAll.MemberId
                                   , CLO_Position.ObjectId AS PositionId
                              FROM tmpAll
                                   INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                         ON ObjectLink_Personal_Member.ChildObjectId = tmpAll.MemberId
                                                        AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                   INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                                  ON CLO_ServiceDate.ObjectId = vbServiceDateId
                                                                 AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate()
                                   INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                  ON CLO_Personal.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                 AND CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                                                 AND CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                                  ON CLO_PersonalServiceList.ObjectId = vbPersonalServiceListId
                                                                 AND CLO_PersonalServiceList.DescId = zc_ContainerLinkObject_PersonalServiceList()
                                                                 AND CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                                   LEFT JOIN ContainerLinkObject AS CLO_Position
                                                                 ON CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                                                AND CLO_Position.DescId     = zc_ContainerLinkObject_Position()
                             )*/

       -- Результат
       SELECT 0 :: Integer                            AS Id
            , Object_Personal.Id                      AS PersonalId
            , Object_Personal.ObjectCode              AS PersonalCode
            , Object_Personal.ValueData               AS PersonalName
            , ObjectString_Member_INN.ValueData       AS INN
            , COALESCE (tmpAll.isMain, FALSE) :: Boolean AS isMain
            , COALESCE (ObjectBoolean_Member_Official.ValueData, FALSE) :: Boolean AS isOfficial

            , Object_PersonalTo.ObjectCode            AS PersonalCode_to
            , Object_PersonalTo.ValueData             AS PersonalName_to

            , Object_Unit.Id                          AS UnitId
            , Object_Unit.ObjectCode                  AS UnitCode
            , Object_Unit.ValueData                   AS UnitName
            , Object_Position.Id                      AS PositionId
            , Object_Position.ValueData               AS PositionName

            , COALESCE (Object_Member.Id, 0)         :: Integer  AS MemberId
            , COALESCE (Object_Member.ValueData, '') :: TVarChar AS MemberName

--            , tmpAll.Amount           :: TFloat AS Amount
--            , tmpAll.SummToPay        :: TFloat AS AmountToPay

              -- Сальдо на початок
            , tmpAll.AmountService_diff_start :: TFloat AS AmountService_diff_start
              -- Сальдо на кінець
            , tmpAll.AmountService_diff_end   :: TFloat AS AmountService_diff_end

              -- Ост. к выдаче (из кассы), грн
            , (tmpAll.SummToPay
             - COALESCE (tmpMIContainer.SummNalog, 0)    + tmpAll.SummNalog
             + COALESCE (tmpMIContainer.SummNalogRet, 0) - tmpAll.SummNalogRet
             - tmpAll.SummCard
             - tmpAll.SummCardSecond
             - tmpAll.SummCardSecondCash
             - COALESCE (tmpMIContainer_pay.Amount_avance, 0) - COALESCE (tmpAll.SummAvance, 0)
             - COALESCE (tmpMIContainer_pay.Amount_avance_ret, 0)
             - COALESCE (tmpMIContainer_pay.Amount_service, 0)
               -- Сальдо на кінець
             - COALESCE (tmpAll.AmountService_diff_end, 0)
              ) :: TFloat AS AmountCash

              -- Начислено,грн
            , (tmpAll.SummService /*+ COALESCE (tmpMIContainer.SummNalog, 0)*/
             -- + tmpAll.SummAdd
             + tmpAll.SummHoliday
             + tmpAll.SummHosp
             + tmpAll.SummHospOth
             + tmpAll.SummCompensation
              ) :: TFloat AS SummService

            , tmpAll.SummCard               :: TFloat AS SummCard
            , COALESCE (tmpAll.SummCardSecond,0)         :: TFloat AS SummCardSecond
            , COALESCE (tmpAll.SummCardSecondCash,0)     :: TFloat AS SummCardSecondCash
            , tmpMIContainer.SummNalog      :: TFloat AS SummNalog
            , tmpMIContainer.SummNalogRet   :: TFloat AS SummNalogRet
--            , tmpAll.SummCardRecalc       :: TFloat AS SummCardRecalc
              -- !!!временно!!!
            , (COALESCE (tmpAll.SummMinus, 0) + COALESCE (tmpAll.SummFine, 0) + COALESCE (tmpAll.SummFineOth, 0) + COALESCE (tmpAll.SummSkip, 0)) :: TFloat AS SummMinus
            , (COALESCE (tmpAll.SummFine, 0) + COALESCE (tmpAll.SummFineOth, 0)) :: TFloat AS SummFine
              --суммируем комп. жилья с премией
            , (COALESCE (tmpAll.SummAdd,0) + COALESCE (tmpAll.SummAddOth,0) + COALESCE (tmpAll.SummHouseAdd,0)) :: TFloat AS SummAdd
            , (COALESCE (tmpAll.SummAuditAdd, 0) + COALESCE (tmpAll.SummMedicdayAdd, 0)) :: TFloat AS SummAuditAdd
            , tmpAll.SummMedicdayAdd        :: TFloat AS SummMedicdayAdd
            , tmpAll.SummSkip               :: TFloat AS SummSkip
--            , tmpAll.SummSocialIn         :: TFloat AS SummSocialIn
--            , tmpAll.SummSocialAdd        :: TFloat AS SummSocialAdd
            , tmpAll.SummChild              :: TFloat AS SummChild
            , tmpAll.SummMinusExt           :: TFloat AS SummMinusExt

            , tmpAll.SummTransportAdd       :: TFloat AS SummTransportAdd
            , tmpAll.SummTransport          :: TFloat AS SummTransport
            , tmpAll.SummTransportTaxi      :: TFloat AS SummTransportTaxi
            , tmpAll.SummPhone              :: TFloat AS SummPhone

--            , ( 1 * COALESCE (tmpMIContainer_pay.Amount_avance, 0) + COALESCE (tmpAll.SummAvance, 0)) :: TFloat AS Amount_avance
            , case when vbUserId = 5 and 1=0 then tmpAll.SummAvance else COALESCE (tmpMIContainer_pay.Amount_avance, 0) + COALESCE (tmpAll.SummAvance, 0) end :: TFloat AS Amount_avance
            , (-1 * tmpMIContainer_pay.Amount_avance_ret)  :: TFloat AS Amount_avance_ret
            , tmpMIContainer_pay.Amount_service :: TFloat AS Amount_pay_service
            , tmpAll.WorkTimeHoursOne_child ::TFloat

            , tmpAll.Comment

       FROM tmpAll
            LEFT JOIN tmpMIContainer ON tmpMIContainer.MemberId    = tmpAll.MemberId
                                    AND tmpAll.Ord                 = 1
                                    AND (tmpMIContainer.PositionId = tmpAll.PositionId
                                      OR inIsShowAll = FALSE
                                        )
            LEFT JOIN tmpMIContainer_find ON tmpMIContainer_find.MemberId = tmpAll.MemberId
                                        AND ((tmpMIContainer_find.Ord      = 1 -- !!!только 1-ый!!!
                                              AND inIsShowAll = FALSE)
                                          OR (tmpMIContainer_find.PositionId = tmpAll.PositionId
                                              AND inIsShowAll = TRUE)
                                            )
            LEFT JOIN tmpMIContainer_pay ON tmpMIContainer_pay.MemberId    = tmpAll.MemberId
                                        AND ((tmpMIContainer_pay.PositionId  = tmpAll.PositionId
                                          AND tmpMIContainer_pay.UnitId      = tmpAll.UnitId
                                             )
                                          OR inIsShowAll = FALSE
                                            )

            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpAll.PersonalId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpAll.UnitId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpAll.PositionId
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpAll.MemberId
            LEFT JOIN Object AS Object_PersonalTo ON Object_PersonalTo.Id = tmpMIContainer_find.MemberId

            LEFT JOIN ObjectString AS ObjectString_Member_INN
                                   ON ObjectString_Member_INN.ObjectId = tmpAll.MemberId
                                  AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Member_Official
                                    ON ObjectBoolean_Member_Official.ObjectId = tmpAll.MemberId
                                   AND ObjectBoolean_Member_Official.DescId = zc_ObjectBoolean_Member_Official()
            --если печать из грида
            INNER JOIN tmpMI_list ON tmpMI_list.PersonalId = tmpAll.PersonalId
                                 AND tmpMI_list.PositionId = tmpAll.PositionId
                                 AND tmpMI_list.MemberId = tmpAll.MemberId
                                 AND tmpMI_list.UnitId = tmpAll.UnitId
                                 AND tmpMI_list.PersonalId = tmpAll.PersonalId
                                -- AND inIsList = TRUE) OR (inIsList = FALSE)
       WHERE 0 <> tmpAll.SummToPay
                + tmpAll.SummNalog    - COALESCE (tmpMIContainer.SummNalog, 0)
                - tmpAll.SummNalogRet + COALESCE (tmpMIContainer.SummNalogRet, 0)
                - tmpAll.SummCard - tmpAll.SummChild
          OR 0 <> tmpAll.SummService /*+ COALESCE (tmpMIContainer.SummNalog, 0)*/ + tmpAll.SummHoliday + tmpAll.SummHosp + tmpAll.SummHospOth + tmpAll.SummCompensation
          OR 0 <> tmpAll.SummCard
          OR 0 <> tmpMIContainer.SummNalog
          OR 0 <> tmpMIContainer.SummNalogRet
          OR 0 <> tmpAll.SummMinus
          OR 0 <> tmpAll.SummFine
          OR 0 <> tmpAll.SummFineOth
          OR 0 <> tmpAll.SummTransportAdd
          OR 0 <> tmpAll.SummTransport
          OR 0 <> tmpAll.SummTransportTaxi
          OR 0 <> tmpAll.SummPhone
          OR 0 <> tmpAll.SummCardSecond
          OR 0 <> tmpAll.SummAdd
          OR 0 <> tmpAll.SummAddOth
          OR 0 <> tmpAll.SummAuditAdd
          OR 0 <> tmpAll.SummMedicdayAdd
          OR 0 <> tmpAll.SummSkip
          OR 0 <> tmpAll.SummHouseAdd
          OR 0 <> tmpAll.SummAvance
          OR 0 <> tmpAll.AmountService_diff_start
          OR 0 <> tmpAll.AmountService_diff_end

          -- OR 0 <> tmpAll.SummNalog
          -- OR 0 <> tmpAll.SummNalogRet
          OR tmpMIContainer_pay.Amount_avance      <> 0
          OR tmpMIContainer_pay.Amount_avance_ret  <> 0
          OR tmpMIContainer_pay.Amount_service     <> 0
       ORDER BY Object_Personal.ValueData
      ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.03.22         *
 17.11.21         * add SummHouseAdd
 25.03.20         * add SummAuditAdd
 20.06.17         * add SummCardSecondCash
 24.02.17         *
 20.04.16         * Holiday
 16.12.15         * add Member...
 25.05.15         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalService_Print (inMovementId := 1001606, inIsShowAll:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_Movement_PersonalService_Print (inMovementId := 377284, inIsShowAll:= FALSE, inSession:= zfCalc_UserAdmin()); --FETCH ALL "<unnamed portal 5>";
