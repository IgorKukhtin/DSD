--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_AccountGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_AccountGroup', 'Связь счета с Группой счетов', zc_Object_Account(), zc_Object_AccountGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_AccountDirection', 'Связь счета с Аналитики счетов - направления', zc_Object_Account(), zc_Object_AccountDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_InfoMoneyDestination', 'Связь счета с Управленческие назначения', zc_Object_Account(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoneyDestination');

--!!! 
CREATE OR REPLACE FUNCTION zc_ObjectLink_Bank_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Bank_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Bank_Juridical', 'Связь банка с юр лицом', zc_Object_Bank(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Bank_Juridical');

-- !!!zc_Object_BankAccount!!!
CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_Juridical', 'Связь счета с юр. лицом', zc_Object_BankAccount(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Bank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_Bank', 'Связь счета банком', zc_Object_BankAccount(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Bank');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_Currency', 'Связь счета с валютой', zc_Object_BankAccount(), zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Currency');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_CorrespondentBank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_CorrespondentBank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_CorrespondentBank', 'Банк корреспондент для счета', zc_Object_BankAccount(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_CorrespondentBank');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_BeneficiarysBank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_BeneficiarysBank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_BeneficiarysBank', 'Счет в банке - корреспонденте', zc_Object_BankAccount(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_BeneficiarysBank');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Account'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_Account', 'Счет (баланс)', zc_Object_BankAccount(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_Account');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccount_PaidKind', 'Виды форм оплаты ', zc_Object_BankAccount(), zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccount_PaidKind');



CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccountContract_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccountContract_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccountContract_BankAccount', 'Связь с р.счетом', zc_Object_BankAccountContract(), zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccountContract_BankAccount');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccountContract_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccountContract_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccountContract_InfoMoney', 'Связь со Статьи назначения', zc_Object_BankAccountContract(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccountContract_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccountContract_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccountContract_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BankAccountContract_Unit', 'Связь с Подразделением', zc_Object_BankAccountContract(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BankAccountContract_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BarCodeBox_Box() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BarCodeBox_Box'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BarCodeBox_Box', 'Связь c Ящик', zc_Object_BarCodeBox(), zc_Object_Box() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BarCodeBox_Box');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_CarModel() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_CarModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_CarModel', 'Связь Машины с маркой автомобиля', zc_Object_Car(), zc_Object_CarModel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_CarModel');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_Unit', 'Связь Машины с Подразделением', zc_Object_Car(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_PersonalDriver() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_PersonalDriver'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_PersonalDriver', 'Связь Машины с Сотрудником(водитель)', zc_Object_Car(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_PersonalDriver');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_FuelMaster() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_FuelMaster'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_FuelMaster', 'Связь Машины с Видом топлива(основное)', zc_Object_Car(), zc_Object_Fuel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_FuelMaster');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_FuelChild() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_FuelChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_FuelChild', 'Связь Машины с Видом топлива(Дополнительное)', zc_Object_Car(), zc_Object_Fuel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_FuelChild');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_Juridical', 'Связь Машины с Юридическое лицо(стороннее)', zc_Object_Car(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_Asset() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_Asset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_Asset', 'Связь Машины с Основные средства', zc_Object_Car(), zc_Object_Asset() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_Asset');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_CarType() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_CarType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_CarType', 'Связь Машины с Модель автомобиля', zc_Object_Car(), zc_Object_CarType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_CarType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_BodyType() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_BodyType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_BodyType', 'Связь Машины с Тип кузова', zc_Object_Car(), zc_Object_BodyType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_BodyType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_ObjectColor() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_ObjectColor'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_ObjectColor', 'Связь Машины с Цвет авто', zc_Object_Car(), zc_Object_ObjectColor() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_ObjectColor');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Car_CarProperty() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_CarProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Car_CarProperty', 'Связь Машины с Тип авто', zc_Object_Car(), zc_Object_CarProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Car_CarProperty');


--
CREATE OR REPLACE FUNCTION zc_ObjectLink_CarExternal_CarModel() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CarExternal_CarModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CarExternal_CarModel', 'Связь Машины с маркой автомобиля', zc_Object_CarExternal(), zc_Object_CarModel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CarExternal_CarModel');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CarExternal_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CarExternal_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CarExternal_Juridical', 'Связь Машины с Юридическое лицо(стороннее)', zc_Object_CarExternal(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CarExternal_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CarExternal_CarType() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CarExternal_CarType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CarExternal_CarType', 'Связь Машины с Модель автомобиля', zc_Object_CarExternal(), zc_Object_CarType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CarExternal_CarType');

 CREATE OR REPLACE FUNCTION zc_ObjectLink_CarExternal_ObjectColor() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CarExternal_ObjectColor'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CarExternal_ObjectColor', 'Связь Машины с Цвет авто', zc_Object_CarExternal(), zc_Object_ObjectColor() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CarExternal_ObjectColor');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CarExternal_CarProperty() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CarExternal_CarProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CarExternal_CarProperty', 'Связь Машины с Тип авто', zc_Object_CarExternal(), zc_Object_CarProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CarExternal_CarProperty');



--

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Currency() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
   SELECT 'zc_ObjectLink_Cash_Currency', 'Связь кассы с валютой', zc_Object_Cash(), zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Currency');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Cash_PaidKind', 'Связь кассы с формой оплаты', zc_Object_Cash(), zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_PaidKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
   SELECT 'zc_ObjectLink_Cash_Branch', 'Связь кассы с филиалом', zc_Object_Cash(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Branch');

-- !!!zc_Object_Goods!!!
CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_GoodsGroup', 'Связь товаров с группой товаров', zc_Object_Goods(), zc_Object_GoodsGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_Measure', 'Связь товаров с единицей измерения', zc_Object_Goods(), zc_Object_Measure() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Measure');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_TradeMark', 'Связь товаров с Торговой маркой', zc_Object_Goods(), zc_Object_TradeMark() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_TradeMark');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_InfoMoney', 'Связь товаров с управленческой статьей', zc_Object_Goods(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_Business', 'Связь товаров с бизнесом', zc_Object_Goods(), zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Business');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Fuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Fuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_Fuel', 'Связь товаров с видом топлива', zc_Object_Goods(), zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Fuel');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_GoodsBasis', 'Связь товаров с базовым', zc_Object_Goods(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsBasis');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_GoodsMain', 'Связь товаров с главным', zc_Object_Goods(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsMain');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Asset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Asset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_Asset', 'Связь товаров с ОС', zc_Object_Goods(), zc_Object_Asset() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Asset');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_AssetProd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_AssetProd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_AssetProd', 'Связь товаров с ОС', zc_Object_Goods(), zc_Object_Asset() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_AssetProd');


CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsBasis', 'Связь товаров с базовым', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsBasis');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsMain', 'Связь товаров с главным', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsMain');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsBasis_old() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsBasis_old'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsBasis_old', 'Связь товаров с базовым(история)', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsBasis_old');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsMain_old() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsMain_old'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsMain_old', 'Связь товаров с главным(история)', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsMain_old');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Object() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Object'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_Object', 'Связь товаров с юр лицом или торговой сетью', zc_Object_Goods(), null WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Object');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsGroupStat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroupStat'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_GoodsGroupStat', 'Связь товаров с группой товаров (статистика)', zc_Object_Goods(), zc_Object_GoodsGroupStat() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroupStat');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_GoodsTag', 'Связь товаров с Признаком товара', zc_Object_Goods(), zc_Object_GoodsTag() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsTag');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsGroupAnalyst() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroupAnalyst'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_GoodsGroupAnalyst', 'Связь товаров с Группа товаров(аналитика)', zc_Object_Goods(), zc_Object_GoodsGroupAnalyst() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroupAnalyst');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Maker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Maker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_Maker', 'Связь товаров с производителем', zc_Object_Goods(), zc_Object_Maker() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Maker');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsPlatform() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsPlatform'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_GoodsPlatform', 'Связь товаров с Производственной площадкой', zc_Object_Goods(), zc_Object_GoodsPlatform() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsPlatform');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_PartnerIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_PartnerIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_PartnerIn', 'Связь товаров с поставщиком', zc_Object_Goods(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_PartnerIn');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_PartnerIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_PartnerIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_PartnerIn', 'Связь товаров с поставщиком', zc_Object_Goods(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_PartnerIn');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsGroupDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroupDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_GoodsGroupDirection', 'Связь товаров с Аналитическая группа Направление', zc_Object_Goods(), zc_Object_GoodsGroupDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroupDirection');




CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroup_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsGroup_Parent', 'Связь группы товаров с группой товаров', zc_Object_GoodsGroup(), zc_Object_GoodsGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroup_GoodsGroupStat() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_GoodsGroupStat'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsGroup_GoodsGroupStat', 'Связь группы товаров с группой товаров(статистика)', zc_Object_GoodsGroup(), zc_Object_GoodsGroupStat() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_GoodsGroupStat');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroup_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsGroup_TradeMark', 'Связь группы товаров с торговой маркой', zc_Object_GoodsGroup(), zc_Object_TradeMark() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_TradeMark');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroup_GoodsTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_GoodsTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsGroup_GoodsTag', 'Связь группы товаров с Признаком товара', zc_Object_GoodsGroup(), zc_Object_GoodsTag() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_GoodsTag');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst', 'Связь группы товаров с Группа товаров(аналитика)', zc_Object_GoodsGroup(), zc_Object_GoodsGroupAnalyst() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroup_GoodsPlatform() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_GoodsPlatform'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsGroup_GoodsPlatform', 'Связь группы товаров с Производственная площадка', zc_Object_GoodsGroup(), zc_Object_GoodsPlatform() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_GoodsPlatform');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroup_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsGroup_InfoMoney', 'Связь группы товаров с управленческой статьей', zc_Object_GoodsGroup(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroup_InfoMoney');


CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsTag_GoodsGroupAnalyst() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsTag_GoodsGroupAnalyst'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsTag_GoodsGroupAnalyst', 'Связь признака товаров с Группа товаров(аналитика)', zc_Object_GoodsTag(), zc_Object_GoodsGroupAnalyst() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsTag_GoodsGroupAnalyst');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractTag_ContractTagGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractTag_ContractTagGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ContractTag_ContractTagGroup', 'Связь группы признака договора с признаком договора', zc_Object_ContractTag(), zc_Object_ContractTagGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractTag_ContractTagGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsAnalog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsAnalog'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_GoodsAnalog', 'Связь товаров с аналогом товара', zc_Object_Goods(), zc_Object_GoodsAnalog() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsAnalog');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsGroupProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroupProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_GoodsGroupProperty', 'Связь товаров с Аналитическим классификатором ', zc_Object_Goods(), zc_Object_GoodsGroupProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroupProperty');




-- !!!zc_Object_GoodsPropertyValue!!!
CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_GoodsProperty', 'Связь Значения свойств товаров для классификатора с Классификатором свойств товаров', zc_Object_GoodsPropertyValue(), zc_Object_GoodsProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_Goods', 'Связь Значения свойств товаров для классификатора с Товарами', zc_Object_GoodsPropertyValue(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_GoodsKind', 'Связь Значения свойств товаров для классификатора с Видами товаров', zc_Object_GoodsPropertyValue(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_GoodsBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_GoodsBox', 'Связь Значения свойств товаров для классификатора с Товар(гофроящик)', zc_Object_GoodsPropertyValue(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsBox');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Sh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Sh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Sh', 'Связь Значения свойств товаров для классификатора с Категория товара "Штучный"', zc_Object_GoodsPropertyValue(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Sh');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom', 'Связь Значения свойств товаров для классификатора с Категория товара "Номинальный"', zc_Object_GoodsPropertyValue(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Ves() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Ves'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Ves', 'Связь Значения свойств товаров для классификатора с Категория товара "Неноминальный"', zc_Object_GoodsPropertyValue(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Ves');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_Box() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_Box'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_Box', 'Связь Значения свойств товаров для классификатора с ящиком', zc_Object_GoodsPropertyValue(), zc_Object_Box() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_Box');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_GoodsKindSub() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsKindSub'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyValue_GoodsKindSub', 'Связь Значения свойств товаров для классификатора с Вид товара (факт расход в накладной)', zc_Object_GoodsPropertyValue(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyValue_GoodsKindSub');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsScaleCeh_From() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsScaleCeh_From'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsScaleCeh_From', 'От кого', zc_Object_GoodsScaleCeh(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsScaleCeh_From');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsScaleCeh_To() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsScaleCeh_To'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsScaleCeh_To', 'Кому', zc_Object_GoodsScaleCeh(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsScaleCeh_To');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsScaleCeh_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsScaleCeh_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsScaleCeh_Goods', 'Товар', zc_Object_GoodsScaleCeh(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsScaleCeh_Goods');


CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportExportLink_ObjectMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportExportLink_ObjectMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportExportLink_ObjectMain', 'Связи объектов для загрузки, выгрузки c объектом', zc_Object_ImportExportLink(), NULL WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportExportLink_ObjectMain');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportExportLink_ObjectChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportExportLink_ObjectChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportExportLink_ObjectChild', 'Связи объектов для загрузки, выгрузки c объектом', zc_Object_ImportExportLink(), NULL WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportExportLink_ObjectChild');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportExportLink_LinkType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportExportLink_LinkType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportExportLink_LinkType', 'Связи объектов для загрузки, выгрузки c объектом', zc_Object_ImportExportLink(), zc_Object_ImportExportLinkType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportExportLink_LinkType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalGroup_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalGroup_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_JuridicalGroup_Parent', 'Группа юр лиц', zc_Object_JuridicalGroup(), zc_Object_JuridicalGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalGroup_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_JuridicalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_JuridicalGroup'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_JuridicalGroup', 'Группа юр лиц', zc_Object_Juridical(), zc_Object_JuridicalGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_JuridicalGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_GoodsProperty'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_GoodsProperty', 'Классификатор свойств товаров', zc_Object_Juridical(), zc_Object_GoodsProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PriceList'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_PriceList', 'Прайс-лист', zc_Object_Juridical(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PriceList');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_PriceListPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PriceListPromo'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_PriceListPromo', 'Прайс-лист(Акционный)', zc_Object_Juridical(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PriceListPromo');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_PriceListPrior() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PriceListPrior'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_PriceListPrior', 'Прайс-лист возвраты по старым ценам', zc_Object_Juridical(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PriceListPrior');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_PriceList30103() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PriceList30103'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_PriceList30103', 'Прайс-лист УП Хлеб', zc_Object_Juridical(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PriceList30103');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_PriceList30201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PriceList30201'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_PriceList30201', 'Прайс-лист УП Мясное сырье', zc_Object_Juridical(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PriceList30201');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_Retail'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_Retail', 'Торговая сеть', zc_Object_Juridical(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_Retail');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_RetailReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_RetailReport'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Juridical_RetailReport', 'Торговая сеть(отчет)', zc_Object_Juridical(), zc_Object_RetailReport() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_RetailReport');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_PrintKindItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PrintKindItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_Juridical_PrintKindItem', 'Элемент печати', zc_Object_Juridical(), zc_Object_PrintKindItem() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_PrintKindItem');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_Section() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_Section'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_Juridical_Section', 'Сегмент', zc_Object_Juridical(), zc_Object_Section() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_Section');



CREATE OR REPLACE FUNCTION zc_ObjectLink_LinkGoods_GoodsMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_LinkGoods_GoodsMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_LinkGoods_GoodsMain', '', zc_Object_LinkGoods(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_LinkGoods_GoodsMain');

CREATE OR REPLACE FUNCTION zc_ObjectLink_LinkGoods_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_LinkGoods_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_LinkGoods_Goods', '', zc_Object_LinkGoods(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_LinkGoods_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MarginCategoryItem_MarginCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginCategoryItem_MarginCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MarginCategoryItem_MarginCategory', '', zc_Object_MarginCategoryItem(), zc_Object_MarginCategory() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginCategoryItem_MarginCategory');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MarginCategoryLink_MarginCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginCategoryLink_MarginCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MarginCategoryLink_MarginCategory', '', zc_Object_MarginCategoryLink(), zc_Object_MarginCategory() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginCategoryLink_MarginCategory');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MarginCategoryLink_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginCategoryLink_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MarginCategoryLink_Unit', '', zc_Object_MarginCategoryLink(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginCategoryLink_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MarginCategoryLink_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginCategoryLink_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MarginCategoryLink_Juridical', '', zc_Object_MarginCategoryLink(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginCategoryLink_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MarginReportItem_MarginReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginReportItem_MarginReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MarginReportItem_MarginReport', 'Категория наценки для отчета (Ценовая интервенция)', zc_Object_MarginReportItem(), zc_Object_MarginReport() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginReportItem_MarginReport');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MarginReportItem_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginReportItem_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MarginReportItem_Unit', 'Подразделение', zc_Object_MarginReportItem(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarginReportItem_Unit');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_MemberTake() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_MemberTake', 'Физ лицо (экспедитор)', zc_Object_Partner(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake');
--
CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_MemberTake1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_MemberTake1', 'Физ лицо (экспедитор)-1', zc_Object_Partner(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake1');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_MemberTake2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_MemberTake2', 'Физ лицо (экспедитор)-2', zc_Object_Partner(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake2');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_MemberTake3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_MemberTake3', 'Физ лицо (экспедитор)-3', zc_Object_Partner(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake3');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_MemberTake4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_MemberTake4', 'Физ лицо (экспедитор)-4', zc_Object_Partner(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake4');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_MemberTake5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_MemberTake5', 'Физ лицо (экспедитор)-5', zc_Object_Partner(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake5');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_MemberTake6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_MemberTake6', 'Физ лицо (экспедитор)-6', zc_Object_Partner(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake6');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_MemberTake7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_MemberTake7', 'Физ лицо (экспедитор)-7', zc_Object_Partner(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberTake7');
--
CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_MemberSaler1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberSaler1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_MemberSaler1', 'ФФиз лицо (Продавец-1)', zc_Object_Partner(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberSaler1');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_MemberSaler2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberSaler2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_MemberSaler2', 'Физ лицо (Продавец-2)', zc_Object_Partner(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_MemberSaler2');

