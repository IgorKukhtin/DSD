-- Function: gpSetErased_Movement_SheetWorkTimeClose (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_SheetWorkTimeClose (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_SheetWorkTimeClose(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_SheetWorkTimeClose());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.21         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_SheetWorkTimeClose (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
