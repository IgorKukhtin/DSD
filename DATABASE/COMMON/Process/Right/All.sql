-- Документ <Приход>
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PeriodCloseAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PeriodCloseAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PeriodCloseTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PeriodCloseTax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportNikolaev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportNikolaev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportCherkassi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportCherkassi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportDoneck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportDoneck' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideNikolaev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideNikolaev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideCherkassi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideCherkassi' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideDoneck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideDoneck' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceProduction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceProduction' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceAdmin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceAdmin' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceSbit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceSbit' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceMarketing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceMarketing' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceSB() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceSB' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_PersonalServiceFirstForm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_PersonalServiceFirstForm' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashOfficialDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashOfficialDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashKharkov() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashKharkov' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashKrRog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashKrRog' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentZaporozhye() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentZaporozhye' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentBread() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentBread' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

 -- zc_Enum_Process_AccessKey_PeriodCloseAll
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PeriodCloseAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1001
                                   , inName:= 'Закрытый период ВСЕ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PeriodCloseAll');
 -- zc_Enum_Process_AccessKey_PeriodCloseTax
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PeriodCloseTax()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1002
                                   , inName:= 'Закрытый период Налог+Корректировки (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PeriodCloseTax');

 -- zc_Object_Goods, для Транспорта ограничивается Справочник Товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= 'Транспорт все (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportAll');

 -- zc_Object_Branch, по Филиалу ограничиваются Документы и Справочники для Транспорта
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= 'Транспорт Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportDnepr');

 -- zc_Object_Branch, по Филиалу ограничиваются Документы и Справочники для Транспорта
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 3
                                   , inName:= 'Транспорт Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKiev');

 -- Кривой Рог, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 4
                                   , inName:= 'Транспорт Кривой Рог (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKrRog');
 -- Николаев, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 5
                                   , inName:= 'Транспорт Николаев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportNikolaev');
 -- Харьков, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 6
                                   , inName:= 'Транспорт Харьков (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKharkov');
 -- Черкассы, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 7
                                   , inName:= 'Транспорт Черкассы (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportCherkassi');
                                   
 -- Донецк, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 8
                                   , inName:= 'Транспорт Донецк (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportDoneck');
 -- Запорожье, ограничения в справочниках - Транспорт
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 9
                                   , inName:= 'Транспорт Запорожье (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportZaporozhye');



 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashDnepr');

 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKiev');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса Запорожье (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashZaporozhye');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashOfficialDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса Днепр-БН (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashOfficialDnepr');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса ХАРЬКОВ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKharkov');
 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса КРИВОЙ РОГ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKrRog');

                                   
 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 31
                                   , inName:= 'Услуги Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceDnepr');

 -- по Филиалу ограничиваются Документы для Услуг
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_ServiceKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 32
                                   , inName:= 'Услуги Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_ServiceKiev');



 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 41
                                   , inName:= 'Документы товарные все (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentAll');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= 'Документы товарные Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentDnepr');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentBread()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 43
                                   , inName:= 'Документы товарные Хлеб (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentBread');
                                   
 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 44
                                   , inName:= 'Документы товарные Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentKiev');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 45
                                   , inName:= 'Документы товарные Запорожье (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentZaporozhye');


 -- ALL, нет ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 101
                                   , inName:= 'Справочники все (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideAll');

 -- Днепр, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 102
                                   , inName:= 'Справочники Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideDnepr');
 -- Киев, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 103
                                   , inName:= 'Справочники Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKiev');
 -- Кривой Рог, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKrRog()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 104
                                   , inName:= 'Справочники Кривой Рог (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKrRog');
 -- Николаев, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideNikolaev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 105
                                   , inName:= 'Справочники Николаев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideNikolaev');
 -- Харьков, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideKharkov()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 106
                                   , inName:= 'Справочники Харьков (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideKharkov');
 -- Черкассы, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideCherkassi()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 107
                                   , inName:= 'Справочники Черкассы (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideCherkassi');

 -- Донецк, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideDoneck()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 108
                                   , inName:= 'Справочники Донецк (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideDoneck');
 -- Запорожье, ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideZaporozhye()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 109
                                   , inName:= 'Справочники Запорожье (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideZaporozhye');

 -- ЗП Производство, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceProduction()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 201
                                   , inName:= 'ЗП Производство (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceProduction');
 -- ЗП Админ, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceAdmin()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 202
                                   , inName:= 'ЗП Админ (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceAdmin');
 -- ЗП Коммерческий отдел, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceSbit()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 203
                                   , inName:= 'ЗП Коммерческий отдел (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceSbit');
 -- ЗП отдел Маркетинга, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceMarketing()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 204
                                   , inName:= 'ЗП отдел Маркетинга (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceMarketing');
 -- ЗП СБ, Охрана, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceSB()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 205
                                   , inName:= 'ЗП СБ, Охрана (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceSB');
 -- ЗП карточки БН, ограничения в справочниках + документах
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_PersonalServiceFirstForm()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 206
                                   , inName:= 'ЗП карточки БН (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_PersonalServiceFirstForm');


