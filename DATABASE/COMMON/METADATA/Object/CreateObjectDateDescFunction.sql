--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReplServer_StartTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_StartTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectDate_ReplServer_StartTo', 'Дата/время начала отправки в базу-Child' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_StartTo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReplServer_EndTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_EndTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectDate_ReplServer_EndTo', 'Дата/время завершения отправки в базу-Child' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_EndTo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReplServer_StartFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_StartFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectDate_ReplServer_StartFrom', 'Дата/время начала получения из базы-Child' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_StartFrom');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReplServer_EndFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_EndFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReplServer(), 'zc_ObjectDate_ReplServer_EndFrom', 'Дата/время завершения получения из базы-Child' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReplServer_EndFrom');

--
CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_In() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_In', 'Дата принятия у сотрудника' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_Out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_Out', 'Дата увольнения у сотрудника' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Send'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_Send', 'Дата перевода сотрудника' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Send');


CREATE OR REPLACE FUNCTION zc_ObjectDate_PartionGoods_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionGoods_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectDate_PartionGoods_Value', 'Дата партии товара' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionGoods_Value');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReceiptChild_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectDate_ReceiptChild_Start', 'Начальная дата составляющие рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReceiptChild_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectDate_ReceiptChild_End', 'Конечная дата составляющие рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_End');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Receipt_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectDate_Receipt_Start', 'Начальная дата Рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Receipt_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectDate_Receipt_End', 'Конечная дата Рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_End');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Receipt_End_Parent_old() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_End_Parent_old'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectDate_Receipt_End_Parent_old', 'Дата до (история)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_End_Parent_old');



CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_Signing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Signing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_Signing', 'Дата заключения договора' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Signing');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_Start', 'Дата с которой действует договор' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Start');
CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_End', 'Дата до которой действует договор' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_End');
CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_Document() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Document'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_Document', 'Дата последнего документа' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_Document');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Calendar_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Calendar_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Calendar_Value', 'Дата' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GlobalConst_ActualBankStatement');

CREATE OR REPLACE FUNCTION zc_ObjectDate_GlobalConst_ActualBankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GlobalConst_ActualBankStatement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GlobalConst(), 'zc_ObjectDate_GlobalConst_ActualBankStatement', 'Дата актуальности банковской выписки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GlobalConst_ActualBankStatement');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Partner_StartPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Partner_StartPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectDate_Partner_StartPromo', 'Дата начала акции' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Partner_StartPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Partner_EndPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Partner_EndPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Partner(), 'zc_ObjectDate_Partner_EndPromo', 'Дата окончания акции' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Partner_EndPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Juridical_StartPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_StartPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectDate_Juridical_StartPromo', 'Дата начала акции' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_StartPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Juridical_EndPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_EndPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectDate_Juridical_EndPromo', 'Дата окончания акции' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_EndPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Juridical_VatPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_VatPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectDate_Juridical_VatPrice', 'С какой даты схема расчета цены с НДС (построчно)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Juridical_VatPrice');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Asset_Release() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Asset_Release'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Asset(), 'zc_ObjectDate_Asset_Release', 'Дата выпуска' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Asset_Release');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Protocol_Insert', 'Дата создания' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Insert');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Protocol_Update', 'Дата корректировки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Update');

CREATE OR REPLACE FUNCTION zc_ObjectDate_InvNumberTax_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_InvNumberTax_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_InvNumberTax(), 'zc_ObjectDate_InvNumberTax_Value', 'Дата' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_InvNumberTax_Value');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ServiceDate_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ServiceDate_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ServiceDate(), 'zc_ObjectDate_ServiceDate_Value', 'Значение' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ServiceDate_Value');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_StartPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_StartPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_StartPromo', 'Дата начала акции' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_StartPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Contract_EndPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_EndPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Contract_EndPromo', 'Дата окончания акции' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Contract_EndPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_MedocLoadInfo_Period() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MedocLoadInfo_Period'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_MedocLoadInfo(), 'zc_ObjectDate_MedocLoadInfo_Period', 'Период загрузки медка' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MedocLoadInfo_Period');

