-- Function: gpGet_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderExternal (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderExternal(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
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
             , RouteSortingId Integer, RouteSortingName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , RetailId Integer, RetailName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , DayCount TFloat
             , isPrinted Boolean
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId_Branch_Constraint Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     vbObjectId_Branch_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
 
     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_orderexternal_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , inOperDate                                       AS OperDatePartner
             , inOperDate                                       AS OperDatePartner_sale
             , inOperDate                                       AS OperDateMark
             , (inOperDate - INTERVAL '7 DAY') ::TDateTime      AS OperDateStart
             , (inOperDate - INTERVAL '1 DAY') ::TDateTime      AS OperDateEnd             
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

             , CAST (FALSE AS Boolean)                          AS PriceWithVAT
             , CAST (20 AS TFloat)                              AS VATPercent
             , CAST (0 AS TFloat)                               AS ChangePercent
             , (1 + EXTRACT (DAY FROM ((inOperDate - INTERVAL '1 DAY') - (inOperDate - INTERVAL '7 DAY')))) :: TFloat AS DayCount
             , CAST (FALSE AS Boolean)                          AS isPrinted

             , CAST ('' as TVarChar) 		        AS Comment

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 11 -- ������ ���������
                                                                         THEN 301309 -- ����� �� �.���������
                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 4  -- ������ ������
                                                                         THEN 346093 -- ����� �� �.������

                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 3  -- ������ �������� (������)
                                                                         THEN 8417 -- ����� �� �.�������� (������)

                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 2  -- ������ ����
                                                                         THEN 8411 -- ����� �� � ����

                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 5  -- ������ �������� (����������)
                                                                         THEN 8415 -- ����� �� �.�������� (����������)

                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 7  -- ������ ��.���
                                                                         THEN 8413 -- ����� �� �.������ ���

                                                                    WHEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbObjectId_Branch_Constraint) = 9  -- ������ �������
                                                                         THEN 8425 -- ����� �� �.�������

                                                                    ELSE 8459 -- ����� ����������
                                                               END
               LEFT JOIN Object AS Object_StoreMain ON Object_StoreMain.Id = 8459 -- ����� ����������
         ;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , (Movement.OperDate + ((COALESCE (ObjectFloat_PrepareDayCount.ValueData, 0) + COALESCE (ObjectFloat_DocumentDayCount.ValueData, 0)) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner_sale
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
           , Object_RouteSorting.Id                     AS RouteSortingId
           , Object_RouteSorting.ValueData              AS RouteSortingName
           , Object_PaidKind.Id                         AS PaidKindId
           , Object_PaidKind.ValueData                  AS PaidKindName
           , View_Contract_InvNumber.ContractId         AS ContractId
           , View_Contract_InvNumber.InvNumber          AS ContractName
           , View_Contract_InvNumber.ContractTagName    AS ContractTagName
           , Object_PriceList.id                        AS PriceListId
           , Object_PriceList.ValueData                 AS PriceListName

           , Object_Retail.id                               AS RetailId
           , Object_Retail.ValueData                        AS RetailName
           , Object_Partner.id                              AS PartnerId
           , Object_Partner.ValueData                       AS PartnerName

           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)  AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_ChangePercent.ValueData      AS ChangePercent
           , (1 + EXTRACT (DAY FROM (COALESCE (MovementDate_OperDateEnd.ValueData, Movement.OperDate - (INTERVAL '1 DAY')) :: TDateTime
                                   - COALESCE (MovementDate_OperDateStart.ValueData, Movement.OperDate - (INTERVAL '7 DAY')) :: TDateTime)
                          )) :: TFloat AS DayCount
           , COALESCE (MovementBoolean_Print.ValueData, FALSE) AS isPrinted
           , MovementString_Comment.ValueData       AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementDate AS MovementDate_OperDateMark
                                   ON MovementDate_OperDateMark.MovementId =  Movement.Id
                                  AND MovementDate_OperDateMark.DescId = zc_MovementDate_OperDateMark()

            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

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

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
           LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

           LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                     ON MovementBoolean_Print.MovementId =  Movement.Id
                                    AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                        ON MovementLinkObject_Retail.MovementId = Movement.Id
                                       AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

           LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                        ON MovementLinkObject_Partner.MovementId = Movement.Id
                                       AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_OrderExternal();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_OrderExternal (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.05.15         * add Retail, Partner
 09.02.15         * add DayCount
 06.02.15                                                        *
 26.08.14                                                        *
 18.08.14                                                        *
 06.06.14                                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_OrderExternal (inMovementId:= 1, inOperDate:= CURRENT_TIMESTAMP, inSession:= '9818')
