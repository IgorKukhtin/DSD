--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Account'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Account', 'Счета' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Account');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ArticleLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ArticleLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ArticleLoss', 'Статьи списания' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ArticleLoss');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_BankAccount', 'Расчетный счет' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BankAccount');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Branch', 'Филиал' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Branch');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Business', 'Бизнес' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Business');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Car() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Car', 'Автомобили' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Car');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_CarTrailer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CarTrailer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_CarTrailer', 'Автомобиль (прицеп)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CarTrailer');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Cash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Cash', 'Касса' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Cash');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_CashRegister() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CashRegister'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_CashRegister', 'Кассовый аппарат' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CashRegister');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Contract', 'Договора' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Contract');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ContractConditionKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ContractConditionKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ContractConditionKind', 'Валюта' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ContractConditionKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ContractFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ContractFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ContractFrom', 'Договор (от кого)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ContractFrom');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ContractTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ContractTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ContractTo', 'Договор (кому)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ContractTo');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Currency', 'Валюта' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Currency');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_CurrencyDocument() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CurrencyDocument'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_CurrencyDocument', 'Валюта (документа)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CurrencyDocument');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_CurrencyPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CurrencyPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_CurrencyPartner', 'Валюта (контрагента)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CurrencyPartner');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_DocumentTaxKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_DocumentTaxKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_DocumentTaxKind', 'Тип формирования налогового документа' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_DocumentTaxKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_GoodsProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_GoodsProperty', 'Классификаторы свойств товаров' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_GoodsProperty');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_GoodsTypeKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_GoodsTypeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_GoodsTypeKind', 'Категория товара' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_GoodsTypeKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_BarCodeBox() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BarCodeBox'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_BarCodeBox', 'Ш/К для ящиков' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BarCodeBox');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_From() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_From'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_From', 'От кого (в документе)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_From');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_InfoMoney', 'Управленческая статья' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_InfoMoney');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Juridical', 'Юр. лицо' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Juridical');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_JuridicalBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_JuridicalBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_JuridicalBasis', 'Главное юр. лицо' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_JuridicalBasis');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_NDSKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_NDSKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_NDSKind', 'Типы НДС' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_NDSKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Object() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Object'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Object', 'Объект' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Object');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_OrderKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_OrderKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_OrderKind', 'Виды форм оплаты' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_OrderKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PaidKind', 'Виды форм оплаты' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PaidKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PaidKindFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PaidKindFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PaidKindFrom', 'Виды форм оплаты (от кого)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PaidKindFrom');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PaidKindTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PaidKindTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PaidKindTo', 'Виды форм оплаты (кому)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PaidKindTo');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Partner', 'Контрагент (кому)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Partner');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PartnerFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PartnerFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PartnerFrom', 'Контрагент (от кого)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PartnerFrom');


CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Personal', 'Сотрудник (экспедитор)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Personal');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalDriver() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalDriver'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalDriver', 'Сотрудник (водитель)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalDriver');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalDriverMore() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalDriverMore'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalDriverMore', 'Сотрудник (водитель)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalDriverMore');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalPacker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalPacker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalPacker', 'Сотрудник (заготовитель)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalPacker');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalComplete1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalComplete1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalComplete1', 'Сотрудник комплектовщик 1' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalComplete1');
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalComplete2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalComplete2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalComplete2', 'Сотрудник комплектовщик 2' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalComplete2');
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalComplete3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalComplete3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalComplete3', 'Сотрудник комплектовщик 3' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalComplete3');
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalComplete4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalComplete4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalComplete4', 'Сотрудник комплектовщик 4' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalComplete4');
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalComplete5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalComplete5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalComplete5', 'Сотрудник комплектовщик 5' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalComplete5');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_MemberSignCarrier() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberSignCarrier'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_MemberSignCarrier', 'Физические лицо (ключь подписи перевозчика)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberSignCarrier');
  
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_MemberSignConsignor() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberSignConsignor'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_MemberSignConsignor', 'Физические лицо (ключь подписи грузоотправителя)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberSignConsignor');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalStick1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalStick1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalStick1', 'Сотрудник стикеровщик 1' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalStick1');
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PositionStick1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionStick1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PositionStick1', 'Должность стикеровщик 1' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionStick1');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PositionComplete1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionComplete1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PositionComplete1', 'Должность комплектовщик 1' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionComplete1');
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PositionComplete2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionComplete2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PositionComplete2', 'Должность комплектовщик 2' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionComplete2');
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PositionComplete3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionComplete3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PositionComplete3', 'Должность комплектовщик 3' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionComplete3');
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PositionComplete4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionComplete4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PositionComplete4', 'Должность комплектовщик 4' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionComplete4');
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PositionComplete5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionComplete5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PositionComplete5', 'Должность комплектовщик 5' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionComplete5');


CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalServiceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalServiceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalServiceList', 'Ведомости начисления' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalServiceList');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Position', 'Должность' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Position');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PositionLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PositionLevel', 'Разряд' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PositionLevel');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PriceList', 'Прайс лист' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PriceList');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PriceListIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PriceListIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PriceListIn', 'Прайс-лист (вх.цены)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PriceListIn');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ReturnType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ReturnType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ReturnType', 'Тип возврата' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ReturnType');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Retail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Retail', 'Торговая сеть' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Retail');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Route() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Route'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Route', 'Маршрут' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Route');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_RouteSorting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_RouteSorting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_RouteSorting', 'Сортировки маршрутов' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_RouteSorting');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_To() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_To'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_To', 'Кому (в документе)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_To');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Unit', 'Подразделение' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Unit');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_UnitCategory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_UnitCategory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_UnitCategory', 'Категория подразделения' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_UnitCategory');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_UnitForwarding() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_UnitForwarding'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_UnitForwarding', 'Подразделение (Место отправки)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_UnitForwarding');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_User', 'Пользователь' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_User');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Quality() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Quality'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Quality', 'Качественное удостоверение' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Quality');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member1', 'отримав водій/експедитор' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member1');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member2', 'Бухгалтер (відповідальна особа вантажовідправника)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member2');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member3', 'Відпуск дозволив' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member3');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member4', 'Здав (відповідальна особа вантажовідправника)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member4');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member5', 'Прийняв водій/експедитор' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member5');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member6', 'Здав водій/експедитор' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member6');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member7', 'Прийняв (відповідальна особа вантажоодержувача)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member7');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member', 'Физические лица(экспедитор)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_MemberMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_MemberMain', 'Физические лица' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberMain');


CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PromoKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PromoKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PromoKind', 'Вид акции' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PromoKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Advertising() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Advertising'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Advertising', 'Вид акции' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Advertising');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalTrade() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalTrade'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalTrade', 'Ответственный представитель коммерческого отдела' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalTrade');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalMain', 'Сотрудники (супервайзер)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalMain');


CREATE OR REPLACE FUNCTION zc_MovementLinkObject_DocumentKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_DocumentKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_DocumentKind', 'Тип документа' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_DocumentKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ReestrKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ReestrKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ReestrKind', 'Состояние по реестру' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ReestrKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_GoodsGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_GoodsGroup', 'Группа товара' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_GoodsGroup');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_MemberExp() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberExp'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_MemberExp', 'Экспедитор' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberExp');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Checked() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Checked'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Checked', 'Пользователь, кот. сканировал и поставил/убрал галку Проверен' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Checked');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Union() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Union'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Union', 'Пользователь, кот. объединил документы' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Union');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_SubjectDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_SubjectDoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_SubjectDoc', 'Пользователь, кот. объединил документы' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_SubjectDoc');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_CheckedHead() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CheckedHead'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_CheckedHead', 'Пользователь, Проверен руководителем' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CheckedHead');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_CheckedPersonal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CheckedPersonal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_CheckedPersonal', 'Пользователь, Проверен Отдел персонала' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CheckedPersonal');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_WorkTimeKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_WorkTimeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_WorkTimeKind', 'Тип отпуска' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_WorkTimeKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_BonusKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BonusKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_BonusKind', 'Вид бонуса' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BonusKind');


CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Manager() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Manager'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Manager', 'Физические лица (Начальник участка)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Manager');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Security() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Security'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Security', 'Физические лица (Отдел безопасности)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Security');

 CREATE OR REPLACE FUNCTION zc_MovementLinkObject_CarInfo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CarInfo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_CarInfo', 'Информация по отгрузке' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CarInfo');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_StatusInsert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_StatusInsert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_StatusInsert', 'Пользователь первого проведения' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_StatusInsert');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_TradeMark', 'Торговая Марка' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_TradeMark');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PromoItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PromoItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PromoItem', 'Статья затрат' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PromoItem');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ContractConditionKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ContractConditionKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ContractConditionKind', 'Типы условий договоров' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ContractConditionKind');

----
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member_1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member_1', 'Отвественный сотрудник коммерческого отдела' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_1');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member_2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member_2', 'Отвественный сотрудник экономического отдела' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_2');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member_3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member_3', 'Региональнай менеджер / Директор филиала' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_3');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member_4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member_4', 'Руководитель отдела продаж' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_4');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member_5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member_5', 'Отвественный сотрудник отдела маркетинга' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_5');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Member_6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Member_6', 'Коммерческий директор' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Member_6');


