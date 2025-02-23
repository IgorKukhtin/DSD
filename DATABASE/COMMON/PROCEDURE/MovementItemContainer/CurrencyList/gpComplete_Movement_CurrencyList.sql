-- Function: gpComplete_Movement_CurrencyList()

DROP FUNCTION IF EXISTS gpComplete_Movement_CurrencyList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_CurrencyList(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
 RETURNS void
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Currency());


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- �������� ��������
     PERFORM lpComplete_Movement_CurrencyList (inMovementId := inMovementId
                                             , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Currency (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
