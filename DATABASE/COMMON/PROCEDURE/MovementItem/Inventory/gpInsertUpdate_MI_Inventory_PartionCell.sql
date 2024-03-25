-- Function: gpInsertUpdate_MI_Inventory_PartionCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Inventory_PartionCell (Integer, Integer, TVarChar, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Inventory_PartionCell (Integer, Integer, TVarChar, Boolean, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Inventory_PartionCell (Integer, Integer, Integer, Integer, TFloat, TVarChar, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Inventory_PartionCell(
    IN inId                      Integer   , -- ���� ������� <������� ���������>
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inGoodsId                 Integer   , -- 
    IN inGoodsKindId             Integer   , -- 
    IN inAmount                  TFloat,
 INOUT ioPartionCellName_1       TVarChar   , --
    IN inisPartionCell_Close_1   Boolean    ,
    IN inPartionGoodsDate        TDateTime , -- ���� ������
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId           Integer;
   DECLARE vbPartionCellId    Integer;
   --DECLARE vbGoodsId          Integer;
   --DECLARE vbGoodsKindId      Integer;
   DECLARE vbPartionGoodsDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     IF COALESCE (inId, 0) = 0
     THEN
         RETURN;
     END IF;


     --����� �������� ����� / ��� ������ / ���-�� ������� ���������
     PERFORM lpInsertUpdate_MovementItem_Inventory (ioId                 := inId
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := inGoodsId
                                                  , inAmount             := inAmount
                                                  , inPartionGoodsDate   := tmp.PartionGoodsDate 
                                                  , inPrice              := COALESCE (tmp.Price,0)    ::TFloat
                                                  , inSumm               := COALESCE (tmp.Summ ,0)    ::TFloat
                                                  , inHeadCount          := COALESCE (tmp.HeadCount,0)    ::TFloat
                                                  , inCount              := COALESCE (tmp.Count,0)    ::TFloat
                                                  , inPartionGoods       := tmp.PartionGoods 
                                                  , inPartNumber         := tmp.PartNumber
                                                  , inPartionGoodsId     := tmp.PartionGoodsId
                                                  , inGoodsKindId        := inGoodsKindId
                                                  , inGoodsKindCompleteId:= tmp.GoodsKindId_Complete
                                                  , inAssetId            := tmp.AssetId
                                                  , inUnitId             := tmp.UnitId
                                                  , inStorageId          := tmp.StorageId
                                                  , inPartionModelId     := tmp.PartionModelId
                                                  , inUserId             := vbUserId
                                                   )
     FROM gpSelect_MovementItem_Inventory (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS tmp
     WHERE tmp.Id = inId;

     -- �����
     SELECT MIDate_PartionGoods.ValueData
            INTO vbPartionGoodsDate
     FROM MovementItem
          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                     ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                    AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
     WHERE MovementItem.Id = inId
    ;


     --  1
     IF COALESCE (ioPartionCellName_1, '') <> '' AND TRIM (ioPartionCellName_1) <> '0'
     THEN
         -- !!!����� �� !!!
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (ioPartionCellName_1) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_1)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ValueData ILIKE TRIM (ioPartionCellName_1)
                                  AND Object.DescId    = zc_Object_PartionCell()
                               );
         END IF;

         -- ���� �� �����
         IF COALESCE (vbPartionCellId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ � % = <%>.'
                           , CASE WHEN zfConvert_StringToNumber (ioPartionCellName_1) > 0 THEN '����� =' ELSE '��������� =' END
                           , ioPartionCellName_1
                            ;
         END IF;


         -- ��� ������ ����� ���� ��������� ������ ���� ������
         IF 1=1 AND vbPartionCellId > 0 
         -- ��������
         AND EXISTS (SELECT 1
                     FROM MovementItem
                          INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                       ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                      AND MIFloat_PartionCell.ValueData      = vbPartionCellId :: TFloat
                          LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                           ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                          LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                     ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                    AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = FALSE
                       AND MovementItem.Id         <> COALESCE (inId, 0)
                       -- ���� ������ ������ ��� ����� � ���� ������
                       AND (MovementItem.ObjectId <> inGoodsId
                         OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                         OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (vbPartionGoodsDate, zc_DateStart())
                           )
                    )
          THEN
              RAISE EXCEPTION '������.� ��������� <��������������> � <%> �� <%> %��� ������ <%> %����� ���� ��������� ������ ������% <%> %� ����� <%>.'
                             , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                             , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                            , CHR (13)
                            , lfGet_Object_ValueData (vbPartionCellId)
                            , CHR (13)
                            , CHR (13)
                            , (SELECT DISTINCT lfGet_Object_ValueData (MovementItem.ObjectId) || '> <' || lfGet_Object_ValueData_sh (MILO_GoodsKind.ObjectId)
                               FROM MovementItem
                                    INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                                 ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                                AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                                AND MIFloat_PartionCell.ValueData      = vbPartionCellId :: TFloat
                                    LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                     ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                    AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
              
                                    LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                               ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                              AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                                 AND MovementItem.Id         <> COALESCE (inId, 0)
                                 -- ���� ������ ������ ��� ����� � ���� ������
                                 AND (MovementItem.ObjectId <> inGoodsId
                                   OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                                   OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (vbPartionGoodsDate, zc_DateStart())
                                     )
                              )
                            , CHR (13)
                            , (SELECT DISTINCT zfConvert_DateToString (MID_PartionGoodsDate.ValueData)
                               FROM MovementItem
                                    INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                                 ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                                AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                                AND MIFloat_PartionCell.ValueData      = vbPartionCellId :: TFloat
                                    LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                     ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                    AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
              
                                    LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                               ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                              AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                                 AND MovementItem.Id         <> COALESCE (inId, 0)
                                 -- ���� ������ ������ ��� ����� � ���� ������
                                 AND (MovementItem.ObjectId <> inGoodsId
                                   OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                                   OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (vbPartionGoodsDate, zc_DateStart())
                                     )
                              )
                             ;
          END IF;

         -- ��������� ����� � <������ ��������>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell(), inId, vbPartionCellId :: TFloat);

         --
         ioPartionCellName_1 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);

     ELSE
         -- �������� ����� � <������ ��������>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell(), inId, 0 :: TFloat);
         --
         ioPartionCellName_1:= '';
     END IF;


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inId, inisPartionCell_Close_1);

     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

     -- ��������� �������� <���� ������>
     IF COALESCE (inPartionGoodsDate, zc_DateStart()) <> zc_DateStart() OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = inId AND MID.DescId = zc_MIDate_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inId, inPartionGoodsDate);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.01.24         *
*/

-- ����
--