DROP FUNCTION IF EXISTS gpGet_MovementFormClass (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementFormClass(
    IN inMovementId        Integer  , -- ���� ���������
   OUT outFormClass        TVarChar , --����� ����� ��� �������������� ���������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
BEGIN
    SELECT
        CASE Movement.DescId
            WHEN zc_Movement_Income() THEN zc_FormClass_Income()
            WHEN zc_Movement_ReturnOut() THEN zc_FormClass_ReturnOut()
            WHEN zc_Movement_Inventory() THEN zc_FormClass_Inventory()
            WHEN zc_Movement_Send() THEN zc_FormClass_Send()
            WHEN zc_Movement_Loss() THEN zc_FormClass_Loss()
            WHEN zc_Movement_Check() THEN zc_FormClass_Check()
            WHEN zc_Movement_Sale() THEN zc_FormClass_Sale()
        END
    INTO
        outFormClass
    FROM Movement
    WHERE Movement.Id = inMovementId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_MovementFormClass (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.05.15                         *
 28.04.15                         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Sale_Print (inMovementId := 135428, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_Movement_Sale_Print (inMovementId := 377284, inSession:= zfCalc_UserAdmin());
