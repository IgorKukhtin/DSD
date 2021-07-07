DROP FUNCTION IF EXISTS gpGet_Movement_TotalSummTestingTuning (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TotalSummTestingTuning(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (TotalCount Integer
             , Question   Integer)
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ZakazInternal());

     RETURN QUERY 
       SELECT
             MovementFloat_TotalCount.ValueData::Integer        AS TotalCount
           , MovementFloat_Question.ValueData::Integer          AS Question
       FROM Movement

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_Question
                                    ON MovementFloat_Question.MovementId = Movement.Id
                                   AND MovementFloat_Question.DescId = zc_MovementFloat_TestingUser_Question()
                                   
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_TestingTuning();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TotalSummTestingTuning (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 24.07.14                                                          *
 */

-- ����
-- SELECT * FROM gpGet_Movement_TotalSummTestingTuning (inMovementId:= 1, inSession:= '2')
