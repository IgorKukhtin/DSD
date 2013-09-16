-- Function: lfReport_Container_CountList ()

-- DROP FUNCTION lfReport_Container_CountList ();

CREATE OR REPLACE FUNCTION lfReport_Container_CountList ()
RETURNS TABLE  (ContainerId_Goods Integer, LocationId Integer, GoodsId Integer, Amount TFloat)  
AS
$BODY$
BEGIN

    RETURN QUERY
                                    -- список суммовых контейнеров (добавили ограниечение ТОВАРЫ)
    SELECT tmpObject.ContainerId_Goods
         , tmpObject.LocationId
         , _tmpGoods.GoodsId
         , tmpObject.Amount
    FROM _tmpGoods 
     -- список суммовых контейнеров (начали с ограниечения LocationId)
        JOIN  (SELECT Container.Id AS ContainerId_Goods
		            , COALESCE (ContainerLinkObject_Unit.ObjectId, ContainerLinkObject_Personal.ObjectId) AS LocationId
                    , Container.ObjectId AS GoodsId
                    , Container.Amount
               FROM _tmpLocation
                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit ON ContainerLinkObject_Unit.Objectid = _tmpLocation.LocationId
                                                                             AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal ON ContainerLinkObject_Personal.Objectid = _tmpLocation.LocationId
                                                                                 AND ContainerLinkObject_Personal.DescId = zc_ContainerLinkObject_Personal()
                    JOIN Container ON Container.Id = COALESCE (ContainerLinkObject_Unit.ContainerId, ContainerLinkObject_Personal.ContainerId)
                                  AND Container.DescId = zc_Container_Count() 
               ) AS  tmpObject on tmpObject.GoodsId = _tmpGoods .GoodsId;
                                  
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

SELECT * FROM lfReport_Container_CountList () as lfContainer_CountList
left join object as object_Goods on object_Goods.Id = lfContainer_CountList.GoodsId 
left join object as object_Location on object_Location.Id = lfContainer_CountList.LocationId ;

*/