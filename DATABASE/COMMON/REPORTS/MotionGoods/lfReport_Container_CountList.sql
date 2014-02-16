-- Function: lfReport_Container_CountList ()

DROP FUNCTION IF EXISTS lfReport_Container_CountList ();

CREATE OR REPLACE FUNCTION lfReport_Container_CountList ()
RETURNS TABLE  (ContainerId_Goods Integer, LocationId Integer, GoodsId Integer, Amount TFloat)  
AS
$BODY$
BEGIN

    RETURN QUERY
                                    -- список количественных контейнеров (добавили ограниечение ТОВАРЫ)
    SELECT tmpObject.ContainerId_Goods
         , tmpObject.LocationId
         , _tmpGoods.GoodsId
         , tmpObject.Amount
    FROM _tmpGoods 
     -- список суммовых контейнеров (начали с ограниечения LocationId)
        JOIN  (SELECT Container.Id AS ContainerId_Goods
		    , _tmpLocation.LocationId
                    , Container.ObjectId AS GoodsId
                    , Container.Amount
               FROM _tmpLocation
                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit ON ContainerLinkObject_Unit.Objectid = _tmpLocation.LocationId
                                                                             AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Member ON ContainerLinkObject_Member.Objectid = _tmpLocation.LocationId
                                                                               AND ContainerLinkObject_Member.DescId = zc_ContainerLinkObject_Member()
                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car ON ContainerLinkObject_Car.Objectid = _tmpLocation.LocationId
                                                                               AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                    JOIN Container ON Container.Id = COALESCE (ContainerLinkObject_Unit.ContainerId, COALESCE (ContainerLinkObject_Member.ContainerId, ContainerLinkObject_Car.ContainerId))
                                  AND Container.DescId = zc_Container_Count() 
               ) AS  tmpObject on tmpObject.GoodsId = _tmpGoods .GoodsId;
                                  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfReport_Container_CountList () OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.12.13                                        * Personal -> Member
 13.09.13         *  
*/

-- тест
/*
CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
CREATE TEMP TABLE _tmpLocation (LocationId Integer) ON COMMIT DROP;

INSERT INTO _tmpGoods (GoodsId) SELECT Id FROM Object WHERE DescId = zc_Object_Goods();
INSERT INTO _tmpLocation (LocationId) SELECT Id FROM Object WHERE DescId = zc_Object_Unit() UNION ALL SELECT Id FROM Object WHERE DescId = zc_Object_Member() ;

SELECT * FROM lfReport_Container_CountList () as lfContainer_CountList
left join object as object_Goods on object_Goods.Id = lfContainer_CountList.GoodsId 
left join object as object_Location on object_Location.Id = lfContainer_CountList.LocationId ;

*/