--

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_Personal', 'Сотрудник (ответственное лицо)', zc_Object_Partner(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Personal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_PersonalTrade() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PersonalTrade'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_PersonalTrade', 'Сотрудник (торговый)', zc_Object_Partner(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PersonalTrade');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_PersonalMerch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PersonalMerch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_PersonalMerch', 'Сотрудник (мерчандайзер)', zc_Object_Partner(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PersonalMerch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_PersonalSigning() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PersonalSigning'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_PersonalSigning', 'Сотрудники (подписант)', zc_Object_Partner(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PersonalSigning');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_Area', 'Регион', zc_Object_Partner(), zc_Object_Area() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Area');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_PartnerTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PartnerTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_PartnerTag', 'Признак торговой точки', zc_Object_Partner(), zc_Object_PartnerTag() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PartnerTag');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner_Juridical', 'Юридическое лицо', zc_Object_Partner(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Route() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Route'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_Route', 'Маршрут', zc_Object_Partner(), zc_Object_Route() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Route');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Route30201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Route30201'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_Route30201', 'Маршрут (сырье)', zc_Object_Partner(), zc_Object_Route() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Route30201');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_RouteSorting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_RouteSorting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_RouteSorting', 'Сотрировка маршрута', zc_Object_Partner(), zc_Object_RouteSorting() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_RouteSorting');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_Unit', 'Подразделение', zc_Object_Partner(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PriceList'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_PriceList', 'Прайс-лист', zc_Object_Partner(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PriceList');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_PriceListPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PriceListPromo'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_PriceListPromo', 'Прайс-лист(Акционный)', zc_Object_Partner(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PriceListPromo');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_PriceListPrior() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PriceListPrior'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner_PriceListPrior', 'Прайс-лист возвраты по старым ценам', zc_Object_Partner(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PriceListPrior');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_PriceList30103() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PriceList30103'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner_PriceList30103', 'Прайс-лист УП Хлеб', zc_Object_Partner(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PriceList30103');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_PriceList30201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PriceList30201'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner_PriceList30201', 'Прайс-лист УП Мясное сырье', zc_Object_Partner(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_PriceList30201');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Street() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Street'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Partner_Street', 'Улица/проспект', zc_Object_Partner(), zc_Object_Street() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_Street');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_GoodsProperty'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner_GoodsProperty', 'Классификатор свойств товаров', zc_Object_Partner(), zc_Object_GoodsProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_UnitMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_UnitMobile'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner_UnitMobile', 'Подразделение(заявки мобильный)', zc_Object_Partner(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner_UnitMobile');


CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceListItem_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PriceListItem_PriceList', 'Прайс-лист', zc_Object_PriceListItem(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_PriceList');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceListItem_Goods()  RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PriceListItem_Goods', 'Товар', zc_Object_PriceListItem(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceListItem_GoodsKind()  RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PriceListItem_GoodsKind', 'Вид товара', zc_Object_PriceListItem(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceListItem_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleRight_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RoleRight_Role', 'Ссылка на роль в справочнике указания ролей', zc_Object_RoleRight(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Role');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleRight_Process() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Process'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RoleRight_Process', 'Ссылка на процесс в справочнике указания ролей', zc_Object_RoleRight(), zc_Object_Process() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleRight_Process');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Parent', 'Связь подразделения с подразделением', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Branch', 'Связь подразделения с филиалом', zc_Object_Unit(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Contract', 'Связь подразделения с договором', zc_Object_Unit(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Route() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Route'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_Route', 'Маршрут', zc_Object_Unit(), zc_Object_Route() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Route');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_RouteSorting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_RouteSorting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_RouteSorting', 'Сотрировка маршрута', zc_Object_Unit(), zc_Object_RouteSorting() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_RouteSorting');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_Area', 'Связь подразделения с Регионом', zc_Object_Unit(), zc_Object_Area() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Area');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_PersonalSheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_PersonalSheetWorkTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_PersonalSheetWorkTime', 'Связь подразделения с Сотрудником(доступ к табелю р.времени)', zc_Object_Unit(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_PersonalSheetWorkTime');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_PersonalHead() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_PersonalHead'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_PersonalHead', 'Руководитель подразделения', zc_Object_Unit(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_PersonalHead');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_SheetWorkTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_SheetWorkTime', 'Связь подразделения с Режим работы (Шаблон табеля р.вр.)', zc_Object_Unit(), zc_Object_SheetWorkTime() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_SheetWorkTime');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Category() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Category'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_Category', 'Связь подразделения с категорией', zc_Object_Unit(), zc_Object_UnitCategory() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Category');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_PartnerMedical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_PartnerMedical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_PartnerMedical', 'Связь подразделения с Мед.учреждение для пкму 1303', zc_Object_Unit(), zc_Object_PartnerMedical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_PartnerMedical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_City() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_City'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_City', 'Связь подразделения с Городом', zc_Object_Unit(), zc_Object_City() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_City');


CREATE OR REPLACE FUNCTION zc_ObjectLink_UserRole_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UserRole_Role', 'Ссылка на роль в справочнике связи пользователей и ролей', zc_Object_UserRole(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_Role');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserRole_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UserRole_User', 'Связь с пользователем в справочнике ролей пользователя', zc_Object_UserRole(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserRole_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserFormSettings_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserFormSettings_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UserFormSettings_User', 'Пользователь', zc_Object_UserFormSettings(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserFormSettings_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserFormSettings_Form() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserFormSettings_Form'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UserFormSettings_Form', '???', zc_Object_UserFormSettings(), zc_Object_Form() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserFormSettings_Form');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Business()  RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Business', 'Связь подразделения с бизнесом', zc_Object_Unit(), zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Business');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Juridical', 'Связь подразделения с юр лицом', zc_Object_Unit(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_AccountDirection() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_AccountDirection', 'Связь подразделения с аналитикой управленческих счетов - направление', zc_Object_Unit(), zc_Object_AccountDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_AccountDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_ProfitLossDirection() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_ProfitLossDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_ProfitLossDirection', 'Связь подразделения с аналитикой управленческих счетов - направление', zc_Object_Unit(), zc_Object_ProfitLossDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_ProfitLossDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_HistoryCost() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_HistoryCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_HistoryCost', 'Связь подразделения с альтернативным подразделением для с/с', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_HistoryCost');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Founder() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Founder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Founder', 'Учредители', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Founder');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Department() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Department'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Department', 'Департамент', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Department');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Department_two() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Department_two'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_Department_two', 'Департамент 2-го уровня', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Department_two');



CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Account_InfoMoney', 'Связь счета с Управленческой аналитикой', zc_Object_Account(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_InfoMoney');


-- CREATE OR REPLACE FUNCTION zc_ObjectLink_UnitGroup_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitGroup_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_ObjectLink_InfoMoney_InfoMoneyGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_InfoMoney_InfoMoneyGroup', 'Связь Статьи назначения с Группой управленческих назначений', zc_Object_InfoMoney(), zc_Object_InfoMoneyGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_InfoMoney_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_InfoMoney_InfoMoneyDestination', 'Связь Статьи назначения с Управленческим назначением', zc_Object_InfoMoney(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_ObjectLink_InfoMoney_CashFlow_in() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_CashFlow_in'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_InfoMoney_CashFlow_in', 'Связь Статьи назначения с Статья отчета ДДС приход', zc_Object_InfoMoney(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_CashFlow_in');

CREATE OR REPLACE FUNCTION zc_ObjectLink_InfoMoney_CashFlow_out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_CashFlow_out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_InfoMoney_CashFlow_out', 'Связь Статьи назначения с Статья отчета ДДС расход', zc_Object_InfoMoney(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InfoMoney_CashFlow_out');


CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_ProfitLossGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_ProfitLossGroup', 'Связь Статьи отчета о прибылях и убытках с Группой статей отчета о прибылях и убытках', zc_Object_ProfitLoss(), zc_Object_ProfitLossGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_ProfitLossDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_ProfitLossDirection', 'Связь Статьи отчета о прибылях и убытках с Аналитикой статей отчета о прибылях и убытках - направления', zc_Object_ProfitLoss(), zc_Object_ProfitLossDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_ProfitLossDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_InfoMoneyDestination', 'Связь Статьи отчета о прибылях и убытках с Управленческие назначения', zc_Object_ProfitLoss(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProfitLoss_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProfitLoss_InfoMoney', 'Связь Статьи отчета о прибылях и убытках с Управленческой аналитикой', zc_Object_ProfitLoss(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProfitLoss_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Member', 'Связь Сотрудники с Физ.лицами', zc_Object_Personal(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Position', 'Связь Сотрудники с должностью', zc_Object_Personal(), zc_Object_Position() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Position');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_PositionLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PositionLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_PositionLevel', 'Разряд должности', zc_Object_Personal(), zc_Object_PositionLevel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PositionLevel');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Unit', 'Связь Сотрудники с подразделением', zc_Object_Personal(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Juridical', 'Связь Сотрудники с юр.лицом', zc_Object_Personal(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Business', 'Связь Сотрудники с Бизнесом', zc_Object_Personal(), zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Business');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_PersonalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_PersonalGroup', 'Связь Сотрудники с Группировкой Сотрудников', zc_Object_Personal(), zc_Object_PersonalGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_PersonalServiceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalServiceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_PersonalServiceList', 'Связь Сотрудники с Ведомость начисления(главная)', zc_Object_Personal(), zc_Object_PersonalServiceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalServiceList');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_PersonalServiceListOfficial() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalServiceListOfficial'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_PersonalServiceListOfficial', 'Связь Сотрудники с Ведомость начисления(БН)', zc_Object_Personal(), zc_Object_PersonalServiceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalServiceListOfficial');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_PersonalServiceListCardSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalServiceListCardSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_PersonalServiceListCardSecond', 'Связь Сотрудники с Ведомость начисления(Карта Ф2)', zc_Object_Personal(), zc_Object_PersonalServiceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalServiceListCardSecond');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_SheetWorkTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_SheetWorkTime', 'Связь Сотрудники с Режим работы (Шаблон табеля р.вр.)', zc_Object_Personal(), zc_Object_SheetWorkTime() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_SheetWorkTime');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_StorageLine() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_StorageLine'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_StorageLine', 'Связь Сотрудники с линией производства', zc_Object_Personal(), zc_Object_StorageLine() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_StorageLine');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_PersonalServiceListAvance_F2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalServiceListAvance_F2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_PersonalServiceListAvance_F2', 'Ведомость начисления(аванс Карта Ф2)', zc_Object_Personal(), zc_Object_PersonalServiceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_PersonalServiceListAvance_F2');



CREATE OR REPLACE FUNCTION zc_ObjectLink_AssetGroup_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_AssetGroup_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_AssetGroup_Parent', 'Связь с группой  основных средств', zc_Object_AssetGroup(), zc_Object_AssetGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_AssetGroup_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Asset_AssetGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_AssetGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Asset_AssetGroup', 'Связь основных средств с группой основных средств', zc_Object_Asset(), zc_Object_AssetGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_AssetGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Asset_AssetType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_AssetType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Asset_AssetType', 'Связь основных средств с Типом основных средств', zc_Object_Asset(), zc_Object_AssetType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_AssetType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Asset_PartionModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_PartionModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Asset_PartionModel', 'Связь основных средств с Моделью', zc_Object_Asset(), zc_Object_PartionModel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_PartionModel');


CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionGoods_GoodsKindComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_GoodsKindComplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartionGoods_GoodsKindComplete', 'Вид товара(готовая продукция)', zc_Object_PartionGoods(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_GoodsKindComplete');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionGoods_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartionGoods_Partner', 'Контрагенты', zc_Object_PartionGoods(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Partner');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionGoods_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartionGoods_Goods', 'Товары', zc_Object_PartionGoods(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionGoods_Storage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Storage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartionGoods_Storage', 'Место хранения', zc_Object_PartionGoods(), zc_Object_Storage() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Storage');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionGoods_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartionGoods_Unit', 'Подразделения(для цены)', zc_Object_PartionGoods(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionGoods_PartionModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_PartionModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartionGoods_PartionModel', ' Модель (Партия учета)', zc_Object_PartionGoods(), zc_Object_PartionModel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_PartionModel');
  
CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionGoods_PartionCell() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_PartionCell'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartionGoods_PartionCell', ' Модель (Партия учета)', zc_Object_PartionCell(), zc_Object_PartionModel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionGoods_PartionCell');



CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Juridical_InfoMoney', 'Связь Контрагента с Управленческими аналитиками', zc_Object_Juridical(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Juridical_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_AccountKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Account_AccountKind', 'Связь Счета с Видом счетов', zc_Object_Account(), zc_Object_AccountKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Account_AccountKind');


CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_Goods', 'Товары', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsKind', 'Виды товаров', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKind');
--
CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsSub() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsSub'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsSub', 'Товары (пересортица - расход)', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsSub');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub', 'Виды товаров (пересортица - расход)', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsSubSend() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsSubSend'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsSubSend', 'Товары (перемещ.пересортица - расход)', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsSubSend');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend', 'Виды товаров (перемещ.пересортица - расход)', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend');


CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_Receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_Receipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_Receipt', 'Связь с Рецептурой', zc_Object_GoodsByGoodsKind(), zc_Object_Receipt() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_Receipt');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_ReceiptGP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_ReceiptGP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_ReceiptGP', 'Связь с Рецептурой (схема с тушенкой)', zc_Object_GoodsByGoodsKind(), zc_Object_Receipt() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_ReceiptGP');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsPack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsPack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsPack', 'Товары (для упаковки)', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsPack');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsKindPack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindPack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindPack', 'Виды товаров (для упаковки)', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindPack');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh', 'Категория товара "Штучный"', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom', 'Категория товара "Номинальный"', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves', 'Категория товара "Неноминальный"', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsBrand() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsBrand'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsBrand', 'Бренд товара', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsBrand');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_Goods_Sh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_Goods_Sh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_Goods_Sh', 'Товар (из категории "Штучный")', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_Goods_Sh');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsKind_Sh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKind_Sh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsKind_Sh', 'Вид товара (из категории "Штучный")', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKind_Sh');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsSub_Br() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsSub_Br'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsSub_Br', 'Товары (пересортица на филиалах - расход)', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsSub_Br');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br', 'Виды товаров (пересортица на филиалах - расход)', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsReal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsReal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsReal', 'Товары(факт отгрузка)', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsReal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsKindReal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindReal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindReal', 'Виды товаров(факт отгрузка)', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindReal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsKindNew() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindNew'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindNew', 'Виды товаров (Новые)', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindNew');


CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsIncome() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsIncome'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsIncome', 'Товары (факт приход)', zc_Object_GoodsByGoodsKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsIncome');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind_GoodsKindIncome() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindIncome'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindIncome', 'Виды товаров (факт приход)', zc_Object_GoodsByGoodsKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind_GoodsKindIncome');


--

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReceiptChild_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReceiptChild_Parent', 'Ссылка на рецептуру этого товара', zc_Object_ReceiptChild(), zc_Object_Receipt() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReceiptChild_Receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_Receipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReceiptChild_Receipt', 'Рецептуры', zc_Object_ReceiptChild(), zc_Object_Receipt() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_Receipt');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReceiptChild_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReceiptChild_Goods', 'Товары', zc_Object_ReceiptChild(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReceiptChild_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReceiptChild_GoodsKind', 'Виды товаров', zc_Object_ReceiptChild(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReceiptChild_ReceiptLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_ReceiptLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReceiptChild_ReceiptLevel', 'Этапы производства', zc_Object_ReceiptChild(), zc_Object_ReceiptLevel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptChild_ReceiptLevel');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_Parent', 'Связь рецептуры Главной', zc_Object_Receipt(), zc_Object_Receipt() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_Goods', 'Связь рецептуры с Товаром', zc_Object_Receipt(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_GoodsKind', 'Связь рецептуры с Видом Товаров', zc_Object_Receipt(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_GoodsKindComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_GoodsKindComplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_GoodsKindComplete', 'Связь рецептуры с Виды товаров (готовая продукция)', zc_Object_Receipt(), zc_Object_GoodsKindComplete() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_GoodsKindComplete');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_ReceiptCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_ReceiptCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_ReceiptCost', 'Связь рецептуры с Затраты в рецептурах', zc_Object_Receipt(), zc_Object_ReceiptCost() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_ReceiptCost');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_ReceiptKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_ReceiptKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_ReceiptKind', 'Связь рецептуры с Виды рецептур', zc_Object_Receipt(), zc_Object_ReceiptKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_ReceiptKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Receipt_Parent_old() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_Parent_old'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Receipt_Parent_old', 'Рецептура Главная (история)', zc_Object_Receipt(), zc_Object_Receipt() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Receipt_Parent_old');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_JuridicalBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_JuridicalBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Cash_JuridicalBasis', 'Связь кассы с главным юр лицом', zc_Object_Cash(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_JuridicalBasis');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Cash_Business', 'Связь кассы с бизнесом', zc_Object_Cash(), zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Cash_Business');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Route_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Route_Unit', 'Связь маршрута с Подразделением', zc_Object_Route(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Route_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Route_Branch', 'Связь маршрута с Филиалом', zc_Object_Route(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Route_RouteKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_RouteKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Route_RouteKind', 'Связь маршрута с Типом маршрута', zc_Object_Route(), zc_Object_RouteKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_RouteKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Route_Freight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_Freight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Route_Freight', 'Связь маршрута с Название груза', zc_Object_Route(), zc_Object_Freight() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_Freight');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Route_RouteGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_RouteGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Route_RouteGroup', 'Связь маршрута с группой', zc_Object_Route(), zc_Object_RouteGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Route_RouteGroup');



CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleAction_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_RoleAction_Role', 'Ссылка на роль в справочнике указания ролей', zc_Object_RoleAction(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Role');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleAction_Action() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Action'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_RoleAction_Action', 'Ссылка на действие в справочнике свзяи ролей', zc_Object_RoleAction(), zc_Object_Action() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleAction_Action');

