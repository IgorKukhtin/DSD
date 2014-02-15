-- Function: lfReport_Container_SummList ()

DROP FUNCTION IF EXISTS lfReport_Container_SummList ();

CREATE OR REPLACE FUNCTION lfReport_Container_SummList ()
RETURNS TABLE  (ContainerId Integer, AccountId Integer, ContainerId_Goods Integer, LocationId Integer, GoodsId Integer, Amount TFloat)  
AS
$BODY$
BEGIN

    RETURN QUERY
                                    
    -- ������ �������������� ����������� (�������� ������������ LocationId)
    SELECT tmpContainerGoods.ContainerId
         , tmpContainerGoods.AccountId
         , tmpContainerGoods.ContainerId_Goods
         , tmpContainerLocation.LocationId
         , tmpContainerGoods.GoodsId
         , tmpContainerGoods.Amount
    FROM (SELECT ContainerLinkObject_Location.ContainerId, _tmpLocation.LocationId
          FROM _tmpLocation 
              JOIN ContainerLinkObject AS ContainerLinkObject_Location ON ContainerLinkObject_Location.ObjectId = _tmpLocation.LocationId
              JOIN (SELECT zc_ContainerLinkObject_Unit() AS DescId 
                   UNION ALL
                    SELECT zc_ContainerLinkObject_Member() AS DescId
                   UNION ALL
                    SELECT zc_ContainerLinkObject_Car() AS DescId
                    ) AS tmpDesc ON tmpDesc.DescId = ContainerLinkObject_Location.DescId
         ) AS tmpContainerLocation
                                -- ������ �������������� ����������� (������ � ������������ ������)
         JOIN (SELECT Container.ParentId AS ContainerId_Goods, Container.Id AS ContainerId, Container.ObjectId AS AccountId, ContainerLinkObject_Goods.ObjectId AS GoodsId, Container.Amount
               FROM _tmpGoods
                    JOIN ContainerLinkObject AS ContainerLinkObject_Goods ON ContainerLinkObject_Goods.ObjectId = _tmpGoods.GoodsId
                                                                           AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                   JOIN Container ON Container.Id = ContainerLinkObject_Goods.ContainerId
                                 AND Container.DescId = zc_Container_Summ()
               ) AS tmpContainerGoods ON tmpContainerGoods.ContainerId = tmpContainerLocation.ContainerId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfReport_Container_SummList () OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.12.13                                        * Personal -> Member
 13.09.13         *  
*/

-- ����
/*
CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
CREATE TEMP TABLE _tmpLocation (LocationId Integer) ON COMMIT DROP;

INSERT INTO _tmpGoods (GoodsId) SELECT Id FROM Object WHERE DescId = zc_Object_Goods();
INSERT INTO _tmpLocation (LocationId) SELECT Id FROM Object WHERE DescId = zc_Object_Unit() UNION ALL SELECT Id FROM Object WHERE DescId = zc_Object_Member();

SELECT * FROM lfReport_Container_SummList () as lfContainer_SummList
left join object as object_Goods on object_Goods.Id = lfContainer_SummList.GoodsId 
left join object as object_Location on object_Location.Id = lfContainer_SummList.LocationId ;


*/
