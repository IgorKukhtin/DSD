-- View: _bi_Guide_Goods_View

-- DROP VIEW IF EXISTS _bi_Guide_Goods_View;
--Справочник Товары
CREATE OR REPLACE VIEW _bi_Guide_Goods_View
AS
     SELECT 
            Object_Goods.Id                AS Id 
          , Object_Goods.ObjectCode        AS Code
          , Object_Goods.ValueData         AS Name
          , Object_Goods.isErased          AS isErased
          --Название сокращенное
          , ObjectString_Goods_ShortName.ValueData :: TVarChar AS ShortName 
          --Название товара(русс.)
          , COALESCE (zfCalc_Text_replace (ObjectString_Goods_RUS.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_RUS
          --Название товара(бухг.)
          , COALESCE (zfCalc_Text_replace (ObjectString_Goods_BUH.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_BUH
          --Название товара(для приложения Scale)
          , COALESCE (zfCalc_Text_replace (ObjectString_Goods_Scale.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_Scale
          --Полное название группы
          , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
          --Код товару згідно з УКТ ЗЕД
          , ObjectString_Goods_UKTZED.ValueData     ::TVarChar AS CodeUKTZED
          --новый Код товару згідно з УКТ ЗЕД
          , ObjectString_Goods_UKTZED_new.ValueData ::TVarChar AS CodeUKTZED_new
          --дата с которой действует новый Код УКТ ЗЕД
          , ObjectDate_Goods_UKTZED_new.ValueData   ::TDateTime AS DateUKTZED_new
          --Дата до которой действует Название товара(бухг.)
          , ObjectDate_BUH.ValueData       :: TDateTime AS Date_BUH
          --Дата прихода от поставщика
          , ObjectDate_In.ValueData       :: TDateTime AS InDate
          --Ознака імпортованого товару
          , ObjectString_Goods_TaxImport.ValueData  ::TVarChar AS TaxImport
          --Послуги згідно з ДКПП
          , ObjectString_Goods_DKPP.ValueData       ::TVarChar AS DKPP
          --Код виду діяльності сільск-господар товаровиробника 
          , ObjectString_Goods_TaxAction.ValueData  ::TVarChar AS TaxAction
          --Примечание
          , ObjectString_Goods_Comment.ValueData    ::TVarChar AS Comment
          --Вес товара
          , ObjectFloat_Weight.ValueData         ::TFloat AS Weight
          --Вес втулки
          , ObjectFloat_WeightTare.ValueData     ::TFloat AS WeightTare
          --Кол-во для веса
          , ObjectFloat_CountForWeight.ValueData ::TFloat AS CountForWeight
          ----Кол-во партий из рецептуры для замеса
          , ObjectFloat_CountReceipt.ValueData   ::TFloat AS CountReceipt
          --Код АЛАН
          , ObjectFloat_ObjectCode_Basis.ValueData ::Integer AS BasisCode

           --Ирна
          , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)       :: Boolean AS isIrna
          --Признак - ОС
          , COALESCE (ObjectBoolean_Goods_Asset.ValueData, FALSE)      :: Boolean AS isAsset
          --Партии поставщика в учете количеств
          , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)   :: Boolean AS isPartionCount
          --Партии поставщика в учете себестоимости
          , COALESCE (ObjectBoolean_PartionSumm.ValueData, TRUE)     :: Boolean AS isPartionSumm          
          --Показывать реальное назв.
          , COALESCE (ObjectBoolean_NameOrig.ValueData, FALSE)         :: Boolean AS isNameOrig
          --Учет по дате партии
          , COALESCE (ObjectBoolean_Goods_PartionDate.ValueData, FALSE):: Boolean AS isPartionDate
          --Проверка Количество голов
          , COALESCE (ObjectBoolean_Goods_HeadCount.ValueData, FALSE)  :: Boolean AS isHeadCount

          --Группы товаров
          , Object_GoodsGroup.Id                    AS GoodsGroupId 
          , Object_GoodsGroup.ObjectCode            AS GoodsGroupCode
          , Object_GoodsGroup.ValueData             AS GoodsGroupName
          --Группы товаров(статистика)
          , Object_GoodsGroupStat.Id            AS GroupStatId 
          , Object_GoodsGroupStat.ObjectCode    AS GroupStatCode
          , Object_GoodsGroupStat.ValueData     AS GroupStatName
          --Группа товаров(аналитика)
          , Object_GoodsGroupAnalyst.Id          AS GoodsGroupAnalystId
          , Object_GoodsGroupAnalyst.ObjectCode  AS GoodsGroupAnalysCode
          , Object_GoodsGroupAnalyst.ValueData   AS GoodsGroupAnalystName          
          --Торговые марки
          , Object_TradeMark.Id                 AS TradeMarkId
          , Object_TradeMark.ObjectCode         AS TradeMarkCode
          , Object_TradeMark.ValueData          AS TradeMarkName
          --Единицы измерения
          , Object_Measure.Id               AS MeasureId
          , Object_Measure.ObjectCode       AS MeasureCode
          , Object_Measure.ValueData        AS MeasureName 
          --Единицы измерения - Международное наименование
          , ObjectString_Measure_InternalName.ValueData ::TVarChar AS InternalName
          --Единицы измерения - Международный код 
          , ObjectString_Measure_InternalCode.ValueData ::TVarChar AS InternalCode
            
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
          --Бизнесы
          , Object_Business.Id           AS BusinessId
          , Object_Business.ObjectCode   AS BusinessCode
          , Object_Business.ValueData    AS BusinessName
          --Виды топлива
          , Object_Fuel.Id               AS FuelId
          , Object_Fuel.ObjectCode       AS FuelCode
          , Object_Fuel.ValueData        AS FuelName
          --Признак товара
          , Object_GoodsTag.Id           AS GoodsTagId
          , Object_GoodsTag.ObjectCode   AS GoodsTagCode
          , Object_GoodsTag.ValueData    AS GoodsTagName
          --Производственная площадка
          , Object_GoodsPlatform.Id          AS GoodsPlatformId
          , Object_GoodsPlatform.ObjectCode  AS GoodsPlatformCode
          , Object_GoodsPlatform.ValueData   AS GoodsPlatformName
          --Поставщик
          , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInId
          , Object_PartnerIn.ObjectCode   :: TVarChar  AS PartnerInCode
          , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInName
          --Связь товаров с базовым
          , Object_Goods_basis.Id             AS GoodsId_basis
          , Object_Goods_basis.ObjectCode     AS GoodsCode_basis
          , Object_Goods_basis.ValueData      AS GoodsName_basis
          --Связь товаров с главным
          , Object_Goods_main.Id              AS GoodsId_main
          , Object_Goods_main.ObjectCode      AS GoodsCode_main
          , Object_Goods_main.ValueData       AS GoodsName_main
          --Основное средство (назначение ТМЦ) 
          , Object_Asset.Id          AS AssetId
          , Object_Asset.ObjectCode  AS AssetCode
          , Object_Asset.ValueData   AS AssetName
          --Основное средство (на каком оборудовании производится) 
          , Object_AssetProd.Id             AS AssetProdId
          , Object_AssetProd.ObjectCode     AS AssetProdCode
          , Object_AssetProd.ValueData      AS AssetProdName
          --Аналитический классификатор
          , Object_GoodsGroupProperty.Id             AS GoodsGroupPropertyId
          , Object_GoodsGroupProperty.ObjectCode     AS GoodsGroupPropertyCode
          , Object_GoodsGroupProperty.ValueData      AS GoodsGroupPropertyName
          --Аналитический классификатор - Группа
          , Object_GoodsGroupPropertyParent.Id             AS GoodsGroupPropertyId_Parent
          , Object_GoodsGroupPropertyParent.ObjectCode     AS GoodsGroupPropertyCode_Parent
          , Object_GoodsGroupPropertyParent.ValueData      AS GoodsGroupPropertyName_Parent
          --Аналитический классификатор - Ідентифікаційний номер тварини від якої отримано сировину
          , ObjectString_QualityINN.ValueData ::TVarChar AS QualityINN          
          --Аналитическая группа Направление
          , Object_GoodsGroupDirection.Id           AS GoodsGroupDirectionId 
          , Object_GoodsGroupDirection.ObjectCode   AS GoodsGroupDirectionCode
          , Object_GoodsGroupDirection.ValueData    AS GoodsGroupDirectionName
            
            
            
            
            
            
            
       FROM Object AS Object_Goods
           --Название сокращенное
           LEFT JOIN ObjectString AS ObjectString_Goods_ShortName
                                  ON ObjectString_Goods_ShortName.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_ShortName.DescId = zc_ObjectString_Goods_ShortName()
           --Полное название группы
           LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                  ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
           --Примечание
           LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                  ON ObjectString_Goods_Comment.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_Comment.DescId = zc_ObjectString_Goods_Comment()
           --Код товару згідно з УКТ ЗЕД
           LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                  ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
           --новый Код товару згідно з УКТ ЗЕД
           LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                  ON ObjectString_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
           --Название товара(русс.)
           LEFT JOIN ObjectString AS ObjectString_Goods_RUS
                                  ON ObjectString_Goods_RUS.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_RUS.DescId = zc_ObjectString_Goods_RUS()
           --Название товара(бухг.)
           LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                  ON ObjectString_Goods_BUH.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
           --Название товара(для приложения Scale)
           LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                  ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_Scale.DescId = zc_ObjectString_Goods_Scale()
           --Ознака імпортованого товару
           LEFT JOIN ObjectString AS ObjectString_Goods_TaxImport
                                  ON ObjectString_Goods_TaxImport.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_TaxImport.DescId = zc_ObjectString_Goods_TaxImport()
           --Послуги згідно з ДКПП
           LEFT JOIN ObjectString AS ObjectString_Goods_DKPP
                                  ON ObjectString_Goods_DKPP.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_DKPP.DescId = zc_ObjectString_Goods_DKPP()
           --Код виду діяльності сільск-господар товаровиробника 
           LEFT JOIN ObjectString AS ObjectString_Goods_TaxAction
                                  ON ObjectString_Goods_TaxAction.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_TaxAction.DescId = zc_ObjectString_Goods_TaxAction()         
           --дата с которой действует новый Код УКТ ЗЕД
           LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                ON ObjectDate_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                               AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()
           --
           LEFT JOIN ObjectDate AS ObjectDate_BUH
                                ON ObjectDate_BUH.ObjectId = Object_Goods.Id
                               AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()
           --Дата прихода от поставщика
           LEFT JOIN ObjectDate AS ObjectDate_In
                                ON ObjectDate_In.ObjectId = Object_Goods.Id
                               AND ObjectDate_In.DescId = zc_ObjectDate_Goods_In()           
           --Вес товара
           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                 ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
           --Вес втулки
           LEFT JOIN ObjectFloat AS ObjectFloat_WeightTare
                                 ON ObjectFloat_WeightTare.ObjectId = Object_Goods.Id
                                AND ObjectFloat_WeightTare.DescId   = zc_ObjectFloat_Goods_WeightTare()
           --Кол-во для веса
           LEFT JOIN ObjectFloat AS ObjectFloat_CountForWeight
                                 ON ObjectFloat_CountForWeight.ObjectId = Object_Goods.Id
                                AND ObjectFloat_CountForWeight.DescId = zc_ObjectFloat_Goods_CountForWeight()
           --Кол-во партий из рецептуры для замеса
           LEFT JOIN ObjectFloat AS ObjectFloat_CountReceipt
                                 ON ObjectFloat_CountReceipt.ObjectId = Object_Goods.Id 
                                AND ObjectFloat_CountReceipt.DescId = zc_ObjectFloat_Goods_CountReceipt()
           --Код АЛАН
           LEFT JOIN ObjectFloat AS ObjectFloat_ObjectCode_Basis
                                 ON ObjectFloat_ObjectCode_Basis.ObjectId = Object_Goods.Id
                                AND ObjectFloat_ObjectCode_Basis.DescId   = zc_ObjectFloat_ObjectCode_Basis()
           --Ирна
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                   ON ObjectBoolean_Guide_Irna.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()
           --Признак - ОС
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Asset
                                   ON ObjectBoolean_Goods_Asset.ObjectId = Object_Goods.Id 
                                  AND ObjectBoolean_Goods_Asset.DescId = zc_ObjectBoolean_Goods_Asset()
           --Партии поставщика в учете количеств
           LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                   ON ObjectBoolean_PartionCount.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
           --Партии поставщика в учете себестоимости
           LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                   ON ObjectBoolean_PartionSumm.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()
           --Показывать реальное назв.
           LEFT JOIN ObjectBoolean AS ObjectBoolean_NameOrig
                                   ON ObjectBoolean_NameOrig.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_NameOrig.DescId = zc_ObjectBoolean_Goods_NameOrig()
           --Проверка Количество голов
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_HeadCount
                                   ON ObjectBoolean_Goods_HeadCount.ObjectId = Object_Goods.Id 
                                  AND ObjectBoolean_Goods_HeadCount.DescId = zc_ObjectBoolean_Goods_HeadCount()
           --Учет по дате партии
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_PartionDate
                                   ON ObjectBoolean_Goods_PartionDate.ObjectId = Object_Goods.Id 
                                  AND ObjectBoolean_Goods_PartionDate.DescId = zc_ObjectBoolean_Goods_PartionDate()
           --Группы товаров
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
           --Группы товаров(статистика)
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                                ON ObjectLink_Goods_GoodsGroupStat.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
           LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_Goods_GoodsGroupStat.ChildObjectId
           --Группа товаров(аналитика)
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
           LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId
           --Торговые марки
           LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
           LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
           --Единицы измерения
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
           --Единицы измерения - Международное наименование
           LEFT JOIN ObjectString AS ObjectString_Measure_InternalName
                                  ON ObjectString_Measure_InternalName.ObjectId = Object_Measure.Id
                                 AND ObjectString_Measure_InternalName.DescId = zc_ObjectString_Measure_InternalName()           
           --Единицы измерения - Международный код
           LEFT JOIN ObjectString AS ObjectString_Measure_InternalCode
                                  ON ObjectString_Measure_InternalCode.ObjectId = Object_Measure.Id
                                 AND ObjectString_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()           
           --Статьи назначения
           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
           --Бизнесы
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                ON ObjectLink_Goods_Business.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
           LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Goods_Business.ChildObjectId
           --Виды топлива
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
           LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId
           --Признак товара
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
           LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId
           --Производственная площадка
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
           LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId
           --Поставщик
           LEFT JOIN ObjectLink AS ObjectLink_Goods_PartnerIn
                                ON ObjectLink_Goods_PartnerIn.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_PartnerIn.DescId = zc_ObjectLink_Goods_PartnerIn()
           LEFT JOIN Object AS Object_PartnerIn ON Object_PartnerIn.Id = ObjectLink_Goods_PartnerIn.ChildObjectId                      
           --Связь товаров с базовым
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsBasis
                                ON ObjectLink_Goods_GoodsBasis.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsBasis.DescId   = zc_ObjectLink_Goods_GoodsBasis()
           LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = ObjectLink_Goods_GoodsBasis.ChildObjectId
           --Связь товаров с главным
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsMain
                                ON ObjectLink_Goods_GoodsMain.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsMain.DescId   = zc_ObjectLink_Goods_GoodsMain()
           LEFT JOIN Object AS Object_Goods_main ON Object_Goods_main.Id = ObjectLink_Goods_GoodsMain.ChildObjectId
           --Основное средство (назначение ТМЦ)
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Asset
                                ON ObjectLink_Goods_Asset.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Asset.DescId = zc_ObjectLink_Goods_Asset()
           LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = ObjectLink_Goods_Asset.ChildObjectId
           --Основное средство (на каком оборудовании производится)
           LEFT JOIN ObjectLink AS ObjectLink_Goods_AssetProd
                                ON ObjectLink_Goods_AssetProd.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_AssetProd.DescId = zc_ObjectLink_Goods_AssetProd()
           LEFT JOIN Object AS Object_AssetProd ON Object_AssetProd.Id = ObjectLink_Goods_AssetProd.ChildObjectId           
           --Аналитический классификатор
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
           LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId
           --Аналитический классификатор -Группа
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                               AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
           LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId
           --Аналитический классификатор - Ідентифікаційний номер тварини від якої отримано сировину 
           LEFT JOIN ObjectString AS ObjectString_QualityINN
                                  ON ObjectString_QualityINN.ObjectId = Object_GoodsGroupProperty.Id
                                 And ObjectString_QualityINN.DescId = zc_ObjectString_GoodsGroupProperty_QualityINN()
           --Аналитическая группа Направление
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
           LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = ObjectLink_Goods_GoodsGroupDirection.ChildObjectId           


     WHERE Object_Goods.DescId = zc_Object_Goods();
     
ALTER TABLE _bi_Guide_Goods_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.05.25         *
*/

-- тест
-- SELECT * FROM _bi_Guide_Goods_View
