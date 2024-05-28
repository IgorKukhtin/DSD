-- Function: gpInsertUpdate_MI_Send_PartionCell_edit()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell_edit (Integer, Integer, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Boolean, Boolean, Boolean, Boolean, Boolean,  TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Send_PartionCell_edit(
    IN inId                       Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId               Integer   , -- Ключ объекта <Документ>
    IN inPartionCell_Last         TFloat    ,
    IN inPartionCell_Amount_1     TFloat   , -- 
    IN inPartionCell_Amount_2     TFloat   ,
    IN inPartionCell_Amount_3     TFloat   ,
    IN inPartionCell_Amount_4     TFloat   ,
    IN inPartionCell_Amount_5     TFloat   ,
    
    IN inisPartionCell_Close_1    Boolean   , -- 
    IN inisPartionCell_Close_2    Boolean   ,
    IN inisPartionCell_Close_3    Boolean   ,
    IN inisPartionCell_Close_4    Boolean   ,
    IN inisPartionCell_Close_5    Boolean   ,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;
  
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Last(), inId, inPartionCell_Last);

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Amount_1(), inId, inPartionCell_Amount_1);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Amount_2(), inId, inPartionCell_Amount_2);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Amount_3(), inId, inPartionCell_Amount_3);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Amount_4(), inId, inPartionCell_Amount_4);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Amount_5(), inId, inPartionCell_Amount_5);


    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inId, inisPartionCell_Close_1);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), inId, inisPartionCell_Close_2);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), inId, inisPartionCell_Close_3);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), inId, inisPartionCell_Close_4);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), inId, inisPartionCell_Close_5);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.12.23         *
*/

-- тест
--