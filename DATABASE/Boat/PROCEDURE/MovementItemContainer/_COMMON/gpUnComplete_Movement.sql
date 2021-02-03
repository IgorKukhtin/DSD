-- Function: gpUnComplete_Movement (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement(
    IN inMovementId Integer               , -- ���� ������� <��������>
--    IN inIsChild    Boolean  DEFAULT TRUE , -- ���� �� � ����� ��������� ����������� ��������� !!!�� � ���� ������ �� ������� FALSE!!!
    IN inSession    TVarChar DEFAULT ''     -- ������� ������������
)                              
  RETURNS void
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_UnComplete_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUnComplete_Movement (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.10.13                                        * del ����������� ����������� ���������
 12.10.13                                        * add lfCheck_Movement_ParentStatus
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 55, inIsChild := TRUE, inSession:= '2')
