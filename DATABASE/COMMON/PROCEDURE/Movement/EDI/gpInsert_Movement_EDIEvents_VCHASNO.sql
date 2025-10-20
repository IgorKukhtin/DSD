-- Function: gpInsertUpdate_MI_EDI() - Криво для Vchasno - ДРУГОЙ НАБОР ПАРАМЕТРОВ

-- DROP FUNCTION IF EXISTS gpInsert_Movement_EDIEvents (Integer, TVarChar, TVarChar, TVarChar, TVarChar); - пока не удалять, здесь параметры для Project
-- DROP FUNCTION IF EXISTS gpInsert_Movement_EDIEvents (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_EDIEvents (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_EDIEvents(
    IN inMovementId          Integer   , -- Ключ объекта <Документ-EDI>
    IN inMovementId_send     Integer   , -- Ключ объекта <Документ-Отправка-EDI>
    IN inDocumentId          TVarChar  , --
    IN inVchasnoId           TVarChar  , --
    IN inId_doc              TVarChar  , -- ІД doc Desadv у системі ВЧАСНО
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


   -- если режим Condra
   IF TRIM (inId_doc) <> '' AND TRIM (inDocumentId) <> ''
   THEN
       -- проверили что есть ІД doc Desadv
       IF NOT EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_DocId_vch() AND MS.ValueData = inId_doc)
       THEN
           RAISE EXCEPTION 'Ошибка.Не найден ІД Desadv = <%>.', inId_doc;
       END IF;

       -- сохранили ІД doc Condra
       PERFORM lpInsertUpdate_MovementString (zc_MovementString_DocId_vch_Condra(), inMovementId, inDocumentId);

   ELSEIF TRIM (inId_doc) <> ''
   THEN
       -- сохранили ІД doc Desadv
       PERFORM lpInsertUpdate_MovementString (zc_MovementString_DocId_vch(), inMovementId, inId_doc);
   END IF;

   -- + не режим Condra
   IF TRIM (COALESCE (inDocumentId, '')) <> '' AND TRIM (COALESCE (inId_doc, '')) = ''
   THEN
       -- сохранили DocumentId
       PERFORM lpInsertUpdate_MovementString (zc_MovementString_DocumentId_vch(), inMovementId, inDocumentId);
   END IF;

   -- сохранили VchasnoId
   IF TRIM (COALESCE (inVchasnoId, '')) <> ''
   THEN
       PERFORM lpInsertUpdate_MovementString (zc_MovementString_VchasnoId(), inMovementId, inVchasnoId);
   END IF;


   -- сохранили Протокол
   IF TRIM (inId_doc) <> '' OR TRIM (inDocumentId) <> '' OR TRIM (inVchasnoId) <> ''
   THEN
       PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
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
