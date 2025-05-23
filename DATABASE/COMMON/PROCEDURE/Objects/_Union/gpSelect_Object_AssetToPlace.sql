-- Function: gpSelect_Object_AssetToPlace()

DROP FUNCTION IF EXISTS gpSelect_Object_AssetToPlace(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AssetToPlace(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DescName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , AssetGroupId Integer, AssetGroupCode Integer, AssetGroupName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , MakerId Integer, MakerCode Integer, MakerName TVarChar
             , Release TDateTime
             , InvNumber TVarChar, FullName TVarChar, SerialNumber TVarChar, PassportNumber TVarChar, Comment TVarChar
             , PeriodUse TFloat
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Asset());

     RETURN QUERY 
     SELECT 
           Object_Asset.Id             AS Id 
         , Object_Asset.ObjectCode     AS Code
         , Object_Asset.ValueData      AS Name
         , ObjectDesc.ItemName         AS DescName
         
         , 0 :: Integer                AS MeasureId
         , '' :: TVarChar              AS MeasureName

         , Asset_AssetGroup.Id         AS AssetGroupId
         , Asset_AssetGroup.ObjectCode AS AssetGroupCode
         , Asset_AssetGroup.ValueData  AS AssetGroupName
         
         , Object_Juridical.Id         AS JuridicalId
         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName

         , Object_Maker.Id             AS MakerId
         , Object_Maker.ObjectCode     AS MakerCode
         , Object_Maker.ValueData      AS MakerName
         
         , COALESCE (ObjectDate_Release.ValueData,CAST (CURRENT_DATE as TDateTime)) AS Release
         
         , ObjectString_InvNumber.ValueData      AS InvNumber
         , ObjectString_FullName.ValueData       AS FullName                                                                                                       
         , ObjectString_SerialNumber.ValueData   AS SerialNumber
         , ObjectString_PassportNumber.ValueData AS PassportNumber
         , ObjectString_Comment.ValueData        AS Comment

         , ObjectFloat_PeriodUse.ValueData       AS PeriodUse

         , Object_Asset.isErased                 AS isErased
         
     FROM Object AS Object_Asset
          LEFT JOIN ObjectLink AS ObjectLink_Asset_AssetGroup
                               ON ObjectLink_Asset_AssetGroup.ObjectId = Object_Asset.Id
                              AND ObjectLink_Asset_AssetGroup.DescId = zc_ObjectLink_Asset_AssetGroup()
          LEFT JOIN Object AS Asset_AssetGroup ON Asset_AssetGroup.Id = ObjectLink_Asset_AssetGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Asset_Juridical
                               ON ObjectLink_Asset_Juridical.ObjectId = Object_Asset.Id
                              AND ObjectLink_Asset_Juridical.DescId = zc_ObjectLink_Asset_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Asset_Juridical.ChildObjectId          

          LEFT JOIN ObjectLink AS ObjectLink_Asset_Maker
                               ON ObjectLink_Asset_Maker.ObjectId = Object_Asset.Id
                              AND ObjectLink_Asset_Maker.DescId = zc_ObjectLink_Asset_Maker()
          LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = ObjectLink_Asset_Maker.ChildObjectId
                    
          LEFT JOIN ObjectDate AS ObjectDate_Release
                               ON ObjectDate_Release.ObjectId = Object_Asset.Id
                              AND ObjectDate_Release.DescId = zc_ObjectDate_Asset_Release()
          
          LEFT JOIN ObjectString AS ObjectString_InvNumber
                                 ON ObjectString_InvNumber.ObjectId = Object_Asset.Id
                                AND ObjectString_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()

          LEFT JOIN ObjectString AS ObjectString_FullName
                                 ON ObjectString_FullName.ObjectId = Object_Asset.Id
                                AND ObjectString_FullName.DescId = zc_ObjectString_Asset_FullName()

          LEFT JOIN ObjectString AS ObjectString_SerialNumber
                                 ON ObjectString_SerialNumber.ObjectId = Object_Asset.Id
                                AND ObjectString_SerialNumber.DescId = zc_ObjectString_Asset_SerialNumber()

          LEFT JOIN ObjectString AS ObjectString_PassportNumber
                                 ON ObjectString_PassportNumber.ObjectId = Object_Asset.Id
                                AND ObjectString_PassportNumber.DescId = zc_ObjectString_Asset_PassportNumber()

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Asset.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Asset_Comment()  

          LEFT JOIN ObjectFloat AS ObjectFloat_PeriodUse
                                ON ObjectFloat_PeriodUse.ObjectId = Object_Asset.Id
                               AND ObjectFloat_PeriodUse.DescId = zc_ObjectFloat_Asset_PeriodUse()
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Asset.DescId

     WHERE Object_Asset.DescId = zc_Object_Asset() 

      UNION All
       SELECT Distinct
              Object_Goods.Id              AS Id
            , Object_Goods.ObjectCode      AS Code
            , Object_Goods.ValueData       AS Name
            , ObjectDesc.ItemName          AS DescName

            , Object_Measure.Id            AS MeasureId
            , Object_Measure.ValueData     AS MeasureName

            , Object_GoodsGroup.Id         AS AssetGroupId
            , Object_GoodsGroup.ObjectCode AS AssetGroupCode
            , Object_GoodsGroup.ValueData  AS AssetGroupName

            , 0    :: Integer  AS JuridicalId
            , NULL :: Integer  AS JuridicalCode
            , ''   :: TVarChar AS JuridicalName

            , 0    :: Integer  AS MakerId
            , NULL :: Integer  AS MakerCode
            , ''   :: TVarChar AS MakerName
         
            , CAST (CURRENT_DATE AS TDateTime) AS Release
         
            , '' :: TVarChar AS InvNumber
            , '' :: TVarChar AS FullName
            , '' :: TVarChar AS SerialNumber
            , '' :: TVarChar AS PassportNumber
            , '' :: TVarChar AS Comment

            , NULL :: TFloat AS PeriodUse

            , Object_Goods.isErased  AS isErased

       FROM Object AS Object_InfoMoney 
            INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney.Id  
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

            LEFT JOIN Object AS Object_Goods
                             ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                            AND Object_Goods.DescId = zc_Object_Goods()
                                  
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                 
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       WHERE Object_InfoMoney.ObjectCode IN (20301, 20302, 20303, 20304, 20305, 20306)

      UNION All
       SELECT 0    :: Integer AS Id
            , NULL :: Integer AS Code
            , '�������' ::TVarChar   AS Name
            , ''        ::TVarChar   AS DescName

            , 0          AS MeasureId
            , ''        ::TVarChar   AS MeasureName

            , 0    :: Integer        AS AssetGroupId
            , NULL :: Integer        AS AssetGroupCode
            , ''        ::TVarChar   AS AssetGroupName

            , 0    :: Integer  AS JuridicalId
            , NULL :: Integer  AS JuridicalCode
            , ''   :: TVarChar AS JuridicalName

            , 0    :: Integer  AS MakerId
            , NULL :: Integer  AS MakerCode
            , ''   :: TVarChar AS MakerName
         
            , CAST (CURRENT_DATE AS TDateTime) AS Release
         
            , '' :: TVarChar AS InvNumber
            , '' :: TVarChar AS FullName
            , '' :: TVarChar AS SerialNumber
            , '' :: TVarChar AS PassportNumber
            , '' :: TVarChar AS Comment

            , NULL :: TFloat AS PeriodUse

            , FALSE  AS isErased
       ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.11.16         *
*/

-- ����
--SELECT * FROM gpSelect_Object_AssetToPlace (zfCalc_UserAdmin())
