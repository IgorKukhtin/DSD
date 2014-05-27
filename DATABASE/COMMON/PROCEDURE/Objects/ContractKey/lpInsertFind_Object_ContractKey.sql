-- Function: lpInsertFind_Object_ContractKey (Integer, Integer, Integer, Integer, Integer, Integer)

-- DROP FUNCTION lpInsertFind_Object_ContractKey (Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_ContractKey(
    IN inJuridicalId_basis       Integer  , -- Главное юридическое лицо
    IN inJuridicalId             Integer  , -- Юридические лица
    IN inInfoMoneyId             Integer  , -- УП статья назначения
    IN inPaidKindId              Integer  , -- Вид форм оплаты
    IN inContractTagId           Integer  , -- Признак договора
    IN inContractId_begin        Integer    -- Договор(!!!Обработка!!!)
)
  RETURNS Integer AS
$BODY$
   DECLARE vbContractKeyId_old Integer;
   DECLARE vbContractKeyId_new Integer;
BEGIN

     -- проверка
     IF COALESCE (inJuridicalId_basis, 0) = 0
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
         RAISE EXCEPTION 'Ошибка.<Вид формы оплаты> не выбран.';
     END IF;
     -- проверка
     IF COALESCE (inContractId_begin, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.<Договор(!!!Обработка!!!)> не определен.';
     END IF;


     -- определяем "предыдущий" ключ
     vbContractKeyId_old:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Contract_ContractKey() AND ObjectId = inContractId_begin);


     -- !!!обработка будет только для "некоторых" <УП статья назначения>!!!
     IF EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId
                                                                AND InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100() -- Продукция
                                                                                             , zc_Enum_InfoMoneyDestination_30200() -- Мясное сырье
                                                                                              )
               )
     THEN
         -- проверка
         IF COALESCE (inContractTagId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.<Признак договора> не выбран.';
         END IF;

         --
         IF EXISTS (SELECT ObjectId FROM ObjectBoolean WHERE ObjectId = inContractId_begin AND ValueData = TRUE AND DescId = zc_ObjectBoolean_Contract_Unique())
         THEN
              -- обнуляются параметры
              inJuridicalId:= NULL;
              inContractTagId:= NULL;
              inInfoMoneyId:= NULL;
              inPaidKindId:= NULL;
              inJuridicalId_basis:= NULL;

              -- поиск ключа по правилу "Ключ - Договор(!!!Обработка!!!) + параметры=0"
              vbContractKeyId_new := (SELECT ObjectLink_1.ObjectId
                                      FROM ObjectLink AS ObjectLink_ContractKey
                                           INNER JOIN ObjectLink AS ObjectLink_1 ON ObjectLink_1.ObjectId      = ObjectLink_ContractKey.ChildObjectId
                                                                                AND ObjectLink_1.ChildObjectId IS NULL
                                                                                AND ObjectLink_1.DescId        = zc_ObjectLink_ContractKey_Juridical()
                                           INNER JOIN ObjectLink AS ObjectLink_2 ON ObjectLink_2.ObjectId      = ObjectLink_ContractKey.ChildObjectId
                                                                                AND ObjectLink_2.ChildObjectId IS NULL
                                                                                AND ObjectLink_2.DescId        = zc_ObjectLink_ContractKey_ContractTag()
                                           INNER JOIN ObjectLink AS ObjectLink_3 ON ObjectLink_3.ObjectId      = ObjectLink_ContractKey.ChildObjectId
                                                                                AND ObjectLink_3.ChildObjectId IS NULL
                                                                                AND ObjectLink_3.DescId        = zc_ObjectLink_ContractKey_InfoMoney()
                                           INNER JOIN ObjectLink AS ObjectLink_4 ON ObjectLink_4.ObjectId      = ObjectLink_ContractKey.ChildObjectId
                                                                                AND ObjectLink_4.ChildObjectId IS NULL
                                                                                AND ObjectLink_4.DescId        = zc_ObjectLink_ContractKey_PaidKind()
                                           INNER JOIN ObjectLink AS ObjectLink_5 ON ObjectLink_5.ObjectId      = ObjectLink_ContractKey.ChildObjectId
                                                                                AND ObjectLink_5.ChildObjectId IS NULL
                                                                                AND ObjectLink_5.DescId        = zc_ObjectLink_ContractKey_JuridicalBasis()
                                      WHERE ObjectLink_ContractKey.ObjectId = inContractId_begin
                                        AND ObjectLink_ContractKey.DescId = zc_ObjectLink_Contract_ContractKey()
                                     );
         ELSE
              -- поиск ключа по правилу "Ключ - 5 параметров"
              vbContractKeyId_new := (SELECT ObjectLink_1.ObjectId
                                      FROM ObjectLink AS ObjectLink_1
                                           INNER JOIN ObjectLink AS ObjectLink_2 ON ObjectLink_2.ObjectId      = ObjectLink_1.ObjectId
                                                                                AND ObjectLink_2.ChildObjectId = inContractTagId
                                                                                AND ObjectLink_2.DescId        = zc_ObjectLink_ContractKey_ContractTag()
                                           INNER JOIN ObjectLink AS ObjectLink_3 ON ObjectLink_3.ObjectId      = ObjectLink_1.ObjectId
                                                                                AND ObjectLink_3.ChildObjectId = inInfoMoneyId
                                                                                AND ObjectLink_3.DescId        = zc_ObjectLink_ContractKey_InfoMoney()
                                           INNER JOIN ObjectLink AS ObjectLink_4 ON ObjectLink_4.ObjectId      = ObjectLink_1.ObjectId
                                                                                AND ObjectLink_4.ChildObjectId = inPaidKindId
                                                                                AND ObjectLink_4.DescId        = zc_ObjectLink_ContractKey_PaidKind()
                                           INNER JOIN ObjectLink AS ObjectLink_5 ON ObjectLink_5.ObjectId      = ObjectLink_1.ObjectId
                                                                                AND ObjectLink_5.ChildObjectId = inJuridicalId_basis
                                                                                AND ObjectLink_5.DescId        = zc_ObjectLink_ContractKey_JuridicalBasis()
                                      WHERE ObjectLink_1.ChildObjectId = inJuridicalId
                                        AND ObjectLink_1.DescId = zc_ObjectLink_ContractKey_Juridical()
                                     );
         END IF;

         -- RAISE EXCEPTION 'Ошибка.<%> <%> <%> <%> <%> <%> : <%> <%>', inJuridicalId_basis, inJuridicalId, inInfoMoneyId, inPaidKindId, inContractTagId, inContractId_begin, vbContractKeyId_old, vbContractKeyId_new;

         -- Если не нашли, добавляем
         IF COALESCE (vbContractKeyId_new, 0) = 0
         THEN
             -- сохранили "пустой" <Объект>
             vbContractKeyId_new := lpInsertUpdate_Object (vbContractKeyId_new, zc_Object_ContractKey(), 0, '');
             -- сохранили связь с <Юридическое лицо>
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractKey_Juridical(), vbContractKeyId_new, inJuridicalId);
             -- сохранили связь с <Признак договора>
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractKey_ContractTag(), vbContractKeyId_new, inContractTagId);
             -- сохранили связь с <УП статья назначения>
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractKey_InfoMoney(), vbContractKeyId_new, inInfoMoneyId);
             -- сохранили связь с <Вид формы оплаты>
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractKey_PaidKind(), vbContractKeyId_new, inPaidKindId);
             -- сохранили связь с <Главное юридическое лицо>
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractKey_JuridicalBasis(), vbContractKeyId_new, inJuridicalId_basis);
         END IF;

     END IF;


     -- !!!обязательно!!! сохранили ключ у <Договор(!!!Обработка!!!)>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractKey(), inContractId_begin, vbContractKeyId_new);


     -- обновили у "предыдущего" <Ключ договора> связь с !!!"последним" договором!!!
     IF vbContractKeyId_old <> 0
     THEN 
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractKey_Contract(), vbContractKeyId_old, lfGet_Contract_ContractKey (vbContractKeyId_old));
     END IF;

     -- обновили у "нового" <Ключ договора> связь с !!!"последним" договором!!!
     IF vbContractKeyId_new <> 0
     THEN 
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractKey_Contract(), vbContractKeyId_new, lfGet_Contract_ContractKey (vbContractKeyId_new));
     END IF;

     -- Возвращаем значение, хотя не понятно зачем...
     RETURN (vbContractKeyId_new);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.05.14                                        * add zc_ObjectBoolean_Contract_Unique
 25.04.14                                        *
*/
/*
SELECT lpInsertFind_Object_ContractKey (inJuridicalId_basis:= Object_Contract_View.JuridicalBasisId
                                      , inJuridicalId      := Object_Contract_View.JuridicalId
                                      , inInfoMoneyId      := Object_Contract_View.InfoMoneyId 
                                      , inPaidKindId       := Object_Contract_View.PaidKindId
                                      , inContractTagId    := Object_Contract_View.ContractTagId
                                      , inContractId_begin := Object_Contract_View.ContractId
                                       )
FROM Object_Contract_View
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_ContractKey (inOperDate:= '31.01.2013');
