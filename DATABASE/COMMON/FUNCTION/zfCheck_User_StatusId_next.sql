-- Function: zfCheck_User_StatusId_next - ������������, ���� �������� ���������� StatusId_next 

DROP FUNCTION IF EXISTS zfCheck_User_StatusId_next (Integer);

CREATE OR REPLACE FUNCTION zfCheck_User_StatusId_next(
    IN inUserId    Integer
)
RETURNS Boolean
AS
$BODY$
BEGIN

    -- ��� ���� ������ - ���
    IF  inUserId IN (zc_Enum_Process_Auto_PrimeCost()
                   , zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_Kopchenie(), zc_Enum_Process_Auto_Defroster()
                   , zc_Enum_Process_Auto_PartionDate()
                    )
    THEN
        RETURN FALSE;

    -- ���� ����� - StatusId_next ������ ��� �����
    ELSEIF inUserId = 5 OR 1=0
    THEN
        -- �������� - ��
        RETURN TRUE;

    ELSE
        -- �������� ���� - ���
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
-- SELECT * FROM zfCheck_User_StatusId_next (5)
