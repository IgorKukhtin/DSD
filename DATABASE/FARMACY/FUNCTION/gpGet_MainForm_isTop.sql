-- Function: gpGet_MainForm_isTop()

DROP FUNCTION IF EXISTS gpGet_MainForm_isTop (TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Send(
   OUT isMainFormTop         Boolean  ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());
     vbUserId := inSession;
    
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
     THEN
       isMainFormTop := True;
     ELSE
       isMainFormTop := False;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.09.21                                                       *  
*/

-- ����
-- 
SELECT * FROM gpInsertUpdate_Movement_Send (inSession:= '17489481')
