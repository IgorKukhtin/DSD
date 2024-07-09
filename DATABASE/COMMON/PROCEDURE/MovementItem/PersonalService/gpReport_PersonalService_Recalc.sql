-- Function: gpReport_PersonalService_Recalc()

DROP FUNCTION IF EXISTS gpReport_PersonalService_Recalc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PersonalService_Recalc(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , MemberId_Personal Integer
             , INN TVarChar, Code1C TVarChar
             , isMain Boolean, isOfficial Boolean, DateOut TDateTime, DateIn TDateTime
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , MemberId Integer, MemberName TVarChar
             , PersonalServiceListId_mi Integer, PersonalServiceListName_mi TVarChar
             , FineSubjectId Integer, FineSubjectName TVarChar
             , UnitFineSubjectId Integer, UnitFineSubjectName TVarChar
             --
             , SummCardRecalc         TFloat
             , SummCardSecondRecalc   TFloat
             , SummNalogRecalc        TFloat
             , SummNalogRetRecalc     TFloat
             , SummFineOthRecalc      TFloat
             , SummHospOthRecalc      TFloat
             , SummChildRecalc        TFloat
             , SummMinusExtRecalc     TFloat
             , SummAddOthRecalc       TFloat
             , SummCompensationRecalc TFloat
             , SummAvanceRecalc       TFloat
             --
             , SummCard               TFloat
             , SummCardSecond         TFloat
             , SummNalog              TFloat
             , SummNalogRet           TFloat
             , SummFineOth            TFloat
             , SummHospOth            TFloat
             , SummChild              TFloat
             , SummMinusExt           TFloat
             , SummAddOth             TFloat
             , SummCompensation       TFloat
             , SummAvance             TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbServiceDate   TDateTime;
   DECLARE vbServiceDateId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Проверка прав роль - Ограничение - нет вообще доступа к просмотру данных ЗП!!!!!!
     --PERFORM lpCheck_UserRole_8813637 (vbUserId);

     -- из шапки док.
     vbServiceDate  := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MIDate_ServiceDate());
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= vbServiceDate);
     
          -- Результат
     RETURN QUERY
       WITH 
       tmpMI_All AS (SELECT MovementItem.Id                          AS MovementItemId
                          , MovementItem.ObjectId                    AS PersonalId
                          , MILinkObject_Unit.ObjectId               AS UnitId
                          , MILinkObject_Position.ObjectId           AS PositionId
                          , MILinkObject_InfoMoney.ObjectId          AS InfoMoneyId
                          , MILinkObject_Member.ObjectId             AS MemberId
                          , ObjectLink_Personal_Member.ChildObjectId AS MemberId_Personal
                          , MILinkObject_PersonalServiceList.ObjectId AS PersonalServiceListId
                     FROM MovementItem
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                           ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                                           ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
                          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                               ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                              AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                           ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId = zc_MI_Master()
                       AND MovementItem.isErased = FALSE
                    )

     , tmpMIFloat AS (SELECT MovementItemFloat.*
                      FROM MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_All.MovementItemId FROM tmpMI_All)
                        AND MovementItemFloat.DescId IN (zc_MIFloat_SummCardRecalc()
                                                       , zc_MIFloat_SummAvanceRecalc()
                                                       , zc_MIFloat_SummCompensationRecalc()
                                                       , zc_MIFloat_SummAddOthRecalc()
                                                       , zc_MIFloat_SummMinusExtRecalc()
                                                       , zc_MIFloat_SummChildRecalc()
                                                       , zc_MIFloat_SummHospOthRecalc()
                                                       , zc_MIFloat_SummFineOthRecalc()
                                                       , zc_MIFloat_SummNalogRetRecalc()
                                                       , zc_MIFloat_SummNalogRecalc()
                                                       , zc_MIFloat_SummCardSecondRecalc()
                                                      )
                     )

     , tmpMI AS (SELECT tmpMI.*
                      , COALESCE (MIFloat_SummCardRecalc.ValueData,0)         AS SummCardRecalc
                      , COALESCE (MIFloat_SummCardSecondRecalc.ValueData,0)   AS SummCardSecondRecalc
                      , COALESCE (MIFloat_SummNalogRecalc.ValueData,0)        AS SummNalogRecalc
                      , COALESCE (MIFloat_SummNalogRetRecalc.ValueData,0)     AS SummNalogRetRecalc
                      , COALESCE (MIFloat_SummFineOthRecalc.ValueData,0)      AS SummFineOthRecalc
                      , COALESCE (MIFloat_SummHospOthRecalc.ValueData,0)      AS SummHospOthRecalc
                      , COALESCE (MIFloat_SummChildRecalc.ValueData,0)        AS SummChildRecalc
                      , COALESCE (MIFloat_SummMinusExtRecalc.ValueData,0)     AS SummMinusExtRecalc
                      , COALESCE (MIFloat_SummAddOthRecalc.ValueData,0)       AS SummAddOthRecalc 
                      , COALESCE (MIFloat_SummCompensationRecalc.ValueData,0) AS SummCompensationRecalc
                      , COALESCE (MIFloat_SummAvanceRecalc.ValueData,0)       AS SummAvanceRecalc
                 FROM tmpMI_All AS tmpMI
                      LEFT JOIN tmpMIFloat AS MIFloat_SummCardRecalc
                                              ON MIFloat_SummCardRecalc.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
                      LEFT JOIN tmpMIFloat AS MIFloat_SummCardSecondRecalc
                                              ON MIFloat_SummCardSecondRecalc.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummCardSecondRecalc.DescId = zc_MIFloat_SummCardSecondRecalc()
                      LEFT JOIN tmpMIFloat AS MIFloat_SummNalogRecalc
                                              ON MIFloat_SummNalogRecalc.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummNalogRecalc.DescId = zc_MIFloat_SummNalogRecalc()
                      LEFT JOIN tmpMIFloat AS MIFloat_SummNalogRetRecalc
                                              ON MIFloat_SummNalogRetRecalc.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummNalogRetRecalc.DescId = zc_MIFloat_SummNalogRetRecalc()
                      LEFT JOIN tmpMIFloat AS MIFloat_SummFineOthRecalc
                                              ON MIFloat_SummFineOthRecalc.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummFineOthRecalc.DescId = zc_MIFloat_SummFineOthRecalc()
                      LEFT JOIN tmpMIFloat AS MIFloat_SummHospOthRecalc
                                              ON MIFloat_SummHospOthRecalc.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummHospOthRecalc.DescId = zc_MIFloat_SummHospOthRecalc()
                      LEFT JOIN tmpMIFloat AS MIFloat_SummChildRecalc
                                              ON MIFloat_SummChildRecalc.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummChildRecalc.DescId = zc_MIFloat_SummChildRecalc()
                      LEFT JOIN tmpMIFloat AS MIFloat_SummMinusExtRecalc
                                              ON MIFloat_SummMinusExtRecalc.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummMinusExtRecalc.DescId = zc_MIFloat_SummMinusExtRecalc()
                      LEFT JOIN tmpMIFloat AS MIFloat_SummAddOthRecalc
                                              ON MIFloat_SummAddOthRecalc.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummAddOthRecalc.DescId = zc_MIFloat_SummAddOthRecalc()
                      LEFT JOIN tmpMIFloat AS MIFloat_SummCompensationRecalc
                                              ON MIFloat_SummCompensationRecalc.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummCompensationRecalc.DescId = zc_MIFloat_SummCompensationRecalc()
                      LEFT JOIN tmpMIFloat AS MIFloat_SummAvanceRecalc
                                              ON MIFloat_SummAvanceRecalc.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummAvanceRecalc.DescId = zc_MIFloat_SummAvanceRecalc()
                 WHERE COALESCE (MIFloat_SummCardRecalc.ValueData,0)        <> 0
                    OR COALESCE (MIFloat_SummCardSecondRecalc.ValueData,0)  <> 0
                    OR COALESCE (MIFloat_SummNalogRecalc.ValueData,0)       <> 0
                    OR COALESCE (MIFloat_SummNalogRetRecalc.ValueData,0)    <> 0
                    OR COALESCE (MIFloat_SummFineOthRecalc.ValueData,0)     <> 0
                    OR COALESCE (MIFloat_SummHospOthRecalc.ValueData,0)     <> 0
                    OR COALESCE (MIFloat_SummChildRecalc.ValueData,0)       <> 0
                    OR COALESCE (MIFloat_SummMinusExtRecalc.ValueData,0)    <> 0
                    OR COALESCE (MIFloat_SummAddOthRecalc.ValueData,0)      <> 0
                    OR COALESCE (MIFloat_SummCompensationRecalc.ValueData,0)<> 0
                    OR COALESCE (MIFloat_SummAvanceRecalc.ValueData,0)      <> 0
                 )

     --выбираем все документы для тек.месяца начислений
     , tmpMovement_PS AS (SELECT MovementDate_ServiceDate.MovementId             AS Id
                               , MovementLinkObject_PersonalServiceList.ObjectId AS PersonalServiceListId
                          FROM MovementDate AS MovementDate_ServiceDate
                               JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                            AND Movement.DescId = zc_Movement_PersonalService()
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                            ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                                           AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                          WHERE MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', vbServiceDate) AND (DATE_TRUNC ('MONTH', vbServiceDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                            AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                          )
     -- все строки выбр. док
     , tmpMI_PS AS (SELECT Movement.Id                              AS MovementId
                         , Movement.PersonalServiceListId           AS PersonalServiceListId
                         , MovementItem.Id                          AS MovementItemId
                         , MovementItem.ObjectId                    AS PersonalId
                         , MILinkObject_Unit.ObjectId               AS UnitId
                         , MILinkObject_Position.ObjectId           AS PositionId
                         , MILinkObject_InfoMoney.ObjectId          AS InfoMoneyId
                         , MILinkObject_Member.ObjectId             AS MemberId
                         , ObjectLink_Personal_Member.ChildObjectId AS MemberId_Personal
                    FROM tmpMovement_PS AS Movement
                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId = zc_MI_Master()
                                                AND MovementItem.isErased = FALSE
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                          ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                          ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                          ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                                          ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                              ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                             AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                          ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()
                    )

     , tmpMIFloat_PS AS (SELECT MovementItemFloat.*
                         FROM MovementItemFloat
                         WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_PS.MovementItemId FROM tmpMI_PS)
                           AND MovementItemFloat.DescId IN (zc_MIFloat_SummCard()
                                                          , zc_MIFloat_SummAvance()
                                                          , zc_MIFloat_SummCompensation()
                                                          , zc_MIFloat_SummAddOth()
                                                          , zc_MIFloat_SummMinusExt()
                                                          , zc_MIFloat_SummChild()
                                                          , zc_MIFloat_SummHospOth()
                                                          , zc_MIFloat_SummFineOth()
                                                          , zc_MIFloat_SummNalogRet()
                                                          , zc_MIFloat_SummNalog()
                                                          , zc_MIFloat_SummCardSecond()
                                                          ) 
                        )
     
     , tmpMI_Data AS (SELECT tmpMI.*
                           , COALESCE (MIFloat_SummCard.ValueData,0)         AS SummCard
                           , COALESCE (MIFloat_SummCardSecond.ValueData,0)   AS SummCardSecond
                           , COALESCE (MIFloat_SummNalog.ValueData,0)        AS SummNalog
                           , COALESCE (MIFloat_SummNalogRet.ValueData,0)     AS SummNalogRet
                           , COALESCE (MIFloat_SummFineOth.ValueData,0)      AS SummFineOth
                           , COALESCE (MIFloat_SummHospOth.ValueData,0)      AS SummHospOth
                           , COALESCE (MIFloat_SummChild.ValueData,0)        AS SummChild
                           , COALESCE (MIFloat_SummMinusExt.ValueData,0)     AS SummMinusExt
                           , COALESCE (MIFloat_SummAddOth.ValueData,0)       AS SummAddOth 
                           , COALESCE (MIFloat_SummCompensation.ValueData,0) AS SummCompensation
                           , COALESCE (MIFloat_SummAvance.ValueData,0)       AS SummAvance                           
                      FROM tmpMI_PS AS tmpMI
                      LEFT JOIN tmpMIFloat_PS AS MIFloat_SummCard
                                              ON MIFloat_SummCard.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()
                      LEFT JOIN tmpMIFloat_PS AS MIFloat_SummCardSecond
                                              ON MIFloat_SummCardSecond.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummCardSecond.DescId = zc_MIFloat_SummCardSecond()
                      LEFT JOIN tmpMIFloat_PS AS MIFloat_SummNalog
                                              ON MIFloat_SummNalog.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummNalog.DescId = zc_MIFloat_SummNalog()
                      LEFT JOIN tmpMIFloat_PS AS MIFloat_SummNalogRet
                                              ON MIFloat_SummNalogRet.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummNalogRet.DescId = zc_MIFloat_SummNalogRet()
                      LEFT JOIN tmpMIFloat_PS AS MIFloat_SummFineOth
                                              ON MIFloat_SummFineOth.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummFineOth.DescId = zc_MIFloat_SummFineOth()
                      LEFT JOIN tmpMIFloat_PS AS MIFloat_SummHospOth
                                              ON MIFloat_SummHospOth.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummHospOth.DescId = zc_MIFloat_SummHospOth()
                      LEFT JOIN tmpMIFloat_PS AS MIFloat_SummChild
                                              ON MIFloat_SummChild.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()
                      LEFT JOIN tmpMIFloat_PS AS MIFloat_SummMinusExt
                                              ON MIFloat_SummMinusExt.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummMinusExt.DescId = zc_MIFloat_SummMinusExt()
                      LEFT JOIN tmpMIFloat_PS AS MIFloat_SummAddOth
                                              ON MIFloat_SummAddOth.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummAddOth.DescId = zc_MIFloat_SummAddOth()
                      LEFT JOIN tmpMIFloat_PS AS MIFloat_SummCompensation
                                              ON MIFloat_SummCompensation.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummCompensation.DescId = zc_MIFloat_SummCompensation()
                      LEFT JOIN tmpMIFloat_PS AS MIFloat_SummAvance
                                              ON MIFloat_SummAvance.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_SummAvance.DescId = zc_MIFloat_SummAvance()
                      WHERE COALESCE (MIFloat_SummCard.ValueData,0)        <> 0
                         OR COALESCE (MIFloat_SummCardSecond.ValueData,0)  <> 0
                         OR COALESCE (MIFloat_SummNalog.ValueData,0)       <> 0
                         OR COALESCE (MIFloat_SummNalogRet.ValueData,0)    <> 0
                         OR COALESCE (MIFloat_SummFineOth.ValueData,0)     <> 0
                         OR COALESCE (MIFloat_SummHospOth.ValueData,0)     <> 0
                         OR COALESCE (MIFloat_SummChild.ValueData,0)       <> 0
                         OR COALESCE (MIFloat_SummMinusExt.ValueData,0)    <> 0
                         OR COALESCE (MIFloat_SummAddOth.ValueData,0)      <> 0
                         OR COALESCE (MIFloat_SummCompensation.ValueData,0)<> 0
                         OR COALESCE (MIFloat_SummAvance.ValueData,0)      <> 0                           
                      )



       -- Результат
       SELECT Movement.Id AS MovementId
            , Movement.InvNumber
            , Movement.OperDate
            , Object_PersonalServiceList.Id           AS PersonalServiceListId
            , Object_PersonalServiceList.ValueData    AS PersonalServiceListName       

            , Object_Personal.Id                      AS PersonalId
            , Object_Personal.ObjectCode              AS PersonalCode
            , Object_Personal.ValueData               AS PersonalName
            , tmpMI.MemberId_Personal
            , ObjectString_Member_INN.ValueData       AS INN
            , ObjectString_Code1C.ValueData           AS Code1C
            , COALESCE (ObjectBoolean_Personal_Main.ValueData, FALSE)   :: Boolean AS isMain
            , COALESCE (ObjectBoolean_Member_Official.ValueData, FALSE) :: Boolean AS isOfficial
              -- дата увольнения
            , CASE WHEN COALESCE (ObjectDate_Personal_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_Personal_DateOut.ValueData END ::TDateTime AS DateOut
             -- дата приема на работу - только если мес начислений соотв месяцу приема
            , CASE WHEN DATE_TRUNC ('Month', ObjectDate_DateIn.ValueData) = DATE_TRUNC ('Month', vbServiceDate) THEN ObjectDate_DateIn.ValueData ELSE NULL END ::TDateTime AS DateIn

            , Object_Unit.Id                          AS UnitId
            , Object_Unit.ObjectCode                  AS UnitCode
            , Object_Unit.ValueData                   AS UnitName
            , Object_Position.Id                      AS PositionId
            , Object_Position.ValueData               AS PositionName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
            , View_InfoMoney.InfoMoneyName_all
            
            , COALESCE (Object_Member.Id, 0)                   AS MemberId
            , COALESCE (Object_Member.ValueData, ''::TVarChar) AS MemberName

            , COALESCE (Object_PersonalServiceList_mi.Id, 0)                   AS PersonalServiceListId_mi
            , COALESCE (Object_PersonalServiceList_mi.ValueData, ''::TVarChar) AS PersonalServiceListName_mi

            , COALESCE (Object_FineSubject.Id, 0)             :: Integer  AS FineSubjectId
            , COALESCE (Object_FineSubject.ValueData, '')     :: TVarChar AS FineSubjectName

            , COALESCE (Object_UnitFineSubject.Id, 0)         :: Integer  AS UnitFineSubjectId
            , COALESCE (Object_UnitFineSubject.ValueData, '') :: TVarChar AS UnitFineSubjectName
            
            --
            , COALESCE (tmpMI.SummCardRecalc,0)       ::TFloat  AS SummCardRecalc       
            , COALESCE (tmpMI.SummCardSecondRecalc,0) ::TFloat  AS SummCardSecondRecalc 
            , COALESCE (tmpMI.SummNalogRecalc,0)      ::TFloat  AS SummNalogRecalc    
            , COALESCE (tmpMI.SummNalogRetRecalc,0)   ::TFloat  AS SummNalogRetRecalc    
            , COALESCE (tmpMI.SummFineOthRecalc,0)    ::TFloat  AS SummFineOthRecalc   
            , COALESCE (tmpMI.SummHospOthRecalc,0)    ::TFloat  AS SummHospOthRecalc      
            , COALESCE (tmpMI.SummChildRecalc,0)      ::TFloat  AS SummChildRecalc 
            , COALESCE (tmpMI.SummMinusExtRecalc,0)   ::TFloat  AS SummMinusExtRecalc    
            , COALESCE (tmpMI.SummAddOthRecalc,0)      ::TFloat AS SummAddOthRecalc      
            , COALESCE (tmpMI.SummCompensationRecalc,0)::TFloat AS SummCompensationRecalc   
            , COALESCE (tmpMI.SummAvanceRecalc,0)      ::TFloat AS SummAvanceRecalc
            ---
            , COALESCE (tmpMI_Data.SummCard,0)        ::TFloat  AS SummCard
            , COALESCE (tmpMI_Data.SummCardSecond,0)  ::TFloat  AS SummCardSecond
            , COALESCE (tmpMI_Data.SummNalog,0)       ::TFloat  AS SummNalog
            , COALESCE (tmpMI_Data.SummNalogRet,0)    ::TFloat  AS SummNalogRet
            , COALESCE (tmpMI_Data.SummFineOth,0)     ::TFloat  AS SummFineOth
            , COALESCE (tmpMI_Data.SummHospOth,0)     ::TFloat  AS SummHospOth
            , COALESCE (tmpMI_Data.SummChild,0)       ::TFloat  AS SummChild
            , COALESCE (tmpMI_Data.SummMinusExt,0)    ::TFloat  AS SummMinusExt
            , COALESCE (tmpMI_Data.SummAddOth,0)      ::TFloat  AS SummAddOth 
            , COALESCE (tmpMI_Data.SummCompensation,0)::TFloat  AS SummCompensation
            , COALESCE (tmpMI_Data.SummAvance,0)      ::TFloat  AS SummAvance


/*            , COALESCE (MIBoolean_isAuto.ValueData, FALSE)    :: Boolean   AS isAuto
            , COALESCE (ObjectBoolean_BankOut.ValueData, FALSE) :: Boolean   AS isBankOut
            , MIDate_BankOut.ValueData                          :: TDateTime AS BankOutDate
            , COALESCE (MIDate_BankOut.ValueData, vbOperDate)   :: TDateTime AS BankOutDate_export 
            */
       FROM tmpMI
            LEFT JOIN tmpMI_Data ON tmpMI_Data.UnitId = tmpMI.UnitId
                                AND tmpMI_Data.PersonalId = tmpMI.PersonalId
                                AND tmpMI_Data.PositionId = tmpMI.PositionId 
                                AND tmpMI_Data.InfoMoneyId = tmpMI.InfoMoneyId
                                --AND tmpMI_Data.MemberId = tmpMI.MemberId

            LEFT JOIN Movement ON Movement.Id = tmpMI_Data.MovementId
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = tmpMI_Data.PersonalServiceListId
            
            LEFT JOIN ObjectString AS ObjectString_Code1C
                                   ON ObjectString_Code1C.ObjectId = tmpMI.PersonalId
                                  AND ObjectString_Code1C.DescId    = zc_ObjectString_Personal_Code1C()

            LEFT JOIN MovementItemBoolean AS MIBoolean_Main
                                          ON MIBoolean_Main.MovementItemId = tmpMI_Data.MovementItemId
                                         AND MIBoolean_Main.DescId = zc_MIBoolean_Main()

            LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                          ON MIBoolean_isAuto.MovementItemId = tmpMI_Data.MovementItemId
                                         AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpMI_Data.PersonalId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI_Data.UnitId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpMI_Data.PositionId
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMI_Data.MemberId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpMI_Data.InfoMoneyId
            LEFT JOIN Object AS Object_PersonalServiceList_mi ON Object_PersonalServiceList_mi.Id = tmpMI_Data.PersonalServiceListId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                    ON ObjectBoolean_Personal_Main.ObjectId = tmpMI_Data.PersonalId
                                   AND ObjectBoolean_Personal_Main.DescId = zc_ObjectBoolean_Personal_Main()
            LEFT JOIN ObjectDate AS ObjectDate_Personal_DateOut
                                 ON ObjectDate_Personal_DateOut.ObjectId = tmpMI_Data.PersonalId
                                AND ObjectDate_Personal_DateOut.DescId = zc_ObjectDate_Personal_Out()

            LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                 ON ObjectDate_DateIn.ObjectId = tmpMI_Data.PersonalId
                                AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()

            LEFT JOIN ObjectString AS ObjectString_Member_INN
                                   ON ObjectString_Member_INN.ObjectId = tmpMI_Data.MemberId_Personal
                                  AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Member_Official
                                    ON ObjectBoolean_Member_Official.ObjectId = tmpMI_Data.MemberId_Personal
                                   AND ObjectBoolean_Member_Official.DescId = zc_ObjectBoolean_Member_Official()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_FineSubject
                                             ON MILinkObject_FineSubject.MovementItemId = tmpMI_Data.MovementItemId
                                            AND MILinkObject_FineSubject.DescId = zc_MILinkObject_FineSubject()
            LEFT JOIN Object AS Object_FineSubject ON Object_FineSubject.Id = MILinkObject_FineSubject.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_UnitFineSubject
                                             ON MILinkObject_UnitFineSubject.MovementItemId = tmpMI_Data.MovementItemId
                                            AND MILinkObject_UnitFineSubject.DescId = zc_MILinkObject_UnitFineSubject()
            LEFT JOIN Object AS Object_UnitFineSubject ON Object_UnitFineSubject.Id = MILinkObject_UnitFineSubject.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                 ON ObjectLink_Personal_PositionLevel.ObjectId = tmpMI_Data.PersonalId
                                AND ObjectLink_Personal_PositionLevel.DescId   = zc_ObjectLink_Personal_PositionLevel()

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.03.23         *
*/

-- тест
--SELECT * FROM gpReport_PersonalService_Recalc (inMovementId:= 24691665, inSession:= '9457')
--select * from gpReport_PersonalService_Recalc(inMovementId := 24750747 ,  inSession := '9457');