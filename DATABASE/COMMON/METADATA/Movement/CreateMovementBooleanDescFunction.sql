--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
CREATE OR REPLACE FUNCTION zc_MovementBoolean_Checked() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Checked'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Checked', 'Проверен'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Checked');
CREATE OR REPLACE FUNCTION zc_MovementBoolean_Document() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Document'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Document', 'Есть ли подписанный документ'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Document');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Registered() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Registered'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Registered', 'Зарегестрирована (да/нет)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Registered');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_NPP_calc() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_NPP_calc'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_NPP_calc', 'Сформированы №п/п (да/нет)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_NPP_calc');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Electron() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Electron'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Electron', 'Электронный документ (да/нет)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Electron');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Medoc() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Medoc'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Medoc', 'Передан в Медок'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Medoc');
CREATE OR REPLACE FUNCTION zc_MovementBoolean_EdiOrdspr() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_EdiOrdspr'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_EdiOrdspr', 'EDI - Подтверждение'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_EdiOrdspr');
CREATE OR REPLACE FUNCTION zc_MovementBoolean_EdiInvoice() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_EdiInvoice'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_EdiInvoice', 'EDI - Счет'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_EdiInvoice');
CREATE OR REPLACE FUNCTION zc_MovementBoolean_EdiDesadv() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_EdiDesadv'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_EdiDesadv', 'EDI - уведомление'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_EdiDesadv');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Error() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Error'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Error', 'Ошибка'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Error');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_HistoryCost() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_HistoryCost'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_HistoryCost', 'Спец. алгоритм для расчета с/с (да/нет)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_HistoryCost');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_isLoad() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_isLoad'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_isLoad', 'Загружен из 1С'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_isLoad');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_isAuto() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_isAuto'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_isAuto', 'Автоматически'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_isAuto');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_PriceWithVAT() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_PriceWithVAT'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_PriceWithVAT', 'цена с НДС (да/нет)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_PriceWithVAT');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Peresort() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Peresort'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Peresort', 'пересорт'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Peresort');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Print() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Print'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Print', 'Распечатан (да/нет)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Print');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_isCopy() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_isCopy'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_isCopy', 'Копия документа по маске'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_isCopy');
  
CREATE OR REPLACE FUNCTION zc_MovementBoolean_isIncome() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_isIncome'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_isIncome', 'Признак приход'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_isIncome');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_isPartner() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_isPartner'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_isPartner', 'основание - Акт недовоза'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_isPartner');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Promo() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Promo'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Promo', 'Есть ли товары с акцией в документе'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Promo');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_List() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_List'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_List', 'Только для списка'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_List');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Closed() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Closed'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Closed', 'Закрыто'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Closed');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_GoodsGroupIn() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_GoodsGroupIn'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_GoodsGroupIn', 'GoodsGroup - Include включает выбранную группу товаров, т.е. только по ...'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_GoodsGroupIn');
  
CREATE OR REPLACE FUNCTION zc_MovementBoolean_GoodsGroupExc() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_GoodsGroupExc'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_GoodsGroupExc', 'GoodsGroup - Exclude исключает выбранную группу товаров, т.е. по все кроме ...'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_GoodsGroupExc');
  
CREATE OR REPLACE FUNCTION zc_MovementBoolean_Remains() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Remains'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Remains', 'По остаткам (да/нет)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Remains');
  
CREATE OR REPLACE FUNCTION zc_MovementBoolean_RoundingTo10() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_RoundingTo10'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_RoundingTo10', 'Округление до 10 коп.'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_RoundingTo10');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Calculated() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Calculated'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Calculated', 'Расчет на основании Товары в Производстве-разделении'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Calculated');
  
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Аптека

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Deferred() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Deferred'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Deferred', 'Отложен'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Deferred');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_FullInvent() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_FullInvent'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_FullInvent', 'Полная инвентаризация'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_FullInvent');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_NotMCS() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_NotMCS'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_NotMCS', 'Не для НТЗ'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_NotMCS');
  
CREATE OR REPLACE FUNCTION zc_MovementBoolean_Complete() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Complete'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Complete', 'Собрано фармацевтом'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Complete');
  
CREATE OR REPLACE FUNCTION zc_MovementBoolean_One() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_One'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_One', 'Уникальный код'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_One');
  
CREATE OR REPLACE FUNCTION zc_MovementBoolean_BuySite() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_BuySite'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_BuySite', 'Только для покупок на Сайте'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_BuySite');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Promo_Prescribe() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Promo_Prescribe'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Promo_Prescribe', 'Статус надо прописать в приходах и чеках'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Promo_Prescribe');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.   Шаблий О.В.
 16.10.18                                                                                    * zc_MovementBoolean_Promo_Prescribe
 07.10.18         * zc_MovementBoolean_Calculated
 12.09.18                                                                                    * zc_MovementBoolean_BuySite
 22.07.18                                                                                    * zc_MovementBoolean_RoundingTo10
 27.10.17         * zc_MovementBoolean_Remains
 18.09.17         * zc_MovementBoolean_GoodsGroupIn
                    zc_MovementBoolean_GoodsGroupExc
 15.11.16         * zc_MovementBoolean_Complete
 16.09.15                                                                    * + zc_MovementBoolean_FullInvent
 08.04.15         * add zc_MovementBoolean_isCopy
 06.02.15         * add zc_MovementBoolean_EdiOrdspr
                        zc_MovementBoolean_EdiInvoice
                        zc_MovementBoolean_EdiDesadv
 04.02.15                                                       * add zc_MovementBoolean_Print
 26.12.14                                        * add zc_MovementBoolean_Peresort
 10.08.14                                        * add zc_MovementBoolean_HistoryCost
 24.07.14         				 * add zc_MovementBoolean_Electron
 09.02.14         						*    add zc_MovementBoolean_Registered
 08.02.14         						*    add zc_MovementBoolean_Document
 11.01.14                                        * add
 07.07.13         * НОВАЯ СХЕМА
*/