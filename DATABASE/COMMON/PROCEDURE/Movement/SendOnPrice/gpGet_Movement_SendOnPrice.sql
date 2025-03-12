-- Function: gpGet_Movement_SendOnPrice()

DROP FUNCTION IF EXISTS gpGet_Movement_SendOnPrice (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_SendOnPrice (Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SendOnPrice(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inChangePercentAmount TFloat , -- Расчет по % скидки вес
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat, ChangePercentAmount TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , MovementId_Order Integer, InvNumber_Order TVarChar
             , MovementId_Transport Integer, InvNumber_Transport TVarChar
             , Comment TVarChar
             , MovementId_Production Integer, InvNumber_ProductionFull TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
             , ReasonId Integer, ReasonName  TVarChar
             , MovementId_TransportGoods Integer
             , InvNumber_TransportGoods TVarChar
             , OperDate_TransportGoods TDateTime
             , Checked Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) < 0
    THEN
        RAISE EXCEPTION 'Ошибка. Невозможно открыть пустой документ.';
    END IF;


     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_sendonprice_seq') AS TVarChar) AS InvNumber
             , inOperDate				  AS OperDate
             , Object_Status.Code               	  AS StatusCode
             , Object_Status.Name              		  AS StatusName
             , inOperDate			     	  AS OperDatePartner
             , ObjectBoolean_PriceWithVAT.ValueData       AS PriceWithVAT
             , ObjectFloat_VATPercent.ValueData           AS VATPercent
             , CAST (0 AS TFloat)                         AS ChangePercent
             , 0 /*inChangePercentAmount*/      :: TFloat AS ChangePercentAmount
             , 0                     			  AS FromId
             , CAST ('' AS TVarChar) 			  AS FromName
             , 0                     			  AS ToId
             , CAST ('' AS TVarChar) 			  AS ToName
             , 0                     			  AS RouteSortingId
             , CAST ('' AS TVarChar) 			  AS RouteSortingName
             , Object_PriceList.Id                        AS PriceListId
             , Object_PriceList.ValueData 		  AS PriceListName

             , 0                     			  AS MovementId_Order
             , CAST ('' AS TVarChar) 			  AS InvNumber_Order

             , 0                     			  AS MovementId_Transport
             , '' :: TVarChar                             AS InvNumber_Transport
             , '' :: TVarChar                             AS Comment

             , 0                                          AS MovementId_Production
             , CAST ('' AS TVarChar)                      AS InvNumber_ProductionFull

             , 0                                          AS ReestrKindId
             , '' :: TVarChar                             AS ReestrKindName

             , 0                                          AS SubjectDocId
             , CAST ('' AS TVarChar)                      AS SubjectDocName
             , 0                                          AS ReasonId
             , CAST ('' AS TVarChar)                      AS ReasonName 

             , 0                   			  AS MovementId_TransportGoods 
             , '' :: TVarChar                     	  AS InvNumber_TransportGoods 
             , inOperDate                                 AS OperDate_TransportGoods
             , CAST (FALSE AS Boolean)         		  AS Checked

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
           , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
           , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) :: Boolean         AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData             AS VATPercent
           , MovementFloat_ChangePercent.ValueData          AS ChangePercent
           , 0 /*inChangePercentAmount*/          :: TFloat AS ChangePercentAmount
           , Object_From.Id                    	            AS FromId
           , Object_From.ValueData             		    AS FromName
           , Object_To.Id                      		    AS ToId
           , Object_To.ValueData               		    AS ToName
           , Object_RouteSorting.Id       		    AS RouteSortingId
           , Object_RouteSorting.ValueData		    AS RouteSortingName
           , Object_PriceList.id                            AS PriceListId
           , Object_PriceList.valuedata                     AS PriceListName

           , MovementLinkMovement_Order.MovementChildId     AS MovementId_Order
           , Movement_Order.InvNumber                       AS InvNumber_Order

           , Movement_Transport.Id                          AS MovementId_Transport
           , ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar AS InvNumber_Transport

           , MovementString_Comment.ValueData               AS Comment

           , CASE WHEN COALESCE (Movement_Production.Id,0) <> 0 THEN Movement_Production.Id ELSE -1 END ::Integer AS MovementId_Production
           , (CASE WHEN Movement_Production.StatusId = zc_Enum_Status_Erased()
                       THEN '***'
                   WHEN Movement_Production.StatusId = zc_Enum_Status_UnComplete()
                       THEN '*'
                   ELSE ''
              END
           || zfCalc_PartionMovementName (Movement_Production.DescId, MovementDesc_Production.ItemName, Movement_Production.InvNumber, Movement_Production.OperDate)
             )                             :: TVarChar      AS InvNumber_ProductionFull

           , Object_ReestrKind.Id             		    AS ReestrKindId
           , Object_ReestrKind.ValueData       		    AS ReestrKindName

           , Object_SubjectDoc.Id                                 AS SubjectDocId
           , COALESCE (Object_SubjectDoc.ValueData,'') ::TVarChar AS SubjectDocName

           , 0                   		            AS ReasonId
           , CAST ('' AS TVarChar)                          AS ReasonName 

           , Movement_TransportGoods.Id                     AS MovementId_TransportGoods
           , Movement_TransportGoods.InvNumber              AS InvNumber_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, Movement.OperDate) AS OperDate_TransportGoods
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId = Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

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

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id 
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Production
                                           ON MovementLinkMovement_Production.MovementChildId = Movement.Id                                   --MovementLinkMovement_Production.MovementId = Movement.Id
                                          AND MovementLinkMovement_Production.DescId = zc_MovementLinkMovement_Production()
            LEFT JOIN Movement AS Movement_Production ON Movement_Production.Id = MovementLinkMovement_Production.MovementId  --MovementLinkMovement_Production.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Production ON MovementDesc_Production.Id = Movement_Production.DescId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_SendOnPrice()
       LIMIT CASE WHEN vbUserId = 5 THEN 10 ELSE 1 END
      ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_SendOnPrice (Integer, TDateTime, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.02.20         * SubjectDoc
 11.06.15         * add inChangePercentAmount
 08.06.15         * add Order
 05.05.14                                                        *   передалал все по новой на базе проц расхода.
 18.04.14                                                        *
 09.07.13                                        * Красота
 08.07.13                                        * zc_MovementFloat_ChangePercent
 30.06.13                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_SendOnPrice (inMovementId:= 1, inOperDate:= NULL, inChangePercentAmount:= 0, inSession:= '2')
--select * from gpGet_Movement_SendOnPrice(inMovementId := 22292328 , inOperDate := ('25.02.2022')::TDateTime , inChangePercentAmount := 1 ,  inSession := '9457');
