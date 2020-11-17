-- Function: gpSelect_Object_AssetChoice()

DROP FUNCTION IF EXISTS gpSelect_Object_AssetChoice(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AssetChoice(
    IN inUnitId      Integer ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, ItemName TVarChar, Id Integer, Code Integer, Name TVarChar
             , AssetGroupId Integer, AssetGroupCode Integer, AssetGroupName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , MakerId Integer, MakerCode Integer, MakerName TVarChar
             , CarId Integer, CarCode Integer, CarName TVarChar, CarModelName TVarChar
             , AssetTypeId Integer, AssetTypeCode Integer, AssetTypeName TVarChar
             , Release TDateTime
             , InvNumber TVarChar, FullName TVarChar, SerialNumber TVarChar, PassportNumber TVarChar, Comment TVarChar
             , PeriodUse TFloat, Production TFloat, KW TFloat
             , AmountRemains TFloat
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Asset());

     RETURN QUERY
     WITH 
     tmpAsset AS (SELECT Object_Asset.Id     AS AssetId
                       , Object_Asset.DescId AS DescId
                  FROM Object AS Object_Asset
                  WHERE Object_Asset.DescId IN (zc_Object_Asset(), zc_Object_Goods())
                  --AND Object_Asset.isErased = FALSE
                 )

   , tmpRemains AS (SELECT Container.Id           AS ContainerId
                         , Container.DescId       AS ContainerDescId
                         , tmpAsset.AssetId       AS AssetId
                         , SUM (Container.Amount) AS Amount
                    FROM tmpAsset
                         INNER JOIN Container ON Container.ObjectId = tmpAsset.AssetId
                                             AND Container.DescId   IN (zc_Container_Count(), zc_Container_CountAsset())
                                             AND COALESCE (Container.Amount, 0) <> 0
                         INNER JOIN ContainerLinkObject AS CLO_Unit
                                                        ON CLO_Unit.ContainerId = Container.Id
                                                       AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                       AND (CLO_Unit.ObjectId = inUnitId OR inUnitId = 0)
                         LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = Container.Id
                                                                     AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                         LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                         LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                    WHERE (Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAsset.DescId = zc_Object_Asset())
                    GROUP BY Container.Id
                           , Container.DescId
                           , tmpAsset.AssetId
                   )

    SELECT tmpRemains.ContainerId :: Integer
         , ContainerDesc.ItemName
         , Object_Asset.Id             AS Id 
         , Object_Asset.ObjectCode     AS Code
         , Object_Asset.ValueData      AS Name
         
         , Asset_AssetGroup.Id         AS AssetGroupId
         , Asset_AssetGroup.ObjectCode AS AssetGroupCode
         , Asset_AssetGroup.ValueData  AS AssetGroupName
         
         , Object_Juridical.Id         AS JuridicalId
         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName

         , Object_Maker.Id             AS MakerId
         , Object_Maker.ObjectCode     AS MakerCode
         , Object_Maker.ValueData      AS MakerName

         , Object_Car.Id               AS CarId
         , Object_Car.ObjectCode       AS CarCode
         , Object_Car.ValueData        AS CarName
         , Object_CarModel.ValueData   AS CarModelName

         , Object_AssetType.Id             AS AssetTypeId
         , Object_AssetType.ObjectCode     AS AssetTypeCode
         , Object_AssetType.ValueData      AS AssetTypeName

         , COALESCE (ObjectDate_Release.ValueData, CAST (CURRENT_DATE as TDateTime)) AS Release
         
         , ObjectString_InvNumber.ValueData      AS InvNumber
         , ObjectString_FullName.ValueData       AS FullName                                                                                                       
         , ObjectString_SerialNumber.ValueData   AS SerialNumber
         , ObjectString_PassportNumber.ValueData AS PassportNumber
         , ObjectString_Comment.ValueData        AS Comment

         , ObjectFloat_PeriodUse.ValueData               :: TFloat AS PeriodUse
         , COALESCE (ObjectFloat_Production.ValueData,0) :: TFloat AS Production
         , COALESCE (ObjectFloat_KW.ValueData,0)         :: TFloat AS KW

         , tmpRemains.Amount      :: TFloat AS AmountRemains
         , Object_Asset.isErased            AS isErased
         
     FROM tmpRemains
          LEFT JOIN ContainerDesc ON ContainerDesc.Id = tmpRemains.ContainerDescId
          LEFT JOIN Object AS Object_Asset 
                           ON Object_Asset.Id = tmpRemains.AssetId
                        --AND Object_Asset.DescId = zc_Object_Asset()

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

          LEFT JOIN ObjectLink AS ObjectLink_Asset_Car
                               ON ObjectLink_Asset_Car.ObjectId = Object_Asset.Id
                              AND ObjectLink_Asset_Car.DescId = zc_ObjectLink_Asset_Car()
          LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_Asset_Car.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                               ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                              AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
          LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Asset_AssetType
                               ON ObjectLink_Asset_AssetType.ObjectId = Object_Asset.Id
                              AND ObjectLink_Asset_AssetType.DescId = zc_ObjectLink_Asset_AssetType()
          LEFT JOIN Object AS Object_AssetType ON Object_AssetType.Id = ObjectLink_Asset_AssetType.ChildObjectId

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

          LEFT JOIN ObjectFloat AS ObjectFloat_Production
                                ON ObjectFloat_Production.ObjectId = Object_Asset.Id
                               AND ObjectFloat_Production.DescId = zc_ObjectFloat_Asset_Production()
          LEFT JOIN ObjectFloat AS ObjectFloat_KW
                                ON ObjectFloat_KW.ObjectId = Object_Asset.Id
                               AND ObjectFloat_KW.DescId = zc_ObjectFloat_Asset_KW()
       ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.20         * add Production
 16.03.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_AssetChoice (8444,zfCalc_UserAdmin())  ----8447  -- 8396
