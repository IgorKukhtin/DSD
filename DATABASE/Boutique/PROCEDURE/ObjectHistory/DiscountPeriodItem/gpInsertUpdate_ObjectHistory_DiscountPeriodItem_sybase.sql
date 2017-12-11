-- Function: gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase (Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase(
 INOUT ioId                     Integer,    -- ���� ������� <������� �������>
    IN inUnitId                 Integer,    -- �������������
    IN inGoodsId                Integer,    -- �����
    IN inStartDate              TDateTime,  -- ���� �������� % ������
    IN inEndDate                TDateTime,  -- ���� �������� % ������
    IN inValue                  TFloat,     -- % ������
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
DECLARE
BEGIN
   -- !!!������ ��������!!!
   IF inIsLast = TRUE
   THEN SELECT tmp.ioId INTO ioId
        FROM gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast (ioId          := ioId
                                                                , inUnitId      := inUnitId
                                                                , inGoodsId     := inGoodsId
                                                                , inOperDate    := inStartDate
                                                                , inValue       := inValue
                                                                , inIsLast      := inIsLast
                                                                , inSession     := inSession
                                                                 ) AS tmp;
   ELSE
       -- ��������� ��������
       RAISE EXCEPTION 'inIsLast <%>', inIsLast;
   END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 28.04.17         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase (ioId := 0 , inUnitId := 311 , inGoodsId := 271 , inOperDate := ('08.05.2017')::TDateTime , inValue := 0 , inIsLast := 'False' ,  inSession := '2');
