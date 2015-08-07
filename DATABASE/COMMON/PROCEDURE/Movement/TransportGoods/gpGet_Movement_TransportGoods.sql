-- Function: gpGet_Movement_TransportGoods()

DROP FUNCTION IF EXISTS gpGet_Movement_TransportGoods (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TransportGoods(
    IN inMovementId       Integer  , -- ���� ���������
    IN inMovementId_Sale  Integer  , -- ���� ���������
    IN inOperDate         TDateTime , -- 
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , InvNumberMark TVarChar
             , MovementId_Sale Integer, InvNumber_Sale TVarChar, OperDate_Sale TDateTime
             , RouteId Integer, RouteName TVarChar
             , CarId Integer, CarName TVarChar, CarModelId Integer, CarModelName TVarChar
             , CarTrailerId Integer, CarTrailerName TVarChar, CarTrailerModelId Integer, CarTrailerModelName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar
             , MemberId1 Integer, MemberName1 TVarChar
             , MemberId2 Integer, MemberName2 TVarChar
             , MemberId3 Integer, MemberName3 TVarChar
             , MemberId4 Integer, MemberName4 TVarChar
             , MemberId5 Integer, MemberName5 TVarChar
             , MemberId6 Integer, MemberName6 TVarChar
             , MemberId7 Integer, MemberName7 TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , TotalCountBox TFloat
             , TotalWeightBox TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsOd Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TransportGoods());
     vbUserId:= lpGetUserBySession (inSession);


     -- �������� ����� �� �������
     IF inMovementId_Sale <> 0 AND COALESCE (inMovementId, 0) = 0
     THEN
         inMovementId:= (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inMovementId_Sale AND DescId = zc_MovementLinkMovement_TransportGoods());
     END IF;

     -- !!! ��� ������, ������� ��� ��������!!!
     vbIsOd:= 8374 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);

     -- ���� ���� - �������
     IF COALESCE (inMovementId, 0) = 0
     THEN inMovementId:= lpInsertUpdate_Movement_TransportGoods (ioId              := inMovementId
                                                               , inInvNumber       := NEXTVAL ('Movement_TransportGoods_seq') :: TVarChar
                                                               , inOperDate        := inOperDate
                                                               , inMovementId_Sale := inMovementId_Sale
                                                               , inInvNumberMark   := NULL
                                                               , inCarId           := CASE -- vbIsOd + ����
                                                                                           WHEN vbIsOd = TRUE AND 341640 = (SELECT OL_Retail.ChildObjectId
                                                                                                                            FROM MovementLinkObject AS MLO
                                                                                                                                 LEFT JOIN ObjectLink AS OL_Juridical ON OL_Juridical.ObjectId = MLO.ObjectId AND OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                                                                                 LEFT JOIN ObjectLink AS OL_Retail ON OL_Retail.ObjectId = OL_Juridical.ChildObjectId AND OL_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                                                                            WHERE MLO.MovementId = inMovementId_Sale AND MLO.DescId = zc_MovementLinkObject_To()
                                                                                                                           )
                                                                                                THEN 148689 -- �� 12-54 ��
                                                                                           WHEN vbIsOd = TRUE
                                                                                                THEN 8682   -- 850-51 ��
                                                                                           ELSE NULL
                                                                                      END
                                                               , inCarTrailerId    := NULL
                                                               , inPersonalDriverId:= CASE -- vbIsOd + ����
                                                                                           WHEN vbIsOd = TRUE AND 341640 = (SELECT OL_Retail.ChildObjectId
                                                                                                                            FROM MovementLinkObject AS MLO
                                                                                                                                 LEFT JOIN ObjectLink AS OL_Juridical ON OL_Juridical.ObjectId = MLO.ObjectId AND OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                                                                                 LEFT JOIN ObjectLink AS OL_Retail ON OL_Retail.ObjectId = OL_Juridical.ChildObjectId AND OL_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                                                                            WHERE MLO.MovementId = inMovementId_Sale AND MLO.DescId = zc_MovementLinkObject_To()
                                                                                                                           )
                                                                                                THEN 343903 -- ������ ������ ����������
                                                                                           WHEN vbIsOd = TRUE
                                                                                                THEN 427054 -- ������� ����� �����������
                                                                                           ELSE NULL
                                                                                      END
                                                               , inRouteId         := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Sale AND MLO.DescId = zc_MovementLinkObject_Route())
                                                               , inMemberId1       := CASE -- vbIsOd + ����
                                                                                           WHEN vbIsOd = TRUE AND 341640 = (SELECT OL_Retail.ChildObjectId
                                                                                                                            FROM MovementLinkObject AS MLO
                                                                                                                                 LEFT JOIN ObjectLink AS OL_Juridical ON OL_Juridical.ObjectId = MLO.ObjectId AND OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                                                                                 LEFT JOIN ObjectLink AS OL_Retail ON OL_Retail.ObjectId = OL_Juridical.ChildObjectId AND OL_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                                                                            WHERE MLO.MovementId = inMovementId_Sale AND MLO.DescId = zc_MovementLinkObject_To()
                                                                                                                           )
                                                                                                THEN 343903 -- ������ ������ ����������
                                                                                           WHEN vbIsOd = TRUE
                                                                                                THEN 427054 -- ������� ����� �����������
                                                                                           ELSE NULL
                                                                                      END
                                                               , inMemberId2       := CASE WHEN vbIsOd = TRUE
                                                                                                THEN 418699 -- ������ ������ ��������
                                                                                           ELSE NULL
                                                                                      END
                                                               , inMemberId3       := NULL
                                                               , inMemberId4       := NULL
                                                               , inMemberId5       := NULL
                                                               , inMemberId6       := NULL
                                                               , inMemberId7       := NULL
                                                               , inUserId          := vbUserId
                                                                );
     END IF;


     -- ���������
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate

           , MovementString_InvNumberMark.ValueData  AS InvNumberMark

           , Movement_Sale.Id        AS MovementId_Sale
           , Movement_Sale.InvNumber AS InvNumber_Sale
           , Movement_Sale.OperDate  AS OperDate_Sale

           , Object_Route.Id                  AS RouteId
           , Object_Route.ValueData           AS RouteName
           , Object_Car.Id                    AS CarId
           , Object_Car.ValueData             AS CarName
           , Object_CarModel.Id               AS CarModelId
           , Object_CarModel.ValueData        AS CarModelName
           , Object_CarTrailer.Id             AS CarTrailerId
           , Object_CarTrailer.ValueData      AS CarTrailerName
           , Object_CarTrailerModel.Id        AS CarTrailerModelId
           , Object_CarTrailerModel.ValueData AS CarTrailerModelName
           , Object_PersonalDriver.Id         AS PersonalDriverId
           , Object_PersonalDriver.ValueData  AS PersonalDriverName

           , Object_Member1.Id        AS MemberId1
           , Object_Member1.ValueData AS MemberName1
           , Object_Member2.Id        AS MemberId2
           , Object_Member2.ValueData AS MemberName2
           , Object_Member3.Id        AS MemberId3
           , Object_Member3.ValueData AS MemberName3
           , Object_Member4.Id        AS MemberId4
           , Object_Member4.ValueData AS MemberName4
           , Object_Member5.Id        AS MemberId5
           , Object_Member5.ValueData AS MemberName5
           , Object_Member6.Id        AS MemberId6
           , Object_Member6.ValueData AS MemberName6
           , Object_Member7.Id        AS MemberId7
           , Object_Member7.ValueData AS MemberName7

           , Object_From.Id           AS FromId
           , Object_From.ValueData    AS FromName
           , Object_To.Id             AS ToId
           , Object_To.ValueData      AS ToName

           , 0 :: TFloat AS TotalCountBox
           , 0 :: TFloat AS TotalWeightBox

       FROM Movement
            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  Movement.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarTrailer
                                         ON MovementLinkObject_CarTrailer.MovementId = Movement.Id
                                        AND MovementLinkObject_CarTrailer.DescId = zc_MovementLinkObject_CarTrailer()
            LEFT JOIN Object AS Object_CarTrailer ON Object_CarTrailer.Id = MovementLinkObject_CarTrailer.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_CarTrailer_CarModel ON ObjectLink_CarTrailer_CarModel.ObjectId = Object_CarTrailer.Id
                                                                  AND ObjectLink_CarTrailer_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarTrailerModel ON Object_CarTrailerModel.Id = ObjectLink_CarTrailer_CarModel.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId
    
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member1
                                         ON MovementLinkObject_Member1.MovementId = Movement.Id
                                        AND MovementLinkObject_Member1.DescId = zc_MovementLinkObject_Member1()
            LEFT JOIN Object AS Object_Member1 ON Object_Member1.Id = MovementLinkObject_Member1.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member2
                                         ON MovementLinkObject_Member2.MovementId = Movement.Id
                                        AND MovementLinkObject_Member2.DescId = zc_MovementLinkObject_Member2()
            LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = MovementLinkObject_Member2.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member3
                                         ON MovementLinkObject_Member3.MovementId = Movement.Id
                                        AND MovementLinkObject_Member3.DescId = zc_MovementLinkObject_Member3()
            LEFT JOIN Object AS Object_Member3 ON Object_Member3.Id = MovementLinkObject_Member3.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member4
                                         ON MovementLinkObject_Member4.MovementId = Movement.Id
                                        AND MovementLinkObject_Member4.DescId = zc_MovementLinkObject_Member4()
            LEFT JOIN Object AS Object_Member4 ON Object_Member4.Id = MovementLinkObject_Member4.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member5
                                         ON MovementLinkObject_Member5.MovementId = Movement.Id
                                        AND MovementLinkObject_Member5.DescId = zc_MovementLinkObject_Member5()
            LEFT JOIN Object AS Object_Member5 ON Object_Member5.Id = MovementLinkObject_Member5.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member6
                                         ON MovementLinkObject_Member6.MovementId = Movement.Id
                                        AND MovementLinkObject_Member6.DescId = zc_MovementLinkObject_Member6()
            LEFT JOIN Object AS Object_Member6 ON Object_Member6.Id = MovementLinkObject_Member6.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member7
                                         ON MovementLinkObject_Member7.MovementId = Movement.Id
                                        AND MovementLinkObject_Member7.DescId = zc_MovementLinkObject_Member7()
            LEFT JOIN Object AS Object_Member7 ON Object_Member7.Id = MovementLinkObject_Member7.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()

            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_TransportGoods.MovementId
                                               AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_TransportGoods()
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TransportGoods (Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 28.03.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_TransportGoods (inMovementId:= 1, inMovementId_Sale:= 2, inOperDate:= '01.01.2015', inSession:= zfCalc_UserAdmin())
