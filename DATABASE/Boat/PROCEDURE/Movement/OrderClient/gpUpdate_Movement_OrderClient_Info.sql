-- Function: gpUpdate_Movement_OrderClient_Info()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Info(Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderClient_Info(
    IN inId                  Integer   , -- Ключ объекта <>
    IN inCodeInfo            Integer   , -- код информации
    IN inText_Info           TBlob     , -- информация
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
    vbUserId := lpGetUserBySession (inSession);
    
    IF COALESCE (inCodeInfo,0) = 0    -- Создание строк Информации
    THEN
        -- проверяем сколько строк уже есть , может быть не не больше 3 (3 деска)
        vbCode := COALESCE ( (SELECT MAX (tmp.CodeInfo) FROM gpSelect_Movement_OrderClient_Info (inMovementId:= inId, inSession:= inSession) AS tmp), 0) ;
        --
        IF vbCode >= 3   -- на всякий случай 
        THEN
            -- ошибка
            RAISE EXCEPTION 'Ошибка. 3 реквизита информации заполнены.';
           -- RETURN;
        END IF;
        inCodeInfo := vbCode + 1;
    ENd IF;

    --сохраяем
        IF inCodeInfo = 1
        THEN
            PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Info1(), inId, inText_Info);
        ENd IF;
        IF inCodeInfo = 2
        THEN
            PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Info2(), inId, inText_Info);
        ENd IF;
        IF inCodeInfo = 3
        THEN
            PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Info3(), inId, inText_Info);
        ENd IF;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.03.21         *
*/

-- тест
--