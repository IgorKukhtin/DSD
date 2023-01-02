-- Function: gpInsert_MI_Send_byOrder_Detail()

DROP FUNCTION IF EXISTS gpInsert_MI_Send_byOrder_Detail(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_Send_byOrder_Detail(
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient Integer   , -- ����� �������
    IN inGoodsId                Integer   , -- ������������� ��� ����� ����
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbUnitId_From  Integer;
  DECLARE vbUnitId_To    Integer;
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


    -- ������ �� ������ - ����� ����������� - ������������� ��� ������ �����
    CREATE TEMP TABLE _tmpOrder (MovementId_order Integer, ObjectId Integer, Amount NUMERIC(16, 8)) ON COMMIT DROP;
    INSERT INTO _tmpOrder (MovementId_order, ObjectId, Amount)
       WITH
            tmpMI_Child AS (-- ����� ������� - zc_MI_Detail - �������������
                            SELECT MI_Detail.MovementId   AS MovementId_order
                                 , MI_Detail.ObjectId
                                   -- ���������� ������ ������
                                 , zfCalc_Value_ForCount (MI_Detail.Amount, MIFloat_ForCount.ValueData) AS Amount
                            FROM Movement
                                 INNER JOIN MovementItem AS MI_Detail
                                                         ON MI_Detail.MovementId = Movement.Id
                                                        AND MI_Detail.DescId     = zc_MI_Detail()
                                                        AND MI_Detail.isErased   = FALSE
                                 LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                             ON MIFloat_ForCount.MovementItemId = MI_Detail.Id
                                                            AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                                 -- ����� "�����������" ���� ����������
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                                  ON MILinkObject_GoodsBasis.MovementItemId = MI_Detail.Id
                                                                 AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                                 -- ����� ���� ����������
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                  ON MILinkObject_Goods.MovementItemId = MI_Detail.Id
                                                                 AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()

                            WHERE Movement.Id      = inMovementId_OrderClient
                              AND Movement.DescId = zc_Movement_OrderClient()
                              -- ��� ������ ���� ����������
                              AND (MILinkObject_Goods.ObjectId = inGoodsId OR inGoodsId = 0)
                              -- ��� ������������� ��� ������ "�����������" �����
                              AND MILinkObject_GoodsBasis.ObjectId IS NULL

                           UNION ALL
                            -- ����� ������� - zc_MI_Detail - ������������� ��� "�����������" �����
                            SELECT MI_Detail.MovementId   AS MovementId_order
                                 , MI_Detail.ObjectId
                                   -- ���������� ������ ������
                                 , zfCalc_Value_ForCount (MI_Detail.Amount, MIFloat_ForCount.ValueData) AS Amount
                            FROM Movement
                                 INNER JOIN MovementItem AS MI_Detail
                                                         ON MI_Detail.MovementId = Movement.Id
                                                        AND MI_Detail.DescId     = zc_MI_Detail()
                                                        AND MI_Detail.isErased   = FALSE
                                 LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                             ON MIFloat_ForCount.MovementItemId = MI_Detail.Id
                                                            AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                                 -- ����� "�����������" ���� ����������
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                                  ON MILinkObject_GoodsBasis.MovementItemId = MI_Detail.Id
                                                                 AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                            WHERE Movement.Id      = inMovementId_OrderClient
                              AND Movement.DescId = zc_Movement_OrderClient()
                              -- ���� "�����������" ����
                              AND MILinkObject_GoodsBasis.ObjectId > 0
                              -- ��� ������ "������������" ���� ����������
                              AND (MILinkObject_GoodsBasis.ObjectId = inGoodsId OR inGoodsId = 0)
                           )
     -- ������� �������� ��� �����������
     SELECT tmpMI_Child.MovementId_order
          , tmpMI_Child.ObjectId
            -- ������� ��������
          --, tmpMI_Child.Amount - COALESCE (tmpMI_Send.Amount, 0) AS Amount
          , tmpMI_Child.Amount AS Amount

     FROM (SELECT tmpMI_Child.MovementId_order, tmpMI_Child.ObjectId, SUM (tmpMI_Child.Amount) AS Amount
           FROM tmpMI_Child
           GROUP BY tmpMI_Child.MovementId_order, tmpMI_Child.ObjectId
          ) AS tmpMI_Child
     -- !! �������� ��� ����������!!!
     WHERE tmpMI_Child.Amount >= 0
    ;

    -- test
    --RAISE EXCEPTION '%', (select count(*)  from _tmpOrder);

    -- ��������� - zc_MI_Master - ����� �����������
    PERFORM lpInsertUpdate_MovementItem_Send (ioId                     := COALESCE (_tmpMI_Master.Id, 0)
                                            , inMovementId             := inMovementId
                                            , inMovementId_OrderClient := COALESCE (_tmpOrder.MovementId_order, _tmpMI_Master.MovementId_order) :: Integer
                                            , inGoodsId                := COALESCE (_tmpOrder.ObjectId, _tmpMI_Master.ObjectId)
                                            , inAmount                 := COALESCE (_tmpOrder.Amount, _tmpMI_Master.Amount)
                                            , inOperPrice              := COALESCE (_tmpOrder.OperPrice, _tmpMI_Master.OperPrice, 0)
                                            , inCountForPrice          := COALESCE (_tmpOrder.CountForPrice, _tmpMI_Master.CountForPrice, 1)
                                            , inPartNumber             := COALESCE (_tmpMI_Master.PartNumber,'') ::TVarChar
                                            , inComment                := COALESCE (_tmpMI_Master.Comment,'') ::TVarChar
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
                           -- ����� ������� 
                         , _tmpOrder.MovementId_order

                    FROM _tmpOrder
                         LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                               ON ObjectFloat_EKPrice.ObjectId = _tmpOrder.ObjectId
                                              AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                    GROUP BY _tmpOrder.ObjectId
                           , ObjectFloat_EKPrice.ValueData
                           , _tmpOrder.MovementId_order
                    ) AS _tmpOrder
                      ON _tmpOrder.ObjectId         = _tmpMI_Master.objectId
                     AND _tmpOrder.MovementId_order = _tmpMI_Master.MovementId_order
    ;


    -- �������� zc_MI_Master ���-�� = 0
    /*PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE
      AND MovementItem.Amount     = 0
   ;*/


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.12.22         *
*/

-- ����
-- SELECT * FROM gpInsert_MI_Send_byOrder_Detail(inMovementId := 663 , inMovementId_OrderClient := 662 , inGoodsId:= 253170 ,  inSession := '5');