CREATE OR REPLACE FUNCTION zc_ObjectLink_User_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_User_Member', 'Физ лицо', zc_Object_User(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Fuel_RateFuelKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Fuel_RateFuelKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Fuel_RateFuelKind', 'Вид нормы для топлива', zc_Object_Fuel(), zc_Object_RateFuelKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Fuel_RateFuelKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RateFuel_RouteKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RateFuel_RouteKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_RateFuel_RouteKind', 'Тип маршрута', zc_Object_RateFuel(), zc_Object_RateFuelKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RateFuel_RouteKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RateFuel_Car() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RateFuel_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_RateFuel_Car', 'Автомобиль', zc_Object_RateFuel(), zc_Object_RateFuelKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RateFuel_Car');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalGroup_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalGroup_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalGroup_Unit', 'Подразделения', zc_Object_PersonalGroup(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalGroup_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CardFuel_PersonalDriver() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_PersonalDriver'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CardFuel_PersonalDriver', 'Сотрудник (водитель)', zc_Object_CardFuel(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_PersonalDriver');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CardFuel_Car() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CardFuel_Car', 'Автомобиль', zc_Object_CardFuel(), zc_Object_Car() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Car');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CardFuel_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CardFuel_PaidKind', 'Виды формы оплаты', zc_Object_CardFuel(), zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_PaidKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CardFuel_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CardFuel_Juridical', 'Юридическое лицо', zc_Object_CardFuel(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CardFuel_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CardFuel_Goods', 'Товар', zc_Object_CardFuel(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CardFuel_CardFuelKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_CardFuelKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CardFuel_CardFuelKind', 'Статус Топливные карты', zc_Object_CardFuel(), zc_Object_CardFuelKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CardFuel_CardFuelKind');



CREATE OR REPLACE FUNCTION zc_ObjectLink_TicketFuel_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TicketFuel_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_TicketFuel_Goods', 'Товар', zc_Object_CardFuel(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TicketFuel_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_StaffList_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StaffList_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_StaffList_Unit', 'Подразделение', zc_Object_StaffList(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StaffList_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_StaffList_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StaffList_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_StaffList_Position', 'Должность', zc_Object_StaffList(), zc_Object_Position() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StaffList_Position');

CREATE OR REPLACE FUNCTION zc_ObjectLink_StaffList_PositionLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StaffList_PositionLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_StaffList_PositionLevel', 'Разряд должности', zc_Object_StaffList(), zc_Object_PositionLevel() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StaffList_PositionLevel');

-- !!!zc_Object_Contract!!!
CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_Juridical', 'Юридическое лицо', zc_Object_Contract(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_JuridicalBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_JuridicalBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
UPDATE ObjectLinkDesc SET ItemName = 'Юридическое лицо (главное)' WHERE Id = zc_ObjectLink_Contract_JuridicalBasis();
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_JuridicalBasis', 'Юридическое лицо (главное)', zc_Object_Contract(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_JuridicalBasis');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_ContractKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_ContractKind', 'Виды договоров', zc_Object_Contract(), zc_Object_ContractKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_InfoMoney', 'Статья назначения', zc_Object_Contract(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_PaidKind', 'Виды форм оплаты', zc_Object_Contract(), zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PaidKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_Personal', 'Сотрудники (отвественное лицо)', zc_Object_Contract(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Personal');

-- CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
--   SELECT 'zc_ObjectLink_Contract_Area', 'Регион', zc_Object_Contract(), zc_Object_Area() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Area');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_AreaContract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_AreaContract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_AreaContract', 'Регион(договор)', zc_Object_Contract(), zc_Object_AreaContract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_AreaContract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_ContractArticle() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractArticle'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_ContractArticle', 'Предмет договора', zc_Object_Contract(), zc_Object_ContractArticle() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractArticle');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_ContractStateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractStateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_ContractStateKind', 'Состояние договора', zc_Object_Contract(), zc_Object_ContractStateKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractStateKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_Bank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_Bank', 'Банк (исх.платеж)', zc_Object_Contract(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Bank');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_PersonalTrade() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PersonalTrade'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_PersonalTrade', 'Сотрудники (торговый)', zc_Object_Contract(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PersonalTrade');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_PersonalCollation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PersonalCollation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_PersonalCollation', 'Сотрудники (сверка)', zc_Object_Contract(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PersonalCollation');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_PersonalSigning() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PersonalSigning'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_PersonalSigning', 'Сотрудники (подписант)', zc_Object_Contract(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PersonalSigning');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_BankAccount', 'Расч.сч.(вх.платеж) печ.накл.', zc_Object_Contract(), zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_BankAccount');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_ContractTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_ContractTag', 'Признак договора', zc_Object_Contract(), zc_Object_ContractTag() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractTag');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_ContractKey() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractKey'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_ContractKey', 'Ключ договора', zc_Object_Contract(), zc_Object_ContractKey() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractKey');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_JuridicalDocument() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_JuridicalDocument'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_JuridicalDocument', 'Юридические лица(печать док.)', zc_Object_Contract(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_JuridicalDocument');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PriceList'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Contract_PriceList', 'Прайс-лист', zc_Object_Contract(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PriceList');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_PriceListPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PriceListPromo'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Contract_PriceListPromo', 'Прайс-лист(Акционный)', zc_Object_Contract(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PriceListPromo');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_GoodsProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_GoodsProperty', 'Классификаторы свойств товаров', zc_Object_Contract(), zc_Object_GoodsProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_ContractTermKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractTermKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_ContractTermKind', 'Типы пролонгаций договоров', zc_Object_Contract(), zc_Object_ContractTermKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_ContractTermKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Currency'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Contract_Currency', 'Валюта', zc_Object_Contract(), zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Currency');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_GroupMemberSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_GroupMemberSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_GroupMemberSP', 'Категория пациента(СП)', zc_Object_Contract(), zc_Object_GroupMemberSP() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_GroupMemberSP');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_JuridicalInvoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_JuridicalInvoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_JuridicalInvoice', 'Юридические лица(печать док. - реквизиты плательщика)', zc_Object_Contract(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_JuridicalInvoice');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_Member', 'Ответственный за прайс', zc_Object_Contract(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_PriceListGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PriceListGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_PriceListGoods', 'Прайс-лист(Спецификация)', zc_Object_Contract(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_PriceListGoods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Contract_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Contract_Branch', 'Филиал (расчеты нал)', zc_Object_Contract(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Contract_Branch');

--!!! ContractPartner
CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractPartner_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractPartner_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractPartner_Contract', 'Договора', zc_Object_ContractPartner(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractPartner_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractPartner_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractPartner_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractPartner_Partner', 'Контрагент', zc_Object_ContractPartner(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractPartner_Partner');

--!!! ContractConditionPartner
CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractConditionPartner_ContractCondition() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractConditionPartner_ContractCondition'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractConditionPartner_ContractCondition', 'Условие Договора', zc_Object_ContractConditionPartner(), zc_Object_ContractCondition() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractConditionPartner_ContractCondition');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractConditionPartner_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractConditionPartner_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractConditionPartner_Partner', 'Контрагент', zc_Object_ContractConditionPartner(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractConditionPartner_Partner');

--
CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractCondition_ContractConditionKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_ContractConditionKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractCondition_ContractConditionKind', 'Тип условий договора', zc_Object_ContractCondition(), zc_Object_ContractConditionKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_ContractConditionKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractCondition_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractCondition_Contract', 'Договор', zc_Object_ContractCondition(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractCondition_ContractSend() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_ContractSend'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractCondition_ContractSend', 'Договор маркетинга', zc_Object_ContractCondition(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_ContractSend');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractCondition_BonusKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_BonusKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractCondition_BonusKind', 'Договор', zc_Object_ContractCondition(), zc_Object_BonusKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_BonusKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractCondition_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractCondition_InfoMoney', 'Статьи назначения', zc_Object_ContractCondition(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractCondition_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractCondition_PaidKind', ' 	Форма оплаты', zc_Object_ContractCondition(), zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractCondition_PaidKind');

--
CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractPriceList_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractPriceList_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractPriceList_Contract', 'Договор', zc_Object_ContractPriceList(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractPriceList_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractPriceList_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractPriceList_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractPriceList_PriceList', 'Прайс-лист', zc_Object_ContractPriceList(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractPriceList_PriceList');



-- !!!zc_Object_ContractKind!!!
CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractKind_AccountKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKind_AccountKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractKind_AccountKind', 'Типы Счетов', zc_Object_ContractKind(), zc_Object_AccountKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKind_AccountKind');


-- !!!zc_Object_ModelService!!!
CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelService_ModelServiceKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelService_ModelServiceKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelService_ModelServiceKind', 'Типы модели начисления', zc_Object_ModelService(), zc_Object_ModelServiceKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelService_ModelServiceKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelService_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelService_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelService_Unit', 'Подразделение', zc_Object_ModelService(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelService_Unit');

-- !!!zc_Object_StaffListCost!!!
CREATE OR REPLACE FUNCTION zc_ObjectLink_StaffListCost_StaffList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StaffListCost_StaffList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_StaffListCost_StaffList', 'Штатное расписание', zc_Object_StaffListCost(), zc_Object_StaffList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StaffListCost_StaffList');

CREATE OR REPLACE FUNCTION zc_ObjectLink_StaffListCost_ModelService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StaffListCost_ModelService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_StaffListCost_ModelService', 'Штатное расписание', zc_Object_StaffListCost(), zc_Object_ModelService() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StaffListCost_ModelService');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemMaster_ModelService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemMaster_ModelService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemMaster_ModelService', 'Модели начисления', zc_Object_ModelServiceItemMaster(), zc_Object_ModelService() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemMaster_ModelService');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemMaster_From() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemMaster_From'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemMaster_From', 'Подразделения(От кого)', zc_Object_ModelServiceItemMaster(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemMaster_From');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemMaster_To() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemMaster_To'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemMaster_To', 'Подразделения(кому)', zc_Object_ModelServiceItemMaster(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemMaster_To');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemMaster_SelectKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemMaster_SelectKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemMaster_SelectKind', 'Тип выбора данных', zc_Object_ModelServiceItemMaster(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemMaster_SelectKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemMaster_DocumentKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemMaster_DocumentKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemMaster_DocumentKind', 'Тип документа', zc_Object_ModelServiceItemMaster(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemMaster_DocumentKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemChild_From() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_From'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemChild_From', 'Товар(От кого)', zc_Object_ModelServiceItemChild(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_From');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemChild_To() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_To'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemChild_To', 'Товар(кому)', zc_Object_ModelServiceItemChild(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_To');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemChild_FromGoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_FromGoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemChild_FromGoodsKind', 'Вид товара (От кого)', zc_Object_ModelServiceItemChild(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_FromGoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemChild_ToGoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_ToGoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemChild_ToGoodsKind', 'Вид товара (кому)', zc_Object_ModelServiceItemChild(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_ToGoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemChild_FromGoodsKindComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_FromGoodsKindComplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemChild_FromGoodsKindComplete', 'Вид товара (От кого, ГП)', zc_Object_ModelServiceItemChild(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_FromGoodsKindComplete');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemChild_ToGoodsKindComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_ToGoodsKindComplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemChild_ToGoodsKindComplete', 'Вид товара (кому, ГП)', zc_Object_ModelServiceItemChild(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_ToGoodsKindComplete');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster', 'Cсылка на главный элемент', zc_Object_ModelServiceItemChild(), zc_Object_ModelServiceItemMaster() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemChild_FromStorageLine() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_FromStorageLine'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemChild_FromStorageLine', 'Линия производства(От кого)', zc_Object_ModelServiceItemChild(), zc_Object_StorageLine() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_FromStorageLine');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ModelServiceItemChild_ToStorageLine() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_ToStorageLine'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ModelServiceItemChild_ToStorageLine', 'Линия производства(кому)', zc_Object_ModelServiceItemChild(), zc_Object_StorageLine() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ModelServiceItemChild_ToStorageLine');


CREATE OR REPLACE FUNCTION zc_Objectlink_StaffListSumm_StaffList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_Objectlink_StaffListSumm_StaffList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_Objectlink_StaffListSumm_StaffList', 'Cсылка на штатное расписание', zc_Object_StaffListSumm(), zc_Object_StaffList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_Objectlink_StaffListSumm_StaffList');

CREATE OR REPLACE FUNCTION zc_Objectlink_StaffListSumm_StaffListMaster() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_Objectlink_StaffListSumm_StaffListMaster'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_Objectlink_StaffListSumm_StaffListMaster', 'Cсылка на штатное расписание', zc_Object_StaffListSumm(), zc_Object_StaffList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_Objectlink_StaffListSumm_StaffListMaster');

CREATE OR REPLACE FUNCTION zc_Objectlink_StaffListSumm_StaffListSummKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_Objectlink_StaffListSumm_StaffListSummKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_Objectlink_StaffListSumm_StaffListSummKind', 'Cсылка на типы сумм для штатного расписания 	', zc_Object_StaffListSumm(), zc_Object_StaffListSummKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_Objectlink_StaffListSumm_StaffListSummKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleProcessAccess_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleProcessAccess_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RoleProcessAccess_Role', 'Ссылка на роль в справочнике указания ролей', zc_Object_RoleProcessAccess(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleProcessAccess_Role');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleProcessAccess_Process() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleProcessAccess_Process'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RoleProcessAccess_Process', 'Ссылка на роль в справочнике указания ролей', zc_Object_RoleProcessAccess(), zc_Object_Process() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RoleProcessAccess_Process');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractDocument_Contract() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractDocument_Contract'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ContractDocument_Contract', 'Ссылка на договор в справочнике документов договоров', zc_Object_ContractDocument(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractDocument_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Maker_Country() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Maker_Country'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Maker_Country', 'Ссылка на Страну в справочнике Производитель(ОС)', zc_Object_Maker(), zc_Object_Country() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Maker_Country');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Maker_ContactPerson() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Maker_ContactPerson'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Maker_ContactPerson', 'Ссылка на Контактные лица', zc_Object_Maker(), zc_Object_ContactPerson() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Maker_ContactPerson');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Asset_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_Juridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Asset_Juridical', 'Ссылка на Юридические лица в справочнике Основные средства', zc_Object_Asset(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Asset_Maker() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_Maker'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Asset_Maker', 'Ссылка на Производитель(ОС) в справочнике Основные средства', zc_Object_Asset(), zc_Object_Maker() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_Maker');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Asset_Car() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_Car'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Asset_Car', 'Ссылка на авто', zc_Object_Asset(), zc_Object_Car() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Asset_Car');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ToolsWeighing_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ToolsWeighing_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ToolsWeighing_Parent', 'Связь Настройки взвешивания с Настройки взвешивания', zc_Object_ToolsWeighing(), zc_Object_ToolsWeighing() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ToolsWeighing_Parent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsKindWeighing_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsKindWeighing_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsKindWeighing_GoodsKind', 'Виды упаковки', zc_Object_GoodsKindWeighing(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsKindWeighing_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsKindWeighing_GoodsKindWeighingGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsKindWeighing_GoodsKindWeighingGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsKindWeighing_GoodsKindWeighingGroup', 'Связь Виды упаковки для взвешивания с Группы видов упаковки для взвешивания', zc_Object_GoodsKindWeighing(), zc_Object_GoodsKindWeighingGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsKindWeighing_GoodsKindWeighingGroup');

/****  ContractKey  ****/
CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractKey_JuridicalBasis() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_JuridicalBasis'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractKey_JuridicalBasis', 'Ссылка на Главное юр. лицо в справочнике Ключ договора', zc_Object_ContractKey(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_JuridicalBasis');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractKey_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_Juridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractKey_Juridical', 'Ссылка на Юридические лица в справочнике Ключ договора', zc_Object_ContractKey(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractKey_InfoMoney() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_InfoMoney'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractKey_InfoMoney', 'Ссылка на Статьи назначения в справочнике Ключ договора', zc_Object_ContractKey(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractKey_PaidKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_PaidKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractKey_PaidKind', 'Ссылка на Виды форм оплаты в справочнике Ключ договора', zc_Object_ContractKey(), zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_PaidKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractKey_Area() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_Area'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractKey_Area', 'Ссылка на Регион в справочнике Ключ договора', zc_Object_ContractKey(), zc_Object_Area() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_Area');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractKey_ContractTag() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_ContractTag'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractKey_ContractTag', 'Ссылка на Признак договора в справочнике Ключ договора', zc_Object_ContractKey(), zc_Object_ContractTag() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_ContractTag');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractKey_Contract() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_Contract'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractKey_Contract', 'Ссылка на Договор (!!!Последний!!!) в справочнике Ключ договора', zc_Object_ContractKey(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractKey_Contract');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Province_Region() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Province_Region'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Province_Region', 'Ссылка на Область', zc_Object_Province(), zc_Object_Region() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Province_Region');

CREATE OR REPLACE FUNCTION zc_ObjectLink_City_CityKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_City_CityKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_City_CityKind', 'Ссылка на Вид населенного пункта', zc_Object_City(), zc_Object_CityKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_City_CityKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_City_Region() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_City_Region'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_City_Region', 'Ссылка на Область', zc_Object_City(), zc_Object_Region() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_City_Region');

CREATE OR REPLACE FUNCTION zc_ObjectLink_City_Province() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_City_Province'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_City_Province', 'Ссылка на Район', zc_Object_City(), zc_Object_Province() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_City_Province');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ProvinceCity_City() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProvinceCity_City'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ProvinceCity_City', 'Ссылка на Населенный пункт', zc_Object_ProvinceCity(), zc_Object_City() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ProvinceCity_City');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Street_StreetKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Street_StreetKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Street_StreetKind', 'Ссылка на Вид(улица,проспект)', zc_Object_Street(), zc_Object_StreetKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Street_StreetKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Street_City() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Street_City'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Street_City', 'Ссылка на Населенный пункт', zc_Object_Street(), zc_Object_City() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Street_City');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Street_ProvinceCity() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Street_ProvinceCity'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Street_ProvinceCity', 'Ссылка на Район в населенном пункте', zc_Object_Street(), zc_Object_ProvinceCity() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Street_ProvinceCity');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContactPerson_Object() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_Object'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContactPerson_Object', 'Ссылка на Объект', zc_Object_ContactPerson(), NULL WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_Object');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContactPerson_ContactPersonKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_ContactPersonKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContactPerson_ContactPersonKind', 'Ссылка на Вид контакта', zc_Object_ContactPerson(), zc_Object_ContactPersonKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_ContactPersonKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContactPerson_Email() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_Email'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContactPerson_Email', 'Почтовый ящик', zc_Object_ContactPerson(), zc_Object_Email() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_Email');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContactPerson_Retail() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_Retail'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContactPerson_Retail', 'Торговая группа', zc_Object_ContactPerson(), zc_Object_Email() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_Retail');



