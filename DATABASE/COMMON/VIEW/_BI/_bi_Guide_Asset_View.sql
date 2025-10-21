-- View: _bi_Guide_Asset_View

 DROP VIEW IF EXISTS _bi_Guide_Asset_View;

-- Справочник Основные средства
/*
-- Названия
Id
Code
Name
-- Признак "Удален да/нет"
isErased
*/

CREATE OR REPLACE VIEW _bi_Guide_Asset_View
AS
      SELECT Object_Asset.Id             AS Id
           , Object_Asset.ObjectCode     AS Code
           , Object_Asset.ValueData      AS Name
             -- Признак "Удален да/нет"
           , Object_Asset.isErased

           , Asset_AssetGroup.ValueData      AS AssetGroupName
           , Object_Maker.ValueData          AS MakerName
           , Object_PartionModel.ValueData   AS PartionModelName
           , Object_AssetType.ValueData      AS AssetTypeName

           , ObjectLink_Asset_Car.ChildObjectId AS CarId

           , ObjectString_InvNumber.ValueData      AS InvNumber
           , ObjectString_FullName.ValueData       AS FullName
           , ObjectString_SerialNumber.ValueData   AS SerialNumber
           , ObjectString_PassportNumber.ValueData AS PassportNumber
           , ObjectString_Comment.ValueData        AS Comment

       FROM Object AS Object_Asset
            LEFT JOIN ObjectLink AS ObjectLink_Asset_AssetGroup
                                 ON ObjectLink_Asset_AssetGroup.ObjectId = Object_Asset.Id
                                AND ObjectLink_Asset_AssetGroup.DescId = zc_ObjectLink_Asset_AssetGroup()
            LEFT JOIN Object AS Asset_AssetGroup ON Asset_AssetGroup.Id = ObjectLink_Asset_AssetGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Asset_Maker
                                 ON ObjectLink_Asset_Maker.ObjectId = Object_Asset.Id
                                AND ObjectLink_Asset_Maker.DescId = zc_ObjectLink_Asset_Maker()
            LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = ObjectLink_Asset_Maker.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Asset_PartionModel
                                 ON ObjectLink_Asset_PartionModel.ObjectId = Object_Asset.Id
                                AND ObjectLink_Asset_PartionModel.DescId = zc_ObjectLink_Asset_PartionModel()
            LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_Asset_PartionModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Asset_AssetType
                                 ON ObjectLink_Asset_AssetType.ObjectId = Object_Asset.Id
                                AND ObjectLink_Asset_AssetType.DescId = zc_ObjectLink_Asset_AssetType()
            LEFT JOIN Object AS Object_AssetType ON Object_AssetType.Id = ObjectLink_Asset_AssetType.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Asset_Car
                                 ON ObjectLink_Asset_Car.ObjectId = Object_Asset.Id
                                AND ObjectLink_Asset_Car.DescId = zc_ObjectLink_Asset_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_Asset_Car.ChildObjectId

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

       WHERE Object_Asset.DescId = zc_Object_Asset()
      ;

ALTER TABLE _bi_Guide_Asset_View  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC._bi_Guide_Asset_View TO admin;
GRANT ALL ON TABLE PUBLIC._bi_Guide_Asset_View TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_Asset_View ORDER BY 1
