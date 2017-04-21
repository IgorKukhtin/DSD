-- Function: gpInsertUpdate_MovementItem_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Visit (Integer, Integer, TVarChar, TBlob, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Visit(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPhotoMobileName     TVarChar  , -- 
    IN inPhotoData           TBlob     , --
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPhotoMobileId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Visit());

    IF COALESCE(ioId,0) <> 0 
    THEN
        --Находим существующий элемент по ObjectCode = ioId
        vbPhotoMobileId := (SELECT Object_PhotoMobile.Id
                            FROM Object AS Object_PhotoMobile
                            WHERE Object_PhotoMobile.DescId = zc_Object_PhotoMobile()
                              AND Object_PhotoMobile.ObjectCode = ioId); 
    
    ELSE 
        IF COALESCE (inPhotoMobileName,'') <> ''
           THEN
               -- сохраняем новый элемент
               vbPhotoMobileId := lpInsertUpdate_Object (0, zc_Object_PhotoMobile(), 0, TRIM (inPhotoMobileName));
           END IF;
    END IF;
	    
    -- сохранили
    ioId:= lpInsertUpdate_MovementItem_Visit (ioId             := COALESCE(ioId,0)
                                            , inMovementId     := inMovementId
                                            , inPhotoMobileId  := COALESCE(vbPhotoMobileId,0)
                                            , inComment        := inComment
                                            , inUserId         := vbUserId
                                            );

   -- обновляем элемент фото
   PERFORM lpInsertUpdate_Object_PhotoMobile (vbPhotoMobileId, ioId, TRIM (inPhotoMobileName), inPhotoData, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.   Воробкало А.А.
 26.03.17         *
*/

-- тест
-- 