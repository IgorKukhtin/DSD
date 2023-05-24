-- Function: gpReport_Remains_Partion()

DROP FUNCTION IF EXISTS gpReport_Remains_Partion (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Remains_Partion(
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inIsShowAll          Boolean   ,
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE  (ContainerId        Integer
              , GoodsId            Integer
              , GoodsCode          Integer
              , GoodsName          TVarChar
              , GoodsGroupNameFull TVarChar
              , Amount             TFloat
              , GoodsKindName      TVarChar
              , LocationCode       Integer
              , LocationName       TVarChar
              , LocationDescName   TVarChar
              , PartionGoodsId     Integer
              , InvNumber          TVarChar
              , OperDate           TDateTime
              , Price              TFloat
              , StorageName        TVarChar
              , PartionModelName   TVarChar
              , PartNumber         TVarChar
              , UnitName           TVarChar
              , UnitName_storage   TVarChar
              , BranchName_storage TVarChar
              , AreaUnitName_storage TVarChar
              , Room_storage       TVarChar
              , Address_storage    TVarChar
              , Comment_storage    TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inGoodsGroupId,0) = 0 AND COALESCE (inGoodsId,0) = 0
   THEN
        RAISE EXCEPTION '������. �� ������ ����� ��� ������ �������.';
   END IF;
   
   -- ���������
    RETURN QUERY
    WITH 
         tmpGoods AS (SELECT inGoodsId AS GoodsId
                      WHERE COALESCE (inGoodsId <> 0)
                     UNION
                      SELECT lfSelect.GoodsId
                      FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                      WHERE inGoodsId = 0 AND inGoodsGroupId <> 0
                      )

       , tmpWhere AS (SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Car() AS DescId FROM Object WHERE Object.DescId = zc_Object_Car()
                     UNION
                      SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Member() AS DescId FROM Object WHERE Object.DescId = zc_Object_Member()
                     UNION
                      SELECT Object_Unit.Id AS LocationId, zc_ContainerLinkObject_Unit() AS DescId FROM Object AS Object_Unit WHERE Object_Unit.DescId = zc_Object_Unit()
                    )
       , tmpContainer AS (SELECT Container.Id          AS ContainerId
                                     , CLO_Location.ObjectId AS LocationId
                                     , Container.ObjectId    AS GoodsId
                                    -- , COALESCE (CLO_GoodsKind.ObjectId, 0)    AS GoodsKindId
                                     , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                                     , (COALESCE (Container.Amount,0)) AS Amount
                                FROM tmpGoods
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                                         AND (COALESCE (Container.Amount,0) <> 0 OR inIsShowAll = TRUE)
                                     INNER JOIN ContainerLinkObject AS CLO_Location
                                                                    ON CLO_Location.ContainerId = Container.Id
                                                                   AND CLO_Location.DescId IN (zc_ContainerLinkObject_Car(), zc_ContainerLinkObject_Unit(),zc_ContainerLinkObject_Member())--  tmpWhere.DescId
                                                                   --AND CLO_Location.ObjectId = tmpWhere.LocationId
                                    /* LEFT JOIN ContainerLinkObject AS CLO_GoodsKind 
                                                                   ON CLO_GoodsKind.ContainerId = Container.Id
                                                                  AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()*/
                                     INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                   ON CLO_PartionGoods.ContainerId = Container.Id
                                                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                                                  AND COALESCE (CLO_PartionGoods.ObjectId, 0) <> 0
                                     LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                   ON CLO_Account.ContainerId = Container.Id
                                                                  AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                WHERE CLO_Account.ContainerId IS NULL -- !!!�.�. ��� ����� �������!!!
                                  AND COALESCE (CLO_Location.ObjectId,0) <> 0
                               )

       , tmpCLO_GoodsKind AS (SELECT ContainerLinkObject.*
                              FROM ContainerLinkObject
                              WHERE ContainerLinkObject.DescId = zc_ContainerLinkObject_GoodsKind()
                                AND ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId FROM tmpContainer)
                              )

       , tmpPartion AS (SELECT Object_PartionGoods.Id          AS Id
                             , Object_PartionGoods.ValueData   AS InvNumber
                             , ObjectDate_Value.ValueData      AS OperDate
                             , ObjectFloat_Price.ValueData     AS Price
                  
                             , Object_Storage.Id               AS StorageId
                             , Object_Storage.ValueData        AS StorageName
                            
                             , Object_Unit.Id                  AS UnitId
                             , Object_Unit.ValueData           AS UnitName 
                             
                             , Object_PartionModel.Id          AS PartionModelId
                             , Object_PartionModel.ValueData   AS PartionModelName
                             
                             , ObjectString_PartNumber.ValueData AS PartNumber 
                        FROM (SELECT DISTINCT tmpContainer.PartionGoodsId FROM tmpContainer) AS tmp
                            INNER JOIN Object as Object_PartionGoods  ON Object_PartionGoods.Id = tmp.PartionGoodsId                       --������

                            LEFT JOIN ObjectDate AS objectdate_value
                                                 ON objectdate_value.ObjectId = Object_PartionGoods.Id                    -- ����
                                                AND objectdate_value.DescId = zc_ObjectDate_PartionGoods_Value()

                            LEFT JOIN ObjectString AS ObjectString_PartNumber
                                                   ON ObjectString_PartNumber.ObjectId = Object_PartionGoods.Id                    -- ����
                                                  AND ObjectString_PartNumber.DescId = zc_ObjectString_PartionGoods_PartNumber()

                            LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                             ON ObjectFloat_Price.ObjectId = Object_PartionGoods.Id                       -- ����
                                            AND ObjectFloat_Price.DescId = zc_ObjectFloat_PartionGoods_Price()    

                            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId = Object_PartionGoods.Id		        -- �������������
                                                AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId
                                    
                            LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                 ON ObjectLink_Storage.ObjectId = Object_PartionGoods.Id	                -- �����
                                                AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
                            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId  

                            LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                                 ON ObjectLink_PartionModel.ObjectId = Object_PartionGoods.Id		        -- ������
                                                AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_PartionModel()
                            LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId
                        )

       , tmpStorage AS (SELECT spSelect.*
                        FROM gpSelect_Object_Storage (inSession) AS spSelect
                        )


       SELECT  tmpContainer.ContainerId
             , Object_Goods.Id                 AS GoodsId
             , Object_Goods.ObjectCode         AS GoodsCode
             , Object_Goods.ValueData          AS GoodsName
             , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
             , tmpContainer.Amount           ::TFloat
             , Object_GoodsKind.ValueData  AS GoodsKindName 
             , Object_Location.ObjectCode  AS LocationCode
             , Object_Location.ValueData   AS LocationName
             , ObjectDesc.ItemName         AS LocationDescName
             , tmpPartion.Id               AS PartionGoodsId
             , tmpPartion.InvNumber
             , tmpPartion.OperDate
             , tmpPartion.Price
             , tmpPartion.StorageName
             , tmpPartion.PartionModelName
             , tmpPartion.PartNumber
             , tmpPartion.UnitName 
             , tmpStorage.UnitName     AS UnitName_storage
             , tmpStorage.BranchName   AS BranchName_storage
             , tmpStorage.AreaUnitName AS AreaUnitName_storage
             , tmpStorage.Room         AS Room_storage
             , tmpStorage.Address      AS Address_storage
             , tmpStorage.Comment      AS Comment_storage

         FROM tmpContainer
             LEFT JOIN ContainerLinkObject AS CLO_GoodsKind 
                                            ON CLO_GoodsKind.ContainerId = tmpContainer.ContainerId
                                           AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
              LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (CLO_GoodsKind.ObjectId, 0) 

              LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpContainer.LocationId
              LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location.DescId
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpContainer.GoodsId
              LEFT JOIN tmpPartion ON tmpPartion.Id = tmpContainer.PartionGoodsId 
              LEFT JOIN tmpStorage ON tmpStorage.Id = tmpPartion.StorageId

              LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                     ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                    AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.05.23         *
*/

-- SELECT * FROM gpReport_Remains_Partion(inGoodsGroupId := 0, inGoodsId:= 7144, inIsShowAll:=true, inSession := zfCalc_UserAdmin():: TVarChar ) as tmp
