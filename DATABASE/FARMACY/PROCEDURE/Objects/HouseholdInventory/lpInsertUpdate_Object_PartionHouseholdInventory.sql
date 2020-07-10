-- Function: lpInsertUpdate_Object_PartionHouseholdInventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionHouseholdInventory (Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PartionHouseholdInventory(
 INOUT ioId                     Integer   ,     -- ключ объекта <>
    IN inInvNumber              Integer   ,     -- Инвентарный номер
    IN inUnitId                 Integer   ,     -- Подразделение
    IN inMovementItemId         Integer   ,     -- Ключ элемента прихода хозяйственного инвентаря
    IN inUserId                 Integer     -- пользователь
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
--   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_HouseholdInventory());

   IF COALESCE (inInvNumber, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка. Не заполнено <Инвентарный номер>...';
   END IF;

   -- пытаемся найти ID
   IF EXISTS(SELECT Object.ID FROM Object 
             WHERE Object.DescId = zc_Object_PartionHouseholdInventory()
               AND Object.ObjectCode = inInvNumber) 
   THEN 
     SELECT Object.ID FROM Object 
     INTO ioId
     WHERE Object.DescId = zc_Object_PartionHouseholdInventory()
       AND Object.ObjectCode = inInvNumber;
   ELSE
     ioId := 0;
   END IF;
   
   IF COALESCE (ioId, 0) = 0 AND COALESCE (inMovementItemId, 0) = 0
   THEN 
      RETURN;
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PartionHouseholdInventory(), inInvNumber, inInvNumber::TVarChar);
   
   -- сохранили 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionHouseholdInventory_MovementItemId(), ioId, inMovementItemId);

   -- сохранили 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartionHouseholdInventory_Unit(), ioId, inUnitId);
   
   -- сохранили протокол
--   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_PartionHouseholdInventory (Integer, Integer, Integer, Integer, Integer) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.07.20                                                       *
*/

-- тест
-- 