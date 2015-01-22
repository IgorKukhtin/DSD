-- Function: lfGet_Object_Partner_PriceList_record (Integer, TDateTime)

DROP FUNCTION IF EXISTS lfGet_Object_Partner_PriceList_record (Integer, TDateTime);

CREATE OR REPLACE FUNCTION lfGet_Object_Partner_PriceList_record(
    IN inPartnerId Integer,
    IN inOperDate TDateTime)
RETURNS Integer
AS
$BODY$
  DECLARE vbPriceListId Integer;
BEGIN
      SELECT PriceListId
             INTO vbPriceListId
      FROM lfGet_Object_Partner_PriceList (inPartnerId:= inPartnerId, inOperDate:= inOperDate);

      RETURN vbPriceListId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.15                                        *
*/

-- ����
-- SELECT * FROM lfGet_Object_Partner_PriceList_record (inPartnerId:= 79134, inOperDate:= '20.11.2014')
