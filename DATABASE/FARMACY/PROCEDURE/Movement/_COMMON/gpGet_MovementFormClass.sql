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
            WHEN zc_Movement_SendPartionDate() THEN zc_FormClass_SendPartionDate()
            WHEN zc_Movement_Reprice() THEN zc_FormClass_Reprice()
            WHEN zc_Movement_OrderInternal() THEN  zc_FormClass_OrderInternal()
            WHEN zc_Movement_OrderInternal() THEN  zc_FormClass_OrderInternal()
            WHEN zc_Movement_Over() THEN  zc_FormClass_Over()
            WHEN zc_Movement_OrderExternal() THEN  zc_FormClass_OrderExternal()
            WHEN zc_Movement_Layout() THEN  zc_FormClass_Layout()
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 05.03.20                                                                     *
 25.05.15                         *
 28.04.15                         *
*/
-- ����
-- select * from gpGet_MovementFormClass(inMovementId := 1591983  ,  inSession := '3');



select * from gpGet_MovementFormClass(inMovementId := 20462223 ,  inSession := '3');