--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_In() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_In', 'Дата принятия у сотрудника' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_Out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_Out', 'Дата увольнения у сотрудника' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out');

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

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Unit_NormOfManDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_NormOfManDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Unit(), 'zc_ObjectFloat_Unit_NormOfManDays', 'Норма человекодней в месяце' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Unit_NormOfManDays');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_UnitCategory(), 'zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan', '% штрафа за невыполнение минимального плана' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_UnitCategory_PremiumImplPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PremiumImplPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_UnitCategory(), 'zc_ObjectFloat_UnitCategory_PremiumImplPlan', '% премии за выполнение плана продаж' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_PremiumImplPlan');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_UnitCategory(), 'zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan', 'Минимальный % построчного выполнения минимального плана для получения премии' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan');


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

CREATE OR REPLACE FUNCTION zc_ObjectDate_MemberSP_HappyDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MemberSP_HappyDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_MemberSP(), 'zc_ObjectDate_MemberSP_HappyDate', 'Дата рождения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_MemberSP_HappyDate');


/*-------------------------------------------------------------------------------
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
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
