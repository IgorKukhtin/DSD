-- Function: gpInsert_MI_OrderPartner_byOrderClient()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderPartner_byOrderClient(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderPartner_byOrderClient(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderPartner());
     vbUserId:= lpGetUserBySession (inSession);


    --��������, ����  ���� ������ � ��� �� ������
  /*IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE AND MovementItem.DescId = zc_MI_Master())
    THEN
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ��������� ��� ���������' :: TVarChar
                                               , inProcedureName := 'gpInsert_MI_OrderPartner_byOrderClient'   :: TVarChar
                                               , inUserId        := vbUserId);
    END IF;*/


     -- ��������� �� ���������
    SELECT MovementLinkObject_From.ObjectId        AS FromId
         , MovementLinkObject_To.ObjectId          AS ToId
           INTO
               vbFromId
             , vbToId
    FROM Movement AS Movement_OrderPartner
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement_OrderPartner.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement_OrderPartner.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
    WHERE Movement_OrderPartner.Id = inMovementId
      AND Movement_OrderPartner.DescId = zc_Movement_OrderPartner();

    -- ������ ����� ����������
    CREATE TEMP TABLE _tmpMI (Id Integer, ObjectId Integer, Amount TFloat, OperPrice TFloat, CountForPrice TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMI (Id, ObjectId, Amount, OperPrice, CountForPrice)
          SELECT MovementItem.Id
               , MovementItem.ObjectId
               , MovementItem.Amount
               , MIFloat_OperPrice.ValueData                   AS OperPrice
               , COALESCE (MIFloat_CountForPrice.ValueData, 1) AS CountForPrice
          FROM MovementItem
               LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                           ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                          AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;


    -- ������ ����� ������� - zc_MI_Child - ����������� �� �����������
    CREATE TEMP TABLE _tmpMI_Child (Id Integer, ObjectId Integer, AmountPartner TFloat, OperPrice TFloat, CountForPrice TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMI_Child (Id, ObjectId, AmountPartner, OperPrice, CountForPrice)
       WITH -- ����� ������� - zc_MI_Child
            tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId
                           , MovementItem.Amount
                      FROM MovementItemLinkObject AS MILinkObject_Partner
                           INNER JOIN MovementItem ON MovementItem.Id      = MILinkObject_Partner.MovementItemId
                                                  AND MovementItem.DescId  = zc_MI_Child()
                                                  AND MovementItem.isErased = FALSE
                           INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                              AND Movement.DescId   = zc_Movement_OrderClient()
                                              -- ��� �� ���������
                                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                           -- ValueData - MovementId ������ ����������
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                       ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                      WHERE -- !!!����������� �� ����������
                            MILinkObject_Partner.ObjectId = vbToId
                        AND MILinkObject_Partner.DescId   = zc_MILinkObject_Partner()
                        -- "�������" ����� ���������� ��� ���� ����� ��� �� ��� �����������
                        AND (MIFloat_MovementId.ValueData = inMovementId OR COALESCE (MIFloat_MovementId.ValueData,0) = 0)
                     )
     , tmpMIFloat AS (SELECT MovementItemFloat.*
                      FROM MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPartner()
                                                       , zc_MIFloat_CountForPrice()
                                                        )
                     )
      -- ���������
      SELECT tmpMI.Id
           , tmpMI.ObjectId
             -- ���������� ����� ����������
           , MIFloat_AmountPartner.ValueData               AS AmountPartner
             -- ���� �� ��� ���  -- ��������� ���� ����������
           , ObjectFloat_EKPrice.ValueData                 AS OperPrice
             --
           , COALESCE (MIFloat_CountForPrice.ValueData, 1) AS CountForPrice
      FROM tmpMI
           LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                ON MIFloat_AmountPartner.MovementItemId = tmpMI.Id
                               AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
           LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                ON MIFloat_CountForPrice.MovementItemId = tmpMI.Id
                               AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                 ON ObjectFloat_EKPrice.ObjectId = tmpMI.ObjectId
                                AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
      -- ������ ��� ��� �� ����
      WHERE MIFloat_AmountPartner.ValueData > 0
     ;

    -- ������� zc_MI_Master - ����� ����������
    PERFORM lpInsertUpdate_MovementItem_OrderPartner (ioId           := COALESCE (_tmpMI.Id, 0)
                                                    , inMovementId   := inMovementId
                                                    , inGoodsId      := COALESCE (_tmpMI.ObjectId, tmpMI_Child.ObjectId)
                                                      -- ���� ���� ����������� ���-�� - ��������� ���, ����� - ��� ������ �� ����������
                                                    , inAmount       := CASE WHEN _tmpMI.Amount > 0        THEN _tmpMI.Amount        ELSE tmpMI_Child.AmountPartner END
                                                      --             
                                                    , ioOperPrice    := CASE WHEN _tmpMI.OperPrice > 0     THEN _tmpMI.OperPrice     ELSE tmpMI_Child.OperPrice END
                                                      --
                                                    , inCountForPrice:= CASE WHEN _tmpMI.CountForPrice > 0 THEN _tmpMI.CountForPrice ELSE COALESCE (tmpMI_Child.CountForPrice, 1) END
                                                      --
                                                    , inComment      := MIString_Comment.ValueData
                                                    , inUserId       := vbUserId
                                                     )
    FROM _tmpMI
         LEFT JOIN MovementItemString AS MIString_Comment
                                      ON MIString_Comment.MovementItemId = _tmpMI.Id
                                     AND MIString_Comment.DescId         = zc_MIString_Comment()
         -- ������� ������ �������
         FULL JOIN (SELECT _tmpMI_Child.ObjectId
                         , _tmpMI_Child.CountForPrice
                         , _tmpMI_Child.OperPrice
                         , SUM (_tmpMI_Child.AmountPartner) AS AmountPartner
                    FROM _tmpMI_Child
                    GROUP BY _tmpMI_Child.ObjectId
                           , _tmpMI_Child.CountForPrice
                           , _tmpMI_Child.OperPrice
                    ) AS tmpMI_Child ON tmpMI_Child.ObjectId = _tmpMI.ObjectId
    ;


    -- � ������� ������� - zc_MI_Child - ����������� �� ����������� - c�������� ��� ����� ���������� ������
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), _tmpMI_Child.Id, inMovementId)
    FROM _tmpMI_Child
   ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.04.21         *
*/

-- ����
--