CREATE OR REPLACE FUNCTION zc_ObjectDate_MedocLoadInfo_LoadDateTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MedocLoadInfo_LoadDateTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_MedocLoadInfo(), 'zc_ObjectDate_MedocLoadInfo_LoadDateTime', 'Дата загрузки периода медка' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MedocLoadInfo_LoadDateTime');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_StartSummer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_StartSummer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_StartSummer', 'Начальная дата для нормы авто лето' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_StartSummer');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_EndSummer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_EndSummer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_EndSummer', 'Конечная дата для нормы авто лето' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_EndSummer');

--
CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Birthday() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Birthday'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Birthday', 'Паспорт, дата рождения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Birthday');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Children1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Children1', 'Ребенок 1, дата рождения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children1');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Children2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Children2', 'Ребенок 2, дата рождения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children2');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Children3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Children3', 'Ребенок 3, дата рождения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children3');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Children4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Children4', 'Ребенок 4, дата рождения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children4');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Children5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Children5', 'Ребенок 5, дата рождения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Children5');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_PSP_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_PSP_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_PSP_Start', 'Паспорт, срок годности с' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_PSP_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_PSP_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_PSP_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_PSP_End', 'Паспорт, срок годности по' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_PSP_End');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Dekret_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Dekret_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Dekret_Start', 'Декрет c' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Dekret_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Member_Dekret_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Dekret_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Member(), 'zc_ObjectDate_Member_Dekret_End', 'Декрет по' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Member_Dekret_End');

--
CREATE OR REPLACE FUNCTION zc_ObjectDate_ImportSettings_StartTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ImportSettings_StartTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ImportSettings(), 'zc_ObjectDate_ImportSettings_StartTime', 'Время начала активной проверки почты' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ImportSettings_StartTime');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ImportSettings_EndTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ImportSettings_EndTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ImportSettings(), 'zc_ObjectDate_ImportSettings_EndTime', 'Время окончания активной проверки почты' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ImportSettings_EndTime');

--
CREATE OR REPLACE FUNCTION zc_ObjectDate_SheetWorkTime_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_SheetWorkTime(), 'zc_ObjectDate_SheetWorkTime_Start', 'Время начала' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_SheetWorkTime_Work() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_Work'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_SheetWorkTime(), 'zc_ObjectDate_SheetWorkTime_Work', 'Количество рабочих часов' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_Work');

CREATE OR REPLACE FUNCTION zc_ObjectDate_SheetWorkTime_DayOffPeriod() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_DayOffPeriod'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_SheetWorkTime(), 'zc_ObjectDate_SheetWorkTime_DayOffPeriod', 'Начиная с какого числа расчет периодичности' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SheetWorkTime_DayOffPeriod');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportCollation_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportCollation(), 'zc_ObjectDate_ReportCollation_Start', 'Нач. дата периода Акта сверки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportCollation_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportCollation(), 'zc_ObjectDate_ReportCollation_End', 'Кон. дата периода Акта сверки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_End');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportCollation_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportCollation(), 'zc_ObjectDate_ReportCollation_Insert', 'дата создания Акта сверки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Insert');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportCollation_Buh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Buh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportCollation(), 'zc_ObjectDate_ReportCollation_Buh', 'дата (сдали в бухгалтерию)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportCollation_Buh');

CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsListIncome_Last() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsListIncome_Last'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsListIncome(), 'zc_ObjectDate_GoodsListIncome_Last', 'последняя дата изм.' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsListIncome_Last');

CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsReportSaleInf_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsReportSaleInf_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsReportSaleInf(), 'zc_ObjectDate_GoodsReportSaleInf_Start', 'Начальная Дата' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsReportSaleInf_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsReportSaleInf_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsReportSaleInf_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsReportSaleInf(), 'zc_ObjectDate_GoodsReportSaleInf_End', 'Конечная Дата' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsReportSaleInf_End');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_ReCalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_ReCalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Contract(), 'zc_ObjectDate_Protocol_ReCalc', 'Дата/время пересчета' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_ReCalc');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_In() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_In'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_In', 'Дата прихода от поставщика' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_In');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_UKTZED_new() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UKTZED_new'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_UKTZED_new', 'дата с которой действует новый Код УКТ ЗЕД' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UKTZED_new');

