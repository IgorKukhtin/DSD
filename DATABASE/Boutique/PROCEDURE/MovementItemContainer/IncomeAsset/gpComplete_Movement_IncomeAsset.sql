-- Function: gpComplete_Movement_IncomeAsset()

DROP FUNCTION IF EXISTS gpComplete_Movement_IncomeAsset (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_IncomeAsset(
    IN inMovementId        Integer                , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_IncomeAsset());

     -- �������� ��������
     PERFORM lpComplete_Movement_IncomeAsset (inMovementId     := inMovementId
                                            , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.08.16         *
 */

-- ����
--