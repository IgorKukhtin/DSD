-- Function: gpSelect_CashListDiffPeriod()

DROP FUNCTION IF EXISTS gpSelect_CashListDiffPeriod (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashListDiffPeriod(
    IN inDateStart     TDateTime,  -- ���� ������
    IN inDateFinal     TDateTime,  -- ���� ���������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id              Integer, 
               GoodsCode       Integer, 
               GoodsName       TVarChar,
               Price           TFloat,
               AmountDiffUser  TFloat,
               AmountDiff      TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ListDiff());
     vbUserId:= lpGetUserBySession (inSession);

    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    
    
    -- ����� <�������� ����>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
   
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey ::Integer;


     RETURN QUERY

       SELECT
               MovementItem.ObjectId                                                               AS Id, 
               Object_Goods.ObjectCode                                                             AS GoodsCode,
               Object_Goods.ValueData                                                              AS GoodsName,
               MAX(MIFloat_Price.ValueData)::TFloat                                                AS Price,
               SUM(CASE WHEN MILO_Insert.ObjectId = vbUserId THEN MovementItem.Amount END)::TFloat AS AmountDiffUser,
               SUM(MovementItem.Amount)::TFloat                                                    AS AmountDiff
       FROM Movement 
            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                                        AND MovementLinkObject_Unit.ObjectId = vbUnitId

            LEFT JOIN MovementItem ON MovementItem.MovementID = Movement.Id 

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                             ON MILO_Insert.MovementItemId = MovementItem.Id
                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
       WHERE Movement.OperDate >= inDateStart
         AND Movement.OperDate < inDateFinal + INTERVAL '1 DAY'
         AND Movement.DescId = zc_Movement_ListDiff()
       GROUP BY MovementItem.ObjectId, Object_Goods.ObjectCode, Object_Goods.ValueData;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 11.11.18                                                      *
*/

-- ����
-- 
-- SELECT * FROM gpSelect_CashListDiffPeriod (inDateStart := ('01.11.2018')::TDateTime , inDateFinal := ('30.11.2018')::TDateTime , inSession:= '3')
-- select * from gpSelect_CashListDiffPeriod(inDateStart := ('01.11.2018')::TDateTime , inDateFinal := ('30.11.2018')::TDateTime , inSession := '3354092');
