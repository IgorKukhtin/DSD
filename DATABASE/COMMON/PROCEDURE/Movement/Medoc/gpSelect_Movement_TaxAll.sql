-- Function: gpSelect_Movement_TaxAll()

 DROP FUNCTION IF EXISTS gpSelect_Movement_TaxAll (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TaxAll(
    IN inPeriodDate     TDateTime , --
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, DateRegistered TDateTime, InvNumberRegistered TVarChar, MedocCode Integer)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Tax());
     vbUserId:= inSession;

     --
     RETURN QUERY
     SELECT
             Movement.Id                                AS Id
           , MovementDate_DateRegistered.ValueData      AS DateRegistered
           , MovementString_InvNumberRegistered.ValueData   AS InvNumberRegistered
           , MovementFloat_MedocCode.ValueData::Integer     AS MedocCode

       FROM  Movement 

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            JOIN MovementFloat AS MovementFloat_MedocCode
                               ON MovementFloat_MedocCode.MovementId =  Movement.Id
                              AND MovementFloat_MedocCode.DescId = zc_MovementFloat_MedocCode()

            LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                     ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                    AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()
          WHERE (Movement.StatusId <> zc_Enum_Status_Erased()) AND Movement.DescId in (zc_Movement_Tax(), zc_Movement_TaxCorrective())
                 AND Movement.OperDate >=  inPeriodDate AND Movement.OperDate < (inPeriodDate + INTERVAL '1 month');

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_TaxAll (TDateTime, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.04.15                        * 
*/

-- ����
-- SELECT * FROM gpSelect_Movement_TaxAll (inPeriodDate:= ('01.03.2015')::TDateTime, inSession:= zfCalc_UserAdmin())
