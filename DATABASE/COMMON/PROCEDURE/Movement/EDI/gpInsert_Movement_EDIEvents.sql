-- Function: gpInsertUpdate_MI_EDI()

-- DROP FUNCTION IF EXISTS gpInsert_Movement_EDIEvents(Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_EDIEvents (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_EDIEvents(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inDocumentId          TVarChar  , --
    IN inVchasnoId           TVarChar  , --
    IN inEDIEvent            TVarChar  , -- Описание события
    IN inSession             TVarChar    -- Пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCount  Integer;
   DECLARE vbCount_in Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);


    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.inMovementId = 0.';
    END IF;


   IF TRIM (COALESCE (inDocumentId, '')) <> ''
   THEN
       PERFORM lpInsertUpdate_MovementString (zc_MovementString_DocumentId_vch(), inMovementId, inDocumentId);
   END IF;


   IF TRIM (COALESCE (inVchasnoId, '')) <> ''
   THEN
       PERFORM lpInsertUpdate_MovementString (zc_MovementString_VchasnoId(), inMovementId, inVchasnoId);
   END IF;


   IF SUBSTRING (inEDIEvent FROM 1 FOR 1) = '{'
   THEN
        --
        vbCount:= (SELECT COUNT(*)
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId     = zc_MI_Master()
                     AND MovementItem.isErased   = FALSE);
        --
        vbCount_in:= zfConvert_StringToFloat (SUBSTRING (inEDIEvent FROM 2 FOR POSITION ('}' IN inEDIEvent) - 2)) :: Integer;
        --
        PERFORM lpInsert_Movement_EDIEvents (inMovementId
                                           , CASE WHEN vbCount <> vbCount_in
                                                       THEN 'Ошибка.Загружено {' || (vbCount :: TVarChar) || '} строк из {' || (vbCount_in :: TVarChar) || '}.'
                                                  ELSE ''
                                             END
                                          || SUBSTRING (inEDIEvent
                                                        FROM POSITION ('}' IN inEDIEvent) + 1
                                                        FOR  LENGTH (inEDIEvent) - POSITION ('}' IN inEDIEvent)
                                                       )
                                           , vbUserId);
   ELSE
        PERFORM lpInsert_Movement_EDIEvents (inMovementId, inEDIEvent, vbUserId);
   END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.14                         *

*/

-- тест
-- SELECT * FROM gpInsert_Movement_EDIEvents (inMovementId:= 16086413, inEDIEvent:= '{8}Загрузка ORDER из EDI завершена _order_20200311114504000_Zpp00048733.xml_', inSession:= '2')
