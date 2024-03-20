-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderInternal(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient Integer   , -- ����� �������
    IN inGoodsId                Integer   , -- �������������
    IN inAmount                 TFloat    , -- ����������
    IN inComment                TVarChar  ,
    IN inUserId                 Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������
     IF COALESCE (inMovementId_OrderClient, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� <����� �������> �� �����������.';
     END IF;

     -- ��������
     IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                 ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.ObjectId   = inGoodsId
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.Id         <> COALESCE (ioId, 0)
                  --
                  AND COALESCE (MIFloat_MovementId.ValueData, 0) = inMovementId_OrderClient
               )
     THEN
         RAISE EXCEPTION '������.������� <%> ��� ���������� ��� <%>.', lfGet_Object_ValueData_article (inGoodsId), lfGet_Movement_Data (inMovementId_OrderClient);
     END IF;

     -- ��������
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                        AND Movement.DescId   = zc_Movement_OrderInternal()
                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                     INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                  ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                 AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                 AND MIFloat_MovementId.ValueData      = inMovementId_OrderClient ::TFloat
                WHERE MovementItem.MovementId <> inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.ObjectId   = inGoodsId
                  AND MovementItem.isErased   = FALSE
               )
     THEN
         RAISE EXCEPTION '������.��� ���� <%> %��� ����������� �������� <����� �� ������������>.%� <%> �� <%>.'
                       , lfGet_Object_ValueData_sh (inGoodsId)
                       , CHR (13)
                       , CHR (13)
                       , (SELECT Movement.InvNumber
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.DescId   = zc_Movement_OrderInternal()
                                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                               INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                            ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                           AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                           AND MIFloat_MovementId.ValueData      = inMovementId_OrderClient ::TFloat
                          WHERE MovementItem.MovementId <> inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.ObjectId   = inGoodsId
                            AND MovementItem.isErased   = FALSE
                          ORDER BY MovementItem.Id
                          LIMIT 1
                         )
                       , (SELECT zfConvert_DateToString (Movement.OperDate)
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.DescId   = zc_Movement_OrderInternal()
                                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                               INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                            ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                           AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                           AND MIFloat_MovementId.ValueData      = inMovementId_OrderClient ::TFloat
                          WHERE MovementItem.MovementId <> inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.ObjectId   = inGoodsId
                            AND MovementItem.isErased   = FALSE
                          ORDER BY MovementItem.Id
                          LIMIT 1
                         )
                        ;
     END IF;


     -- !������!
     IF inAmount = 0
     THEN
         inAmount:= 1;
     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, NULL, inMovementId, CASE WHEN vbIsInsert = TRUE AND inAmount = 0 THEN 1 ELSE inAmount END, NULL,inUserId);

     -- ��������� �������� <����� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_OrderClient ::TFloat);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     END IF;


     -- ������� - ���
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.ParentId   = ioId
       AND MovementItem.isErased   = FALSE;

     -- ���������� ������
     PERFORM lpInsertUpdate_MI_OrderInternal_Child (ioId                     := 0
                                                  , inParentId               := ioId
                                                  , inMovementId             := inMovementId
                                                  , inObjectId               := tmpMI.ObjectId
                                                  , inReceiptLevelId         := tmpMI.ReceiptLevelId
                                                  , inColorPatternId         := tmpMI.ColorPatternId
                                                  , inProdColorPatternId     := tmpMI.ProdColorPatternId
                                                  , inProdOptionsId          := tmpMI.ProdOptionsId
                                                  , inUnitId                 := 0 -- !!!
                                                  , inAmount                 := tmpMI.Amount
                                                  , inAmountReserv           := 0
                                                  , inAmountSend             := 0
                                                  , inForCount               := tmpMI.ForCount
                                                  , inUserId                 := inUserId
                                                   )
     FROM (-- 1. ���� ��� "�����������" ����
           SELECT DISTINCT
                  CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            -- �������� � ���� ������� "�����������" ����
                            THEN MILinkObject_Goods_basis.ObjectId
                        ELSE MovementItem.ObjectId
                  END AS ObjectId
                  -- ReceiptLevel
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ReceiptLevel.ObjectId
                  END AS ReceiptLevelId
                  -- ������ Boat Structure
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ColorPattern.ObjectId
                  END AS ColorPatternId
                  -- Boat Structure
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ProdColorPattern.ObjectId
                  END AS ProdColorPatternId
                  -- Options
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ProdOptions.ObjectId
                  END AS ProdOptionsId
                  
                  --
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            -- ���-�� ��� ����� ������� "�����������" ����
                            THEN 1
                        ELSE MovementItem.Amount
                  END AS Amount
                  --
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MIFloat_ForCount.ValueData
                  END AS ForCount

           FROM MovementItem
                -- ����� ���� ����������
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                 ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                -- ����� "�����������" ���� ����������
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                 ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                --
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                 ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                 ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                --
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                 ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                 ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                            ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                           AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()

           WHERE MovementItem.MovementId = inMovementId_OrderClient
             AND MovementItem.DescId     = zc_MI_Detail()
             AND MovementItem.isErased    = FALSE
             AND (MILinkObject_Goods.ObjectId       = inGoodsId
               OR MILinkObject_Goods_basis.ObjectId = inGoodsId
                 )

          UNION
           -- �����
           SELECT 
                  MovementItem.ObjectId
                  --
                , 0 AS ReceiptLevelId
                  --
                , 0 AS ColorPatternId
                  --
                , 0 AS ProdColorPatternId
                  --
                , 0 AS ProdOptionsId
                  --
                , MovementItem.Amount
                  --
                , MIFloat_ForCount.ValueData AS ForCount

           FROM MovementItem
                -- ����� ���� ��� � ReceiptProdModel, ����������� ���� ���� ������
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                 ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                                              --AND MILinkObject_GoodsBasis.ObjectId       = inGoodsId
                LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                            ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                           AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                -- �����
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                 ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
           WHERE MovementItem.MovementId = inMovementId_OrderClient
             AND MovementItem.DescId     = zc_MI_Child()
             AND MovementItem.isErased    = FALSE
             -- �� �����
             AND MILinkObject_ProdOptions.ObjectId IS NULL
             -- ��� �����
             AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Product())

          UNION
           -- �����
           SELECT lpSelect.GoodsId AS ObjectId
                  --
                , 0 AS ReceiptLevelId
                  --
                , 0 AS ColorPatternId
                  --
                , 0 AS ProdColorPatternId
                  --
                , lpSelect.ProdOptionsId
                  -- ���-�� �����
                , lpSelect.Amount
                  --
                , 1 AS ForCount

           FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= inMovementId_OrderClient
                                            , inIsShowAll:= FALSE
                                            , inIsErased := FALSE
                                            , inIsSale   := TRUE
                                            , inSession  := inUserId :: TVarChar
                                             ) AS lpSelect
           WHERE lpSelect.MovementId_OrderClient = inMovementId_OrderClient
             AND lpSelect.ProductId              = inGoodsId
             AND lpSelect.GoodsId                > 0
             -- ��� ���� ���������
             AND COALESCE (lpSelect.ProdColorPatternId, 0) = 0
             -- ��� �����
             AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Product())
           
          ) AS tmpMI
          ;

     -- ������� - ���
     /*PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Detail()
       AND MovementItem.ParentId   = ioId
       AND MovementItem.isErased   = FALSE;*/

     -- ���������� ������
     -- ���������� ������
     PERFORM lpInsertUpdate_MI_OrderInternal_Detail (ioId                     := 0
                                                  , inParentId               := ioId
                                                  , inMovementId             := inMovementId
                                                  , inReceiptServiceId       := tmpMI.ReceiptServiceId
                                                  , inPersonalId             := NULL
                                                  , inAmount                 := 0
                                                  , inOperPrice              := 0
                                                  , inHours                  := COALESCE (tmpMI.Value_hour, 0)
                                                  , inSumm                   := 0
                                                  , inComment                := ''
                                                  , inUserId                 := inUserId
                                                   )
     FROM (WITH -- OrderInternal - ������������ ������
                tmpMI_Detail AS (SELECT MovementItem.ObjectId AS ReceiptServiceId
                                 FROM MovementItem
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Detail()
                                   AND MovementItem.isErased   = FALSE
                                   AND MovementItem.ParentId   = ioId
                                )
                -- OrderClient - ���� - Child
              , tmpOrderClient AS (SELECT -- ����
                                          MI_Child.ObjectId AS GoodsId
                                          -- ���� (�������) - ��� ���� ����� ������ �����
                                        , COALESCE (MILinkObject_GoodsBasis.ObjectId, MI_Child.ObjectId) AS GoodsId_basis
                                         -- ������ ������ ����
                                        , MILinkObject_ReceiptGoods.ObjectId AS ReceiptGoodsId
                                   FROM MovementItem AS MI_Child
                                        -- ���� (�������) 
                                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                                         ON MILinkObject_GoodsBasis.MovementItemId = MI_Child.Id
                                                                        AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                                        -- ������ ������ ����
                                        LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptGoods
                                                                         ON MILinkObject_ReceiptGoods.MovementItemId = MI_Child.Id
                                                                        AND MILinkObject_ReceiptGoods.DescId         = zc_MILinkObject_ReceiptGoods()
                                   WHERE MI_Child.MovementId = inMovementId_OrderClient
                                     AND MI_Child.DescId     = zc_MI_Child()
                                     AND MI_Child.isErased   = FALSE
                                  )
                      -- ������ ������ ���� - ������
                    , tmpReceiptItems AS (SELECT -- �������� ���� - � ������� ���� ���� �� ��
                                                 COALESCE (ObjectLink_GoodsChild.ChildObjectId, tmpOrderClient.GoodsId) AS GoodsId
                                                 -- ���� (�������) - ��� ���� ����� ������ �����
                                               , tmpOrderClient.GoodsId_basis
                                                 -- ������ ������ ����
                                               , tmpOrderClient.ReceiptGoodsId
                                                 -- ������ ������ ����
                                               , Object_ReceiptGoods.Id AS ReceiptGoodsId_find
      
                                                 -- ������
                                               , Object_ReceiptService.Id         AS ReceiptServiceId
                                               
                                                 -- ����?
                                               , ObjectFloat_ReceiptGoodsChild_Value.ValueData AS Value_hour
      
                                          FROM tmpOrderClient
                                               -- ������� ������ - ��� ������� ?��� ��������? ?��� ������?
                                               INNER JOIN ObjectLink AS ObjectLink_Goods
                                                                     ON ObjectLink_Goods.ChildObjectId = tmpOrderClient.GoodsId_basis -- tmpOrderClient.GoodsId
                                                                    AND ObjectLink_Goods.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                                               INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = ObjectLink_Goods.ObjectId -- tmpOrderClient.ReceiptGoodsId
                                                                                       AND Object_ReceiptGoods.isErased = FALSE
                                               INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                                     ON ObjectLink_ReceiptGoods.ChildObjectId = Object_ReceiptGoods.Id
                                                                    AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                               INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id = ObjectLink_ReceiptGoods.ObjectId
                                                                                            AND Object_ReceiptGoods.isErased = FALSE
                                               INNER JOIN ObjectLink AS ObjectLink_Object
                                                                     ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                                    AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                               -- ������ ���� ������
                                               INNER JOIN Object AS Object_ReceiptService
                                                                 ON Object_ReceiptService.Id     = ObjectLink_Object.ChildObjectId
                                                                AND Object_ReceiptService.DescId = zc_Object_ReceiptService()
                                               -- Value
                                               LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptGoodsChild_Value
                                                                     ON ObjectFloat_ReceiptGoodsChild_Value.ObjectId  = Object_ReceiptGoodsChild.Id
                                                                    AND ObjectFloat_ReceiptGoodsChild_Value.DescId    = zc_ObjectFloat_ReceiptGoodsChild_Value()
      
                                               -- GoodsId_child
                                               LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                                    ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                                   AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
      
                                          WHERE Object_ReceiptGoodsChild.DescId   = zc_Object_ReceiptGoodsChild()
                                            AND Object_ReceiptGoodsChild.isErased = FALSE
                                            -- ��� ����
                                            -- AND  IS NULL
                                         )
              -- ��������� - ����� ������ ���� ��������
              SELECT tmpReceiptItems.ReceiptServiceId   AS ReceiptServiceId
                   , tmpReceiptItems.Value_hour
              FROM tmpReceiptItems
                   LEFT JOIN tmpMI_Detail ON tmpMI_Detail.ReceiptServiceId = tmpReceiptItems.ReceiptServiceId
              -- ������ ��, ���� �� ��������
              WHERE tmpMI_Detail.ReceiptServiceId IS NULL
                -- �������� ����
                AND tmpReceiptItems.GoodsId = inGoodsId
          ) AS tmpMI
          ;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.12.22         *
*/

-- ����
-- SELECT * FROM