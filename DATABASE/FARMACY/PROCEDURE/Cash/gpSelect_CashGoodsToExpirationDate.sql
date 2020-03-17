-- Function: gpSelect_CashGoodsToExpirationDate()

DROP FUNCTION IF EXISTS gpSelect_CashGoodsToExpirationDate (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashGoodsToExpirationDate(
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS TABLE (ID Integer,
               Price TFloat,
               Amount TFloat,
               ExpirationDate TDateTime,
               PartionDateKindId  Integer,
               Color_calc Integer)

AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbObjectId   Integer;
  DECLARE vbUnitId     Integer;
  DECLARE vbUnitIdStr  TVarChar;

  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_1 TDateTime;
  DECLARE vbDate_0 TDateTime;
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

    -- �������� ��� ���������� �� ������
    -- ���� + 6 �������
    SELECT CURRENT_DATE + tmp.Date_6, tmp.Day_6
           INTO vbDate_6
    FROM (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                            , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                       FROM Object  AS Object_PartionDateKind
                            LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                  ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                 AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                  ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                 AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                       WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                      )
          SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL AS Date_6
               , tmp.Value AS Day_6
          FROM tmp
         ) AS tmp;
    -- ���� + 1 �����
    vbDate_1:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );
    -- ���� + 0 �������
    vbDate_0:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );


     RETURN QUERY
     WITH tmpContainer AS (SELECT Container.Id,
                                  Container.ObjectId                            AS GoodsId,
                                  Container.Amount
                             FROM Container
                             WHERE Container.DescId = zc_Container_Count()
                               AND Container.WhereObjectId = vbUnitId
                               AND Container.Amount <> 0
                            )
       , tmpContainerPDId AS (SELECT Container.ParentId                                          AS ContainerId
                                   , Max(Container.Id)                                           AS ContainerPDId
                              FROM Container
                              WHERE Container.DescId = zc_Container_CountPartionDate()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.Amount <> 0
                              GROUP BY Container.ParentId)
       , tmpContainerPD AS (SELECT tmpContainerPDId.ContainerId                                  AS ContainerId
                                 , ObjectDate_ExpirationDate.ValueData                           AS ExpirationDate
                                 , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                              COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 ��� (��������� ��� �������)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- ����������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- ������ 1 ������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- ������ 6 ������
                                        ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- ����������� � ���������
                            FROM tmpContainerPDId

                                 LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = tmpContainerPDId.ContainerPDId
                                                              AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5())
       , tmpExpirationIn AS (SELECT tmp.Id
                                    , tmp.GoodsId
                                    , tmp.Amount
                                    , COALESCE (MI_Income_find.Id,MI_Income.Id)    AS MI_IncomeId
                               FROM tmpContainer AS tmp

                                     -- ������� ���� �������� �� �������
                                  LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                ON ContainerLinkObject_MovementItem.Containerid = tmp.Id
                                                               AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                  LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                  -- ������� �������
                                  LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                  -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                  LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                              ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                             AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                  -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                  LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                               )
       , tmpExpirationDate AS (SELECT tmp.Id
                                    , tmp.GoodsId
                                    , tmp.Amount
                                    , COALESCE (tmpContainerPD.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate
                                    , tmpContainerPD.PartionDateKindId                                                        AS PartionDateKindId
                               FROM tmpExpirationIn AS tmp

                                   -- ������� ���� �������� ��� ���������� ������
                                  LEFT JOIN tmpContainerPD ON tmpContainerPD.ContainerId = tmp.Id

                                  LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                    ON MIDate_ExpirationDate.MovementItemId = tmp.MI_IncomeId
                                                                   AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )
       , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                          AND ObjectFloat_Goods_Price.ValueData > 0
                                         THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                         ELSE ROUND (Price_Value.ValueData, 2)
                                    END :: TFloat                           AS Price
                                  , Price_Goods.ChildObjectId               AS GoodsId
                             FROM ObjectLink AS ObjectLink_Price_Unit
                                LEFT JOIN ObjectLink AS Price_Goods
                                                     ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                    AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                LEFT JOIN ObjectFloat AS Price_Value
                                                      ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                -- ���� ���� ��� ���� ����
                                LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                       ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                      AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                        ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                       AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                             WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                               AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                             )

     SELECT Container.GoodsId                                                      AS ID
          , COALESCE(tmpObject_Price.Price,0)::TFloat                              AS Price
          , Container.Amount                                                       AS Amount
          , tmpExpirationDate.ExpirationDate                                       AS MinExpirationDate
          , tmpExpirationDate.PartionDateKindId                                    AS PartionDateKindId
          , CASE WHEN COALESCE (tmpExpirationDate.ExpirationDate, zc_DateEnd()) <= vbDate_0 THEN zc_Color_Red() ELSE       -- ����������
            CASE WHEN COALESCE (tmpExpirationDate.ExpirationDate, zc_DateEnd()) <= vbDate_1 THEN zc_Color_Yelow() ELSE     -- ������ 1 ������
            CASE WHEN COALESCE (tmpExpirationDate.ExpirationDate, zc_DateEnd()) <= vbDate_6 THEN zc_Color_Cyan() ELSE      -- ������ 6 ������
            zc_Color_White() END END END                                                           AS Color_calc
     FROM tmpContainer AS Container

          LEFT JOIN tmpExpirationDate ON tmpExpirationDate.id = Container.Id

          LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Container.GoodsId
     ORDER BY 1, 4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.   ������ �.�.
 21.09.19                                                                                     *
 15.07.19                                                                                     *
 28.03.19                                                                                     *
*/

-- ����
--
SELECT * FROM gpSelect_CashGoodsToExpirationDate (inSession := '3');