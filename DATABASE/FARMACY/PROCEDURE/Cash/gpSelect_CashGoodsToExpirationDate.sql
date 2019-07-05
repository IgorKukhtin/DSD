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

  DECLARE vbMonth_0  TFloat;
  DECLARE vbMonth_1  TFloat;
  DECLARE vbMonth_6  TFloat;

  DECLARE vbOperDate TDateTime;
  DECLARE vbDate180  TDateTime;
  DECLARE vbDate30   TDateTime;

  DECLARE vbPartion   boolean;
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

    -- �������� �������� �� ����������� ��� ���������� �� ������
    vbMonth_0 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0());
    vbMonth_1 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1());
    vbMonth_6 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

    -- ���� + 6 �������, + 1 �����
    vbDate180 := CURRENT_DATE + (vbMonth_6||' MONTH' ) ::INTERVAL;
    vbDate30  := CURRENT_DATE + (vbMonth_1||' MONTH' ) ::INTERVAL;
    vbOperDate:= CURRENT_DATE + (vbMonth_0||' MONTH' ) ::INTERVAL;

    vbPartion := False;

     RETURN QUERY
     WITH tmpContainer AS (SELECT Container.Id, 
                                  Container.ObjectId AS GoodsId, 
                                  Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                         )
       , tmpExpirationDate AS (SELECT tmp.Id
                                    , tmp.GoodsId
                                    , tmp.Amount
                                    , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate  
                               FROM tmpContainer AS tmp
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
                                                                       -- AND 1=0
                                   LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                    ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                   AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )
          -- ������� �� ������
       , tmpPDContainerAll AS (SELECT Container.Id,
                                      Container.ParentID,
                                      Container.Amount,
                                      ContainerLinkObject.ObjectId                       AS PartionGoodsId
                              FROM Container

                                   LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.WhereObjectId = vbUnitId
                              AND Container.Amount <> 0)
       , tmpPDContainer AS (SELECT Container.Id,
                                   Container.ParentID,
                                   Container.Amount,
                                   COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate,
                                   CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbOperDate   THEN zc_Enum_PartionDateKind_0()  -- ����������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate30  THEN zc_Enum_PartionDateKind_1()  -- ������ 1 ������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate180 THEN zc_Enum_PartionDateKind_6()  -- ������ 6 ������
                                        ELSE zc_Enum_PartionDateKind_Good() END                  AS PartionDateKindId           -- ����������� � ���������

                            FROM tmpPDContainerAll AS Container

                                 LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ID = Container.PartionGoodsId

                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

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
          , COALESCE(tmpPDContainer.Amount, Container.Amount)                      AS Amount
          , COALESCE (tmpPDContainer.ExpirationDate, tmpExpirationDate.ExpirationDate, zc_DateEnd()) :: TDateTime    AS MinExpirationDate
          , tmpPDContainer.PartionDateKindId                                       AS PartionDateKindId          
          , CASE WHEN COALESCE (tmpPDContainer.ExpirationDate, tmpExpirationDate.ExpirationDate, zc_DateEnd()) <= vbOperDate THEN zc_Color_Red() ELSE   -- ����������
            CASE WHEN COALESCE (tmpPDContainer.ExpirationDate, tmpExpirationDate.ExpirationDate, zc_DateEnd()) <= vbDate30  THEN zc_Color_Yelow() ELSE     -- ������ 1 ������
            CASE WHEN COALESCE (tmpPDContainer.ExpirationDate, tmpExpirationDate.ExpirationDate, zc_DateEnd()) <= vbDate180 THEN zc_Color_Cyan() ELSE      -- ������ 6 ������
            zc_Color_White() END END END                                                           AS Color_calc
     FROM tmpContainer AS Container
          LEFT JOIN tmpPDContainer ON tmpPDContainer.ParentID = Container.ID

          LEFT JOIN tmpExpirationDate ON tmpExpirationDate.id = Container.Id

          LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Container.GoodsId 
     ORDER BY 1, 4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.   ������ �.�.
 28.03.19                                                                                     *
*/

-- ����
-- SELECT * FROM gpSelect_CashGoodsToExpirationDate (inSession := '3');