-- Function: gpGet_Movement_SendOnPrice()

DROP FUNCTION IF EXISTS gpGet_Movement_SendOnPrice (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SendOnPrice(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , PriceListId Integer, PriceListName TVarChar
              )
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_SendOnPrice());

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_sendonprice_seq') AS TVarChar) AS InvNumber
             , inOperDate				        AS OperDate
             , Object_Status.Code               	        AS StatusCode
             , Object_Status.Name              		        AS StatusName
             , inOperDate			     	        AS OperDatePartner
             , ObjectBoolean_PriceWithVAT.ValueData             AS PriceWithVAT
             , ObjectFloat_VATPercent.ValueData                 AS VATPercent
             , CAST (0 AS TFloat)                               AS ChangePercent
             , 0                     				        AS FromId
             , CAST ('' AS TVarChar) 				        AS FromName
             , 0                     				        AS ToId
             , CAST ('' AS TVarChar) 				        AS ToName
             , 0                     				        AS RouteSortingId
             , CAST ('' AS TVarChar) 				        AS RouteSortingName
             , Object_PriceList.Id                                      AS PriceListId
             , Object_PriceList.ValueData 				AS PriceListName

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis()
               LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                       ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                      AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
               LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                     ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                    AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
          ;
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode    				    AS StatusCode
           , Object_Status.ValueData     				    AS StatusName
           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData             AS VATPercent
           , MovementFloat_ChangePercent.ValueData          AS ChangePercent
           , Object_From.Id                    			    AS FromId
           , Object_From.ValueData             			    AS FromName
           , Object_To.Id                      			    AS ToId
           , Object_To.ValueData               			    AS ToName
           , Object_RouteSorting.Id        				    AS RouteSortingId
           , Object_RouteSorting.ValueData 				    AS RouteSortingName
           , Object_PriceList.id                            AS PriceListId
           , Object_PriceList.valuedata                     AS PriceListName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_SendOnPrice();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_SendOnPrice (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.05.14                                                        *   ��������� ��� �� ����� �� ���� ���� �������.
 18.04.14                                                        *
 09.07.13                                        * �������
 08.07.13                                        * zc_MovementFloat_ChangePercent
 30.06.13                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_SendOnPrice (inMovementId:= 1, inSession:= '2')