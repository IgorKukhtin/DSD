-- View: _bi_Guide_GoodsGroup_View

-- DROP VIEW IF EXISTS _bi_Guide_GoodsGroup_View;
--Справочник Группы товаров
CREATE OR REPLACE VIEW _bi_Guide_GoodsGroup_View
AS
     SELECT 
            Object_GoodsGroup.Id                AS Id 
          , Object_GoodsGroup.ObjectCode        AS Code
          , Object_GoodsGroup.ValueData         AS Name
          , Object_GoodsGroup.isErased          AS isErased
          --Родитель Группы товаров
          , Object_Parent.Id                    AS ParentId 
          , Object_Parent.ObjectCode            AS ParentCode
          , Object_Parent.ValueData             AS ParentName
          --Группы товаров(статистика)
          , Object_GoodsGroupStat.Id            AS GroupStatId 
          , Object_GoodsGroupStat.ObjectCode    AS GroupStatCode
          , Object_GoodsGroupStat.ValueData     AS GroupStatName          
          --Торговые марки
          , Object_TradeMark.Id                 AS TradeMarkId
          , Object_TradeMark.ObjectCode         AS TradeMarkCode
          , Object_TradeMark.ValueData          AS TradeMarkName
          --Признак товара
          , Object_GoodsTag.Id                  AS GoodsTagId
          , Object_GoodsTag.ObjectCode          AS GoodsTagCode
          , Object_GoodsTag.ValueData           AS GoodsTagName
          --Группа товаров(аналитика)          
          , Object_GoodsGroupAnalyst.Id         AS GoodsGroupAnalystId
          , Object_GoodsGroupAnalyst.ObjectCode AS GoodsGroupAnalystCode
          , Object_GoodsGroupAnalyst.ValueData  AS GoodsGroupAnalystName
          --Производственная площадка
          , Object_GoodsPlatform.Id             AS GoodsPlatformId
          , Object_GoodsPlatform.ObjectCode     AS GoodsPlatformCode
          , Object_GoodsPlatform.ValueData      AS GoodsPlatformName
          --Статьи назначения
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyGroupId
          , Object_InfoMoney_View.InfoMoneyGroupCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationId
          , Object_InfoMoney_View.InfoMoneyDestinationCode
          , Object_InfoMoney_View.InfoMoneyDestinationName
          --Код товару згідно з УКТ ЗЕД
          , ObjectString_GoodsGroup_UKTZED.ValueData     ::TVarChar  AS CodeUKTZED
          --новый Код товару згідно з УКТ ЗЕД
          , ObjectString_GoodsGroup_UKTZED_new.ValueData ::TVarChar  AS CodeUKTZED_new
          --дата с которой действует новый Код УКТ ЗЕД
          , ObjectDate_GoodsGroup_UKTZED_new.ValueData   ::TDateTime AS DateUKTZED_new          
          --Ознака імпортованого товару
          , ObjectString_GoodsGroup_TaxImport.ValueData  :: TVarChar AS TaxImport
          --Послуги згідно з ДКПП
          , ObjectString_GoodsGroup_DKPP.ValueData       :: TVarChar AS DKPP
          --Код виду діяльності сільск-господар товаровиробника
          , ObjectString_GoodsGroup_TaxAction.ValueData  :: TVarChar AS TaxAction
          --Признак - ОС
          , COALESCE(ObjectBoolean_GoodsGroup_Asset.ValueData, FALSE) ::Boolean AS isAsset
          
       FROM Object AS Object_GoodsGroup
           --Родитель Группы товаров
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                ON ObjectLink_GoodsGroup_Parent.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
           LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroup_Parent.ChildObjectId
           --Группы товаров(статистика)
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsGroupStat
                                ON ObjectLink_GoodsGroup_GoodsGroupStat.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_GoodsGroupStat.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupStat()
           LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_GoodsGroup_GoodsGroupStat.ChildObjectId
           --Торговые марки
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_TradeMark
                                ON ObjectLink_GoodsGroup_TradeMark.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_TradeMark.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
           LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_GoodsGroup_TradeMark.ChildObjectId
           --Признак товара
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsTag
                                ON ObjectLink_GoodsGroup_GoodsTag.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_GoodsTag.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
           LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_GoodsGroup_GoodsTag.ChildObjectId
           --Группа товаров(аналитика)
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsGroupAnalyst
                                ON ObjectLink_GoodsGroup_GoodsGroupAnalyst.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_GoodsGroupAnalyst.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
           LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_GoodsGroup_GoodsGroupAnalyst.ChildObjectId
           --Производственная площадка
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsPlatform
                                ON ObjectLink_GoodsGroup_GoodsPlatform.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_GoodsPlatform.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
           LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_GoodsGroup_GoodsPlatform.ChildObjectId
           --Статьи назначения
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_InfoMoney
                                ON ObjectLink_GoodsGroup_InfoMoney.ObjectId = Object_GoodsGroup.Id 
                               AND ObjectLink_GoodsGroup_InfoMoney.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_GoodsGroup_InfoMoney.ChildObjectId
           --Признак - ОС
           LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsGroup_Asset
                                   ON ObjectBoolean_GoodsGroup_Asset.ObjectId = Object_GoodsGroup.Id 
                                  AND ObjectBoolean_GoodsGroup_Asset.DescId = zc_ObjectBoolean_GoodsGroup_Asset()
           --Код товару згідно з УКТ ЗЕД
           LEFT JOIN ObjectString AS ObjectString_GoodsGroup_UKTZED
                                  ON ObjectString_GoodsGroup_UKTZED.ObjectId = Object_GoodsGroup.Id 
                                 AND ObjectString_GoodsGroup_UKTZED.DescId = zc_ObjectString_GoodsGroup_UKTZED()
           --новый Код товару згідно з УКТ ЗЕД
           LEFT JOIN ObjectString AS ObjectString_GoodsGroup_UKTZED_new
                                  ON ObjectString_GoodsGroup_UKTZED_new.ObjectId = Object_GoodsGroup.Id
                                 AND ObjectString_GoodsGroup_UKTZED_new.DescId = zc_ObjectString_GoodsGroup_UKTZED_new() 
           --дата с которой действует новый Код УКТ ЗЕД                      
           LEFT JOIN ObjectDate AS ObjectDate_GoodsGroup_UKTZED_new
                                ON ObjectDate_GoodsGroup_UKTZED_new.ObjectId = Object_GoodsGroup.Id
                               AND ObjectDate_GoodsGroup_UKTZED_new.DescId = zc_ObjectDate_GoodsGroup_UKTZED_new()
           --Ознака імпортованого товару
           LEFT JOIN ObjectString AS ObjectString_GoodsGroup_TaxImport
                                  ON ObjectString_GoodsGroup_TaxImport.ObjectId = Object_GoodsGroup.Id
                                 AND ObjectString_GoodsGroup_TaxImport.DescId = zc_ObjectString_GoodsGroup_TaxImport()
           --Послуги згідно з ДКПП
           LEFT JOIN ObjectString AS ObjectString_GoodsGroup_DKPP
                                  ON ObjectString_GoodsGroup_DKPP.ObjectId = Object_GoodsGroup.Id
                                 AND ObjectString_GoodsGroup_DKPP.DescId = zc_ObjectString_GoodsGroup_DKPP()
           --Код виду діяльності сільск-господар товаровиробника
           LEFT JOIN ObjectString AS ObjectString_GoodsGroup_TaxAction
                                  ON ObjectString_GoodsGroup_TaxAction.ObjectId = Object_GoodsGroup.Id
                                 AND ObjectString_GoodsGroup_TaxAction.DescId = zc_ObjectString_GoodsGroup_TaxAction()
                                 
     WHERE Object_GoodsGroup.DescId = zc_Object_GoodsGroup();
     
ALTER TABLE _bi_Guide_GoodsGroup_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.05.25         *
*/

-- тест
-- SELECT * FROM _bi_Guide_GoodsGroup_View