CREATE OR REPLACE FUNCTION zc_ObjectLink_ArticleLoss_InfoMoney() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ArticleLoss_InfoMoney'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ArticleLoss_InfoMoney', 'Ссылка на Статьи назначения', zc_Object_ArticleLoss(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ArticleLoss_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ArticleLoss_ProfitLossDirection() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ArticleLoss_ProfitLossDirection'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ArticleLoss_ProfitLossDirection', 'Ссылка на Аналитики статей отчета о прибылях и убытках - направление', zc_Object_ArticleLoss(), zc_Object_ProfitLossDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ArticleLoss_ProfitLossDirection');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ArticleLoss_Business() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ArticleLoss_Business'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ArticleLoss_Business', 'Ссылка на Бизнес', zc_Object_ArticleLoss(), zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ArticleLoss_Business');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ArticleLoss_Branch() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ArticleLoss_Branch'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ArticleLoss_Branch', 'Ссылка на Филиал', zc_Object_ArticleLoss(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ArticleLoss_Branch');


CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_Juridical', 'Связь Ведомости начисления с юр лицом', zc_Object_PersonalServiceList(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_PaidKind', 'Связь Ведомости начисления с формой оплаты', zc_Object_PersonalServiceList(), zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_PaidKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_Branch', 'Связь Ведомости начисления с Филиалом', zc_Object_PersonalServiceList(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_Bank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_Bank', 'Связь Ведомости начисления с Банком', zc_Object_PersonalServiceList(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_Bank');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_Member', 'Связь Ведомости начисления с Физ лицом (пользователь)', zc_Object_PersonalServiceList(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_MemberHeadManager() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_MemberHeadManager'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_MemberHeadManager', 'Связь Ведомости начисления с Физ лицом (исполнительный директор)', zc_Object_PersonalServiceList(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_MemberHeadManager');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_MemberManager() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_MemberManager'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_MemberManager', 'Связь Ведомости начисления с Физ лицом (директор)', zc_Object_PersonalServiceList(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_MemberManager');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_MemberBookkeeper() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_MemberBookkeeper'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_MemberBookkeeper', 'Связь Ведомости начисления с Физ лицом (бухгалтер)', zc_Object_PersonalServiceList(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_MemberBookkeeper');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_BankAccount', 'Связь Ведомости начисления с Расчетные счета', zc_Object_PersonalServiceList(), zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_BankAccount');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_PSLExportKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_PSLExportKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_PSLExportKind', 'Связь Ведомости начисления с Тип выгрузки ведомости в банк', zc_Object_PersonalServiceList(), zc_Object_PSLExportKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_PSLExportKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_PersonalHead() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_PersonalHead'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_PersonalHead', 'Руководитель подразделения', zc_Object_PersonalServiceList(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_PersonalHead');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PersonalServiceList_Avance_F2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_Avance_F2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PersonalServiceList_Avance_F2', 'Ведомость начисления (2ф)', zc_Object_PersonalServiceList(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PersonalServiceList_Avance_F2');


---
CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsQuality_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsQuality_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsQuality_Goods', 'Связь Параметры качественного удостоверения с Товаром', zc_Object_GoodsQuality(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsQuality_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsQuality_Quality() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsQuality_Quality'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsQuality_Quality', 'Связь Параметры качественного удостоверения с кач.удостоверением', zc_Object_GoodsQuality(), zc_Object_Quality() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsQuality_Quality');


CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractGoods_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractGoods_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractGoods_Goods', 'Связь Товары в договорах с Товаром', zc_Object_ContractGoods(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractGoods_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractGoods_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractGoods_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractGoods_Contract', 'Связь Товары в договорах с договором', zc_Object_ContractGoods(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractGoods_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractGoods_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractGoods_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractGoods_GoodsKind', 'Связь Товары в договорах с Видом товара', zc_Object_ContractGoods(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractGoods_GoodsKind');


--!!! Quality

CREATE OR REPLACE FUNCTION zc_ObjectLink_Quality_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Quality_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Quality_Juridical', 'Связь качественного удостоверения с Юр лицо', zc_Object_Quality(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Quality_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Quality_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Quality_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Quality_Retail', 'Связь качественного удостоверения с Торговая сеть', zc_Object_Quality(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Quality_Retail');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Quality_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Quality_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Quality_TradeMark', 'Связь качественного удостоверения с Торговые марки', zc_Object_Quality(), zc_Object_TradeMark() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Quality_TradeMark');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Quality_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Quality_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Quality_Retail', 'Связь качественного удостоверения с торговой сетью', zc_Object_Quality(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Quality_Retail');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Quality_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Quality_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Quality_TradeMark', 'Связь качественного удостоверения с торговой маркой', zc_Object_Quality(), zc_Object_TradeMark() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Quality_TradeMark');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Member_InfoMoney', 'Связь физ.лиц со Статьи назначения', zc_Object_Member(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Retail_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_GoodsProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_Retail_GoodsProperty', 'Связь торг.сеть с Классификаторы свойств товаров', zc_Object_Retail(), zc_Object_GoodsProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Retail_PrintKindItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_PrintKindItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_Retail_PrintKindItem', 'Связь торг.сеть с элементами печати', zc_Object_Retail(), zc_Object_PrintKindItem() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_PrintKindItem');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Retail_PersonalMarketing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_PersonalMarketing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_Retail_PersonalMarketing', 'Связь торг.сеть с Сотрудником(Отв. представитель маркет.отдела)', zc_Object_Retail(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_PersonalMarketing');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Retail_PersonalTrade() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_PersonalTrade'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_Retail_PersonalTrade', 'Связь торг.сеть с Сотрудником(Отв. представитель коммерч.отдела)', zc_Object_Retail(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_PersonalTrade');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Retail_ClientKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_ClientKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_Retail_ClientKind', 'Связь торг.сеть с Категории покупателей', zc_Object_Retail(), zc_Object_ClientKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_ClientKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Retail_StickerHeader() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_StickerHeader'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_Retail_StickerHeader', 'Заголовок для сети', zc_Object_Retail(), zc_Object_ClientKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Retail_StickerHeader');


CREATE OR REPLACE FUNCTION zc_ObjectLink_OrderType_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderType_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_OrderType_Unit', 'Связь Тип расчета заявки на производство с Подразделением', zc_Object_OrderType(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderType_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_OrderType_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderType_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_OrderType_Goods', 'Связь Типf расчета заявки на производство с Товаром', zc_Object_OrderType(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderType_Goods');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Branch_Personal', 'Связь Филиала с Сотрудник (бухгалтер) расх.накл.', zc_Object_Branch(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Personal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_PersonalStore() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_PersonalStore'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Branch_PersonalStore', 'Связь Филиала с Сотрудник (кладовщик)', zc_Object_Branch(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_PersonalStore');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_PersonalBookkeeper() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_PersonalBookkeeper'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Branch_PersonalBookkeeper', 'Связь Филиала с Сотрудник (бухгалтер) налог.накл.', zc_Object_Branch(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_PersonalBookkeeper');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Branch_Unit', 'Связь филиала с подразделением (основной склад)', zc_Object_Branch(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_UnitReturn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_UnitReturn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Branch_UnitReturn', 'Связь филиала с подразделением (склад возвратов)', zc_Object_Branch(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_UnitReturn');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_PersonalDriver() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_PersonalDriver'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Branch_PersonalDriver', 'Водитель ТТН', zc_Object_Branch(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_PersonalDriver');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_Member1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Member1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Branch_Member1', 'Водитель/Экспедитор ТТН', zc_Object_Branch(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Member1');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_Member2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Member2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Branch_Member2', 'Бухгалтер ТТН', zc_Object_Branch(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Member2');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_Member3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Member3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Branch_Member3', 'Ответственное лицо(відпуск дозволив) ТТН', zc_Object_Branch(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Member3');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_Member4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Member4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Branch_Member4', 'Ответственное лицо(здав) ТТН', zc_Object_Branch(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Member4');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_Car() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Branch_Car', 'Автомобиль ТТН', zc_Object_Branch(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Branch_Car');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BranchJuridical_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchJuridical_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_BranchJuridical_Branch', 'Связь с филиалом', zc_Object_BranchJuridical(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchJuridical_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BranchJuridical_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchJuridical_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_BranchJuridical_Juridical', 'Связь с юр.лицом', zc_Object_BranchJuridical(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchJuridical_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BranchJuridical_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchJuridical_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_BranchJuridical_Unit', 'Связь с Подразделением', zc_Object_BranchJuridical(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchJuridical_Unit');


CREATE OR REPLACE FUNCTION zc_ObjectLink_BranchPrintKindItem_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchPrintKindItem_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_BranchPrintKindItem_Branch', 'Связь с филиалом', zc_Object_BranchPrintKindItem(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchPrintKindItem_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BranchPrintKindItem_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchPrintKindItem_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_BranchPrintKindItem_Retail', 'Связь с торговой сетью', zc_Object_BranchPrintKindItem(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchPrintKindItem_Retail');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BranchPrintKindItem_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchPrintKindItem_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_BranchPrintKindItem_Juridical', 'Связь с юр.лицом', zc_Object_BranchPrintKindItem(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchPrintKindItem_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BranchPrintKindItem_PrintKindItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchPrintKindItem_PrintKindItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_BranchPrintKindItem_PrintKindItem', 'Связь с Элементами печати', zc_Object_BranchPrintKindItem(), zc_Object_PrintKindItem() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BranchPrintKindItem_PrintKindItem');

--ExportJuridical
CREATE OR REPLACE FUNCTION zc_ObjectLink_ExportJuridical_EmailKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_EmailKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ExportJuridical_EmailKind', 'Связь с Видом почты', zc_Object_ExportJuridical(), zc_Object_EmailKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_EmailKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ExportJuridical_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ExportJuridical_Retail', 'Связь с Торговая сеть', zc_Object_ExportJuridical(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_Retail');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ExportJuridical_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ExportJuridical_Juridical', 'Связь с Юридические лица', zc_Object_ExportJuridical(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ExportJuridical_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ExportJuridical_Contract', 'Связь с Договором', zc_Object_ExportJuridical(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ExportJuridical_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ExportJuridical_InfoMoney', 'Связь с Статьи назначения', zc_Object_ExportJuridical(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ExportJuridical_ExportKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_ExportKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ExportJuridical_ExportKind', 'Связь с Типы экспорта', zc_Object_ExportJuridical(), zc_Object_ExportKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_ExportKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ExportJuridical_ContactPerson() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_ContactPerson'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ExportJuridical_ContactPerson', 'Связь с Контактные лица', zc_Object_ExportJuridical(), zc_Object_ContactPerson() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ExportJuridical_ContactPerson');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Storage_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Storage_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Storage_Unit', 'Связь с Подразделением', zc_Object_Storage(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Storage_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Storage_AreaUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Storage_AreaUnit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Storage_AreaUnit', 'Связь с Участок(Места хранения)', zc_Object_Storage(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Storage_AreaUnit');



CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionRemains_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionRemains_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartionRemains_Unit', 'Связь с Подразделением', zc_Object_PartionRemains(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionRemains_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionRemains_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionRemains_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartionRemains_PartionGoods', 'Связь с Партиями товаров', zc_Object_PartionRemains(), zc_Object_PartionGoods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionRemains_PartionGoods');


CREATE OR REPLACE FUNCTION zc_ObjectLink_SignInternalItem_SignInternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SignInternalItem_SignInternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_SignInternalItem_SignInternal', 'Связь с Модель электронной подписи', zc_Object_SignInternalItem(), zc_Object_SignInternal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SignInternalItem_SignInternal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SignInternalItem_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SignInternalItem_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_SignInternalItem_User', 'Связь с Пользователь', zc_Object_SignInternalItem(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SignInternalItem_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SignInternal_Object() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SignInternal_Object'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_SignInternal_Object', 'Связь с Подразделения/Ведомости начисления', zc_Object_SignInternal(), NULL WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SignInternal_Object');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MobileTariff_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MobileTariff_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MobileTariff_Contract', 'Связь Тарифа с Договором', zc_Object_MobileTariff(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MobileTariff_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MobileEmployee_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MobileEmployee_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MobileEmployee_Personal', 'Связь c Сотрудники', zc_Object_MobileEmployee(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MobileEmployee_Personal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MobileEmployee_MobileTariff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MobileEmployee_MobileTariff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MobileEmployee_MobileTariff', 'Связь c Тарифы мобильных операторов', zc_Object_MobileEmployee(), zc_Object_MobileTariff() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MobileEmployee_MobileTariff');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MobileEmployee_Region() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MobileEmployee_Region'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MobileEmployee_Region', 'Связь c Регионов', zc_Object_MobileEmployee(), zc_Object_Region() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MobileEmployee_Region');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MobileEmployee_MobilePack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MobileEmployee_MobilePack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MobileEmployee_MobilePack', 'Связь c названием пакета', zc_Object_MobileEmployee(), zc_Object_MobilePack() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MobileEmployee_MobilePack');



-- GoodsListSale
CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsListSale_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListSale_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsListSale_Contract', 'Договор', zc_Object_GoodsListSale(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListSale_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsListSale_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListSale_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsListSale_Partner', 'Контрагенты', zc_Object_GoodsListSale(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListSale_Partner');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsListSale_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListSale_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsListSale_Goods', 'Товары', zc_Object_GoodsListSale(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListSale_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsListSale_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListSale_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsListSale_GoodsKind', 'Товары', zc_Object_GoodsListSale(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListSale_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsListSale_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListSale_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsListSale_Juridical', 'Юр.лицо', zc_Object_GoodsListSale(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListSale_Juridical');

-- GoodsListIncome
CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsListIncome_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListIncome_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsListIncome_Contract', 'Договор', zc_Object_GoodsListIncome(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListIncome_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsListIncome_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListIncome_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsListIncome_Partner', 'Контрагенты', zc_Object_GoodsListIncome(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListIncome_Partner');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsListIncome_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListIncome_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsListIncome_Goods', 'Товары', zc_Object_GoodsListIncome(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListIncome_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsListIncome_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListIncome_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsListIncome_GoodsKind', 'Товары', zc_Object_GoodsListIncome(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListIncome_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsListIncome_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListIncome_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsListIncome_Juridical', 'Юр.лицо', zc_Object_GoodsListIncome(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsListIncome_Juridical');
--

CREATE OR REPLACE FUNCTION zc_ObjectLink_SheetWorkTime_DayKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SheetWorkTime_DayKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_SheetWorkTime_DayKind', 'Тип дня', zc_Object_SheetWorkTime(), zc_Object_DayKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SheetWorkTime_DayKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Position_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Position_SheetWorkTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Position_SheetWorkTime', 'Связь Должности с Режим работы (Шаблон табеля р.вр.)', zc_Object_Personal(), zc_Object_SheetWorkTime() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Position_SheetWorkTime');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Position_PositionProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Position_PositionProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Position_PositionProperty', 'Связь Должности с Классификатор должности', zc_Object_Personal(), zc_Object_PositionProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Position_PositionProperty');



---
CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportCollation_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReportCollation_Juridical', 'Юр.лицо', zc_Object_ReportCollation(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportCollation_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReportCollation_Partner', 'Контрагенты', zc_Object_ReportCollation(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_Partner');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportCollation_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReportCollation_Contract', 'Договор', zc_Object_ReportCollation(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportCollation_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
  INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReportCollation_PaidKind', 'Связь с формой оплаты', zc_Object_ReportCollation(), zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_PaidKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportCollation_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReportCollation_InfoMoney', 'УП статья назначения', zc_Object_ReportCollation(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportCollation_Insert() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_Insert'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ReportCollation_Insert', 'Пользователь (создание)', zc_Object_ReportCollation(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_Insert');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportCollation_Buh() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_Buh'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ReportCollation_Buh', 'Пользователь (сдали в бухгалтерию)', zc_Object_ReportCollation(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportCollation_Buh');

CREATE OR REPLACE FUNCTION zc_ObjectLink_StorageLine_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StorageLine_Unit'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_StorageLine_Unit', 'Подразделение', zc_Object_StorageLine(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StorageLine_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DocumentKind_Goods() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DocumentKind_Goods'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_DocumentKind_Goods', 'Товары', zc_Object_DocumentKind(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DocumentKind_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DocumentKind_GoodsKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DocumentKind_GoodsKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_DocumentKind_GoodsKind', 'Виды Товаров', zc_Object_DocumentKind(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DocumentKind_GoodsKind');

--Sticker
CREATE OR REPLACE FUNCTION zc_ObjectLink_Sticker_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_Juridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Sticker_Juridical', 'Юридическое лицо', zc_Object_Sticker(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Sticker_Goods() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_Goods'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Sticker_Goods', 'Товар', zc_Object_Sticker(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Sticker_StickerGroup() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerGroup'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Sticker_StickerGroup', 'Вид продукта (Группа)', zc_Object_Sticker(), zc_Object_StickerGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Sticker_StickerType() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerType'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Sticker_StickerType', 'Способ изготовления продукта', zc_Object_Sticker(), zc_Object_StickerType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Sticker_StickerTag() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerTag'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Sticker_StickerTag', 'Название продукта', zc_Object_Sticker(), zc_Object_StickerTag() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerTag');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Sticker_StickerSort() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerSort'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Sticker_StickerSort', 'Сортность продукта', zc_Object_Sticker(), zc_Object_StickerSort() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerSort');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Sticker_StickerNorm() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerNorm'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Sticker_StickerNorm', 'ТУ или ДСТУ', zc_Object_Sticker(), zc_Object_StickerNorm() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerNorm');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Sticker_StickerFile() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerFile'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Sticker_StickerFile', 'ШАБЛОН', zc_Object_Sticker(), zc_Object_StickerFile() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerFile');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Sticker_StickerFile_70_70() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerFile_70_70'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Sticker_StickerFile_70_70', 'ШАБЛОН 70_70', zc_Object_Sticker(), zc_Object_StickerFile() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Sticker_StickerFile_70_70');


CREATE OR REPLACE FUNCTION zc_ObjectLink_StickerFile_Language() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerFile_Language'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_StickerFile_Language', 'Язык', zc_Object_StickerFile(), zc_Object_Language() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerFile_Language');

CREATE OR REPLACE FUNCTION zc_ObjectLink_StickerFile_TradeMark() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerFile_TradeMark'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_StickerFile_TradeMark', 'Торг.марка', zc_Object_StickerFile(), zc_Object_TradeMark() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerFile_TradeMark');

CREATE OR REPLACE FUNCTION zc_ObjectLink_StickerFile_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerFile_Juridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_StickerFile_Juridical', 'Юр.лицо', zc_Object_StickerFile(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerFile_Juridical');


CREATE OR REPLACE FUNCTION zc_ObjectLink_StickerProperty_Sticker() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_Sticker'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_StickerProperty_Sticker', 'Этикетка', zc_Object_StickerProperty(), zc_Object_Sticker() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_Sticker');

CREATE OR REPLACE FUNCTION zc_ObjectLink_StickerProperty_GoodsKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_GoodsKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_StickerProperty_GoodsKind', 'Вид товара', zc_Object_StickerProperty(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_StickerProperty_StickerSkin() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_StickerSkin'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_StickerProperty_StickerSkin', 'Оболочка', zc_Object_StickerProperty(), zc_Object_StickerSkin() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_StickerSkin');

CREATE OR REPLACE FUNCTION zc_ObjectLink_StickerProperty_StickerPack() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_StickerPack'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_StickerProperty_StickerPack', 'вид пакування', zc_Object_StickerProperty(), zc_Object_StickerPack() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_StickerPack');

CREATE OR REPLACE FUNCTION zc_ObjectLink_StickerProperty_StickerFile() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_StickerFile'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_StickerProperty_StickerFile', 'ШАБЛОН', zc_Object_StickerProperty(), zc_Object_StickerFile() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_StickerFile');
          
CREATE OR REPLACE FUNCTION zc_ObjectLink_StickerProperty_StickerFile_70_70() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_StickerFile_70_70'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_StickerProperty_StickerFile_70_70', 'ШАБЛОН 70_70', zc_Object_StickerProperty(), zc_Object_StickerFile() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_StickerProperty_StickerFile_70_70');


--- 
CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsReportSale_Goods() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsReportSale_Goods'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsReportSale_Goods', 'Товар', zc_Object_GoodsReportSale(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsReportSale_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsReportSale_GoodsKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsReportSale_GoodsKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsReportSale_GoodsKind', 'Вид товара', zc_Object_GoodsReportSale(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsReportSale_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsReportSale_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsReportSale_Unit'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsReportSale_Unit', 'Подразделение', zc_Object_GoodsReportSale(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsReportSale_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberSheetWorkTime_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberSheetWorkTime_Unit'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_MemberSheetWorkTime_Unit', 'Подразделение', zc_Object_MemberSheetWorkTime(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberSheetWorkTime_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberSheetWorkTime_Member() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberSheetWorkTime_Member'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_MemberSheetWorkTime_Member', 'Физ.лицо', zc_Object_MemberSheetWorkTime(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberSheetWorkTime_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList', 'Ведомость начисления', zc_Object_MemberPersonalServiceList(), zc_Object_PersonalServiceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberPersonalServiceList_Member() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberPersonalServiceList_Member'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
 INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_MemberPersonalServiceList_Member', 'Физ.лицо', zc_Object_MemberPersonalServiceList(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberPersonalServiceList_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsSeparate_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsSeparate_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsSeparate_Goods', 'Товары', zc_Object_GoodsSeparate(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsSeparate_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsSeparate_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsSeparate_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsSeparate_GoodsKind', 'Виды товаров', zc_Object_GoodsSeparate(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsSeparate_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsSeparate_GoodsMaster() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsSeparate_GoodsMaster'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsSeparate_GoodsMaster', 'товары', zc_Object_GoodsSeparate(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsSeparate_GoodsMaster');

CREATE OR REPLACE FUNCTION zc_ObjectLink_OrderFinance_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderFinance_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_OrderFinance_PaidKind', 'Форма оплаты', zc_Object_OrderFinance(), zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderFinance_PaidKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_OrderFinance_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderFinance_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_OrderFinance_BankAccount', 'расч.счет', zc_Object_OrderFinance(), zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderFinance_BankAccount');


CREATE OR REPLACE FUNCTION zc_ObjectLink_OrderFinanceProperty_OrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderFinanceProperty_OrderFinance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_OrderFinanceProperty_OrderFinance', 'Виды Планирования платежей', zc_Object_OrderFinanceProperty(), zc_Object_OrderFinance() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderFinanceProperty_OrderFinance');

CREATE OR REPLACE FUNCTION zc_ObjectLink_OrderFinanceProperty_Object() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderFinanceProperty_Object'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_OrderFinanceProperty_Object', 'Управленческие группы назначения/ назначения/ статьи назначения', zc_Object_OrderFinanceProperty(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderFinanceProperty_Object');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalOrderFinance_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalOrderFinance_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalOrderFinance_Juridical', 'Юр. лицо', zc_Object_JuridicalOrderFinance(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalOrderFinance_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalOrderFinance_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalOrderFinance_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalOrderFinance_BankAccount', 'Расчетный счет', zc_Object_JuridicalOrderFinance(), zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalOrderFinance_BankAccount');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalOrderFinance_BankAccountMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalOrderFinance_BankAccountMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalOrderFinance_BankAccountMain', 'Расчетный счет (с которого оплата)', zc_Object_JuridicalOrderFinance(), zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalOrderFinance_BankAccountMain');


CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalOrderFinance_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalOrderFinance_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalOrderFinance_InfoMoney', 'УП статьи назначения', zc_Object_JuridicalOrderFinance(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalOrderFinance_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberBankAccount_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberBankAccount_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberBankAccount_BankAccount', 'Расчетный счет', zc_Object_MemberBankAccount(), zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberBankAccount_BankAccount');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberBankAccount_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberBankAccount_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberBankAccount_Member', 'Физ лицо', zc_Object_MemberBankAccount(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberBankAccount_Member');


CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberMinus_From() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberMinus_From'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberMinus_From', 'Физ лицо', zc_Object_MemberMinus(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberMinus_From');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberMinus_To() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberMinus_To'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberMinus_To', 'Физ лицо (сторонние) / юр. лица', zc_Object_MemberMinus(), zc_Object_MemberExternal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberMinus_To');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberMinus_BankAccountFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberMinus_BankAccountFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberMinus_BankAccountFrom', 'IBAN плательщика платежа', zc_Object_MemberMinus(), zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberMinus_BankAccountFrom');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberMinus_BankAccountTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberMinus_BankAccountTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberMinus_BankAccountTo', 'IBAN получателя платежа', zc_Object_MemberMinus(), zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberMinus_BankAccountTo');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportBonus_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportBonus_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReportBonus_Juridical', 'Юр. лицо', zc_Object_ReportBonus(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportBonus_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportBonus_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportBonus_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReportBonus_Partner', 'Контрагент', zc_Object_ReportBonus(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportBonus_Partner');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportBonus_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportBonus_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReportBonus_Contract', 'Договор', zc_Object_ReportBonus(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportBonus_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportBonus_ContractMaster() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportBonus_ContractMaster'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReportBonus_ContractMaster', 'Бонусный Договор', zc_Object_ReportBonus(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportBonus_ContractMaster');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportBonus_ContractChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportBonus_ContractChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReportBonus_ContractChild', 'Договор база', zc_Object_ReportBonus(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportBonus_ContractChild');


CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberBranch_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberBranch_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberBranch_Branch', 'Филиал', zc_Object_MemberBranch(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberBranch_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberBranch_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberBranch_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberBranch_Member', 'Физ.лицо', zc_Object_MemberBranch(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberBranch_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartnerExternal_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerExternal_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartnerExternal_Partner', 'Контрагент', zc_Object_PartnerExternal(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerExternal_Partner');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartnerExternal_PartnerReal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerExternal_PartnerReal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartnerExternal_PartnerReal', 'Торговая точка РЦ', zc_Object_PartnerExternal(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerExternal_PartnerReal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartnerExternal_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerExternal_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartnerExternal_Contract', 'Договор', zc_Object_PartnerExternal(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerExternal_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartnerExternal_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerExternal_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PartnerExternal_Retail', 'Торговая сеть', zc_Object_PartnerExternal(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerExternal_Retail');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractTradeMark_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractTradeMark_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractTradeMark_Contract', 'Договор', zc_Object_ContractTradeMark(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractTradeMark_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractTradeMark_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractTradeMark_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractTradeMark_TradeMark', 'Торговая марка', zc_Object_ContractTradeMark(), zc_Object_TradeMark() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractTradeMark_TradeMark');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberPriceList_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberPriceList_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberPriceList_PriceList', 'PriceList', zc_Object_MemberPriceList(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberPriceList_PriceList');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberPriceList_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberPriceList_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberPriceList_Member', 'Физ лицо', zc_Object_MemberPriceList(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberPriceList_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReceiptLevel_To() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptLevel_To'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReceiptLevel_To', 'Кому', zc_Object_ReceiptLevel(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptLevel_To');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReceiptLevel_From() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptLevel_From'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReceiptLevel_From', 'От кого', zc_Object_ReceiptLevel(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptLevel_From');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReceiptLevel_DocumentKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptLevel_DocumentKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ReceiptLevel_DocumentKind', 'Типы документов', zc_Object_ReceiptLevel(), zc_Object_DocumentKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReceiptLevel_DocumentKind');



CREATE OR REPLACE FUNCTION zc_ObjectLink_Reason_ReturnKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Reason_ReturnKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Reason_ReturnKind', 'Тип возврата', zc_Object_Reason(), zc_Object_ReturnKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Reason_ReturnKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Reason_ReturnDescKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Reason_ReturnDescKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Reason_ReturnDescKind', 'Признак возврата', zc_Object_Reason(), zc_Object_ReturnDescKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Reason_ReturnDescKind');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Member_Refer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Member_Refer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Member_Refer', 'Фамилия рекомендателя', zc_Object_Personal(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Member_Refer');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_Member_Mentor() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Member_Mentor'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_Member_Mentor', 'Фамилия наставника', zc_Object_Personal(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_Member_Mentor');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Personal_ReasonOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_ReasonOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Personal_ReasonOut', 'Причина увольнения', zc_Object_Personal(), zc_Object_ReasonOut() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Personal_ReasonOut');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalDefermentPayment_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalDefermentPayment_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalDefermentPayment_Juridical', 'Юр.лицо', zc_Object_JuridicalDefermentPayment(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalDefermentPayment_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalDefermentPayment_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalDefermentPayment_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalDefermentPayment_Contract', 'Договор', zc_Object_JuridicalDefermentPayment(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalDefermentPayment_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalDefermentPayment_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalDefermentPayment_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalDefermentPayment_PaidKind', 'Форма оплаты', zc_Object_JuridicalDefermentPayment(), zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalDefermentPayment_PaidKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalDefermentPayment_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalDefermentPayment_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalDefermentPayment_Partner', 'Контрагент', zc_Object_JuridicalDefermentPayment(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalDefermentPayment_Partner');

CREATE OR REPLACE FUNCTION zc_ObjectLink_AreaContract_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_AreaContract_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_AreaContract_Branch', 'Филиал', zc_Object_AreaContract(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_AreaContract_Branch');


CREATE OR REPLACE FUNCTION zc_ObjectLink_UserByGroupList_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserByGroupList_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_UserByGroupList_User', 'Пользователь', zc_Object_UserByGroupList(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserByGroupList_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserByGroupList_UserByGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserByGroupList_UserByGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_UserByGroupList_UserByGroup', 'Группировка пользователя', zc_Object_UserByGroupList(), zc_Object_UserByGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UserByGroupList_UserByGroup');


CREATE OR REPLACE FUNCTION zc_ObjectLink_OrderCarInfo_Route() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderCarInfo_Route'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_OrderCarInfo_Route', 'Маршрут', zc_Object_OrderCarInfo(), zc_Object_Route() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderCarInfo_Route');

CREATE OR REPLACE FUNCTION zc_ObjectLink_OrderCarInfo_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderCarInfo_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_OrderCarInfo_Retail', 'Торговая сеть', zc_Object_OrderCarInfo(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderCarInfo_Retail');

CREATE OR REPLACE FUNCTION zc_ObjectLink_OrderCarInfo_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderCarInfo_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_OrderCarInfo_Unit', 'Подразделение', zc_Object_OrderCarInfo(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderCarInfo_Unit');
       
CREATE OR REPLACE FUNCTION zc_ObjectLink_TradeMark_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TradeMark_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_TradeMark_Retail', 'Торговая сеть', zc_Object_TradeMark(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TradeMark_Retail');
       
CREATE OR REPLACE FUNCTION zc_ObjectLink_Area_TelegramGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Area_TelegramGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Area_TelegramGroup', 'Группа телеграм', zc_Object_Area(), zc_Object_TelegramGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Area_TelegramGroup');
    

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberReport_From() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberReport_From'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberReport_From', 'от кого', zc_Object_MemberReport(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberReport_From');
 
 CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberReport_To() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberReport_To'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberReport_To', 'Кому', zc_Object_MemberReport(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberReport_To');
      
  CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberReport_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberReport_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MemberReport_Member', 'Физ.лицо', zc_Object_MemberReport(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberReport_Member');
 
 --   
  CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_in() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_in'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_in', 'Товар (пересортица - приход)', zc_Object_GoodsByGoodsKindPeresort(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_in');
    
  CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in', 'Вид товара (пересортица - приход)', zc_Object_GoodsByGoodsKindPeresort(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in');
    
  CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_out', 'Товары (пересортица - расход)', zc_Object_GoodsByGoodsKindPeresort(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_out');
    
  CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out', 'Вид товара (пересортица - расход)', zc_Object_GoodsByGoodsKindPeresort(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out');
    
  CREATE OR REPLACE FUNCTION zc_ObjectLink_ViewPriceList_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ViewPriceList_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ViewPriceList_PriceList', 'Прайс лист', zc_Object_ViewPriceList(), zc_Object_PriceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ViewPriceList_PriceList');
     
  CREATE OR REPLACE FUNCTION zc_ObjectLink_ViewPriceList_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ViewPriceList_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ViewPriceList_Member', 'Физ лицо', zc_Object_ViewPriceList(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ViewPriceList_Member');
     
  CREATE OR REPLACE FUNCTION zc_ObjectLink_ChoiceCell_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ChoiceCell_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ChoiceCell_Goods', 'Товар', zc_Object_ChoiceCell(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ChoiceCell_Goods');
     
  CREATE OR REPLACE FUNCTION zc_ObjectLink_ChoiceCell_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ChoiceCell_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ChoiceCell_GoodsKind', 'Вид товара', zc_Object_ChoiceCell(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ChoiceCell_GoodsKind');
     
  CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsNormDiff_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsNormDiff_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsNormDiff_Goods', 'Товара', zc_Object_GoodsNormDiff(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsNormDiff_Goods');
     
  CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsNormDiff_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsNormDiff_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsNormDiff_GoodsKind', 'Вид товара', zc_Object_GoodsNormDiff(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsNormDiff_GoodsKind');
  
  CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsNormDiff_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsNormDiff_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_GoodsNormDiff_GoodsKind', 'Вид товара', zc_Object_GoodsNormDiff(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsNormDiff_GoodsKind');
 
  CREATE OR REPLACE FUNCTION zc_ObjectLink_UnitPeresort_GoodsByGoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitPeresort_GoodsByGoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_UnitPeresort_GoodsByGoodsKind', 'Связь Товар и Вид товара', zc_Object_UnitPeresort(), zc_Object_GoodsByGoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitPeresort_GoodsByGoodsKind');  
  
  CREATE OR REPLACE FUNCTION zc_ObjectLink_UnitPeresort_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitPeresort_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_UnitPeresort_Unit', 'Подразделение', zc_Object_UnitPeresort(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitPeresort_Unit');
  
  CREATE OR REPLACE FUNCTION zc_ObjectLink_MessagePersonalService_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MessagePersonalService_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MessagePersonalService_Member', 'Физическое лицо', zc_Object_MessagePersonalService(), zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MessagePersonalService_Member');

  CREATE OR REPLACE FUNCTION zc_ObjectLink_MessagePersonalService_PersonalServiceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MessagePersonalService_PersonalServiceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MessagePersonalService_PersonalServiceList', 'Ведомость начисления', zc_Object_MessagePersonalService(), zc_Object_PersonalServiceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MessagePersonalService_PersonalServiceList');
  

  CREATE OR REPLACE FUNCTION zc_ObjectLink_MessagePersonalService_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MessagePersonalService_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MessagePersonalService_Unit', 'Подразделение', zc_Object_MessagePersonalService(), zc_Object_PersonalServiceList() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MessagePersonalService_Unit');
           
  CREATE OR REPLACE FUNCTION zc_ObjectLink_Box_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Box_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Box_Goods', 'Товар', zc_Object_Box(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Box_Goods');
  
    
    
    
       
    
    
    
