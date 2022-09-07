-- Function: gpUpdate_Unit_SetDateRRO()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SetDateRRO(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SetDateRRO(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inSetDateRRO          TDateTime ,    -- Автопростановка ОС	
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDate TVarChar;
   DECLARE vbDateListOld TVarChar;
   DECLARE vbDateListNew TVarChar;
   DECLARE vbIndex Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   vbDate := zfConvert_DateToString (inSetDateRRO);
   vbDateListNew := '';
   
   vbDateListOld := COALESCE ((SELECT ObjectString_SetDateRROList.ValueData  
                               FROM ObjectString AS ObjectString_SetDateRROList
                               WHERE ObjectString_SetDateRROList.ObjectId = inId
                                 AND ObjectString_SetDateRROList.DescId = zc_ObjectString_Unit_SetDateRROList()), '');
   
   -- парсим даты
   vbIndex := 1;
   WHILE SPLIT_PART (vbDateListOld, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        IF SPLIT_PART (vbDateListOld, ',', vbIndex) <> vbDate
        THEN
          IF vbDateListNew <> ''
          THEN
            vbDateListNew := vbDateListNew||',';
          END IF;
          vbDateListNew := vbDateListNew||SPLIT_PART (vbDateListOld, ',', vbIndex);
        ELSE
          vbDate := '';
        END IF;
          
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
   END LOOP;
   
   IF vbDate <> ''
   THEN
      IF vbDateListNew <> ''
      THEN
        vbDateListNew := vbDateListNew||',';
      END IF;
      vbDateListNew := vbDateListNew||vbDate;   
   END IF;

   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_SetDateRROList(), inId, vbDateListNew);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.09.22                                                       *
*/