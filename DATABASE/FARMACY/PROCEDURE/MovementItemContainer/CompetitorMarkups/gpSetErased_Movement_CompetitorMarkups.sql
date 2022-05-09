-- Function: gpSetErased_Movement_CompetitorMarkups (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_CompetitorMarkups (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_CompetitorMarkups(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.05.22                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_CompetitorMarkups (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
