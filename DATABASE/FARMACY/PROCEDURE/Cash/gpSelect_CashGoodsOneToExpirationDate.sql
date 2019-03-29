-- Function: gpSelect_CashGoodsOneToExpirationDate()

DROP FUNCTION IF EXISTS gpSelect_CashGoodsOneToExpirationDate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashGoodsOneToExpirationDate(
    IN inGoodsId        Integer,
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS TABLE (ID Integer,
               GoodsCode Integer,
               GoodsName TVarChar,
               Amount TFloat,
               ExpirationDate TDateTime)

AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbObjectId   Integer;
  DECLARE vbUnitId     Integer;
  DECLARE vbUnitIdStr  TVarChar;
  DECLARE vbAreaId     Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId := inSession;
     vbObjectId := COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '0');
     vbUnitIdStr := COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), '0');
     IF vbUnitIdStr <> '' THEN
        vbUnitId := vbUnitIdStr;
     ELSE
     	vbUnitId := 0;
     END IF;


     RETURN QUERY
    WITH tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.ObjectId =  inGoodsId
                            AND Container.Amount <> 0
                         )
       , tmpCLO AS (SELECT CLO.*
                    FROM ContainerlinkObject AS CLO
                    WHERE CLO.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                   )
       , tmpObject AS (SELECT Object.* FROM Object WHERE Object.Id IN (SELECT DISTINCT tmpCLO.ObjectId FROM tmpCLO))

       , tmpMIDate AS (SELECT MovementItemDate.*
                       FROM MovementItemDate
                       WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpObject.ObjectCode FROM tmpObject)
                         AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                      )

       , tmpExpirationDate AS (SELECT tmpCLO.ContainerId, MIDate_ExpirationDate.ValueData
                               FROM tmpCLO
                                    INNER JOIN tmpObject ON tmpObject.Id = tmpCLO.ObjectId
                                    INNER JOIN tmpMIDate AS MIDate_ExpirationDate
                                                         ON MIDate_ExpirationDate.MovementItemId = tmpObject.ObjectCode
                                                        -- AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )

     SELECT Container.ObjectId                                                AS ID
          , Object_Goods.ObjectCode                                           AS GoodsCode
          , Object_Goods.ValueData                                            AS GoodsName
          , Container.Amount                                                  AS Amount
          , COALESCE (tmpExpirationDate.ValueData, zc_DateEnd()) :: TDateTime AS MinExpirationDate
     FROM tmpContainer AS Container

          INNER JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId
          LEFT JOIN tmpExpirationDate ON tmpExpirationDate.Containerid = Container.Id
     ORDER BY 5;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 27.03.19                                                                    *
*/

-- ����
-- SELECT * FROM gpSelect_CashGoodsOneToExpirationDate (inGoodsId := 59107, inSession := '3354092');