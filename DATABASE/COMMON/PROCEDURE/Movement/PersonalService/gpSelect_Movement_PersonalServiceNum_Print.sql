-- Function: gpSelect_Movement_PersonalServiceNum_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalServiceNum_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalServiceNum_Print(
    IN inMovementId    Integer  , -- ключ Документа
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

    /*
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

    */
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

           /* LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
           */
       WHERE Movement.Id = inMovementId
      --   AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       WITH 
        tmpMI AS (SELECT * 
                  FROM MovementItem 
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.isErased = FALSE
                    AND MovementItem.DescId = zc_MI_Master() 
                  )
      , tmpMIFloat AS (SELECT *
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI) 
                         AND MovementItemFloat.DescId IN (zc_MIFloat_Summ_BankSecond_num()
                                                        , zc_MIFloat_Summ_BankSecondTwo_num()
                                                        , zc_MIFloat_Summ_BankSecondDiff_num()
                                                        , zc_MIFloat_SummCardSecond()   
                                                        , zc_MIFloat_SummCardSecondRecalc()
                                                        , zc_MIFloat_SummCardSecondCash()
                                                        )
                      )

      , tmpAll AS (SELECT MovementItem.ObjectId                      AS PersonalId
                        , MILinkObject_Unit.ObjectId                 AS UnitId
                        , MILinkObject_Position.ObjectId             AS PositionId
                        , MILinkObject_BankSecondDiff_num.ObjectId   AS BankSecondDiffId_num

                        , SUM (COALESCE (MIFloat_SummCardSecond.ValueData,0) + COALESCE (MIFloat_SummCardSecondRecalc.ValueData, 0)) AS SummCardSecond
                        , SUM (COALESCE (MIFloat_SummCardSecondCash.ValueData,0))      AS SummCardSecondCash
                        , SUM (COALESCE (MIFloat_Summ_BankSecond_num.ValueData,0))     AS Summ_BankSecond_num
                        , SUM (COALESCE (MIFloat_Summ_BankSecondTwo_num.ValueData,0))  AS Summ_BankSecondTwo_num
                        , SUM (COALESCE (MIFloat_Summ_BankSecondDiff_num.ValueData,0)) AS Summ_BankSecondDiff_num

                   FROM tmpMI AS MovementItem
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                         ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

                        LEFT JOIN MovementItemLinkObject AS MILinkObject_BankSecondDiff_num
                                                         ON MILinkObject_BankSecondDiff_num.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_BankSecondDiff_num.DescId = zc_MILinkObject_BankSecondDiff_num()

                        LEFT JOIN tmpMIFloat AS MIFloat_SummCardSecond
                                             ON MIFloat_SummCardSecond.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummCardSecond.DescId = zc_MIFloat_SummCardSecond()
                        LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondRecalc
                                                    ON MIFloat_SummCardSecondRecalc.MovementItemId = MovementItem.Id
                                                   AND MIFloat_SummCardSecondRecalc.DescId = zc_MIFloat_SummCardSecondRecalc()

                        LEFT JOIN tmpMIFloat AS MIFloat_SummCardSecondCash
                                             ON MIFloat_SummCardSecondCash.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()

                        LEFT JOIN tmpMIFloat AS MIFloat_Summ_BankSecond_num
                                             ON MIFloat_Summ_BankSecond_num.MovementItemId = MovementItem.Id
                                            AND MIFloat_Summ_BankSecond_num.DescId = zc_MIFloat_Summ_BankSecond_num()
                        LEFT JOIN tmpMIFloat AS MIFloat_Summ_BankSecondTwo_num
                                             ON MIFloat_Summ_BankSecondTwo_num.MovementItemId = MovementItem.Id
                                            AND MIFloat_Summ_BankSecondTwo_num.DescId = zc_MIFloat_Summ_BankSecondTwo_num()
                        LEFT JOIN tmpMIFloat AS MIFloat_Summ_BankSecondDiff_num
                                             ON MIFloat_Summ_BankSecondDiff_num.MovementItemId = MovementItem.Id
                                            AND MIFloat_Summ_BankSecondDiff_num.DescId = zc_MIFloat_Summ_BankSecondDiff_num()
                   GROUP BY MovementItem.ObjectId
                        , MILinkObject_Unit.ObjectId
                        , MILinkObject_Position.ObjectId
                        , MILinkObject_BankSecondDiff_num.ObjectId
                   HAVING 0 <> SUM (COALESCE (MIFloat_Summ_BankSecond_num.ValueData,0))
                       OR 0 <> SUM (COALESCE (MIFloat_Summ_BankSecondTwo_num.ValueData,0))
                       OR 0 <> SUM (COALESCE (MIFloat_Summ_BankSecondDiff_num.ValueData,0)) 
                       OR 0 <> SUM (COALESCE (MIFloat_SummCardSecond.ValueData,0) + COALESCE (MIFloat_SummCardSecondRecalc.ValueData, 0))
                       OR 0 <> SUM (COALESCE (MIFloat_SummCardSecondCash.ValueData,0))
                  )

       --------------
       SELECT 0 :: Integer                            AS Id
            , Object_Personal.Id                      AS PersonalId
            , Object_Personal.ObjectCode              AS PersonalCode
            , Object_Personal.ValueData               AS PersonalName
            , ObjectString_Member_INN.ValueData       AS INN
            
            , Object_Unit.Id                          AS UnitId
            , Object_Unit.ObjectCode                  AS UnitCode
            , Object_Unit.ValueData                   AS UnitName
            , Object_Position.Id                      AS PositionId
            , Object_Position.ValueData               AS PositionName 
            
            , Object_BankSecondDiff_num.ValueData     AS BankSecondDiffName_num

            , tmpAll.Summ_BankSecond_num        :: TFloat
            , tmpAll.Summ_BankSecondTwo_num     :: TFloat
            , tmpAll.Summ_BankSecondDiff_num    :: TFloat
            , tmpAll.SummCardSecond             :: TFloat
            , tmpAll.SummCardSecondCash         :: TFloat

       FROM tmpAll
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpAll.PersonalId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpAll.UnitId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpAll.PositionId
            LEFT JOIN Object AS Object_BankSecondDiff_num ON Object_BankSecondDiff_num.Id = tmpAll.BankSecondDiffId_num

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = tmpAll.PersonalId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

            LEFT JOIN ObjectString AS ObjectString_Member_INN
                                   ON ObjectString_Member_INN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                  AND ObjectString_Member_INN.DescId = zc_ObjectString_member_INN()

       ORDER BY Object_Personal.ValueData
      ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 15.03.24         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalServiceNum_Print (inMovementId := 1001606, inSession:= zfCalc_UserAdmin());
