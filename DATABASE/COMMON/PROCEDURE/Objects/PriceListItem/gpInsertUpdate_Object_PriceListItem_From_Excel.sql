-- Function: gpInsertUpdate_Object_PriceListItem_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceListItem_From_Excel (TDateTime, Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceListItem_From_Excel(
    IN inOperDate        TDateTime,
    IN inPriceListId     Integer  , -- ����� ����
    IN inGoodsCode       Integer  , -- Code �����
    IN inGoodsKindName   TVarChar , -- ��� ������
    IN inPriceValue      TFloat   ,  -- ����
    IN inSession         TVarChar -- ������ ������������
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbGoodsId Integer;
    DECLARE vbGoodsKindId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());


    IF COALESCE(inPriceListId,0) = 0
    THEN
        RAISE EXCEPTION '������. ������� �������� ����� ����';
    END IF;
    
    --����� ������ �� ����
    vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode);

    -- ����� ���� ������
    vbGoodsKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsKind() AND Object.ValueData = inGoodsKindName);

    
    IF (COALESCE(vbGoodsId,0) = 0)
    THEN
        RAISE EXCEPTION '������. � ���� ������ �� ������ ����� � ����� <%>', inGoodsCode;
    END IF;

    IF (COALESCE(vbGoodsKindId,0) = 0)
    THEN
        RAISE EXCEPTION '������. � ���� ������ �� ������ ��� ������ <%>', inGoodsKindName;
    END IF;

 
    IF inPriceValue is not null AND (inPriceValue < 0)
    THEN
        RAISE EXCEPTION '������. ���� <%> �� ����� ���� ������ ����.', inPriceValue;
    END IF;
   
    -- 
    PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId := 0
                                                      , inPriceListId := inPriceListId
                                                      , inGoodsId     := vbGoodsId
                                                      , inGoodsKindId := vbGoodsKindId
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 24.03.20         *
*/

-- ����
