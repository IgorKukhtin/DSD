-- �������� �������� �������
-- Function: lpCheckPeriodClose()

DROP FUNCTION IF EXISTS lpCheckPeriodClose (TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheckPeriodClose(
    IN inOperDate         TDateTime , -- 
    IN inMovementId      Integer   , -- 
    IN inMovementDescId  Integer   , -- 
    IN inAccessKeyId     Integer   , -- 
    IN inUserId          Integer     -- ������������
)
RETURNS VOID
AS
$BODY$  
BEGIN

     -- �������� - ������
     IF inOperDate < CURRENT_DATE - INTERVAL '3 DAY'
        AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������.��� ������������ <%> ��������� � ��������� �������� � <%>.'
                       , lfGet_Object_ValueData_sh (inUserId)
                       , zfConvert_DateToString (CURRENT_DATE - INTERVAL '3 DAY')
                        ;
     END IF;

     -- �������� - ������������
     IF NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = inUserId AND OB.DescId = zc_ObjectBoolean_User_Sign() AND OB.ValueData = TRUE)
        AND COALESCE (inUserId, -1) <> COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Insert()), -2)
        AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������.�������� ����� = <%> �� ����� ���������������� ������������� <%>.'
                       , lfGet_Object_ValueData ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Insert()))
                       , lfGet_Object_ValueData (inUserId)
                        ;
     END IF;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheckPeriodClose (TDateTime, Integer, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.04.16                                        * ALL
 25.02.14                        *
*/

-- ����
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 81241), Movement.* FROM Movement WHERE Id = 3091408 -- ��������� ����� - ������� �.�.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 81241), Movement.* FROM Movement WHERE Id = 3067578 -- ���� �� - ������� �.�.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 300547), Movement.* FROM Movement WHERE Id = 3424050 -- ���� �� - �������� �.�.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 76913), Movement.* FROM Movement WHERE Id = 2802779  -- ���������� ��������� - �������� �.