/*
 -- заливка прав 
 PERFORM gpInsertUpdate_Object_RoleProcess2 (ioId        := tmpData.RoleRightId
                                           , inRoleId    := tmpRole.RoleId
                                           , inProcessId := tmpProcess.ProcessId
                                           , inSession   := zfCalc_UserAdmin())
 -- AccessKey  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_Right_Branch_Dnepr() AS ProcessId
           ) AS tmpProcess ON 1=1
      -- находим уже существующие права
      LEFT JOIN (SELECT ObjectLink_RoleRight_Role.ObjectId         AS RoleRightId
                      , ObjectLink_RoleRight_Role.ChildObjectId    AS RoleId
                      , ObjectLink_RoleRight_Process.ChildObjectId AS ProcessId
                 FROM ObjectLink AS ObjectLink_RoleRight_Role
                      JOIN ObjectLink AS ObjectLink_RoleRight_Process ON ObjectLink_RoleRight_Process.ObjectId = ObjectLink_RoleRight_Role.ObjectId
                                                                     AND ObjectLink_RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
                 WHERE ObjectLink_RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
                ) AS tmpData ON tmpData.RoleId    = tmpRole.RoleId
                            AND tmpData.ProcessId = tmpProcess.ProcessId
 WHERE tmpData.RoleId IS NULL
 ;
*/
 
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.11.14                                        * add zc_Enum_Process_AccessKey_DocumentAll
 23.09.14                                        * add zc_Enum_Process_AccessKey_PeriodClose...
 17.09.14                                        * add zc_Enum_Process_AccessKey_PersonalServiceFirstForm
 10.09.14                                        * add zc_Enum_Process_AccessKey_PersonalService...
 08.09.14                                        * add zc_Enum_Process_AccessKey_Guide...
 07.04.14                                        * add zc_Enum_Process_AccessKey_DocumentBread
 10.02.14                                        * add zc_Enum_Process_AccessKey_Document...
 28.12.13                                        * add zc_Enum_Process_AccessKey_Service...
 26.12.13                                        * add zc_Enum_Process_AccessKey_Cash...
 14.12.13                                        * add zc_Enum_Process_AccessKey_GuideAll
 07.12.13                                        *
*/

/*
-- !!!update AccessKeyId!!!
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashKiev() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 14686  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKiev();
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashKharkov() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 279790  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKharkov();
update Movement set AccessKeyId = zc_Enum_Process_AccessKey_CashKrRog() from MovementItem where MovementItem.MovementId = Movement.Id and MovementItem.ObjectId = 279788  and Movement.DescId = zc_Movement_Cash() and AccessKeyId <> zc_Enum_Process_AccessKey_CashKrRog();
*/