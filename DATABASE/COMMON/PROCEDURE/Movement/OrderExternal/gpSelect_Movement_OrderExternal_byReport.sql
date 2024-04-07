-- Function: gpSelect_Movement_OrderExternal_byReport()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal_byReport (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderExternal_byReport(
    IN inOperDate                TDateTime , -- Дата документа
    IN inOperDatePartner         TDateTime , -- Дата отгрузки со склада
    IN inToId                    Integer   , -- Кому (в документе)
    IN inRouteId                 Integer   , -- Маршрут
    IN inRetailId                Integer   , -- торг. сеть
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, OperDatePartner_Sale TDateTime, OperDateMark TDateTime, OperDate_CarInfo TDateTime
             , InvNumberPartner TVarChar, InvNumber_calc TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , RouteId Integer, RouteName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , RetailId Integer, RetailName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagId Integer, ContractTagName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat, TotalCountSecond TFloat
             , JuridicalId Integer, JuridicalName TVarChar
             , isEDI Boolean
             , Comment TVarChar
             , DayOfWeekName          TVarChar
             , DayOfWeekName_Partner  TVarChar
             , DayOfWeekName_CarInfo  TVarChar
             , isRemains Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     RETURN QUERY
     WITH tmpMovement AS (SELECT Movement.*
                               , MovementLinkObject_To.ObjectId             AS ToId
                               , MovementLinkObject_From.ObjectId           AS FromId
                               , MovementLinkObject_Route.ObjectId          AS RouteId
                               , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
                               , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
                               , COALESCE (MovementBoolean_Remains.ValueData, FALSE)  AS isRemains
                          FROM Movement
                              INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                     AND MovementDate_OperDatePartner.ValueData = inOperDatePartner

                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                           AND COALESCE (MovementLinkObject_To.ObjectId,0) = inToId

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                           ON MovementLinkObject_Route.MovementId = Movement.Id
                                                          AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                              LEFT JOIN MovementBoolean AS MovementBoolean_Remains
                                                        ON MovementBoolean_Remains.MovementId = Movement.Id
                                                       AND MovementBoolean_Remains.DescId = zc_MovementBoolean_Remains()

                              LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                   ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                  AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                          WHERE Movement.OperDate = inOperDate
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND Movement.DescId = zc_Movement_OrderExternal()
                            AND (inRetailId = CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, Object_From.Id) END
                              OR COALESCE (inRetailId, 0) = 0
                                )
                            AND COALESCE (MovementLinkObject_Route.ObjectId, 0) = inRouteId
                         )

        , tmpMovementFloat AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId IN (zc_MovementFloat_TotalCount()
                                                            , zc_MovementFloat_VATPercent()
                                                            , zc_MovementFloat_ChangePercent()
                                                            , zc_MovementFloat_TotalCountSh()
                                                            , zc_MovementFloat_TotalCountKg()
                                                            , zc_MovementFloat_TotalCountSecond()
                                                            , zc_MovementFloat_TotalSummMVAT()
                                                            , zc_MovementFloat_TotalSummPVAT()
                                                            , zc_MovementFloat_TotalSumm()
                                                            )
                              )

        , tmpMovementString AS (SELECT MovementString.*
                                FROM MovementString
                                WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementString.DescId IN (zc_MovementString_InvNumberPartner()
                                                              , zc_MovementString_Comment()
                                                              )
                              )
        , tmpMovementDate AS (SELECT MovementDate.*
                              FROM MovementDate
                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementDate.DescId IN (/*zc_MovementDate_OperDatePartner()
                                                          , */zc_MovementDate_OperDateMark()
                                                          , zc_MovementDate_CarInfo()
                                                            )
                            )

        , tmpMovementLinkMovement AS (SELECT MovementLinkMovement.*
                                      FROM MovementLinkMovement
                                      WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                        AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Order())
                                    )

        , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                                    FROM MovementLinkObject
                                    WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                      AND MovementLinkObject.DescId IN (/*zc_MovementLinkObject_From()
                                                                      , zc_MovementLinkObject_To()
                                                                      , */
                                                                        zc_MovementLinkObject_Personal()
                                                                      --, zc_MovementLinkObject_Route()
                                                                      , zc_MovementLinkObject_RouteSorting()
                                                                      , zc_MovementLinkObject_PaidKind()
                                                                      , zc_MovementLinkObject_Contract()
                                                                      , zc_MovementLinkObject_PriceList()
                                                                      )
                                  )

        , tmpMovementBoolean AS (SELECT MovementBoolean.*
                                 FROM MovementBoolean
                                 WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementBoolean.DescId IN (zc_MovementBoolean_PriceWithVAT())
                               )

        , tmpContract_InvNumber_View AS (SELECT View_Contract_InvNumber.*
                                         FROM Object_Contract_InvNumber_View AS View_Contract_InvNumber
                                         WHERE View_Contract_InvNumber.ContractId IN (SELECT DISTINCT tmpMovementLinkObject.ObjectId FROM tmpMovementLinkObject WHERE tmpMovementLinkObject.DescId = zc_MovementLinkObject_Contract())
                                         )
        , tmpInfoMoney_View AS (SELECT View_InfoMoney.*
                                FROM Object_InfoMoney_View AS View_InfoMoney
                                WHERE View_InfoMoney.InfoMoneyId IN (SELECT DISTINCT tmpContract_InvNumber_View.InfoMoneyId FROM tmpContract_InvNumber_View)
                                )

       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName
           --, MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , Movement.OperDatePartner
           --, (MovementDate_OperDatePartner.ValueData + (COALESCE (ObjectFloat_Partner_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner_Sale
           , (Movement.OperDatePartner + (COALESCE (ObjectFloat_Partner_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner_Sale
           , MovementDate_OperDateMark.ValueData            AS OperDateMark
           , MovementDate_CarInfo.ValueData                 AS OperDate_CarInfo
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
           , CASE WHEN MovementString_InvNumberPartner.ValueData <> '' THEN MovementString_InvNumberPartner.ValueData ELSE '***' || Movement.InvNumber END :: TVarChar AS InvNumber_calc

           , Object_From.Id                                 AS FromId
           , Object_From.ValueData                          AS FromName
           , Object_To.Id                                   AS ToId
           , Object_To.ValueData                            AS ToName
           , Object_Personal.Id                             AS PersonalId
           , Object_Personal.ValueData                      AS PersonalName
           , Object_Route.Id                                AS RouteId
           , Object_Route.ValueData                         AS RouteName
           , Object_RouteSorting.Id                         AS RouteSortingId
           , Object_RouteSorting.ValueData                  AS RouteSortingName
           , Object_Retail.Id                               AS RetailId
           , Object_Retail.ValueData                        AS RetailName
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           , View_Contract_InvNumber.ContractId             AS ContractId
           , View_Contract_InvNumber.ContractCode           AS ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractName
           , View_Contract_InvNumber.ContractTagId          AS ContractTagId
           , View_Contract_InvNumber.ContractTagName        AS ContractTagName
           , Object_PriceList.id                            AS PriceListId
           , Object_PriceList.ValueData                     AS PriceListName
           , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
           , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData             AS VATPercent
           , MovementFloat_ChangePercent.ValueData          AS ChangePercent
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData          AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData          AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData              AS TotalSumm
           , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh
           , MovementFloat_TotalCount.ValueData             AS TotalCount
           , MovementFloat_TotalCountSecond.ValueData       AS TotalCountSecond

           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ValueData      AS JuridicalName

           , COALESCE(MovementLinkMovement_Order.MovementId, 0) <> 0 AS isEDI
           , MovementString_Comment.ValueData       AS Comment

           , tmpWeekDay.DayOfWeekName         ::TVarChar AS DayOfWeekName
           , tmpWeekDay_Partner.DayOfWeekName ::TVarChar AS DayOfWeekName_Partner
           , tmpWeekDay_CarInfo.DayOfWeekName ::TVarChar AS DayOfWeekName_CarInfo
           
           , Movement.isRemains               :: Boolean AS isRemains

       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Object AS Object_From ON Object_From.Id = Movement.FromId

            /*LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            */
            LEFT JOIN tmpMovementDate AS MovementDate_OperDateMark
                                      ON MovementDate_OperDateMark.MovementId =  Movement.Id
                                     AND MovementDate_OperDateMark.DescId = zc_MovementDate_OperDateMark()
            LEFT JOIN tmpMovementDate AS MovementDate_CarInfo
                                      ON MovementDate_CarInfo.MovementId =  Movement.Id
                                     AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementString AS MovementString_Comment
                                        ON MovementString_Comment.MovementId = Movement.Id
                                       AND MovementString_Comment.DescId = zc_MovementString_Comment()


            LEFT JOIN ObjectFloat AS ObjectFloat_Partner_DocumentDayCount
                                  ON ObjectFloat_Partner_DocumentDayCount.ObjectId = Movement.FromId
                                 AND ObjectFloat_Partner_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

            LEFT JOIN Object AS Object_To ON Object_To.Id = Movement.ToId


            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Personal
                                            ON MovementLinkObject_Personal.MovementId = Movement.Id
                                           AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()

            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

           /* LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Route
                                            ON MovementLinkObject_Route.MovementId = Movement.Id
                                           AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            */
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = Movement.RouteId-- MovementLinkObject_Route.ObjectId

            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = Movement.RetailId-- MovementLinkObject_Route.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_RouteSorting
                                            ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                           AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()

            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidKind
                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Contract
                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN tmpContract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN tmpInfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId


            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PriceList
                                            ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                           AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()

            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                         ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                        AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                       ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                      AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN tmpMovementFloat AS MovementFloat_ChangePercent
                                       ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                      AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSh
                                       ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                       ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSecond
                                       ON MovementFloat_TotalCountSecond.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountSecond.DescId = zc_MovementFloat_TotalCountSecond()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                       ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                       ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN tmpMovementLinkMovement AS MovementLinkMovement_Order
                                              ON MovementLinkMovement_Order.MovementId = Movement.Id
                                             AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

            LEFT JOIN ObjectLink AS ObjectLink_From_Juridical
                                 ON ObjectLink_From_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_From_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_From_Juridical.ChildObjectId

            LEFT JOIN zfCalc_DayOfWeekName (Movement.OperDate) AS tmpWeekDay ON 1=1
            LEFT JOIN zfCalc_DayOfWeekName (Movement.OperDatePartner) AS tmpWeekDay_Partner ON 1=1
            LEFT JOIN zfCalc_DayOfWeekName (MovementDate_CarInfo.ValueData) AS tmpWeekDay_CarInfo ON 1=1
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.06.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderExternal_byReport(inOperDate := ('29.06.2022')::TDateTime , inOperDatePartner := ('08.07.2022')::TDateTime , inToId := 8459 , inRouteId := 419580 , inRetailId := 0 ,  inSession := '5');
