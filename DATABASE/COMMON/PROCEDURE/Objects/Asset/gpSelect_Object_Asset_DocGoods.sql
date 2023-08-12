-- Function: gpSelect_Object_Asset_DocGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_Asset_DocGoods(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Asset_DocGoods(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , AssetGroupId Integer, AssetGroupCode Integer, AssetGroupName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , MakerId Integer, MakerCode Integer, MakerName TVarChar
             , CarId Integer, CarCode Integer, CarName TVarChar, CarModelName TVarChar
             , PartionModelId Integer, PartionModelCode Integer, PartionModelName TVarChar
             , AssetTypeId Integer, AssetTypeCode Integer, AssetTypeName TVarChar
             , Release TDateTime
             , InvNumber TVarChar, FullName TVarChar, SerialNumber TVarChar, PassportNumber TVarChar, Comment TVarChar
             , PeriodUse TFloat, Production TFloat, KW TFloat
             , isIrna Boolean, isDocGoods Boolean
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Asset());

     RETURN QUERY 
     SELECT 
           tmp.Id 
         , tmp.Code
         , tmp.Name
         , tmp.AssetGroupId
         , tmp.AssetGroupCode
         , tmp.AssetGroupName
         , tmp.JuridicalId
         , tmp.JuridicalCode
         , tmp.JuridicalName
         , tmp.MakerId
         , tmp.MakerCode
         , tmp.MakerName
         , tmp.CarId
         , tmp.CarCode
         , tmp.CarName
         , tmp.CarModelName 
         , tmp.PartionModelId
         , tmp.PartionModelCode
         , tmp.PartionModelName
         , tmp.AssetTypeId
         , tmp.AssetTypeCode
         , tmp.AssetTypeName
         , tmp.Release
         , tmp.InvNumber
         , tmp.FullName                                                                                                       
         , tmp.SerialNumber
         , tmp.PassportNumber
         , tmp.Comment
         , tmp.PeriodUse
         , tmp.Production
         , tmp.KW
         , tmp.isIrna
         , tmp.isDocGoods
         , tmp.isErased
     FROM gpSelect_Object_Asset (inSession) AS tmp
     WHERE tmp.isDocGoods = TRUE
       ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.10.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Asset_DocGoods (zfCalc_UserAdmin())
