-- Function: gpSelect_Movement_OrderInternalPackRemains_PrintSticker (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemains_PrintSticker (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPackRemains_PrintSticker(
    IN inMovementId        Integer   ,   -- ���� ���������
    IN inSession           TVarChar      -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� �� ���������
     SELECT Movement.DescId, Movement.StatusId, Movement.OperDate
   INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

     -- �������� - � ����� �������� ����� ��������
     --PERFORM lfCheck_Movement_Print (inMovementDescId:= Movement.DescId, inMovementId:= Movement.Id, inStatusId:= Movement.StatusId) FROM Movement WHERE Id = inMovementId;
     -- ����� ������ ��������
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
       /* IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF; 
        */
    END IF;

     -- ���������
     OPEN Cursor1 FOR
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId   AS GoodsId
                           , MovementItem.Amount
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                        AND MovementItem.Amount     <> 0
                     )
          , tmpMIProtocol AS(SELECT tmp.MovementItemId
                                  , MAX (tmp.OperDate) AS OperDate
                             FROM MovementItemProtocol AS tmp
                             WHERE tmp.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                             GROUP BY tmp.MovementItemId
                             )                     
       -- ���������
       SELECT
            tmpMI.Id
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Goods.Id) AS IdBarCode
           , tmpMI.Amount
           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName 
           , tmpMIProtocol.OperDate         AS Date_Update
           , CURRENT_TIMESTAMP              AS Date_Curr
       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId 

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = tmpMI.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN tmpMIProtocol ON tmpMIProtocol.MovementItemId = tmpMI.Id
               
       ORDER BY Object_Goods.ValueData
       ;        
       --�� �������� ��� + ������������ + ��� ������ +  ������� ��������� + ����� ���� ������������� � ��������� ��� ������� + ����� ����� ���������� ��������

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
28.07.25          *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_OrderInternalPackRemains_PrintSticker (inMovementId := 31827095, inSession:= '5');
