-- View: _bi_Guide_Goods_View

-- DROP VIEW IF EXISTS _bi_Guide_Goods_View;
--���������� ������
CREATE OR REPLACE VIEW _bi_Guide_Goods_View
AS
     SELECT 
            Object_Goods.Id                AS Id 
          , Object_Goods.ObjectCode        AS Code
          , Object_Goods.ValueData         AS Name
          , Object_Goods.isErased          AS isErased
          --�������� �����������
          , ObjectString_Goods_ShortName.ValueData :: TVarChar AS ShortName 
          --�������� ������(����.)
          , COALESCE (zfCalc_Text_replace (ObjectString_Goods_RUS.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_RUS
          --�������� ������(����.)
          , COALESCE (zfCalc_Text_replace (ObjectString_Goods_BUH.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_BUH
          --�������� ������(��� ���������� Scale)
          , COALESCE (zfCalc_Text_replace (ObjectString_Goods_Scale.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_Scale
          --������ �������� ������
          , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
          --��� ������ ����� � ��� ���
          , ObjectString_Goods_UKTZED.ValueData     ::TVarChar AS CodeUKTZED
          --����� ��� ������ ����� � ��� ���
          , ObjectString_Goods_UKTZED_new.ValueData ::TVarChar AS CodeUKTZED_new
          --���� � ������� ��������� ����� ��� ��� ���
          , ObjectDate_Goods_UKTZED_new.ValueData   ::TDateTime AS DateUKTZED_new
          --���� �� ������� ��������� �������� ������(����.)
          , ObjectDate_BUH.ValueData       :: TDateTime AS Date_BUH
          --���� ������� �� ����������
          , ObjectDate_In.ValueData       :: TDateTime AS InDate
          --������ ������������� ������
          , ObjectString_Goods_TaxImport.ValueData  ::TVarChar AS TaxImport
          --������� ����� � ����
          , ObjectString_Goods_DKPP.ValueData       ::TVarChar AS DKPP
          --��� ���� �������� �����-�������� ��������������� 
          , ObjectString_Goods_TaxAction.ValueData  ::TVarChar AS TaxAction
          --����������
          , ObjectString_Goods_Comment.ValueData    ::TVarChar AS Comment
          --��� ������
          , ObjectFloat_Weight.ValueData         ::TFloat AS Weight
          --��� ������
          , ObjectFloat_WeightTare.ValueData     ::TFloat AS WeightTare
          --���-�� ��� ����
          , ObjectFloat_CountForWeight.ValueData ::TFloat AS CountForWeight
          ----���-�� ������ �� ��������� ��� ������
          , ObjectFloat_CountReceipt.ValueData   ::TFloat AS CountReceipt
          --��� ����
          , ObjectFloat_ObjectCode_Basis.ValueData ::Integer AS BasisCode

           --����
          , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)       :: Boolean AS isIrna
          --������� - ��
          , COALESCE (ObjectBoolean_Goods_Asset.ValueData, FALSE)      :: Boolean AS isAsset
          --������ ���������� � ����� ���������
          , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)   :: Boolean AS isPartionCount
          --������ ���������� � ����� �������������
          , COALESCE (ObjectBoolean_PartionSumm.ValueData, TRUE)     :: Boolean AS isPartionSumm          
          --���������� �������� ����.
          , COALESCE (ObjectBoolean_NameOrig.ValueData, FALSE)         :: Boolean AS isNameOrig
          --���� �� ���� ������
          , COALESCE (ObjectBoolean_Goods_PartionDate.ValueData, FALSE):: Boolean AS isPartionDate
          --�������� ���������� �����
          , COALESCE (ObjectBoolean_Goods_HeadCount.ValueData, FALSE)  :: Boolean AS isHeadCount

          --������ �������
          , Object_GoodsGroup.Id                    AS GoodsGroupId 
          , Object_GoodsGroup.ObjectCode            AS GoodsGroupCode
          , Object_GoodsGroup.ValueData             AS GoodsGroupName
          --������ �������(����������)
          , Object_GoodsGroupStat.Id            AS GroupStatId 
          , Object_GoodsGroupStat.ObjectCode    AS GroupStatCode
          , Object_GoodsGroupStat.ValueData     AS GroupStatName
          --������ �������(���������)
          , Object_GoodsGroupAnalyst.Id          AS GoodsGroupAnalystId
          , Object_GoodsGroupAnalyst.ObjectCode  AS GoodsGroupAnalysCode
          , Object_GoodsGroupAnalyst.ValueData   AS GoodsGroupAnalystName          
          --�������� �����
          , Object_TradeMark.Id                 AS TradeMarkId
          , Object_TradeMark.ObjectCode         AS TradeMarkCode
          , Object_TradeMark.ValueData          AS TradeMarkName
          --������� ���������
          , Object_Measure.Id               AS MeasureId
          , Object_Measure.ObjectCode       AS MeasureCode
          , Object_Measure.ValueData        AS MeasureName 
          --������� ��������� - ������������� ������������
          , ObjectString_Measure_InternalName.ValueData ::TVarChar AS InternalName
          --������� ��������� - ������������� ��� 
          , ObjectString_Measure_InternalCode.ValueData ::TVarChar AS InternalCode
            
          --������ ����������
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyGroupId
          , Object_InfoMoney_View.InfoMoneyGroupCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationId
          , Object_InfoMoney_View.InfoMoneyDestinationCode
          , Object_InfoMoney_View.InfoMoneyDestinationName
          --�������
          , Object_Business.Id           AS BusinessId
          , Object_Business.ObjectCode   AS BusinessCode
          , Object_Business.ValueData    AS BusinessName
          --���� �������
          , Object_Fuel.Id               AS FuelId
          , Object_Fuel.ObjectCode       AS FuelCode
          , Object_Fuel.ValueData        AS FuelName
          --������� ������
          , Object_GoodsTag.Id           AS GoodsTagId
          , Object_GoodsTag.ObjectCode   AS GoodsTagCode
          , Object_GoodsTag.ValueData    AS GoodsTagName
          --���������������� ��������
          , Object_GoodsPlatform.Id          AS GoodsPlatformId
          , Object_GoodsPlatform.ObjectCode  AS GoodsPlatformCode
          , Object_GoodsPlatform.ValueData   AS GoodsPlatformName
          --���������
          , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInId
          , Object_PartnerIn.ObjectCode   :: TVarChar  AS PartnerInCode
          , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInName
          --����� ������� � �������
          , Object_Goods_basis.Id             AS GoodsId_basis
          , Object_Goods_basis.ObjectCode     AS GoodsCode_basis
          , Object_Goods_basis.ValueData      AS GoodsName_basis
          --����� ������� � �������
          , Object_Goods_main.Id              AS GoodsId_main
          , Object_Goods_main.ObjectCode      AS GoodsCode_main
          , Object_Goods_main.ValueData       AS GoodsName_main
          --�������� �������� (���������� ���) 
          , Object_Asset.Id          AS AssetId
          , Object_Asset.ObjectCode  AS AssetCode
          , Object_Asset.ValueData   AS AssetName
          --�������� �������� (�� ����� ������������ ������������) 
          , Object_AssetProd.Id             AS AssetProdId
          , Object_AssetProd.ObjectCode     AS AssetProdCode
          , Object_AssetProd.ValueData      AS AssetProdName
          --������������� �������������
          , Object_GoodsGroupProperty.Id             AS GoodsGroupPropertyId
          , Object_GoodsGroupProperty.ObjectCode     AS GoodsGroupPropertyCode
          , Object_GoodsGroupProperty.ValueData      AS GoodsGroupPropertyName
          --������������� ������������� - ������
          , Object_GoodsGroupPropertyParent.Id             AS GoodsGroupPropertyId_Parent
          , Object_GoodsGroupPropertyParent.ObjectCode     AS GoodsGroupPropertyCode_Parent
          , Object_GoodsGroupPropertyParent.ValueData      AS GoodsGroupPropertyName_Parent
          --������������� ������������� - ���������������� ����� ������� �� ��� �������� ��������
          , ObjectString_QualityINN.ValueData ::TVarChar AS QualityINN          
          --������������� ������ �����������
          , Object_GoodsGroupDirection.Id           AS GoodsGroupDirectionId 
          , Object_GoodsGroupDirection.ObjectCode   AS GoodsGroupDirectionCode
          , Object_GoodsGroupDirection.ValueData    AS GoodsGroupDirectionName
            
            
            
            
            
            
            
       FROM Object AS Object_Goods
           --�������� �����������
           LEFT JOIN ObjectString AS ObjectString_Goods_ShortName
                                  ON ObjectString_Goods_ShortName.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_ShortName.DescId = zc_ObjectString_Goods_ShortName()
           --������ �������� ������
           LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                  ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
           --����������
           LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                  ON ObjectString_Goods_Comment.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_Comment.DescId = zc_ObjectString_Goods_Comment()
           --��� ������ ����� � ��� ���
           LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                  ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
           --����� ��� ������ ����� � ��� ���
           LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                  ON ObjectString_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
           --�������� ������(����.)
           LEFT JOIN ObjectString AS ObjectString_Goods_RUS
                                  ON ObjectString_Goods_RUS.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_RUS.DescId = zc_ObjectString_Goods_RUS()
           --�������� ������(����.)
           LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                  ON ObjectString_Goods_BUH.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
           --�������� ������(��� ���������� Scale)
           LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                  ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_Scale.DescId = zc_ObjectString_Goods_Scale()
           --������ ������������� ������
           LEFT JOIN ObjectString AS ObjectString_Goods_TaxImport
                                  ON ObjectString_Goods_TaxImport.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_TaxImport.DescId = zc_ObjectString_Goods_TaxImport()
           --������� ����� � ����
           LEFT JOIN ObjectString AS ObjectString_Goods_DKPP
                                  ON ObjectString_Goods_DKPP.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_DKPP.DescId = zc_ObjectString_Goods_DKPP()
           --��� ���� �������� �����-�������� ��������������� 
           LEFT JOIN ObjectString AS ObjectString_Goods_TaxAction
                                  ON ObjectString_Goods_TaxAction.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_TaxAction.DescId = zc_ObjectString_Goods_TaxAction()         
           --���� � ������� ��������� ����� ��� ��� ���
           LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                ON ObjectDate_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                               AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()
           --
           LEFT JOIN ObjectDate AS ObjectDate_BUH
                                ON ObjectDate_BUH.ObjectId = Object_Goods.Id
                               AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()
           --���� ������� �� ����������
           LEFT JOIN ObjectDate AS ObjectDate_In
                                ON ObjectDate_In.ObjectId = Object_Goods.Id
                               AND ObjectDate_In.DescId = zc_ObjectDate_Goods_In()           
           --��� ������
           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                 ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
           --��� ������
           LEFT JOIN ObjectFloat AS ObjectFloat_WeightTare
                                 ON ObjectFloat_WeightTare.ObjectId = Object_Goods.Id
                                AND ObjectFloat_WeightTare.DescId   = zc_ObjectFloat_Goods_WeightTare()
           --���-�� ��� ����
           LEFT JOIN ObjectFloat AS ObjectFloat_CountForWeight
                                 ON ObjectFloat_CountForWeight.ObjectId = Object_Goods.Id
                                AND ObjectFloat_CountForWeight.DescId = zc_ObjectFloat_Goods_CountForWeight()
           --���-�� ������ �� ��������� ��� ������
           LEFT JOIN ObjectFloat AS ObjectFloat_CountReceipt
                                 ON ObjectFloat_CountReceipt.ObjectId = Object_Goods.Id 
                                AND ObjectFloat_CountReceipt.DescId = zc_ObjectFloat_Goods_CountReceipt()
           --��� ����
           LEFT JOIN ObjectFloat AS ObjectFloat_ObjectCode_Basis
                                 ON ObjectFloat_ObjectCode_Basis.ObjectId = Object_Goods.Id
                                AND ObjectFloat_ObjectCode_Basis.DescId   = zc_ObjectFloat_ObjectCode_Basis()
           --����
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                   ON ObjectBoolean_Guide_Irna.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()
           --������� - ��
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Asset
                                   ON ObjectBoolean_Goods_Asset.ObjectId = Object_Goods.Id 
                                  AND ObjectBoolean_Goods_Asset.DescId = zc_ObjectBoolean_Goods_Asset()
           --������ ���������� � ����� ���������
           LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                   ON ObjectBoolean_PartionCount.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
           --������ ���������� � ����� �������������
           LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                   ON ObjectBoolean_PartionSumm.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()
           --���������� �������� ����.
           LEFT JOIN ObjectBoolean AS ObjectBoolean_NameOrig
                                   ON ObjectBoolean_NameOrig.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_NameOrig.DescId = zc_ObjectBoolean_Goods_NameOrig()
           --�������� ���������� �����
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_HeadCount
                                   ON ObjectBoolean_Goods_HeadCount.ObjectId = Object_Goods.Id 
                                  AND ObjectBoolean_Goods_HeadCount.DescId = zc_ObjectBoolean_Goods_HeadCount()
           --���� �� ���� ������
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_PartionDate
                                   ON ObjectBoolean_Goods_PartionDate.ObjectId = Object_Goods.Id 
                                  AND ObjectBoolean_Goods_PartionDate.DescId = zc_ObjectBoolean_Goods_PartionDate()
           --������ �������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
           --������ �������(����������)
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                                ON ObjectLink_Goods_GoodsGroupStat.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
           LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_Goods_GoodsGroupStat.ChildObjectId
           --������ �������(���������)
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
           LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId
           --�������� �����
           LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
           LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
           --������� ���������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
           --������� ��������� - ������������� ������������
           LEFT JOIN ObjectString AS ObjectString_Measure_InternalName
                                  ON ObjectString_Measure_InternalName.ObjectId = Object_Measure.Id
                                 AND ObjectString_Measure_InternalName.DescId = zc_ObjectString_Measure_InternalName()           
           --������� ��������� - ������������� ���
           LEFT JOIN ObjectString AS ObjectString_Measure_InternalCode
                                  ON ObjectString_Measure_InternalCode.ObjectId = Object_Measure.Id
                                 AND ObjectString_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()           
           --������ ����������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
           --�������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                ON ObjectLink_Goods_Business.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
           LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Goods_Business.ChildObjectId
           --���� �������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
           LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId
           --������� ������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
           LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId
           --���������������� ��������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
           LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId
           --���������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_PartnerIn
                                ON ObjectLink_Goods_PartnerIn.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_PartnerIn.DescId = zc_ObjectLink_Goods_PartnerIn()
           LEFT JOIN Object AS Object_PartnerIn ON Object_PartnerIn.Id = ObjectLink_Goods_PartnerIn.ChildObjectId                      
           --����� ������� � �������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsBasis
                                ON ObjectLink_Goods_GoodsBasis.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsBasis.DescId   = zc_ObjectLink_Goods_GoodsBasis()
           LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = ObjectLink_Goods_GoodsBasis.ChildObjectId
           --����� ������� � �������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsMain
                                ON ObjectLink_Goods_GoodsMain.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsMain.DescId   = zc_ObjectLink_Goods_GoodsMain()
           LEFT JOIN Object AS Object_Goods_main ON Object_Goods_main.Id = ObjectLink_Goods_GoodsMain.ChildObjectId
           --�������� �������� (���������� ���)
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Asset
                                ON ObjectLink_Goods_Asset.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Asset.DescId = zc_ObjectLink_Goods_Asset()
           LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = ObjectLink_Goods_Asset.ChildObjectId
           --�������� �������� (�� ����� ������������ ������������)
           LEFT JOIN ObjectLink AS ObjectLink_Goods_AssetProd
                                ON ObjectLink_Goods_AssetProd.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_AssetProd.DescId = zc_ObjectLink_Goods_AssetProd()
           LEFT JOIN Object AS Object_AssetProd ON Object_AssetProd.Id = ObjectLink_Goods_AssetProd.ChildObjectId           
           --������������� �������������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
           LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId
           --������������� ������������� -������
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                               AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
           LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId
           --������������� ������������� - ���������������� ����� ������� �� ��� �������� �������� 
           LEFT JOIN ObjectString AS ObjectString_QualityINN
                                  ON ObjectString_QualityINN.ObjectId = Object_GoodsGroupProperty.Id
                                 And ObjectString_QualityINN.DescId = zc_ObjectString_GoodsGroupProperty_QualityINN()
           --������������� ������ �����������
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
           LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = ObjectLink_Goods_GoodsGroupDirection.ChildObjectId           


     WHERE Object_Goods.DescId = zc_Object_Goods();
     
ALTER TABLE _bi_Guide_Goods_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.05.25         *
*/

-- ����
-- SELECT * FROM _bi_Guide_Goods_View
