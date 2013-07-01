CREATE OR REPLACE FUNCTION zc_Object_Process_User()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_Role_Admin()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_PaidKind_FirstForm()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 6;
END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_PaidKind_SecondForm()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 7;
END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_AccountGroup_Inventory()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2001;
END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_AccountDirection_Store()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 3001;
END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_Account_InventoryStoreEmpties()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 4001;
END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_Account_CreditorsSupplierMeat()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 4002;
END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;



--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--------------------------- !!! ЭТИ ф-ции пока оставлены в старой схеме, а в новой называются по другому !!!
--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_Object_Status_UnComplete()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 3;
END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_Status_Complete()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 4;
END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_Status_Erased()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 5;
END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_Enum_Status_UnComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_UnComplete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Complete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Erased() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Erased' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! 
-- !!! 2-уровень Управленческих назначений
-- !!! 

-- 10000; "Основное сырье"; 10100; "Мясное сырье"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_10100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_10100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10000; "Основное сырье"; 10200; "Прочее сырье"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_10200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_10200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "Общефирменные"; 20100; "Запчасти и Ремонты"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "Общефирменные"; 20200; "Прочие ТМЦ"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "Общефирменные"; 20300; "Прочие основные ср-ва"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "Общефирменные"; 20400; "ГСМ"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "Общефирменные"; 20500; "Оборотная тара"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "Общефирменные"; 20600; "Прочие материалы"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "Общефирменные"; 20700; "Товары"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 01.07.13                                        * add 2-уровень Управленческих назначений
 28.06.13                                        *
*/