CREATE OR REPLACE FUNCTION zc_MovementLinkObject_InfoMoney_CostPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_InfoMoney_CostPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_InfoMoney_CostPromo', 'Статья для Стоимость участия' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_InfoMoney_CostPromo');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_InfoMoney_Market() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_InfoMoney_Market'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_InfoMoney_Market', 'Статья для Сумма компенсации' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_InfoMoney_Market');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_SiteTag() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_SiteTag'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_SiteTag', 'Категория сайт' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_SiteTag');


 











--!!!!!!!!!!!  Аптека
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_CheckMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CheckMember'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_CheckMember', 'Менеджер' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CheckMember');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PaidType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PaidType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PaidType', 'Тип оплаты' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PaidType');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ChangeIncomePaymentKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ChangeIncomePaymentKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ChangeIncomePaymentKind', 'Виды корректировок долга приходных окументов' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ChangeIncomePaymentKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Maker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Maker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Maker', 'Производитель' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Maker');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Insert', 'Пользователь созд.' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Insert');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Update', 'Пользователь корр.' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Update');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_discountcard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_discountcard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_discountcard', 'Дисконтные карты' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_discountcard');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ConfirmedKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ConfirmedKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ConfirmedKind', 'Статус заказа (Состояние VIP-чека)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ConfirmedKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ConfirmedKindClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ConfirmedKindClient'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ConfirmedKindClient', 'Статус заказа (Отправлен клиенту)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ConfirmedKindClient');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PartnerMedical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PartnerMedical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PartnerMedical', 'Медицинское учреждение(Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PartnerMedical');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_GroupMemberSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_GroupMemberSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_GroupMemberSP', 'Категория пациента(Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_GroupMemberSP');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_MemberSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_MemberSP', 'ФИО пациента(Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberSP');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_MedicSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MedicSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_MedicSP', 'ФИО врача(Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MedicSP');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_SPKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_SPKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_SPKind', 'Вид Соц. проекта' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_SPKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_MemberIncomeCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberIncomeCheck'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_MemberIncomeCheck', 'ФИО Уполномоченных лиц' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberIncomeCheck');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Area', 'Регион' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Area');


CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PromoCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PromoCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PromoCode', 'Промо код' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PromoCode');


CREATE OR REPLACE FUNCTION zc_MovementLinkObject_LegalAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_LegalAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_LegalAddress', 'Юридический адрес' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_LegalAddress');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ActualAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ActualAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ActualAddress', 'Фактический адрес' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ActualAddress');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_RetailForwarding() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_RetailForwarding'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_RetailForwarding', 'Торговая сеть(основание для равенства цен)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_RetailForwarding');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_ClientsByBank() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ClientsByBank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_ClientsByBank', 'Клиенты по безналу' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_ClientsByBank');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_UserConfirmedKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_UserConfirmedKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_UserConfirmedKind', 'Кто поставил/убрал галка Подтвержден' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_UserConfirmedKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_BankPOSTerminal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BankPOSTerminal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_BankPOSTerminal', 'POS терминал' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BankPOSTerminal');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_JackdawsChecks() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_JackdawsChecks'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_JackdawsChecks', 'Тип галки' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_JackdawsChecks');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PartionDateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PartionDateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PartionDateKind', 'Типы срок/не срок' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PartionDateKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_OrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_OrderFinance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_OrderFinance', 'Виды Планирования платежей' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_OrderFinance');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Driver() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Driver'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Driver', 'Водитель)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Driver');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_JuridicalCar() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_JuridicalCar'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_JuridicalCar', 'Юр.лицо грузоотправитель' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_JuridicalCar');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_DriverSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_DriverSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_DriverSun', 'Водитель получивший товар' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_DriverSun');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PromoStateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PromoStateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PromoStateKind', 'Состояние Акции' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PromoStateKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PromoTradeStateKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PromoTradeStateKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PromoTradeStateKind', 'Состояние Трейд-маркетинг' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PromoTradeStateKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_SignInternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_SignInternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_SignInternal', 'Модель электронной подписи' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_SignInternal');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_CheckSourceKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CheckSourceKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_CheckSourceKind', 'Источник чека' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CheckSourceKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Status_wms() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Status_wms'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Status_wms', 'Виды статусов' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Status_wms');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PersonalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PersonalGroup', '№ бригады' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PersonalGroup');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Layout() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Layout'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Layout', 'Название выкладки' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Layout');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_CancelReason() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CancelReason'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_CancelReason', 'Причина отказа для сайта' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_CancelReason');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_MedicForSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MedicForSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_MedicForSale', 'ФИО врача (на продажу)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MedicForSale');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_BuyerForSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BuyerForSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_BuyerForSale', 'ФИО покупателя (на продажу)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BuyerForSale');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_MedicKashtan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MedicKashtan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_MedicKashtan', 'ФИО врача (МИС «Каштан»)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MedicKashtan');


