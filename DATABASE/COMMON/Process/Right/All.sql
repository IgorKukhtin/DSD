-- Документ <Приход>
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_TrasportAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_TrasportAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_GuideAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_GuideAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_CashKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_CashKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_ServiceKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_ServiceKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentDnepr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentDnepr' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentKiev() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentKiev' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_DocumentBread() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_DocumentBread' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

 -- zc_Object_Branch, по Филиалу ограничиваются Документы и Справочники для Транспорта
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1
                                   , inName:= 'Транспорт Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportDnepr');

 -- zc_Object_Branch, по Филиалу ограничиваются Документы и Справочники для Транспорта
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= 'Транспорт Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportKiev');
                                   
 -- zc_Object_Goods, для Транспорта ограничивается Справочник Товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_TrasportAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 3
                                   , inName:= 'Транспорт все (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_TrasportAll');

 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 21
                                   , inName:= 'Касса Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashDnepr');

 -- по Филиалу ограничиваются Документы для Кассы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_CashKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 22
                                   , inName:= 'Касса Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_CashKiev');

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
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentDnepr()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 41
                                   , inName:= 'Документы товарные Днепр (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentDnepr');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentBread()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 42
                                   , inName:= 'Документы товарные Хлеб (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentBread');

 -- по Филиалу ограничиваются Документы для товаров
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_DocumentKiev()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 43
                                   , inName:= 'Документы товарные Киев (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_DocumentKiev');

 -- ALL, нет ограничения в справочниках
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_GuideAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 101
                                   , inName:= 'Справочники все (доступ просмотра)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_GuideAll');

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
 07.04.14                                        * add zc_Enum_Process_AccessKey_DocumentBread
 10.02.14                                        * add zc_Enum_Process_AccessKey_Document...
 28.12.13                                        * add zc_Enum_Process_AccessKey_Service...
 26.12.13                                        * add zc_Enum_Process_AccessKey_Cash...
 14.12.13                                        * add zc_Enum_Process_AccessKey_GuideAll
 07.12.13                                        *
*/