CREATE OR REPLACE FUNCTION zc_Object_ReportBonus_Month() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_Object_ReportBonus_Month'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportBonus(), 'zc_Object_ReportBonus_Month', 'Месяц начисления бонусов' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_Object_ReportBonus_Month');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractGoods_Start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractGoods_Start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractGoods(), 'zc_ObjectDate_ContractGoods_Start', 'Дата действия цены с ...' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractGoods_Start');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractGoods_End() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractGoods_End'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractGoods(), 'zc_ObjectDate_ContractGoods_End', 'Дата действия цены по ...' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractGoods_End');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractPriceList_StartDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractPriceList_StartDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractPriceList(), 'zc_ObjectDate_ContractPriceList_StartDate', 'Дата действия c ...' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractPriceList_StartDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractPriceList_EndDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractPriceList_EndDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractPriceList(), 'zc_ObjectDate_ContractPriceList_EndDate', 'Дата действия по ...' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractPriceList_EndDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_JuridicalDefermentPayment_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_JuridicalDefermentPayment_OperDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalDefermentPayment(), 'zc_ObjectDate_JuridicalDefermentPayment_OperDate', 'Дата последней оплаты' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_JuridicalDefermentPayment_OperDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_JuridicalDefermentPayment_OperDateIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_JuridicalDefermentPayment_OperDateIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_JuridicalDefermentPayment(), 'zc_ObjectDate_JuridicalDefermentPayment_OperDateIn', 'Дата последнего прихода' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_JuridicalDefermentPayment_OperDateIn');


CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsGroup_UKTZED_new() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsGroup_UKTZED_new'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsGroup(), 'zc_ObjectDate_GoodsGroup_UKTZED_new', 'дата с которой действует новый Код УКТ ЗЕД' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsGroup_UKTZED_new');

 
 CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsByGoodsKind_End_old() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsByGoodsKind_End_old'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectDate_GoodsByGoodsKind_End_old', 'Дата до (история)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsByGoodsKind_End_old');
 
 CREATE OR REPLACE FUNCTION zc_ObjectDate_GoodsByGoodsKind_GoodsSub() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsByGoodsKind_GoodsSub'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_GoodsByGoodsKind(), 'zc_ObjectDate_GoodsByGoodsKind_GoodsSub', 'Дата, с которой формируется пересорт расход' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_GoodsByGoodsKind_GoodsSub');


 

--!!!FARMACY

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_DateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_DateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_DateChange', 'Дата изменения цены' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_DateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_MCSDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_MCSDateChange', 'Дата изменения неснижаемого товарного запаса' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_MCSIsCloseDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSIsCloseDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_MCSIsCloseDateChange', 'Дата изменения признака "Убить код"' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSIsCloseDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_MCSNotRecalcDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSNotRecalcDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_MCSNotRecalcDateChange', 'Дата изменения признака "Спецконтроль кода"' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_MCSNotRecalcDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_FixDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_FixDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_FixDateChange', 'Дата изменения признака "Фиксированная цена"' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_FixDateChange');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_StartDateMCSAuto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_StartDateMCSAuto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_StartDateMCSAuto', 'Дата с которой действует выставленное фармацевтом НТЗ' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_StartDateMCSAuto');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_EndDateMCSAuto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_EndDateMCSAuto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_EndDateMCSAuto', 'Дата окончания действия выставленного фармацевтом НТЗ' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_EndDateMCSAuto');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_CheckPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_CheckPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_CheckPrice', 'дата/время когда Появился на рынке - и высветился признак исправить НТЗ (да/нет)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_CheckPrice');




CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportSoldParams_PlanDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportSoldParams_PlanDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportSoldParams(), 'zc_ObjectDate_ReportSoldParams_PlanDate', 'Месяц плана продаж' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportSoldParams_PlanDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReportPromoParams_PlanDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportPromoParams_PlanDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReportPromoParams(), 'zc_ObjectDate_ReportPromoParams_PlanDate', 'Месяц плана по маркетингу' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReportPromoParams_PlanDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_StartServiceNigth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_StartServiceNigth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_StartServiceNigth', 'время начала ночной смены' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_StartServiceNigth');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_EndServiceNigth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_EndServiceNigth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_EndServiceNigth', 'время завершения ночной смены' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_EndServiceNigth');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_FarmacyCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_FarmacyCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_FarmacyCash', 'Дата/время последнего сеанса с FarmacyCash' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_FarmacyCash');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_Create() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Create'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_Create', 'дата создания точки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Create');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_Close() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Close'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_Close', 'дата закрытия точки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Close');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_TaxUnitStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_TaxUnitStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_TaxUnitStart', 'Время начала ночных цен' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_TaxUnitStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_TaxUnitEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_TaxUnitEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_TaxUnitEnd', 'Время завершения ночных цен' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_TaxUnitEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SP', 'Дата начала работы по Соц.проектам' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SP');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_StartSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_StartSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_StartSP', 'Время начала работы по Соц.проектам ' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_StartSP');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_EndSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_EndSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_EndSP', 'Время завершения работы по Соц.проектам' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_EndSP');


CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_TOPDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_TOPDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_TOPDateChange', 'Дата изменения ТОП-позиция' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_TOPDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Price_PercentMarkupDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_PercentMarkupDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Price(), 'zc_ObjectDate_Price_PercentMarkupDateChange', 'Дата изменения % наценки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Price_PercentMarkupDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_ReestrSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_ReestrSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_ReestrSP', 'Дата закінчення строку дії реєстраційного посвідчення на лікарський засіб(Соц. проект)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_ReestrSP');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_InsertSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_InsertSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Protocol_InsertSP', 'Дата создания' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_InsertSP');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_LastPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_LastPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_LastPrice', 'Дата загрузки прайса' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_LastPrice');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_LastPriceOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_LastPriceOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_LastPriceOld', 'Пред Послед. дата наличия на рынке' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_LastPriceOld');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_PairSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_PairSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_PairSun', 'Дата с которой синхр. в перемещении для Пара товара' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_PairSun');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_BUH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_BUH'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_BUH', 'Дата до которой действует Название товара(бухг.)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_BUH');


CREATE OR REPLACE FUNCTION zc_ObjectDate_User_UpdateMobileFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_UpdateMobileFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_UpdateMobileFrom', 'Дата/время успешной синхронизации с Мобильного устройства' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_UpdateMobileFrom');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_UpdateMobileTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_UpdateMobileTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_UpdateMobileTo', 'Дата/время успешной синхронизации на Мобильное устройство' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_UpdateMobileTo');


CREATE OR REPLACE FUNCTION zc_ObjectDate_User_FarmacyCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_FarmacyCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_FarmacyCash', 'дата/время когда в последний раз работал и проводи документ Чек' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_FarmacyCash');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_In() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_In'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_In', 'Дата принятия на работу' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_In');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_GUID', 'дата/время окончания использования UUID-сессии' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_GUID');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_SMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_SMS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_SMS', 'дата/время отправки SMS для идентификации' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_SMS');

CREATE OR REPLACE FUNCTION zc_ObjectDate_MemberSP_HappyDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MemberSP_HappyDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_MemberSP(), 'zc_ObjectDate_MemberSP_HappyDate', 'Дата рождения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MemberSP_HappyDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceChange_DateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceChange_DateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceChange(), 'zc_ObjectDate_PriceChange_DateChange', 'Дата, время изменения цены или % наценки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceChange_DateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_RepriceUnitSheduler_DataStartLast() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_RepriceUnitSheduler_DataStartLast'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_RepriceUnitSheduler(), 'zc_ObjectDate_RepriceUnitSheduler_DataStartLast', 'Старт последней переоценкии' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_RepriceUnitSheduler_DataStartLast');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays', 'Дата начала праздничных дней' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_RecalcMCSSheduler_EndHolidays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_EndHolidays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectFloat_RecalcMCSSheduler_EndHolidays', 'Последний день праздников' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_EndHolidays');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_RecalcMCSSheduler_DateRun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_DateRun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectFloat_RecalcMCSSheduler_DateRun', 'Дата проведения пересчета' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_DateRun');
  
CREATE OR REPLACE FUNCTION zc_ObjectFloat_RecalcMCSSheduler_DateRunSun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_DateRunSun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_RecalcMCSSheduler(), 'zc_ObjectFloat_RecalcMCSSheduler_DateRunSun', 'Дата проведения пересчета по СУН' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectFloat_RecalcMCSSheduler_DateRunSun');


CREATE OR REPLACE FUNCTION zc_ObjectDate_Maker_SendPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_SendPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectDate_Maker_SendPlan', 'Когда планируем отправить(дата/время)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_SendPlan');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Maker_SendReal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_SendReal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectDate_Maker_SendReal', 'Когда успешно прошла отправка (дата/время)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_SendReal');

CREATE OR REPLACE FUNCTION zc_ObjectDate_CashRegister_TimePUSHFinal1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashRegister_TimePUSHFinal1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashRegister(), 'zc_ObjectDate_CashRegister_TimePUSHFinal1', 'Время первого PUSH сообщения о завершении работы' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashRegister_TimePUSHFinal1');

