-- Function: gpSelect_MovementItem_PartionGoods()

DROP FUNCTION IF EXISTS gpSelect_PartionDateGoods (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PartionDateGoods(
    IN inUnitId   Integer      , -- ���� ���������
    IN inGoodsId  Integer      , -- ���� ���������
    IN inSession  TVarChar       -- ������ ������������
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               ExpirationDate TDateTime,
               PartionDateKindId  Integer, PartionDateKindName  TVarChar,
               Amount TFloat, ContainerID Integer
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
                                   Container.ParentId,
                                   Container.Amount,
                                   ObjectDate_ExpirationDate.ValueData AS ExpirationDate,
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
          -- ������� �� �������� �����������
       , tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.ObjectId = inGoodsId
                            AND Container.WhereObjectId = inUnitId
                            AND Container.Amount <> 0
                         )

    SELECT
           Goods.ID                      AS GoodsId
         , Goods.ObjectCode              AS GoodsCode
         , Goods.ValueData               AS GoodsName
         , tmpPDContainer.ExpirationDate AS ExpirationDate
         , PartionDateKind.ID            AS PartionDateKindId
         , PartionDateKind.ValueData     AS PartionDateKindName
         , tmpPDContainer.Amount         AS Amount
         , tmpPDContainer.ID             AS ContainerID
    FROM tmpContainer
    
         INNER JOIN tmpPDContainer ON tmpPDContainer.ParentId = tmpContainer.Id

         INNER JOIN Object AS Goods ON Goods.Id = tmpPDContainer.ObjectId

         LEFT JOIN Object AS PartionDateKind ON PartionDateKind.Id = tmpPDContainer.PartionDateKindId;
    

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_PartionDateGoods (Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�. ��������� �.�   ������ �.�.
 19.07.19                                                                                   *
*/

-- ����
-- 

select * from gpSelect_PartionDateGoods(inUnitId := 7117700 , inGoodsId := 30745 ,  inSession := '3');