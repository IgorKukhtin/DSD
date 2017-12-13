-- Function: gpGet_Movement_Form_two()

DROP FUNCTION IF EXISTS gpGet_Movement_Form_two (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Form_two(
    IN inMovementId        Integer  , -- ���� ���������
    IN inDescCode          TVarChar , -- ���� ������ �� ������ �����
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (FormName TVarChar)
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ZakazInternal());

     RETURN QUERY 
       SELECT
            COALESCE (CASE WHEN inDescCode = 'zc_Movement_Send' AND Movement.DescId = zc_Movement_Send()
                                THEN 'TSendMemberForm'
                           ELSE Object_Form.ValueData
                      END, '') :: TVarChar AS FromName

       FROM Movement                          
            JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
            LEFT JOIN Object AS Object_Form ON Object_Form.Id = MovementDesc.FormId
       WHERE Movement.Id = inMovementId;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.01.14                        *

*/

-- ����
-- SELECT * FROM gpGet_Movement_Form_two (inMovementId:= 40874, inDescCode:= 'zc_Movement_Send', inSession:= zfCalc_UserAdmin())
