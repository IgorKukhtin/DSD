-- Function: gpSelect_Movement_ReestrReturnOut()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReestrReturnOut_Print (Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ReestrReturnOut_Print (Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReestrReturnOut_Print(
    IN inMovementId        Integer   ,
    IN inPersonalId        Integer   DEFAULT 0,
    IN inPersonalTradeId   Integer   DEFAULT 0,
    IN inReestrKindId      Integer   DEFAULT 0,
    IN inIsReestrKind      Boolean   DEFAULT FALSE,
    IN inisShowAll         Boolean   DEFAULT FALSE,
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

   DECLARE vbMemberId_User  Integer;
   DECLARE vbMILinkObjectId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ReestrReturnOut());
     vbUserId:= lpGetUserBySession (inSession);


     -- Определяется
     vbMemberId     := COALESCE ((SELECT ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inPersonalId      AND OL.DescId = zc_ObjectLink_Personal_Member()), 0);
     vbMemberTradeId:= COALESCE ((SELECT ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inPersonalTradeId AND OL.DescId = zc_ObjectLink_Personal_Member()), 0);

     -- Определяется <Физическое лицо> - кто сформировал визу inReestrKindId
     vbMemberId_User:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
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

     -- Определяется
     SELECT Movement.DescId, Movement.StatusId
            INTO vbDescId, vbStatusId
     FROM Movement WHERE Movement.Id = inMovementId;

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

     -- переопределим значение для вывезено со склада; в форме start нет єтого параметра, в др.формах есть
     IF COALESCE (inReestrKindId, 0 ) = 0
        THEN inReestrKindId := zc_Enum_ReestrKind_PartnerOut();
     END IF;
     
     -- Результат
     OPEN Cursor1 FOR


       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate

           , Object_Update.ValueData           AS UpdateName
           , MovementDate_Update.ValueData     AS UpdateDate

           , Object_Car.ValueData              AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , View_PersonalDriver.PersonalName  AS PersonalDriverName
           , Object_Member.ValueData           AS MemberName

           , Movement_Transport.InvNumber      AS InvNumber_Transport
           , Movement_Transport.OperDate       AS OperDate_Transport

       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                 ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId
    WHERE Movement.Id = inMovementId
      AND Movement.DescId = zc_Movement_ReestrReturnOut()
     ;
    RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
      WITH
       -- выбираем строки текущего реестра
       tmpMI_Main AS (SELECT MovementItem.Id                AS MovementItemId
                           , MovementItem.ObjectId          AS MemberId
                           , MovementFloat_MovementItemId.MovementId AS MovementId_ReturnOut
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
         , tmpFrom AS (SELECT tmpFrom.FromId
                       FROM  (SELECT DISTINCT tmpMI_Main.FromId
                              FROM tmpMI_Main
                              ) AS tmpFrom
                       )

         -- выбираем строки из других реестров, по клиентам текущего реестра
         , tmpMIList AS (SELECT MovementItem.Id         AS MovementItemId
                           , MovementItem.ObjectId      AS MemberId
                           , MovementFloat_MovementItemId.MovementId AS MovementId_ReturnOut
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

                         WHERE Movement.DescId = zc_Movement_ReestrReturnOut() AND Movement.StatusId <> zc_Enum_Status_Erased()
                           AND Movement.Id <> inMovementId
                           AND (inPersonalId <> 0 OR inPersonalTradeId <> 0 OR (inReestrKindId <> 0 AND inIsReestrKind = TRUE))
                         )
         -- все нужные строки реестров
        , tmpMI AS (SELECT tmpMI_Main.MovementItemId
                         , tmpMI_Main.MemberId
                         , tmpMI_Main.MovementId_ReturnOut
                         , tmpMI_Main.GroupNum
                    FROM tmpMI_Main
                  UNION
                    SELECT tmpMIList.MovementItemId
                         , tmpMIList.MemberId
                         , tmpMIList.MovementId_ReturnOut
                         , tmpMIList.GroupNum
                    FROM tmpMIList
                    )

        , tmpMovementDate_OperDatePartner AS (SELECT MovementDate.*
                                              FROM MovementDate
                                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMI.MovementId_ReturnOut FROM tmpMI)
                                                AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                                              )
        , tmpMovementFloat_ReturnOut AS (SELECT MovementFloat.*
                                    FROM MovementFloat
                                    WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMI.MovementId_ReturnOut FROM tmpMI)
                                      AND MovementFloat.DescId IN (zc_MovementFloat_TotalCountPartner()
                                                                 , zc_MovementFloat_TotalSumm())
                                    )

        , tmpMLO_ReturnOut AS (SELECT MovementLinkObject.*
                          FROM MovementLinkObject
                          WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMI.MovementId_ReturnOut FROM tmpMI)
                            AND MovementLinkObject.DescId IN (zc_MovementLinkObject_ReestrKind()
                                                            , zc_MovementLinkObject_From()
                                                            , zc_MovementLinkObject_PaidKind() )
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
                                      

       SELECT
             Movement_ReturnOut.InvNumber                AS InvNumber_ReturnOut
           , Movement_ReturnOut.OperDate                 AS OperDate_ReturnOut
           , MovementDate_OperDatePartner.ValueData   AS OperDatePartner
           , Object_From.ValueData                    AS FromName
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

           , MovementFloat_TotalCountPartner.ValueData AS TotalCountPartner
           , MovementFloat_TotalSumm.ValueData         AS TotalSumm

           , Movement_TransportGoods.InvNumber      AS InvNumber_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, NULL) ::TDateTime  AS OperDate_TransportGoods
           , COALESCE (MIDate_Insert.ValueData, NULL) ::TDateTime         AS Date_Insert
           , COALESCE (MIDate_EconomIn.ValueData, NULL) ::TDateTime       AS Date_EconomIn
           , COALESCE (MIDate_EconomOut.ValueData, NULL) ::TDateTime      AS Date_EconomOut
           , COALESCE (MIDate_Snab.ValueData, NULL) ::TDateTime           AS Date_Snab
           , COALESCE (MIDate_SnabRe.ValueData, NULL) ::TDateTime         AS Date_SnabRe
           , COALESCE (MIDate_Remake.ValueData, NULL) ::TDateTime         AS Date_Remake
           , COALESCE (MIDate_Econom.ValueData, NULL) ::TDateTime         AS Date_Econom
           , COALESCE (MIDate_Buh.ValueData, NULL) ::TDateTime            AS Date_Buh

           , CASE WHEN MIDate_Insert.DescId IS NOT NULL THEN Object_ObjectMember.ValueData ELSE '' END :: TVarChar AS Member_Insert -- т.к. в "пустышках" - "криво" формируется это свойство
           , Object_EconomIn.ValueData       AS Member_EconomIn
           , Object_EconomOut.ValueData      AS Member_EconomOut
           , Object_Snab.ValueData           AS Member_Snab
           , Object_SnabRe.ValueData         AS Member_SnabRe
           , Object_Remake.ValueData         AS Member_Remake
           , Object_Econom.ValueData         AS Member_Econom
           , Object_Buh.ValueData            AS Member_Buh
           , tmpMI.GroupNum
           , MovementString_Comment.ValueData       AS Comment_Order

       FROM tmpMI
            LEFT JOIN Object AS Object_ObjectMember ON Object_ObjectMember.Id = tmpMI.MemberId

            LEFT JOIN tmpMIDate AS MIDate_Insert
                                ON MIDate_Insert.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Insert.DescId = zc_MIDate_Insert()
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
            LEFT JOIN tmpMIDate AS MIDate_Remake
                                ON MIDate_Remake.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Remake.DescId = zc_MIDate_Remake()
            LEFT JOIN tmpMIDate AS MIDate_Buh
                                ON MIDate_Buh.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Buh.DescId = zc_MIDate_Buh()
            LEFT JOIN tmpMIDate AS MIDate_Econom
                                ON MIDate_Econom.MovementItemId = tmpMI.MovementItemId
                               AND MIDate_Econom.DescId = zc_MIDate_Econom()

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

            --
            LEFT JOIN Movement AS Movement_ReturnOut ON Movement_ReturnOut.id = tmpMI.MovementId_ReturnOut

            LEFT JOIN tmpMovementDate_OperDatePartner AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.MovementId = Movement_ReturnOut.Id
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN tmpMLO_ReturnOut AS MovementLinkObject_ReestrKind
                                    ON MovementLinkObject_ReestrKind.MovementId = Movement_ReturnOut.Id
                                   AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
                                 --AND ((inIsReestrKind = TRUE AND MovementLinkObject_ReestrKind.ObjectId = inReestrKindId) OR inIsReestrKind = FALSE)
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN tmpMLO_ReturnOut AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = Movement_ReturnOut.Id
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement_ReturnOut.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement_ReturnOut.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            -- примечание из заявки
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = MovementLinkMovement_Order.MovementChildId   --- заявка
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMovementFloat_ReturnOut AS MovementFloat_TotalCountPartner
                                              ON MovementFloat_TotalCountPartner.MovementId = Movement_ReturnOut.Id
                                             AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()

            LEFT JOIN tmpMovementFloat_ReturnOut AS MovementFloat_TotalSumm
                                              ON MovementFloat_TotalSumm.MovementId = Movement_ReturnOut.Id
                                             AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN tmpMLO_ReturnOut AS MovementLinkObject_PaidKind
                                    ON MovementLinkObject_PaidKind.MovementId = Movement_ReturnOut.Id
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

            LEFT JOIN tmpMILO ON tmpMILO.MovementItemId = tmpMI.MovementItemId
                             AND tmpMILO.DescId = vbMILinkObjectId 

       WHERE ((inIsReestrKind = TRUE AND MovementLinkObject_ReestrKind.ObjectId = inReestrKindId) 
          OR inIsReestrKind = FALSE
             )
         AND (Object_Personal.Id      = vbMemberId        OR vbMemberId        = 0)
         AND (Object_PersonalTrade.Id = vbMemberTradeId   OR vbMemberTradeId   = 0)

         AND (tmpMILO.ObjectId = vbMemberId_User OR inisShowAll = True) -- по текущему пользователю или по всем
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReestrReturnOut_Print(inMovementId := 4887960 , inPersonalId := 0 , inPersonalTradeId := 0 , inReestrKindId := 0 , inIsReestrKind := 'False' ,  inSession := '5');
