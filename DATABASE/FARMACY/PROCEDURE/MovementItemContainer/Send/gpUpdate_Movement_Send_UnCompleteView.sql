-- Function: gpUpdate_Movement_Send_UnCompleteView

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_UnCompleteView (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_UnCompleteView(
    IN inId               Integer,   -- �����������
    IN inSession          TVarChar   -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbComent TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION '������. ��������� ������ ��������������.';
   END IF;

   IF COALESCE ((SELECT Movement_Send.StatusId
                 FROM Movement AS Movement_Send
                 WHERE Movement_Send.Id = inID
                   AND Movement_Send.DescId = zc_Movement_Send()), 0) = zc_Enum_Status_Erased()
   THEN
     PERFORM gpUnComplete_Movement_Send (inMovementId := inID, inSession := inSession);
   END IF;
    
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.01.20                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Send_UnCompleteView (inMovementId:= 1, inSession := '3');
