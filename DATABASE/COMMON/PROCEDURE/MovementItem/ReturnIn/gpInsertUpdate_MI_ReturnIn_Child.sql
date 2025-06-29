-- Function: gpInsertUpdate_MI_ReturnIn_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReturnIn_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReturnIn_Child (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReturnIn_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>   
    IN inParentId            Integer   , -- ����
    IN inMovementId          Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId             Integer   , -- �����
    IN inMovementId_sale     Integer   , -- 
    IN inMovementItemId_sale Integer   , -- 
    IN inAmount              TFloat    , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
           vbUserId Integer;
           vbMovementItemId_sale Integer;
           vbGoodsKindId Integer;
           vbPrice TFloat;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     --��������
     IF COALESCE (ioId, 0) <> 0 
        AND TRUE = COALESCE ( (SELECT MIBoolean_Calculated.ValueData
                               FROM MovementItemBoolean AS MIBoolean_Calculated
                               WHERE MIBoolean_Calculated.MovementItemId = ioId
                                 AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                               ), FALSE)
     THEN 
          RAISE EXCEPTION '������.������ � ���������������, ������ ����� �� ��������.';
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     --��� ������, �� inParentId
     vbGoodsKindId := (SELECT MILO.ObjectId
                       FROM MovementItemLinkObject AS MILO
                       WHERE MILO.MovementItemId= inParentId
                         AND MILO.DescId = zc_MILinkObject_GoodsKind()
                      );
                      
     vbPrice := (SELECT COALESCE (MIFloat_Price.ValueData, 0)
                 FROM MovementItemFloat AS MIFloat_Price
                 WHERE MIFloat_Price.MovementItemId = inParentId
                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                 );

     IF COALESCE (inMovementItemId_sale,0) = 0
     THEN
         --���������� ������ ���. �������
         inMovementItemId_sale := (SELECT tmp.Id 
                                   FROM (SELECT MI.Id
                                              , ROW_NUMBER () OVER (PARTITION BY MI.Amount, MI.Id) AS Ord  
                                         FROM MovementItem AS MI
                                              INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                                ON MILinkObject_GoodsKind.MovementItemId = MI.Id
                                                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                                               AND COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) = COALESCE (vbGoodsKindId, zc_GoodsKind_Basis()) 
                                              INNER JOIN MovementItemFloat AS MIFloat_Price
                                                                           ON MIFloat_Price.MovementItemId = MI.Id
                                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                          AND COALESCE (MIFloat_Price.ValueData, 0) = vbPrice                                 
                                         WHERE MI.MovementId = inMovementId_sale
                                           AND MI.DescId = zc_MI_Master()
                                           AND MI.isErased = FALSE
                                           AND MI.ObjectId = inGoodsId
                                        ) AS tmp
                                   WHERE tmp.Ord = 1                               
                                   );
         --���� �� ����� ����� + ��� + ����, ������������ ��� ����
         IF COALESCE (inMovementItemId_sale,0) = 0 
         THEN
              --���������� ������ ���. �������
              inMovementItemId_sale := (SELECT tmp.Id 
                                        FROM (SELECT MI.Id
                                                   , ROW_NUMBER () OVER (PARTITION BY MI.Amount, MI.Id) AS Ord  
                                              FROM MovementItem AS MI
                                                   INNER JOIN MovementItemFloat AS MIFloat_Price
                                                                                ON MIFloat_Price.MovementItemId = MI.Id
                                                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                               AND COALESCE (MIFloat_Price.ValueData, 0) = vbPrice                                 
                                              WHERE MI.MovementId = inMovementId_sale
                                                AND MI.DescId = zc_MI_Master()
                                                AND MI.isErased = FALSE
                                                AND MI.ObjectId = inGoodsId
                                             ) AS tmp
                                        WHERE tmp.Ord = 1                               
                                        );
         END IF;
     END IF;


     IF COALESCE (inMovementItemId_sale,0) = 0 
     THEN
          RAISE EXCEPTION '������.� ��������� ���.������� �� ������ <%> <%> ���� <%>.', lfGet_Object_ValueData_sh (inGoodsId), lfGet_Object_ValueData_sh (vbGoodsKindId), vbPrice;
     END IF;
     
     ioId := lpInsertUpdate_MovementItem_ReturnIn_Child (ioId                  := ioId
                                                       , inMovementId          := inMovementId
                                                       , inParentId            := inParentId
                                                       , inGoodsId             := inGoodsId
                                                       , inAmount              := CASE WHEN inMovementId_sale > 0 AND inMovementItemId_sale > 0 THEN COALESCE (inAmount, 0) ELSE 0 END
                                                       , inMovementId_sale     := COALESCE (inMovementId_sale, 0)
                                                       , inMovementItemId_sale := COALESCE (inMovementItemId_sale, 0)
                                                       , inUserId              := vbUserId
                                                       , inIsRightsAll         := FALSE
                                                        );     
     IF vbUserId = 9457
     THEN
          RAISE EXCEPTION 'Test.Ok. <%>' , inMovementItemId_sale;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.06.25         *
*/

-- ����
