-- Function: zfGet_AccessKey_onUnit

DROP FUNCTION IF EXISTS zfGet_AccessKey_onUnit (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfGet_AccessKey_onUnit (inUnitId Integer, inProcessId Integer, inUserId Integer)
RETURNS Integer
AS
$BODY$
 DECLARE vbAccessKeyId Integer;
BEGIN
     vbAccessKeyId:= CASE WHEN inUnitId IN (8411   -- Склад ГП ф Киев
                                          , 428365 -- Склад возвратов ф.Киев
                                           )
                              THEN zc_Enum_Process_AccessKey_DocumentKiev()

                          WHEN inUnitId IN (346093 -- Склад ГП ф.Одесса
                                          , 346094 -- Склад возвратов ф.Одесса
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa()

                          WHEN inUnitId IN (8413   -- Склад ГП ф.Кривой Рог
                                          , 428366 -- Склад возвратов ф.Кривой Рог
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog()

                          WHEN inUnitId IN (8417   -- Склад ГП ф.Николаев (Херсон)
                                          , 428364 -- Склад возвратов ф.Николаев (Херсон)
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev()

                          WHEN inUnitId IN (8425   -- Склад ГП ф.Харьков
                                          , 409007 -- Склад возвратов ф.Харьков
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov()

                          WHEN inUnitId IN (8415   -- Склад ГП ф.Черкассы (Кировоград)
                                          , 428363 -- Склад возвратов ф.Черкассы (Кировоград)
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi()

                          WHEN inUnitId IN (301309 -- Склад ГП ф.Запорожье
                                          , 309599 -- Склад возвратов ф.Запорожье
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye()

                          WHEN inUnitId IN (3080691 -- Склад ГП ф.Львов
                                          , 3080696 -- Склад возвратов ф.Львов
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentLviv()

                          WHEN inUnitId IN (11921035 -- Склад ГП ф.Вінниця
                                          , 11921036 -- Склад повернень ф.Вінниця
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentVinnica()

                          WHEN inUnitId IN (8020714 -- Склад База ГП (Ирна)
                                          , 8020715 -- Склад Возвратов (Ирна)
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentIrna()

                          ELSE lpGetAccessKey (inUserId, inProcessId)

                     END;
     --
     RETURN (vbAccessKeyId);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.03.2025                                      *
*/

-- тест
-- SELECT zfGet_AccessKey_onUnit (346093, 5, zc_Enum_Process_InsertUpdate_Movement_Loss()) -- Склад ГП ф.Одесса
