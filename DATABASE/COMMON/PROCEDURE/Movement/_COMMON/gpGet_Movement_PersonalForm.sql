-- Function: gpGet_Movement_PersonalForm()

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalForm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalForm(
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
 20.07.23         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_PersonalForm (inMovementId:= 40874, inSession:= zfCalc_UserAdmin())
