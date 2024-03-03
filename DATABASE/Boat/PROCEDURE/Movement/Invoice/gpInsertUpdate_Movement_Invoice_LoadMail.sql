-- Function: gpInsertUpdate_Movement_Invoice_LoadMail()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice_LoadMail (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Invoice_LoadMail(
 INOUT ioId                      Integer  ,  --
    IN inSubject                 TVarChar ,  -- Номер документа
    IN inSession                 TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbObjectId Integer;
   DECLARE vbAmount TFloat;
   
   DECLARE vbPartner TVarChar;
   DECLARE vbAmountStr TVarChar;
   DECLARE vbPos Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    --проверка, если заказ проведен сумму и дату счета уже менять нельзя
    IF COALESCE (ioId, 0) <> 0
    THEN
      RAISE EXCEPTION 'Ошибка. Процедура для создание новых документов.';
    END IF;
    
    -- Ищем партнера
    vbPartner := SPLIT_PART (inSubject, ',', 1)||' '||SPLIT_PART (inSubject, ',', 2);

    WHILE length(vbPartner) >= 3 LOOP
      IF EXISTS(SELECT Object_Partner.Id
                FROM Object AS Object_Partner
                WHERE Object_Partner.DescId = zc_Object_Partner()
                  AND Object_Partner.isErased = False
                  AND Object_Partner.ValueData ILIKE vbPartner||'%')
      THEN
        SELECT Object_Partner.Id
        INTO vbObjectId
        FROM Object AS Object_Partner
        WHERE Object_Partner.DescId = zc_Object_Partner()
          AND Object_Partner.isErased = False
          AND Object_Partner.ValueData ILIKE vbPartner||'%'
        ORDER BY ID DESC
        LIMIT 1;
      
        EXIT;
      END IF;
      
      -- теперь следуюющий
      vbPartner := SUBSTRING(vbPartner, 1, length(vbPartner) - 1);
    END LOOP;    

    -- Ищем сумму
    vbPartner := TRIM(inSubject);
    vbPos := Length(vbPartner);
    vbAmountStr := '';
    WHILE SUBSTRING(vbPartner, vbPos, 1) <> ' ' LOOP

      IF SUBSTRING(vbPartner, vbPos, 1) in ('.',',','0','1','2','3','4','5','6','7','8','9')
      THEN
        IF SUBSTRING(vbPartner, vbPos, 1) = ',' 
        THEN
          vbAmountStr := '.'||vbAmountStr;        
        ELSE
          vbAmountStr := SUBSTRING(vbPartner, vbPos, 1)||vbAmountStr;
        END IF;
      END IF;

      -- теперь следуюющий
      vbPos := vbPos - 1;
    END LOOP;    
    
    -- сохранили <>
    IF vbAmountStr <> ''
    THEN
      BEGIN  
        vbAmount := vbAmountStr::TFloat;
      EXCEPTION WHEN others THEN vbAmount := Null;
      END;
    END IF;     
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Invoice(), NEXTVAL ('movement_Invoice_seq'):: TVarChar, CURRENT_DATE, Null, 0);

    -- сохранили связь с <>
    IF COALESCE(vbObjectId, 0) <> 0
    THEN
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Object(), ioId, vbObjectId);
    END IF;
    -- Сохранили свойство <Итого Сумма>
    IF COALESCE(vbAmount, 0) <> 0
    THEN
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, -1 * vbAmount);
    END IF;
    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inSubject);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, True);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.02.24                                                       *

*/

-- select * from gpInsertUpdate_Movement_Invoice_LoadMail(ioId := 0, inSubject := 'NUMAN 1234,56', inSession := '5');