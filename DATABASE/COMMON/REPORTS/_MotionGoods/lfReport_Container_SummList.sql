-- Function: lfRepor_Container_SummList ()

-- DROP FUNCTION lfRepor_Container_SummList ();

CREATE OR REPLACE FUNCTION lfRepor_Container_SummList ()
RETURNS TABLE  (ContainerId Integer, AccountId Integer, LocationId Integer, ContainerId_Goods Integer, GoodsId Integer, Amount TFloat)  
AS
$BODY$
BEGIN

    RETURN QUERY
                                    -- список суммовых контейнеров (добавили ограниечение ТОВАРЫ)
    SELECT tmpObject.ContainerId
         , tmpObject.AccountId
         , tmpObject.LocationId
         , tmpObject.ContainerId_Goods
         , _tmpGoods.GoodsId
         , tmpObject.Amount
    FROM _tmpGoods 
        JOIN ContainerLinkObject AS ContainerLinkObject_Goods ON  ContainerLinkObject_Goods.ObjectId = _tmpGoods .GoodsId
                                                             AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                  -- список суммовых контейнеров (начали с ограниечения LocationId)
        JOIN  (SELECT Container.Id AS ContainerId
					, Container.ParentId AS ContainerId_Goods
                    , Container.ObjectId AS AccountId
                    , COALESCE (ContainerLinkObject_Unit.ContainerId, ContainerLinkObject_Personal.ContainerId) AS LocationId
                    , Container.Amount
               FROM _tmpLocation
                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit ON ContainerLinkObject_Unit.Objectid = _tmpLocation.LocationId
                                                                            AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal ON ContainerLinkObject_Personal.Objectid = _tmpLocation.LocationId
                                                                                AND ContainerLinkObject_Personal.DescId = zc_ContainerLinkObject_Personal()
                   JOIN Container ON Container.Id = COALESCE (ContainerLinkObject_Unit.ContainerId, ContainerLinkObject_Personal.ContainerId)
                                  AND Container.DescId = zc_Container_Summ() 
                   LEFT JOIN Container AS Container_Goods ON Container_Goods.Id = Container.ParentId               
               ) AS  tmpObject on tmpObject.ContainerId = ContainerLinkObject_Goods.ContainerId;
                                  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION lfRepor_Container_SummList () OWNER TO postgres;


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

SELECT * FROM lfRepor_Container_SummList ();

*/