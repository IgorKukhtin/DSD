-- View: _bi_Guide_GoodsGroup_View

-- DROP VIEW IF EXISTS _bi_Guide_GoodsGroup_View;
--���������� ������ �������
CREATE OR REPLACE VIEW _bi_Guide_GoodsGroup_View
AS
     SELECT 
            Object_GoodsGroup.Id                AS Id 
          , Object_GoodsGroup.ObjectCode        AS Code
          , Object_GoodsGroup.ValueData         AS Name
          , Object_GoodsGroup.isErased          AS isErased
          --�������� ������ �������
          , Object_Parent.Id                    AS ParentId 
          , Object_Parent.ObjectCode            AS ParentCode
          , Object_Parent.ValueData             AS ParentName
          --������ �������(����������)
          , Object_GoodsGroupStat.Id            AS GroupStatId 
          , Object_GoodsGroupStat.ObjectCode    AS GroupStatCode
          , Object_GoodsGroupStat.ValueData     AS GroupStatName          
          --�������� �����
          , Object_TradeMark.Id                 AS TradeMarkId
          , Object_TradeMark.ObjectCode         AS TradeMarkCode
          , Object_TradeMark.ValueData          AS TradeMarkName
          --������� ������
          , Object_GoodsTag.Id                  AS GoodsTagId
          , Object_GoodsTag.ObjectCode          AS GoodsTagCode
          , Object_GoodsTag.ValueData           AS GoodsTagName
          --������ �������(���������)          
          , Object_GoodsGroupAnalyst.Id         AS GoodsGroupAnalystId
          , Object_GoodsGroupAnalyst.ObjectCode AS GoodsGroupAnalystCode
          , Object_GoodsGroupAnalyst.ValueData  AS GoodsGroupAnalystName
          --���������������� ��������
          , Object_GoodsPlatform.Id             AS GoodsPlatformId
          , Object_GoodsPlatform.ObjectCode     AS GoodsPlatformCode
          , Object_GoodsPlatform.ValueData      AS GoodsPlatformName
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
          --��� ������ ����� � ��� ���
          , ObjectString_GoodsGroup_UKTZED.ValueData     ::TVarChar  AS CodeUKTZED
          --����� ��� ������ ����� � ��� ���
          , ObjectString_GoodsGroup_UKTZED_new.ValueData ::TVarChar  AS CodeUKTZED_new
          --���� � ������� ��������� ����� ��� ��� ���
          , ObjectDate_GoodsGroup_UKTZED_new.ValueData   ::TDateTime AS DateUKTZED_new          
          --������ ������������� ������
          , ObjectString_GoodsGroup_TaxImport.ValueData  :: TVarChar AS TaxImport
          --������� ����� � ����
          , ObjectString_GoodsGroup_DKPP.ValueData       :: TVarChar AS DKPP
          --��� ���� �������� �����-�������� ���������������
          , ObjectString_GoodsGroup_TaxAction.ValueData  :: TVarChar AS TaxAction
          --������� - ��
          , COALESCE(ObjectBoolean_GoodsGroup_Asset.ValueData, FALSE) ::Boolean AS isAsset
          
       FROM Object AS Object_GoodsGroup
           --�������� ������ �������
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                ON ObjectLink_GoodsGroup_Parent.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
           LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroup_Parent.ChildObjectId
           --������ �������(����������)
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsGroupStat
                                ON ObjectLink_GoodsGroup_GoodsGroupStat.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_GoodsGroupStat.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupStat()
           LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_GoodsGroup_GoodsGroupStat.ChildObjectId
           --�������� �����
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_TradeMark
                                ON ObjectLink_GoodsGroup_TradeMark.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_TradeMark.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
           LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_GoodsGroup_TradeMark.ChildObjectId
           --������� ������
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsTag
                                ON ObjectLink_GoodsGroup_GoodsTag.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_GoodsTag.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
           LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_GoodsGroup_GoodsTag.ChildObjectId
           --������ �������(���������)
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsGroupAnalyst
                                ON ObjectLink_GoodsGroup_GoodsGroupAnalyst.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_GoodsGroupAnalyst.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
           LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_GoodsGroup_GoodsGroupAnalyst.ChildObjectId
           --���������������� ��������
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsPlatform
                                ON ObjectLink_GoodsGroup_GoodsPlatform.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup_GoodsPlatform.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
           LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_GoodsGroup_GoodsPlatform.ChildObjectId
           --������ ����������
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_InfoMoney
                                ON ObjectLink_GoodsGroup_InfoMoney.ObjectId = Object_GoodsGroup.Id 
                               AND ObjectLink_GoodsGroup_InfoMoney.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_GoodsGroup_InfoMoney.ChildObjectId
           --������� - ��
           LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsGroup_Asset
                                   ON ObjectBoolean_GoodsGroup_Asset.ObjectId = Object_GoodsGroup.Id 
                                  AND ObjectBoolean_GoodsGroup_Asset.DescId = zc_ObjectBoolean_GoodsGroup_Asset()
           --��� ������ ����� � ��� ���
           LEFT JOIN ObjectString AS ObjectString_GoodsGroup_UKTZED
                                  ON ObjectString_GoodsGroup_UKTZED.ObjectId = Object_GoodsGroup.Id 
                                 AND ObjectString_GoodsGroup_UKTZED.DescId = zc_ObjectString_GoodsGroup_UKTZED()
           --����� ��� ������ ����� � ��� ���
           LEFT JOIN ObjectString AS ObjectString_GoodsGroup_UKTZED_new
                                  ON ObjectString_GoodsGroup_UKTZED_new.ObjectId = Object_GoodsGroup.Id
                                 AND ObjectString_GoodsGroup_UKTZED_new.DescId = zc_ObjectString_GoodsGroup_UKTZED_new() 
           --���� � ������� ��������� ����� ��� ��� ���                      
           LEFT JOIN ObjectDate AS ObjectDate_GoodsGroup_UKTZED_new
                                ON ObjectDate_GoodsGroup_UKTZED_new.ObjectId = Object_GoodsGroup.Id
                               AND ObjectDate_GoodsGroup_UKTZED_new.DescId = zc_ObjectDate_GoodsGroup_UKTZED_new()
           --������ ������������� ������
           LEFT JOIN ObjectString AS ObjectString_GoodsGroup_TaxImport
                                  ON ObjectString_GoodsGroup_TaxImport.ObjectId = Object_GoodsGroup.Id
                                 AND ObjectString_GoodsGroup_TaxImport.DescId = zc_ObjectString_GoodsGroup_TaxImport()
           --������� ����� � ����
           LEFT JOIN ObjectString AS ObjectString_GoodsGroup_DKPP
                                  ON ObjectString_GoodsGroup_DKPP.ObjectId = Object_GoodsGroup.Id
                                 AND ObjectString_GoodsGroup_DKPP.DescId = zc_ObjectString_GoodsGroup_DKPP()
           --��� ���� �������� �����-�������� ���������������
           LEFT JOIN ObjectString AS ObjectString_GoodsGroup_TaxAction
                                  ON ObjectString_GoodsGroup_TaxAction.ObjectId = Object_GoodsGroup.Id
                                 AND ObjectString_GoodsGroup_TaxAction.DescId = zc_ObjectString_GoodsGroup_TaxAction()
                                 
     WHERE Object_GoodsGroup.DescId = zc_Object_GoodsGroup();
     
ALTER TABLE _bi_Guide_GoodsGroup_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.05.25         *
*/

-- ����
-- SELECT * FROM _bi_Guide_GoodsGroup_View
