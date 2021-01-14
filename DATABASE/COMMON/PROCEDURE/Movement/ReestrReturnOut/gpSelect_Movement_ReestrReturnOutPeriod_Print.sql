-- Function: gpSelect_Movement_ReestrReturnOut()


DROP FUNCTION IF EXISTS gpSelect_Movement_ReestrReturnOutPeriod_Print (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReestrReturnOutPeriod_Print(
    IN inStartDate           TDateTime ,
    IN inEndDate             TDateTime ,
    IN inReestrKindId        Integer   ,
    IN inPersonalId          Integer   ,
    IN inPersonalTradeId     Integer   ,
    IN inIsReestrKind        Boolean   ,    
    IN inisShowAll           Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbDescId Integer;

   DECLARE vbMemberId_User  Integer;
   DECLARE vbDateDescId     Integer;
   DECLARE vbMILinkObjectId Integer;

   DECLARE vbMemberId      Integer;
   DECLARE vbMemberTradeId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ReestrReturnOut());
     vbUserId:= lpGetUserBySession (inSession);


     -- Определяется
     vbMemberId     := COALESCE ((SELECT ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inPersonalId      AND OL.DescId = zc_ObjectLink_Personal_Member()), 0);
     vbMemberTradeId:= COALESCE ((SELECT ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inPersonalTradeId AND OL.DescId = zc_ObjectLink_Personal_Member()), 0);

  /*  -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
        RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;
*/

     -- Определяется
     vbDateDescId := (SELECT CASE WHEN inReestrKindId = zc_Enum_ReestrKind_EconomIn()  THEN zc_MIDate_EconomIn()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_EconomOut() THEN zc_MIDate_EconomOut()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_Snab()      THEN zc_MIDate_Snab()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_SnabRe()    THEN zc_MIDate_SnabRe()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_Remake()    THEN zc_MIDate_Remake()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_Econom()    THEN zc_MIDate_Econom()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_Buh()       THEN zc_MIDate_Buh()
                             END AS DateDescId
                      );
     -- Определяется
     vbMILinkObjectId := (SELECT CASE WHEN inReestrKindId = zc_Enum_ReestrKind_EconomIn()  THEN zc_MILinkObject_EconomIn()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_EconomOut() THEN zc_MILinkObject_EconomOut()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_Snab()      THEN zc_MILinkObject_Snab()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_SnabRe()    THEN zc_MILinkObject_SnabRe()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_Remake()    THEN zc_MILinkObject_Remake()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_Econom()    THEN zc_MILinkObject_Econom()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_Buh()       THEN zc_MILinkObject_Buh()
                                 END AS MILinkObjectId
                      );

     -- Определяется <Физическое лицо> - кто сформировал визу inReestrKindId
     vbMemberId_User:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;

     -- Результат - 1
     OPEN Cursor1 FOR

       SELECT inStartDate AS StartDate
            , inEndDate   AS EndDate
            , Object_ReestrKind.ValueData AS ReestrKindName
            , Object_User.ValueData       AS UserName
            , CASE WHEN inReestrKindId = zc_Enum_ReestrKind_RemakeBuh() THEN TRUE ELSE FALSE END isRemakeBuh
       FROM Object AS Object_ReestrKind
            LEFT JOIN Object AS Object_User ON Object_User.Id = vbUserId
       WHERE Object_ReestrKind.Id = inReestrKindId;

     RETURN NEXT Cursor1;


     -- Результат - 2
     OPEN Cursor2 FOR
       WITH
       -- выбираем строки реестров по выбранной визе и пользователю (или всем пользователям)
       tmpMI AS (SELECT MIDate.MovementItemId
                        , MILinkObject.ObjectId AS MemberId
                        , MovementFloat_MovementItemId.MovementId AS MovementId_ReturnOut
                   FROM MovementItemDate AS MIDate
                        INNER JOIN MovementItemLinkObject AS MILinkObject
                                                          ON MILinkObject.MovementItemId = MIDate.MovementItemId
                                                         AND MILinkObject.DescId = vbMILinkObjectId
                                                         AND (MILinkObject.ObjectId = vbMemberId_User OR inisShowAll = True)
                        LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                ON MovementFloat_MovementItemId.ValueData = MIDate.MovementItemId
                                               AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                               
                   WHERE MIDate.DescId = vbDateDescId
                     AND MIDate.ValueData >= inStartDate AND MIDate.ValueData < inEndDate + INTERVAL '1 DAY'
                   )

     , tmpMovementFloat_ReturnOut AS (SELECT MovementFloat.*
                                   FROM MovementFloat
                                   WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMI.MovementId_ReturnOut FROM tmpMI)
                                     AND MovementFloat.DescId IN (zc_MovementFloat_TotalCountPartner()
                                                                , zc_MovementFloat_TotalSumm())
                                   )

     , tmpMIDate AS (SELECT MovementItemDate.*
                     FROM MovementItemDate
                     WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                       AND MovementItemDate.DescId IN (zc_MIDate_Insert()
                                                     , zc_MIDate_EconomIn()
                                                     , zc_MIDate_EconomOut()
                                                     , zc_MIDate_Snab()
                                                     , zc_MIDate_SnabRe()
                                                     , zc_MIDate_Remake()
                                                     , zc_MIDate_Buh()
                                                     , zc_MIDate_Econom())
                   )

     , tmpMILO AS (SELECT MovementItemLinkObject.*
                   FROM MovementItemLinkObject
                   WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                     AND MovementItemLinkObject.DescId IN (zc_MILinkObject_EconomIn()
                                                         , zc_MILinkObject_EconomOut()
                                                         , zc_MILinkObject_Snab()
                                                         , zc_MILinkObject_SnabRe()
                                                         , zc_MILinkObject_Remake()
                                                         , zc_MILinkObject_Buh()
                                                         , zc_MILinkObject_Econom())
                   )

     , tmpData AS
      (SELECT
             Movement_ReturnOut.InvNumber                AS InvNumber_ReturnOut
           , Movement_ReturnOut.OperDate                 AS OperDate_ReturnOut
           , MovementDate_OperDatePartner.ValueData   AS OperDatePartner
           , Object_From.ValueData                    AS FromName
           , CASE WHEN Object_Personal.Id <> Object_PersonalTrade.Id -- AND Object_Personal.Id > 0 AND Object_PersonalTrade.Id > 0
                       THEN Object_Personal.ValueData || ' / ' || Object_PersonalTrade.ValueData
                  WHEN Object_Personal.Id IS NULL AND Object_PersonalTrade.Id > 0
                       THEN ' / ' || Object_PersonalTrade.ValueData
                  ELSE Object_Personal.ValueData
             END                        :: TVarChar AS PersonalName
           , Object_Personal.Id                     AS PersonalId
           , Object_PersonalTrade.Id                AS PersonalTradeId
           , Object_PersonalTrade.ValueData         AS PersonalTradeName
           , CASE WHEN Object_Personal.Id <> 0 
                  THEN Object_Personal.ValueData
                  ELSE Object_Personal.ValueData
             END                        :: TVarChar AS PersonalName_Group
             
           , Object_ReestrKind.ValueData    	    AS ReestrKindName
           , Object_PaidKind.ValueData              AS PaidKindName

           , MovementFloat_TotalCountPartner.ValueData           AS TotalCountPartner
           , MovementFloat_TotalSumm.ValueData              AS TotalSumm

           , Movement_TransportGoods.InvNumber              AS InvNumber_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, NULL) ::TDateTime  AS OperDate_TransportGoods
           , COALESCE (MIDate_Insert.ValueData, NULL) ::TDateTime         AS Date_Insert
           , COALESCE (MIDate_Snab.ValueData, NULL) ::TDateTime           AS Date_Snab
           , COALESCE (MIDate_SnabRe.ValueData, NULL) ::TDateTime         AS Date_SnabRe
           , COALESCE (MIDate_EconomIn.ValueData, NULL) ::TDateTime       AS Date_EconomIn
           , COALESCE (MIDate_EconomOut.ValueData, NULL) ::TDateTime      AS Date_EconomOut
           , COALESCE (MIDate_Remake.ValueData, NULL) ::TDateTime         AS Date_Remake
           , COALESCE (MIDate_Econom.ValueData, NULL) ::TDateTime         AS Date_Econom
           , COALESCE (MIDate_Buh.ValueData, NULL) ::TDateTime            AS Date_Buh

           , CASE WHEN MIDate_Insert.DescId IS NOT NULL THEN Object_ObjectMember.ValueData ELSE '' END :: TVarChar AS Member_Insert -- т.к. в "пустышках" - "криво" формируется это свойство
           , Object_Snab.ValueData          AS Member_Snab
           , Object_SnabRe.ValueData        AS Member_SnabRe
           , Object_EconomIn.ValueData      AS Member_EconomIn
           , Object_EconomOut.ValueData     AS Member_EconomOut
           , Object_Remake.ValueData         AS Member_Remake
           , Object_Econom.ValueData         AS Member_Econom
           , Object_Buh.ValueData            AS Member_Buh

       FROM tmpMI
            LEFT JOIN Object AS Object_ObjectMember ON Object_ObjectMember.Id = tmpMI.MemberId

            LEFT JOIN tmpMIDate AS MIDate_Insert
                                ON MIDate_Insert.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN tmpMIDate AS MIDate_Remake
                                ON MIDate_Remake.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Remake.DescId = zc_MIDate_Remake()
            LEFT JOIN tmpMIDate AS MIDate_Econom
                                ON MIDate_Econom.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Econom.DescId = zc_MIDate_Econom()
            LEFT JOIN tmpMIDate AS MIDate_Buh
                                ON MIDate_Buh.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Buh.DescId = zc_MIDate_Buh()
            LEFT JOIN tmpMIDate AS MIDate_Snab
                                ON MIDate_Snab.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Snab.DescId = zc_MIDate_Snab()
            LEFT JOIN tmpMIDate AS MIDate_SnabRe
                                ON MIDate_SnabRe.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_SnabRe.DescId = zc_MIDate_SnabRe()
            LEFT JOIN tmpMIDate AS MIDate_EconomIn
                                ON MIDate_EconomIn.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_EconomIn.DescId = zc_MIDate_EconomIn()
            LEFT JOIN tmpMIDate AS MIDate_EconomOut
                                ON MIDate_EconomOut.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_EconomOut.DescId = zc_MIDate_EconomOut()

            LEFT JOIN tmpMILO AS MILinkObject_EconomIn
                              ON MILinkObject_EconomIn.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_EconomIn.DescId = zc_MILinkObject_EconomIn()
            LEFT JOIN Object AS Object_EconomIn ON Object_EconomIn.Id = MILinkObject_EconomIn.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_EconomOut
                              ON MILinkObject_EconomOut.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_EconomOut.DescId = zc_MILinkObject_EconomOut()
            LEFT JOIN Object AS Object_EconomOut ON Object_EconomOut.Id = MILinkObject_EconomOut.ObjectId     

            LEFT JOIN tmpMILO AS MILinkObject_Snab
                              ON MILinkObject_Snab.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_Snab.DescId = zc_MILinkObject_Snab()
            LEFT JOIN Object AS Object_Snab ON Object_Snab.Id = MILinkObject_Snab.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_SnabRe
                              ON MILinkObject_SnabRe.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_SnabRe.DescId = zc_MILinkObject_SnabRe()
            LEFT JOIN Object AS Object_SnabRe ON Object_SnabRe.Id = MILinkObject_SnabRe.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Remake
                              ON MILinkObject_Remake.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_Remake.DescId = zc_MILinkObject_Remake()
            LEFT JOIN Object AS Object_Remake ON Object_Remake.Id = MILinkObject_Remake.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Econom
                              ON MILinkObject_Econom.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_Econom.DescId = zc_MILinkObject_Econom()
            LEFT JOIN Object AS Object_Econom ON Object_Econom.Id = MILinkObject_Econom.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Buh
                              ON MILinkObject_Buh.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_Buh.DescId = zc_MILinkObject_Buh()
            LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = MILinkObject_Buh.ObjectId
            --
            LEFT JOIN Movement AS Movement_ReturnOut ON Movement_ReturnOut.id = tmpMI.MovementId_ReturnOut

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_ReturnOut.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement_ReturnOut.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            LEFT JOIN tmpMovementFloat_ReturnOut AS MovementFloat_TotalCountPartner
                                              ON MovementFloat_TotalCountPartner.MovementId = Movement_ReturnOut.Id
                                             AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()

            LEFT JOIN tmpMovementFloat_ReturnOut AS MovementFloat_TotalSumm
                                              ON MovementFloat_TotalSumm.MovementId = Movement_ReturnOut.Id
                                             AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId 

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                 ON ObjectLink_Partner_Personal.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Partner_Personal.ChildObjectId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ChildObjectId -- ObjectLink_Partner_Personal.ChildObjectId -- AND Object_Personal.DescId = zc_Object_Personal()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
            LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Member
                                 ON ObjectLink_PersonalTrade_Member.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                                AND ObjectLink_PersonalTrade_Member.DescId = zc_ObjectLink_Personal_Member()
            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_PersonalTrade_Member.ChildObjectId -- ObjectLink_Partner_PersonalTrade.ChildObjectId

       WHERE (inIsReestrKind = TRUE AND MovementLinkObject_ReestrKind.ObjectId = inReestrKindId) 
           OR inIsReestrKind = FALSE
      )


      SELECT *
      FROM tmpData
      WHERE (tmpData.PersonalId      = vbMemberId        OR vbMemberId      = 0)
        AND (tmpData.PersonalTradeId = vbMemberTradeId   OR vbMemberTradeId = 0)
      ORDER BY tmpData.FromName
             , tmpData.OperDatePartner
      ;

     RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReestrReturnOutPeriod_Print(inStartDate := ('26.12.2016')::TDateTime , inEndDate := ('31.12.2016')::TDateTime , inReestrKindId := 640043 , inPersonalId := 0 , inPersonalTradeId := 0 , inIsReestrKind := 'False' , inIsShowAll := 'True' ,  inSession := '5'); --FETCH ALL "<unnamed portal 37>";