CREATE OR REPLACE FUNCTION zc_ObjectDate_CashRegister_TimePUSHFinal2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashRegister_TimePUSHFinal2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashRegister(), 'zc_ObjectDate_CashRegister_TimePUSHFinal2', 'Время второго PUSH сообщения о завершении работы' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashRegister_TimePUSHFinal2');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Route_StartRunPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Route_StartRunPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectDate_Route_StartRunPlan', 'Время выезда план' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Route_StartRunPlan');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Route_EndRunPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Route_EndRunPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Route(), 'zc_ObjectDate_Route_EndRunPlan', 'Время возвращения план' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Route_EndRunPlan');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PartionGoods_Cat_5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionGoods_Cat_5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectDate_PartionGoods_Cat_5', 'Дата перевода в 5 категорию' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionGoods_Cat_5');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_MondayStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_MondayStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_MondayStart', 'Пон. -  пятн. начало работы' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_MondayStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_MondayEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_MondayEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_MondayEnd', 'Пон. -  пятн. конец работы' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_MondayEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SaturdayStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SaturdayStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SaturdayStart', 'Суббота начало работы' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SaturdayStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SaturdayEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SaturdayEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SaturdayEnd', 'Суббота конец работы' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SaturdayEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SundayStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SundayStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SundayStart', 'Воскресенье начало работы' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SundayStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SundayEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SundayEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SundayEnd', 'Воскресенье конец работы' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SundayEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PlanIventory_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_OperDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PlanIventory(), 'zc_ObjectDate_PlanIventory_OperDate', 'Дата инвентаризации' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_OperDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PlanIventory_DateEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_DateEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PlanIventory(), 'zc_ObjectDate_PlanIventory_DateEnd', 'Дата инвентаризации' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_DateEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PlanIventory_DateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_DateStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PlanIventory(), 'zc_ObjectDate_PlanIventory_DateStart', 'Дата инвентаризации' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PlanIventory_DateStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Buyer_DateBirth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Buyer_DateBirth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Buyer(), 'zc_ObjectDate_Buyer_DateBirth', 'Дата рождения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Buyer_DateBirth');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractCondition_StartDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractCondition_StartDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractCondition(), 'zc_ObjectDate_ContractCondition_StartDate', 'Дейстует с' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractCondition_StartDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ContractCondition_EndDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractCondition_EndDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ContractCondition(), 'zc_ObjectDate_ContractCondition_EndDate', 'Дейстует по' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ContractCondition_EndDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_CashSettings_DateBanSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashSettings_DateBanSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CashSettings(), 'zc_ObjectDate_CashSettings_DateBanSUN', 'Дата запрета работы по СУН' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CashSettings_DateBanSUN');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_PUSH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_PUSH'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_PUSH', 'Дата последнего получения PUSH в Фармаси' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_PUSH');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_FirstCheck() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_FirstCheck'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_FirstCheck', 'Первый чек' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_FirstCheck');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Hardware_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Hardware_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Hardware(), 'zc_ObjectDate_Hardware_Update', 'Дата изменения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Hardware_Update');

CREATE OR REPLACE FUNCTION zc_ObjectDate_FinalSUAProtocol_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_FinalSUAProtocol_OperDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectDate_FinalSUAProtocol_OperDate', 'Дата и время формирования документа' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_FinalSUAProtocol_OperDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_FinalSUAProtocol_DateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Hardware_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectDate_FinalSUAProtocol_DateStart', 'Начало периода' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_FinalSUAProtocol_DateStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_FinalSUAProtocol_DateEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_FinalSUAProtocol_DateEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_FinalSUAProtocol(), 'zc_ObjectDate_FinalSUAProtocol_DateEnd', 'Окончание периода' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_FinalSUAProtocol_DateEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_AutoSUA() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_AutoSUA'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_AutoSUA', 'Дата автоматического расчета по СУА' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_AutoSUA');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceSite_DateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectDate_PriceSite_DateChange', 'Дата изменения цены' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DateChange');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceSite_FixDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_FixDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectDate_PriceSite_FixDateChange', 'Дата изменения фиксированная цена' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_FixDateChange');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceSite_PercentMarkupDateChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_PercentMarkupDateChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectDate_PriceSite_PercentMarkupDateChange', 'Дата изменения % наценки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_PercentMarkupDateChange');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_CorrectMinAmount_Date() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectMinAmount_Date'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CorrectMinAmount(), 'zc_ObjectDate_CorrectMinAmount_Date', 'Дата начала действия' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectMinAmount_Date');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_CheckoutTesting_DateUpdate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CheckoutTesting_DateUpdate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CheckoutTesting(), 'zc_ObjectDate_CheckoutTesting_DateUpdate', 'Дата и время обновления на кассы и сервиса' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CheckoutTesting_DateUpdate');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_ZReportLog_Date() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ZReportLog_Date'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ZReportLog(), 'zc_ObjectDate_ZReportLog_Date', 'Дата Z отчета' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ZReportLog_Date');
  
