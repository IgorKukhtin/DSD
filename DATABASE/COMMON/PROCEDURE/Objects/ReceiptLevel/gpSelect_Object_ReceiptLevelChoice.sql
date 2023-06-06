-- Function: gpSelect_Object_ReceiptLevelChoice()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptLevelChoice(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptLevelChoice(
    IN inUnitId      Integer ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ItemName TVarChar, Id Integer, Code Integer, Name TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , MakerId Integer, MakerCode Integer, MakerName TVarChar
             , CarId Integer, CarCode Integer, CarName TVarChar, CarModelName TVarChar
             , ReceiptLevelTypeId Integer, ReceiptLevelTypeCode Integer, ReceiptLevelTypeName TVarChar
             , DocumentKindId Integer, DocumentKindCode Integer, DocumentKindName TVarChar
             , Release TDateTime
             , InvNumber TVarChar, FullName TVarChar, SerialNumber TVarChar, PassportNumber TVarChar, Comment TVarChar
             , PeriodUse TFloat, Production TFloat, KW TFloat
             , AmountRemains TFloat
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptLevel());

     RETURN QUERY
     WITH 
     tmpReceiptLevel AS (SELECT Object_ReceiptLevel.Id     AS ReceiptLevelId
                              , Object_ReceiptLevel.DescId AS DescId
                         FROM Object AS Object_ReceiptLevel
                         WHERE Object_ReceiptLevel.DescId IN (zc_Object_ReceiptLevel(), zc_Object_Goods())
                         --AND Object_ReceiptLevel.isErased = FALSE
                        )

   , tmpRemains AS (SELECT Container.Id           AS ContainerId
                         , Container.DescId       AS ContainerDescId
                         , tmpReceiptLevel.ReceiptLevelId       AS ReceiptLevelId
                         , SUM (Container.Amount) AS Amount
                    FROM tmpReceiptLevel
                         INNER JOIN Container ON Container.ObjectId = tmpReceiptLevel.ReceiptLevelId
                                             AND Container.DescId   IN (zc_Container_Count(), zc_Container_CountReceiptLevel())
                                             AND COALESCE (Container.Amount, 0) <> 0
                         INNER JOIN ContainerLinkObject AS CLO_Unit
                                                        ON CLO_Unit.ContainerId = Container.Id
                                                       AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                       AND (CLO_Unit.ObjectId = inUnitId OR inUnitId = 0)
                         LEFT JOIN ContainerLinkObject AS CLO_ReceiptLevelTo
                                                       ON CLO_ReceiptLevelTo.ContainerId = Container.Id
                                                      AND CLO_ReceiptLevelTo.DescId = zc_ContainerLinkObject_lTo()
                         LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                       ON CLO_PartionGoods.ContainerId = Container.Id
                                                      AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                         LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                    WHERE (Object_PartionGoods.ObjectCode > 0 OR CLO_ReceiptLevelTo.ObjectId > 0 OR tmpReceiptLevel.DescId = zc_Object_ReceiptLevel())
                    GROUP BY Container.Id
                           , Container.DescId
                           , tmpReceiptLevel.ReceiptLevelId
                   )

    SELECT tmpRemains.ContainerId :: Integer
         , ContainerDesc.ItemName
         , Object_ReceiptLevel.Id             AS Id 
         , Object_ReceiptLevel.ObjectCode     AS Code
         , Object_ReceiptLevel.ValueData      AS Name
         
         , ReceiptLevel_From.Id         AS FromId
         , ReceiptLevel_From.ObjectCode AS FromCode
         , ReceiptLevel_From.ValueData  AS FromName
         
         , Object_To.Id         AS ToId
         , Object_To.ObjectCode AS ToCode
         , Object_To.ValueData  AS ToName

         , Object_Maker.Id             AS MakerId
         , Object_Maker.ObjectCode     AS MakerCode
         , Object_Maker.ValueData      AS MakerName

         , Object_Car.Id               AS CarId
         , Object_Car.ObjectCode       AS CarCode
         , Object_Car.ValueData        AS CarName
         , Object_CarModel.ValueData   AS CarModelName

         , Object_ReceiptLevelType.Id             AS ReceiptLevelTypeId
         , Object_ReceiptLevelType.ObjectCode     AS ReceiptLevelTypeCode
         , Object_ReceiptLevelType.ValueData      AS ReceiptLevelTypeName
         
         , Object_DocumentKind.Id           AS DocumentKindId
         , Object_DocumentKind.ObjectCode   AS DocumentKindCode
         , Object_DocumentKind.ValueData    AS DocumentKindName

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
         , Object_ReceiptLevel.isErased            AS isErased
         
     FROM tmpRemains
          LEFT JOIN ContainerDesc ON ContainerDesc.Id = tmpRemains.ContainerDescId
          LEFT JOIN Object AS Object_ReceiptLevel 
                           ON Object_ReceiptLevel.Id = tmpRemains.ReceiptLevelId
                        --AND Object_ReceiptLevel.DescId = zc_Object_ReceiptLevel()

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_From
                               ON ObjectLink_ReceiptLevel_From.ObjectId = Object_ReceiptLevel.Id
                              AND ObjectLink_ReceiptLevel_From.DescId = zc_ObjectLink_ReceiptLevel_From()
          LEFT JOIN Object AS ReceiptLevel_From ON ReceiptLevel_From.Id = ObjectLink_ReceiptLevel_From.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_To
                               ON ObjectLink_ReceiptLevel_To.ObjectId = Object_ReceiptLevel.Id
                              AND ObjectLink_ReceiptLevel_To.DescId = zc_ObjectLink_ReceiptLevel_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_ReceiptLevel_To.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_Maker
                               ON ObjectLink_ReceiptLevel_Maker.ObjectId = Object_ReceiptLevel.Id
                              AND ObjectLink_ReceiptLevel_Maker.DescId = zc_ObjectLink_ReceiptLevel_Maker()
          LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = ObjectLink_ReceiptLevel_Maker.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_Car
                               ON ObjectLink_ReceiptLevel_Car.ObjectId = Object_ReceiptLevel.Id
                              AND ObjectLink_ReceiptLevel_Car.DescId = zc_ObjectLink_ReceiptLevel_Car()
          LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_ReceiptLevel_Car.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                               ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                              AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
          LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_ReceiptLevelType
                               ON ObjectLink_ReceiptLevel_ReceiptLevelType.ObjectId = Object_ReceiptLevel.Id
                              AND ObjectLink_ReceiptLevel_ReceiptLevelType.DescId = zc_ObjectLink_ReceiptLevel_ReceiptLevelType()
          LEFT JOIN Object AS Object_ReceiptLevelType ON Object_ReceiptLevelType.Id = ObjectLink_ReceiptLevel_ReceiptLevelType.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_DocumentKind
                               ON ObjectLink_ReceiptLevel_DocumentKind.ObjectId = Object_ReceiptLevel.Id
                              AND ObjectLink_ReceiptLevel_DocumentKind.DescId = zc_ObjectLink_ReceiptLevel_DocumentKind()
          LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = ObjectLink_ReceiptLevel_DocumentKind.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Release
                                ON ObjectDate_Release.ObjectId = Object_ReceiptLevel.Id
                               AND ObjectDate_Release.DescId = zc_ObjectDate_ReceiptLevel_Release()

          LEFT JOIN ObjectString AS ObjectString_InvNumber
                                 ON ObjectString_InvNumber.ObjectId = Object_ReceiptLevel.Id
                                AND ObjectString_InvNumber.DescId = zc_ObjectString_ReceiptLevel_InvNumber()

          LEFT JOIN ObjectString AS ObjectString_FullName
                                 ON ObjectString_FullName.ObjectId = Object_ReceiptLevel.Id
                                AND ObjectString_FullName.DescId = zc_ObjectString_ReceiptLevel_FullName()

          LEFT JOIN ObjectString AS ObjectString_SerialNumber
                                 ON ObjectString_SerialNumber.ObjectId = Object_ReceiptLevel.Id
                                AND ObjectString_SerialNumber.DescId = zc_ObjectString_ReceiptLevel_SerialNumber()

          LEFT JOIN ObjectString AS ObjectString_PassportNumber
                                 ON ObjectString_PassportNumber.ObjectId = Object_ReceiptLevel.Id
                                AND ObjectString_PassportNumber.DescId = zc_ObjectString_ReceiptLevel_PassportNumber()

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptLevel.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptLevel_Comment()  

          LEFT JOIN ObjectFloat AS ObjectFloat_PeriodUse
                                ON ObjectFloat_PeriodUse.ObjectId = Object_ReceiptLevel.Id
                               AND ObjectFloat_PeriodUse.DescId = zc_ObjectFloat_ReceiptLevel_PeriodUse()

          LEFT JOIN ObjectFloat AS ObjectFloat_Production
                                ON ObjectFloat_Production.ObjectId = Object_ReceiptLevel.Id
                               AND ObjectFloat_Production.DescId = zc_ObjectFloat_ReceiptLevel_Production()
          LEFT JOIN ObjectFloat AS ObjectFloat_KW
                                ON ObjectFloat_KW.ObjectId = Object_ReceiptLevel.Id
                               AND ObjectFloat_KW.DescId = zc_ObjectFloat_ReceiptLevel_KW()
       ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.06.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptLevelChoice (8444,zfCalc_UserAdmin())  ----8447  -- 8396
