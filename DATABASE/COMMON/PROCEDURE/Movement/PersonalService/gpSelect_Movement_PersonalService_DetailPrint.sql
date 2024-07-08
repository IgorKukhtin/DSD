-- Function: gpSelect_Movement_PersonalService_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_DetailPrint (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService_DetailPrint(
    IN inMovementId    Integer  , -- ключ Документа
    IN inisShowAll     Boolean  ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbServiceDateId         Integer;
    DECLARE vbPersonalServiceListId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Проверка прав роль - Ограничение просмотра данных ЗП!!!
     PERFORM lpCheck_UserRole_8813637 (vbUserId);


     IF zc_Enum_Status_Erased() = (SELECT StatusId FROM Movement WHERE Id = inMovementId)
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = (SELECT DescId FROM Movement WHERE Id = inMovementId)), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
     END IF;
     IF zc_Enum_Status_UnComplete() = (SELECT StatusId FROM Movement WHERE Id = inMovementId) AND vbUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = (SELECT DescId FROM Movement WHERE Id = inMovementId)), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
     END IF;


     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MIDate_ServiceDate()));
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
            + COALESCE (MovementFloat_TotalSummAuditAdd.ValueData,0)
            + COALESCE (MovementFloat_TotalSummAddOth.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummHoliday.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummHosp.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummHospOth.ValueData, 0)
            + CAST (COALESCE (MovementFloat_TotalSummCompensation.ValueData, 0) AS NUMERIC (16, 2))
            -- + COALESCE (MovementFloat_TotalSummSocialAdd.ValueData, 0)
            + COALESCE (MovementFloat_TotalSummHouseAdd.ValueData,0)
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
            + COALESCE (MovementFloat_TotalSummAvCardSecond.ValueData, 0) + COALESCE (MovementFloat_TotalSummAvCardSecondRecalc.ValueData, 0)
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
                                   AND MovementFloat_TotalSummFine.DescId = zc_MovementFloat_TotalSummFine()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummFineOth
                                    ON MovementFloat_TotalSummFineOth.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummFineOth.DescId     = zc_MovementFloat_TotalSummFineOth()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAdd
                                    ON MovementFloat_TotalSummAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAdd.DescId = zc_MovementFloat_TotalSummAdd()

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

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAddOth
                                    ON MovementFloat_TotalSummAddOth.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAddOth.DescId = zc_MovementFloat_TotalSummAddOth()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHoliday
                                    ON MovementFloat_TotalSummHoliday.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHoliday.DescId = zc_MovementFloat_TotalSummHoliday()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHosp
                                    ON MovementFloat_TotalSummHosp.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHosp.DescId = zc_MovementFloat_TotalSummHosp()
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
          , tmpMIContainer AS (SELECT tmpMIContainer_all.MovementItemId
                                    , tmpMIContainer_all.MemberId
                                    , SUM (tmpMIContainer_all.SummNalog)    :: TFloat AS SummNalog
                                    , SUM (tmpMIContainer_all.SummNalogRet) :: TFloat AS SummNalogRet
                                    , CASE WHEN inisShowAll = TRUE THEN tmpMIContainer_all.PositionId ELSE 0 END AS PositionId
                               FROM tmpMIContainer_all
                               GROUP BY tmpMIContainer_all.MovementItemId
                                      , tmpMIContainer_all.MemberId
                                      , CASE WHEN inisShowAll = TRUE THEN tmpMIContainer_all.PositionId ELSE 0 END
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

                           , COALESCE (MIFloat_SummToPay.ValueData, 0)        AS SummToPay
                           , COALESCE (MIFloat_SummNalog.ValueData, 0)        AS SummNalog
                           , COALESCE (MIFloat_SummNalogRet.ValueData, 0)     AS SummNalogRet
                           , COALESCE (MIFloat_SummCard.ValueData, 0)         AS SummCard
                           , COALESCE (MIFloat_SummCardSecond.ValueData, 0) + COALESCE (MIFloat_SummCardSecondRecalc.ValueData, 0)
                           + COALESCE (MIFloat_SummAvCardSecond.ValueData, 0) + COALESCE (MIFloat_SummAvCardSecondRecalc.ValueData, 0)
                             AS SummCardSecond
                           , COALESCE (MIFloat_SummCardSecondCash.ValueData, 0) AS SummCardSecondCash
                           , COALESCE (MIFloat_SummService.ValueData, 0)      AS SummService
                           , COALESCE (MIFloat_SummAdd.ValueData, 0)          AS SummAdd
                           , COALESCE (MIFloat_SummAddOth.ValueData, 0)       AS SummAddOth
                           , COALESCE (MIFloat_SummHoliday.ValueData, 0)      AS SummHoliday
                           , COALESCE (MIFloat_SummHosp.ValueData, 0)         AS SummHosp
                           , COALESCE (MIFloat_SummHospOth.ValueData, 0)      AS SummHospOth
                           , CAST (COALESCE (MIFloat_SummCompensation.ValueData, 0) AS NUMERIC (16, 2)) AS SummCompensation
                             --
                           , COALESCE (MIFloat_SummAuditAdd.ValueData, 0)     AS SummAuditAdd
                             -- плюс за санобработка
                           , COALESCE (MIFloat_SummMedicdayAdd.ValueData, 0)  AS SummMedicdayAdd
                             -- минус за прогул
                           , COALESCE (MIFloat_SummSkip.ValueData, 0)         AS SummSkip

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

                           , MIString_Comment.ValueData         AS Comment

                      FROM MovementItem
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
                           LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecondRecalc
                                                       ON MIFloat_SummAvCardSecondRecalc.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummAvCardSecondRecalc.DescId = zc_MIFloat_SummAvCardSecondRecalc()

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

                           LEFT JOIN MovementItemBoolean AS MIBoolean_Main
                                                         ON MIBoolean_Main.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_Main.DescId = zc_MIBoolean_Main()

                      WHERE  MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.isErased = FALSE
                     )

          , tmpMI AS (SELECT tmpMI_all.MovementItemId
                           , tmpMI_all.PersonalId
                           , tmpMI_all.UnitId
                           , tmpMI_all.PositionId

                           , tmpMI_all.MemberId
                           , tmpMI_all.PersonalServiceListId
                           , tmpMI_all.isMain
                           , tmpMI_all.Comment

                           , SUM (tmpMI_all.Amount)           AS Amount

                           , SUM (tmpMI_all.SummToPay)        AS SummToPay
                           , SUM (tmpMI_all.SummNalog)        AS SummNalog
                           , SUM (tmpMI_all.SummNalogRet)     AS SummNalogRet
                           , SUM (tmpMI_all.SummCard)         AS SummCard
                           , SUM (tmpMI_all.SummCardSecond)   AS SummCardSecond
                           , SUM (tmpMI_all.SummCardSecondCash)  AS SummCardSecondCash
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

                      FROM tmpMI_all
                      GROUP BY tmpMI_all.MovementItemId
                             , tmpMI_all.PersonalId
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
          , tmpAll AS (SELECT tmpMI.MovementItemId
                            , tmpMI.Amount, tmpMI.PersonalId, tmpMI.UnitId, tmpMI.PositionId, tmpMI.MemberId, tmpMI.PersonalServiceListId
                            , tmpMI.isMain
                            , tmpMI.Comment
                            , tmpMI.Amount
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
                       FROM tmpMI
                      UNION ALL
                       SELECT 0 AS MovementItemId
                            , 0 AS Amount, tmpPersonal.PersonalId, tmpPersonal.UnitId, tmpPersonal.PositionId, tmpPersonal.MemberId, tmpPersonal.PersonalServiceListId
                            , tmpPersonal.isMain
                            , '' AS Comment
                            , 0 AS Amount
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
                        FROM tmpPersonal
                        WHERE tmpPersonal.Ord = 1
                      )

   , tmpMaster AS (SELECT tmpAll.PositionId
                        , tmpAll.MemberId

            --            , tmpAll.Amount           :: TFloat AS Amount
            --            , tmpAll.SummToPay        :: TFloat AS AmountToPay

                        , SUM (tmpAll.SummService /*+ COALESCE (tmpMIContainer.SummNalog, 0)*/
                         -- + tmpAll.SummAdd
                         --+ tmpAll.SummHoliday
                          ) :: TFloat AS SummService
                        , SUM (tmpAll.SummHoliday)            :: TFloat AS SummHoliday
                        , SUM (tmpAll.SummHosp)               :: TFloat AS SummHosp
                        , SUM (tmpAll.SummHospOth)            :: TFloat AS SummHospOth
                        , SUM (tmpAll.SummCompensation)       :: TFloat AS SummCompensation
                        , SUM (tmpAll.SummCard)               :: TFloat AS SummCard
                        , SUM (tmpAll.SummCardSecond)         :: TFloat AS SummCardSecond
                        , SUM (tmpAll.SummCardSecondCash)     :: TFloat AS SummCardSecondCash
                        , SUM (tmpMIContainer.SummNalog)      :: TFloat AS SummNalog
                        , SUM (tmpMIContainer.SummNalogRet)   :: TFloat AS SummNalogRet
            --            , SUM (tmpAll.SummCardRecalc)       :: TFloat AS SummCardRecalc
                        , SUM (tmpAll.SummMinus)              :: TFloat AS SummMinus
                        , SUM (tmpAll.SummFine)               :: TFloat AS SummFine
                        , SUM (tmpAll.SummFineOth)            :: TFloat AS SummFineOth
                        , SUM (COALESCE (tmpAll.SummAdd,0) + COALESCE (tmpAll.SummAddOth,0) + COALESCE (tmpAll.SummHouseAdd,0) )   :: TFloat AS SummAdd
                        , SUM (tmpAll.SummAuditAdd)           :: TFloat AS SummAuditAdd
                        , SUM (tmpAll.SummMedicdayAdd)        :: TFloat AS SummMedicdayAdd
                        , SUM (tmpAll.SummSkip)               :: TFloat AS SummSkip
                          --
            --            , SUM (tmpAll.SummSocialIn)         :: TFloat AS SummSocialIn
            --            , SUM (tmpAll.SummSocialAdd)        :: TFloat AS SummSocialAdd
                        , SUM (tmpAll.SummChild)              :: TFloat AS SummChild
                        , SUM (tmpAll.SummMinusExt)           :: TFloat AS SummMinusExt

                        , SUM (tmpAll.SummTransportAdd)       :: TFloat AS SummTransportAdd
                        , SUM (tmpAll.SummTransport)          :: TFloat AS SummTransport
                        , SUM (tmpAll.SummTransportTaxi)      :: TFloat AS SummTransportTaxi
                        , SUM (tmpAll.SummPhone)              :: TFloat AS SummPhone

                        , MAX (tmpAll.Comment)               :: TVarChar AS Comment

                   FROM tmpAll
                        LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = tmpAll.MovementItemId
                                                AND tmpMIContainer.MemberId       = tmpAll.MemberId
                                                AND tmpMIContainer.PositionId     = tmpAll.PositionId
                   WHERE 0 <> tmpAll.SummToPay
                            + tmpAll.SummNalog    - COALESCE (tmpMIContainer.SummNalog, 0)
                            - tmpAll.SummNalogRet + COALESCE (tmpMIContainer.SummNalogRet, 0)
                            - tmpAll.SummCard - tmpAll.SummChild
                      OR 0 <> tmpAll.SummService /*+ COALESCE (tmpMIContainer.SummNalog, 0)*/
                      OR 0 <> tmpAll.SummHoliday
                      OR 0 <> tmpAll.SummHosp
                      OR 0 <> tmpAll.SummHospOth
                      OR 0 <> tmpAll.SummCompensation
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
                      -- OR 0 <> tmpAll.SummNalog
                      -- OR 0 <> tmpAll.SummNalogRet
                   GROUP BY tmpAll.PositionId
                          , tmpAll.MemberId
                )



     -- чайд
     , tmpMI_Child AS (SELECT MovementItem.Id                          AS Id
                            , MovementItem.ParentId                    AS ParentId
                            , MovementItem.Amount                      AS Amount

                            , MILinkObject_PositionLevel.ObjectId      AS PositionLevelId
                            , MILinkObject_StaffList.ObjectId          AS StaffListId
                            , MILinkObject_ModelService.ObjectId       AS ModelServiceId
                            , MILinkObject_StaffListSummKind.ObjectId  AS StaffListSummKindId
                          -- , MILinkObject_StorageLine.ObjectId        AS StorageLineId
                            , CAST (CASE WHEN MIFloat_Koeff.ValueData IS NULL THEN CASE WHEN COALESCE (MIFloat_GrossOne.ValueData,0) <> 0 THEN MovementItem.Amount / MIFloat_GrossOne.ValueData ELSE 0 END
                                   ELSE (COALESCE (MIFloat_Koeff.ValueData,1) * CASE WHEN COALESCE (MILinkObject_StaffListSummKind.ObjectId, 0) = 0 THEN MIFloat_Price.ValueData ELSE 0 END)
                              END  AS NUMERIC (16,2) ) :: TFloat AS Rate
                            , MIFloat_Price.ValueData                  AS Price
                            , MIFloat_GrossOne.ValueData               AS GrossOne

                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                            ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffList
                                                           ON MILinkObject_StaffList.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_StaffList.DescId = zc_MILinkObject_StaffList()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_ModelService
                                                            ON MILinkObject_ModelService.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_ModelService.DescId = zc_MILinkObject_ModelService()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffListSummKind
                                                            ON MILinkObject_StaffListSummKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_StaffListSummKind.DescId = zc_MILinkObject_StaffListSummKind()
                          /* LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                            ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()*/
                           LEFT JOIN MovementItemFloat AS MIFloat_Koeff
                                                       ON MIFloat_Koeff.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Koeff.DescId = zc_MIFloat_Koeff()

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()

                           LEFT JOIN MovementItemFloat AS MIFloat_GrossOne
                                                       ON MIFloat_GrossOne.MovementItemId = MovementItem.Id
                                                      AND MIFloat_GrossOne.DescId = zc_MIFloat_GrossOne()

                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId = zc_MI_Child()
                         AND MovementItem.isErased = FALSE
                      )

     , tmpChild_TotalSumm AS (SELECT tmpMI.MemberId, tmpMI.PositionId, tmpMI_Child.Rate
                                   , SUM (tmpMI_Child.Amount) AS Amount
                              FROM tmpMI_Child
                                   LEFT JOIN tmpMI ON tmpMI.MovementItemId = tmpMI_Child.ParentId
                              GROUP BY tmpMI.MemberId, tmpMI.PositionId, tmpMI_Child.Rate
                              )

     , tmpMovementItemFloat AS (SELECT MovementItemFloat.*
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                                  AND MovementItemFloat.DescId IN (zc_MIFloat_DayCount()
                                                                  , zc_MIFloat_MemberCount()
                                                                  , zc_MIFloat_WorkTimeHoursOne()
                                                                  , zc_MIFloat_WorkTimeHours()
                                                                 -- , zc_MIFloat_Price()
                                                                  , zc_MIFloat_HoursPlan()
                                                                  , zc_MIFloat_HoursDay()
                                                                  , zc_MIFloat_PersonalCount()
                                                                 -- , zc_MIFloat_GrossOne()
                                                                  )
                                ) 

     , tmpChild AS (SELECT tmpMI.MemberId
                         , tmpMI.PositionId
                         , tmpMI_Child.PositionLevelId
                         , tmpMI_Child.StaffListId
                         , tmpMI_Child.ModelServiceId
                         , CASE WHEN COALESCE (tmpMI_Child.StaffListSummKindId, 0) IN (12109, 12110) THEN tmpMI_Child.StaffListSummKindId ELSE 0 END    AS StaffListSummKindId -- доплата (тип доплаты)
                         , CASE WHEN COALESCE (tmpMI_Child.StaffListSummKindId, 0) = 0 THEN tmpMI_Child.Price ELSE 0 END                                AS Price        -- расценка
                         , tmpMI_Child.Rate                                                                                                                                  -- тариф
                         , SUM (CASE WHEN COALESCE (tmpMI_Child.StaffListSummKindId, 0) IN (12109, 12110) THEN tmpMI_Child.Price ELSE 0 END)            AS Price_Dop    -- расценка за смену
                         , SUM (CASE WHEN COALESCE (tmpMI_Child.StaffListSummKindId, 0) NOT IN (0, 12109, 12110) THEN tmpMI_Child.Price ELSE 0 END)     AS Price_Day    -- расценка за день
                         , SUM (CASE WHEN COALESCE (tmpMI_Child.StaffListSummKindId, 0) IN (12109, 12110) THEN MIFloat_DayCount.ValueData ELSE 0 END)         AS DayCount_Dop -- кол. смен - доплата
                         --, SUM (CASE WHEN COALESCE (tmpMI_Child.StaffListSummKindId, 0) NOT IN (0, 12109, 12110) THEN MIFloat_DayCount.ValueData ELSE 0 END)  AS DayCount     -- кол. смен
                         , SUM (CASE WHEN COALESCE (MIFloat_HoursDay.ValueData,0) <> 0 THEN MIFloat_WorkTimeHoursOne.ValueData / COALESCE (MIFloat_HoursDay.ValueData,0) ELSE 0 END) AS DayCount     -- кол. смен (часы, деленные на норму часов за 1 рабочий день)
                         , SUM (CASE WHEN COALESCE (tmpMI_Child.StaffListSummKindId, 0) = 0 THEN tmpMI_Child.Amount ELSE 0 END)                               AS Amount       -- начислено
                         , SUM (CASE WHEN COALESCE (tmpMI_Child.StaffListSummKindId, 0) IN ( 12109, 12110)  THEN tmpMI_Child.Amount ELSE 0 END)               AS Amount_Dop   -- начислено за смену
                         , SUM (CASE WHEN COALESCE (tmpMI_Child.StaffListSummKindId, 0) NOT IN (0, 12109, 12110) THEN tmpMI_Child.Amount ELSE 0 END)          AS Amount_Day   -- начислено за день
                         , SUM (MIFloat_MemberCount.ValueData)            AS MemberCount
                         , SUM (MIFloat_WorkTimeHoursOne.ValueData)       AS WorkTimeHoursOne
                         , SUM (MIFloat_WorkTimeHours.ValueData)          AS WorkTimeHours
                         , SUM (MIFloat_HoursPlan.ValueData)              AS HoursPlan
                         , SUM (MIFloat_HoursDay.ValueData)               AS HoursDay
                         , SUM (MIFloat_PersonalCount.ValueData)          AS PersonalCount
                         --, SUM (MIFloat_GrossOne.ValueData)               AS GrossOne                     -- выработка на человека
                         , SUM (COALESCE (tmpMI_Child.GrossOne,0))        AS GrossOne                     -- выработка на человека
                         
                    FROM tmpMI_Child
                         LEFT JOIN tmpMI ON tmpMI.MovementItemId = tmpMI_Child.ParentId
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_MemberCount
                                                     ON MIFloat_MemberCount.MovementItemId = tmpMI_Child.Id
                                                    AND MIFloat_MemberCount.DescId = zc_MIFloat_MemberCount()
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_DayCount
                                                     ON MIFloat_DayCount.MovementItemId = tmpMI_Child.Id
                                                    AND MIFloat_DayCount.DescId = zc_MIFloat_DayCount()
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_WorkTimeHoursOne
                                                     ON MIFloat_WorkTimeHoursOne.MovementItemId = tmpMI_Child.Id
                                                    AND MIFloat_WorkTimeHoursOne.DescId = zc_MIFloat_WorkTimeHoursOne()

                         LEFT JOIN tmpMovementItemFloat AS MIFloat_WorkTimeHours
                                                     ON MIFloat_WorkTimeHours.MovementItemId = tmpMI_Child.Id
                                                    AND MIFloat_WorkTimeHours.DescId = zc_MIFloat_WorkTimeHours()

                         /*LEFT JOIN tmpMovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = tmpMI_Child.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()*/

                         LEFT JOIN tmpMovementItemFloat AS MIFloat_HoursPlan
                                                     ON MIFloat_HoursPlan.MovementItemId = tmpMI_Child.Id
                                                    AND MIFloat_HoursPlan.DescId = zc_MIFloat_HoursPlan()

                         LEFT JOIN tmpMovementItemFloat AS MIFloat_HoursDay
                                                     ON MIFloat_HoursDay.MovementItemId = tmpMI_Child.Id
                                                    AND MIFloat_HoursDay.DescId = zc_MIFloat_HoursDay()

                         LEFT JOIN tmpMovementItemFloat AS MIFloat_PersonalCount
                                                     ON MIFloat_PersonalCount.MovementItemId = tmpMI_Child.Id
                                                    AND MIFloat_PersonalCount.DescId = zc_MIFloat_PersonalCount()
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_GrossOne
                                                     ON MIFloat_GrossOne.MovementItemId = tmpMI_Child.Id
                                                    AND MIFloat_GrossOne.DescId = zc_MIFloat_GrossOne()

                       GROUP BY tmpMI.MemberId
                              , tmpMI.PositionId
                              , tmpMI_Child.PositionLevelId
                              , tmpMI_Child.StaffListId
                              , tmpMI_Child.ModelServiceId
                              , CASE WHEN COALESCE (tmpMI_Child.StaffListSummKindId, 0) IN (12109, 12110) THEN tmpMI_Child.StaffListSummKindId ELSE 0 END
                              , CASE WHEN COALESCE (tmpMI_Child.StaffListSummKindId, 0) = 0 THEN tmpMI_Child.Price ELSE 0 END
                              , tmpMI_Child.Rate
                        )

     , tmpChild_TotalDayCount AS (SELECT tmpChild.MemberId, tmpChild.PositionId, tmpChild.Rate
                                       , SUM (tmpChild.DayCount) AS Amount
                                  FROM tmpChild
                                  GROUP BY tmpChild.MemberId, tmpChild.PositionId, tmpChild.Rate
                                  )

       -- Результат
       SELECT 0 :: Integer                            AS Id
            , Object_Personal.Id                      AS PersonalId
            , Object_Personal.ObjectCode              AS PersonalCode
            , Object_Personal.ValueData               AS PersonalName
            , ObjectString_Member_INN.ValueData       AS INN
          --, COALESCE (tmpAll.isMain, FALSE) :: Boolean AS isMain
            , COALESCE (ObjectBoolean_Member_Official.ValueData, FALSE) :: Boolean AS isOfficial

            , Object_Unit.Id                          AS UnitId
            , Object_Unit.ObjectCode                  AS UnitCode
            , Object_Unit.ValueData                   AS UnitName
            , Object_Position.Id                      AS PositionId
            , Object_Position.ValueData               AS PositionName

            , COALESCE (Object_Member.Id, 0)         :: Integer  AS MemberId
            , COALESCE (Object_Member.ValueData, '') :: TVarChar AS MemberName

--            , tmpAll.Amount           :: TFloat AS Amount
--            , tmpAll.SummToPay        :: TFloat AS AmountToPay

            , tmpAll.SummService            :: TFloat AS SummService
              -- !!!временно!!!
            , (tmpAll.SummHoliday + tmpAll.SummHosp + tmpAll.SummHospOth + tmpAll.SummCompensation) :: TFloat AS SummHoliday
            , (tmpAll.SummHosp + tmpAll.SummHospOth) :: TFloat AS SummHosp
            , tmpAll.SummCompensation       :: TFloat AS SummCompensation
            , tmpAll.SummCard               :: TFloat AS SummCard
            , tmpAll.SummCardSecond         :: TFloat AS SummCardSecond
            , tmpAll.SummCardSecondCash     :: TFloat AS SummCardSecondCash
            , tmpAll.SummNalog              :: TFloat AS SummNalog
            , tmpAll.SummNalogRet           :: TFloat AS SummNalogRet
--            , tmpAll.SummCardRecalc       :: TFloat AS SummCardRecalc
              -- !!!временно!!!
            , (COALESCE (tmpAll.SummMinus, 0) + COALESCE (tmpAll.SummFine, 0) + COALESCE (tmpAll.SummFineOth, 0) + COALESCE (tmpAll.SummSkip, 0)) :: TFloat AS SummMinus
            , (tmpAll.SummFine  + tmpAll.SummFineOth)              :: TFloat AS SummFine
            , tmpAll.SummAdd                :: TFloat AS SummAdd
            , (COALESCE (tmpAll.SummAuditAdd, 0) + COALESCE (tmpAll.SummMedicdayAdd, 0)) :: TFloat AS SummAuditAdd
            , tmpAll.SummMedicdayAdd        :: TFloat AS SummMedicdayAdd
            , tmpAll.SummSkip               :: TFloat AS SummSkip
              --
--            , tmpAll.SummSocialIn         :: TFloat AS SummSocialIn
--            , tmpAll.SummSocialAdd        :: TFloat AS SummSocialAdd
              --
            , tmpAll.SummChild              :: TFloat AS SummChild
            , tmpAll.SummMinusExt           :: TFloat AS SummMinusExt

            , tmpAll.SummTransportAdd       :: TFloat AS SummTransportAdd
            , tmpAll.SummTransport          :: TFloat AS SummTransport
            , tmpAll.SummTransportTaxi      :: TFloat AS SummTransportTaxi
            , tmpAll.SummPhone              :: TFloat AS SummPhone
            , (tmpAll.SummService + COALESCE (tmpAll.SummAdd, 0) + COALESCE (tmpAll.SummNalogRet, 0)
                                  + COALESCE (tmpAll.SummHoliday, 0) + COALESCE (tmpAll.SummHosp, 0) + COALESCE (tmpAll.SummHospOth, 0) + COALESCE (tmpAll.SummCompensation, 0)
                                  - COALESCE (tmpAll.SummMinus, 0) - COALESCE (tmpAll.SummFine, 0) - COALESCE (tmpAll.SummFineOth, 0) - COALESCE (tmpAll.SummNalog, 0)) :: TFloat AS TotalSumm

            , tmpChild_TotalSumm.Amount     :: TFloat AS TotalSummChild
            , tmpChild_TotalDayCount.Amount :: TFloat AS TotalDayCount
            -- чайлд
            , Object_PositionLevel.Id                 AS PositionLevelId
            , Object_PositionLevel.ValueData          AS PositionLevelName

            , Object_ModelService.Id                  AS ModelServiceId
            , Object_ModelService.ValueData           AS ModelServiceName

            , Object_StaffListSummKind.Id             AS StaffListSummKindId
            , Object_StaffListSummKind.ValueData      AS StaffListSummKindName

            --, Object_StorageLine.Id                    AS StorageLineId
            --, Object_StorageLine.ValueData             AS StorageLineName

            , tmpChild.Price               :: TFloat -- расценка
            , tmpChild.Price_Dop           :: TFloat -- расценка за смену
            , tmpChild.Price_Day           :: TFloat -- расценка за день
            , tmpChild.DayCount_Dop        :: TFloat -- кол. смен - доплата
            , CAST (tmpChild.DayCount AS NUMERIC (16,2)) :: TFloat -- кол. смен
            , tmpChild.Amount :: TFloat AS Amount_Child -- начислено
            , tmpChild.Amount_Dop          :: TFloat -- начислено за смену
            , tmpChild.Amount_Day          :: TFloat -- начислено за день
            , tmpChild.MemberCount         :: TFloat
            , tmpChild.WorkTimeHoursOne    :: TFloat
            , tmpChild.WorkTimeHours       :: TFloat
            , tmpChild.HoursPlan           :: TFloat
            , tmpChild.HoursDay            :: TFloat
            , tmpChild.PersonalCount       :: TFloat
            , tmpChild.GrossOne            :: TFloat
            , tmpChild.Rate                :: TFloat
       FROM tmpMaster AS tmpAll
            LEFT JOIN tmpChild ON tmpChild.MemberId   = tmpAll.MemberId
                              AND tmpChild.PositionId = tmpAll.PositionId

            LEFT JOIN tmpChild_TotalSumm ON tmpChild_TotalSumm.MemberId   = tmpAll.MemberId
                                        AND tmpChild_TotalSumm.PositionId = tmpAll.PositionId
                                        AND tmpChild_TotalSumm.Rate       = tmpChild.Rate
            LEFT JOIN tmpChild_TotalDayCount ON tmpChild_TotalDayCount.MemberId   = tmpAll.MemberId
                                            AND tmpChild_TotalDayCount.PositionId = tmpAll.PositionId
                                            AND tmpChild_TotalDayCount.Rate       = tmpChild.Rate

            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpAll.MemberId -- tmpAll.PersonalId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = NULL -- tmpAll.UnitId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpAll.PositionId
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpAll.MemberId

            LEFT JOIN ObjectString AS ObjectString_Member_INN
                                   ON ObjectString_Member_INN.ObjectId = tmpAll.MemberId
                                  AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Member_Official
                                    ON ObjectBoolean_Member_Official.ObjectId = tmpAll.MemberId
                                   AND ObjectBoolean_Member_Official.DescId = zc_ObjectBoolean_Member_Official()

            -- чайлд
            LEFT JOIN Object AS Object_PositionLevel     ON Object_PositionLevel.Id     = tmpChild.PositionLevelId
            LEFT JOIN Object AS Object_StaffList         ON Object_StaffList.Id         = tmpChild.StaffListId
            LEFT JOIN Object AS Object_ModelService      ON Object_ModelService.Id      = tmpChild.ModelServiceId
            LEFT JOIN Object AS Object_StaffListSummKind ON Object_StaffListSummKind.Id = tmpChild.StaffListSummKindId
            --LEFT JOIN Object AS Object_StorageLine       ON Object_StorageLine.Id       = tmpChild.StorageLineId
       --where tmpAll.PersonalId = 2250371
       ORDER BY
                Object_Position.ValueData , Object_Personal.ValueData
              , Object_ModelService.ValueData
              , Object_PositionLevel.ValueData
              , Object_StaffListSummKind.Id
              , tmpChild.Rate
      ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.03.20         * SummAuditAdd
 02.10.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalService_DetailPrint (inMovementId := 1001606, inisShowAll:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_Movement_PersonalService_DetailPrint (inMovementId := 10495948, inisShowAll:= TRUE, inSession:= zfCalc_UserAdmin()); -- FETCH ALL "<unnamed portal 16>";
