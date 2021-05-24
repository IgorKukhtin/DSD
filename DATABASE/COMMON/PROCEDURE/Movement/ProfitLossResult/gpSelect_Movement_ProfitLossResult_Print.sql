-- Function: gpSelect_Movement_ProfitLossResult_Print()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossResult_Print (Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossResult_Print (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossResult_Print (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProfitLossResult_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inMovementId_Weighing        Integer  , -- ключ Документа взвешивания
    IN inisItem                     Boolean  , -- не сворачивать по MovementItem да / нет
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbIsProductionOut Boolean;
    DECLARE vbIsInventory Boolean;
    DECLARE vbIsWeighing Boolean;

    DECLARE vbStoreKeeperName TVarChar;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- расчет, временно захардкодил - только если Обвалка
     vbIsWeighing:= EXISTS (SELECT 1
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = inMovementId AND MLO_From.DescId = zc_MovementLinkObject_From()
                                 INNER JOIN lfSelect_Object_Unit_byGroup (8439) AS lfSelectFrom ON lfSelectFrom.UnitId = MLO_From.ObjectId -- Участок мясного сырья
                                 INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = inMovementId AND MLO_To.DescId = zc_MovementLinkObject_To()
                                 INNER JOIN lfSelect_Object_Unit_byGroup (8439) AS lfSelectTo ON lfSelectTo.UnitId = MLO_To.ObjectId -- Участок мясного сырья
                            WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_ProductionUnion()
                           );
     -- расчет, временно захардкодил
     vbIsProductionOut:= (EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To() AND ObjectId IN (8447, 8448, 8449)) -- ЦЕХ колбасный + ЦЕХ деликатесов + ЦЕХ с/к
                       OR (EXISTS (SELECT 1 FROM MovementBoolean WHERE MovementId = inMovementId_Weighing AND DescId = zc_MovementBoolean_isIncome() AND ValueData = FALSE)
                           AND vbIsWeighing = TRUE)
                       OR (EXISTS (SELECT 1 FROM MovementLinkObject AS MLO_DocumentKind WHERE MLO_DocumentKind.MovementId = inMovementId AND MLO_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind() AND MLO_DocumentKind.ObjectId = zc_Enum_DocumentKind_PackDiff()))
                         )
                     AND EXISTS (SELECT Id FROM Movement WHERE Id = inMovementId AND DescId = zc_Movement_ProductionUnion());
     -- расчет, временно захардкодил
     vbIsInventory:= EXISTS (SELECT Id FROM Movement WHERE Id = inMovementId AND DescId = zc_Movement_Inventory());


     -- параметры из Взвешивания
     vbStoreKeeperName:= (SELECT Object_User.ValueData
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                            ON MovementLinkObject_User.MovementId = Movement.Id
                                                           AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                               LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
                          WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          LIMIT 1
                         );


    OPEN Cursor1 FOR
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , Object_Account.Id                  AS AccountId
           , Object_Account.ValueData           AS AccountName
           , MovementFloat_TotalSumm.ValueData  AS TotalSumm
           , MovementString_Comment.ValueData   AS Comment
           , COALESCE(MovementBoolean_isCorrective.ValueData, False) :: Boolean  AS isCorrective

       FROM tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementBoolean AS MovementBoolean_isCorrective
                                      ON MovementBoolean_isCorrective.MovementId = Movement.Id
                                     AND MovementBoolean_isCorrective.DescId = zc_MovementBoolean_isCorrective()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Account
                                         ON MovementLinkObject_Account.MovementId = Movement.Id
                                        AND MovementLinkObject_Account.DescId = zc_MovementLinkObject_Account()
            LEFT JOIN Object AS Object_Account ON Object_Account.Id = MovementLinkObject_Account.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_ProfitLossResult()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    WITH
    tmpMI AS (SELECT MovementItem.Id                    AS MovementItemId
                   , MovementItem.ObjectId              AS AccountId
                   , MovementItem.Amount                AS Amount
                   , COALESCE (MIFloat_ContainerId.ValueData, 0) AS ContainerId
              FROM MovementItem
                   LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                               ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                              AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE
                AND MovementItem.Amount <> 0
             )

       --результат
       SELECT
             tmpMI.MovementItemId      AS Id
           , Object_Account.Id         AS AccountId
           , Object_Account.ObjectCode AS AccountCode
           , Object_Account.ValueData  AS AccountName
           , tmpMI.Amount       ::TFloat
           , tmpMI.ContainerId  ::TFloat
       FROM tmpMI
            LEFT JOIN Object AS Object_Account ON Object_Account.Id = tmpMI.AccountId
       ;


    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.03.21         *
*/

-- SELECT * FROM gpSelect_Movement_ProfitLossResult_Print (inMovementId := 570596, inMovementId_Weighing:= 0 , inisItem:=true, inSession:= '5');