CREATE OR REPLACE FUNCTION zc_ObjectDate_Maker_StartDateUnPlanned() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_StartDateUnPlanned'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectDate_Maker_StartDateUnPlanned', 'Дата начала для внепланового отчета' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_StartDateUnPlanned');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Maker_EndDateUnPlanned() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_EndDateUnPlanned'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Maker(), 'zc_ObjectDate_Maker_EndDateUnPlanned', 'Дата окончания для внепланового отчета' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Maker_EndDateUnPlanned');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_UpdateMinimumLot() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UpdateMinimumLot'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_UpdateMinimumLot', 'Дата (корр. Мин. округл)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UpdateMinimumLot');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_UpdateisPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UpdateisPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_UpdateisPromo', 'Дата (корр. Акция)' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_UpdateisPromo');

CREATE OR REPLACE FUNCTION zc_ObjectDate_CorrectWagesPercentage_DateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectWagesPercentage_DateStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CorrectWagesPercentage(), 'zc_ObjectDate_CorrectWagesPercentage_DateStart', 'Дата начала действия' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectWagesPercentage_DateStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_CorrectWagesPercentage_DateEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectWagesPercentage_DateEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_CorrectWagesPercentage(), 'zc_ObjectDate_CorrectWagesPercentage_DateEnd', 'Дата окончания действия' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_CorrectWagesPercentage_DateEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_Exam() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Exam'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_Exam', 'Сдача экзамена' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_Exam');

CREATE OR REPLACE FUNCTION zc_ObjectDate_SurchargeWages_DateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SurchargeWages_DateStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_SurchargeWages(), 'zc_ObjectDate_SurchargeWages_DateStart', 'Дата начала действия' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SurchargeWages_DateStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_SurchargeWages_DateEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SurchargeWages_DateEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_SurchargeWages(), 'zc_ObjectDate_SurchargeWages_DateEnd', 'Дата окончания действия' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_SurchargeWages_DateEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PickUpLogsAndDBF_DateLoaded() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PickUpLogsAndDBF_DateLoaded'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PickUpLogsAndDBF(), 'zc_ObjectDate_PickUpLogsAndDBF_DateLoaded', 'Дата и время загрузки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PickUpLogsAndDBF_DateLoaded');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ConditionsKeep_ColdSUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ConditionsKeep_ColdSUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ConditionsKeep(), 'zc_ObjectDate_ConditionsKeep_ColdSUN', 'Холод для СУН' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ConditionsKeep_ColdSUN');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_DiscontSiteStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_DiscontSiteStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_DiscontSiteStart', 'Дата начало скидки на сайте' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_DiscontSiteStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Goods_DiscontSiteEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_DiscontSiteEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Goods(), 'zc_ObjectDate_Goods_DiscontSiteEnd', 'Дата окончания скидки на сайте' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Goods_DiscontSiteEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceSite_DiscontStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DiscontStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectDate_PriceSite_DiscontStart', 'Дата начало скидки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DiscontStart');

