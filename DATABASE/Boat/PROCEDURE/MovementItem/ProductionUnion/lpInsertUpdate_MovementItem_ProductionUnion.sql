-- Function: gpInsertUpdate_MovementItem_ProductionUnion()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProductionUnion(Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProductionUnion(Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProductionUnion(Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ProductionUnion(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient Integer   , -- ����� �������
    IN inObjectId            Integer   , -- �������������
    IN inReceiptProdModelId  Integer   , --
    IN inAmount              TFloat    , -- ����������
    IN inComment             TVarChar  ,
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������
     IF COALESCE (inReceiptProdModelId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <������ ������ ������ ��� ����>.';
     END IF;

     -- ��������
     IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                 ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.ObjectId   = inObjectId
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.Id         <> COALESCE (ioId, 0)
                  --
                  AND COALESCE (MIFloat_MovementId.ValueData, 0) = zc_MIFloat_MovementId()
               )
     THEN
         RAISE EXCEPTION '������.������� <%> ��� ���������� ��� <%>.', lfGet_Object_ValueData_article (inObjectId), lfGet_Movement_Data (inMovementId_OrderClient);
     END IF;


     -- !������!
     IF inAmount = 0
     THEN
         inAmount:= 1;
     END IF;

     -- !������!
     IF COALESCE (inMovementId_OrderClient, 0) = 0
     THEN
         inMovementId_OrderClient:= (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId);
     END IF;

     -- ���� ��� �����
     IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId = zc_Object_Product())
     THEN
         -- ��������
         IF COALESCE (inMovementId_OrderClient, 0) = 0
         THEN
             RAISE EXCEPTION '������.����� ������� �� ����������.';
         END IF;

         -- ��������� � �����
         UPDATE Movement SET ParentId = inMovementId_OrderClient WHERE Movement.Id = inMovementId AND COALESCE (Movement.ParentId, 0) <> inMovementId_OrderClient;

     ELSE -- IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.ParentId > 0) THEN
     
         -- ��������
         -- UPDATE Movement SET ParentId = NULL WHERE Movement.Id = inMovementId;
         -- !������!
         -- inMovementId_OrderClient:= 0;

         -- ��������� � �����
         UPDATE Movement SET ParentId = inMovementId_OrderClient WHERE Movement.Id = inMovementId AND COALESCE (Movement.ParentId, 0) <> inMovementId_OrderClient;

     END IF;


     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inObjectId, NULL, inMovementId, inAmount, NULL,inUserId);


     -- ��������� �������� <����� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_OrderClient ::TFloat);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptProdModel(), ioId, inReceiptProdModelId);

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


     -- ������ ��������� ����������� zc_MI_Child  
     PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId                := 0
                                                    , inParentId          := ioId
                                                    , inMovementId        := inMovementId
                                                    , inObjectId          := tmpMI.GoodsId
                                                    , inReceiptLevelId    := tmpMI.ReceiptLevelId
                                                    , inColorPatternId    := tmpMI.ColorPatternId
                                                    , inProdColorPatternId:= tmpMI.ProdColorPatternId
                                                    , inProdOptionsId     := tmpMI.ProdOptionsId
                                                    , inAmount            := tmpMI.Amount     ::TFloat
                                                    , inForCount          := tmpMI.ForCount   ::TFloat
                                                    , inUserId            := inUserId
                                                     )
     FROM (
           WITH
           -- �������� �� ������ �� ������
           tmpOrderInternal AS (SELECT MovementItem.MovementId AS MovementId_OrderInternal
                                FROM MovementItemFloat AS MIFloat_MovementId 
                                     INNER JOIN MovementItem ON MovementItem.Id = MIFloat_MovementId.MovementItemId
                                     INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                        AND Movement.DescId = zc_Movement_OrderInternal()
                                WHERE MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                 AND MIFloat_MovementId.ValueData = inMovementId_OrderClient
                                 AND MovementItem.ObjectId = inObjectId
                                )

         , tmpMI AS (SELECT MovementItem.*
                     FROM tmpOrderInternal
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpOrderInternal.MovementId_OrderInternal
                                                AND MovementItem.DescId = zc_MI_Child()
                                                AND MovementItem.isErased   = FALSE

                         INNER JOIN MovementItem AS MI_Master ON MI_Master.Id = MovementItem.ParentId
                                                AND MI_Master.DescId = zc_MI_Master()
                                                AND MI_Master.ObjectId = inObjectId
                                                AND MI_Master.isErased   = FALSE
                         INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                      ON MIFloat_MovementId.MovementItemId = MI_Master.Id
                                                     AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                     AND MIFloat_MovementId.ValueData      = inMovementId_OrderClient
                     )
         SELECT MovementItem.ObjectId          AS GoodsId
              , MILO_ReceiptLevel.ObjectId     AS ReceiptLevelId
              , MILO_ColorPattern.ObjectId     AS ColorPatternId
              , MILO_ProdColorPattern.ObjectId AS ProdColorPatternId
              , MILO_ProdOptions.ObjectId      AS ProdOptionsId
              , MIFloat_ForCount.ValueData     AS ForCount
              , MovementItem.Amount            AS Amount
         FROM tmpMI AS MovementItem
           LEFT JOIN MovementItemLinkObject AS MILO_ReceiptLevel
                                            ON MILO_ReceiptLevel.MovementItemId = MovementItem.Id
                                           AND MILO_ReceiptLevel.DescId          = zc_MILinkObject_ReceiptLevel()
           LEFT JOIN MovementItemLinkObject AS MILO_ColorPattern
                                            ON MILO_ColorPattern.MovementItemId = MovementItem.Id
                                           AND MILO_ColorPattern.DescId = zc_MILinkObject_ColorPattern()
           LEFT JOIN MovementItemLinkObject AS MILO_ProdColorPattern
                                            ON MILO_ProdColorPattern.MovementItemId = MovementItem.Id
                                           AND MILO_ProdColorPattern.DescId = zc_MILinkObject_ProdColorPattern()
           LEFT JOIN MovementItemLinkObject AS MILO_ProdOptions
                                            ON MILO_ProdOptions.MovementItemId = MovementItem.Id
                                           AND MILO_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
           LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                       ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                      AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
        ) AS tmpMI;
        
 
       -- ���� ������ �� ������ ��� ����� ����� �� ������� 
       IF NOT EXISTS (SELECT 1
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Child()
                        AND MovementItem.ParentId   = ioId
                        AND MovementItem.isErased   = FALSE) 
       THEN
           --
           PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId                := 0
                                                          , inParentId          := ioId
                                                          , inMovementId        := inMovementId
                                                          , inObjectId          := tmpReceiptGoodsChild.GoodsId
                                                          , inReceiptLevelId    := tmpReceiptGoodsChild.ReceiptLevelId
                                                          , inColorPatternId    := tmpReceiptGoodsChild.ColorPatternId
                                                          , inProdColorPatternId:= tmpReceiptGoodsChild.ProdColorPatternId
                                                          , inProdOptionsId     := tmpReceiptGoodsChild.ProdOptionsId
                                                          , inAmount            := tmpReceiptGoodsChild.Value * inAmount
                                                          , inForCount          := 1
                                                          , inUserId            := inUserId
                                                           )
           FROM (WITH
                tmpReceiptGoodsChild AS (SELECT ObjectLink_Goods_master.ChildObjectId      AS GoodsId_master
                                              , ObjectLink_Object.ChildObjectId            AS GoodsId
                                              , ObjectLink_GoodsChild.ChildObjectId        AS GoodsId_child
                                              , ObjectLink_ReceiptLevel.ChildObjectId      AS ReceiptLevelId
                                              , ObjectLink_ColorPattern.ChildObjectId      AS ColorPatternId
                                              , ObjectLink_ProdColorPattern.ChildObjectId  AS ProdColorPatternId
                                              , ObjectFloat_Value.ValueData                AS Value
                                         FROM ObjectLink AS ObjectLink_ReceiptGoods
                                              -- ����� ���� ����������
                                              LEFT JOIN ObjectLink AS ObjectLink_Goods_master
                                                                   ON ObjectLink_Goods_master.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                                  AND ObjectLink_Goods_master.DescId   = zc_ObjectLink_ReceiptGoods_Object()
                                              -- ������
                                              LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                                   ON ObjectLink_ColorPattern.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                                  AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ReceiptGoods_ColorPattern()

                                              INNER JOIN Object AS Object_ReceiptGoodsChild
                                                                ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoods.ObjectId
                                                               -- �� ������
                                                               AND Object_ReceiptGoodsChild.isErased = FALSE

                                              LEFT JOIN ObjectLink AS ObjectLink_Object
                                                                   ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                                  AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                              INNER JOIN Object AS Object_Object
                                                                ON Object_Object.Id     = ObjectLink_Object.ChildObjectId
                                                               -- ��� �� ������ � �� ������ Boat Structure
                                                               AND Object_Object.DescId = zc_Object_Goods()

                                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                                   ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                                  AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()

                                              -- �������� � ������
                                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                                     ON ObjectFloat_Value.ObjectId  = Object_ReceiptGoodsChild.Id
                                                                    AND ObjectFloat_Value.DescId    = zc_ObjectFloat_ReceiptGoodsChild_Value()
                                                                    AND ObjectFloat_Value.ValueData > 0
                                              -- "�����������" ���� ������
                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                                   ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                                  AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                              -- Boat Structure
                                              LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                                   ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                                                  AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()

                                         WHERE ObjectLink_ReceiptGoods.ChildObjectId = inReceiptProdModelId
                                           AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                        )
               , tmpReceiptProdModel AS (SELECT 0                           AS GoodsId_master
                                              , MovementItem.ObjectId       AS GoodsId
                                              , 0                           AS GoodsId_child
                                              , MILO_ReceiptLevel.ObjectId  AS ReceiptLevelId
                                              , MovementItem.Amount         AS Amount
                                         FROM MovementItem
                                              LEFT JOIN MovementItemLinkObject AS MILO_ReceiptLevel
                                                                               ON MILO_ReceiptLevel.MovementItemId = MovementItem.Id
                                                                              AND MILO_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()

                                              LEFT JOIN MovementItemLinkObject AS MILO_ProdOptions
                                                                               ON MILO_ProdOptions.MovementItemId = MovementItem.Id
                                                                              AND MILO_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()

                                         WHERE MovementItem.MovementId = inMovementId_OrderClient
                                           AND MovementItem.isErased   = FALSE
                                           AND MovementItem.DescId     = zc_MI_Child()
                                           -- !!!�� �����!!!
                                           AND MILO_ProdOptions.ObjectId IS NULL
                                           -- !!!
                                           AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId = zc_Object_Product())
                                        )
                 -- �����
               , tmpProdOptItems AS (SELECT lpSelect.GoodsId
                                          , lpSelect.ProdOptionsId
                                            -- ���-�� �����
                                          , lpSelect.Amount
                                     FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= inMovementId_OrderClient
                                                                      , inIsShowAll:= FALSE
                                                                      , inIsErased := FALSE
                                                                      , inIsSale   := TRUE
                                                                      , inSession  := inUserId :: TVarChar
                                                                       ) AS lpSelect
                                     WHERE lpSelect.MovementId_OrderClient = inMovementId_OrderClient
                                       AND lpSelect.ProductId              = inObjectId
                                       AND lpSelect.GoodsId                > 0
                                       -- ��� ���� ���������
                                       AND COALESCE (lpSelect.ProdColorPatternId, 0) = 0
                                    )

           -- 1. ���� ��� "�����������" ���� ������
           SELECT tmpReceiptGoodsChild.GoodsId
                , tmpReceiptGoodsChild.ReceiptLevelId
                , tmpReceiptGoodsChild.ColorPatternId
                , tmpReceiptGoodsChild.ProdColorPatternId
                , 0 AS ProdOptionsId
                , tmpReceiptGoodsChild.Value
           FROM tmpReceiptGoodsChild
           WHERE tmpReceiptGoodsChild.GoodsId_child = inObjectId

         UNION ALL
           -- 2.1. ���� ��� ������ ����
           SELECT tmpReceiptGoodsChild.GoodsId
                , tmpReceiptGoodsChild.ReceiptLevelId
                , tmpReceiptGoodsChild.ColorPatternId
                , tmpReceiptGoodsChild.ProdColorPatternId
                , 0 AS ProdOptionsId
                , tmpReceiptGoodsChild.Value
           FROM tmpReceiptGoodsChild
           WHERE tmpReceiptGoodsChild.GoodsId_master = inObjectId
              -- ��������� �������������� ���� ������
             AND tmpReceiptGoodsChild.GoodsId_child IS NULL
             -- ���� ���
             AND tmpReceiptGoodsChild.GoodsId NOT IN (SELECT DISTINCT tmpCheck.GoodsId_child FROM tmpReceiptGoodsChild AS tmpCheck WHERE tmpCheck.GoodsId_child > 0)

         UNION ALL
           -- 2.2. ���� ��� "�����������" � ������ ����
           SELECT DISTINCT
                  tmpReceiptGoodsChild.GoodsId_child AS GoodsId
                , 0                                  AS ReceiptLevelId
                , 0                                  AS ColorPatternId
                , 0                                  AS ProdColorPatternId
                , 0                                  AS ProdOptionsId
                  -- ������
                , 1 AS Value
           FROM tmpReceiptGoodsChild
           WHERE tmpReceiptGoodsChild.GoodsId_master = inObjectId
              -- ��������� �������������� ���� ������
             AND tmpReceiptGoodsChild.GoodsId_child > 0

         UNION ALL
           -- 3.1. ���� ��� ������ �����
           SELECT tmpReceiptProdModel.GoodsId
                , tmpReceiptProdModel.ReceiptLevelId
                , 0 AS ColorPatternId
                , 0 AS ProdColorPatternId
                , 0 AS ProdOptionsId
                  --
                , tmpReceiptProdModel.Amount

           FROM tmpReceiptProdModel

         UNION ALL
           -- 3.2. �������� �����, ���� ��� ������ �����
           SELECT tmpProdOptItems.GoodsId
                , 0 AS ReceiptLevelId
                , 0 AS ColorPatternId
                , 0 AS ProdColorPatternId
                , tmpProdOptItems.ProdOptionsId
                  -- ���-�� �����
                , tmpProdOptItems.Amount

           FROM tmpProdOptItems

          ) AS tmpReceiptGoodsChild
         ;   

     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.11.23         *
 04.01.23         *
 12.07.21         *
*/

-- ����
-- SELECT * FROM
