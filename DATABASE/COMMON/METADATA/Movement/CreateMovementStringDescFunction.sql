--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MovementString_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BankAccount', 'Расчетный счет' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankAccount');

CREATE OR REPLACE FUNCTION zc_MovementString_BankMFO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankMFO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BankMFO', 'МФО' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankMFO');

CREATE OR REPLACE FUNCTION zc_MovementString_BankName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BankName', 'Название банка' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankName');

CREATE OR REPLACE FUNCTION zc_MovementString_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Comment', 'Примечание' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Comment');

CREATE OR REPLACE FUNCTION zc_MovementString_Desc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Desc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Desc', 'Тип документа' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Desc');

CREATE OR REPLACE FUNCTION zc_MovementString_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_GLNCode', 'GLN код юр.лица' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_GLNCode');

CREATE OR REPLACE FUNCTION zc_MovementString_GLNPlaceCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_GLNPlaceCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_GLNPlaceCode', 'GLN код контрагента' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_GLNPlaceCode');

CREATE OR REPLACE FUNCTION zc_MovementString_FileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_FileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_FileName', 'Имя файла' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_FileName');

CREATE OR REPLACE FUNCTION zc_MovementString_DeclarFileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_DeclarFileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_DeclarFileName', 'Имя файла DECLAR' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_DeclarFileName');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberBranch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberBranch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberBranch', 'Номер филиала' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberBranch');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberMark', 'Номер перекресленої зеленої марки зi складу' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberMark');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberSaleLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberSaleLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberSaleLink', 'Номер накладной продажи контрагенту (привязка возврата)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberSaleLink');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberOrder', 'Номер заявки контрагента' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberOrder');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberRegistered() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberRegistered'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberRegistered', 'Номер квитанции' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberRegistered');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberPartner', 'Номер накладной у контрагента' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberPartner');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberTax', 'Номер налоговой накладной' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberTax');

CREATE OR REPLACE FUNCTION zc_MovementString_JuridicalName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_JuridicalName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_JuridicalName', 'JuridicalName' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_JuridicalName');

CREATE OR REPLACE FUNCTION zc_MovementString_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_OKPO', 'ОКПО' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_OKPO');

CREATE OR REPLACE FUNCTION zc_MovementString_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_PartionGoods', 'Партия товара' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_PartionGoods');

CREATE OR REPLACE FUNCTION zc_MovementString_CertificateNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CertificateNumber', 'Ветеринарне свідоцтво №' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateNumber');

CREATE OR REPLACE FUNCTION zc_MovementString_CertificateSeries() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateSeries'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CertificateSeries', 'Ветеринарне свідоцтво Серія' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateSeries');

CREATE OR REPLACE FUNCTION zc_MovementString_CertificateSeriesNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateSeriesNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_CertificateSeriesNumber', 'Ветеринарне свідоцтво Серія №' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_CertificateSeriesNumber');

CREATE OR REPLACE FUNCTION zc_MovementString_ExpertPrior() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_ExpertPrior'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_ExpertPrior', 'Експертний висновок' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_ExpertPrior');

CREATE OR REPLACE FUNCTION zc_MovementString_ExpertLast() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_ExpertLast'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_ExpertLast', 'Експертний висновок (параметры)' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_ExpertLast');

CREATE OR REPLACE FUNCTION zc_MovementString_QualityNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_QualityNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_QualityNumber', 'Декларація виробника №' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_QualityNumber');

CREATE OR REPLACE FUNCTION zc_MovementString_FromINN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_FromINN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_FromINN', 'ИНН от кого' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_FromINN');

CREATE OR REPLACE FUNCTION zc_MovementString_ToINN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_ToINN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_ToINN', 'ИНН кому' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_ToINN');

CREATE OR REPLACE FUNCTION zc_MovementString_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Contract', 'Договор' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Contract');

  --!!!!!!!!!!!!!!!!!!!!!!!!!!Аптека
CREATE OR REPLACE FUNCTION zc_MovementString_Bayer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Bayer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Bayer', 'ФИО клиента для чека по VIP' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Bayer');
  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.07.14                         *
 19.07.14                                        * del zc_MovementString_SaleInvNumber
 17.06.14         * add zc_MovementString_InvNumberPartner()
                      , zc_MovementString_InvNumberMark()
 24.04.14                                                       * add zc_MovementString_InvNumberBranch
 23.04.14                                        * add zc_MovementString_InvNumberMark
 11.01.14                                        * add zc_MovementString_InvNumberOrder
 02.12.13                         * поля для работы с Клиент-Банком
 25.09.13         * add zc_MovementString_Comment
 13.08.13         * add zc_MovementString_OKPO
 12.08.13         * add zc_MovementString_FileName
 19.07.13         * add zc_MovementString_PartionGoods()
 30.06.13                                        * НОВАЯ СХЕМА
*/
