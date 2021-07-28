-- Function: gpUpdate_Object_Maker_SendDate (Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Maker_SendDate (Integer,Integer,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Maker_SendDate(
 INOUT ioId              Integer   ,    -- ключ объекта <Производитель>
    IN inAddMonth        Integer   ,    -- Добавить месяц к отправке
    IN inAddDay          Integer   ,    -- Добавить дни к отправке
    IN inisCurrMonth     Boolean   ,    -- Отправка текущего месяца
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSendPlan TDateTime;    
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Maker());
   vbUserId := inSession; 

   IF not EXISTS(SELECT * FROM Object WHERE Object.DescId = zc_Object_Maker() and Object.Id = ioId)
   THEN
        RAISE EXCEPTION 'Ошибка.Производитель не найден.'; 
   END IF;

   IF EXISTS(SELECT * FROM ObjectDate WHERE ObjectDate.DescId = zc_ObjectDate_Maker_SendPlan() and ObjectDate.ObjectId = ioId)
      AND COALESCE (inisCurrMonth, FALSE) = FALSE
   THEN
     SELECT 
       ObjectDate.ValueData
     INTO
       vbSendPlan
     FROM ObjectDate 
     WHERE ObjectDate.DescId = zc_ObjectDate_Maker_SendPlan() and ObjectDate.ObjectId = ioId;
     
     IF COALESCE (inAddDay, 0) = 0 
     THEN
       IF COALESCE (inAddMonth, 0) <> 0 
       THEN
         vbSendPlan := vbSendPlan + inAddMonth * interval '1 month';
       ELSE
         vbSendPlan := vbSendPlan + interval '1 month';       
       END IF;
     ELSE
       IF COALESCE (inAddDay, 0) = 15 or COALESCE (inAddDay, 0) = 14
       THEN
         IF date_part('day', vbSendPlan) < (inAddDay + 1)
         THEN
           vbSendPlan := vbSendPlan + inAddDay * interval '1 day';     
         ELSE
           vbSendPlan := vbSendPlan - inAddDay * interval '1 day';     
           vbSendPlan := vbSendPlan + interval '1 month';         
         END IF;
       ELSE
         vbSendPlan := vbSendPlan + inAddDay * interval '1 day';     
       END IF;
     END IF;

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_SendPlan(), ioId, vbSendPlan);
     
   END IF;

   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_SendReal(), ioId, CURRENT_TIMESTAMP);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.02.19                                                       *
 25.01.19                                                       *
 
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Maker_SendDate()