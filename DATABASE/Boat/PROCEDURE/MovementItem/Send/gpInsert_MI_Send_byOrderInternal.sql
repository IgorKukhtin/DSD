-- Function: gpInsert_MI_Send_byOrderInternal()

DROP FUNCTION IF EXISTS gpInsert_MI_Send_byOrderInternal (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_Send_byOrderInternal(
    IN inMovementId               Integer   , -- ���� ������� <��������>
    IN inMovementId_Order         Integer   , -- ����� ������������
    IN inGoodsId                  Integer   , -- ����
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId       Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderPartner());
     vbUserId:= lpGetUserBySession (inSession);


    --��������, ����  ���� ������ � ��� �� ������
  /*IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE AND MovementItem.DescId = zc_MI_Child())
    THEN
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ��������� ��� ���������' :: TVarChar
                                               , inProcedureName := 'gpInsert_MI_Send_auto'   :: TVarChar
                                               , inUserId        := vbUserId);
    END IF;*/

    -- zc_MI_Master - ������� �����������
    CREATE TEMP TABLE _tmpMI_Master (Id Integer, ObjectId Integer, Amount TFloat, MovementId_order Integer, PartNumber TVarChar, Comment TVarChar, OperPrice TFloat, CountForPrice TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMI_Master (Id, ObjectId, Amount, MovementId_order, PartNumber, Comment, OperPrice, CountForPrice)
          SELECT MovementItem.Id
               , MovementItem.ObjectId
               , MovementItem.Amount
               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
               , MIString_PartNumber.ValueData           AS PartNumber
               , MIString_Comment.ValueData              AS Comment
               , MIFloat_OperPrice.ValueData             AS OperPrice
               , MIFloat_CountForPrice.ValueData         AS CountForPrice
          FROM MovementItem
               -- MovementId ����� �������
               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
               --
               LEFT JOIN MovementItemString AS MIString_PartNumber
                                            ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                           AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()
               --
               LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                           ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                          AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice() 
               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                          AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice() 
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;

    -- ������ �� OrderInternal - ����� ����������� - ������������� ��� ������ �����
    CREATE TEMP TABLE _tmpOrder (MovementId_order Integer, ObjectId Integer, Amount NUMERIC(16, 8)) ON COMMIT DROP;
    INSERT INTO _tmpOrder (MovementId_order, ObjectId, Amount)
       WITH
            tmpMI_Child AS (-- ����� - zc_MI_Detail - �������������
                            SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                                 , MI_Child.ObjectId
                                 , SUM (zfCalc_Value_ForCount (MI_Child.Amount, MIFloat_ForCount.ValueData)) AS Amount
                            FROM Movement
                                 -- ����� ���� ����������
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                                        -- ��� ������ ���� ����������
                                                        AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                                 -- MovementId ����� �������
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                 -- �������������
                                 INNER JOIN MovementItem AS MI_Child
                                                         ON MI_Child.MovementId = Movement.Id
                                                        AND MI_Child.DescId     = zc_MI_Child()
                                                        AND MI_Child.ParentId   = MovementItem.Id
                                                        AND MI_Child.isErased   = FALSE
                                 LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                             ON MIFloat_ForCount.MovementItemId = MI_Child.Id
                                                            AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()

                            WHERE Movement.Id     = inMovementId_Order
                              AND Movement.DescId = zc_Movement_OrderInternal()

                            GROUP BY MIFloat_MovementId.ValueData :: Integer
                                   , MI_Child.ObjectId
                            )

     -- ������� �������� ��� �����������
     SELECT tmpMI_Child.MovementId_order
          , tmpMI_Child.ObjectId
            -- ������� ��������
          , tmpMI_Child.Amount
     FROM tmpMI_Child
          -- !!!�� ��!!!
          INNER JOIN Object AS Object_Goods ON Object_Goods.Id        = tmpMI_Child.ObjectId
                                           AND Object_Goods.ValueData NOT ILIKE '��%'
     WHERE tmpMI_Child.Amount >= 0
       -- !!!������ ����� ���-��!!!
       AND tmpMI_Child.Amount :: Integer = tmpMI_Child.Amount
       -- !!!�� "�����������" ����!!!
       AND tmpMI_Child.ObjectId NOT IN (SELECT OL.ChildObjectId
                                        FROM ObjectLink AS OL
                                             -- �� ������
                                             INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = OL.ObjectId
                                                                                          AND Object_ReceiptGoodsChild.isErased = FALSE

                                             INNER JOIN ObjectLink AS OL_ReceiptGoodsChild_ReceiptGoods
                                                                   ON OL_ReceiptGoodsChild_ReceiptGoods.ObjectId = OL.ObjectId
                                                                  AND OL_ReceiptGoodsChild_ReceiptGoods.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                             -- �� ������
                                             INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = OL_ReceiptGoodsChild_ReceiptGoods.ChildObjectId
                                                                                     AND Object_ReceiptGoods.isErased = FALSE
                                        WHERE OL.DescId        = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                          AND OL.ChildObjectId > 0
                                       )
    ;

    -- test
    --RAISE EXCEPTION '%', (select count(*)  from _tmpOrder);


    -- ��������� - zc_MI_Master - ����� �����������
    PERFORM lpInsertUpdate_MovementItem_Send (ioId                     := COALESCE (_tmpMI_Master.Id, 0)
                                            , inMovementId             := inMovementId
                                            , inMovementId_OrderClient := COALESCE (tmp.MovementId_order, _tmpMI_Master.MovementId_order) :: Integer
                                            , inGoodsId                := COALESCE (tmp.ObjectId, _tmpMI_Master.ObjectId)
                                            , inAmount                 := COALESCE (tmp.Amount, _tmpMI_Master.Amount)
                                            , inOperPrice              := COALESCE (tmp.OperPrice, 0)
                                            , inCountForPrice          := COALESCE (tmp.CountForPrice, 1)
                                            , inPartNumber             := COALESCE (_tmpMI_Master.PartNumber,'') ::TVarChar
                                            , inComment                :='' ::TVarChar
                                            , inUserId                 := vbUserId
                                             )
    FROM _tmpMI_Master
         -- ����������� ������������ ������ � ������ �������
         FULL JOIN (-- ���������� ������ ������
                    SELECT _tmpOrder.ObjectId
                           -- ������������ ����, � ������� ������
                         , ObjectFloat_EKPrice.ValueData AS OperPrice
                         , 1 :: TFloat AS CountForPrice
                         , SUM (_tmpOrder.Amount) AS Amount
                          -- �����
                         , _tmpOrder.MovementId_order
                    FROM _tmpOrder
                         LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                               ON ObjectFloat_EKPrice.ObjectId = _tmpOrder.ObjectId
                                              AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                    GROUP BY _tmpOrder.ObjectId
                           , ObjectFloat_EKPrice.ValueData
                           , _tmpOrder.MovementId_order
                    ) AS tmp ON tmp.ObjectId = _tmpMI_Master.objectId
                            AND tmp.MovementId_order = _tmpMI_Master.MovementId_order
    ;

/*
    -- �������� zc_MI_Master ���-�� = 0
    PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE
      AND MovementItem.Amount     = 0
   ;
*/

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.12.22         *
*/

-- ����
-- SELECT * FROM gpInsert_MI_Send_byOrder(inMovementId := 663 , inMovementId_Order := 662 , inGoodsId := 253170 ,  inSession := '5');
