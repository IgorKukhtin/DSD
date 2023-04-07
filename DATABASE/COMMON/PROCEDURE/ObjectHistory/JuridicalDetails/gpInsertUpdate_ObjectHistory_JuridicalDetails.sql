-- Function: gpInsertUpdate_ObjectHistory_JuridicalDetails ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_JuridicalDetails(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент истории реквизитов юр. лиц>
    IN inJuridicalId            Integer,    -- Юр. лицо
    IN inOperDate               TDateTime,  -- Дата действия прайс-листа
    IN inBankId                 Integer,    -- Банк
    IN inName                   TVarChar,   -- Юр. лицо наименование
    IN inFullName               TVarChar,   -- Юр. лицо полное наименование
    IN inJuridicalAddress	    TVarChar,   -- Юридический адрес
    IN inOKPO                   TVarChar,   -- ОКПО
    IN inINN	                TVarChar,   -- ИНН
    IN inNumberVAT	            TVarChar,   -- Номер свидетельства плательщика НДС
    IN inAccounterName	        TVarChar,   -- ФИО бухг.
    IN inMainName	            TVarChar,   -- ФИО директора
    IN inBankAccount	        TVarChar,   -- р.счет
    IN inPhone      	        TVarChar,   -- телефон
    IN inInvNumberBranch        TVarChar,   -- № филиала
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbJuridicalId_find Integer;
 DECLARE vbAddXML TBlob;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);


   -- проверка уникальность <ОКПО>, кроме "виртуальных"
   IF inOKPO <> '' AND NOT (LENGTH (inOKPO) = 5 AND (SUBSTRING (inOKPO, 3, 1) = '-' OR SUBSTRING (inOKPO, 3, 1) = '*'))
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

   -- проверка
   IF TRIM (COALESCE (inOKPO, '')) = '' AND NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = vbUserId)
   THEN
       IF COALESCE (ioId, 0) = 0
       THEN
           inOKPO:= (SELECT ObjectHistoryString_OKPO.ValueData
                     FROM ObjectHistory
                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_OKPO
                                                        ON ObjectHistoryString_OKPO.ObjectHistoryId = ObjectHistory.Id
                                                       AND ObjectHistoryString_OKPO.DescId          = zc_ObjectHistoryString_JuridicalDetails_OKPO()
                     WHERE ObjectHistory.ObjectID = inJuridicalId
                     ORDER BY ObjectHistory.StartDate DESC
                     LIMIT 1
                    );
       END IF;
       --
       IF TRIM (COALESCE (inOKPO, '')) = ''
       THEN
           RAISE EXCEPTION 'Ошибка.Нет прав добавлять с пустым <ОКПО>.';
       END IF;
   END IF;


   -- Вставляем или меняем объект историю
   ioId := lpInsertUpdate_ObjectHistory(ioId, zc_ObjectHistory_JuridicalDetails(), inJuridicalId, inOperDate, vbUserId);

   -- Банк
   PERFORM lpInsertUpdate_ObjectHistoryLink(zc_ObjectHistoryLink_JuridicalDetails_Bank(), ioId, inBankId);

   -- Юр. лицо полное название
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_FullName(), ioId, inFullName);
   -- Юр. лицо название
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_Name(), ioId, inName);
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
   -- ФИО директора
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_MainName(), ioId, inMainName);
   -- р.счет
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_BankAccount(), ioId, inBankAccount);
   -- телефон
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_Phone(), ioId, inPhone);
   -- № филиала
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_InvNumberBranch(), ioId, inInvNumberBranch);


   -- протокол
   SELECT STRING_AGG (D.FieldXML, '') INTO vbAddXML
   FROM
        (SELECT D.FieldXML
         FROM 
          (-- Float
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectHistoryFloatDesc.ItemName) || '" FieldValue = "' || COALESCE (zfConvert_FloatToString (ObjectHistoryFloat.ValueData), 'NULL') || '"/>' AS FieldXML
                , 2 AS GroupId
                , ObjectHistoryFloat.DescId
           FROM ObjectHistoryFloat
                JOIN ObjectHistoryFloatDesc ON ObjectHistoryFloatDesc.Id = ObjectHistoryFloat.DescId
           WHERE ObjectHistoryFloat.ObjectHistoryId = ioId

          UNION
           -- Date
           SELECT '<Field FieldName = "' || zfStrToXmlStr (ObjectHistoryDateDesc.ItemName)
               || '" FieldValue = "' || COALESCE (zfConvert_DateToString (ObjectHistoryDate.ValueData), 'NULL') || '"/>' :: TVarChar AS FieldXML
                , 3 AS GroupId
                , ObjectHistoryDate.DescId
           FROM ObjectHistoryDate
                JOIN ObjectHistoryDateDesc ON ObjectHistoryDateDesc.Id = ObjectHistoryDate.DescId
           WHERE ObjectHistoryDate.ObjectHistoryId = ioId

          UNION
           -- Link
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectHistoryLinkDesc.ItemName) || '" FieldValue = "' || zfStrToXmlStr(COALESCE (Object.ValueData, 'NULL')) || '"/>' AS FieldXML 
                , 4 AS GroupId
                , ObjectHistoryLink.DescId
           FROM ObjectHistoryLink
                JOIN Object ON Object.Id = ObjectHistoryLink.ObjectId
                JOIN ObjectHistoryLinkDesc ON ObjectHistoryLinkDesc.Id = ObjectHistoryLink.DescId
           WHERE ObjectHistoryLink.ObjectHistoryId = ioId

          UNION
           -- String
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectHistoryStringDesc.ItemName)
               || '" FieldValue = "' || zfStrToXmlStr(COALESCE (ObjectHistoryString.ValueData, 'NULL'))
               || '"/>' AS FieldXML 
                , 5 AS GroupId
                , ObjectHistoryString.DescId
           FROM ObjectHistoryString
                JOIN ObjectHistoryStringDesc ON ObjectHistoryStringDesc.Id = ObjectHistoryString.DescId
           WHERE ObjectHistoryString.ObjectHistoryId = ioId

          /*UNION
           -- Boolean
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectHistoryBooleanDesc.ItemName) || '" FieldValue = "' || COALESCE (ObjectHistoryBoolean.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                , 6 AS GroupId
                , ObjectHistoryBoolean.DescId
           FROM ObjectHistoryBoolean
                JOIN ObjectHistoryBooleanDesc ON ObjectHistoryBooleanDesc.Id = ObjectHistoryBoolean.DescId
           WHERE ObjectHistoryBoolean.ObjectHistoryId = ioId*/
          ) AS D
           ORDER BY D.GroupId, D.DescId
        ) AS D;


   -- сохранили протокол
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, 0, vbAddXML)
   FROM ObjectHistory
   WHERE Id = ioId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.09.22         * Name
 07.04.16         * add InvNumberBranch
 26.11.15         * add MainName
 03.08.14                                        * add кроме "виртуальных"
 12.02.14                                                       * add phone
 06.01.14                                        * add проверка уникальность  <Юр. лицо полное наименование>
 05.01.14                                        * add проверка уникальность <ОКПО>
 03.01.14                                        *Cyr1251
 28.11.13                        *
*/
