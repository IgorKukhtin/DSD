-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_OH_PriceListItemTax(Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_OH_PriceListItemTax(
    IN inPriceListId                Integer,    -- �����-���� ���������
    IN inGoodsId                    Integer,    -- �����
    IN inOperDate                   TDateTime,  -- ��������� ���� �
    IN inOperPrice                 TFloat,     -- ��. ����
    IN inTax                        TFloat,     -- ����� �� ������� ����
    IN inSession                    TVarChar    -- ������ ������������
)
  RETURNS VOID AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- ��������
   IF COALESCE (inPriceListId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� �������� <�����-����>.';
   END IF;

   -- ��������
   IF inOperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
   THEN
       RAISE EXCEPTION '������.�������� <��������� ���� �> �� ����� ���� ������ ��� <%>.', DATE (DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH');
   END IF;


   -- (�.�. �� ���� 100�.�. ����� ���� = 50, ����� ���� ������ ���� 5000���, � ��� ��� ������� ����� ������� �� ������� � ��� ��� �� ����� � ���������� �� ����� ���)

   -- ��������� ��� (��� ������ ���� = ��.���� * ���.)
   PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId          := 0
                                                     , inPriceListId := inPriceListId
                                                     , inGoodsId     := inGoodsId
                                                     , inOperDate    := inOperDate
                                                                        -- ���������� ��� ������ � �� +/-50 ������, �.�. ��������� ����� ��� 50 ��� �����
                                                     , inValue       := (CEIL ((inOperPrice * inTax) / 50) * 50) :: TFloat
                                                  -- , inValue       := CAST ((inOperPrice * inTax) AS NUMERIC (16, 0)) :: TFloat
                                                     , inUserId      := vbUserId
                                                      );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.03.18         *
*/
