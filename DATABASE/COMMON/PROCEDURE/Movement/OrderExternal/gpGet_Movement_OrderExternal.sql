-- Function: gpGet_Movement_OrderExternal()

--DROP FUNCTION IF EXISTS gpGet_Movement_OrderExternal (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_OrderExternal (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderExternal(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inMask              Boolean  , -- добавить по маске
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, OperDatePartner_sale TDateTime, OperDateMark TDateTime
             , OperDateStart TDateTime, OperDateEnd TDateTime
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , FromId_OrderUnit Integer, FromName_OrderUnit TVarChar
             , ToId_OrderUnit Integer, ToName_OrderUnit TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , RouteId Integer, RouteName TVarChar
             , RouteId_OrderUnit Integer, RouteName_OrderUnit TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , RetailId Integer, RetailName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , CarInfoId Integer, CarInfoName TVarChar, OperDate_CarInfo TDateTime
             , StatusId_wms Integer, StatusCode_wms Integer, StatusName_wms TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , DayCount TFloat
             , isPrinted Boolean
             , isPrintComment Boolean
             , isPromo Boolean
             , isAuto Boolean
             , isMask Boolean  -- вернуть обратно False 
             , IsRemains Boolean
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId_Branch_Constraint Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) < 0
    THEN
        RAISE EXCEPTION 'Ошибка. Невозможно открыть пустой документ.';
    END IF;


     -- создаем док по маске
     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_OrderExternal_Mask (ioId        := inMovementId
                                                         , inOperDate  := inOperDate
                                                         , inSession   := inSession); 
     END IF;


     vbObjectId_Branch_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
 
     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_orderexternal_seq') AS TVarChar) AS InvNumber
             -- , inOperDate                                    AS OperDate
             , CURRENT_DATE :: TDateTime                        AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             -- , inOperDate                                    AS OperDatePartner
             , CURRENT_DATE :: TDateTime                        AS OperDatePartner
             -- , inOperDate                                    AS OperDatePartner_sale
             , CURRENT_DATE :: TDateTime                        AS OperDatePartner_sale
             -- , inOperDate                                    AS OperDateMark
             , CURRENT_DATE :: TDateTime                        AS OperDateMark
             -- , (inOperDate - INTERVAL '7 DAY') ::TDateTime   AS OperDateStart
             , (CURRENT_DATE - INTERVAL '7 DAY') ::TDateTime    AS OperDateStart
             -- , (inOperDate - INTERVAL '1 DAY') ::TDateTime   AS OperDateEnd
             , (CURRENT_DATE - INTERVAL '1 DAY') ::TDateTime    AS OperDateEnd
             , CAST ('' AS TVarChar)                            AS InvNumberPartner
             , 0                     				AS FromId
             , CAST ('' AS TVarChar) 				AS FromName
             , Object_To.Id             	                AS ToId
             , Object_To.ValueData                              AS ToName
             , Object_To.Id            				AS FromId_OrderUnit
             , Object_To.ValueData 				AS FromName_OrderUnit
             , Object_StoreMain.Id             	                AS ToId_OrderUnit
             , Object_StoreMain.ValueData                       AS ToName_OrderUnit
             , 0                     				AS PersonalId
             , CAST ('' AS TVarChar) 				AS PersonalName
             , 0                     				AS RouteId
             , CAST ('' AS TVarChar) 				AS RouteName
             , Object_Route.Id               			AS RouteId_OrderUnit
             , Object_Route.ValueData        			AS RouteName_OrderUnit
             , 0                     				AS RouteSortingId
             , CAST ('' AS TVarChar) 				AS RouteSortingName
             , 0                     				AS PaidKindId
             , CAST ('' AS TVarChar) 				AS PaidKindName
             , 0                     				AS ContractId
             , CAST ('' AS TVarChar) 				AS ContractName
             , CAST ('' AS TVarChar) 				AS ContractTagName
             , CAST (0  AS Integer)                             AS PriceListId
             , CAST ('' AS TVarChar) 			        AS PriceListName

             , CAST (0  AS Integer)                             AS RetailId
             , CAST ('' AS TVarChar)                            AS RetailName
             , CAST (0  AS Integer)                             AS PartnerId
             , CAST ('' AS TVarChar)                            AS PartnerName
             , CAST (0  AS Integer)                             AS CarInfoId
             , CAST ('' AS TVarChar)                            AS CarInfoName
             , NULL ::TDateTime                                 AS OperDate_CarInfo
             , CAST (0  AS Integer)                             AS StatusId_wms
             , CAST (0  AS Integer)                             AS StatusCode_wms
             , CAST ('' AS TVarChar)                            AS StatusName_wms

             , CAST (FALSE AS Boolean)                          AS PriceWithVAT
             , CAST (20 AS TFloat)                              AS VATPercent
             , CAST (0 AS TFloat)                               AS ChangePercent
             -- , (1 + EXTRACT (DAY FROM ((inOperDate - INTERVAL '1 DAY') - (inOperDate - INTERVAL '7 DAY')))) :: TFloat AS DayCount
             , (1 + EXTRACT (DAY FROM ((CURRENT_DATE - INTERVAL '1 DAY') - (CURRENT_DATE - INTERVAL '7 DAY')))) :: TFloat AS DayCount
             , CAST (FALSE AS Boolean)                          AS isPrinted
             , CAST (FALSE AS Boolean)                          AS isPrintComment
             , CAST (FALSE AS Boolean)                          AS isPromo 
             , CAST (TRUE  AS Boolean)                          AS isAuto
             , CAST (FALSE AS Boolean)                          AS isMask
             , CAST (FALSE AS Boolean)                          AS IsRemains
             , CAST ('' as TVarChar) 		                    AS Comment 

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 11 -- филиал Запорожье
                                                                         THEN 301309 -- Склад ГП ф.Запорожье
                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 4  -- филиал Одесса
                                                                         THEN 346093 -- Склад ГП ф.Одесса

                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 3  -- филиал Николаев (Херсон)
                                                                         THEN 8417 -- Склад ГП ф.Николаев (Херсон)

                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 2  -- филиал Киев
                                                                         THEN 8411 -- Склад ГП ф Киев

                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 5  -- филиал Черкассы (Кировоград)
                                                                         THEN 8415 -- Склад ГП ф.Черкассы (Кировоград)

                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 7  -- филиал Кр.Рог
                                                                         THEN 8413 -- Склад ГП ф.Кривой Рог

                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 9  -- филиал Харьков
                                                                         THEN 8425 -- Склад ГП ф.Харьков

                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 12 -- филиал Lviv
                                                                         THEN 3080691 -- Склад ГП ф.Львов

                                                                    ELSE 8459 -- Склад Реализации
                                                               END
               LEFT JOIN Object AS Object_StoreMain ON Object_StoreMain.Id = 8459 -- Склад Реализации
               LEFT JOIN ObjectLink AS ObjectLink_Unit_Route
                                    ON ObjectLink_Unit_Route.ObjectId = Object_To.Id
                                   AND ObjectLink_Unit_Route.DescId = zc_ObjectLink_Unit_Route()
               LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Unit_Route.ChildObjectId
         ;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode

           , CASE WHEN vbUserId = 5
                  THEN zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next)
                  ELSE Object_Status.ValueData
             END :: TVarChar AS StatusName

           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , (MovementDate_OperDatePartner.ValueData + (COALESCE (ObjectFloat_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner_sale
           , MovementDate_OperDateMark.ValueData        AS OperDateMark
           , COALESCE (MovementDate_OperDateStart.ValueData, Movement.OperDate - (INTERVAL '7 DAY')) :: TDateTime      AS OperDateStart
           , COALESCE (MovementDate_OperDateEnd.ValueData, Movement.OperDate - (INTERVAL '1 DAY')) :: TDateTime        AS OperDateEnd           
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , Object_From.Id                             AS FromId
           , Object_From.ValueData                      AS FromName
           , Object_To.Id                      	        AS ToId
           , Object_To.ValueData               	        AS ToName
           , Object_From.Id                             AS FromId_OrderUnit
           , Object_From.ValueData                      AS FromName_OrderUnit
           , Object_To.Id                      	        AS ToId_OrderUnit
           , Object_To.ValueData               	        AS ToName_OrderUnit
           , Object_Personal.Id                         AS PersonalId
           , Object_Personal.ValueData                  AS PersonalName
           , Object_Route.Id                            AS RouteId
           , Object_Route.ValueData                     AS RouteName
           , Object_Route.Id                            AS RouteId_OrderUnit
           , Object_Route.ValueData                     AS RouteName_OrderUnit
           , Object_RouteSorting.Id                     AS RouteSortingId
           , Object_RouteSorting.ValueData              AS RouteSortingName
           , Object_PaidKind.Id                         AS PaidKindId
           , Object_PaidKind.ValueData                  AS PaidKindName
           , View_Contract_InvNumber.ContractId         AS ContractId
           , View_Contract_InvNumber.InvNumber          AS ContractName
           , View_Contract_InvNumber.ContractTagName    AS ContractTagName
           , Object_PriceList.id                        AS PriceListId
           , Object_PriceList.ValueData                 AS PriceListName

           , Object_Retail.Id                           AS RetailId
           , Object_Retail.ValueData                    AS RetailName
           , Object_Partner.Id                          AS PartnerId
           , Object_Partner.ValueData                   AS PartnerName

           , Object_CarInfo.Id                          AS CarInfoId
           , Object_CarInfo.ValueData                   AS CarInfoName
           , COALESCE (MovementDate_CarInfo.ValueData, Null) ::TDateTime AS OperDate_CarInfo

           , Object_Status_wms.Id                       AS StatusId_wms
           --, COALESCE (Object_Status_wms.ObjectCode, zc_Enum_StatusCode_Erased()) AS StatusCode_wms
           , Object_Status_wms.ObjectCode AS StatusCode_wms
           , Object_Status_wms.ValueData                AS StatusName_wms

           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)  AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_ChangePercent.ValueData      AS ChangePercent
           , (1 + EXTRACT (DAY FROM (COALESCE (MovementDate_OperDateEnd.ValueData, Movement.OperDate - (INTERVAL '1 DAY')) :: TDateTime
                                   - COALESCE (MovementDate_OperDateStart.ValueData, Movement.OperDate - (INTERVAL '7 DAY')) :: TDateTime)
                          )) :: TFloat AS DayCount
           , COALESCE (MovementBoolean_Print.ValueData, FALSE) AS isPrinted
           , COALESCE (MovementBoolean_PrintComment.ValueData, FALSE) AS isPrintComment
           , COALESCE (MovementBoolean_Promo.ValueData, FALSE) AS isPromo 
           , COALESCE (MovementBoolean_isAuto.ValueData, TRUE) AS isAuto
           , CAST (FALSE AS Boolean)                AS isMask
           , COALESCE (MovementBoolean_Remains.ValueData, FALSE) ::Boolean AS IsRemains
           , MovementString_Comment.ValueData       AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementDate AS MovementDate_OperDateMark
                                   ON MovementDate_OperDateMark.MovementId = Movement.Id
                                  AND MovementDate_OperDateMark.DescId = zc_MovementDate_OperDateMark()

            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

            LEFT JOIN MovementDate AS MovementDate_CarInfo
                                   ON MovementDate_CarInfo.MovementId = Movement.Id
                                  AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                      ON MovementBoolean_Print.MovementId = Movement.Id
                                     AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()

            LEFT JOIN MovementBoolean AS MovementBoolean_PrintComment
                                      ON MovementBoolean_PrintComment.MovementId = Movement.Id
                                     AND MovementBoolean_PrintComment.DescId = zc_MovementBoolean_PrintComment()

            LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                      ON MovementBoolean_Promo.MovementId = Movement.Id
                                     AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

            LEFT JOIN MovementBoolean AS MovementBoolean_Remains
                                      ON MovementBoolean_Remains.MovementId = Movement.Id
                                     AND MovementBoolean_Remains.DescId = zc_MovementBoolean_Remains()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount  ON ObjectFloat_PrepareDayCount.ObjectId = MovementLinkObject_From.ObjectId AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
            LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount ON ObjectFloat_DocumentDayCount.ObjectId = MovementLinkObject_From.ObjectId AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                         ON MovementLinkObject_Retail.MovementId = Movement.Id
                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Status_wms
                                         ON MovementLinkObject_Status_wms.MovementId = Movement.Id
                                        AND MovementLinkObject_Status_wms.DescId = zc_MovementLinkObject_Status_wms()
            LEFT JOIN Object AS Object_Status_wms ON Object_Status_wms.Id = MovementLinkObject_Status_wms.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarInfo
                                         ON MovementLinkObject_CarInfo.MovementId = Movement.Id
                                        AND MovementLinkObject_CarInfo.DescId = zc_MovementLinkObject_CarInfo()
            LEFT JOIN Object AS Object_CarInfo ON Object_CarInfo.Id = MovementLinkObject_CarInfo.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_OrderExternal();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_OrderExternal (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.06.22         * CarInfo
 25.06.21         * add inMask
 25.05.21         * isPrintComment
 05.08.20         *
 20.06.18         * add isAuto
 25.11.15         * add Promo
 21.05.15         * add Retail, Partner
 09.02.15         * add DayCount
 06.02.15                                                        *
 26.08.14                                                        *
 18.08.14                                                        *
 06.06.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderExternal (inMovementId:= 1, inOperDate:= CURRENT_TIMESTAMP, inMask := false, inSession:= '9818')
