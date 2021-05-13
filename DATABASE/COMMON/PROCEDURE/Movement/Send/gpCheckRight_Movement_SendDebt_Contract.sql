-- Function: gpCheckRight_Movement_SendDebt_Contract()

DROP FUNCTION IF EXISTS gpCheckRight_Movement_SendDebt_Contract (TVarChar);

CREATE OR REPLACE FUNCTION gpCheckRight_Movement_SendDebt_Contract(
    IN inSession          TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendDebt_Contract());

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.05.21         *
*/