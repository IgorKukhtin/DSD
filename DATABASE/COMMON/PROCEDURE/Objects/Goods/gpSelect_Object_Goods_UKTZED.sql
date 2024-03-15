-- Function: gpSelect_Object_Goods_UKTZED()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_UKTZED (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Goods_UKTZED (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_UKTZED(
    IN inShowAll     Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CodeUKTZED TVarChar, CodeUKTZED_Calc TVarChar, CodeUKTZED_group TVarChar
             , CodeUKTZED_new TVarChar, DateUKTZED_new TDateTime
             , CodeUKTZED_group_new TVarChar, CodeUKTZED_Calc_new TVarChar

             , TaxImport TVarChar, TaxImport_Calc TVarChar, TaxImport_Group TVarChar
             , DKPP TVarChar, DKPP_Calc TVarChar, DKPP_Group TVarChar
             , TaxAction TVarChar, TaxAction_Calc TVarChar, TaxAction_Group TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GroupStatId Integer, GroupStatName TVarChar
             , GoodsGroupAnalystId Integer, GoodsGroupAnalystName TVarChar
             , GoodsGroupPropertyId Integer, GoodsGroupPropertyName TVarChar, GoodsGroupPropertyId_Parent Integer, GoodsGroupPropertyName_Parent TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyId Integer
             , BusinessName TVarChar
             , FuelName TVarChar
             , Weight TFloat, isPartionCount Boolean, isPartionSumm Boolean, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbAccessKeyRight Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_Goods());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - есть ли ограничения
     -- vbAccessKeyRight:= NOT zfCalc_AccessKey_GuideAll (vbUserId) AND EXISTS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId);

     -- Результат
     RETURN QUERY
       WITH tmpIsErased  AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
            -- старая Схема
          , tmpUKTZED    AS (SELECT Object.Id AS GoodsGroupId, lfGet_Object_GoodsGroup_CodeUKTZED (Object.Id) AS CodeUKTZED FROM Object WHERE Object.DescId = zc_Object_GoodsGroup())
            -- новая Схема
          , tmpUKTZED_new AS (SELECT Object.Id AS GoodsGroupId, lfGet.CodeUKTZED_new AS CodeUKTZED, lfGet.DateUKTZED_new FROM Object CROSS JOIN lfGet_Object_GoodsGroup_CodeUKTZED_new (Object.Id) AS lfGet WHERE Object.DescId = zc_Object_GoodsGroup())
            --
          , tmpTaxImport AS (SELECT Object.Id AS GoodsGroupId, lfGet_Object_GoodsGroup_TaxImport  (Object.Id) AS TaxImport  FROM Object WHERE Object.DescId = zc_Object_GoodsGroup())
          , tmpDKPP      AS (SELECT Object.Id AS GoodsGroupId, lfGet_Object_GoodsGroup_DKPP       (Object.Id) AS DKPP       FROM Object WHERE Object.DescId = zc_Object_GoodsGroup())
          , tmpTaxAction AS (SELECT Object.Id AS GoodsGroupId, lfGet_Object_GoodsGroup_TaxAction  (Object.Id) AS TaxAction  FROM Object WHERE Object.DescId = zc_Object_GoodsGroup())

       -- результат
       SELECT Object_Goods.Id             AS Id
            , Object_Goods.ObjectCode     AS Code
            , Object_Goods.ValueData      AS Name
            , ObjectString_Goods_UKTZED.ValueData AS CodeUKTZED
            , CASE WHEN ObjectString_Goods_UKTZED.ValueData <> '' THEN ObjectString_Goods_UKTZED.ValueData ELSE tmpUKTZED.CodeUKTZED END :: TVarChar AS CodeUKTZED_Calc
            , tmpUKTZED.CodeUKTZED        AS CodeUKTZED_group

            , ObjectString_Goods_UKTZED_new.ValueData ::TVarChar  AS CodeUKTZED_new
            , CASE WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' THEN ObjectDate_Goods_UKTZED_new.ValueData ELSE tmpUKTZED_new.DateUKTZED_new END :: TDateTime AS DateUKTZED_new
            , tmpUKTZED_new.CodeUKTZED    AS CodeUKTZED_group_new
            , CASE WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' THEN ObjectString_Goods_UKTZED_new.ValueData ELSE tmpUKTZED_new.CodeUKTZED END :: TVarChar AS CodeUKTZED_Calc_new


            , ObjectString_Goods_TaxImport.ValueData AS TaxImport
            , CASE WHEN ObjectString_Goods_TaxImport.ValueData <> '' THEN ObjectString_Goods_TaxImport.ValueData ELSE tmpTaxImport.TaxImport END :: TVarChar AS TaxImport_Calc
            , tmpTaxImport.TaxImport      AS TaxImport_Group

            , ObjectString_Goods_DKPP.ValueData AS DKPP
            , CASE WHEN ObjectString_Goods_DKPP.ValueData <> '' THEN ObjectString_Goods_DKPP.ValueData ELSE tmpDKPP.DKPP END :: TVarChar AS DKPP_Calc
            , tmpDKPP.DKPP                AS DKPP_Group

            , ObjectString_Goods_TaxAction.ValueData AS TaxAction
            , CASE WHEN ObjectString_Goods_TaxAction.ValueData <> '' THEN ObjectString_Goods_TaxAction.ValueData ELSE tmpTaxAction.TaxAction END :: TVarChar AS TaxAction_Calc
            , tmpTaxAction.TaxAction      AS TaxAction_Group

            , Object_GoodsGroup.Id        AS GoodsGroupId
            , Object_GoodsGroup.ValueData AS GoodsGroupName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

            , Object_GoodsGroupStat.Id        AS GroupStatId
            , Object_GoodsGroupStat.ValueData AS GroupStatName

            , Object_GoodsGroupAnalyst.Id        AS GoodsGroupAnalystId
            , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName

            , Object_GoodsGroupProperty.Id              AS GoodsGroupPropertyId
            , Object_GoodsGroupProperty.ValueData       AS GoodsGroupPropertyName
            , Object_GoodsGroupPropertyParent.Id        AS GoodsGroupPropertyId_Parent
            , Object_GoodsGroupPropertyParent.ValueData AS GoodsGroupPropertyName_Parent

            , Object_Measure.Id               AS MeasureId
            , Object_Measure.ValueData        AS MeasureName

            , Object_TradeMark.ValueData      AS TradeMarkName
            , Object_GoodsTag.ValueData       AS GoodsTagName
            , Object_GoodsPlatform.ValueData  AS GoodsPlatformName

            , Object_InfoMoney_View.InfoMoneyCode
            , Object_InfoMoney_View.InfoMoneyGroupName
            , Object_InfoMoney_View.InfoMoneyDestinationName
            , Object_InfoMoney_View.InfoMoneyName
            , Object_InfoMoney_View.InfoMoneyId

            , Object_Business.ValueData  AS BusinessName

            , Object_Fuel.ValueData    AS FuelName

            , ObjectFloat_Weight.ValueData AS Weight
            , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE) AS isPartionCount
            , COALESCE (ObjectBoolean_PartionSumm.ValueData, TRUE)   AS isPartionSumm
            , Object_Goods.isErased       AS isErased

       FROM (SELECT Object_Goods.*
             FROM Object AS Object_Goods
	         INNER JOIN tmpIsErased on tmpIsErased.isErased= Object_Goods.isErased
             WHERE Object_Goods.DescId = zc_Object_Goods()

            ) AS Object_Goods
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                                  ON ObjectLink_Goods_GoodsGroupStat.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
             LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_Goods_GoodsGroupStat.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                  ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
             LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                  ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
             LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                  ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
             LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                     ON ObjectBoolean_PartionCount.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                     ON ObjectBoolean_PartionSumm.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                    ON ObjectLink_Goods_Business.ObjectId = Object_Goods.Id
                   AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
             LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Goods_Business.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                  ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
             LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                    ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
             LEFT JOIN tmpUKTZED ON tmpUKTZED.GoodsGroupId = ObjectLink_Goods_GoodsGroup.ChildObjectId
             LEFT JOIN tmpuktzed_new ON tmpuktzed_new.GoodsGroupId = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                    ON ObjectString_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
             LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                  ON ObjectDate_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                 AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

             LEFT JOIN ObjectString AS ObjectString_Goods_TaxImport
                                    ON ObjectString_Goods_TaxImport.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_TaxImport.DescId = zc_ObjectString_Goods_TaxImport()
             LEFT JOIN tmpTaxImport ON tmpTaxImport.GoodsGroupId = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_DKPP
                                    ON ObjectString_Goods_DKPP.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_DKPP.DescId = zc_ObjectString_Goods_DKPP()
             LEFT JOIN tmpDKPP ON tmpDKPP.GoodsGroupId = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_TaxAction
                                    ON ObjectString_Goods_TaxAction.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_TaxAction.DescId = zc_ObjectString_Goods_TaxAction()
             LEFT JOIN tmpTaxAction ON tmpTaxAction.GoodsGroupId = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                  ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
             LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                  ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                 AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
             LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId

       WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20500(), zc_Enum_InfoMoneyDestination_30200(), zc_Enum_InfoMoneyDestination_30300())
          OR Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101()
                                                 , zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_30102()
                                                 , zc_Enum_InfoMoney_30103()
                                                  )
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 
 09.11.23         *
 06.01.17         * add CodeUKTZED
*/

-- тест
-- SELECT * FROM gpSelect_Object_Goods_UKTZED (FALSE, inSession := zfCalc_UserAdmin())
