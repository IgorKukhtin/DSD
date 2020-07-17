-- Function: gpSelect_MovementItem_PartionGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PartionGoods (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PartionGoods(
    IN inUnitId   Integer      , -- ���� ���������
    IN inGoodsId  Integer      , -- ���� ���������
    IN inSession  TVarChar       -- ������ ������������
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               PartionDateKindId  Integer, PartionDateKindName  TVarChar,
               Remains TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbDate_0     TDateTime;
   DECLARE vbDate_1    TDateTime;
   DECLARE vbDate_3    TDateTime;
   DECLARE vbDate_6   TDateTime;

BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;

    -- �������� ��� ���������� �� ������
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();
    
    RETURN QUERY
    WITH           -- ������� �� ������
         tmpPDContainerAll AS (SELECT Container.Id,
                                     Container.ObjectId,
                                     Container.ParentId,
                                     Container.Amount,
                                     ContainerLinkObject.ObjectId                       AS PartionGoodsId 
                              FROM Container

                                   LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.ObjectId = inGoodsId
                              AND Container.WhereObjectId = inUnitId
                              AND Container.Amount <> 0)
       , tmpPDContainer AS (SELECT Container.Id,
                                   Container.ObjectId,
                                   Container.Amount,
                                   CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND 
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE 
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5() -- 5 ��� (��������� ��� �������)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0   THEN zc_Enum_PartionDateKind_0()     -- ����������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()     -- ������ 1 ������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()     -- ������ 3 ������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()     -- ������ 6 ������
                                        ELSE zc_Enum_PartionDateKind_Good() END                  AS PartionDateKindId              -- ����������� � ���������
                            FROM tmpPDContainerAll AS Container

                                 LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ID = Container.PartionGoodsId

                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                                      
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId =  Container.PartionGoodsId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5() 
                                  )
       , tmpPDGoodsRemains AS (SELECT Container.ObjectId
                                    , Container.PartionDateKindId                                       AS PartionDateKindId
                                    , SUM (Container.Amount)                                            AS Remains
                               FROM tmpPDContainer AS Container
                               GROUP BY Container.ObjectId
                                      , Container.PartionDateKindId
                               )
       , tmpPDGoodsRemainsAll AS (SELECT tmpPDGoodsRemains.ObjectId
                                       , SUM (tmpPDGoodsRemains.Remains)                                AS Remains
                                  FROM tmpPDGoodsRemains
                                  GROUP BY tmpPDGoodsRemains.ObjectId
                                 )
          -- ������� �� �������� �����������
       , tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.ObjectId = inGoodsId
                            AND Container.WhereObjectId = inUnitId
                            AND Container.Amount <> 0
                         )
       , tmpGoodsRemains AS (SELECT Container.ObjectId
                                  , SUM (Container.Amount) AS Remains
                             FROM tmpContainer AS Container
                             GROUP BY Container.ObjectId
                             )
          -- ��������������� �������
       , GoodsRemains AS (SELECT Container.ObjectId
                               , Container.Remains - COALESCE(tmpPDGoodsRemainsAll.Remains, 0)                   AS Remains
                               , NULL                                                                            AS PartionDateKindId
                          FROM tmpGoodsRemains AS Container
                               LEFT JOIN tmpPDGoodsRemainsAll ON tmpPDGoodsRemainsAll.ObjectId = Container.ObjectId
                          UNION ALL
                          SELECT tmpPDGoodsRemains.ObjectId
                               , tmpPDGoodsRemains.Remains
                               , tmpPDGoodsRemains.PartionDateKindId
                          FROM tmpPDGoodsRemains
                         )

    SELECT
           Goods.ID                     AS GoodsId
         , Goods.ObjectCode             AS GoodsCode
         , Goods.ValueData              AS GoodsName
         , PartionDateKind.ID           AS PartionDateKindId
         , PartionDateKind.ValueData    AS PartionDateKindName
         , GoodsRemains.Remains::TFloat AS Remains 
    FROM GoodsRemains

         INNER JOIN Object AS Goods ON Goods.Id = GoodsRemains.ObjectId

         LEFT JOIN Object AS PartionDateKind ON PartionDateKind.Id = GoodsRemains.PartionDateKindId;
    

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Check (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�. ��������� �.�   ������ �.�.
 19.07.19                                                                                   *
*/

-- ����
-- select * from gpSelect_MovementItem_PartionGoods(inUnitId := 377610 ,  inGoodsId := 2149403 ,  inSession := '3');