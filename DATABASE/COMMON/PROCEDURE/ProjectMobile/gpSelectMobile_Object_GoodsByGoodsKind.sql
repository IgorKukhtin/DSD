-- Function: gpSelectMobile_Object_GoodsByGoodsKind (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_GoodsLinkGoodsKind (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelectMobile_Object_GoodsByGoodsKind (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_GoodsByGoodsKind (
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer  -- �����
             , GoodsKindId   Integer  -- ��� ������
             , Remains       TFloat   -- ������� �� ����������� ������
             , Forecast      TFloat   -- ������� ������� �� ����������� �����
             , isErased      Boolean  -- ��������� �� �������
             , isSync        Boolean  -- ���������������� (��/���)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbUnitId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      SELECT PersonalId, UnitId INTO vbPersonalId, vbUnitId FROM gpGetMobile_Object_Const (inSession);

      -- ���������
      IF vbPersonalId IS NOT NULL
      THEN
           CREATE TEMP TABLE tmpGoodsOrder ON COMMIT DROP
           AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId         AS GoodsId
                    , COUNT (ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId) AS GoodsCount
               FROM Object AS Object_GoodsByGoodsKind
                    JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_Order
                                       ON ObjectBoolean_GoodsByGoodsKind_Order.ObjectId = Object_GoodsByGoodsKind.Id
                                      AND ObjectBoolean_GoodsByGoodsKind_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order() 
                                      AND ObjectBoolean_GoodsByGoodsKind_Order.ValueData
                    JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                    ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object_GoodsByGoodsKind.Id
                                   AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                   AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId IS NOT NULL
               WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind()
               GROUP BY ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
              );

           CREATE TEMP TABLE tmpRemains ON COMMIT DROP
           AS (SELECT Container_Count.ObjectId                             AS GoodsId
                    , COALESCE (ContainerLinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                    , CAST (SUM (Container_Count.Amount) AS TFloat)        AS Amount
               FROM ContainerLinkObject AS ContainerLinkObject_Unit
                    JOIN Container AS Container_Count 
                                   ON Container_Count.Id = ContainerLinkObject_Unit.ContainerId 
                                  AND Container_Count.DescId = zc_Container_Count() 
                                  AND Container_Count.Amount > 0.0
                    JOIN tmpGoodsOrder ON tmpGoodsOrder.GoodsId = Container_Count.ObjectId
                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                                  ON ContainerLinkObject_GoodsKind.ContainerId = ContainerLinkObject_Unit.ContainerId
                                                 AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                  ON ContainerLinkObject_Account.ContainerId = ContainerLinkObject_Unit.ContainerId
                                                 AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
               WHERE ContainerLinkObject_Unit.ObjectId = vbUnitId
                 AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                 AND ContainerLinkObject_Account.ContainerId IS NULL -- !!!�.�. ��� ����� �������!!!
               GROUP BY Container_Count.ObjectId
                      , COALESCE (ContainerLinkObject_GoodsKind.ObjectId, 0)
              );

           /*IF inSyncDateIn > zc_DateStart()
           THEN
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS GoodsByGoodsKindId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                       FROM ObjectProtocol
                                            JOIN Object AS Object_GoodsByGoodsKind
                                                        ON Object_GoodsByGoodsKind.Id = ObjectProtocol.ObjectId
                                                       AND Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind() 
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       GROUP BY ObjectProtocol.ObjectId
                                      )
                  SELECT Object_GoodsByGoodsKind.Id
                       , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   AS GoodsId
                       , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId 
                       , COALESCE (tmpRemains.Amount, CAST(0.0 AS TFloat))                 AS Remains
                       , CAST(0.0 AS TFloat)                                               AS Forecast
                       , Object_GoodsByGoodsKind.isErased
                       , COALESCE(ObjectBoolean_GoodsByGoodsKind_Order.ValueData, false) AS isSync
                  FROM Object AS Object_GoodsByGoodsKind
                       JOIN tmpProtocol ON tmpProtocol.GoodsByGoodsKindId = Object_GoodsByGoodsKind.Id
                       LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_Order
                                               ON ObjectBoolean_GoodsByGoodsKind_Order.ObjectId = Object_GoodsByGoodsKind.Id
                                              AND ObjectBoolean_GoodsByGoodsKind_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order() 
                       JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                       ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object_GoodsByGoodsKind.Id
                                      AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                      AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId IS NOT NULL
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                            ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = Object_GoodsByGoodsKind.Id
                                           AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                       LEFT JOIN tmpRemains ON tmpRemains.GoodsId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                           AND tmpRemains.GoodsKindId = COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0)
                  WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind();
           ELSE*/
                RETURN QUERY
                  SELECT Object_GoodsByGoodsKind.Id
                       , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   AS GoodsId
                       , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId 
                       , COALESCE (tmpRemains.Amount, CAST(0.0 AS TFloat))                 AS Remains
                       , CAST(0.0 AS TFloat)                                               AS Forecast 
                       , Object_GoodsByGoodsKind.isErased
                       , CAST(true AS Boolean) AS isSync
                  FROM Object AS Object_GoodsByGoodsKind
                       JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_Order
                                          ON ObjectBoolean_GoodsByGoodsKind_Order.ObjectId = Object_GoodsByGoodsKind.Id
                                         AND ObjectBoolean_GoodsByGoodsKind_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order() 
                                         AND ObjectBoolean_GoodsByGoodsKind_Order.ValueData
                       JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                       ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object_GoodsByGoodsKind.Id
                                      AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                      AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId IS NOT NULL
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                            ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = Object_GoodsByGoodsKind.Id
                                           AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                       LEFT JOIN tmpRemains ON tmpRemains.GoodsId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                           AND tmpRemains.GoodsKindId = COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0)
                  WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind();
           --END IF;
      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 17.02.17                                                         *
*/

-- ����
-- SELECT * FROM gpSelectMobile_Object_GoodsByGoodsKind(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