CREATE OR REPLACE FUNCTION zc_MovementLinkObject_MemberKashtan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberKashtan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_MemberKashtan', 'ФИО пациента (МИС «Каштан»)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberKashtan');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_BuyerForSite() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BuyerForSite'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_BuyerForSite', 'Покупатель сайта "Не болей"' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BuyerForSite');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_OrderPeriodKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_OrderPeriodKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_OrderPeriodKind', 'Вид периода планирования' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_OrderPeriodKind');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_TopicsTestingTuning() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_TopicsTestingTuning'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_TopicsTestingTuning', 'Темы тестирования сотрудников' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_TopicsTestingTuning');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_InsuranceCompanies() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_InsuranceCompanies'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_InsuranceCompanies', 'Страховые компании' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_InsuranceCompanies');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_MemberIC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberIC'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_MemberIC', 'ФИО покупателя (Страховой компании)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_MemberIC');

CREATE OR REPLACE FUNCTION zc_MovementLink_MedicalProgramSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLink_MedicalProgramSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLink_MedicalProgramSP', 'Медицинская программа соц. проектов' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLink_MedicalProgramSP');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Category1303() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLink_Category1303'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLink_Category1303', 'Группы населения по постановлению КМУ 1303' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLink_Category1303');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PairDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PairDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PairDay', 'Вид смены' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PairDay');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_UserReferals() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_UserReferals'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_UserReferals', 'По рекомендации сотрудника' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_UserReferals');


CREATE OR REPLACE FUNCTION zc_MovementLinkObject_UserKeyId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_UserKeyId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_UserKeyId', 'Чей файловый ключ использовался при пробитии чека.' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_UserKeyId');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_BankSecond_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BankSecond_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_BankSecond_num', 'Банк - 2ф.(Восток)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BankSecond_num');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_BankSecondTwo_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BankSecondTwo_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_BankSecondTwo_num', 'Банк - 2ф.(ОТП)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BankSecondTwo_num');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_BankSecondDiff_num() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BankSecondDiff_num'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_BankSecondDiff_num', 'Банк - 2ф.(личный)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_BankSecondDiff_num');



