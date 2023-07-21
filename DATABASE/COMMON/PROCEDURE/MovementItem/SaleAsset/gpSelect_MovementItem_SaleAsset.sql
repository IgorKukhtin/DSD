-- Function: gpSelect_MovementItem_SaleAsset()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SaleAsset (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SaleAsset(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , ContainerId Integer
             , Amount TFloat
             , AmountRemains TFloat
             , Price TFloat
             , CountForPrice TFloat
             , AmountSumm TFloat
             , isErased Boolean
             , MakerId Integer, MakerCode Integer, MakerName TVarChar
             , CarId Integer, CarCode Integer, CarName TVarChar, CarModelName TVarChar
             , Release TDateTime
             , InvNumber TVarChar, SerialNumber TVarChar, PassportNumber TVarChar
             , PeriodUse TFloat 
             , StorageId Integer, StorageName TVarChar
             , UnitName_Storage     TVarChar
             , BranchName_Storage   TVarChar
             , AreaUnitName_Storage TVarChar
             , Room_Storage         TVarChar
             , Address_Storage      TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbFromId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SaleAsset());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется
     SELECT MovementLinkObject_From.ObjectId
            INTO vbFromId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

    -- Результат
     RETURN QUERY
       WITH tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.ObjectId                         AS GoodsId
                                 , MovementItem.Amount                           AS Amount
                                 , MIFloat_ContainerId.ValueData      :: Integer AS ContainerId
                                 , MovementItem.isErased
                            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = tmpIsErased.isErased

                                 LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                             ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId() 
                                   )

          , tmpPartionGoods AS (SELECT CLO_PartionGoods.*
                                FROM ContainerLinkObject AS CLO_PartionGoods
                                WHERE CLO_PartionGoods.ContainerId IN (SELECT DISTINCT tmpMI_Goods.ContainerId FROM tmpMI_Goods)
                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                )
          , tmpRemains AS (SELECT tmpMI_Goods.MovementItemId
                                , SUM (Container.Amount) AS Amount
                           FROM tmpMI_Goods
                                INNER JOIN Container ON Container.ObjectId = tmpMI_Goods.GoodsId
                                                    AND Container.DescId   = zc_Container_Count()
                                                    AND Container.Amount   <> 0
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                              AND CLO_Unit.ObjectId    = vbFromId
                           GROUP BY tmpMI_Goods.MovementItemId
                          )

       -- Результат
       SELECT
             tmpMI_Goods.MovementItemId         AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Asset_AssetGroup.ValueData         AS GoodsGroupNameFull

           , tmpMI_Goods.ContainerId
           , tmpMI_Goods.Amount                 AS Amount
           , tmpRemains.Amount :: TFloat        AS AmountRemains

           , COALESCE (MIFloat_Price.ValueData, 0)      :: TFloat     AS Price
           , COALESCE (MIFloat_CountForPrice.ValueData, 1) :: TFloat  AS CountForPrice

           , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 1) > 0
                       THEN CAST ( COALESCE (tmpMI_Goods.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) / COALESCE (MIFloat_CountForPrice.ValueData, 1) AS NUMERIC (16, 2))
                  ELSE CAST ( COALESCE (tmpMI_Goods.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
             END :: TFloat AS AmountSumm

           , tmpMI_Goods.isErased        AS isErased

           , Object_Maker.Id             AS MakerId
           , Object_Maker.ObjectCode     AS MakerCode
           , Object_Maker.ValueData      AS MakerName

           , Object_Car.Id               AS CarId
           , Object_Car.ObjectCode       AS CarCode
           , Object_Car.ValueData        AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , COALESCE (ObjectDate_Release.ValueData,CAST (CURRENT_DATE as TDateTime)) AS Release
           , ObjectString_InvNumber.ValueData      AS InvNumber
           , ObjectString_SerialNumber.ValueData   AS SerialNumber
           , ObjectString_PassportNumber.ValueData AS PassportNumber
           , ObjectFloat_PeriodUse.ValueData       AS PeriodUse

           , Object_Storage.Id                        AS StorageId
           , Object_Storage.ValueData ::TVarChar      AS StorageName 
           , Object_Unit_Storage.ValueData            AS UnitName_Storage
           , Object_Branch_Storage.ValueData          AS BranchName_Storage
           , Object_AreaUnit_Storage.ValueData        AS AreaUnitName_Storage
           , ObjectString_Storage_Room.ValueData      AS Room_Storage
           , ObjectString_Storage_Address.ValueData   AS Address_Storage

       FROM tmpMI_Goods
            LEFT JOIN tmpRemains ON tmpRemains.MovementItemId = tmpMI_Goods.MovementItemId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Goods.GoodsId
             
            LEFT JOIN ObjectLink AS ObjectLink_Asset_AssetGroup
                                 ON ObjectLink_Asset_AssetGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Asset_AssetGroup.DescId = zc_ObjectLink_Asset_AssetGroup()
            LEFT JOIN Object AS Asset_AssetGroup ON Asset_AssetGroup.Id = ObjectLink_Asset_AssetGroup.ChildObjectId

            ---
            LEFT JOIN ObjectLink AS ObjectLink_Asset_Maker
                                 ON ObjectLink_Asset_Maker.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectLink_Asset_Maker.DescId = zc_ObjectLink_Asset_Maker()
            LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = ObjectLink_Asset_Maker.ChildObjectId
  
            LEFT JOIN ObjectLink AS ObjectLink_Asset_Car
                                 ON ObjectLink_Asset_Car.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectLink_Asset_Car.DescId = zc_ObjectLink_Asset_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_Asset_Car.ChildObjectId
  
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                 ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId
  
            LEFT JOIN ObjectDate AS ObjectDate_Release
                                 ON ObjectDate_Release.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectDate_Release.DescId = zc_ObjectDate_Asset_Release()
  
            LEFT JOIN ObjectString AS ObjectString_InvNumber
                                   ON ObjectString_InvNumber.ObjectId = tmpMI_Goods.GoodsId
                                  AND ObjectString_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()
  
            LEFT JOIN ObjectString AS ObjectString_SerialNumber
                                   ON ObjectString_SerialNumber.ObjectId = tmpMI_Goods.GoodsId
                                  AND ObjectString_SerialNumber.DescId = zc_ObjectString_Asset_SerialNumber()
  
            LEFT JOIN ObjectString AS ObjectString_PassportNumber
                                   ON ObjectString_PassportNumber.ObjectId = tmpMI_Goods.GoodsId
                                  AND ObjectString_PassportNumber.DescId = zc_ObjectString_Asset_PassportNumber()
  
            LEFT JOIN ObjectFloat AS ObjectFloat_PeriodUse
                                  ON ObjectFloat_PeriodUse.ObjectId = tmpMI_Goods.GoodsId
                                 AND ObjectFloat_PeriodUse.DescId = zc_ObjectFloat_Asset_PeriodUse()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = tmpMI_Goods.MovementItemId
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()    
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = tmpMI_Goods.MovementItemId
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN tmpPartionGoods AS CLO_PartionGoods
                                      ON CLO_PartionGoods.ContainerId = tmpMI_Goods.ContainerId
                                     AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                                          
            LEFT JOIN ObjectLink AS ObjectLink_Storage
                                 ON ObjectLink_Storage.ObjectId = CLO_PartionGoods.ObjectId
                                AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Storage_Address
                                   ON ObjectString_Storage_Address.ObjectId = Object_Storage.Id 
                                  AND ObjectString_Storage_Address.DescId = zc_ObjectString_Storage_Address()
            LEFT JOIN ObjectString AS ObjectString_Storage_Room
                                   ON ObjectString_Storage_Room.ObjectId = Object_Storage.Id 
                                  AND ObjectString_Storage_Room.DescId = zc_ObjectString_Storage_Room()
            LEFT JOIN ObjectLink AS ObjectLink_Storage_AreaUnit
                                 ON ObjectLink_Storage_AreaUnit.ObjectId = Object_Storage.Id 
                                AND ObjectLink_Storage_AreaUnit.DescId = zc_ObjectLink_Storage_AreaUnit()
            LEFT JOIN Object AS Object_AreaUnit_Storage ON Object_AreaUnit_Storage.Id = ObjectLink_Storage_AreaUnit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Storage_Unit
                                 ON ObjectLink_Storage_Unit.ObjectId = Object_Storage.Id 
                                AND ObjectLink_Storage_Unit.DescId = zc_ObjectLink_Storage_Unit()
            LEFT JOIN Object AS Object_Unit_Storage ON Object_Unit_Storage.Id = ObjectLink_Storage_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit_Storage.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch_Storage ON Object_Branch_Storage.Id = ObjectLink_Unit_Branch.ChildObjectId

            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.23         *
 18.06.20         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_SaleAsset (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_SaleAsset (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '2')