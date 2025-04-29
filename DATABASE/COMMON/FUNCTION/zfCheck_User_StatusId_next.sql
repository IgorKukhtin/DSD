-- Function: zfCheck_User_StatusId_next - Пользователи, если отдельно заполнение StatusId_next 

DROP FUNCTION IF EXISTS zfCheck_User_StatusId_next (Integer);

CREATE OR REPLACE FUNCTION zfCheck_User_StatusId_next(
    IN inUserId    Integer
)
RETURNS Boolean
AS
$BODY$
BEGIN

    -- Для него ВСЕГДА - НЕТ
    IF  inUserId IN (zc_Enum_Process_Auto_PrimeCost()
                   , zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_Kopchenie(), zc_Enum_Process_Auto_Defroster()
                   , zc_Enum_Process_Auto_PartionDate()
                    )
    THEN
        RETURN FALSE;

    -- Нова Схема - StatusId_next только для таких
    ELSEIF inUserId = 5 OR 1=0
    THEN
        -- Временно - ДА
        RETURN TRUE;

    ELSE
        -- Временно ВСЕМ - НЕТ
        RETURN FALSE;
    END IF;

END;
$BODY$
LANGUAGE PLPGSQL IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.25                                        *
*/

-- тест
-- SELECT * FROM zfCheck_User_StatusId_next (5)