--!!! АПТЕКА

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_NDSKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_NDSKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_NDSKind', 'Связь товаров с Видом НДС', zc_Object_Goods(), zc_Object_NDSKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_NDSKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_IntenalSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_IntenalSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_IntenalSP', 'Міжнародна непатентована назва (2)(СП)', zc_Object_Goods(), zc_Object_IntenalSP() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_IntenalSP');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_BrandSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_BrandSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_BrandSP', 'Торгова назва лікарського засобу (3)(СП)', zc_Object_Goods(), zc_Object_BrandSP() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_BrandSP');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_KindOutSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_KindOutSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_KindOutSP', 'Форма випуску (4)(СП)', zc_Object_Goods(), zc_Object_KindOutSP() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_KindOutSP');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_ConditionsKeep() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_ConditionsKeep'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_ConditionsKeep', 'Условия хранения', zc_Object_Goods(), zc_Object_ConditionsKeep() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_ConditionsKeep');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_Area', 'Регион', zc_Object_Goods(), zc_Object_Area() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Area');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsPairSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsPairSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_GoodsPairSun', 'Пара товара в СУН', zc_Object_Goods(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsPairSun');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportGroup_Object() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportGroup_Object'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportGroup_Object', '', zc_Object_ImportGroup(), NULL WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportGroup_Object');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportGroupItems_ImportSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportGroupItems_ImportSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportGroupItems_ImportSettings', '', zc_Object_ImportGroupItems(), zc_Object_ImportSettings() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportGroupItems_ImportSettings');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportGroupItems_ImportGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportGroupItems_ImportGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportGroupItems_ImportGroup', '', zc_Object_ImportGroupItems(), zc_Object_ImportGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportGroupItems_ImportGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettings_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettings_Contract', 'Связь с договором', zc_Object_ImportSettings(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettings_FileType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_FileType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettings_FileType', 'Связь с Типом файла', zc_Object_ImportSettings(), zc_Object_FileTypeKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_FileType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettings_ImportType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_ImportType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettings_ImportType', 'Связь с Типы импорта', zc_Object_ImportSettings(), zc_Object_ImportType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_ImportType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettings_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettings_Juridical', 'Связь с юр лицом', zc_Object_ImportSettings(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettings_ContactPerson() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_ContactPerson'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettings_ContactPerson', 'Связь с Контактные лица', zc_Object_ImportSettings(), zc_Object_ContactPerson() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_ContactPerson');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettings_EmailKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_EmailKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettings_EmailKind', 'Типы установок для почты', zc_Object_ImportSettings(), zc_Object_EmailKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_EmailKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettings_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettings_Email', 'Почтовый ящик', zc_Object_ImportSettings(), zc_Object_Email() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettings_Email');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettingsItems_ImportSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettingsItems_ImportSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettingsItems_ImportSettings', 'Связь с Настройки импорта', zc_Object_ImportSettingsItems(), zc_Object_ImportSettings() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettingsItems_ImportSettings');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportSettingsItems_ImportTypeItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettingsItems_ImportTypeItems'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportSettingsItems_ImportTypeItems', 'Связь с элементом настройки импорта', zc_Object_ImportSettingsItems(), zc_Object_ImportTypeItems() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportSettingsItems_ImportTypeItems');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportTypeItems_ImportSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportTypeItems_ImportSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ImportTypeItems_ImportSettings', 'Связь с элементом настройки импорта', zc_Object_ImportTypeItems(), zc_Object_ImportSettings() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportTypeItems_ImportSettings');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ImportTypeItems_ImportType() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportTypeItems_ImportType'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ImportTypeItems_ImportType', 'Ссылка на тип импорта', zc_Object_ImportTypeItems(), zc_Object_ImportType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ImportTypeItems_ImportType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalSettings_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalSettings_Juridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalSettings_Juridical', 'Ссылка на юридическое лицо', zc_Object_JuridicalSettings(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalSettings_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalSettings_MainJuridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalSettings_MainJuridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalSettings_MainJuridical', 'Ссылка на главное юридическое лицо', zc_Object_JuridicalSettings(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalSettings_MainJuridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalSettings_Retail() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalSettings_Retail'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalSettings_Retail', 'Ссылка на торговую сеть', zc_Object_JuridicalSettings(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalSettings_Retail');


CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceGroupSettings_Retail() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceGroupSettings_Retail'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PriceGroupSettings_Retail', 'Ссылка на торговую сеть', zc_Object_PriceGroupSettings(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceGroupSettings_Retail');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceGroupSettingsTOP_Retail() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceGroupSettingsTOP_Retail'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PriceGroupSettingsTOP_Retail', 'Ссылка на торговую сеть', zc_Object_PriceGroupSettingsTOP(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceGroupSettingsTOP_Retail');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CorrespondentAccount_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CorrespondentAccount_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CorrespondentAccount_BankAccount', 'обычный счет, для которого указан Корреспондентский счет', zc_Object_CorrespondentAccount(), zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CorrespondentAccount_BankAccount');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CorrespondentAccount_Bank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CorrespondentAccount_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CorrespondentAccount_Bank', '	в каком банке находится Корреспондентский счет', zc_Object_CorrespondentAccount(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CorrespondentAccount_Bank');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CashRegister_CashRegisterKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CashRegister_CashRegisterKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CashRegister_CashRegisterKind', 'Тип кассового аппарата', zc_Object_CashRegister(), zc_Object_CashRegisterKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CashRegister_CashRegisterKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Price_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Price_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Price_Goods', 'Товар', zc_Object_Price(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Price_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Price_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Price_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Price_Unit', 'Подразделение', zc_Object_Price(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Price_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_AlternativeGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_AlternativeGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_AlternativeGroup', 'Группа альтернативных товаров', zc_Object_Goods(), zc_Object_AlternativeGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_AlternativeGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportSoldParams_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportSoldParams_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ReportSoldParams_Unit', 'Подразделение плана продаж', zc_Object_ReportSoldParams(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportSoldParams_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ReportPromoParams_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportPromoParams_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ReportPromoParams_Unit', 'Подразделение плана по маркетингу', zc_Object_ReportPromoParams(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ReportPromoParams_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_AdditionalGoods_GoodsMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_AdditionalGoods_GoodsMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_AdditionalGoods_GoodsMain', 'Главный товар в дополнительных товарах', zc_Object_AdditionalGoods(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_AdditionalGoods_GoodsMain');

CREATE OR REPLACE FUNCTION zc_ObjectLink_AdditionalGoods_GoodsSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_AdditionalGoods_GoodsSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_AdditionalGoods_GoodsSecond', 'Второстепенный товар в дополнительных товарах', zc_Object_AdditionalGoods(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_AdditionalGoods_GoodsSecond');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Appointment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Appointment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_Appointment', 'Назначение товара', zc_Object_Goods(), zc_Object_Appointment() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Appointment');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_MarginCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_MarginCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_MarginCategory', 'Категория для переоценки', zc_Object_Unit(), zc_Object_MarginCategory() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_MarginCategory');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_Education() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Education'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Member_Education', 'Связь физ.лиц со Специальностью', zc_Object_Member(), zc_Object_Education() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Education');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_ObjectTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_ObjectTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Member_ObjectTo', 'Связь физ.лиц с сотрудник/учредитель/подразделение', zc_Object_Member(), zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_ObjectTo');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_Bank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Member_Bank', 'Банк (Ф1)', zc_Object_Member(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Bank');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_BankSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_BankSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Member_BankSecond', 'Банк (Ф2 - Восток)', zc_Object_Member(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_BankSecond');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_BankSecondTwo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_BankSecondTwo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Member_BankSecondTwo', 'Банк (Ф2 - ОТП)', zc_Object_Member(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_BankSecondTwo');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_BankSecondDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_BankSecondDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Member_BankSecondDiff', 'Банк (Ф2 - личный)', zc_Object_Member(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_BankSecondDiff');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_BankChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_BankChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Member_BankChild', 'Связь физ.лиц с Банком алименты', zc_Object_Member(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_BankChild');



CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_UnitMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_UnitMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Member_UnitMobile', 'Связь физ.лиц с Подразделение(заявки мобильный)', zc_Object_Member(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_UnitMobile');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_UserFarmacyCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UserFarmacyCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_UserFarmacyCash', 'Связь подразделения с Пользователь последнего сеанса с FarmacyCash', zc_Object_Unit(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UserFarmacyCash');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_ProvinceCity() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_ProvinceCity'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_ProvinceCity', 'Ссылка на Район', zc_Object_Unit(), zc_Object_ProvinceCity() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_ProvinceCity');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_UserManager() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UserManager'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_UserManager', 'Ссылка на Пользователя', zc_Object_Unit(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UserManager');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_UserManager2() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UserManager2'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_UserManager2', 'Ссылка на Пользователя 2', zc_Object_Unit(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UserManager2');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_UserManager3() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UserManager3'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_UserManager3', 'Ссылка на Пользователя 3', zc_Object_Unit(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UserManager3');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_UnitRePrice() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UnitRePrice'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_UnitRePrice', 'Ссылка на Аптеку к которой уравниваются цены в автомат режиме', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UnitRePrice');

CREATE OR REPLACE FUNCTION zc_ObjectLink_OverSettings_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OverSettings_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_OverSettings_Unit', 'Подразделение', zc_Object_OverSettings(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OverSettings_Unit');


CREATE OR REPLACE FUNCTION zc_ObjectLink_BarCode_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BarCode_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_BarCode_Goods', 'Товар', zc_Object_BarCode(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BarCode_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BarCode_Object() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BarCode_Object'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_BarCode_Object', 'Проект (дисконтные карты)', zc_Object_BarCode(), zc_Object_DiscountExternal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BarCode_Object');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountCard_Object() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountCard_Object'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_DiscountCard_Object', 'Проект (дисконтные карты)', zc_Object_DiscountCard(), zc_Object_DiscountExternal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountCard_Object');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountExternalTools_DiscountExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalTools_DiscountExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_DiscountExternalTools_DiscountExternal', 'Проект (дисконтные карты)', zc_Object_DiscountExternalTools(), zc_Object_DiscountExternal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalTools_DiscountExternal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountExternalTools_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalTools_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_DiscountExternalTools_Unit', 'Подразделение', zc_Object_DiscountExternalTools(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalTools_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountExternalJuridical_DiscountExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalJuridical_DiscountExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_DiscountExternalJuridical_DiscountExternal', 'Проект (дисконтные карты)', zc_Object_DiscountExternalJuridical(), zc_Object_DiscountExternal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalJuridical_DiscountExternal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountExternalJuridical_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalJuridical_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_DiscountExternalJuridical_Juridical', 'Юридическое лицо', zc_Object_DiscountExternalJuridical(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalJuridical_Juridical');


CREATE OR REPLACE FUNCTION zc_ObjectLink_OrderShedule_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderShedule_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_OrderShedule_Unit', 'Связь с Подразделением', zc_Object_OrderShedule(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderShedule_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_OrderShedule_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderShedule_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_OrderShedule_Contract', 'Связь с договором', zc_Object_OrderShedule(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_OrderShedule_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartnerMedical_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerMedical_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PartnerMedical_Juridical', 'Связь с Юридические лица', zc_Object_PartnerMedical(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerMedical_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartnerMedical_Department() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerMedical_Department'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PartnerMedical_Department', 'Связь с Департаментом охраны здоровья', zc_Object_PartnerMedical(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartnerMedical_Department');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MedicSP_PartnerMedical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicSP_PartnerMedical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MedicSP_PartnerMedical', 'Связь с Мед.учрежд.', zc_Object_MedicSP(), zc_Object_PartnerMedical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicSP_PartnerMedical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalArea_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalArea_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalArea_Juridical', 'Юридическое лицо', zc_Object_JuridicalArea(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalArea_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalArea_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalArea_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalArea_Area', 'Регион', zc_Object_JuridicalArea(), zc_Object_Area() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalArea_Area');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Fiscal_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Fiscal_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Fiscal_Unit', 'Аптека', zc_Object_Fiscal(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Fiscal_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberSP_PartnerMedical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberSP_PartnerMedical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MemberSP_PartnerMedical', 'Связь с Мед.учрежд.', zc_Object_MemberSP(), zc_Object_PartnerMedical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberSP_PartnerMedical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberSP_GroupMemberSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberSP_GroupMemberSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MemberSP_GroupMemberSP', 'Связь с Категория пациента(Соц. проект)', zc_Object_MemberSP(), zc_Object_GroupMemberSP() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberSP_GroupMemberSP');


CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalLegalAddress_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalLegalAddress_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalLegalAddress_Juridical', 'Связь Юридического адреса с Юридическим лицом', zc_Object_JuridicalLegalAddress(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalLegalAddress_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalActualAddress_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalActualAddress_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalActualAddress_Juridical', 'Связь Фактического адреса с Юридическим лицом', zc_Object_JuridicalActualAddress(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalActualAddress_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalLegalAddress_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalLegalAddress_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalLegalAddress_Address', 'Юридический адрес', zc_Object_JuridicalLegalAddress(), zc_Object_Address() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalLegalAddress_Address');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalActualAddress_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalActualAddress_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalActualAddress_Address', 'Фактический адрес', zc_Object_JuridicalActualAddress(), zc_Object_Address() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalActualAddress_Address');

--
CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyBox_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyBox_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyBox_Goods', 'Связь с Товарами', zc_Object_GoodsPropertyBox(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyBox_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyBox_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyBox_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyBox_GoodsKind', 'Связь с Видами товаров', zc_Object_GoodsPropertyBox(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyBox_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyBox_Box() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyBox_Box'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsPropertyBox_Box', 'Связь с ящиком', zc_Object_GoodsPropertyBox(), zc_Object_Box() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsPropertyBox_Box');


CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceChange_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceChange_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_PriceChange_Goods', 'Товар сети', zc_Object_PriceChange(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceChange_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceChange_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceChange_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_PriceChange_Retail', 'Торговая сеть', zc_Object_PriceChange(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceChange_Retail');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceChange_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceChange_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_PriceChange_Unit', 'Подразделение', zc_Object_PriceChange(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceChange_Unit');

CREATE OR REPLACE FUNCTION zc_Object_Accommodation_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_Object_Accommodation_Unit'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_Object_Accommodation_Unit', 'Связь размещения с подразделением', zc_Object_Unit(), zc_Object_Accommodation() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_Object_Accommodation_Unit');
  
CREATE OR REPLACE FUNCTION zc_Object_Accommodation_Goods() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_Object_Accommodation_Goods'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_Object_Accommodation_Goods', 'Связь размещения с подразделением', zc_Object_Goods(), zc_Object_Accommodation() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_Object_Accommodation_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MakerReport_Maker() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MakerReport_Maker'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MakerReport_Maker', 'Ссылка на Производитель', zc_Object_MakerReport(), zc_Object_Maker() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MakerReport_Maker');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MakerReport_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MakerReport_Juridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_MakerReport_Juridical', 'Ссылка на Юридические лица', zc_Object_MakerReport(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MakerReport_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalSettingsItem_JuridicalSettings() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalSettingsItem_JuridicalSettings'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_JuridicalSettingsItem_JuridicalSettings', 'Ссылка на Установки для юр. лиц', zc_Object_JuridicalSettingsItem(), zc_Object_JuridicalSettings() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalSettingsItem_JuridicalSettings');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SettingsServiceItem_SettingsService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SettingsServiceItem_SettingsService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_SettingsServiceItem_SettingsService', 'Связь с Ограничение на просмотр журнала услуг', zc_Object_SettingsServiceItem(), zc_Object_SettingsService() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SettingsServiceItem_SettingsService');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SettingsServiceItem_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SettingsServiceItem_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_SettingsServiceItem_InfoMoneyDestination', 'Связь с Управленческие назначения', zc_Object_SettingsServiceItem(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SettingsServiceItem_InfoMoneyDestination');

CREATE OR REPLACE FUNCTION zc_ObjectLink_TaxUnit_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TaxUnit_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_TaxUnit_Unit', 'Подразделение', zc_Object_TaxUnit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_TaxUnit_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RetailCostCredit_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RetailCostCredit_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RetailCostCredit_Retail', 'Торговая сеть', zc_Object_RetailCostCredit(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RetailCostCredit_Retail');

--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!
--------------------------- !!! ВРЕМЕННЫЕ ОБЪЕКТЫ !!!
--------------------------- !!!!!!!!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner1CLink_Partner() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner1CLink_Partner'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner1CLink_Partner', 'Ссылка на точку доставки в объекте связь точек доставки и кодов в 1С', zc_Object_Partner1CLink(), zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner1CLink_Partner');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner1CLink_Branch() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner1CLink_Branch'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Partner1CLink_Branch', 'Ссылка на филиал в объекте связь точек доставки и кодов в 1С', zc_Object_Partner1CLink(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Partner1CLink_Branch');


CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind1CLink_Branch() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind1CLink_Branch'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsByGoodsKind1CLink_Branch', '', zc_Object_GoodsByGoodsKind1CLink(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind1CLink_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind', '', zc_Object_GoodsByGoodsKind1CLink(), zc_Object_GoodsByGoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Protocol_Insert() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Protocol_Insert'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Protocol_Insert', 'Пользователь (создание)', zc_Object_Contract(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Protocol_Insert');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Protocol_Update() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Protocol_Update'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Protocol_Update', 'Пользователь (корректировка)', zc_Object_Contract(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Protocol_Update');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Founder_InfoMoney() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Founder_InfoMoney'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Founder_InfoMoney', 'УП Статьи назначения', zc_Object_Founder(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Founder_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceList_Currency() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceList_Currency'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PriceList_Currency', 'Валюта', zc_Object_PriceList(), zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceList_Currency');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsExternal_Goods() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsExternal_Goods'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsExternal_Goods', 'Товар', zc_Object_GoodsExternal(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsExternal_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsExternal_GoodsKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsExternal_GoodsKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsExternal_GoodsKind', 'Виды Товара', zc_Object_GoodsExternal(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsExternal_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_EmailSettings_EmailKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_EmailSettings_EmailKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_EmailSettings_EmailKind', 'Типы установок для почты', zc_Object_EmailSettings(), zc_Object_EmailKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_EmailSettings_EmailKind');
--update  ObjectLinkDesc set ItemName = 'Вид почты' where Id = zc_ObjectLink_EmailSettings_EmailKind()  -- ДЛЯ ПРОДЖЕКТА

CREATE OR REPLACE FUNCTION zc_ObjectLink_EmailSettings_Email() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_EmailSettings_Email'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_EmailSettings_Email', 'Почтовый ящик', zc_Object_EmailSettings(), zc_Object_Email() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_EmailSettings_Email');

CREATE OR REPLACE FUNCTION zc_ObjectLink_EmailSettings_EmailTools() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_EmailSettings_EmailTools'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_EmailSettings_EmailTools', 'Параметры установок для почты', zc_Object_EmailSettings(), zc_Object_EmailTools() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_EmailSettings_EmailTools');

CREATE OR REPLACE FUNCTION zc_ObjectLink_EmailSettings_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_EmailSettings_Juridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_EmailSettings_Juridical', 'Юридические лица', zc_Object_EmailSettings(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_EmailSettings_Juridical');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Email_EmailKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Email_EmailKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Email_EmailKind', 'Тип почтового ящика', zc_Object_Email(), zc_Object_EmailKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Email_EmailKind');
 
CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractSettings_MainJuridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractSettings_MainJuridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractSettings_MainJuridical', 'Ссылка на Главное юр.лицо', zc_Object_ContractSettings(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractSettings_MainJuridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractSettings_Contract() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractSettings_Contract'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractSettings_Contract', 'Ссылка на договор', zc_Object_ContractSettings(), zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractSettings_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContractSettings_Area() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractSettings_Area'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContractSettings_Area', 'Ссылка на регион', zc_Object_ContractSettings(), zc_Object_Area() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContractSettings_Area');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContactPerson_Area() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_Area'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_ContactPerson_Area', 'Регион', zc_Object_ContactPerson(), zc_Object_Area() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_Area');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Exchange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Exchange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_Exchange', 'Связь товаров с одиницей виміру', zc_Object_Goods(), zc_Object_Exchange() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_Exchange');
	
CREATE OR REPLACE FUNCTION zc_ObjectLink_Protocol_ReCalc() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Protocol_ReCalc'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Protocol_ReCalc', 'Пользователь (пересчет)', zc_Object_Contract(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Protocol_ReCalc');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RepriceUnitSheduler_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RepriceUnitSheduler_Juridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RepriceUnitSheduler_Juridical', 'Наше юр. лицо', zc_Object_RepriceUnitSheduler(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RepriceUnitSheduler_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RepriceUnitSheduler_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RepriceUnitSheduler_Unit'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RepriceUnitSheduler_Unit', 'Связь с Подразделением', zc_Object_RepriceUnitSheduler(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RepriceUnitSheduler_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RepriceUnitSheduler_User() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RepriceUnitSheduler_User'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RepriceUnitSheduler_User', 'Связь с Пользователем', zc_Object_RepriceUnitSheduler(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RepriceUnitSheduler_User');


CREATE OR REPLACE FUNCTION zc_ObjectLink_RecalcMCSSheduler_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RecalcMCSSheduler_Unit'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RecalcMCSSheduler_Unit', 'Связь с Подразделением', zc_Object_RecalcMCSSheduler(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RecalcMCSSheduler_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RecalcMCSSheduler_User() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RecalcMCSSheduler_User'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RecalcMCSSheduler_User', 'Связь с Пользователем', zc_Object_RecalcMCSSheduler(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RecalcMCSSheduler_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_RecalcMCSSheduler_UserRun() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RecalcMCSSheduler_UserRun'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_RecalcMCSSheduler_UserRun', 'Кто выполнил пересчет', zc_Object_RecalcMCSSheduler(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_RecalcMCSSheduler_UserRun');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsCategory_Goods() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsCategory_Goods'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsCategory_Goods', 'Товар Главный', zc_Object_GoodsCategory(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsCategory_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsCategory_Category() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsCategory_Category'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsCategory_Category', 'Категория подразделения(A-B-C)', zc_Object_GoodsCategory(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsCategory_Category');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsCategory_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsCategory_Unit'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsCategory_Unit', 'Подразделение', zc_Object_GoodsCategory(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsCategory_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UnitBankPOSTerminal_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitBankPOSTerminal_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_UnitBankPOSTerminal_Unit', 'Ссылка на подразделение', zc_Object_UnitBankPOSTerminal(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitBankPOSTerminal_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UnitBankPOSTerminal_BankPOSTerminal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitBankPOSTerminal_BankPOSTerminal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_UnitBankPOSTerminal_BankPOSTerminal', 'Ссылка на банков POS терминалов', zc_Object_UnitBankPOSTerminal(), zc_Object_BankPOSTerminal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitBankPOSTerminal_BankPOSTerminal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_User_Helsi_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_Helsi_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_User_Helsi_Unit', 'Связь с Подразделением для которого зарегестрирован ключ', zc_Object_User(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_Helsi_Unit');


CREATE OR REPLACE FUNCTION zc_ObjectLink_CreditLimitJuridical_Provider() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CreditLimitJuridical_Provider'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CreditLimitJuridical_Provider', 'Поставщик', zc_Object_CreditLimitJuridical(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CreditLimitJuridical_Provider');
  
CREATE OR REPLACE FUNCTION zc_ObjectLink_CreditLimitJuridical_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CreditLimitJuridical_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_CreditLimitJuridical_Juridical', 'Наше юр. лицо', zc_Object_CreditLimitJuridical(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CreditLimitJuridical_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_UnitOverdue() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UnitOverdue'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_UnitOverdue', 'Подразделение для перемещения просроченного товара', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UnitOverdue');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_UnitOld() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UnitOld'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_UnitOld', 'Старое подразделениие (закрытое)', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UnitOld');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsGroupPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroupPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Goods_GoodsGroupPromo', 'Связь товаров с группой товаров маркетинга', zc_Object_Goods(), zc_Object_GoodsGroupPromo() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsGroupPromo');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Driver() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Driver'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_Driver', 'Водитель для развозки товара', zc_Object_Unit(), zc_Object_Driver() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Driver');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Layout() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Layout'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Unit_Layout', 'Название выкладки', zc_Object_Unit(), zc_Object_Layout() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_Layout');


CREATE OR REPLACE FUNCTION zc_ObjectLink_PayrollType_PayrollGroup() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PayrollType_PayrollGroup'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PayrollType_PayrollGroup', 'Группа расчета заработной платы', zc_Object_PayrollType(), zc_Object_PayrollGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PayrollType_PayrollGroup');

CREATE OR REPLACE FUNCTION zc_ObjectLink_WorkTimeKind_PayrollType() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_WorkTimeKind_PayrollType'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_WorkTimeKind_PayrollType', 'Тип расчета заработной платы', zc_Object_WorkTimeKind(), zc_Object_PayrollType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_WorkTimeKind_PayrollType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_WorkTimeKind_PairDay() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_WorkTimeKind_PairDay'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_WorkTimeKind_PairDay', 'Вид смены', zc_Object_WorkTimeKind(), zc_Object_PairDay() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_WorkTimeKind_PairDay');



CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Member_Position', 'Связь Физ. лица с должностью', zc_Object_Member(), zc_Object_Position() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Position');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Member_Unit', 'Связь Физ. лица с Подразделением', zc_Object_Member(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Unit');

--
CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_Gender() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Gender'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Member_Gender', 'Связь Физ. лица с Пол', zc_Object_Member(), zc_Object_Gender() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Gender');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_MemberSkill() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_MemberSkill'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Member_MemberSkill', 'Связь Физ. лица с Область, адрес прописки', zc_Object_Member(), zc_Object_MemberSkill() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_MemberSkill');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_JobSource() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_JobSource'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Member_JobSource', 'Связь Физ. лица с Город/село/пгт, адрес прописки', zc_Object_Member(), zc_Object_JobSource() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_JobSource');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_Region() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Region'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Member_Region', 'Связь Физ. лица с Область, адрес проживания', zc_Object_Member(), zc_Object_Region() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Region');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_City() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_City'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Member_City', 'Связь Физ. лица с Город/село/пгт, адрес прописки', zc_Object_Member(), zc_Object_City() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_City');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_Region_Real() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Region_Real'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Member_Region_Real', 'Связь Физ. лица с Область, адрес проживания', zc_Object_Member(), zc_Object_Region() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_Region_Real');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_City_Real() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_City_Real'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Member_City_Real', 'Связь Физ. лица с Город/село/пгт, адрес проживания', zc_Object_Member(), zc_Object_City() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_City_Real');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Member_RouteNum() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_RouteNum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Member_RouteNum', 'Связь Физ. лица Маршрутка', zc_Object_Member(), zc_Object_City() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Member_RouteNum');


--

CREATE OR REPLACE FUNCTION zc_ObjectLink_LabReceiptChild_LabMark() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_LabReceiptChild_LabMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_LabReceiptChild_LabMark', 'Связь Нормы для исследования с Название показателя (вид исследования)', zc_Object_LabReceiptChild(), zc_Object_LabMark() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_LabReceiptChild_LabMark');

CREATE OR REPLACE FUNCTION zc_ObjectLink_LabReceiptChild_Goods() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_LabReceiptChild_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_LabReceiptChild_Goods', 'Связь Нормы для исследования с Реактивы (товар)', zc_Object_LabReceiptChild(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_LabReceiptChild_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_LabMark_LabProduct() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_LabMark_LabProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_LabMark_LabProduct', 'Связь Название показателя с Продукт исследования', zc_Object_LabMark(), zc_Object_LabProduct() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_LabMark_LabProduct');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PlanIventory_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PlanIventory_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PlanIventory_Unit', 'Связь с Аптекой', zc_Object_PlanIventory(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PlanIventory_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PlanIventory_Member() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PlanIventory_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PlanIventory_Member', 'Связь с ФИО ответственного', zc_Object_PlanIventory(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PlanIventory_Member');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PlanIventory_MemberReturn() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PlanIventory_MemberReturn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PlanIventory_MemberReturn', 'Связь с ФИО ответственного за возврат', zc_Object_PlanIventory(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PlanIventory_MemberReturn');


CREATE OR REPLACE FUNCTION zc_ObjectLink_SunExclusion_From() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SunExclusion_From'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_SunExclusion_From', 'От кого', zc_Object_SunExclusion(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SunExclusion_From');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SunExclusion_To() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SunExclusion_To'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_SunExclusion_To', 'Кому', zc_Object_SunExclusion(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SunExclusion_To');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Hardware_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Hardware_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Hardware_Unit', 'Связь с Подразделением', zc_Object_Hardware(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Hardware_Unit');


