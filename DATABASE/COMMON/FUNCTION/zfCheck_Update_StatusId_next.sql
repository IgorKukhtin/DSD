-- Function: zfCheck_Update_StatusId_next - ���� ����������, ���� StatusId �� �������� �� zc_Enum_Status_UnComplete

DROP FUNCTION IF EXISTS zfCheck_Update_StatusId_next (Integer, Integer);

CREATE OR REPLACE FUNCTION zfCheck_Update_StatusId_next(
    IN inStatusId_old    Integer,
    IN inMovementDescId  Integer
)
RETURNS Boolean
AS
$BODY$
BEGIN

    -- ����� - StatusId_next ������ ��� �����
    IF inMovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()
                          , zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_Loss()
                          , zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()
                          , zc_Movement_Sale(), zc_Movement_ReturnIn()
                          , zc_Movement_Inventory()
                           )
       -- ���� ��� ��������
       AND inStatusId_old = zc_Enum_Status_Complete()
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

END;
$BODY$
LANGUAGE PLPGSQL IMMUTABLE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.04.25                                        *
*/

-- ����
-- SELECT * FROM zfCheck_Update_StatusId_next (zc_Enum_Status_Complete(), zc_Movement_Sale())