/*-------------------------------------------------------------------------------

                  РАСПОЛАГАЙТЕ ДЕСКИ ПО АЛФАВИТУ  !!!!!!!!!!!!!!!!!!!

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 02.12.24         * zc_MovementLinkObject_SiteTag
 07.08.24         * zc_MovementLinkObject_TradeMark
 10.03.24         * zc_MovementLinkObject_BankSecond
                    zc_MovementLinkObject_BankSecondTwo_num
                    zc_MovementLinkObject_BankSecondDiff_num
 22.05.23                                                                                     * zc_MovementLinkObject_MemberSignCarrier, zc_MovementLinkObject_MemberSignConsignor
 19.04.23         * zc_MovementLinkObject_StatusInsert
 20.02.23                                                                                     * zc_MovementLinkObject_UserKeyId
 14.06.22         * zc_MovementLinkObject_CarInfo
 29.04.22         * zc_MovementLinkObject_Manager
                    zc_MovementLinkObject_Security
 21.02.22                                                                                     * zc_MovementLinkObject_UserReferals 
 26.01.22         * zc_MovementLinkObject_PriceListIn
 27.10.21                                                                                     * zc_MovementLink_Category1303 
 01.10.21                                                                                     * zc_MovementLink_MedicalProgramSP
 20.09.21                                                                                     * zc_MovementLinkObject_InsuranceCompanies, zc_MovementLinkObject_MemberIC
 21.08.21         * zc_MovementLinkObject_WorkTimeKind
 09.08.21         * zc_MovementLinkObject_CheckedHead
                    zc_MovementLinkObject_CheckedPersonal
 06.07.21                                                                                      * zc_MovementLinkObject_TopicsTestingTuning 
 08.06.21         * zc_MovementLinkObject_OrderPeriodKind
 21.04.21                                                                                      * zc_MovementLinkObject_BuyerForSite 
 05.03.21                                                                                      * zc_MovementLinkObject_MedicKashtan, zc_MovementLinkObject_MemberKashtan
 10.10.20                                                                                      * zc_MovementLinkObject_MedicForSale, zc_MovementLinkObject_BuyerForSale
 03.09.20                                                                                      * zc_MovementLinkObject_CancelReason
 27.08.20         * zc_MovementLinkObject_Layout
 07.08.20         * zc_MovementLinkObject_PersonalGroup
 05.08.20         * zc_MovementLinkObject_Status_wms
 16.06.20                                                                                      * zc_MovementLinkObject_CheckSourceKind
 01.04.20         * zc_MovementLinkObject_PromoStateKind
 05.03.19                                                                                      * zc_MovementLinkObject_DriverSun
 06.02.20         * zc_MovementLinkObject_SubjectDoc
 04.02.20         * zc_MovementLinkObject_JuridicalCar
 29.07.19         * zc_MovementLinkObject_OrderFinance
 20.06.19         * zc_MovementLinkObject_GoodsTypeKind
                    zc_MovementLinkObject_BarCodeBox
 20.04.19         * zc_MovementLinkObject_PartionDateKind
 25.02.19                                                                                      * zc_MovementLinkObject_JackdawsChecks
 16.02.19                                                                                      * zc_MovementLinkObject_BankPOSTerminal
 12.18.17         * zc_MovementLinkObject_PositionComplete5
                    zc_MovementLinkObject_PersonalComplete5
 23.10.18         * zc_MovementLinkObject_Union
 12.10.18                                                                                      * zc_MovementLinkObject_UserConfirmedKind
 11.10.18         * zc_MovementLinkObject_Checked
 30.09.18                                                                                      * zc_MovementLinkObject_ClientsByBank
 20.08.18         * zc_MovementLinkObject_RetailForwarding
 28.05.18                                                                                      * zc_MovementLinkObject_LegalAddress, zc_MovementLinkObject_ActualAddress
 07.05.18                                                                                      * zc_MovementLinkObject_UnitCategory
 13.12.17         * zc_MovementLinkObject_PromoCode
 11.10.17         * zc_MovementLinkObject_Area
 18.09.17         * zc_MovementLinkObject_GoodsGroup
 08.06.17         * zc_MovementLinkObject_MemberIncomeCheck
 09.02.17         * zc_MovementLinkObject_GroupMemberSP
 22.12.16         * zc_MovementLinkObject_PartnerMedical
 25.08.16         * zc_MovementLinkObject_ConfirmedKindClient
 21.07.16         * zc_MovementLinkObject_discountcard
 13.06.16         * zc_MovementLinkObject_DocumentKind
 10.12.15                                                                       *zc_MovementLinkObject_ChangeIncomePaymentKind
 31.10.15                                                                       *zc_MovementLinkObject_PromoKind, zc_MovementLinkObject_Advertising, zc_MovementLinkObject_PersonalTrade
 22.05.15         * add zc_MovementLinkObject_retail
 09.02.15         												*

                  РАСПОЛАГАЙТЕ ДЕСКИ ПО АЛФАВИТУ  !!!!!!!!!!!!!!!!!!!


 13.11.14                                        * add zc_MovementLinkObject_Branch
 12.09.14         * add zc_MovementLinkObject_PersonalServiceList()
 09.02.14                                                       * add zc_MovementLinkObject_ArticleLoss
 23.07.14         * add zc_MovementLinkObject_CurrencyDocument
                        zc_MovementLinkObject_CurrencyPartner
 19.07.14                      	                 * add zc_MovementLinkObject_GoodsProperty
 04.07.14                      	                 		        * + zc_MovementLinkObject_NDSKind
 11.02.14                      	                 * add zc_MovementLinkObject_Partner
 11.02.14                      	                 * del 10.02.14 :)
 10.02.14                                                       * add zc_MovementLinkObject_DocumentMaster, zc_MovementLinkObject_DocumentChild
 09.02.14                                                       * add zc_MovementLinkObject_DocumentTaxKind
 31.01.14                                                       * add zc_MovementLinkObject_PriceList
 22.12.13         * add zc_MovementLinkObject_ContractConditionKind
 03.10.13                                         * rename to JuridicalBasis
 25.09.13         * del zc_MovementLinkObject_Member; add UnitForwarding, CarTrailer
 20.08.13         * add zc_MovementLinkObject_Member
 12.08.13         * add zc_MovementLinkObject_BankAccount, Juridical, JuridicalBasis
 29.07.13         * НОВАЯ СХЕМА 2, add zc_MovementLinkObject_Personal
 30.06.13                                        * НОВАЯ СХЕМА
*/
