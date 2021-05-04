-- Function: gpInsertUpdate_ObjectHistory_PriceChange ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceChange (Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceChange (Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceChange (Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceChange (Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceChange(
 INOUT ioId                 Integer,    -- ���� ������� <������� ������� ������>
    IN inPriceChangeId      Integer,    -- �����
    IN inOperDate           TDateTime,  -- ���� �������� ������
    IN inPriceChange        TFloat,     -- ����
    IN inFixValue           TFloat,     -- 
    IN inFixPercent         TFloat,     --
    IN inFixDiscount        TFloat,     --
    IN inPercentMarkup      TFloat,     -- 
    IN inMultiplicity       TFloat,     -- ���������
    IN inFixEndDate         TDateTime,  -- ���� ��������� �������� ������
    IN inSession            TVarChar    -- ������ ������������
)
  RETURNS Integer AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- ��������
   IF COALESCE (inPriceChangeId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� <�����>.';
   END IF;


   -- ��������� ��� ������ ������ �������
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceChange(), inPriceChangeId, inOperDate, vbUserId);
   -- ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_Value(), ioId, inPriceChange);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_FixValue(), ioId, inFixValue);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_FixPercent(), ioId, inFixPercent);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_FixDiscount(), ioId, inFixDiscount);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_PercentMarkup(), ioId, inPercentMarkup);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_Multiplicity(), ioId, inMultiplicity);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryDate (zc_ObjectHistoryDate_PriceChange_FixEndDate(), ioId, inFixEndDate);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 04.12.19                                                      * FixDiscount
 08.02.19         * inFixPercent
 17.08.18         *
*/