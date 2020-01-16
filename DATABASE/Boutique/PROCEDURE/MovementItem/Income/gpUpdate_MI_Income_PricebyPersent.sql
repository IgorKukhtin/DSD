-- Function: gpUpdate_MI_Income_PricebyPersent (TFloat, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_Income_PricebyPersent (TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Income_PricebyPersent(
    IN inPersent      TFloat,
    IN inPriceJur     TFloat,
   OUT outOperPrice   TFloat,
    IN insession      TVarChar
)
RETURNS TFloat
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_Price());

     -- ���������
     outOperPrice := CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE
                               THEN inPriceJur + (inPriceJur / 100 * inPersent)
                          ELSE inPriceJur
                     END;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.02.19         *
*/