-- Function: lpUpdate_MI_ProductionUnion_RealDelicShp()

DROP FUNCTION IF EXISTS lpUpdate_MI_ProductionUnion_RealDelicShp  (Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_ProductionUnion_RealDelicShp(
    IN inId                     Integer   , -- ���� ������� <������� ���������>
    IN inAmount                 TFloat    , -- ���������� 
    IN inUserId                 Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
BEGIN
   -- ��������
   IF EXISTS (SELECT 1
              FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId AND Movement.DescId = zc_Movement_ProductionUnion()
              WHERE MI.Id = inId AND MI.DescId = zc_MI_Master()
                AND (Movement.StatusId <> zc_Enum_Status_Complete() OR MI.isErased = TRUE)
             )
   THEN
       RAISE EXCEPTION '������. ������ ������������ <%> %.%���������� ������� ��� ������ � ������ �����������.'
                     , (SELECT '���.=<' || zfConvert_FloatToString (COALESCE (MI_Partion.Amount, 0)) || '>'
                            || ' ���.=<' || zfConvert_FloatToString (COALESCE (MIFloat_CuterCount.ValueData, 0)) || '>'
                            || ' ���=<' || COALESCE (Object_GoodsKindComplete.ValueData, '') || '>'
                            || ' ������=<' || DATE (COALESCE (Movement_Partion.OperDate, zc_DateEnd())) || '>'
                            || ' � <' || COALESCE (Movement_Partion.InvNumber, '') || '>'
                        FROM MovementItem AS MI_Partion
                          LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id       = MI_Partion.MovementId
                                                                AND Movement_Partion.DescId   = zc_Movement_ProductionUnion()
                          LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                           ON MILO_GoodsKindComplete.MovementItemId = MI_Partion.Id
                                                          AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                          LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId
                          LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                      ON MIFloat_CuterCount.MovementItemId = MI_Partion.Id
                                                     AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                        WHERE MI_Partion.Id = inId AND MI_Partion.DescId = zc_MI_Master()
                       )
                     , (SELECT CASE WHEN MI_Partion.isErased = TRUE THEN '�������'
                                    ELSE '� ������� <' || lfGet_Object_ValueData_sh (Movement_Partion.StatusId) || '>'
                               END
                        FROM MovementItem AS MI_Partion
                          LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id       = MI_Partion.MovementId
                                                                AND Movement_Partion.DescId   = zc_Movement_ProductionUnion()
                        WHERE MI_Partion.Id = inId AND MI_Partion.DescId = zc_MI_Master()
                       )
                     , CHR (13)
                      ;

   ELSEIF NOT EXISTS (SELECT 1 FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId AND Movement.DescId = zc_Movement_ProductionUnion() AND Movement.StatusId = zc_Enum_Status_Complete() WHERE MI.Id = inId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE)
   THEN
       RAISE EXCEPTION '������. ������ ������������ <%> �� �������.', inId;
   END IF;

   -- ��������� �������� <����������� �/� ���� ����� �����������>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeightShp(), inId, inAmount + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_RealWeightShp()), 0));

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (inId, inUserId, FALSE);

   -- 
   RETURN inId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.11.20                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_MI_ProductionUnion_RealDelicShp (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
