CREATE OR REPLACE FUNCTION zc_MIDate_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_PartionGoods', 'Партия дата' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_PartionGoods');

CREATE OR REPLACE FUNCTION zc_MIDate_PartionGoods_next() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_PartionGoods_next'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_PartionGoods_next', 'Дата партии (ячейка хранения)' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_PartionGoods_next');


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
  
CREATE OR REPLACE FUNCTION zc_MIDate_StartBegin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_StartBegin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_StartBegin', 'Протокол Дата/время начало' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_StartBegin');

CREATE OR REPLACE FUNCTION zc_MIDate_EndBegin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_EndBegin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_EndBegin', 'Протокол Дата/время завершение' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_EndBegin');


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

CREATE OR REPLACE FUNCTION zc_MIDate_inBuh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_inBuh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_inBuh', 'когда сформирована виза Бухгалтерия в работе' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_inBuh');


CREATE OR REPLACE FUNCTION zc_MIDate_Log() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Log'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Log', 'когда сформирована виза Отдел логистики' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Log');

CREATE OR REPLACE FUNCTION zc_MIDate_Econom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Econom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Econom', 'когда сформирована виза Экономисты' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Econom');

CREATE OR REPLACE FUNCTION zc_MIDate_EconomIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_EconomIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_EconomIn', 'когда сформирована виза Экономисты (в работе)' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_EconomIn');

CREATE OR REPLACE FUNCTION zc_MIDate_EconomOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_EconomOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_EconomOut', 'когда сформирована виза Экономисты (для снабжения)' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_EconomOut');

CREATE OR REPLACE FUNCTION zc_MIDate_Snab() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Snab'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Snab', 'когда сформирована виза Снабжение (в работе)' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Snab');

CREATE OR REPLACE FUNCTION zc_MIDate_SnabRe() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_SnabRe'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_SnabRe', 'когда сформирована виза Снабжение (для переделки)' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_SnabRe');



CREATE OR REPLACE FUNCTION zc_MIDate_TransferIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_TransferIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_TransferIn', 'когда сформирована виза "Транзит получен"' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_TransferIn');

CREATE OR REPLACE FUNCTION zc_MIDate_TransferOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_TransferOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_TransferOut', 'когда сформирована виза "Транзит возвращен"' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_TransferOut');

CREATE OR REPLACE FUNCTION zc_MIDate_Double() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Double'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Double', 'когда сформирована виза "Выведен дубликат"' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Double');

CREATE OR REPLACE FUNCTION zc_MIDate_Scan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Scan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Scan', 'когда сформирована виза "В наличии скан"' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Scan');

--

CREATE OR REPLACE FUNCTION zc_MIDate_UpdateMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_UpdateMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_UpdateMobile', 'когда торговый отметил заданиe' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_UpdateMobile');

CREATE OR REPLACE FUNCTION zc_MIDate_InsertMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_InsertMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_InsertMobile', 'Дата/время создания фото' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_InsertMobile');

CREATE OR REPLACE FUNCTION zc_MIDate_BankOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_BankOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_BankOut', 'Дата выплаты по банку' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_BankOut');

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

CREATE OR REPLACE FUNCTION zc_MIDate_List() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_List'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_List', 'Дата/время (лист отказов)' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_List');

CREATE OR REPLACE FUNCTION zc_MIDate_Income() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Income'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Income', 'Дата последнего прихода' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Income');

CREATE OR REPLACE FUNCTION zc_MIDate_Viewed() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Viewed'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Viewed', 'Дата и время просмотра сообщения' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Viewed');

CREATE OR REPLACE FUNCTION zc_MIDate_Calculation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Calculation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Calculation', 'Дата расчета' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Calculation');
 
CREATE OR REPLACE FUNCTION zc_MIDate_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Start', 'Дата/время начало' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Start');

CREATE OR REPLACE FUNCTION zc_MIDate_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_End', 'Дата/время завершение' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_End');

CREATE OR REPLACE FUNCTION zc_MIDate_IssuedBy() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_IssuedBy'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_IssuedBy', 'Дата выдачи' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_IssuedBy');


CREATE OR REPLACE FUNCTION zc_MIDate_ReplacementDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ReplacementDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_ReplacementDate', 'Дата замены' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ReplacementDate');

CREATE OR REPLACE FUNCTION zc_MIDate_ExpirationDateIncome() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ExpirationDateIncome'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_ExpirationDateIncome', 'Срок годности с прихода' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ExpirationDateIncome');

CREATE OR REPLACE FUNCTION zc_MIDate_ExpirationDateTwo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ExpirationDateTwo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_ExpirationDateTwo', 'Срок годности' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ExpirationDateTwo');

CREATE OR REPLACE FUNCTION zc_MIDate_ReestrDateSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ReestrDateSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_ReestrDateSP', 'Дата реєстрації (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ReestrDateSP');

CREATE OR REPLACE FUNCTION zc_MIDate_ValiditySP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ValiditySP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_ValiditySP', 'Термін дії (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ValiditySP');

CREATE OR REPLACE FUNCTION zc_MIDate_OrderDateSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_OrderDateSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_OrderDateSP', 'Дата наказу, в якому внесено ЛЗ (Соц. проект)' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_OrderDateSP');

CREATE OR REPLACE FUNCTION zc_MIDate_PriceRetOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_PriceRetOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_PriceRetOut', 'Дата для цены возврат поставщику' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_PriceRetOut');






/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.  Шаблий О.В. 
 12.02.25         * zc_MIDate_inBuh
 21.10.24         * zc_MIDate_PriceRetOut 
 24.08.24         * zc_MIDate_PartionGoods_next
 14.05.22                                                                         * zc_MIDate_ReestrDateSP
 05.05.22         * zc_MIDate_Double
                    zc_MIDate_Scan
 24.11.21                                                                         * zc_MIDate_ExpirationDateTwo
 17.11.20         * zc_MIDate_BankOut
 10.09.20                                                                         * zc_MIDate_ExpirationDateIncome
 14.07.20                                                                         * zc_MIDate_ReplacementDate
 01.09.19                                                                         * zc_MIDate_IssuedBy
 23.08.19                                                                         * zc_MIDate_Start, zc_MIDate_End
 27.08.19                                                                         * zc_MIDate_Calculation
 10.03.19                                                                         * zc_MIDate_Viewed
 19.11.18         * zc_MIDate_Income
 07.11.18         * zc_MIDate_List
 21.09.18                                                                         * zc_MIDate_TestingUser
 26.03.17         * zc_MIDate_InsertMobile
 24.03.17         * zc_MIDate_UpdateMobile
 01.10.15                                                          * zc_MIDate_SertificatStart, zc_MIDate_SertificatEnd
 17.02.14                        *
 04.11.13                                        *
 19.07.13         *
*/
