-- Function: gpUpdate_MI_Send_byReport()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_byReport (Integer, Integer, Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_byReport(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId        Integer   , -- Ключ объекта <Элемент документа>  
    IN inGoodsId               Integer  ,
    IN inGoodsKindId           Integer  ,
    IN inPartionGoodsDate      TDateTime , -- 
 INOUT ioPartionCellName_1     TVarChar   , -- 
 INOUT ioPartionCellName_2     TVarChar   ,
 INOUT ioPartionCellName_3     TVarChar   ,
 INOUT ioPartionCellName_4     TVarChar   ,
 INOUT ioPartionCellName_5     TVarChar   ,
 INOUT ioPartionCellName_6     TVarChar   , -- 
 INOUT ioPartionCellName_7     TVarChar   ,
 INOUT ioPartionCellName_8     TVarChar   ,
 INOUT ioPartionCellName_9     TVarChar   ,
 INOUT ioPartionCellName_10    TVarChar   ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

  
 
 
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.24         *
*/

-- тест
--