CREATE OR REPLACE FUNCTION zc_ObjectDate_PriceSite_DiscontEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DiscontEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PriceSite(), 'zc_ObjectDate_PriceSite_DiscontEnd', 'Дата окончания скидки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PriceSite_DiscontEnd');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ExchangeRates_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ExchangeRates_OperDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ExchangeRates(), 'zc_ObjectDate_ExchangeRates_OperDate', 'Дата начала действия' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ExchangeRates_OperDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_User_KeyExpireDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_KeyExpireDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_KeyExpireDate', 'Дата истечения срока действия файлового ключа' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_KeyExpireDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_MCRequest_DateUpdate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MCRequest_DateUpdate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_MCRequest(), 'zc_ObjectDate_MCRequest_DateUpdate', 'Дата последнего изменения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MCRequest_DateUpdate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_MCRequest_DateDone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MCRequest_DateDone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_MCRequest(), 'zc_ObjectDate_MCRequest_DateDone', 'Дата выполнения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MCRequest_DateDone');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_SetDateRRO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SetDateRRO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_SetDateRRO', 'Авто установка времени на РРО' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_SetDateRRO');

 CREATE OR REPLACE FUNCTION zc_ObjectDate_Unit_PersonalService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_PersonalService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectDate_Unit_PersonalService', 'Дата/время когда сформировались начисление зп автоматом' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_PersonalService');

 CREATE OR REPLACE FUNCTION zc_ObjectDate_User_InternshipConfirmation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Unit_PersonalService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_InternshipConfirmation', 'Дата подтверждения стажировки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_InternshipConfirmation');

 CREATE OR REPLACE FUNCTION zc_ObjectDate_User_InternshipCompleted() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_InternshipCompleted'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectDate_User_InternshipCompleted', 'Дата признака стажировка проведена' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_User_InternshipCompleted');

 CREATE OR REPLACE FUNCTION zc_ObjectDate_PartionDateWages_DateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionDateWages_DateStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionDateWages(), 'zc_ObjectDate_PartionDateWages_DateStart', 'Дата начала действия' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionDateWages_DateStart');


