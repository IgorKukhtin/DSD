-- Function: lpSelect_Object_Cash()

DROP FUNCTION IF EXISTS lpSelect_Object_Cash (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_Object_Cash(
    IN inUnitId                Integer   , -- Ключ
    IN inUserId                Integer     -- Ключ
)
RETURNS TABLE (CashId         Integer
             , CashCode       Integer
             , CashName       TVarChar
             , CurrencyId     Integer
             , CurrencyCode   Integer
             , CurrencyName   TVarChar
             , UnitId         Integer
             , UnitCode       Integer
             , UnitName       TVarChar
             , isBankAccount  Boolean
              )
AS
$BODY$
BEGIN

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('_tmpCash_list'))
     THEN
         DELETE FROM _tmpCash_list;
     ELSE
         -- табл - список, что б потом проверить
         CREATE TEMP TABLE _tmpCash_list (CashId Integer, CashCode Integer, CashName TVarChar, CurrencyId Integer, CurrencyCode Integer, CurrencyName TVarChar, UnitId Integer, UnitCode Integer, UnitName TVarChar, isBankAccount Boolean) ON COMMIT DROP;
     END IF;


     -- сформировали список
     INSERT INTO _tmpCash_list (CashId, CashCode, CashName, CurrencyId, CurrencyCode, CurrencyName, UnitId, UnitCode, UnitName, isBankAccount)
       SELECT Object_Cash.Id                  AS CashId
            , Object_Cash.ObjectCode          AS CashCode
            , Object_Cash.ValueData           AS CashName
            , Object_Currency.Id              AS CurrencyId
            , Object_Currency.ObjectCode      AS CurrencyCode
            , Object_Currency.ValueData       AS CurrencyName
            , Object_Unit.Id                  AS UnitId
            , Object_Unit.ObjectCode          AS UnitCode
            , Object_Unit.ValueData           AS UnitName
            , FALSE                           AS isBankAccount
       FROM Object AS Object_Unit
            -- если сразу получили по Магазину
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                 ON ObjectLink_Cash_Unit.ChildObjectId = Object_Unit.Id
                                AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
            -- иначе попробуем найти через группу Подразделений
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId    = Object_Unit.Id
                                AND ObjectLink_Unit_Parent.DescId      = zc_ObjectLink_Unit_Parent()
                                AND ObjectLink_Cash_Unit.ChildObjectId IS NULL
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit_Parent
                                 ON ObjectLink_Cash_Unit_Parent.ChildObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                AND ObjectLink_Cash_Unit_Parent.DescId        = zc_ObjectLink_Cash_Unit()
            -- нашли все кассы
            INNER JOIN Object AS Object_Cash
                              ON Object_Cash.Id       = COALESCE (ObjectLink_Cash_Unit.ObjectId, ObjectLink_Cash_Unit_Parent.ObjectId)
                             AND Object_Cash.DescId   = zc_Object_Cash()
                             AND Object_Cash.isErased = FALSE
            -- Валюта
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                                 ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                                AND ObjectLink_Cash_Currency.DescId   = zc_ObjectLink_Cash_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Cash_Currency.ChildObjectId

       WHERE Object_Unit.Id = inUnitId

      UNION ALL
       -- расчетный счет Магазина - в ГРН
       SELECT Object_BankAccount.Id           AS CashId
            , Object_BankAccount.ObjectCode   AS CashCode
            , Object_BankAccount.ValueData    AS CashName
            , Object_Currency.Id              AS CurrencyId
            , Object_Currency.ObjectCode      AS CurrencyCode
            , Object_Currency.ValueData       AS CurrencyName
            , Object_Unit.Id                  AS UnitId
            , Object_Unit.ObjectCode          AS UnitCode
            , Object_Unit.ValueData           AS UnitName
            , TRUE                           AS isBankAccount
       FROM ObjectLink AS ObjectLink_Unit_BankAccount
            INNER JOIN ObjectLink AS ObjectLink_BankAccount_Currency
                                  ON ObjectLink_BankAccount_Currency.ObjectId      = ObjectLink_Unit_BankAccount.ChildObjectId
                                 AND ObjectLink_BankAccount_Currency.DescId        = zc_ObjectLink_BankAccount_Currency()
                                 AND ObjectLink_BankAccount_Currency.ChildObjectId = zc_Currency_GRN()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ChildObjectId = ObjectLink_Unit_BankAccount.ObjectId
                                AND ObjectLink_Unit_Parent.DescId        = zc_ObjectLink_Unit_Parent()

           LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Unit_BankAccount.ChildObjectId
           LEFT JOIN Object AS Object_Currency    ON Object_Currency.Id    = ObjectLink_BankAccount_Currency.ChildObjectId
           LEFT JOIN Object AS Object_Unit        ON Object_Unit.Id        = inUnitId


       WHERE ObjectLink_Unit_BankAccount.DescId    = zc_ObjectLink_Unit_BankAccount()
         -- Т.е. - нашли нужный Магазин
         AND (ObjectLink_Unit_BankAccount.ObjectId = inUnitId OR ObjectLink_Unit_Parent.ObjectId = inUnitId)
      ;


     -- проверка - CurrencyId должен быть уникальным
     IF EXISTS (SELECT 1 FROM _tmpCash_list GROUP BY _tmpCash_list.CurrencyId, _tmpCash_list.isBankAccount HAVING COUNT(*) > 1) THEN
        RAISE EXCEPTION 'Ошибка.Для магазина <%> установлено несколько Касс/Р.сч. в валюте <%><%>.'
                       , lfGet_Object_ValueData (inUnitId)
                       , lfGet_Object_ValueData ((SELECT _tmpCash_list.CurrencyId FROM _tmpCash_list GROUP BY _tmpCash_list.CurrencyId, _tmpCash_list.isBankAccount HAVING COUNT(*) > 1 ORDER BY _tmpCash_list.CurrencyId, _tmpCash_list.isBankAccount LIMIT 1))
                       , (SELECT _tmpCash_list.isBankAccount FROM _tmpCash_list GROUP BY _tmpCash_list.CurrencyId, _tmpCash_list.isBankAccount HAVING COUNT(*) > 1 ORDER BY _tmpCash_list.CurrencyId, _tmpCash_list.isBankAccount LIMIT 1)
                        ;
     END IF;


     -- !!!для SYBASE - потом убрать!!!
     IF inUserId = zc_User_Sybase() AND NOT EXISTS (SELECT 1 FROM _tmpCash_list WHERE _tmpCash_list.isBankAccount = FALSE)
     THEN
          -- !!!для SYBASE - потом убрать!!!
          IF 1=0 THEN RAISE EXCEPTION 'Ошибка.У магазина <%> не определена касса в Валюте <%>.', lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (zc_Currency_GRN());
          END IF;
     ELSE

     -- проверка - должен быть zc_Currency_GRN - НАЛ
     IF NOT EXISTS (SELECT 1 FROM _tmpCash_list WHERE _tmpCash_list.CurrencyId = zc_Currency_GRN() AND _tmpCash_list.isBankAccount = FALSE) THEN
        RAISE EXCEPTION 'Ошибка.У магазина <%> не определена касса в Валюте <%> (%).', lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (zc_Currency_GRN()), (SELECT COUNT(*) FROM _tmpCash_list);
     END IF;
     -- проверка - должен быть zc_Currency_EUR
     IF NOT EXISTS (SELECT 1 FROM _tmpCash_list WHERE _tmpCash_list.CurrencyId = zc_Currency_EUR() AND _tmpCash_list.isBankAccount = FALSE) THEN
        RAISE EXCEPTION 'Ошибка.У магазина <%> не определена касса в Валюте <%>.', lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (zc_Currency_EUR());
     END IF;
     -- проверка - должен быть zc_Currency_USD
     IF NOT EXISTS (SELECT 1 FROM _tmpCash_list WHERE _tmpCash_list.CurrencyId = zc_Currency_USD() AND _tmpCash_list.isBankAccount = FALSE) THEN
        RAISE EXCEPTION 'Ошибка.У магазина <%> не определена касса в Валюте <%>.', lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (zc_Currency_USD());
     END IF;
     -- проверка - должен быть zc_Currency_GRN - БН
     IF NOT EXISTS (SELECT 1 FROM _tmpCash_list WHERE _tmpCash_list.CurrencyId = zc_Currency_GRN() AND _tmpCash_list.isBankAccount = TRUE) THEN
        RAISE EXCEPTION 'Ошибка.У магазина <%> не определен Р.счет в Валюте <%>.', lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (zc_Currency_GRN());
     END IF;
     -- проверка - должно быть 3+1
     IF 4 <> (SELECT COUNT(*) FROM _tmpCash_list) THEN
        RAISE EXCEPTION 'Ошибка.У магазина <%> не определены ВСЕ 3 Кассы + 1 Р.счет = <%>.', lfGet_Object_ValueData (inUnitId), (SELECT COUNT(*) FROM _tmpCash_list);
     END IF;

     END IF;


     -- Результат - нали ВСЕ кассы Магазина + БН Р/СЧ
     RETURN QUERY
       SELECT _tmpCash_list.CashId
            , _tmpCash_list.CashCode
            , _tmpCash_list.CashName
            , _tmpCash_list.CurrencyId
            , _tmpCash_list.CurrencyCode
            , _tmpCash_list.CurrencyName
            , _tmpCash_list.UnitId
            , _tmpCash_list.UnitCode
            , _tmpCash_list.UnitName
            , _tmpCash_list.isBankAccount
       FROM _tmpCash_list
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.05.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM lpSelect_Object_Cash (inUnitId:= 6332, inUserId:= zfCalc_UserAdmin() :: Integer);
