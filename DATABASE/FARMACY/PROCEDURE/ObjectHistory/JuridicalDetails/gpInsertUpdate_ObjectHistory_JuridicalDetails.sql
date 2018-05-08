-- Function: gpInsertUpdate_ObjectHistory_JuridicalDetails ()
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer,  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer,  TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails 
    (Integer, Integer,  TDateTime, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails 
    (Integer, Integer,  TDateTime, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails 
    (Integer, Integer,  TDateTime, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_JuridicalDetails(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент истории реквизитов юр. лиц>
    IN inJuridicalId            Integer,    -- Юр. лицо
    IN inOperDate               TDateTime,  -- Дата действия прайс-листа
    IN inDecisionDate           TDateTime,  -- Дата рішення про видачу ліцензії
    IN inBankId                 Integer,    -- Банк
    IN inFullName               TVarChar,   -- Юр. лицо полное наименование
    IN inJuridicalAddress	TVarChar,   -- Юридический адрес
    IN inOKPO                   TVarChar,   -- ОКПО
    IN inINN	                TVarChar,   -- ИНН
    IN inNumberVAT	        TVarChar,   -- Номер свидетельства плательщика НДС
    IN inAccounterName	        TVarChar,   -- ФИО бухг.
    IN inBankAccount	        TVarChar,   -- р.счет
    IN inPhone      	        TVarChar,   -- телефон
    IN inMainName     	        TVarChar,   -- ФИО директора
    IN inMainName_Cut  	        TVarChar,   -- ФИО директора (для подписи)
    IN inReestr     	        TVarChar,   -- Витяг з реєстру платників ПДВ
    IN inDecision     	        TVarChar,   -- № рішення про видачу ліцензії
    IN inLicense                TVarChar,   -- № ліцензії
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
    DECLARE vbJuridicalId_find Integer;
    DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

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
           RAISE EXCEPTION 'Ошибка.Значение ОКПО <%> уже установлено у <%>.', inOKPO, lfGet_Object_ValueData (vbJuridicalId_find);
       END IF;
   END IF;

   -- проверка уникальность <Юр. лицо полное наименование>
   IF inFullName <> '' AND inFullName <> 'ДП "Придніпровська залізниця"'
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
           RAISE EXCEPTION 'Ошибка.Значение полное наименование <%> уже установлено у <%>.', inFullName, lfGet_Object_ValueData (vbJuridicalId_find);
       END IF;
   END IF;

   -- проверка
   IF COALESCE (inJuridicalId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено <Юридическое лицо>.';
   END IF;


   -- Вставляем или меняем объект историю
   ioId := lpInsertUpdate_ObjectHistory(ioId, zc_ObjectHistory_JuridicalDetails(), inJuridicalId, inOperDate, vbUserId);

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
   -- телефон
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_Phone(), ioId, inPhone);

   -- 
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_MainName(), ioId, inMainName);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_MainName_Cut(), ioId, inMainName_Cut);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_Reestr(), ioId, inReestr);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_Decision(), ioId, inDecision);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_License(), ioId, inLicense);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryDate(zc_ObjectHistoryDate_JuridicalDetails_Decision(), ioId, inDecisionDate);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.03.17         *
 06.03.17         *
 04.07.14         *
*/