CREATE OR REPLACE FUNCTION zc_ObjectLink_Hardware_CashRegister() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Hardware_CashRegister'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Hardware_CashRegister', 'Связь с Подразделением', zc_Object_Hardware(), zc_Object_CashRegister() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Hardware_CashRegister');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_DiscountExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_DiscountExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_DiscountExternal', 'Товар для проекта (дисконтные карты)', zc_Object_Goods(), zc_Object_Measure() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_DiscountExternal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionHouseholdInventory_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionHouseholdInventory_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PartionHouseholdInventory_Unit', 'Связь с Подразделением', zc_Object_PartionHouseholdInventory(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionHouseholdInventory_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CommentSend_CommentTR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CommentSend_CommentTR'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CommentSend_CommentTR', 'Связь с Комментарием строк технического переучета', zc_Object_CommentSend(), zc_Object_CommentTR() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CommentSend_CommentTR');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalPriorities_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalPriorities_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_JuridicalPriorities_Juridical', 'Связь с поставщиком', zc_Object_JuridicalPriorities(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalPriorities_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalPriorities_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalPriorities_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_JuridicalPriorities_Goods', 'Связь с главным товаром', zc_Object_JuridicalPriorities(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_JuridicalPriorities_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_UnitSAUA() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UnitSAUA'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Unit_UnitSAUA', 'Связь со Slave в системе автоматического управления ассортиментом САУА', zc_Object_Unit(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Unit_UnitSAUA');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MedicSP_AmbulantClinicSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicSP_AmbulantClinicSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MedicSP_AmbulantClinicSP', 'Связь с Амбулаторией', zc_Object_MedicSP(), zc_Object_AmbulantClinicSP() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicSP_AmbulantClinicSP');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Maker_Juridical() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Maker_Juridical'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_Maker_Juridical', 'Юр. лицо поставщик', zc_Object_Maker(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Maker_Juridical');
  
CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_UnitSupplementSUN1Out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_UnitSupplementSUN1Out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_UnitSupplementSUN1Out', 'Подразделения для отправки по дополнению СУН1', zc_Object_Goods(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_UnitSupplementSUN1Out');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_UnitSupplementSUN2Out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_UnitSupplementSUN2Out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_UnitSupplementSUN2Out', 'Подразделения для отправки по дополнению СУН1', zc_Object_Goods(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_UnitSupplementSUN2Out');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Instructions_InstructionsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Instructions_InstructionsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Instructions_InstructionsKind', 'Связь с разделами инструкций', zc_Object_Instructions(), zc_Object_InstructionsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Instructions_InstructionsKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountExternalSupplier_DiscountExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalSupplier_DiscountExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_DiscountExternalSupplier_DiscountExternal', 'Связь с проектом (дисконтные карты)', zc_Object_DiscountExternalSupplier(), zc_Object_DiscountExternal() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalSupplier_DiscountExternal');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiscountExternalSupplier_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalSupplier_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_DiscountExternalSupplier_Juridical', 'Связь с юридическим лицом', zc_Object_DiscountExternalSupplier(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiscountExternalSupplier_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_FinalSUAProtocol_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_FinalSUAProtocol_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_FinalSUAProtocol_User', 'Связь с пользователем', zc_Object_FinalSUAProtocol(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_FinalSUAProtocol_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_User_LikiDnepr_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_LikiDnepr_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_User_LikiDnepr_Unit', 'Связь с Подразделением для которого сотрудник зарегистрирован в МИС «Каштан»', zc_Object_User(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_User_LikiDnepr_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_UnitCategory_ScaleCalcMarketingPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitCategory_ScaleCalcMarketingPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_UnitCategory_ScaleCalcMarketingPlan', 'Связь с Шкала расчета премии/штрафы в план по маркетингу', zc_Object_UnitCategory(), zc_Object_ScaleCalcMarketingPlan() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_UnitCategory_ScaleCalcMarketingPlan');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceSite_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceSite_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PriceSite_Goods', 'Связь с Товаром СЕТИ', zc_Object_PriceSite(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceSite_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MarketingDiscount_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarketingDiscount_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MarketingDiscount_Unit', 'Связь с Подразделением', zc_Object_MarketingDiscount(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarketingDiscount_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MarketingDiscount_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarketingDiscount_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MarketingDiscount_Retail', 'Связь с Торговой сетью', zc_Object_MarketingDiscount(), zc_Object_Retail() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MarketingDiscount_Retail');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsDivisionLock_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsDivisionLock_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsDivisionLock_Goods', 'Товар', zc_Object_GoodsDivisionLock(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsDivisionLock_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsDivisionLock_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsDivisionLock_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsDivisionLock_Unit', 'Подразделение', zc_Object_GoodsDivisionLock(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsDivisionLock_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CashSettings_MethodsAssortment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CashSettings_MethodsAssortment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CashSettings_MethodsAssortment', 'Методы выбора аптек ассортимента', zc_Object_CashSettings(), zc_Object_MethodsAssortment() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CashSettings_MethodsAssortment');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CorrectMinAmount_PayrollType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CorrectMinAmount_PayrollType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CorrectMinAmount_PayrollType', 'Связь с типом расчета заработной платы', zc_Object_CorrectMinAmount(), zc_Object_PayrollType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CorrectMinAmount_PayrollType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ZReportLog_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ZReportLog_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ZReportLog_Unit', 'Подразделение', zc_Object_ZReportLog(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ZReportLog_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ZReportLog_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ZReportLog_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ZReportLog_User', 'Сотрудник', zc_Object_ZReportLog(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ZReportLog_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PayrollType_PayrollType() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PayrollType_PayrollType'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
  SELECT 'zc_ObjectLink_PayrollType_PayrollType', 'Дополнительный расчет заработной платы', zc_Object_PayrollType(), zc_Object_PayrollType() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PayrollType_PayrollType');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_UpdateMinimumLot() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_UpdateMinimumLot'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_UpdateMinimumLot', 'Пользователь (корр. Мин. округл)', zc_Object_Goods(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_UpdateMinimumLot');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_UpdateisPromo() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_UpdateisPromo'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_UpdateisPromo', 'Пользователь (корр. Акция)', zc_Object_Goods(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_UpdateisPromo');

CREATE OR REPLACE FUNCTION zc_ObjectLink_InsuranceCompanies_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InsuranceCompanies_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_InsuranceCompanies_Juridical', 'Связь с юр лицом', zc_Object_InsuranceCompanies(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InsuranceCompanies_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MemberIC_InsuranceCompanies() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberIC_InsuranceCompanies'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MemberIC_InsuranceCompanies', 'Связь с страховой компанией', zc_Object_MemberIC(), zc_Object_InsuranceCompanies() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MemberIC_InsuranceCompanies');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CorrectWagesPercentage_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CorrectWagesPercentage_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CorrectWagesPercentage_Unit', 'Связь с Подразделением', zc_Object_CorrectWagesPercentage(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CorrectWagesPercentage_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CorrectWagesPercentage_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CorrectWagesPercentage_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CorrectWagesPercentage_User', 'Связь с пользователем', zc_Object_CorrectWagesPercentage(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CorrectWagesPercentage_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_ContactPerson_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_ContactPerson_Unit', 'Связь с подразделением', zc_Object_ContactPerson(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_ContactPerson_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_FormDispensing() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_FormDispensing'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_FormDispensing', 'Форма отпуска', zc_Object_Goods(), zc_Object_FormDispensing() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_FormDispensing');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MedicalProgramSP_SPKind() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicalProgramSP_SPKind'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MedicalProgramSP_SPKind', 'Виды соц. проектов', zc_Object_MedicalProgramSP(), zc_Object_SPKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicalProgramSP_SPKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP', 'Связь с Медицинской программой соц. проектов', zc_Object_MedicalProgramSPLink(), zc_Object_MedicalProgramSP() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MedicalProgramSPLink_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicalProgramSPLink_Unit'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MedicalProgramSPLink_Unit', 'Связь с Подразделеним', zc_Object_MedicalProgramSPLink(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicalProgramSPLink_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BanCommentSend_CommentSend() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BanCommentSend_CommentSend'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BanCommentSend_CommentSend', 'Связь с Комментарий строк перемещений по СУН', zc_Object_BanCommentSend(), zc_Object_CommentSend() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BanCommentSend_CommentSend');

CREATE OR REPLACE FUNCTION zc_ObjectLink_BanCommentSend_Unit() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BanCommentSend_Unit'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_BanCommentSend_Unit', 'Связь с Подразделеним', zc_Object_BanCommentSend(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_BanCommentSend_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP() RETURNS Integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP'); END; $BODY$  LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc (Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP', 'Группы медицинских программ соц. проектов', zc_Object_MedicalProgramSP(), zc_Object_GroupMedicalProgramSP() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SurchargeWages_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SurchargeWages_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_SurchargeWages_Unit', 'Связь с Подразделением', zc_Object_SurchargeWages(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SurchargeWages_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SurchargeWages_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SurchargeWages_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_SurchargeWages_User', 'Связь с пользователем', zc_Object_SurchargeWages(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SurchargeWages_User');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SupplierFailures_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SupplierFailures_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_SupplierFailures_Goods', 'Связь с товаром поставщика', zc_Object_SupplierFailures(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SupplierFailures_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SupplierFailures_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SupplierFailures_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_SupplierFailures_Juridical', 'Связь с поставщиком', zc_Object_SupplierFailures(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SupplierFailures_Juridical');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SupplierFailures_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SupplierFailures_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_SupplierFailures_Contract', 'Связь с договором', zc_Object_SupplierFailures(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SupplierFailures_Contract');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SupplierFailures_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SupplierFailures_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_SupplierFailures_Area', 'Связь с регионом', zc_Object_SupplierFailures(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SupplierFailures_Area');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceChange_PartionDateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceChange_PartionDateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_PriceChange_PartionDateKind', 'Типы срок/не срок', zc_Object_PriceChange(), zc_Object_PartionDateKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PriceChange_PartionDateKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_DiffKindPrice_DiffKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiffKindPrice_DiffKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_DiffKindPrice_DiffKind', 'Вид отказа', zc_Object_DiffKind(), zc_Object_DiffKindPrice() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_DiffKindPrice_DiffKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_MCRequestItem_MCRequest() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MCRequestItem_MCRequest'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
 SELECT 'zc_ObjectLink_MCRequestItem_MCRequest', 'Запрос на изменение категории наценки', zc_Object_MCRequestItem(), zc_Object_MCRequest() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_MCRequestItem_MCRequest');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_UnitSupplementSUN1In() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_UnitSupplementSUN1In'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_UnitSupplementSUN1In', 'Аптека получатель вне работы дополнения СУН1', zc_Object_Goods(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_UnitSupplementSUN1In');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsWhoCan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsWhoCan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_GoodsWhoCan', 'Кому можно', zc_Object_Goods(), zc_Object_GoodsWhoCan() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsWhoCan');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsMethodAppl() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsMethodAppl'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_GoodsMethodAppl', 'Способ применения', zc_Object_Goods(), zc_Object_GoodsMethodAppl() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsMethodAppl');

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsSignOrigin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsSignOrigin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_Goods_GoodsSignOrigin', 'Признак происхождения', zc_Object_Goods(), zc_Object_GoodsSignOrigin() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_Goods_GoodsSignOrigin');

CREATE OR REPLACE FUNCTION zc_ObjectLink_InternetRepair_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InternetRepair_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_InternetRepair_Unit', 'Подразделение', zc_Object_InternetRepair(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_InternetRepair_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CashSettings_UserUpdateMarketing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CashSettings_UserUpdateMarketing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CashSettings_UserUpdateMarketing', 'Сотрудник для редактирование в ЗП суммы Маркетинга', zc_Object_CashSettings(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CashSettings_UserUpdateMarketing');

CREATE OR REPLACE FUNCTION zc_ObjectLink_PartionDateWages_PartionDateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionDateWages_PartionDateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_PartionDateWages_PartionDateKind', 'Типы срок/не срок', zc_Object_PartionDateWages(), zc_Object_PartionDateKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_PartionDateWages_PartionDateKind');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CommentCheck_CommentTR() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CommentCheck_CommentTR'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CommentCheck_CommentTR', 'Связь с Комментарием строк технического переучета', zc_Object_CommentCheck(), zc_Object_CommentTR() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CommentCheck_CommentTR');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CashSettings_UnitComplInvent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CashSettings_UnitComplInvent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CashSettings_UnitComplInvent', 'Проведение полной инвентаризациии по аптеке', zc_Object_CashSettings(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CashSettings_UnitComplInvent');

CREATE OR REPLACE FUNCTION zc_ObjectLink_CashSettings_UnitDeferred() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CashSettings_UnitDeferred'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_CashSettings_UnitDeferred', 'Запрет отмены отложен в перемещениях по аптеке', zc_Object_CashSettings(), zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_CashSettings_UnitDeferred');

CREATE OR REPLACE FUNCTION zc_ObjectLink_SubjectDoc_Reason() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SubjectDoc_Reason'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_SubjectDoc_Reason', 'Причина возврата / перемещения', zc_Object_SubjectDoc(), zc_Object_Reason() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_SubjectDoc_Reason');


CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroupProperty_Parent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroupProperty_Parent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectLinkDesc(Code, ItemName, DescId, ChildObjectDescId)
SELECT 'zc_ObjectLink_GoodsGroupProperty_Parent', 'Аналитический классификатор', zc_Object_GoodsGroupProperty(), zc_Object_GoodsGroupProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Code = 'zc_ObjectLink_GoodsGroupProperty_Parent');




