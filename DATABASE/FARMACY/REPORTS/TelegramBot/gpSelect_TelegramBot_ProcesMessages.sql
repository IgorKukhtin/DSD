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
   
     IF SPLIT_PART (inText, '\n', 1) = '����'
     THEN
     
       BEGIN
          vbOperDate := REPLACE(SPLIT_PART (inText, '\n', 2), '.', '/')::TDateTime;
       EXCEPTION
         WHEN others THEN
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;          
         outResult := '������ �������������� ����\n\n'||SPLIT_PART (inText, '\n', 2);
         RETURN;
       END;

       IF vbOperDate IS NULL
       THEN
         outResult := '������ �������������� ����\n\n'||SPLIT_PART (inText, '\n', 2);
         RETURN;
       END IF;
            
       BEGIN
          vbExchange := REPLACE(SPLIT_PART (inText, '\n', 3), ',', '.')::TFloat;
       EXCEPTION
         WHEN others THEN
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;          
         outResult := '������ �������������� �����\n\n'||SPLIT_PART (inText, '\n', 3);
         RETURN;
       END;
       
       IF date_trunc('DAY', vbOperDate) < CURRENT_DATE
       THEN
         outResult := '�������� ���� ����� ������ ���������\n\n'||zfConvert_DateShortToString(vbOperDate)::Text;
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
         outResult := '������ ���������� �����\n\n'||text_var1;
         RETURN;
       END;

       SELECT '���� '||zfConvert_FloatToString(tmp.Exchange)||' �� '||zfConvert_DateShortToString(tmp.OperDate)||' ����������.\n����. �����. '||zfConvert_FloatToString(tmp.Percent�hange)
       INTO outResult
       FROM gpSelect_Object_ExchangeRates(False, zfCalc_UserAdmin()) AS tmp WHERE tmp.OperDate = vbOperDate;

     ELSE
       outResult := '����������� ��������\n\n' + inText;
     END IF;
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.02.22                                                       * 
*/

-- ����

select * from gpSelect_TelegramBot_ProcesMessages(inChatId := 568330367, inText := '����\n28.02.2022\n33,00');
