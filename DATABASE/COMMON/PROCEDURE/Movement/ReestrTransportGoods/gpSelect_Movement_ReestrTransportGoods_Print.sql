-- Function: gpSelect_Movement_Reestr()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReestrTransportGoods_Print (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReestrTransportGoods_Print(
    IN inMovementId        Integer   ,
    IN inPersonalId        Integer   DEFAULT 0,
    IN inPersonalTradeId   Integer   DEFAULT 0,
    IN inSession           TVarChar  DEFAULT ''  -- сессия пользователя
)
RETURNS SETOF refcursor
AS
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

     -- Определяется
     SELECT Movement.DescId, Movement.StatusId 
            INTO vbDescId, vbStatusId
     FROM Movement WHERE Movement.Id = inMovementId;

     -- Результат
     OPEN Cursor1 FOR
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
      
           , Object_Insert.ValueData           AS InsertName
           , MovementDate_Insert.ValueData     AS InsertDate
           , MovementDate_Update.ValueData     AS UpdateDate
       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  
    WHERE Movement.Id = inMovementId
      AND Movement.DescId = zc_Movement_ReestrTransportGoods()
     ;
    RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
      WITH 
       -- выбираем строки текущего реестра
       tmpMI_Main AS (SELECT MovementItem.Id                AS MovementItemId
                           , MovementItem.ObjectId          AS MemberId
                           , MovementFloat_MovementItemId.MovementId AS MovementId_TransportGoods
                           , MovementLinkObject_To.ObjectId            AS ToId
                           , 1 AS GroupNum
                      FROM MovementItem
                           LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                   ON MovementFloat_MovementItemId.ValueData ::integer = MovementItem.Id
                                                  AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()

                           LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                                          ON MovementLinkMovement_TransportGoods.MovementChildId = MovementFloat_MovementItemId.MovementId
                                                         AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()

                           LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_TransportGoods.MovementId
                                                              AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                      )

         -- клиенты реестра
         , tmpFrom AS (SELECT DISTINCT tmpMI_Main.ToId  
                       FROM tmpMI_Main
                     )
         -- выбираем строки из других реестров, по клиентам текущего реестра
         , tmpMIList AS (SELECT MovementItem.Id         AS MovementItemId
                           , MovementItem.ObjectId      AS MemberId
                           , MovementFloat_MovementItemId.MovementId AS MovementId_TransportGoods
                           , CASE WHEN MovementLinkObject_ReestrKind.ObjectId = zc_Enum_ReestrKind_PartnerOut() THEN 2 ELSE 3 END AS GroupNum
                         FROM  Movement
                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                           LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                   ON MovementFloat_MovementItemId.ValueData ::integer = MovementItem.Id
                                                  AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                           
                           INNER JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                                         ON MovementLinkObject_ReestrKind.MovementId = MovementFloat_MovementItemId.MovementId
                                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
                                                        AND MovementLinkObject_ReestrKind.ObjectId IN (zc_Enum_ReestrKind_PartnerOut(), zc_Enum_ReestrKind_Remake())
      
                           LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                                          ON MovementLinkMovement_TransportGoods.MovementChildId = MovementFloat_MovementItemId.MovementId
                                                         AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()

                           LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_TransportGoods.MovementId
                                                              AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                           INNER JOIN tmpFrom ON tmpFrom.ToId  = MovementLinkObject_To.ObjectId

                         WHERE Movement.DescId = zc_Movement_ReestrTransportGoods()
                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                           AND Movement.Id <> inMovementId
                         )
         -- все нужные строки реестров
         , tmpMI AS (SELECT tmpMI_Main.MovementItemId
                          , tmpMI_Main.MemberId
                          , tmpMI_Main.MovementId_TransportGoods
                          , tmpMI_Main.GroupNum
                     FROM tmpMI_Main
                   UNION 
                     SELECT tmpMIList.MovementItemId
                          , tmpMIList.MemberId
                          , tmpMIList.MovementId_TransportGoods
                          , tmpMIList.GroupNum
                     FROM tmpMIList
                     )
  
         , tmpMILO AS (SELECT MovementItemLinkObject.*
                       FROM MovementItemLinkObject
                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                         AND MovementItemLinkObject.DescId IN (zc_MILinkObject_PartnerInTo()
                                                             , zc_MILinkObject_RemakeInTo()
                                                             , zc_MILinkObject_RemakeInFrom()
                                                             , zc_MILinkObject_RemakeBuh()
                                                             , zc_MILinkObject_Remake()
                                                             , zc_MILinkObject_Buh()
                                                             , zc_MILinkObject_Log()
                                                             )
                       )

         , tmpMIDate AS (SELECT MovementItemDate.*
                         FROM MovementItemDate
                         WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                           AND MovementItemDate.DescId IN (zc_MIDate_Insert()
                                                         , zc_MIDate_PartnerIn()
                                                         , zc_MIDate_RemakeIn()
                                                         , zc_MIDate_RemakeBuh()
                                                         , zc_MIDate_Remake()
                                                         , zc_MIDate_Buh()
                                                         , zc_MIDate_Log()
                                                         )
                       )

       ---
       SELECT 
             Movement_TransportGoods.InvNumber      AS InvNumber
           , Movement_TransportGoods.OperDate       AS OperDate
           , COALESCE (MovementDate_OperDatePartner.ValueData,Movement_TransportGoods.OperDate) ::TDateTime AS OperDatePartner
           , Object_To.ValueData                    AS ToName

           , CASE WHEN Object_Personal.Id <> Object_PersonalTrade.Id
                  THEN Object_Personal.ValueData || ' / ' || Object_PersonalTrade.ValueData
                  WHEN Object_Personal.Id IS NULL AND Object_PersonalTrade.Id > 0
                       THEN ' / ' || Object_PersonalTrade.ValueData
                  ELSE Object_Personal.ValueData
             END                        :: TVarChar AS PersonalName
           , Object_PersonalTrade.ValueData         AS PersonalTradeName
           , CASE WHEN Object_Personal.Id <> 0 
                  THEN Object_Personal.ValueData
                  ELSE Object_PersonalTrade.ValueData
             END                        :: TVarChar AS PersonalName_Group

           , Object_ReestrKind.ValueData    	    AS ReestrKindName
           , Object_PaidKind.ValueData              AS PaidKindName

           , MovementFloat_TotalCountKg.ValueData   AS TotalCountKg
           , MovementFloat_TotalSumm.ValueData      AS TotalSumm

           , COALESCE (MIDate_Insert.ValueData, NULL) ::TDateTime         AS Date_Insert
           , COALESCE (MIDate_Log.ValueData, NULL) ::TDateTime            AS Date_Log
           , COALESCE (MIDate_PartnerIn.ValueData, NULL) ::TDateTime      AS Date_PartnerIn
           , COALESCE (MIDate_RemakeIn.ValueData, NULL) ::TDateTime       AS Date_RemakeIn
           , COALESCE (MIDate_RemakeBuh.ValueData, NULL) ::TDateTime      AS Date_RemakeBuh
           , COALESCE (MIDate_Remake.ValueData, NULL) ::TDateTime         AS Date_Remake
           , COALESCE (MIDate_Buh.ValueData, NULL) ::TDateTime            AS Date_Buh

           , CASE WHEN MIDate_Insert.DescId IS NOT NULL THEN Object_ObjectMember.ValueData ELSE '' END :: TVarChar AS Member_Insert -- т.к. в "пустышках" - "криво" формируется это свойство

           , Object_Log.ValueData            AS Member_Log
           , Object_PartnerInTo.ValueData    AS Member_PartnerInTo
           , Object_RemakeInTo.ValueData     AS Member_RemakeInTo
           , Object_RemakeInFrom.ValueData   AS Member_RemakeInFrom
           , Object_RemakeBuh.ValueData      AS Member_RemakeBuh
           , Object_Remake.ValueData         AS Member_Remake
           , Object_Buh.ValueData            AS Member_Buh
           , tmpMI.GroupNum

       FROM tmpMI
            LEFT JOIN Object AS Object_ObjectMember ON Object_ObjectMember.Id = tmpMI.MemberId

            LEFT JOIN tmpMIDate AS MIDate_Insert
                                ON MIDate_Insert.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN tmpMIDate AS MIDate_PartnerIn
                                ON MIDate_PartnerIn.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_PartnerIn.DescId = zc_MIDate_PartnerIn()
            LEFT JOIN tmpMIDate AS MIDate_Buh
                                ON MIDate_Buh.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Buh.DescId = zc_MIDate_Buh()
            LEFT JOIN tmpMIDate AS MIDate_Log
                                ON MIDate_Log.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Log.DescId = zc_MIDate_Log()

            LEFT JOIN tmpMIDate AS MIDate_RemakeIn
                                ON MIDate_RemakeIn.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_RemakeIn.DescId = zc_MIDate_RemakeIn()
            LEFT JOIN tmpMIDate AS MIDate_RemakeBuh
                                ON MIDate_RemakeBuh.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_RemakeBuh.DescId = zc_MIDate_RemakeBuh()
            LEFT JOIN tmpMIDate AS MIDate_Remake
                                ON MIDate_Remake.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Remake.DescId = zc_MIDate_Remake()

            LEFT JOIN tmpMILO AS MILinkObject_PartnerInTo
                              ON MILinkObject_PartnerInTo.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_PartnerInTo.DescId = zc_MILinkObject_PartnerInTo()
            LEFT JOIN Object AS Object_PartnerInTo ON Object_PartnerInTo.Id = MILinkObject_PartnerInTo.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_RemakeInTo
                              ON MILinkObject_RemakeInTo.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_RemakeInTo.DescId = zc_MILinkObject_RemakeInTo()
            LEFT JOIN Object AS Object_RemakeInTo ON Object_RemakeInTo.Id = MILinkObject_RemakeInTo.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_RemakeInFrom
                              ON MILinkObject_RemakeInFrom.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_RemakeInFrom.DescId = zc_MILinkObject_RemakeInFrom()
            LEFT JOIN Object AS Object_RemakeInFrom ON Object_RemakeInFrom.Id = MILinkObject_RemakeInFrom.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_RemakeBuh
                              ON MILinkObject_RemakeBuh.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_RemakeBuh.DescId = zc_MILinkObject_RemakeBuh()
            LEFT JOIN Object AS Object_RemakeBuh ON Object_RemakeBuh.Id = MILinkObject_RemakeBuh.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Remake
                              ON MILinkObject_Remake.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_Remake.DescId = zc_MILinkObject_Remake()
            LEFT JOIN Object AS Object_Remake ON Object_Remake.Id = MILinkObject_Remake.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Buh
                              ON MILinkObject_Buh.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_Buh.DescId = zc_MILinkObject_Buh()
            LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = MILinkObject_Buh.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Log
                              ON MILinkObject_Log.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_Log.DescId = zc_MILinkObject_Log()
            LEFT JOIN Object AS Object_Log ON Object_Log.Id = MILinkObject_Log.ObjectId
            --
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.id = tmpMI.MovementId_TransportGoods

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_TransportGoods.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement_TransportGoods.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementChildId = Movement_TransportGoods.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()

            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_TransportGoods.MovementId
                                               AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

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

       WHERE (Object_Personal.Id      = vbMemberId        OR vbMemberId        = 0)
         AND (Object_PersonalTrade.Id = vbMemberTradeId   OR vbMemberTradeId   = 0)

       ORDER BY tmpMI.GroupNum
              , Object_To.ValueData
              , MovementDate_OperDatePartner.ValueData
;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.20         * add Object_Log
 31.01.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReestrTransportGoods_Print (inMovementId:= 1, inPersonalId := 0 , inPersonalTradeId := 0, inSession:= zfCalc_UserAdmin())

--select * from gpSelect_Movement_ReestrTransportGoods_Print(inMovementId := 15887801 , inPersonalId := 0 , inPersonalTradeId := 0 ,  inSession := '5');
