-- Function: gpGet_Movement_Check_RemainsError()

DROP FUNCTION IF EXISTS gpGet_Movement_Check_RemainsError (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_RemainsError(
    IN inGoodsId_list      TVarChar  , -- ������ Id ������� ��� ��������
    IN inAmount_list       TVarChar  , -- ������ ���-�� ��� ��������
   OUT outMessageText      Text      , -- �������, ���� ���� ������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Text
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbIndex Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);


    vbUnitKey := COALESCE (lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    vbUnitId  := CASE WHEN vbUnitKey = '' THEN '0' ELSE vbUnitKey END :: Integer;


    -- �������
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer, Amount TFloat) ON COMMIT DROP;
    -- ������ ������
    vbIndex := 1;
    WHILE SPLIT_PART (inGoodsId_list, ';', vbIndex) <> '' LOOP
        -- ��������� �� ��� �����
        INSERT INTO _tmpGoods (GoodsId, Amount)
           SELECT tmp.GoodsId, tmp.Amount
           FROM (SELECT SPLIT_PART (inGoodsId_list, ';', vbIndex) :: Integer AS GoodsId
                      , CASE WHEN -- ���� ������ ���� ����������� ���. - ����� ������� �� ���.
                                  SPLIT_PART ((0 :: TFloat) :: TVarChar, ',', 2) <> ''
                                  THEN REPLACE (SPLIT_PART (inAmount_list, ';', vbIndex), '.', ',')
                             WHEN -- ���� ������ ���� ����������� ���. - ����� ������� �� ���.
                                  SPLIT_PART ((0 :: TFloat) :: TVarChar, '.', 2) <> ''
                                  THEN REPLACE (SPLIT_PART (inAmount_list, ';', vbIndex), ',', '.')
                             ELSE ''
                        END :: TFloat AS Amount
                ) AS tmp;
        -- ������ ����������
        vbIndex := vbIndex + 1;
    END LOOP;


    -- �������� ��� ���� �������
    outMessageText:= '������.������ ��� � �������: '
                                || (WITH tmpFrom AS (SELECT _tmpGoods.GoodsId, SUM (_tmpGoods.Amount) AS Amount FROM _tmpGoods GROUP BY _tmpGoods.GoodsId)
                                       , tmpTo AS (SELECT tmpFrom.GoodsId, SUM (Container.Amount) AS Amount
                                                   FROM tmpFrom
                                                        INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                                            AND Container.WhereObjectId = vbUnitId
                                                                            AND Container.ObjectId = tmpFrom.GoodsId
                                                                            AND Container.Amount > 0
                                                   GROUP BY tmpFrom.GoodsId
                                                  )
                                    SELECT STRING_AGG (tmp.Value, ' (***) ')
                                    FROM (SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '') || ' � ���� : ' || zfConvert_FloatToString (AmountFrom) || COALESCE (Object_Measure.ValueData, '') || '; �������: ' || zfConvert_FloatToString (AmountTo) || COALESCE (Object_Measure.ValueData, '') AS Value
                                          FROM (SELECT tmpFrom.GoodsId, tmpFrom.Amount AS AmountFrom, COALESCE (tmpTo.Amount, 0) AS AmountTo
                                                FROM tmpFrom
                                                     LEFT JOIN tmpTo ON tmpTo.GoodsId = tmpFrom.GoodsId WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0)) AS tmp
                                               LEFT JOIN Object ON Object.Id = tmp.GoodsId
                                               LEFT JOIN ObjectLink ON ObjectLink.ObjectId = tmp.GoodsId
                                                                   AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure()
                                               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink.ChildObjectId
                                         ) AS tmp
                                    );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.11.16                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Check_RemainsError (inGoodsId_list:= '358;349;373', inAmount_list:= '1.1;1.1;1,1', inSession:= zfCalc_UserAdmin())
