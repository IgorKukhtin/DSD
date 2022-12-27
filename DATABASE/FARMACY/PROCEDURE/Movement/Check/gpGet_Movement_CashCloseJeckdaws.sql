-- Function: gpGet_Movement_CashCloseJeckdaws()

DROP FUNCTION IF EXISTS gpGet_Movement_CashCloseJeckdaws (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_CashCloseJeckdaws(
    IN inMovementId        Integer  , -- ���� ���������
   OUT outSummaTotal       TFloat   ,
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStatusId Integer;
BEGIN

      vbUserId:= lpGetUserBySession (inSession);

      vbStatusId := NULL;

      SELECT Movement_Check.StatusId
           , MovementFloat_TotalSumm.ValueData             AS TotalSumm
      INTO vbStatusId
         , outSummaTotal
      FROM Movement AS Movement_Check

            LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                         ON MovementLinkObject_JackdawsChecks.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
            LEFT JOIN Object AS Object_JackdawsChecks ON Object_JackdawsChecks.Id = MovementLinkObject_JackdawsChecks.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_Check.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement_Check.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()

      WHERE Movement_Check.Id = inMovementId
        AND Movement_Check.DescId = zc_Movement_Check()
        AND COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 10413041
        AND (COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 0 
         OR COALESCE(MovementLinkObject_CashRegister.ObjectId, 0) = 0);

      IF COALESCE (vbStatusId, 0) = 0
      THEN
        RAISE EXCEPTION '������. ��� � ������� ������ �� ������.';
      END IF;

      IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
      THEN
        RAISE EXCEPTION '������. �������� ���� �� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
16.08.21                                                        *
*/

-- ����
-- 
SELECT * FROM gpGet_Movement_CashCloseJeckdaws (inMovementId:= 19806544 , inSession:= '3')