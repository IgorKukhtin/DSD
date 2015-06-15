-- Function: gpGet_Scale_Movement_checkId()

-- DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_check (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Movement_check (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Movement_checkId (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Movement_checkId(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (isOk        Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     IF EXISTS (SELECT MovementId FROM MovementItem WHERE MovementId = inMovementId AND isErased = FALSE)
     THEN
         -- ���������
         RETURN QUERY
           SELECT FALSE;
     ELSE
         -- ���������
         RETURN QUERY
           SELECT TRUE;
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 03.02.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_Scale_Movement_checkId (inMovementId:= 0, inSession:= '2')