/*-------------------------------------------------------------------------------
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 09.11.23         * zc_ObjectDate_Goods_UKTZED_new
 19.04.23         * zc_ObjectDate_Personal_Send
 29.03.23         * zc_ObjectDate_GoodsGroup_UKTZED_new
 18.01.23                                                                                     * zc_ObjectDate_PartionDateWages_DateStart
 26.09.22                                                                                     * zc_ObjectDate_User_InternshipConfirmation, zc_ObjectDate_User_InternshipCompleted
 06.09.22         * zc_ObjectDate_Unit_PersonalService
 05.09.22                                                                                     * zc_ObjectDate_Unit_SetDateRRO
 01.09.22         * zc_ObjectDate_JuridicalDefermentPayment_OperDateIn
 20.05.22                                                                                     * zc_ObjectDate_MCRequest_DateUpdate, zc_ObjectDate_MCRequest_DateDone
 17.03.22                                                                                     * zc_ObjectDate_User_KeyExpireDate
 24.02.22                                                                                     * zc_ObjectDate_ExchangeRates_OperDate
 15.02.22                                                                                     * zc_ObjectDate_PriceSite_DiscontStart, zc_ObjectDate_PriceSite_DiscontEnd
 15.02.22                                                                                     * zc_ObjectDate_Goods_DiscontSiteStart, zc_ObjectDate_Goods_DiscontSiteEnd
 20.01.22                                                                                     * zc_ObjectDate_PickUpLogsAndDBF_DateLoaded
 25.11.21                                                                                     * zc_ObjectDate_SurchargeWages_...
 07.10.21                                                                                     * zc_ObjectDate_Unit_Exam
 24.09.21                                                                                     * zc_ObjectDate_CorrectWagesPercentage_Date... 
 15.09.21                                                                                     * zc_ObjectDate_Goods_Update... 
 09.09.21                                                                                     * zc_ObjectDate_Maker_StartDateUnPlanned, zc_ObjectDate_Maker_EndDateUnPlanned
 30.07.21                                                                                     * zc_ObjectDate_ZReportLog_Date
 25.06.21                                                                                     * zc_ObjectDate_CheckoutTesting_DateUpdate
 22.06.21                                                                                     * zc_ObjectDate_CorrectMinAmount_Date
 27.04.21                                                                                     * zc_ObjectDate_PriceSite_...
 27.05.21         * zc_ObjectDate_ContractPriceList_StartDate
                    zc_ObjectDate_ContractPriceList_EndDate
 19.05.21                                                                                     * zc_ObjectDate_Unit_AutoSUA
 13.05.21         * zc_ObjectDate_User_GUID
 24.03.21                                                                                     * zc_ObjectDate_FinalSUAProtocol_...
 04.02.21                                                                                     * zc_ObjectDate_Hardware_Update
 06.11.20         * zc_ObjectDate_ContractGoods_Start
                    zc_ObjectDate_ContractGoods_End
 30.09.20                                                                                     * zc_ObjectDate_Unit_FirstCheck
 25.09.20         * zc_Object_ReportBonus_Month
 04.06.20                                                                                     * zc_ObjectDate_User_PUSH
 07.05.20                                                                                     * zc_ObjectDate_Buyer_DateBirth
 06.05.20         * zc_ObjectDate_Juridical_VatPrice
 24.03.20         * zc_ObjectDate_ContractCondition_StartDate
                    zc_ObjectDate_ContractCondition_EndDate
 10.02.20                                                                                     * zc_ObjectDate_Buyer_DateBirth
 29.01.20         * zc_ObjectDate_PlanIventory_DateEnd
                    zc_ObjectDate_PlanIventory_DateStart
                    zc_ObjectDate_PlanIventory_OperDate
 10.12.19                                                                                     * zc_ObjectFloat_RecalcMCSSheduler_DateRunSun 
 28.10.19                                                                                     * График работы
 14.08.19                                                                                     * zc_ObjectDate_PartionGoods_Cat_5
 06.04.19         * zc_ObjectDate_Route_StartRunPlan
                    zc_ObjectDate_Route_EndRunPlan
 20.03.19         * zc_ObjectDate_Unit_SP
                    zc_ObjectDate_Unit_StartSP
                    zc_ObjectDate_Unit_EndSP
 04.03.19                                                                                     * zc_ObjectFloat_CashRegister_TimePUSHFinal ...
 15.02.19         * zc_ObjectDate_Unit_TaxUnitStart
                    zc_ObjectDate_Unit_TaxUnitEnd
 12.02.19                                                                                     * zc_ObjectFloat_RecalcMCSSheduler_DateRun
 11.01.19         * zc_ObjectDate_Maker_SendPlan
                    zc_ObjectDate_Maker_SendReal
 25.12.18                                                                                     * zzc_ObjectFloat_RecalcMCSSheduler_
 22.10.18                                                                                     * zc_ObjectDate_RepriceUnitSheduler_DataStartLast 
 18.10.18         * zc_ObjectDate_Goods_In
 16,10,18         * zc_ObjectDate_Protocol_ReCalc
 16.08.18         * zc_ObjectDate_PriceChange_DateChange
 20.06.18         * zc_ObjectDate_ReplServer_...
 14.05.18                                                                                     * zc_ObjectFloat_Unit_NormOfManDays, zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan
                                                                                                zc_ObjectFloat_UnitCategory_PremiumImplPlan, zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan 
 18.01.18         * zc_ObjectDate_MemberSP_HappyDate
 02.11.17         * zc_ObjectDate_GoodsReportSaleInf_Start
                    zc_ObjectDate_GoodsReportSaleInf_End
 15.09.17         * zc_ObjectDate_Unit_Create
                    zc_ObjectDate_Unit_Close
 16.08.17         * zc_ObjectDate_Goods_LastPriceOld
 09.06.17         * zc_ObjectDate_Price_StartDateMCSAuto
                    zc_ObjectDate_Price_EndDateMCSAuto
 14.04.17         * zc_ObjectDate_GoodsListIncome_Last
 04.04.17         * zc_ObjectDate_Goods_ReestrSP
 13.06.16         * add zc_ObjectDate_Unit_FarmacyCash
 03.03.16         *
 14.01.16         * add zc_ObjectDate_Member_StartSummer, zc_ObjectDate_Member_EndSummer
 22.12.15                                                                       *zc_ObjectDate_Price_MCSIsCloseDateChange,zc_ObjectDate_Price_MCSNotRecalcDateChange,zc_ObjectDate_Price_FixDateChange
 27.09.15                                                                       *zc_ObjectDate_ReportSoldParams_PlanDate
 12.02.15         * add zc_ObjectDate_Contract_StartPromo
                        zc_ObjectDate_Contract_EndPromo
 04.09.14                                                        *
 21.07.14                      	                 * add zc_ObjectDate_Contract_Document
 01.05.14                      	                 * add zc_ObjectDate_InvNumberTax_Value
 25.02.14                                        * add zc_ObjectDate_Protocol_...
 12.01.14          * add zc_ObjectDate_Partner_StartPromo, zc_ObjectDate_Partner_EndPromo
                         zc_ObjectDate_Juridical_EndPromo, zc_ObjectDate_Juridical_EndPromo
 25.09.13          * del Car_StartDateRate, Car_EndDateRate
 19.07.13          * rename zc_ObjectDate_
 01.07.13          *
*/
