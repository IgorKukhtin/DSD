-- Function: gpInsertUpdate_Object_Contract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract(
 INOUT ioId                  Integer,       -- Ключ объекта <Договор>
    IN inCode                Integer,       -- Код
    IN inInvNumber           TVarChar,      -- Номер договора
    IN inInvNumberArchive    TVarChar,      -- Номер архивирования
    IN inComment             TVarChar,      -- Комментарий
    
    IN inSigningDate         TDateTime,     -- свойство Дата заключения договора
    IN inStartDate           TDateTime,     -- свойство Дата с которой действует договор
    IN inEndDate             TDateTime,     -- свойство Дата до которой действует договор    
    
    IN inJuridicalId         Integer  ,     -- Юридическое лицо
    IN inJuridicalBasisId    Integer  ,     -- Главное юридическое лицо
    IN inInfoMoneyId         Integer  ,     -- Статьи назначения
    IN inContractKindId      Integer  ,     -- Виды договоров
    IN inPaidKindId          Integer  ,     -- Виды форм оплаты
    
    IN inPersonalId          Integer  ,     -- Сотрудники (отвественное лицо)
    IN inAreaId              Integer  ,     -- Регион
    IN inContractArticleId   Integer  ,     -- Предмет договора
    IN inContractStateKindId Integer  ,     -- Состояние договора
    
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   vbUserId := inSession;

   IF ioId <> 0 
        -- пытаемся найти код
   THEN vbCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); 
        -- Иначе, определяем его как последний+1
   ELSE vbCode:= inCode; -- lfGet_ObjectCode (inCode, zc_Object_Contract()); 
   END IF;


   -- проверка уникальности для свойства <Номер договора>
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Contract(), inInvNumber);

   -- проверка уникальность <Номер договора> для !!!одного!! Юр. лица
   IF inInvNumber <> '' and inInvNumber <> '100398' and inInvNumber <> '877' and inInvNumber <> '24849' and inInvNumber <> '19' and inInvNumber <> 'б/н' and inInvNumber <> '369/1' and inInvNumber <> '63/12' and inInvNumber <> '4600034104' and inInvNumber <> '19М'
   THEN
       IF EXISTS (SELECT ObjectLink.ChildObjectId
                  FROM ObjectLink
                       JOIN Object ON Object.Id = ObjectLink.ObjectId
                                  AND Object.ValueData = inInvNumber
                  WHERE ObjectLink.ChildObjectId = inJuridicalId
                    AND ObjectLink.ObjectId <> COALESCE (ioId, 0)
                    AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical())
       THEN
           RAISE EXCEPTION 'Ошибка. Номер договора <%> уже установлено у <%>.', inInvNumber, lfGet_Object_ValueData (inJuridicalId);
       END IF;
   END IF;

   -- проверка
   IF COALESCE (inJuridicalBasisId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Главное юридическое лицо> не выбрано.';
   END IF;
   -- проверка
   IF COALESCE (inJuridicalId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Юридическое лицо> не выбрано.';
   END IF;
   -- проверка
   IF COALESCE (inInfoMoneyId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<УП статья назначения> не выбрана.';
   END IF;
   -- проверка
   IF COALESCE (inPaidKindId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Форма оплаты> не выбрана.';
   END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Contract(), vbCode, inInvNumber);

   -- сохранили свойство <Номер договора>
   -- PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_InvNumber(), ioId, inInvNumber);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Signing(), ioId, inSigningDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Start(), ioId, inStartDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_End(), ioId, inEndDate);

   -- сохранили свойство <Номер архивирования>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_InvNumberArchive(), ioId, inInvNumberArchive);

   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_Comment(), ioId, inComment);

   -- сохранили связь с <Юридическое лицо>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <Главным юридическим лицом>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalBasis(), ioId, inJuridicalBasisId);
   -- сохранили связь с <Статьи назначения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили связь с <Виды договоров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractKind(), ioId, inContractKindId);
   -- сохранили связь с <Виды форм оплаты>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PaidKind(), ioId, inPaidKindId);

   -- сохранили связь с <Сотрудники (отвественное лицо)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Personal(), ioId, inPersonalId);
   -- сохранили связь с <Регион>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Area(), ioId, inAreaId);
   -- сохранили связь с <Предмет договора>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractArticle(), ioId, inContractArticleId);
   -- сохранили связь с <Состояние договора>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractStateKind(), ioId, inContractStateKindId);   
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.11.14                        * 
 05.01.14                                        * add проверка уникальность <Номер договора> для !!!одного!! Юр. лица
 04.01.14                                        * add !!!inInvNumber not unique!!!
 14.11.13         * add from redmaine               
 21.10.13                                        * add vbCode
 20.10.13                                        * add from redmaine
 19.10.13                                        * del zc_ObjectString_Contract_InvNumber()
 22.07.13         * add  SigningDate, StartDate, EndDate              
 12.04.13                                        *
 16.06.13                                        * красота
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Contract ()