/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 25.03.25         * zc_ObjectLink_Unit_Department_two
 21.03.25         * zc_ObjectLink_Box_Goods
 19.02.25         * zc_ObjectLink_MessagePersonalService_PersonalServiceList
                    zc_ObjectLink_MessagePersonalService_Member
 11.12.24         * zc_ObjectLink_BankAccount_PaidKind
 07.11.24         * zc_ObjectLink_Partner_PersonalSigning
 28.10.24         * zc_ObjectLink_Unit_Department
 22.08.24         * zc_ObjectLink_Goods_GoodsGroupDirection
 22.06.24         *  zc_ObjectLink_ViewPriceList_PriceList
                     zc_ObjectLink_ViewPriceList_Member
 23.05.24         * zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_in
                    zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in
                    zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_out
                    zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out
 26.02.24         * zc_ObjectLink_Member_BankSecondTwo
                    zc_ObjectLink_Member_BankSecondDiff
 19.12.23         * zc_ObjectLink_GoodsGroupProperty_Parent
                    zc_ObjectLink_Goods_GoodsGroupProperty
 20.11.23                                                                                      * zc_ObjectLink_SubjectDoc_Reason
 20.10.23                                                                                      * zc_ObjectLink_CashSettings_UnitDeferred
 11.08.23         * zc_ObjectLink_Asset_PartionModel
 13.06.23                                                                                      * zc_ObjectLink_CashSettings_UnitComplInvent
 18.05.23         * zc_ObjectLink_Storage_AreaUnit
 18.04.23                                                                                      * zc_ObjectLink_CommentCheck_CommentTR
 18.01.23                                                                                      * zc_ObjectLink_PartionDateWages_PartionDateKind
 20.12.22         * zc_ObjectLink_GoodsByGoodsKind_GoodsKindNew
 14.11.22         * zc_ObjectLink_MemberReport_From
                    zc_ObjectLink_MemberReport_To
                    zc_ObjectLink_MemberReport_Member
 04.10.22                                                                                      * zc_ObjectLink_CashSettings_UserUpdateMarketing
 12.09.22                                                                                      * zc_ObjectLink_InternetRepair_Unit
 12.08.22         * zc_ObjectLink_TradeMark_Retail
 08.08.22         * zc_ObjectLink_Retail_StickerHeader
 29.07.22         * zc_ObjectLink_GoodsPropertyValue_GoodsKindSub
 28.07.22                                                                                      * zc_ObjectLink_Goods_GoodsWhoCan, zc_ObjectLink_Goods_GoodsMethodAppl, zc_ObjectLink_Goods_GoodsSignOrigin
 12.07.22         * zc_ObjectLink_OrderCarInfo_Route 
                    zc_ObjectLink_OrderCarInfo_Retail
 07.06.22         * zc_ObjectLink_GoodsByGoodsKind_GoodsSub_Br
                    zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br
 20.05.22                                                                                      * zc_ObjectLink_DiffKindPrice_DiffKind, zc_ObjectLink_MCRequestItem_MCRequest
 09.03.22         * zc_ObjectLink_PersonalServiceList_PersonalHead
 09.02.22                                                                                      * zc_ObjectLink_SupplierFailures_...
 15.12.21         * zc_ObjectLink_Unit_PersonalHead
 25.11.21                                                                                      * zc_ObjectLink_SurchargeWages_...
 03.11.21         * zc_ObjectLink_Contract_Branch                                              * zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP
 04.10.21                                                                                      * zc_ObjectLink_BanCommentSend_...
 01.10.21                                                                                      * zc_ObjectLink_MedicalProgramSP...
 29.09.21                                                                                      * zc_ObjectLink_Goods_FormDispensing
 28.09.21                                                                                      * zc_ObjectLink_ContactPerson_Unit
 27.09.21         * zc_ObjectLink_Member_UnitMobile
 24.06.21                                                                                      * zc_ObjectLink_CorrectWagesPercentage_Unit, zc_ObjectLink_CorrectWagesPercentage_User
 20.06.21                                                                                      * zc_ObjectLink_InsuranceCompanies_Juridical, zc_ObjectLink_MemberIC_InsuranceCompanies
 15.06.21                                                                                      * zc_ObjectLink_Goods_Update...
 31.05.21                                                                                      * zc_ObjectLink_PayrollType_PayrollType
 06.08.21         * zc_ObjectLink_Personal_ ....
 05.08.21         * zc_ObjectLink_Member_....
 30.07.21                                                                                      * zc_ObjectLink_ZReportLog_...
 12.07.21         * zc_ObjectLink_MobileEmployee_MobilePack
 01.07.21         * zc_ObjectLink_Reason_ReturnDescKind
 22.06.21                                                                                      * zc_ObjectLink_CorrectMinAmount_PayrollType
 14.06.21         * zc_ObjectLink_ReceiptChild_ReceiptLevel
 31.05.21                                                                                      * zc_ObjectLink_CashSettings_MethodsAssortment
 27.05.21         * zc_ObjectLink_ContractPriceList_Contract
                    zc_ObjectLink_ContractPriceList_PriceList
 17.05.21                                                                                      * zc_ObjectLink_GoodsDivisionLock_...
 27.04.21                                                                                      * c_ObjectLink_MarketingDiscount_...
 19.04.21                                                                                      * zc_ObjectLink_UnitCategory_ScaleCalcMarketingPlan
 18.04.21         * zc_ObjectLink_MemberPriceList_PriceList
                    zc_ObjectLink_MemberPriceList_Member
 12.04.21                                                                                      * zc_ObjectLink_User_LikiDnepr_Unit
 25.03.21                                                                                      * zc_ObjectLink_FinalSUAProtocol_User
 18.03.21         * zc_ObjectLink_PersonalServiceList_PSLExportKind
                    zc_ObjectLink_PersonalServiceList_BankAccount
 11.03.21                                                                                      * zc_ObjectLink_DiscountExternalSupplier_...
 16.02.21                                                                                      * zc_ObjectLink_Instructions_InstructionsKind
 28.01.21                                                                                      * zc_ObjectLink_Goods_UnitSupplementSUN1Out
 18.01.21         * zc_ObjectLink_ReportBonus_ContractMaster
                    zc_ObjectLink_ReportBonus_ContractChild
 05.01.21                                                                                      * zc_ObjectLink_Maker_Juridical
 10.12.20         * zc_ObjectLink_PartnerExternal_PartnerReal
 20.11.20                                                                                      * zc_ObjectLink_MedicSP_AmbulantClinicSP
 17.11.20         * zc_ObjectLink_Asset_AssetType
 10.11.20         * zc_ObjectLink_ContractTradeMark_Contract
                    zc_ObjectLink_ContractTradeMark_TradeMark
                    zc_ObjectLink_Contract_PriceListGoods
 30.10.20         * zc_ObjectLink_PartnerExternal_Partner
 20.10.20                                                                                      * zc_ObjectLink_Unit_UnitSAUA
 05.10.20         * zc_ObjectLink_MemberBranch_Branch
                    zc_ObjectLink_MemberBranch_Member
 25.09.20         * zc_ObjectLink_ReportBonus_Juridical
                    zc_ObjectLink_ReportBonus_Partner
                    zc_ObjectLink_ReportBonus_Contract
 
 09.09.20         * zc_ObjectLink_JuridicalOrderFinance_BankAccountMain
 04.09.20         * zc_ObjectLink_MemberMinus_From
                    zc_ObjectLink_MemberMinus_To
                    zc_ObjectLink_MemberMinus_BankAccountFrom
                    zc_ObjectLink_MemberMinus_BankAccountTo
 27.08.20         * zc_ObjectLink_Unit_Layout
 22.08.20                                                                                      * zc_Object_JuridicalPriorities
 19.07.20                                                                                      * zc_ObjectLink_CommentSend_CommentTR
 09.07.20                                                                                      * zc_ObjectLink_PartionHouseholdInventory_Unit
 22.06.20         * zc_ObjectLink_InfoMoney_CashFlow_in
                    zc_ObjectLink_InfoMoney_CashFlow_out
 19.06.20                                                                                      * zc_ObjectLink_Goods_DiscountExternal
 20.05.20         * zc_ObjectLink_ContractCondition_PaidKind
 18.05.20         * zc_ObjectLink_Goods_GoodsPairSun
 13.05.20         * zc_ObjectLink_GoodsByGoodsKind_GoodsKind_Sh
 12.05.20         * zc_ObjectLink_GoodsByGoodsKind_Goods_Sh
 29.04.20         * zc_ObjectLink_Goods_AssetProd
 17.04.20                                                                                      * zc_ObjectLink_Hardware_CashRegister
 12.04.20                                                                                      * zc_ObjectLink_Hardware_Unit
 10.04.20         * zc_ObjectLink_GoodsByGoodsKind_GoodsSubSend
                    zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend
 06.04.20         * zc_ObjectLink_SunExclusion_From
                    zc_ObjectLink_SunExclusion_To
 17.02.20         * zc_ObjectLink_MemberBankAccount_BankAccount
                    zc_ObjectLink_MemberBankAccount_Member
 29.01.20         * zc_ObjectLink_PlanIventory_Unit
                    zc_ObjectLink_PlanIventory_Member
                    zc_ObjectLink_PlanIventory_MemberReturn
 11.12.19                                                                                      * zc_ObjectLink_Unit_UnitOld
 27.11.19         * zc_ObjectLink_PriceListItem_GoodsKind
 18.10.19                                                                                      * zc_ObjectLink_RecalcMCSSheduler_UserRun
 17.10.19         * zc_ObjectLink_LabMark_LabProduct
 16.10.19         * zc_ObjectLink_LabReceiptChild_LabMark
                    zc_ObjectLink_LabReceiptChild_Goods
 02.09.19                                                                                      * zc_ObjectLink_Member_Unit
 25.08.19                                                                                      * zc_ObjectLink_Member_Position
 22.08.19                                                                                      * zc_ObjectLink_PayrollType_PayrollGroup, zc_ObjectLink_WorkTimeKind_PayrollType
 07.08.19                                                                                      * zc_ObjectLink_Unit_Driver
 06.08.19         * zc_ObjectLink_JuridicalOrderFinance_Juridical
                    zc_ObjectLink_JuridicalOrderFinance_BankAccount
                    zc_ObjectLink_JuridicalOrderFinance_InfoMoney
 29.07.19         * zc_ObjectLink_OrderFinance_PaidKind
                    zc_ObjectLink_OrderFinanceProperty_OrderFinance
                    zc_ObjectLink_OrderFinanceProperty_Object
 21.07.19                                                                                      * zc_ObjectLink_Goods_GoodsGroupPromo
 02.07.19                                                                                      * zc_ObjectLink_Unit_UnitOverdue
 02.07.19         * zc_ObjectLink_Unit_UserManager2
                    zc_ObjectLink_Unit_UserManager3
 25.06.19         * zc_ObjectLink_GoodsScaleCeh_From
                    zc_ObjectLink_GoodsScaleCeh_To
                    zc_ObjectLink_GoodsScaleCeh_Goods
 07.06.19                                                                                      * zc_ObjectLink_CreditLimitJuridical_Provider, zc_ObjectLink_CreditLimitJuridical_Juridical
 04.05.19         * zc_ObjectLink_Retail_ClientKind
 27.04.19                                                                                      * zc_ObjectLink_User_Helsi_Unit
 23.04.19         * zc_ObjectLink_RetailCostCredit_Retail
 10.04.19         * zc_ObjectLink_GoodsPropertyValue_Box
 01.04.19                                                                                      * zc_ObjectLink_Goods_GoodsAnalog
 26.02.19         * zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Sh
                    zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom
                    zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Ves
 25.02.19         * zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh
                    zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom
                    zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves
                    zc_ObjectLink_GoodsByGoodsKind_GoodsBrand
 18.02.19                                                                                      * zc_ObjectLink_UnitBankPOSTerminal_Unit, zc_ObjectLink_UnitBankPOSTerminal_BankPOSTerminal
 17.02.19         * zc_ObjectLink_TaxUnit_Unit
 13.02.19         * zc_ObjectLink_GoodsCategory_Unit
 11.02.19         * zc_ObjectLink_GoodsCategory_Goods
                    zc_ObjectLink_GoodsCategory_Category
 15.01.19         * zc_ObjectLink_Unit_PartnerMedical
 13.01.19         * zc_ObjectLink_JuridicalSettingsItem_JuridicalSettings
 11.01.19         * zc_ObjectLink_Maker_ContactPerson
                    zc_ObjectLink_MakerReport_Maker
                    zc_ObjectLink_MakerReport_Juridical
 21.12.18                                                                                      * zc_ObjectLink_RecalcMCSSheduler_Unit, zc_ObjectLink_RecalcMCSSheduler_User
 12.12.18         * zc_ObjectLink_Goods_Asset
 28.11.18         * zc_ObjectLink_ReportCollation_InfoMoney
 09.11.18         * zc_ObjectLink_GoodsSeparate_GoodsMaster
 30.10.18                                                                                      * zc_ObjectLink_RepriceUnitSheduler_User
 23.10.18                                                                                      * zc_ObjectLink_RepriceUnitSheduler_Unit
 22.10.18                                                                                      * zc_ObjectLink_RepriceUnitSheduler_Juridical
 22.10.18         * zc_ObjectLink_Unit_UnitRePrice
 18.10.18         * zc_ObjectLink_Goods_PartnerIn
 16.10.18         * zc_ObjectLink_Protocol_ReCalc
 28.09.18                                                                                      * zc_ObjectLink_Goods_Exchange 
 27.09.18         * zc_ObjectLink_PriceChange_Unit
 17.08.18                                                                                      * zc_Object_Accommodation_Unit, zc_Object_Accommodation_Goods
 16.08.18         * zc_ObjectLink_PriceChange_Goods
                    zc_ObjectLink_PriceChange_Retail
 28.05.18                                                                                      * zc_ObjectLink_JuridicalLegalAddress_Juridical, zc_ObjectLink_JuridicalActualAddress_Juridical,
                                                                                                 zc_ObjectLink_JuridicalLegalAddress_Address, zc_ObjectLink_JuridicalActualAddress_Address  
 10.05.18         * zc_ObjectLink_ContactPerson_Area
 04.05.18                                                                                      * zc_ObjectLink_Unit_Category
 18.04.18         * zc_ObjectLink_MemberSheetWorkTime_Unit
                    zc_ObjectLink_MemberSheetWorkTime_Member
 14.02.18         * zc_ObjectLink_GoodsPropertyValue_GoodsBox
 18.01.18         * zc_ObjectLink_MemberSP_PartnerMedical
                    zc_ObjectLink_MemberSP_GroupMemberSP
 21.12.17         * zc_ObjectLink_GoodsByGoodsKind_GoodsPack
                    zc_ObjectLink_GoodsByGoodsKind_GoodsKindPack
 11.11.17         * zc_ObjectLink_ContactPerson_Area
 02.11.17         * zc_ObjectLink_GoodsReportSale_Goods
                    zc_ObjectLink_GoodsReportSale_GoodsKind
                    zc_ObjectLink_GoodsReportSale_Unit
 23.10.17         * zc_ObjectLink_Sticker_.....
                    zc_ObjectLink_StickerProperty_......
 20.10.17         * zc_ObjectLink_Goods_Area
 25.09.17         * zc_ObjectLink_JuridicalArea_Juridical
                    zc_ObjectLink_JuridicalArea_Area               
 13.07.17         * zc_ObjectLink_Personal_PersonalServiceListCardSecond
 30.06.17         * zc_ObjectLink_Contract_JuridicalInvoice
 19.06.17         * zc_ObjectLink_Partner_PersonalMerch
 12.06.17         * zc_ObjectLink_DocumentKind_GoodsKind
                    zc_ObjectLink_DocumentKind_Goods
 05.03.17         * zc_ObjectLink_Contract_GroupMemberSP
 03.03.17         * zc_ObjectLink_Member_Bank
                    zc_ObjectLink_Member_BankSecond
                    zc_ObjectLink_Member_BankChild
 07.01.17         * zc_ObjectLink_Goods_ConditionsKeep
 19.12.16         * zc_ObjectLink_Goods_IntenalSP
                    zc_ObjectLink_Goods_BrandSP
                    zc_ObjectLink_Goods_KindOutSP
 10.11.16         * zc_ObjectLink_ContractSettings_MainJuridical
                    zc_ObjectLink_ContractSettings_Contract
 23.09.16         * zc_ObjectLink_MobileTariff_Contract
 20.09.16         * zc_ObjectLink_OrderShedule_Unit,
                    zc_ObjectLink_OrderShedule_Contract
 13.06.16         * add zc_ObjectLink_Unit_UserFarmacyCash
 03.03.16         * add zc_ObjectLink_EmailSettings_EmailKind,
                        zc_ObjectLink_EmailSettings_EmailTools
 29.12.15         * add zc_ObjectLink_GoodsExternal_Goods
                      , zc_ObjectLink_GoodsExternal_GoodsKind
 07.12.15         * add zc_ObjectLink_BankAccountContract_Unit
 24.11.15         * add zc_ObjectLink_Unit_PersonalSheetWorkTime, zc_ObjectLink_Retail_PersonalMarketing
 18.11.15         * add zc_ObjectLink_GoodsGroup_InfoMoney
 27.10.15                                                                       *zc_ObjectLink_Goods_Appointment
 27.09.15                                                                       *zc_ObjectLink_PriceList_Currency               
 12.09.15         * add zc_ObjectLink_Partner_MemberTake1...7
 20.04.15         * add zc_ObjectLink_Route_RouteGroup
 14.04.15         * add zc_ObjectLink_GoodsGroup_GoodsPlatform
 01.04.15                                        * add zc_ObjectLink_Quality_Retail and zc_ObjectLink_Quality_TradeMark
 18.03.15         * add zc_ObjectLink_Branch_PersonalBookkeeper
 11.03.15         * add zc_ObjectLink_OrderType_Goods
                      , zc_ObjectLink_OrderType_Unit
 12.02.15         * add zc_ObjectLink_Contract_PriceListPromo
                        zc_ObjectLink_Contract_PriceList
 09.02.15         * zc_ObjectLink_Quality_Juridical
                    zc_ObjectLink_GoodsQuality_Quality
 16.01.15         * add zc_ObjectLink_ContractPartner_Contract
                        zc_ObjectLink_ContractPartner_Partner
 12.01.15         * add zc_ObjectLink_GoodsTag_GoodsGroupAnalyst
 17.12.14         * add zc_ObjectLink_Car_Juridical
 08.12.14         * add zc_ObjectLink_GoodsQuality_Goods
 16.11.14                                        * add zc_ObjectLink_PriceList_Currency
 10.11.14         * add redmine zc_Object_Partner
 08.11.14                                        * add zc_ObjectLink_Unit_HistoryCost
 13.10.14                                                        *
 30.09.14         * add zc_ObjectLink_PersonalServiceList_Juridical
 23.09.14                         *
 20.09.14                                        * add zc_ObjectLink_Founder_InfoMoney
 01.09.14         * add zc_ObjectLink_ArticleLoss_InfoMoney
 26.07.14                      	                 * add zc_ObjectLink_PartionGoods_Storage and zc_ObjectLink_PartionGoods_Unit
 31.05.14         * add
 25.04.14         * add св-ва для zc_Object_BankAccountContract
 25.03.14                                                        * + zc_Object_GoodsKindWeighingGroup
 21.03.14                                                        * + zc_ObjectLink_GoodsKindWeighing_GoodsKind
 12.03.14                                                        * + zc_ObjectLink_ToolsWeighing_Parent

 25.02.14                                         * add zc_ObjectLink_Protocol_...
 12.01.14         * add zc_ObjectLink_Partner_PriceList, zc_ObjectLink_Partner_PriceListPromo
                        zc_ObjectLink_Juridical_PriceList, zc_ObjectLink_Juridical_PriceListPromo
 28.12.13                                        * add zc_ObjectLink_Contract_JuridicalBasis
 28.12.13                                        * rename to zc_ObjectLink_Cash_JuridicalBasis
 22.12.13                                        * add zc_ObjectLink_ContractKind_AccountKind
 13.12.13         * add zc_ObjectLink_Route_Branch
 23.11.13                                        * err zc_Objectlink_StaffListSumm_StaffListMaster
 21.11.13                                        * add zc_ObjectLink_Personal_PositionLevel
 30.10.13         * add zc_Objectlink_StaffListSumm_StaffList, zc_Objectlink_StaffListSumm_StaffListMaster, zc_Objectlink_StaffListSumm_StaffListSummKind
 22.10.13         * add zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster
 20.10.13                                        * add zc_ObjectLink_Contract_ContractKind and zc_ObjectLink_Contract_PaidKind
 19.10.13         * add zc_ObjectLink_ModelService_ModelServiceKind,       zc_ObjectLink_ModelService_Unit,
                        zc_ObjectLink_StaffListCost_StaffList,             zc_ObjectLink_StaffListCost_ModelService
                        zc_ObjectLink_ModelServiceItemMaster_ModelService, zc_ObjectLink_ModelServiceItemMaster_From,
                        zc_ObjectLink_ModelServiceItemMaster_To,           zc_ObjectLink_ModelServiceItemMaster_SelectKind
 19.10.13                                        * add zc_ObjectLink_Contract_Juridical
 17.10.13         * add _StaffList_Unit,_StaffList_Position, _PositionLevel
 14.10.13         * add _CardFuel_PersonalDriver, _CardFuel_Car, _CardFuel_PaidKind, _CardFuel_Juridical, _CardFuel_Goods  , _TicketFuel_Goods
 29.09.13         * add zc_ObjectLink_PersonalGroup_Unit
 01.09.13                                        * add zc_ObjectLink_Goods_Fuel
 26.09.13         * add zc_ObjectLink_Fuel_RateFuelKind,  del Car_RateFuelKind, RateFuel_RateFuelKind
 24.09.13         * add  _Route_Unit, _Route_RouteKind, _Route_Freight
                       , _RateFuel_Car, _RateFuel_RouteKind, _RateFuel_RateFuelKind
                       , _Car_Unit, _Car_PersonalDriver, _Car_FuelMaster, _Car_FuelChild, _Car_RateFuelKind
 07.09.13                                        * add zc_ObjectLink_Contract_InfoMoney
 01.09.13                                        * add zc_ObjectLink_Goods_Business
 27.08.13         * НОВАЯ СХЕМА 2
 28.06.13                                        * НОВАЯ СХЕМА
*/