 -- Function: gpInsertUpdate_Object_Member(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);*/
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member(
 INOUT ioId	                 Integer   ,    -- ключ объекта <Физические лица> 
    IN inCode                Integer   ,    -- код объекта 
    IN inName                TVarChar  ,    -- Название объекта <
    IN inIsOfficial          Boolean   ,    -- Оформлен официально
    IN inIsNotCompensation   Boolean   ,    -- Исключить из компенсации отпуска
    IN inCode1С              TVarChar  ,    -- Код 1С
    IN inINN                 TVarChar  ,    -- Код ИНН
    IN inDriverCertificate   TVarChar  ,    -- Водительское удостоверение 
    IN inCard                TVarChar  ,    -- № карточного счета ЗП
    IN inCardSecond          TVarChar  ,    -- № карточного счета ЗП - вторая форма
    IN inCardChild           TVarChar  ,    -- № карточного счета ЗП - - алименты (удержание)
    IN inCardIBAN            TVarChar  ,    -- № карточного счета IBAN ЗП - первая форма
    IN inCardIBANSecond      TVarChar  ,    -- № карточного счета IBAN ЗП - вторая форма
    IN inCardBank            TVarChar  ,    -- № карточного счета ЗП
    IN inCardBankSecond      TVarChar  ,    -- № карточного счета ЗП - вторая форма
    
    IN inCardBankSecondTwo   TVarChar  ,    --
    IN inCardIBANSecondTwo   TVarChar  ,    --
    IN inCardSecondTwo       TVarChar  ,    --
    IN inCardBankSecondDiff  TVarChar  ,    --  
    IN inCardIBANSecondDiff  TVarChar  ,    --
    IN inCardSecondDiff      TVarChar  ,    --
    
    IN inPhone               TVarChar  ,    --
    IN inComment             TVarChar  ,    -- Примечание 

    IN inBankId_Top            Integer   ,    --
    IN inBankSecondId_Top      Integer   ,    --
    IN inBankSecondTwoId_Top   Integer   ,    --
    IN inBankSecondDiffId_Top  Integer   ,    --
    
    IN inBankId              Integer   ,    --
    IN inBankSecondId        Integer   ,    --
    IN inBankChildId         Integer   ,    --
    IN inBankSecondTwoId     Integer   ,    --
    IN inBankSecondDiffId    Integer   ,    --
    IN inInfoMoneyId         Integer   ,    --
    IN inUnitMobileId        Integer   ,    --Подразделение(заявки мобильный) 
   OUT outBankName           TVarChar  ,    --   
   OUT outBankSecondName     TVarChar  ,    --
   OUT outBankSecondTwoName  TVarChar  ,    --
   OUT outBankSecondDiffName TVarChar  ,    --
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- !!! это временно !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_Member());
   -- END IF;

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());
    
   --проверка
   IF COALESCE (inName,'') = '' THEN RAISE EXCEPTION 'Ошибка. Не заполнен реквизит <ФИО>.' ; END IF;  

   -- Ограничение - проверка параметров для Физ лиц
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11355513)
   THEN
       IF COALESCE (inPhone,'') = '' THEN RAISE EXCEPTION 'Ошибка. Не заполнен реквизит <Телефон>.' ; END IF;
       IF COALESCE (inINN,'') = '' THEN RAISE EXCEPTION 'Ошибка. Не заполнен реквизит <ИНН>.' ; END IF;
   END IF;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний + 1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Member());   
   
   --переопределяем параметры - 
   IF COALESCE (inBankId_Top,0) <> 0           THEN inBankId           = inBankId_Top;           END IF;
   IF COALESCE (inBankSecondId_Top,0) <> 0     THEN inBankSecondId     = inBankSecondId_Top;     END IF;
   IF COALESCE (inBankSecondTwoId_Top,0) <> 0  THEN inBankSecondTwoId  = inBankSecondTwoId_Top;  END IF;
   IF COALESCE (inBankSecondDiffId_Top,0) <> 0 THEN inBankSecondDiffId = inBankSecondDiffId_Top; END IF;
   
   -- проверка уникальности <Наименование>
   IF TRIM (inINN) = ''
   THEN 
       PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Member(), inName);
   END IF;
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Member(), vbCode_calc);
   -- проверка уникальность <INN>      если выбран в контроле тогда берем из него
   IF TRIM (inINN) <> '' AND LEFT (inINN, 8) <> '00000000'
   THEN
       IF EXISTS (SELECT ObjectString.ObjectId
                  FROM ObjectString
                  WHERE TRIM (ObjectString.ValueData) = TRIM (inINN)
                    AND ObjectString.ObjectId <> COALESCE (ioId, 0)
                    AND ObjectString.DescId = zc_ObjectString_Member_INN())
       THEN
           RAISE EXCEPTION 'Ошибка. Код ИНН <%> уже установлен у <%>.', TRIM (inINN), lfGet_Object_ValueData ((SELECT ObjectString.ObjectId
                                                                                                               FROM ObjectString
                                                                                                               WHERE TRIM (ObjectString.ValueData) = TRIM (inINN)
                                                                                                                 AND ObjectString.ObjectId <> COALESCE (ioId, 0)
                                                                                                                 AND ObjectString.DescId = zc_ObjectString_Member_INN()
                                                                                                             ));
       END IF;
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Member(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- сохранили свойство <Оформлен официально>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Official(), ioId, inIsOfficial);
   -- сохранили свойство <Исключить из компенсации отпуска>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_NotCompensation(), ioId, inIsNotCompensation);


   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Code1C(), ioId, inCode1С);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_INN(), ioId, inINN);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_DriverCertificate(), ioId, inDriverCertificate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Card(), ioId, inCard);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardSecond(), ioId, inCardSecond);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardChild(), ioId, inCardChild); 

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardIBAN(), ioId, inCardIBAN);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardIBANSecond(), ioId, inCardIBANSecond);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardBank(), ioId, inCardBank);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardBankSecond(), ioId, inCardBankSecond);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardBankSecondTwo(), ioId, inCardBankSecondTwo);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardIBANSecondTwo(), ioId, inCardIBANSecondTwo);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardSecondTwo(), ioId, inCardSecondTwo);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardBankSecondDiff(), ioId, inCardBankSecondDiff);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardSecondDiff(), ioId, inCardSecondDiff);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardIBANSecondDiff(), ioId, inCardIBANSecondDiff);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Phone(), ioId, inPhone);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Comment(), ioId, inComment);
   
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_InfoMoney(), ioId, inInfoMoneyId);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Bank(), ioId, inBankId);
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_BankSecond(), ioId, inBankSecondId);
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_BankChild(), ioId, inBankChildId);
      -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_BankSecondTwo(), ioId, inBankSecondTwoId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_BankSecondDiff(), ioId, inBankSecondDiffId);
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_UnitMobile(), ioId, inUnitMobileId);

   -- синхронизируем <Физические лица> и <Сотрудники>
   UPDATE Object SET ValueData = inName, ObjectCode = vbCode_calc
   WHERE Id IN (SELECT ObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Personal_Member() AND ChildObjectId = ioId);  

   --
   outBankName           := (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.Id = inBankId);
   outBankSecondName     := (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.Id = inBankSecondId);
   outBankSecondTwoName  := (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.Id = inBankSecondTwoId);
   outBankSecondDiffName := (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.Id = inBankSecondDiffId);
    
   IF vbUserId = 9457 THEN RAISE EXCEPTION 'Test. OK'; END IF;
    
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.10.24         * Code1C
 15.03.24         * Phone
 27.09.21         *
 09.09.21         *
 06.02.20         * inIsNotCompensation
 09.09.19         * inCardIBAN, inCardIBANSecond
 03.03.17         * add Bank, BankSecond, BankChild
 20.02.17         * add CardSecond,inCardChild
 25.03.16         * add Card
 19.02.15         * add inInfoMoneyId
 12.09.14                                        * add inIsOfficial
 13.12.13                                        * del inAccessKeyId
 08.12.13                                        * add inAccessKeyId
 30.10.13                         * синхронизируем <Физические лица> и <Сотрудники>
 09.10.13                                        * пытаемся найти код
 01.10.13         *  add DriverCertificate, Comment              
 01.07.13         *
*/

-- !!!синхронизируем <Физические лица> и <Сотрудники>!!!
-- UPDATE Object SET ValueData = Object2.ValueData , ObjectCode = Object2.ObjectCode from (SELECT Object.*, ObjectId FROM ObjectLink join Object on Object.Id = ObjectLink.ChildObjectId WHERE ObjectLink.DescId = zc_ObjectLink_Personal_Member()) as Object2 WHERE Object.Id  = Object2. ObjectId;
-- тест
-- SELECT * FROM gpInsertUpdate_Object_Member()
