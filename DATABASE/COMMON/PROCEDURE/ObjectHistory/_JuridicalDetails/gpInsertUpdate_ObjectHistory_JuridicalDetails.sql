-- Function: gpInsertUpdate_ObjectHistory_JuridicalDetails ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_JuridicalDetails(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент истории реквизитов юр. лиц>
    IN inJuridicalId            Integer,    -- Юр. лицо
    IN inOperDate               TDateTime,  -- Дата действия прайс-листа

    IN inBankId                 Integer,    -- Банк
    IN inFullName               TVarChar,   -- Юр. лицо полное наименование
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
DECLARE 
  vbJuridicalId_find Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());


   -- проверка уникальность <ОКПО>
   IF inOKPO <> ''
   THEN
       -- находим Юр. лицо
       SELECT MAX (ObjectHistory.ObjectId) INTO vbJuridicalId_find
       FROM ObjectHistoryString
            JOIN ObjectHistory ON ObjectHistory.Id = ObjectHistoryString.ObjectHistoryId
                              AND ObjectHistory.ObjectId <> inJuridicalId
                              AND ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
       WHERE ObjectHistoryString.ValueData = inOKPO
         AND ObjectHistoryString.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO();
       --
       IF vbJuridicalId_find > 0
       THEN
           RAISE EXCEPTION 'Ошибка. Значение ОКПО <%> уже установлено у <%>.', inOKPO, lfGet_Object_ValueData (vbJuridicalId_find);
       END IF;
   END IF;

   -- проверка уникальность <Юр. лицо полное наименование>
   IF inFullName <> '' AND inJuridicalId NOT IN (14888, 14887, 14886, 14885, 14884)
   THEN
       -- находим Юр. лицо
       SELECT MAX (ObjectHistory.ObjectId) INTO vbJuridicalId_find
       FROM ObjectHistoryString
            JOIN ObjectHistory ON ObjectHistory.Id = ObjectHistoryString.ObjectHistoryId
                              AND ObjectHistory.ObjectId <> inJuridicalId
                              AND ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
       WHERE ObjectHistoryString.ValueData = inFullName
         AND ObjectHistoryString.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName();
       --
       IF vbJuridicalId_find > 0
       THEN
           RAISE EXCEPTION 'Ошибка. Значение полное наименование <%> уже установлено у <%>.', inFullName, lfGet_Object_ValueData (vbJuridicalId_find);
       END IF;
   END IF;

   -- Вставляем или меняем объект историю
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
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.01.14                                        * add проверка уникальность  <Юр. лицо полное наименование>
 05.01.14                                        * add проверка уникальность <ОКПО>
 03.01.14                                        *Cyr1251
 28.11.13                        *
*/
