-- Function: gpSelect_Movement_HospitalDoc_1C()

DROP FUNCTION IF EXISTS gpSelect_Movement_HospitalDoc_1C (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_HospitalDoc_1C(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusId Integer, StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , StartStop TDateTime, EndStop TDateTime
             , Code1C            TVarChar --��� ����� ����������
             , INN               TVarChar --INN
             , FIO               TVarChar --���
             , Comment           TVarChar --�������
             , Error             TVarChar --��� ������ ����� �������� � ������ �.��.
             , InvNumberPartner  TVarChar --� ���. � 1�
             , InvNumberHospital TVarChar --� �����������
             , NumHospital       TVarChar --� ������
             , SummStart         TFloat   --���������� �� ������ 5 �.��.
             , SummPF            TFloat   --���������� ��
             , PersonalId        Integer
             , PersonalName      TVarChar
             , MemberName        TVarChar
             , PositionId        Integer
             , PositionName      TVarChar
             , PositionLevelName TVarChar
             , UnitId            Integer
             , UnitName          TVarChar 
             , isMain            Boolean         
             , InsertName        TVarChar
             , UpdateName        TVarChar
             , InsertDate        TDateTime
             , UpdateDate        TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsAccessKey_HospitalDoc_1C Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_HospitalDoc_1C());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- ���������
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMember AS (SELECT lfSelect.MemberId
                             , lfSelect.PersonalId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                             , lfSelect.BranchId
                        FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                        WHERE lfSelect.Ord = 1
                        )

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                             JOIN Movement ON Movement.DescId = zc_Movement_HospitalDoc_1C()
                                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                          AND Movement.StatusId = tmpStatus.StatusId
                        )
 
        , tmpMovementString AS (SELECT * 
                                FROM MovementString 
                                WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementString.DescId IN (zc_MovementString_Code1C()
                                                              , zc_MovementString_INN()
                                                              , zc_MovementString_FIO()
                                                              , zc_MovementString_Comment()
                                                              , zc_MovementString_Error()
                                                              , zc_MovementString_InvNumberPartner()
                                                              , zc_MovementString_InvNumberHospital()
                                                              , zc_MovementString_NumHospital()
                                                               )
                                )

        , tmpMovementDate AS (SELECT * 
                                FROM MovementDate 
                                WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementDate.DescId IN (zc_MovementDate_ServiceDate()
                                                            , zc_MovementDate_StartStop()
                                                            , zc_MovementDate_EndStop()
                                                            , zc_MovementDate_Insert()
                                                            , zc_MovementDate_Update()
                                                             )
                                )

        , tmpMovementFloat AS (SELECT * 
                               FROM MovementFloat 
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId IN (zc_MovementFloat_SummStart()
                                                            , zc_MovementFloat_SummPF()
                                                            , zc_MovementString_FIO()
                                                            , zc_MovementString_Comment()
                                                            , zc_MovementString_Error()
                                                            , zc_MovementString_InvNumberPartner()
                                                            , zc_MovementString_InvNumberHospital()
                                                            , zc_MovementString_NumHospital()
                                                             )
                               )

        , tmpMLO AS (SELECT * 
                     FROM MovementLinkObject 
                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementLinkObject.DescId IN (zc_MovementLinkObject_Personal()
                                                       , zc_MovementLinkObject_Insert()
                                                       , zc_MovementLinkObject_Update()
                                                        )
                         )
        , tmpPersonal_View AS (SELECT Object_Personal_View.* FROM Object_Personal_View)
       -- ���������
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.Id                      AS StatusId
           , Object_Status.ObjectCode              AS StatusCode
           , Object_Status.ValueData               AS StatusName

           , MovementDate_ServiceDate.ValueData ::TDateTime AS ServiceDate    --����� ����������
           , MovementDate_StartStop.ValueData   ::TDateTime AS StartStop      --���� ��������. �
           , MovementDate_EndStop.ValueData     ::TDateTime AS EndStop        --���� ��������. ��

           , MovementString_Code1C.ValueData            ::TVarChar AS Code1C             --��� ����� ����������
           , MovementString_INN.ValueData               ::TVarChar AS INN                --INN
           , MovementString_FIO.ValueData               ::TVarChar AS FIO                --���
           , MovementString_Comment.ValueData           ::TVarChar AS Comment            --�������
           , MovementString_Error.ValueData             ::TVarChar AS Error              --��� ������ ����� �������� � ������ �.��.
           , MovementString_InvNumberPartner.ValueData  ::TVarChar AS InvNumberPartner   --� ���. � 1�
           , MovementString_InvNumberHospital.ValueData ::TVarChar AS InvNumberHospital  --� �����������
           , MovementString_NumHospital.ValueData       ::TVarChar AS NumHospital        --� ������
           
           , MovementFloat_SummStart.ValueData          ::TFloat   AS SummStart          --���������� �� ������ 5 �.��.
           , MovementFloat_SummPF.ValueData             ::TFloat   AS SummPF             --���������� ��

           , View_Personal.PersonalId              AS PersonalId
           , View_Personal.PersonalName            AS PersonalName
           , Object_Member.ValueData               AS MemberName

           , View_Personal.PositionId              AS PositionId
           , View_Personal.PositionName            AS PositionName
           , View_Personal.PositionLevelName       AS PositionLevelName
           , View_Personal.UnitId                  AS UnitId
           , View_Personal.UnitName                AS UnitName
           , View_Personal.isMain        ::Boolean AS isMain

            --�������� ����� ������ + ������������ � ����� �������� zc_ObjectBoolean_Personal_Main + Position + PositionLevel + Unit + MemberName

           , Object_Insert.ValueData               AS InsertName
           , Object_Update.ValueData               AS UpdateName
           , MovementDate_Insert.ValueData         AS InsertDate
           , MovementDate_Update.ValueData         AS UpdateDate

       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN tmpMovementDate AS MovementDate_ServiceDate
                                      ON MovementDate_ServiceDate.MovementId = Movement.Id
                                     AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

            LEFT JOIN tmpMovementDate AS MovementDate_StartStop
                                      ON MovementDate_StartStop.MovementId = Movement.Id
                                     AND MovementDate_StartStop.DescId = zc_MovementDate_StartStop()

            LEFT JOIN tmpMovementDate AS MovementDate_EndStop
                                      ON MovementDate_EndStop.MovementId = Movement.Id
                                     AND MovementDate_EndStop.DescId = zc_MovementDate_EndStop()

            LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                      ON MovementDate_Insert.MovementId = Movement.Id
                                     AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN tmpMovementDate AS MovementDate_Update
                                      ON MovementDate_Update.MovementId = Movement.Id
                                     AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN tmpMovementString AS MovementString_Code1C
                                        ON MovementString_Code1C.MovementId = Movement.Id
                                       AND MovementString_Code1C.DescId = zc_MovementString_Code1C()

            LEFT JOIN tmpMovementString AS MovementString_INN
                                        ON MovementString_INN.MovementId = Movement.Id
                                       AND MovementString_INN.DescId = zc_MovementString_INN()

            LEFT JOIN tmpMovementString AS MovementString_FIO
                                        ON MovementString_FIO.MovementId = Movement.Id
                                       AND MovementString_FIO.DescId = zc_MovementString_FIO()

            LEFT JOIN tmpMovementString AS MovementString_Comment
                                        ON MovementString_Comment.MovementId = Movement.Id
                                       AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMovementString AS MovementString_Error
                                        ON MovementString_Error.MovementId = Movement.Id
                                       AND MovementString_Error.DescId = zc_MovementString_Error()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberHospital
                                        ON MovementString_InvNumberHospital.MovementId = Movement.Id
                                       AND MovementString_InvNumberHospital.DescId = zc_MovementString_InvNumberHospital()

            LEFT JOIN tmpMovementString AS MovementString_NumHospital
                                        ON MovementString_NumHospital.MovementId = Movement.Id
                                       AND MovementString_NumHospital.DescId = zc_MovementString_NumHospital()

            LEFT JOIN tmpMovementFloat AS MovementFloat_SummStart
                                       ON MovementFloat_SummStart.MovementId = Movement.Id
                                      AND MovementFloat_SummStart.DescId = zc_MovementFloat_SummStart()

            LEFT JOIN tmpMovementFloat AS MovementFloat_SummPF
                                       ON MovementFloat_SummPF.MovementId = Movement.Id
                                      AND MovementFloat_SummPF.DescId = zc_MovementFloat_SummPF()

            LEFT JOIN tmpMLO AS MovementLinkObject_Personal
                             ON MovementLinkObject_Personal.MovementId = Movement.Id
                            AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN tmpPersonal_View AS View_Personal ON View_Personal.PersonalId = MovementLinkObject_Personal.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                             ON MovementLinkObject_Insert.MovementId = Movement.Id
                            AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Update
                             ON MovementLinkObject_Update.MovementId = Movement.Id
                            AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

            LEFT JOIN Object AS Object_Member ON Object_Member.Id = View_Personal.MemberId
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.07.25         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_HospitalDoc_1C (inStartDate:= '01.08.2023', inEndDate:= '01.08.2023', inIsErased:=true, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
