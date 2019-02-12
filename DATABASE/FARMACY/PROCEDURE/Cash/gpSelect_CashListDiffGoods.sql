-- Function: gpSelect_CashListDiff()

DROP FUNCTION IF EXISTS gpSelect_CashListDiffGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashListDiffGoods(
    IN inGoodsID       Integer,    -- ����������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id               Integer, 
               AmountDiffUser   TFloat,
               AmountDiff       TFloat,
               AmountDiffPrev   TFloat,
               AmountDiffPromo  TFloat,
               AmountDiffAll    TFloat               
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
               MovementItem.ObjectId                                                                               AS Id, 
               SUM(CASE WHEN Movement.OperDate >= CURRENT_DATE::TDateTime AND 
                   MILO_Insert.ObjectId = vbUserId THEN MovementItem.Amount END)::TFloat                           AS AmountDiffUser,
               SUM(CASE WHEN Movement.OperDate >= CURRENT_DATE::TDateTime THEN MovementItem.Amount END)::TFloat    AS AmountDiff,
               SUM(CASE WHEN Movement.OperDate < CURRENT_DATE::TDateTime THEN MovementItem.Amount END)::TFloat     AS AmountDiffPrev,
               SUM(CASE WHEN Movement.OperDate >= CURRENT_DATE::TDateTime AND 
                   MILO_DiffKind.ObjectId = 9704137 THEN MovementItem.Amount END)::TFloat                          AS AmountDiffPromo,
               SUM(CASE WHEN Movement.OperDate >= CURRENT_DATE::TDateTime AND 
                   MILO_DiffKind.ObjectId not in (9572746, 9572747, 9704137) THEN MovementItem.Amount END)::TFloat AS AmountDiffAll
       FROM Movement 
            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                                        AND MovementLinkObject_Unit.ObjectId = vbUnitId

            LEFT JOIN MovementItem ON MovementItem.MovementID = Movement.Id 

            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                             ON MILO_Insert.MovementItemId = MovementItem.Id
                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                                            
            LEFT JOIN MovementItemLinkObject AS MILO_DiffKind
                                             ON MILO_DiffKind.MovementItemId = MovementItem.Id
                                            AND MILO_DiffKind.DescId = zc_MILinkObject_DiffKind()
                                            
       WHERE Movement.OperDate >= (CURRENT_DATE - interval '1 day')::TDateTime
         AND Movement.DescId = zc_Movement_ListDiff()
         AND  MovementItem.ObjectId = inGoodsID
       GROUP BY MovementItem.ObjectId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 10.02.19                                                      *
 19.11.18                                                      *
*/

-- ����
-- 
-- SELECT * FROM gpSelect_CashListDiffGoods (inGoodsID = 1, inSession:= '3')
-- select * from gpSelect_CashListDiffGoods(inGoodsId := 373 ,  inSession := '3354092');