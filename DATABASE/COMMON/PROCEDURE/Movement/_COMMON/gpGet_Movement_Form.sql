-- Function: gpGet_Movement_ZakazInternal()

DROP FUNCTION IF EXISTS gpGet_Movement_Form (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Form(
    IN inMovementId        Integer  , -- ���� ���������
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
            COALESCE(Object_Form.ValueData, '')::TVarChar    AS FromName

       FROM Movement                          
       JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
  LEFT JOIN Object AS Object_Form ON Object_Form.Id = MovementDesc.FormId
          
       WHERE Movement.Id = inMovementId;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Form (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.01.14                        *

*/

-- ����
-- SELECT * FROM gpGet_Movement_ZakazInternal (inMovementId:= 1, inSession:= '2')
