-- Function: gpUpdate_Movement_Check_MedicForSale()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_MedicForSale (Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_MedicForSale(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inMedicForSaleId    Integer   , -- Подразделени
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);

    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MedicForSale(), inId, inMedicForSaleId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.06.22                                                       *
*/
-- тест
-- select * from gpUpdate_Movement_Check_MedicForSale(inId := 7784533 , inMedicForSaleId := 183294 ,  inSession := '3');
