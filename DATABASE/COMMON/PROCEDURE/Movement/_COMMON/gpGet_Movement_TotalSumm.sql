-- Function: gpGet_Movement_ZakazInternal()

DROP FUNCTION IF EXISTS gpGet_Movement_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TotalSumm(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (TotalSumm TVarChar)
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ZakazInternal());

     RETURN QUERY 
       SELECT
            ('�����: '||trim (to_char (COALESCE (MovementFloat_TotalSummPVAT.ValueData, MovementFloat_TotalSumm.ValueData) , '999 999 999 999 999D99')))::TVarChar  AS TotalSumm
       FROM (SELECT inMovementId AS Id) AS Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
                                   AND Movement.DescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective())
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TotalSumm (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.05.14                                        * add zc_MovementFloat_TotalSummPVAT
 10.04.14                         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_ZakazInternal (inMovementId:= 1, inSession:= '2')
