-- Function: gpCheckRight_Movement_Promo()

DROP FUNCTION IF EXISTS gpCheckRight_Movement_Promo (TVarChar);

CREATE OR REPLACE FUNCTION gpCheckRight_Movement_Promo(
    IN inSession          TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.01.19         *
*/