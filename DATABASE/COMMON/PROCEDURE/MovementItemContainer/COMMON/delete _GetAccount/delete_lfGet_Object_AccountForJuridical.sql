-- Function: lfGet_Object_AccountForJuridical (Integer, boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lfGet_Object_AccountForJuridical (Integer, boolean, Integer, Integer);
/*
CREATE OR REPLACE FUNCTION lfGet_Object_AccountForJuridical(IN inInfoMoneyDestinationId Integer, IN isDebet Boolean, OUT outAccountGroupId Integer, OUT outAccountDirectionId Integer)
AS
$BODY$
BEGIN
   IF isDebet 
   THEN
      -- Выбираем по управленческой статье
      CASE inInfoMoneyDestinationId  
           WHEN zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_10200(),
                zc_Enum_InfoMoneyDestination_20100(), zc_Enum_InfoMoneyDestination_20200(), zc_Enum_InfoMoneyDestination_20300(),
                zc_Enum_InfoMoneyDestination_20400(), zc_Enum_InfoMoneyDestination_20500(), zc_Enum_InfoMoneyDestination_20600(),
                zc_Enum_InfoMoneyDestination_20700()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_70000(); -- Кредиторы;
                outAccountDirectionId := zc_Enum_AccountDirection_70100(); -- Поставщики;
           WHEN zc_Enum_InfoMoneyDestination_21400()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_70000(); -- Кредиторы;
                outAccountDirectionId := zc_Enum_AccountDirection_70200();  -- "услуги полученные"
           WHEN zc_Enum_InfoMoneyDestination_21500()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_70000(); -- Кредиторы;
                outAccountDirectionId := zc_Enum_AccountDirection_70300();  -- "Маркетинг"
           WHEN zc_Enum_InfoMoneyDestination_21600() 
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_70000(); -- Кредиторы;
                outAccountDirectionId := zc_Enum_AccountDirection_70400();  -- "Коммунальные услуги"
           WHEN zc_Enum_InfoMoneyDestination_50100()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_90000(); -- Расчеты с бюджетом;
                outAccountDirectionId := zc_Enum_AccountDirection_90100();  -- "Налоговые платежи"
           WHEN zc_Enum_InfoMoneyDestination_50200()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_90000(); -- Расчеты с бюджетом;
                outAccountDirectionId := zc_Enum_AccountDirection_90200();  -- "Налоговые платежи (прочие)"
           ELSE
                RAISE EXCEPTION 'Не определен счет по управленческой статье "%"', inInfoMoneyDestinationId;
      END CASE;
   ELSE
      -- Выбираем по управленческой статье
      CASE inInfoMoneyDestinationId  
           WHEN zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_10200(),
                zc_Enum_InfoMoneyDestination_20100(), zc_Enum_InfoMoneyDestination_20200(), zc_Enum_InfoMoneyDestination_20300(),
                zc_Enum_InfoMoneyDestination_20400(), zc_Enum_InfoMoneyDestination_20500(), zc_Enum_InfoMoneyDestination_20600(),
                zc_Enum_InfoMoneyDestination_20700()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_30000(); -- Дебиторы;
                outAccountDirectionId := zc_Enum_AccountDirection_30100(); -- покупатели;
           WHEN zc_Enum_InfoMoneyDestination_30400() -- услуги предоставленные
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_30000(); -- Дебиторы;
                outAccountDirectionId := zc_Enum_AccountDirection_30300();  -- "услуги предоставленные"
           WHEN zc_Enum_InfoMoneyDestination_20800(), zc_Enum_InfoMoneyDestination_20900(), -- Внутренние фирмы
                zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_30000(); -- Дебиторы
                outAccountDirectionId := zc_Enum_AccountDirection_30200();  -- "Внутренние фирмы"
           WHEN zc_Enum_InfoMoneyDestination_30500(), -- Прочие доходы 
                zc_Enum_InfoMoneyDestination_40500(), -- Ссуды 
                zc_Enum_InfoMoneyDestination_40600()  -- Депозиты
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_30000(); -- Дебиторы
                outAccountDirectionId := zc_Enum_AccountDirection_30200();  -- Прочие дебиторы
           ELSE
                RAISE EXCEPTION 'Не определен счет по управленческой статье "%"', inInfoMoneyDestinationId;
      END CASE;
   END IF;
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfGet_Object_AccountForJuridical (Integer, boolean) OWNER TO postgres;
*/

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.01.14                                        * delete
 13.08.13                        *
*/

-- тест
-- SELECT * FROM lfGet_Object_AccountForJuridical ()
