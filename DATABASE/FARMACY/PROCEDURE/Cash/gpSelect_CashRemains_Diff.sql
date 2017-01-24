-- Function: gpSelect_CashRemains_Diff_ver2()

-- DROP FUNCTION IF EXISTS gpSelect_CashRemains_Diff_ver2 (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpselect_cashremains_diff_ver2( Integer, TVarChar, TVarChar, TVarChar)

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_Diff_ver2(
    IN inMovementId    Integer,    -- ������� ���������
    IN inCashSessionId TVarChar,   -- ������ ��������� �����
    in inUserSession     TVarChar,   -- ������ ������������ (��������� ��������)
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (
    Id Integer,
    GoodsCode Integer,
    GoodsName TVarChar,
    Price TFloat,
    Remains TFloat,
    MCSValue TFloat,
    Reserved TFloat,
    NewRow Boolean,
    Color_calc Integer
)

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    if coalesce(inUserSession, '') <> '' then 
     inSession := inUserSession;
    end if;

-- if inSession = '3' then return; end if;

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    -- �������� ���� ���������� ��������� �� ������
    PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                      , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                      , inUserId        := vbUserId
                                       );
    
    --���������� ������� � �������� �������� � ����������
    CREATE TEMP TABLE _DIFF (ObjectId  Integer
                           , GoodsCode Integer
                           , GoodsName TVarChar
                           , Price     TFloat
                           , Remains   TFloat
                           , MCSValue  TFloat
                           , Reserved  TFloat
                           , NewRow    Boolean
                           , Color_calc Integer
                           , MinExpirationDate TDateTime) ON COMMIT DROP;    

    -- ������
    WITH tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count() 
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                         )
       , tmpCLO AS (SELECT CLO.*
                    FROM ContainerlinkObject AS CLO
                    WHERE CLO.ContainerId IN (SELECT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                   )
       , tmpObject AS (SELECT Object.Id, Object.ObjectCode FROM Object WHERE Object.Id IN (SELECT tmpCLO.ObjectId FROM tmpCLO))
       , tmpExpirationDate AS (SELECT tmpCLO.ContainerId, MIDate_ExpirationDate.ValueData
                               FROM tmpCLO
                                    INNER JOIN tmpObject ON tmpObject.Id = tmpCLO.ObjectId
                                    INNER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                ON MIDate_ExpirationDate.MovementItemId = tmpObject.ObjectCode
                                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )
       , GoodsRemains AS
     (SELECT Container.ObjectId
           , SUM (Container.Amount) AS Remains
           , MIN (COALESCE (tmpExpirationDate.ValueData, zc_DateEnd())) :: TDateTime AS MinExpirationDate -- ���� ��������
      FROM tmpContainer AS Container
          -- ������� ������
          LEFT JOIN tmpExpirationDate ON tmpExpirationDate.Containerid = Container.Id
          /*
          -- ������� ������
          LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                        ON ContainerLinkObject_MovementItem.Containerid =  Container.Id
                                       AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
          LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
          -- ������� �������
          LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
          -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                      ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                     AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
          -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                     
          LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                           ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                          AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()*/
      GROUP BY Container.ObjectId
     )
    -- ���������� ����
  , RESERVE AS (SELECT gpSelect.GoodsId      AS GoodsId
                     , SUM (gpSelect.Amount) AS Amount
                 FROM gpSelect_MovementItem_CheckDeferred (inSession) AS gpSelect
                 WHERE gpSelect.MovementId <> inMovementId
                 GROUP BY gpSelect.GoodsId
                )
    -- ��������� � ������
  , SESSIONDATA AS (SELECT CashSessionSnapShot.ObjectId
                         , CashSessionSnapShot.Price
                         , CashSessionSnapShot.Remains
                         , CashSessionSnapShot.MCSValue
                         , CashSessionSnapShot.Reserved
                         , CashSessionSnapShot.MinExpirationDate
                    FROM CashSessionSnapShot
                    WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
                   )
       , tmpGoods AS (SELECT tmpContainer.ObjectId FROM tmpContainer
                     UNION
                      SELECT SESSIONDATA.ObjectId FROM SESSIONDATA
                     UNION
                      SELECT RESERVE.GoodsId FROM RESERVE
                     )
       , tmpPrice AS (SELECT tmpGoods.ObjectId, COALESCE (ROUND (ObjectFloat_Value.ValueData, 2), 0) AS Price, COALESCE (ObjectFloat_MCS.ValueData, 0) AS MCSValue
                      FROM tmpGoods
                           INNER JOIN ObjectLink AS ObjectLink_Goods
                                                 ON ObjectLink_Goods.ChildObjectId = tmpGoods.ObjectId
                                                AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                           INNER JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                AND ObjectLink_Unit.ChildObjectId = vbUnitId
                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                  ON ObjectFloat_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                 AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS ObjectFloat_MCS
                                                 ON ObjectFloat_MCS.ObjectId = ObjectLink_Goods.ObjectId
                                                AND ObjectFloat_MCS.DescId = zc_ObjectFloat_Price_MCSValue()
                     )
    -- ��������� - �������� �������
    INSERT INTO _DIFF (ObjectId, GoodsCode, GoodsName, Price, Remains, MCSValue, Reserved, NewRow, Color_calc,MinExpirationDate)
       WITH tmpDiff AS (SELECT tmpPrice.ObjectId                                                 AS ObjectId
                             , tmpPrice.Price                                                    AS Price
                             , tmpPrice.MCSValue                                                 AS MCSValue
                             , COALESCE (GoodsRemains.Remains, 0) - COALESCE (Reserve.Amount,0)  AS Remains
                             , Reserve.Amount                                                    AS Reserved
                             , CASE WHEN SESSIONDATA.ObjectId IS NULL
                                         THEN TRUE
                                     ELSE FALSE
                               END                                                               AS NewRow
                             , GoodsRemains.MinExpirationDate                                    AS MinExpirationDate
                        FROM tmpPrice
                             LEFT JOIN GoodsRemains ON GoodsRemains.ObjectId = tmpPrice.ObjectId
                             LEFT JOIN SESSIONDATA  ON SESSIONDATA.ObjectId  = tmpPrice.ObjectId
                             LEFT JOIN RESERVE      ON RESERVE.GoodsId       = tmpPrice.ObjectId
                        WHERE tmpPrice.Price    <> COALESCE (SESSIONDATA.Price, 0)
                           OR tmpPrice.MCSValue <> COALESCE (SESSIONDATA.MCSValue, 0)
                           OR COALESCE (GoodsRemains.Remains, 0) - COALESCE (Reserve.Amount, 0) <> COALESCE (SESSIONDATA.Remains, 0)
                           OR COALESCE (Reserve.Amount,0) <> COALESCE (SESSIONDATA.Reserved, 0)
                       ) 
       -- ���������
       SELECT tmpDiff.ObjectId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , tmpDiff.Price
            , tmpDiff.Remains
            , tmpDiff.MCSValue
            , tmpDiff.Reserved
            , tmpDiff.NewRow
            , CASE WHEN COALESCE (ObjectBoolean_First.ValueData, FALSE) = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc 
            , tmpDiff.MinExpirationDate
       FROM tmpDiff
            INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpDiff.ObjectId
            LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                    ON ObjectBoolean_First.ObjectId = tmpDiff.ObjectId
                                   AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()
      ;


    --��������� ������ � ������
    UPDATE CashSessionSnapShot SET
        Price             = _DIFF.Price
      , Remains           = _DIFF.Remains
      , MCSValue          = _DIFF.MCSValue
      , Reserved          = _DIFF.Reserved
      , MinExpirationDate = _DIFF.MinExpirationDate
    FROM
        _DIFF
    WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
      AND CashSessionSnapShot.ObjectId = _DIFF.ObjectId;
    
    --�������� ��, ��� ���������
    Insert Into CashSessionSnapShot(CashSessionId,ObjectId,Price,Remains,MCSValue,Reserved,MinExpirationDate)
    SELECT
        inCashSessionId
       ,_DIFF.ObjectId
       ,_DIFF.Price
       ,_DIFF.Remains
       ,_DIFF.MCSValue
       ,_DIFF.Reserved
       ,_DIFF.MinExpirationDate
    FROM
        _DIFF
    WHERE
        _DIFF.NewRow = TRUE;
    --���������� ������� � �������
    RETURN QUERY
        SELECT
            _DIFF.ObjectId,
            _DIFF.GoodsCode,
            _DIFF.GoodsName,
            _DIFF.Price,
            _DIFF.Remains,
            _DIFF.MCSValue,
            _DIFF.Reserved,
            _DIFF.NewRow,
            _DIFF.Color_calc
        FROM
            _DIFF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_Diff_ver2 (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 16.03.16         * 
 12.09.15                                                                       *CashSessionSnapShot
*/

-- ����
-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 (0, '{ACAF6C5B-24C4-43F0-B920-55444A167EC31}', '3')
-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 (0, '{ACAF6C5B-24C4-43F0-B920-55444A167EC31}', '390016')
