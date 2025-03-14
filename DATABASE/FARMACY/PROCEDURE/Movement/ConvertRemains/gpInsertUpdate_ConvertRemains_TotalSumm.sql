-- Function: gpInsertUpdate_ConvertRemains_TotalSumm (Integer)

DROP FUNCTION IF EXISTS gpInsertUpdate_ConvertRemains_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ConvertRemains_TotalSumm(
    IN inMovementId    Integer,    -- ���� ������� <��������>
    IN inSession       TVarChar    -- ������ ������������
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCount TFloat;
  DECLARE vbTotalSum TFloat;
BEGIN

      SELECT SUM(MovementItem.Amount) AS TotalCount
           , SUM(ROUND(MIFloat_PriceWithVAT.ValueData * MovementItem.Amount, 2)) AS TotalSum
      INTO vbTotalCount, vbTotalSum
      FROM MovementItem

           LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                       ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                      AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()

           LEFT JOIN MovementItemString AS MIString_Comment
                                        ON MIString_Comment.MovementItemId = MovementItem.Id
                                       AND MIString_Comment.DescId = zc_MIString_Comment()
                                       
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.isErased = FALSE
        AND MovementItem.Amount > 0 
        --AND COALESCE(MIString_Comment.ValueData , '') = ''
        AND MovementItem.DescId = zc_MI_Master();

      -- ��������� �������� <����� ����������>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, COALESCE(vbTotalCount));
      -- ��������� �������� <����� �����>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, COALESCE(vbTotalSum));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_ConvertRemains_TotalSumm (Integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.10.2023                                                     *
*/

-- select From gpInsertUpdate_ConvertRemains_TotalSumm (34334044, '3');
