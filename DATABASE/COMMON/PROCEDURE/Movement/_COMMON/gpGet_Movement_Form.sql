-- Function: gpGet_Movement_Form()

DROP FUNCTION IF EXISTS gpGet_Movement_Form (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Form(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (FormName TVarChar)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ZakazInternal());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       SELECT
            CASE WHEN 1=1 AND Movement.DescId = zc_Movement_Promo() AND vbUserId IN (280164, /*5,*/ 133035, 9463, 112324) THEN 'TPromoManagerForm'
                 WHEN Movement.DescId = zc_Movement_Promo() AND vbUserId IN (5) AND 1=0 THEN 'TPromoManagerForm'
                 ELSE COALESCE (Object_Form.ValueData, '')
            END ::TVarChar AS FromName

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
 26.06.20         *
 24.01.14                        *

*/

-- ����
-- SELECT * FROM gpGet_Movement_Form (inMovementId:= 40874, inSession:= zfCalc_UserAdmin())
