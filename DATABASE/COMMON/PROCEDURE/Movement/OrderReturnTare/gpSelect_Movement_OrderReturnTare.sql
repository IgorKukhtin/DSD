-- Function: gpSelect_Movement_OrderReturnTare()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderReturnTare (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderReturnTare (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderReturnTare(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer ,
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime, InvNumber_Transport_Full TVarChar
             , CarName TVarChar, CarModelName TVarChar, PersonalDriverName TVarChar
             , TotalCountTare TFloat
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , UpdateName TVarChar
             , UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsUserOrder  Boolean;
   DECLARE vbIsUserOrder_basis Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderReturnTare());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
       -- 
       SELECT
             Movement.Id                      AS Id
           , Movement.InvNumber               AS InvNumber
           , Movement.OperDate                AS OperDate
           , Object_Status.ObjectCode         AS StatusCode
           , Object_Status.ValueData          AS StatusName

           , Movement_Transport.Id            AS MovementId_Transport
           , Movement_Transport.InvNumber     AS InvNumber_Transport
           , Movement_Transport.OperDate      AS OperDate_Transport
           --, ('� ' || Movement_Transport.InvNumber || ' �� ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport_Full
           , zfCalc_PartionMovementName (Movement_Transport.DescId, MovementDesc.ItemName, Movement_Transport.InvNumber, Movement_Transport.OperDate) AS InvNumber_Transport_Full
           
           , Object_Car.ValueData             AS CarName
           , Object_CarModel.ValueData        AS CarModelName
           , View_PersonalDriver.PersonalName AS PersonalDriverName
           
           , MovementFloat_TotalCountTare.ValueData  ::TFloat AS TotalCountTare
           , MovementString_Comment.ValueData AS Comment

           , Object_Insert.ValueData          AS InsertName
           , MovementDate_Insert.ValueData    AS InsertDate
           , Object_Update.ValueData          AS UpdateName
           , MovementDate_Update.ValueData    AS UpdateDate

       FROM (SELECT Movement.*
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.DescId = zc_Movement_OrderReturnTare() AND Movement.StatusId = tmpStatus.StatusId
            ) AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Transport.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.01.2          *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_OrderReturnTare(instartdate := ('20.04.2020')::TDateTime , inenddate := ('22.04.2020')::TDateTime , inIsErased := 'False' , inJuridicalBasisId := 9399 ,  inSession := '5');