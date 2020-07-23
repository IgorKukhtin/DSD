-- Function: gpSelect_Movement_Reestr()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReestrReturn_Print (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ReestrReturn_Print (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReestrReturn_Print(
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

     -- переопределим значение для вывезено со склада; в форме start нет єтого параметра, в др.формах есть
     /*IF COALESCE (inReestrKindId, 0 ) = 0
        THEN inReestrKindId := zc_Enum_ReestrKind_PartnerOut();
     END IF;
*/
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
      AND Movement.DescId = zc_Movement_ReestrReturn()
     ;
    RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
      WITH 
       -- выбираем строки текущего реестра
       tmpMI_Main AS (SELECT MovementItem.Id                AS MovementItemId
                           , MovementItem.ObjectId          AS MemberId
                           , MovementFloat_MovementItemId.MovementId AS MovementId_ReturnIn
                           , MovementLinkObject_From.ObjectId AS FromId
                           , 1 AS GroupNum
                      FROM MovementItem
                           LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                   ON MovementFloat_MovementItemId.ValueData ::integer = MovementItem.Id
                                                  AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = MovementFloat_MovementItemId.MovementId
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                      )

         -- клиенты реестра
         , tmpFrom AS (SELECT DISTINCT tmpMI_Main.FromId  
                       FROM tmpMI_Main
                     )
         -- выбираем строки из других реестров, по клиентам текущего реестра
         , tmpMIList AS (SELECT MovementItem.Id         AS MovementItemId
                           , MovementItem.ObjectId      AS MemberId
                           , MovementFloat_MovementItemId.MovementId AS MovementId_ReturnIn
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
      
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = MovementFloat_MovementItemId.MovementId
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                           INNER JOIN tmpFrom ON tmpFrom.FromId  = MovementLinkObject_From.ObjectId

                         WHERE Movement.DescId = zc_Movement_ReestrReturn() AND Movement.StatusId <> zc_Enum_Status_Erased()
                           AND Movement.Id <> inMovementId
                         )
         -- все нужные строки реестров
        , tmpMI AS (SELECT tmpMI_Main.MovementItemId
                         , tmpMI_Main.MemberId
                         , tmpMI_Main.MovementId_ReturnIn
                         , tmpMI_Main.GroupNum
                    FROM tmpMI_Main
                  UNION 
                    SELECT tmpMIList.MovementItemId
                         , tmpMIList.MemberId
                         , tmpMIList.MovementId_ReturnIn
                         , tmpMIList.GroupNum
                    FROM tmpMIList
                    )
  
       SELECT 
             Movement_ReturnIn.InvNumber            AS InvNumber_ReturnIn
           , Movement_ReturnIn.OperDate             AS OperDate_ReturnIn
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
           , Object_From.ValueData                  AS FromName

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
           , COALESCE (MIDate_RemakeBuh.ValueData, NULL) ::TDateTime      AS Date_RemakeBuh
           , COALESCE (MIDate_Econom.ValueData, NULL) ::TDateTime         AS Date_Econom
           , COALESCE (MIDate_Buh.ValueData, NULL) ::TDateTime            AS Date_Buh

           , CASE WHEN MIDate_Insert.DescId IS NOT NULL THEN Object_ObjectMember.ValueData ELSE '' END :: TVarChar AS Member_Insert -- т.к. в "пустышках" - "криво" формируется это свойство

           , Object_RemakeBuh.ValueData      AS Member_RemakeBuh
           , Object_Econom.ValueData         AS Member_Econom
           , Object_Buh.ValueData            AS Member_Buh
           , tmpMI.GroupNum

       FROM tmpMI
            LEFT JOIN Object AS Object_ObjectMember ON Object_ObjectMember.Id = tmpMI.MemberId

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_RemakeBuh
                                       ON MIDate_RemakeBuh.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_RemakeBuh.DescId = zc_MIDate_RemakeBuh()
            LEFT JOIN MovementItemDate AS MIDate_Econom
                                       ON MIDate_Econom.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Econom.DescId = zc_MIDate_Econom()
            LEFT JOIN MovementItemDate AS MIDate_Buh
                                       ON MIDate_Buh.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Buh.DescId = zc_MIDate_Buh()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_RemakeBuh
                                             ON MILinkObject_RemakeBuh.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_RemakeBuh.DescId = zc_MILinkObject_RemakeBuh()
            LEFT JOIN Object AS Object_RemakeBuh ON Object_RemakeBuh.Id = MILinkObject_RemakeBuh.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Econom
                                             ON MILinkObject_Econom.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_Econom.DescId = zc_MILinkObject_Econom()
            LEFT JOIN Object AS Object_Econom ON Object_Econom.Id = MILinkObject_Econom.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Buh
                                             ON MILinkObject_Buh.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_Buh.DescId = zc_MILinkObject_Buh()
            LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = MILinkObject_Buh.ObjectId

            --
            LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.id = tmpMI.MovementId_ReturnIn

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_ReturnIn.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                 ON ObjectLink_Partner_Personal.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Partner_Personal.ChildObjectId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ChildObjectId -- ObjectLink_Partner_Personal.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
            LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Member
                                 ON ObjectLink_PersonalTrade_Member.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                                AND ObjectLink_PersonalTrade_Member.DescId = zc_ObjectLink_Personal_Member()
            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_PersonalTrade_Member.ChildObjectId -- ObjectLink_Partner_PersonalTrade.ChildObjectId

    -- WHERE (Object_Personal.Id      = inPersonalId      OR inPersonalId      = 0)
    --   AND (Object_PersonalTrade.Id = inPersonalTradeId OR inPersonalTradeId = 0)
       WHERE (Object_Personal.Id      = vbMemberId        OR vbMemberId        = 0)
         AND (Object_PersonalTrade.Id = vbMemberTradeId   OR vbMemberTradeId   = 0)

       ORDER BY tmpMI.GroupNum
              , Object_From.ValueData
              , MovementDate_OperDatePartner.ValueData
;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.07.20         *
 01.02.18         *
 12.03.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReestrReturn_Print (inMovementId:= 1, inPersonalId := 0 , inPersonalTradeId := 0, inSession:= zfCalc_UserAdmin())
