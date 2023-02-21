-- Function: lpComplete_Movement_Currency()

DROP FUNCTION IF EXISTS lpComplete_Movement_CurrencyList (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_CurrencyList(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
 RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate TDateTime;
  DECLARE vbStatusId Integer;
  DECLARE vbCurrencyId Integer;
  DECLARE vbPaidKindId Integer;
  DECLARE vbCurrencyValue TFloat;
  DECLARE vbParValue TFloat;
BEGIN
  
     -- 5.1. ����� - ���������/��������� ��������
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- RAISE EXCEPTION 'ok' ;
     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_CurrencyList()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.02.23         *
*/

-- ����
--