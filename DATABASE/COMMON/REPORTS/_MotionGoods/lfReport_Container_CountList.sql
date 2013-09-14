-- Function: lfReport_Container_CountList ()

-- DROP FUNCTION lfReport_Container_CountList ();

CREATE OR REPLACE FUNCTION lfReport_Container_CountList ()
RETURNS TABLE  (LocationId Integer, ContainerId_Goods Integer, GoodsId Integer, Amount TFloat)  
AS
$BODY$
BEGIN

    RETURN QUERY
                                    
    -- список количественных контейнеров (добавили ограниечение LocationId)
    SELECT tmpContainerLocation.LocationId
         , tmpContainerGoods.ContainerId_Goods
         , tmpContainerGoods.GoodsId
         , tmpContainerGoods.Amount
    FROM (SELECT ContainerLinkObject.ContainerId AS ContainerId_Goods, _tmpLocation.LocationId
          FROM _tmpLocation 
              JOIN ContainerLinkObject_Location AS ContainerLinkObject_Location ON ContainerLinkObject_Location.ObjectId = _tmpLocation.LocationId
              JOIN (SELECT zc_ContainerLinkObject_Unit() AS DescId 
                    UNION ALL
                    SELECT zc_ContainerLinkObject_Personal() AS DescId
                    ) AS tmpDesc ON tmpDesc.DescId = ContainerLinkObject_Location.DescId
         ) AS tmpContainerLocation
                                -- список количественных контейнеров (начали с ограниечения ТОВАРЫ)
         JOIN (SELECT Container.Id AS ContainerId_Goods, Container.ObjectId AS GoodsId, Container.Amount
               FROM _tmpGoods
                   JOIN Container ON Container.ObjectId = _tmpGoods .GoodsId
                                 AND Container.DescId = zc_Container_Count()
               ) AS tmpContainerGoods ON tmpContainerGoods.ContainerId_Goods = tmpContainerLocation.ContainerId_Goods;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION lfReport_Container_CountList () OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.09.13         *  
*/
-- тест
/*
CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
CREATE TEMP TABLE _tmpLocation (LocationId Integer) ON COMMIT DROP;

INSERT INTO _tmpGoods (GoodsId) SELECT Id FROM Object WHERE DescId = zc_Object_Goods();
INSERT INTO _tmpLocation (LocationId) SELECT Id FROM Object WHERE DescId = zc_Object_Unit() UNION ALL SELECT Id FROM Object WHERE DescId = zc_Object_Personal();

SELECT * FROM lfReport_Container_CountList ();

*/
