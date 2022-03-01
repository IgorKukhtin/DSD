-- Function: gpSelect_TelegramBot_ProcesMessages()

DROP FUNCTION IF EXISTS gpSelect_TelegramBot_ProcesMessages (Integer, Text);

CREATE OR REPLACE FUNCTION gpSelect_TelegramBot_ProcesMessages(
    IN inChatId      Integer ,
    IN inText        Text    , -- 
   OUT outResult     Text      -- 
)
RETURNS Text
AS
$BODY$
   DECLARE text_var1 Text;
   DECLARE vbOperDate TDateTime;
   DECLARE vbExchange TFloat;
BEGIN
   outResult := '';
   
   IF inChatId IN (568330367, 300408824)
   THEN
   
     IF SPLIT_PART (inText, '\n', 1) = 'Курс'
     THEN
     
       BEGIN
          vbOperDate := REPLACE(SPLIT_PART (inText, '\n', 2), '.', '/')::TDateTime;
       EXCEPTION
         WHEN others THEN
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;          
         outResult := 'Ошибка преобразования даты\n\n'||SPLIT_PART (inText, '\n', 2);
         RETURN;
       END;

       IF vbOperDate IS NULL
       THEN
         outResult := 'Ошибка преобразования даты\n\n'||SPLIT_PART (inText, '\n', 2);
         RETURN;
       END IF;
            
       BEGIN
          vbExchange := REPLACE(SPLIT_PART (inText, '\n', 3), ',', '.')::TFloat;
       EXCEPTION
         WHEN others THEN
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;          
         outResult := 'Ошибка преобразования курса\n\n'||SPLIT_PART (inText, '\n', 3);
         RETURN;
       END;
       
       IF date_trunc('DAY', vbOperDate) < CURRENT_DATE
       THEN
         outResult := 'Изменить курс адним числом запрещено\n\n'||zfConvert_DateShortToString(vbOperDate)::Text;
         RETURN;
       END IF;
              
       BEGIN
         PERFORM gpInsertUpdate_Object_ExchangeRates(ioId         :=  COALESCE((SELECT tmp.Id FROM gpSelect_Object_ExchangeRates(False, zfCalc_UserAdmin()) AS tmp WHERE tmp.OperDate = vbOperDate), 0)
                                                   , inOperDate   := vbOperDate
                                                   , inExchange   := vbExchange
                                                   , inSession    := zfCalc_UserAdmin());
       EXCEPTION
         WHEN others THEN
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;          
         outResult := 'Ошибка сохранения курса\n\n'||text_var1;
         RETURN;
       END;

       SELECT 'Курс '||zfConvert_FloatToString(tmp.Exchange)||' на '||zfConvert_DateShortToString(tmp.OperDate)||' установлен.\nПроц. измен. '||zfConvert_FloatToString(tmp.PercentСhange)
       INTO outResult
       FROM gpSelect_Object_ExchangeRates(False, zfCalc_UserAdmin()) AS tmp WHERE tmp.OperDate = vbOperDate;

     ELSE
       outResult := 'Неизвестная комманда\n\n' + inText;
     END IF;
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.02.22                                                       * 
*/

-- тест

select * from gpSelect_TelegramBot_ProcesMessages(inChatId := 568330367, inText := 'Курс\n28.02.2022\n33,00');
