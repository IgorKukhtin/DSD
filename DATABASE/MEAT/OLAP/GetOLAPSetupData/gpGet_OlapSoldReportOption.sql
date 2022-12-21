-- Function: gpGet_OlapSoldReportOption (TVarChar)

DROP FUNCTION IF EXISTS gpGet_OlapSoldReportOption (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OlapSoldReportOption(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (SortField Integer, FieldType TVarChar, Caption TVarChar, CaptionCode TVarChar, FieldName TVarChar, FieldCodeName TVarChar, DisplayFormat TVarChar
             , TableName TVarChar, TableSyn TVarChar, ConnectFieldName TVarChar
             , VisibleFieldName TVarChar, VisibleFieldCode TVarChar, SummaryType TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsCost Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    -- Отчеты (управленцы) + Аналитики по продажам
    vbIsCost:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin(), 10898, 326391) AND UserId = vbUserId)
            OR vbUserId = 1058530 -- Няйко В.И.
              ;

   
     -- Результат
     RETURN QUERY 
         SELECT *
         FROM 
        (SELECT 101 AS SortField, 'data' :: TVarChar AS FieldType, 'Кол.вес продажа' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Sale_AmountPartner_Weight' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.###' :: TVarChar AS DisplayFormat
              , '' :: TVarChar AS TableName, '' :: TVarChar AS TableSyn, '' :: TVarChar AS ConnectFieldName, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   -- UNION SELECT 102 AS SortField, 'data' :: TVarChar AS FieldType, 'Кол.шт. продано' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Sale_Amount_Sh' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.###' :: TVarChar, 
   --              '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 103 AS SortField, 'data' :: TVarChar AS FieldType, 'Сумма продажа' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Sale_Summ' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 104 AS SortField, 'data' :: TVarChar AS FieldType, 'С\с продажа' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Sale_SummCost' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE

   UNION SELECT 105 AS SortField, 'data' :: TVarChar AS FieldType, 'Скидка от опт.цен.' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Sale_Summ_10200' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 106 AS SortField, 'data' :: TVarChar AS FieldType, 'Скидка Акции' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Sale_Summ_10250' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 106 AS SortField, 'data' :: TVarChar AS FieldType, 'Скидка доп.' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Sale_Summ_10300' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 111 AS SortField, 'data' :: TVarChar AS FieldType, 'Кол.вес возврат' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Return_AmountPartner_Weight' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.###' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   -- UNION SELECT 112 AS SortField, 'data' :: TVarChar AS FieldType, 'Кол.шт. возврат' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Return_Amount_Sh' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.###' :: TVarChar, 
   --               '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 113 AS SortField, 'data' :: TVarChar AS FieldType, 'Сумма возврат' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Return_Summ' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 114 AS SortField, 'data' :: TVarChar AS FieldType, 'С\с возврат' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Return_SummCost' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE

   UNION SELECT 121 AS SortField, 'data' :: TVarChar AS FieldType, 'Кол.вес продажа-возврат' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleReturn_Amount_Weight' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.###' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   -- UNION SELECT 122 AS SortField, 'data' :: TVarChar AS FieldType, 'Кол.шт. продажа-возврат' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleReturn_Amount_Sh' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.###' :: TVarChar, 
   --               '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 123 AS SortField, 'data' :: TVarChar AS FieldType, 'Сумма продажа-возврат' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleReturn_summ' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 124 AS SortField, 'data' :: TVarChar AS FieldType, 'С\с продажа-возврат' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleReturn_SummCost' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE

   UNION SELECT 131 AS SortField, 'data' :: TVarChar AS FieldType, 'Сумма скидки' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleReturn_Summ_10300' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 132 AS SortField, 'data' :: TVarChar AS FieldType, 'Сумма скидки (на весе)' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Sale_SummCost_10500' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 133 AS SortField, 'data' :: TVarChar AS FieldType, 'Сумма бонус (прямой)' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'BonusBasis' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 134 AS SortField, 'data' :: TVarChar AS FieldType, 'Сумма бонус (другой)' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Bonus' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   -- UNION SELECT 132 AS SortField, 'data' :: TVarChar AS FieldType, 'Сумма продажа-бонус' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleBonus' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
   --               '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 141 AS SortField, 'data' :: TVarChar AS FieldType, 'Прибыль продажа' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Sale_Profit' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.0' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE
   UNION SELECT 142 AS SortField, 'data' :: TVarChar AS FieldType, 'Прибыль продажа-бонус' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleBonus_Profit' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.0' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE
   UNION SELECT 143 AS SortField, 'data' :: TVarChar AS FieldType, 'Прибыль продажа-возврат' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleReturn_Profit' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.0' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE
   UNION SELECT 144 AS SortField, 'data' :: TVarChar AS FieldType, 'Прибыль продажа-возврат-бонус' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleReturnBonus_Profit' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.0' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE

   UNION SELECT 151 AS SortField, 'data' :: TVarChar AS FieldType, '% рент. продажа' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Sale_Percent' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.0' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar,
                'Sale_SummCost,Sale_Profit' :: TVarChar,
                'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(Sale_Profit) / SUM(Sale_SummCost) * 100 END' :: TVarChar AS VisibleFieldName,
                '' :: TVarChar AS VisibleFieldCode,
                'stPercent' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE
   UNION SELECT 152 AS SortField, 'data' :: TVarChar AS FieldType, '% рент. продажа-бонус' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleBonus_Percent' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.0' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar,
                 'Sale_SummCost,SaleBonus_Profit' :: TVarChar,
                 'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(SaleBonus_Profit) / SUM(Sale_SummCost) * 100 END' :: TVarChar AS VisibleFieldName,
                 '' :: TVarChar AS VisibleFieldCode,
                 'stPercent' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE
   UNION SELECT 153 AS SortField, 'data' :: TVarChar AS FieldType, '% рент. продажа-возврат' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleReturn_Percent' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.0' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar,
                 'Sale_SummCost,SaleReturn_Profit' :: TVarChar,
                 'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(SaleReturn_Profit) / SUM(Sale_SummCost) * 100 END' :: TVarChar AS VisibleFieldName,
                 '' :: TVarChar AS VisibleFieldCode,
                 'stPercent' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE
   UNION SELECT 154 AS SortField, 'data' :: TVarChar AS FieldType, '% рент. продажа-возврат-бонус' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SaleReturnBonus_Percent' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.0' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar,
                 'Sale_SummCost,SaleReturnBonus_Profit' :: TVarChar,
                 'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(SaleReturnBonus_Profit) / SUM(Sale_SummCost) * 100 END' :: TVarChar AS VisibleFieldName,
                 '' :: TVarChar AS VisibleFieldCode,
                 'stPercent' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE

   UNION SELECT 161 AS SortField, 'data' :: TVarChar AS FieldType, 'План кол.вес' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Plan_Weight' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.###' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 162 AS SortField, 'data' :: TVarChar AS FieldType, 'План сумма' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Plan_Summ' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 163 AS SortField, 'data' :: TVarChar AS FieldType, '% выполнения план кол.вес' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Plan_Percent' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar,
                 'Plan_Weight,Sale_AmountPartner_Weight' :: TVarChar,
                 'CASE WHEN SUM(Plan_Weight) = 0 THEN 0 ELSE SUM(Sale_AmountPartner_Weight) / SUM(Plan_Weight) * 100 - 100 END' :: TVarChar AS VisibleFieldName,
                 '' :: TVarChar AS VisibleFieldCode,
                 'stPercent' :: TVarChar AS SummaryType

   UNION SELECT 164 AS SortField, 'data' :: TVarChar AS FieldType, 'Акции кг' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Actions_Weight' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.###' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 165 AS SortField, 'data' :: TVarChar AS FieldType, 'Акции с/с' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Actions_SummCost' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
         WHERE vbIsCost = TRUE
   UNION SELECT 166 AS SortField, 'data' :: TVarChar AS FieldType, 'Акции сумма' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Actions_Summ' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 171 AS SortField, 'data' :: TVarChar AS FieldType, 'Оплата сумма' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Money_Summ' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 172 AS SortField, 'data' :: TVarChar AS FieldType, 'Вз-зачет сумма' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'SendDebt_Summ' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 173 AS SortField, 'data' :: TVarChar AS FieldType, 'Оплата и Вз-зачет' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Money_SendDebt_Summ' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, ',0.00' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar, '' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 11, 'dimension' :: TVarChar AS FieldType, 'Форма оплаты' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'PaidKindName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectPaidKind' :: TVarChar, 'PaidKindId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 12, 'dimension' :: TVarChar AS FieldType, 'ФО (бонус)' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'PaidKindName_bonus' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectPaidKind_bonus' :: TVarChar, 'PaidKindId_bonus' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 13, 'dimension' :: TVarChar AS FieldType, 'Филиал' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'BranchName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectBranch' :: TVarChar, 'BranchId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 14, 'dimension' :: TVarChar AS FieldType, 'Регион' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'AreaName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectArea' :: TVarChar, 'AreaId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 15, 'dimension' :: TVarChar AS FieldType, 'Торговая сеть' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'RetailName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectRetail' :: TVarChar, 'RetailId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 16, 'dimension' :: TVarChar AS FieldType, 'Юридическое лицо' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'JuridicalName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectJuridical' :: TVarChar, 'JuridicalId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 17, 'dimension' :: TVarChar AS FieldType, 'Контрагент' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'PartnerName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectPartner' :: TVarChar, 'PartnerId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 18, 'dimension' :: TVarChar AS FieldType, 'Признак торговой точки' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'PartnerTagName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectPartnerTag' :: TVarChar, 'PartnerTagId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 19, 'dimension' :: TVarChar AS FieldType, 'Группа признак договора' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'ContractTagGroupName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectContractTagGroup' :: TVarChar, 'ContractTagGroupId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 20, 'dimension' :: TVarChar AS FieldType, 'Признак договора' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'ContractTagName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectContractTag' :: TVarChar, 'ContractTagId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 21 AS SortField, 'dimension' :: TVarChar AS FieldType, 'Код дог.' :: TVarChar AS Caption, 'Код дог.' :: TVarChar AS CaptionCode, 'ContractCode' :: TVarChar AS FieldName, 'ContractCode' :: TVarChar AS FieldCodeName, '' :: TVarChar AS DisplayFormat,
                 'Object' :: TVarChar AS TableName, 'ObjectContract' :: TVarChar AS TableSyn, 'ContractId' :: TVarChar AS ConnectFieldName, 'ObjectCode' :: TVarChar AS VisibleFieldName, 'ObjectCode' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 22, 'dimension' :: TVarChar AS FieldType, '№ дог.' :: TVarChar AS Caption, 'Код дог.' :: TVarChar AS CaptionCode, 'ContractNumber' :: TVarChar AS FieldName, 'ContractCode' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar AS TableName, 'ObjectContract' :: TVarChar AS TableSyn, 'ContractId' :: TVarChar AS ConnectFieldName, 'ValueData' :: TVarChar AS VisibleFieldName, 'ObjectCode' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 23, 'dimension' :: TVarChar AS FieldType, 'УП статья' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'InfoMoneyName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectInfoMoney' :: TVarChar, 'InfoMoneyId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 31, 'dimension' :: TVarChar AS FieldType, 'ФИО (супервайзер)' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'PersonalName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectPersonal' :: TVarChar, 'PersonalId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 32, 'dimension' :: TVarChar AS FieldType, 'ФИО (ТП)' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'PersonalTradeName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectPersonalTrade' :: TVarChar, 'PersonalTradeId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 33, 'dimension' :: TVarChar AS FieldType, 'Филиал (супервайзер)' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'BranchPersonalName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar,
                 'Object' :: TVarChar, 'ObjectBranchPersonal' :: TVarChar, 'BranchId_Personal' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   /*UNION SELECT 40, 'dimension' :: TVarChar AS FieldType, 'Адрес' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'Address' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 '' :: TVarChar, '' :: TVarChar,'Address' :: TVarChar, '' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType*/

   UNION SELECT 41, 'dimension' :: TVarChar AS FieldType, 'Область' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'RegionName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectRegion' :: TVarChar, 'RegionId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 42, 'dimension' :: TVarChar AS FieldType, 'Район' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'ProvinceName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectProvince' :: TVarChar, 'ProvinceId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 43, 'dimension' :: TVarChar AS FieldType, 'Вид н.п.' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'CityKindName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectCityKind' :: TVarChar, 'CityKindId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 44, 'dimension' :: TVarChar AS FieldType, 'Населенный пункт' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'CityName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectCity' :: TVarChar, 'CityId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 45, 'dimension' :: TVarChar AS FieldType, 'Микрорайон' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'ProvinceCityName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectProvinceCity' :: TVarChar, 'ProvinceCityId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 46, 'dimension' :: TVarChar AS FieldType, 'Вид ул.' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'StreetKindName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectStreetKind' :: TVarChar, 'StreetKindId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 47, 'dimension' :: TVarChar AS FieldType, 'Улица' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'StreetName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectStreet' :: TVarChar, 'StreetId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 50, 'dimension' :: TVarChar AS FieldType, 'Бизнес' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'BusinessName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectBusiness' :: TVarChar, 'BusinessId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 50, 'dimension' :: TVarChar AS FieldType, 'Производственная площадка' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'GoodsPlatformName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectGoodsPlatform' :: TVarChar, 'GoodsPlatformId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 51, 'dimension' :: TVarChar AS FieldType, 'Торговая марка' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'TradeMarkName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectTradeMark' :: TVarChar, 'TradeMarkId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 52, 'dimension' :: TVarChar AS FieldType, 'Группа аналитики' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'GoodsGroupAnalystName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectGoodsGroupAnalyst' :: TVarChar, 'GoodsGroupAnalystId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 53, 'dimension' :: TVarChar AS FieldType, 'Признак товара' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'GoodsTagName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectGoodsTag' :: TVarChar, 'GoodsTagId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 54 AS SortField, 'dimension' :: TVarChar AS FieldType, 'Код тов.' :: TVarChar AS Caption, 'Код тов.' :: TVarChar AS CaptionCode, 'GoodsCode' :: TVarChar AS FieldName, 'GoodsCode' :: TVarChar AS FieldCodeName, '' :: TVarChar AS DisplayFormat
             , 'Object' :: TVarChar AS TableName, 'ObjectGoods' :: TVarChar AS TableSyn, 'GoodsId' :: TVarChar AS ConnectFieldName, 'ObjectCode' :: TVarChar AS VisibleFieldName, 'ObjectCode' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 55 AS SortField, 'dimension' :: TVarChar AS FieldType, 'Товар' :: TVarChar AS Caption, 'Код тов.' :: TVarChar AS CaptionCode, 'GoodsName' :: TVarChar AS FieldName, 'GoodsCode' :: TVarChar AS FieldCodeName, '' :: TVarChar AS DisplayFormat
             , 'Object' :: TVarChar AS TableName, 'ObjectGoods' :: TVarChar AS TableSyn, 'GoodsId' :: TVarChar AS ConnectFieldName, 'ValueData' :: TVarChar AS VisibleFieldName, 'ObjectCode' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 56, 'dimension' :: TVarChar AS FieldType, 'Вид товара' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'GoodsKindName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectGoodsKind' :: TVarChar, 'GoodsKindId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType
   UNION SELECT 57, 'dimension' :: TVarChar AS FieldType, 'Ед. изм.' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'MeasureName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object' :: TVarChar, 'ObjectMeasure' :: TVarChar, 'MeasureId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 58, 'dimension' :: TVarChar AS FieldType, 'Категория ТТ' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'CategoryName' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object_Partner_Category_View' :: TVarChar, 'Object_Partner_Category_View' :: TVarChar, 'PartnerId' :: TVarChar, 'Category' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

   UNION SELECT 59, 'dimension' :: TVarChar AS FieldType, 'Топ' :: TVarChar AS Caption, '' :: TVarChar AS CaptionCode, 'ValueData' :: TVarChar AS FieldName, '' :: TVarChar AS FieldCodeName, '' :: TVarChar, 
                 'Object_GoodsByGoodsKind_Top_View' :: TVarChar, 'Object_GoodsByGoodsKind_Top_View' :: TVarChar, 'GoodsByGoodsKindId' :: TVarChar, 'ValueData' :: TVarChar AS VisibleFieldName, '' :: TVarChar AS VisibleFieldCode, '' :: TVarChar AS SummaryType

     )
                 AS SetupData ORDER BY 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OlapSoldReportOption (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.01.15                                        * all
 21.11.14                        * 
*/

-- тест
-- SELECT * FROM gpGet_OlapSoldReportOption (zfCalc_UserAdmin())
