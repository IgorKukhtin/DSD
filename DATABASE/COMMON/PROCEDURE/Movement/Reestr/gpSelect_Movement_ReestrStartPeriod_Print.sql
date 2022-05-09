-- Function: gpselect_movement_reestrstartperiod_print(tdatetime, tdatetime, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpSelect_Movement_ReestrStartPeriod_Print (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ReestrStartPeriod_Print (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReestrStartPeriod_Print(
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inPersonalId          Integer   ,
    IN inPersonalTradeId     Integer   ,
    IN inReestrKindId        Integer   ,
    IN inIsReestrKind        Boolean   ,
    IN inisShowAll           Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbDescId Integer;

   DECLARE vbMemberId      Integer;
   DECLARE vbMemberTradeId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Reestr());
     vbUserId:= lpGetUserBySession (inSession);


     -- Определяется
     vbMemberId     := COALESCE ((SELECT ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inPersonalId      AND OL.DescId = zc_ObjectLink_Personal_Member()), 0);
     vbMemberTradeId:= COALESCE ((SELECT ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inPersonalTradeId AND OL.DescId = zc_ObjectLink_Personal_Member()), 0);

     -- переопределим значение для вывезено со склада; в форме start нет єтого параметра, в др.формах есть
     IF COALESCE (inReestrKindId, 0 ) = 0
        THEN inReestrKindId := zc_Enum_ReestrKind_PartnerOut();
     END IF;
     
     -- Результат
     OPEN Cursor1 FOR
    
       SELECT inStartDate AS StartDate
            , inEndDate   AS EndDate
            , Object_ReestrKind.ValueData AS ReestrKindName
            , Object_User.ValueData       AS UserName
       FROM Object AS Object_ReestrKind
            LEFT JOIN Object AS Object_User ON Object_User.Id = vbUserId
       WHERE Object_ReestrKind.Id = zc_Enum_ReestrKind_PartnerOut();

    RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
       WITH 
               -- выбираем строки реестров по выбранной визе
               tmpMI AS (SELECT MovementItem.Id            AS MovementItemId
                              , MovementItem.ObjectId      AS MemberId
                              , MovementFloat_MovementItemId.MovementId AS MovementId_Sale
                         FROM Movement
                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                           LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                   ON MovementFloat_MovementItemId.ValueData ::integer = MovementItem.Id
                                                  AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                           
                           INNER JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                                         ON MovementLinkObject_ReestrKind.MovementId = MovementFloat_MovementItemId.MovementId
                                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
                                                        AND MovementLinkObject_ReestrKind.ObjectId = zc_Enum_ReestrKind_PartnerOut()  -- ВЫвезено со склада
      
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = MovementFloat_MovementItemId.MovementId
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         WHERE Movement.DescId = zc_Movement_Reestr() 
                           AND (((Movement.OperDate BETWEEN inStartDate AND inEndDate) AND (inisShowAll = False)) OR (inisShowAll = True))  
                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                         )
   
       SELECT 
             Movement_Sale.InvNumber                AS InvNumber_Sale
           , Movement_Sale.OperDate                 AS OperDate_Sale
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
           , Object_To.ValueData                    AS ToName
           
           , CASE WHEN Object_Personal.Id <> Object_PersonalTrade.Id -- AND Object_Personal.Id > 0 AND Object_PersonalTrade.Id > 0
                       THEN Object_Personal.ValueData || ' / ' || Object_PersonalTrade.ValueData
                  WHEN Object_Personal.Id IS NULL AND Object_PersonalTrade.Id > 0
                       THEN ' / ' || Object_PersonalTrade.ValueData
                  ELSE Object_Personal.ValueData
             END                        :: TVarChar AS PersonalName
           , Object_PersonalTrade.ValueData         AS PersonalTradeName
           , CASE WHEN Object_Personal.Id <> 0 
                  THEN Object_Personal.ValueData
                  ELSE Object_Personal.ValueData
             END                        :: TVarChar AS PersonalName_Group

           , Object_ReestrKind.ValueData    	    AS ReestrKindName
           , Object_PaidKind.ValueData              AS PaidKindName 

           , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
           , MovementFloat_TotalSumm.ValueData              AS TotalSumm

           , Movement_TransportGoods.InvNumber              AS InvNumber_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, NULL) ::TDateTime  AS OperDate_TransportGoods
           , COALESCE (MIDate_Log.ValueData, NULL) ::TDateTime            AS Date_Log
           , COALESCE (MIDate_Insert.ValueData, NULL) ::TDateTime         AS Date_Insert
           , COALESCE (MIDate_PartnerIn.ValueData, NULL) ::TDateTime      AS Date_PartnerIn
           , COALESCE (MIDate_RemakeIn.ValueData, NULL) ::TDateTime       AS Date_RemakeIn
           , COALESCE (MIDate_RemakeBuh.ValueData, NULL) ::TDateTime      AS Date_RemakeBuh
           , COALESCE (MIDate_Remake.ValueData, NULL) ::TDateTime         AS Date_Remake
           , COALESCE (MIDate_Econom.ValueData, NULL) ::TDateTime         AS Date_Econom
           , COALESCE (MIDate_Buh.ValueData, NULL) ::TDateTime            AS Date_Buh
           , COALESCE (MIDate_Double.ValueData, NULL) ::TDateTime         AS Date_Double
           , COALESCE (MIDate_Scan.ValueData, NULL) ::TDateTime           AS Date_Scan

           , CASE WHEN MIDate_Insert.DescId IS NOT NULL THEN Object_ObjectMember.ValueData ELSE '' END :: TVarChar AS Member_Insert -- т.к. в "пустышках" - "криво" формируется это свойство
           , Object_Log.ValueData            AS Member_Log
           , Object_PartnerInTo.ValueData    AS Member_PartnerInTo
           , Object_PartnerInFrom.ValueData  AS Member_PartnerInFrom
           , Object_RemakeInTo.ValueData     AS Member_RemakeInTo
           , Object_RemakeInFrom.ValueData   AS Member_RemakeInFrom
           , Object_RemakeBuh.ValueData      AS Member_RemakeBuh
           , Object_Remake.ValueData         AS Member_Remake
           , Object_Econom.ValueData         AS Member_Econom
           , Object_Buh.ValueData            AS Member_Buh
           , Object_Double.ValueData         AS Member_Double
           , Object_Scan.ValueData           AS Member_Scan
          
       FROM tmpMI
            LEFT JOIN Object AS Object_ObjectMember ON Object_ObjectMember.Id = tmpMI.MemberId

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_PartnerIn
                                       ON MIDate_PartnerIn.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_PartnerIn.DescId = zc_MIDate_PartnerIn()
            LEFT JOIN MovementItemDate AS MIDate_RemakeIn
                                       ON MIDate_RemakeIn.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_RemakeIn.DescId = zc_MIDate_RemakeIn()
            LEFT JOIN MovementItemDate AS MIDate_RemakeBuh
                                       ON MIDate_RemakeBuh.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_RemakeBuh.DescId = zc_MIDate_RemakeBuh()
            LEFT JOIN MovementItemDate AS MIDate_Remake
                                       ON MIDate_Remake.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Remake.DescId = zc_MIDate_Remake()
            LEFT JOIN MovementItemDate AS MIDate_Econom
                                       ON MIDate_Econom.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Econom.DescId = zc_MIDate_Econom()
            LEFT JOIN MovementItemDate AS MIDate_Buh
                                       ON MIDate_Buh.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Buh.DescId = zc_MIDate_Buh()
            LEFT JOIN MovementItemDate AS MIDate_Log
                                       ON MIDate_Log.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Log.DescId = zc_MIDate_Log()

            LEFT JOIN MovementItemDate AS MIDate_Double
                                       ON MIDate_Double.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Double.DescId = zc_MIDate_Double()
            LEFT JOIN MovementItemDate AS MIDate_Scan
                                       ON MIDate_Scan.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Scan.DescId = zc_MIDate_Scan()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartnerInTo
                                             ON MILinkObject_PartnerInTo.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_PartnerInTo.DescId = zc_MILinkObject_PartnerInTo()
            LEFT JOIN Object AS Object_PartnerInTo ON Object_PartnerInTo.Id = MILinkObject_PartnerInTo.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartnerInFrom
                                             ON MILinkObject_PartnerInFrom.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_PartnerInFrom.DescId = zc_MILinkObject_PartnerInFrom()
            LEFT JOIN Object AS Object_PartnerInFrom ON Object_PartnerInFrom.Id = MILinkObject_PartnerInFrom.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_RemakeInTo
                                             ON MILinkObject_RemakeInTo.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_RemakeInTo.DescId = zc_MILinkObject_RemakeInTo()
            LEFT JOIN Object AS Object_RemakeInTo ON Object_RemakeInTo.Id = MILinkObject_RemakeInTo.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_RemakeInFrom
                                             ON MILinkObject_RemakeInFrom.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_RemakeInFrom.DescId = zc_MILinkObject_RemakeInFrom()
            LEFT JOIN Object AS Object_RemakeInFrom ON Object_RemakeInFrom.Id = MILinkObject_RemakeInFrom.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_RemakeBuh
                                             ON MILinkObject_RemakeBuh.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_RemakeBuh.DescId = zc_MILinkObject_RemakeBuh()
            LEFT JOIN Object AS Object_RemakeBuh ON Object_RemakeBuh.Id = MILinkObject_RemakeBuh.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Remake
                                             ON MILinkObject_Remake.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_Remake.DescId = zc_MILinkObject_Remake()
            LEFT JOIN Object AS Object_Remake ON Object_Remake.Id = MILinkObject_Remake.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Econom
                                             ON MILinkObject_Econom.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_Econom.DescId = zc_MILinkObject_Econom()
            LEFT JOIN Object AS Object_Econom ON Object_Econom.Id = MILinkObject_Econom.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Buh
                                             ON MILinkObject_Buh.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_Buh.DescId = zc_MILinkObject_Buh()
            LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = MILinkObject_Buh.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Log
                                             ON MILinkObject_Log.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_Log.DescId = zc_MILinkObject_Log()
            LEFT JOIN Object AS Object_Log ON Object_Log.Id = MILinkObject_Log.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Double
                                             ON MILinkObject_Double.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_Double.DescId = zc_MILinkObject_Double()
            LEFT JOIN Object AS Object_Double ON Object_Double.Id = MILinkObject_Double.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Scan
                                             ON MILinkObject_Scan.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_Scan.DescId = zc_MILinkObject_Scan()
            LEFT JOIN Object AS Object_Scan ON Object_Scan.Id = MILinkObject_Scan.ObjectId

            --
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.id = tmpMI.MovementId_Sale

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_Sale.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement_Sale.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId = Movement_Sale.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_Sale.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                 ON ObjectLink_Partner_Personal.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Partner_Personal.ChildObjectId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ChildObjectId -- ObjectLink_Partner_Personal.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
            LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Member
                                 ON ObjectLink_PersonalTrade_Member.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                                AND ObjectLink_PersonalTrade_Member.DescId = zc_ObjectLink_Personal_Member()
            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_PersonalTrade_Member.ChildObjectId -- ObjectLink_Partner_PersonalTrade.ChildObjectId

       WHERE ((inIsReestrKind = TRUE AND MovementLinkObject_ReestrKind.ObjectId = inReestrKindId) 
          OR inIsReestrKind = FALSE
             )
    --   AND (Object_Personal.Id      = inPersonalId      OR inPersonalId      = 0)
    --   AND (Object_PersonalTrade.Id = inPersonalTradeId OR inPersonalTradeId = 0)
         AND (Object_Personal.Id      = vbMemberId        OR vbMemberId        = 0)
         AND (Object_PersonalTrade.Id = vbMemberTradeId   OR vbMemberTradeId   = 0)
         
       ORDER BY Object_To.ValueData
              , MovementDate_OperDatePartner.ValueData
;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.05.22         *
 22.07.20         *
 06.12.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReestrStartPeriod_Print(inStartDate := ('26.12.2016')::TDateTime , inEndDate := ('31.12.2016')::TDateTime , inPersonalId := 0 ,  inPersonalTradeId := 0, inReestrKindId := 640043  , inIsReestrKind := 'False' , inIsShowAll := 'True' ,  inSession := '5'); --FETCH ALL "<unnamed portal 37>";
