-- Function: gpUnComplete_Movement_OrderSale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderSale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_OrderSale(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_OrderSale());
      vbUserId:= lpGetUserBySession (inSession);

      -- ����������� ��������
      PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                   , inUserId     := vbUserId
                                    );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.21         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_OrderSale (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
