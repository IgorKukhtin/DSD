-- Function: gpGet_Object_Asset()

DROP FUNCTION IF EXISTS gpGet_Object_Asset(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Asset(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , AssetGroupId Integer, AssetGroupCode Integer, AssetGroupName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , MakerId Integer, MakerCode Integer, MakerName TVarChar
             , CarId Integer, CarName TVarChar 
             , PartionModelId Integer, PartionModelName TVarChar
             , AssetTypeId Integer, AssetTypeName TVarChar
             , Release TDateTime
             , InvNumber TVarChar, FullName TVarChar, SerialNumber TVarChar, PassportNumber TVarChar, Comment TVarChar
             , PeriodUse TFloat, Production TFloat, KW TFloat
             , isDocGoods Boolean
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Asset());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)    AS AssetGroupId
           , CAST (0 as Integer)    AS AssetGroupCode
           , CAST ('' as TVarChar)  AS AssetGroupName
           
           , CAST (0 as Integer)    AS JuridicalId
           , CAST (0 as Integer)    AS JuridicalCode
           , CAST ('' as TVarChar)  AS JuridicalName
           
           , CAST (0 as Integer)    AS MakerId
           , CAST (0 as Integer)    AS MakerCode
           , CAST ('' as TVarChar)  AS MakerName

           , CAST (0 as Integer)    AS CarId
           , CAST ('' as TVarChar)  AS CarName

           , 0    :: Integer        AS PartionModelId
           , ''  :: TVarChar        AS PartionModelName

           , CAST (0 as Integer)    AS AssetTypeId
           , CAST ('' as TVarChar)  AS AssetTypeName
 
           , CURRENT_DATE :: TDateTime AS Release
           
           , CAST ('' as TVarChar)  AS InvNumber
           , CAST ('' as TVarChar)  AS FullName
           , CAST ('' as TVarChar)  AS SerialNumber
           , CAST ('' as TVarChar)  AS PassportNumber
           , CAST ('' as TVarChar)  AS Comment
           
           , 0 :: TFloat            AS PeriodUse
           , 0 :: TFloat            AS Production
           , 0 :: TFloat            AS KW
           , FALSE                  AS isDocGoods
           , CAST (FALSE AS Boolean) AS isErased
           
       FROM Object 
       WHERE Object.DescId = zc_Object_Asset();
   ELSE
     RETURN QUERY 
     SELECT 
           Object_Asset.Id            AS Id 
         , Object_Asset.ObjectCode    AS Code
         , Object_Asset.ValueData     AS Name
         
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
         , Object_Car.ValueData        AS CarName

         , Object_PartionModel.Id         AS PartionModelId
         , Object_PartionModel.ValueData  AS PartionModelName
         
         , Object_AssetType.Id         AS AssetTypeId
         , Object_AssetType.ValueData  AS AssetTypeName

         , COALESCE (ObjectDate_Release.ValueData,CAST (CURRENT_DATE as TDateTime)) AS Release
         
         , ObjectString_InvNumber.ValueData      AS InvNumber
         , ObjectString_FullName.ValueData       AS FullName
         , ObjectString_SerialNumber.ValueData   AS SerialNumber
         , ObjectString_PassportNumber.ValueData AS PassportNumber
         , ObjectString_Comment.ValueData        AS Comment

         , ObjectFloat_PeriodUse.ValueData  AS PeriodUse
         , COALESCE (ObjectFloat_Production.ValueData,0) :: TFloat AS Production
         , COALESCE (ObjectFloat_KW.ValueData,0)         :: TFloat AS KW
         
         , COALESCE (ObjectBoolean_DocGoods.ValueData, FALSE)     :: Boolean AS isDocGoods
         
         , Object_Asset.isErased            AS isErased
         
     FROM OBJECT AS Object_Asset
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

          LEFT JOIN ObjectLink AS ObjectLink_Asset_AssetType
                               ON ObjectLink_Asset_AssetType.ObjectId = Object_Asset.Id
                              AND ObjectLink_Asset_AssetType.DescId = zc_ObjectLink_Asset_AssetType()
          LEFT JOIN Object AS Object_AssetType ON Object_AssetType.Id = ObjectLink_Asset_AssetType.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Asset_PartionModel
                               ON ObjectLink_Asset_PartionModel.ObjectId = Object_Asset.Id
                              AND ObjectLink_Asset_PartionModel.DescId = zc_ObjectLink_Asset_PartionModel()
          LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_Asset_PartionModel.ChildObjectId

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

          LEFT JOIN ObjectBoolean AS ObjectBoolean_DocGoods
                                  ON ObjectBoolean_DocGoods.ObjectId = Object_Asset.Id
                                 AND ObjectBoolean_DocGoods.DescId = zc_ObjectBoolean_Asset_DocGoods()

       WHERE Object_Asset.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Asset(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.10.22         *
 29.04.20         * add Production
 10.09.18         * add Car
 11.02.14         * add wiki
 02.07.13         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Asset(0, '2')