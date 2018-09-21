CREATE OR REPLACE FUNCTION zc_MIDate_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_PartionGoods', 'Партия дата' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_PartionGoods');

CREATE OR REPLACE FUNCTION zc_MIDate_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_OperDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_OperDate', 'Дата выдачи' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_OperDate');

CREATE OR REPLACE FUNCTION zc_MIDate_ServiceDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ServiceDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_ServiceDate', 'Месяц начислений' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ServiceDate');

CREATE OR REPLACE FUNCTION zc_MIDate_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Insert', 'Дата/время создания' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Insert');

CREATE OR REPLACE FUNCTION zc_MIDate_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Update', 'Дата/время корректировки' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Update');

CREATE OR REPLACE FUNCTION zc_MIDate_PartnerIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_PartnerIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_PartnerIn', 'когда сформирована виза Получено от клиента' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_PartnerIn');

CREATE OR REPLACE FUNCTION zc_MIDate_RemakeIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_RemakeIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_RemakeIn', 'когда сформирована виза Получено для переделки' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_RemakeIn');

CREATE OR REPLACE FUNCTION zc_MIDate_RemakeBuh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_RemakeBuh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_RemakeBuh', 'когда сформирована виза Бухгалтерия для исправления' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_RemakeBuh');

CREATE OR REPLACE FUNCTION zc_MIDate_Remake() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Remake'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Remake', 'когда сформирована виза Документ исправлен' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Remake');

CREATE OR REPLACE FUNCTION zc_MIDate_Buh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Buh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Buh', 'когда сформирована виза Бухгалтерия (финиш)' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Buh');

CREATE OR REPLACE FUNCTION zc_MIDate_TransferIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_TransferIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_TransferIn', 'когда сформирована виза "Транзит получен"' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_TransferIn');

CREATE OR REPLACE FUNCTION zc_MIDate_TransferOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_TransferOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_TransferOut', 'когда сформирована виза "Транзит возвращен"' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_TransferOut');

CREATE OR REPLACE FUNCTION zc_MIDate_UpdateMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_UpdateMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_UpdateMobile', 'когда торговый отметил заданиe' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_UpdateMobile');

CREATE OR REPLACE FUNCTION zc_MIDate_InsertMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_InsertMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_InsertMobile', 'Дата/время создания фото' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_InsertMobile');


------!!!!!!!!!! Farmacy
CREATE OR REPLACE FUNCTION zc_MIDate_SertificatStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_SertificatStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_SertificatStart', 'Дата начала регудостоверения' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_SertificatStart');
  
CREATE OR REPLACE FUNCTION zc_MIDate_SertificatEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_SertificatEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_SertificatEnd', 'Дата окончания регудостоверения' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_SertificatEnd');

CREATE OR REPLACE FUNCTION zc_MIDate_MinExpirationDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_MinExpirationDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_MinExpirationDate', 'Срок годности остатка' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_MinExpirationDate');

CREATE OR REPLACE FUNCTION zc_MIDate_ExpirationDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ExpirationDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_ExpirationDate', 'Срок годности' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ExpirationDate');

CREATE OR REPLACE FUNCTION zc_MIDate_TestingUser() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_TestingUser'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_TestingUser', 'Дата тестирования сотрудника' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_TestingUser');


  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.  Шаблий О.В.
 21.09.18                                                                         * zc_MIDate_TestingUser
 26.03.17         * zc_MIDate_InsertMobile
 24.03.17         * zc_MIDate_UpdateMobile
 01.10.15                                                          * zc_MIDate_SertificatStart, zc_MIDate_SertificatEnd
 17.02.14                        *
 04.11.13                                        *
 19.07.13         *
*/
