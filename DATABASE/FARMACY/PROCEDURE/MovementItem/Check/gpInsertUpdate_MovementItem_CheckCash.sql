 -- Function: gpInsertUpdate_MovementItem_CheckCash()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_CheckCash (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_CheckCash(
 INOUT ioId                  Integer   , -- ���� ������� <������ ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
   OUT outPriceSale          TFloat    , -- ���� ��� ������
   OUT outSummChangePercent  TFloat    , -- SummChangePercent
   OUT outSumm               TFloat    , -- �����
   OUT outSummSale           TFloat    , -- ����� ��� ������
   OUT outIsSp               Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceSale TFloat;
   DECLARE vbChangePercent TFloat;
   DECLARE vbSummChangePercent TFloat;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    IF 4183126 <> inSession::Integer
    THEN
      RAISE EXCEPTION '��������� ���� ��� ���������.';
    END IF;

    --���������� ������� ��������� � ���.�������, �� ����� ���.
    outIsSp:= COALESCE (
             (SELECT CASE WHEN COALESCE(MovementString_InvNumberSP.ValueData,'') <> '' OR
                                COALESCE(MovementString_MedicSP.ValueData,'') <> '' OR
                                COALESCE(MovementString_MemberSP.ValueData,'') <> '' OR
                               -- COALESCE(MovementDate_OperDateSP.ValueData,Null) <> Null OR
                                COALESCE(MovementLinkObject_PartnerMedical.ObjectId,0) <> 0 THEN True
                           ELSE FALSE
                      END
              FROM Movement
                          LEFT JOIN MovementString AS MovementString_InvNumberSP
                                 ON MovementString_InvNumberSP.MovementId = Movement.Id
                                AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                          LEFT JOIN MovementString AS MovementString_MedicSP
                                 ON MovementString_MedicSP.MovementId = Movement.Id
                                AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
                          LEFT JOIN MovementString AS MovementString_MemberSP
                                 ON MovementString_MemberSP.MovementId = Movement.Id
                                AND MovementString_MemberSP.DescId = zc_MovementString_MemberSP()
                          LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                 ON MovementDate_OperDateSP.MovementId = Movement.Id
                                AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                  ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                 AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Sale())
              , False)  :: Boolean ;

    -- �������� �� 1 ����� ���������� �������� � ����������
    -- ����  ������� ��������� � ���.������� = TRUE . �� � ���. ������ ���� 1 ������
    IF outIsSp = TRUE
    THEN
         IF (SELECT COUNT(*) FROM MovementItem
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.Id <> ioId
               AND MovementItem.IsErased = FALSE
               AND MovementItem.Amount > 0) >= 1
            THEN
                 RAISE EXCEPTION '������.� ��������� ����� ���� ������ 1 ��������.';
            END IF;
    END IF;

    -- ������� ������� �� ��������� � ������
    IF COALESCE (ioId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = ioId)
    THEN
        IF COALESCE (inPrice, 0) = 0
        THEN
            -- ����������, ������, ������� �� ���� ������ - ���
            ioId:= (SELECT MovementItem.Id
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND COALESCE (MIFloat_Price.ValueData, 0) = inPrice
                   );
        ELSE
            ioId:= (SELECT MovementItem.Id
                    FROM MovementItem
                         INNER JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                     AND MIFloat_Price.ValueData = inPrice
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                   );
        END IF;
        -- ���� �� ����� ������� � ������ �����, ���� ����� ������ �������
        IF COALESCE(ioID, 0) = 0
        THEN
            ioId:= (SELECT MovementItem.Id
                    FROM MovementItem
                         INNER JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                     -- ���������� ���� � ���������� ����� �����������
                                                     -- AND MIFloat_Price.ValueData = inPrice
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                    LIMIT 1
                   );
        END IF;

    END IF;

     -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    IF vbIsInsert
    THEN
      -- ��������� �������� <����>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

      vbChangePercent := 0;
      vbSummChangePercent := 0;

      -- !!!������!!!
      IF COALESCE (vbChangePercent, 0) = 0
      THEN
        vbPriceSale:= inPrice;
      ELSE
        vbPriceSale:= Round(inPrice * (100.0 - vbChangePercent) / 100.0, 2);
      END IF;
      -- ��������� �������� <���� ��� ������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, vbPriceSale);

      -- ��������� �������� <% ������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, vbChangePercent);

      -- ��������� �������� <����� ������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, CASE WHEN inAmount = 0 THEN 0 ELSE vbSummChangePercent END);

      -- ��������� �������� <UID ������ �������>
      -- PERFORM lpInsertUpdate_MovementItemString (zc_MIString_UID(), ioId, inList_UID);

    END IF;

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

    -- �������� ������ �� �������
    SELECT
      MovementItem_Check.PriceSale,
      MovementItem_Check.SummChangePercent,
      MovementItem_Check.AmountSumm,
      (MovementItem_Check.PriceSale * MovementItem_Check.Amount)::TFloat
    INTO
      outPriceSale,
      outSummChangePercent,
      outSumm,
      outSummSale
    FROM MovementItem_Check_View AS MovementItem_Check
    WHERE MovementItem_Check.Id =  ioId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_CheckCash (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
              ������ �.�.
 06.10.18       *
*/
