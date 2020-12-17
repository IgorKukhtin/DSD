-- Function: gpInsertUpdate_Object_PriceListItem_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceListItem_From_Excel (TDateTime, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceListItem_From_Excel(
    IN inOperDate        TDateTime,
    IN inPriceListId     Integer  , -- ����� ����
    IN inGoodsId         Integer  , --  �����
    IN inPriceValue      TFloat   , -- ����
    IN inSession         TVarChar   -- ������ ������������
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE(inPriceListId,0) = 0
    THEN
        RAISE EXCEPTION '������.�� ������� �����-����.';
    END IF;
    
    /*
    -- ����� ������ �� ����
    vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode);

    IF COALESCE (vbGoodsId, 0) = 0
    THEN
       -- RAISE EXCEPTION '������.�������� ��� ������ = <%> �� ������.', inGoodsCode;
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� ��� ������ = <%> �� ������.' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_PriceListItem_From_Excel' :: TVarChar
                                             , inUserId        := vbUserId
                                             , inParam1        := inGoodsCode :: TVarChar
                                             );
    END IF;
    */

    IF inPriceValue < 0
    THEN
       -- RAISE EXCEPTION '������. ���� = <%> �� ����� ���� ������ ����.', inPriceValue;
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������. ���� = <%> �� ����� ���� ������ ����.' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_PriceListItem_From_Excel' :: TVarChar
                                             , inUserId        := vbUserId
                                             , inParam1        := inPriceValue :: TVarChar
                                             );
    END IF;

    --
    PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId          := 0
                                                      , inPriceListId := inPriceListId
                                                      , inGoodsId     := inGoodsId
                                                      , inOperDate    := inOperDate
                                                      , inValue       := inPriceValue
                                                      , inUserId      := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.11.20         *
*/

-- ����
