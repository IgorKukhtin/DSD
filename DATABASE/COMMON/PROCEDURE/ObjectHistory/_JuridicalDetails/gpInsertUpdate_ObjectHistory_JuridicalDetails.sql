-- Function: gpInsertUpdate_ObjectHistory_JuridicalDetails()

DROP FUNCTION IF EXISTS 
     gpInsertUpdate_ObjectHistory_JuridicalDetails(Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_JuridicalDetails(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент истории реквизитов юр. лиц>
    IN inJuridicalId            Integer,    -- Юр. лицо
    IN inOperDate               TDateTime,  -- Дата действия прайс-листа

    IN inBankId                 Integer,    -- Банк
    IN inFullName               TVarChar,   -- Юр. лицо полное название
    IN inJuridicalAddress	TVarChar,   -- Юридический адрес
    IN inOKPO                   TVarChar,   -- ОКПО
    IN inINN	                TVarChar,   -- ИНН
    IN inNumberVAT	        TVarChar,   -- Номер свидетельства плательщика НДС
    IN inAccounterName	        TVarChar,   -- ФИО бухг.
    IN inBankAccount	        TVarChar,   -- р.счет
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());


   -- Вставляем или меняем объект историю цен
   ioId := lpInsertUpdate_ObjectHistory(ioId, zc_ObjectHistory_JuridicalDetails(), inJuridicalId, inOperDate);

   -- Банк
   PERFORM lpInsertUpdate_ObjectHistoryLink(zc_ObjectHistoryLink_JuridicalDetails_Bank(), ioId, inBankId);

   -- Юр. лицо полное название
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_FullName(), ioId, inFullName);
   -- Юридический адрес
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress(), ioId, inJuridicalAddress);
   -- ОКПО
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_OKPO(), ioId, inOKPO);
   -- ИНН
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_INN(), ioId, inINN);
   -- Номер свидетельства плательщика НДС
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_NumberVAT(), ioId, inNumberVAT);
   -- ФИО бухг.
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_AccounterName(), ioId, inAccounterName);
   -- р.счет
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_BankAccount(), ioId, inBankAccount);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.11.13                        *

*/
