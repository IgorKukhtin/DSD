-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Summ (Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Summ (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderClient_Summ(
    IN inId                  Integer   , -- ���� ������� <��������>
 INOUT ioSummTax             TFloat    , -- 
 INOUT ioSummReal            TFloat    , -- 
    IN inVATPercent          TFloat    , --
    IN inDiscountTax         TFloat    , --
    IN inDiscountNextTax     TFloat    , -- 
    IN inTransportSumm_load  TFloat    , --���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbNPP_old TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
     vbUserId := lpGetUserBySession (inSession);


     -- ��������� �������� <���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inId, inVATPercent);
     -- ��������� �������� <% ������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), inId, inDiscountTax);
     -- ��������� �������� <% ������ ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), inId, inDiscountNextTax);
     -- ��������� �������� <% ������ ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm_load(), inId, inTransportSumm_load);

     -- ���������
     PERFORM lpInsert_MovementItemProtocol (MovementItem.MovementItemId, vbUserId, FALSE)
     FROM (SELECT MovementItem.MovementItemId
               , lpInsertUpdate_MovementItem_OrderClient (ioId            := MovementItem.MovementItemId
                                                      , inMovementId    := inId
                                                      , inGoodsId       := MovementItem.ProductId
                                                      , inAmount        := MovementItem.Amount
                                                        -- ����� ����� ������� ��� ��� - �� ����� �������� (Basis+options)
                                                      , ioOperPrice     := MovementItem.Basis_summ
                                                        -- ����� ����� ������� ��� ��� - ��� ������ (Basis+options)
                                                      , inOperPriceList := MovementItem.Basis_summ_orig
                                                        -- ����� ����� ������� ��� ��� - ��� ������ (Basis)
                                                      , inBasisPrice    := MovementItem.Basis_summ1_orig
                                                        --
                                                      , inCountForPrice := 1  ::TFloat
                                                      , inComment       := COALESCE ((SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = MovementItem.MovementItemId AND MIS.DescId = zc_MIString_Comment()), '')
                                                      , inUserId        := vbUserId
                                                       )
           FROM (WITH gpSelect AS (SELECT gpSelect.Id AS ProductId, gpSelect.Basis_summ, gpSelect.Basis_summ_orig, gpSelect.Basis_summ1_orig
                                   FROM gpSelect_Object_Product (inId, FALSE, FALSE, vbUserId :: TVarChar) AS gpSelect
                                   WHERE gpSelect.MovementId_OrderClient = inId
                                  )
                      SELECT gpSelect.ProductId, gpSelect.Basis_summ, gpSelect.Basis_summ_orig, gpSelect.Basis_summ1_orig
                           , MovementItem.Id AS MovementItemId
                           , MovementItem.Amount
                      FROM MovementItem
                           JOIN gpSelect ON gpSelect.ProductId = MovementItem.ObjectId
                      WHERE MovementItem.MovementId = inId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                ) AS MovementItem
          ) AS MovementItem
     ;

     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (inId);

     -- ������ ����� !!!���������!!!
     IF ioSummReal > 0
     THEN
         ioSummTax:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSumm()), 0)
                   - ioSummReal
                    ;
     ELSE
         ioSummReal:= 0;
     END IF;

     -- ��������� �������� <C���� ������������������ ������, ��� ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTax(), inId, ioSummTax); 
     -- ��������� �������� <����� ������������������ �����, � ������ ���� ������, ��� ����������, ����� ������� ��� ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReal(), inId, ioSummReal);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.05.23         *
*/

-- ����
--