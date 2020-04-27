-- Function: gpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                            Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                    Integer   , -- ���� ������� <��������>
    IN inGoodsId                       Integer   , -- ������
    IN inPartionId                     Integer   , -- ������
    IN inAmount                        TFloat    , -- ����������
   OUT outOperPrice                    TFloat    , -- ����
   OUT outCountForPrice                TFloat    , -- ���� �� ����������
 INOUT ioOperPriceList                 TFloat    , -- ���� (�����)
 INOUT ioOperPriceListTo               TFloat    , -- ���� (�����)(����) --(��� �������� ����������)
   OUT outTotalSumm                    TFloat    , -- ����� ��.
   OUT outTotalSummBalance             TFloat    , -- ����� ��. (���)
   OUT outTotalSummPriceList           TFloat    , -- ����� �� ������
   OUT outTotalSummPriceListTo         TFloat    , -- ����� (����, �����)
   OUT outTotalSummPriceListBalance    TFloat    , -- ����� ��� (�� ����, �����)
   OUT outTotalSummPriceListToBalance  TFloat    , -- ����� ��� (����, �����)
   OUT outCurrencyValue                TFloat    , --
   OUT outParValue                     TFloat    , --
    IN inSession                       TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
   DECLARE vbCurrencyId_pl_to Integer;
   DECLARE vbToId Integer;
   DECLARE vbPriceListId_to Integer;
   DECLARE vbOperPriceListTo_find TFloat;
   DECLARE vbCurrencyValue_to TFloat;
   DECLARE vbParValue_to TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ���� ���������, ������������� ����, ����� ��� �������. ����
     SELECT Movement.OperDate
          , MovementLinkObject_To.ObjectId AS ToId
          , ObjectLink_Unit_PriceList_to.ChildObjectId AS PriceListId_to
          , COALESCE (ObjectLink_PriceList_Currency_to.ChildObjectId, zc_Currency_Basis()) AS CurrencyId_pl_to
   INTO vbOperDate, vbToId, vbPriceListId_to, vbCurrencyId_pl_to
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
         LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList_to
                              ON ObjectLink_Unit_PriceList_to.ObjectId = MovementLinkObject_To.ObjectId
                             AND ObjectLink_Unit_PriceList_to.DescId = zc_ObjectLink_Unit_PriceList()

         LEFT JOIN ObjectLink AS ObjectLink_PriceList_Currency_to
                              ON ObjectLink_PriceList_Currency_to.ObjectId = ObjectLink_Unit_PriceList_to.ChildObjectId
                             AND ObjectLink_PriceList_Currency_to.DescId   = zc_ObjectLink_PriceList_Currency()
     WHERE Movement.Id = inMovementId;

     -- ���� (�����)
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!��� SYBASE - ����� ������!!!
         IF 1=0 THEN RAISE EXCEPTION '������.�������� ������ ��� �������� �� Sybase.'; END IF;
     ELSE
         -- �� �������
         ioOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                                   , zc_PriceList_Basis()
                                                                                                   , inGoodsId
                                                                                                    ) AS tmp), 0);
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (ioOperPriceList, 0) <= 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <���� (�����)>.';
     END IF;

     -- ������ �� ������ : OperPrice � CountForPrice � CurrencyId
     SELECT COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
          , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
            INTO outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;


     -- ���� �� ������� ������
     IF vbCurrencyId <> zc_Currency_Basis()
     THEN
         -- ���������� ���� �� ���� ���������
         SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue, 0)
                INTO outCurrencyValue, outParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                               , inCurrencyToId  := vbCurrencyId
                                                ) AS tmp;
         -- ��������
         IF COALESCE (vbCurrencyId, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <������>.';
         END IF;
         -- ��������
         IF COALESCE (outCurrencyValue, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <����>.';
         END IF;
         -- ��������
         IF COALESCE (outParValue, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <�������>.';
         END IF;

     ELSE
         -- ���� �� �����
         outCurrencyValue:= 0;
         outParValue     := 0;
     END IF;


     -- ���� ���� ���� � ����� ��� ����. ���� ��������� ��������� ����
     IF COALESCE (vbPriceListId_to,0) <> 0 AND COALESCE (ioOperPriceListTo,0) <> 0
     THEN
         -- ���� ����, ������� ��� ��������� - �� �������
         vbOperPriceListTo_find := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                                          , vbPriceListId_to
                                                                                                          , inGoodsId
                                                                                                           ) AS tmp), 0);
         -- ���� ��� ����
         IF COALESCE (vbOperPriceListTo_find, 0) = 0
         THEN
             PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId         := 0
                                                               , inPriceListId:= vbPriceListId_to
                                                               , inGoodsId    := inGoodsId
                                                               , inOperDate   := zc_DateStart()
                                                               , inValue      := ioOperPriceListTo
                                                               , inUserId     := vbUserId
                                                                );
         ELSE
             -- ����� ������ �� ��� �����
             ioOperPriceListTo:= vbOperPriceListTo_find;
         END IF;
     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inPartionId, inMovementId, inAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, outOperPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, ioOperPriceList);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListTo(), ioId, ioOperPriceListTo);


     -- ��������� �������� <���� �� ����������>
     IF COALESCE (outCountForPrice, 0) = 0 THEN outCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, outCountForPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, outCurrencyValue);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioId, outParValue);

     -- ��������� ����� �� ��������, ��� �����
     outTotalSumm := CASE WHEN outCountForPrice > 0
                               THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                          ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                     END;

     -- ���������� ������ ��� ���� �� �����-����� - vbPriceListId_to
    SELECT COALESCE (OH_PriceListItem_Currency.ObjectId, vbCurrencyId_pl_to) AS CurrencyId
 INTO vbCurrencyId_pl_to
    FROM ObjectLink AS OL_PriceListItem_Goods
         INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                               ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                              AND OL_PriceListItem_PriceList.ChildObjectId = vbPriceListId_to
                              AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

         INNER JOIN ObjectHistory AS OH_PriceListItem
                                  ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                 AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                 AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!��������� ����!!!
         LEFT JOIN ObjectHistoryLink AS OH_PriceListItem_Currency
                                     ON OH_PriceListItem_Currency.ObjectHistoryId = OH_PriceListItem.Id
                                    AND OH_PriceListItem_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
         LEFT JOIN ObjectHistoryFloat AS OHF_Value
                                      ON OHF_Value.ObjectHistoryId = OH_PriceListItem.Id
                                     AND OHF_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
    WHERE OL_PriceListItem_Goods.ChildObjectId = inGoodsId
      AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods();
   
    -- �������� ���� ��� ����
    SELECT COALESCE (tmpCurrency.Amount, 1)   AS CurrencyValue
         , COALESCE (tmpCurrency.ParValue, 0) AS ParValue
   INTO vbCurrencyValue_to, vbParValue_to      
    FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                          , inCurrencyFromId:= zc_Currency_Basis()
                                          , inCurrencyToId  := vbCurrencyId_pl_to
                                           ) AS tmpCurrency

     -- ��������� ����� ��. � ��� �� ��������, ��� �����
     outTotalSummBalance := (CAST (outTotalSumm * outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END AS NUMERIC (16, 2))) ;


     -- ��������� ����� �� ������ �� ��������, ��� �����
     outTotalSummPriceList := CAST ((inAmount * ioOperPriceList) AS NUMERIC (16, 2));

     -- ��������� ����� (����, �����)
     outTotalSummPriceListTo := CAST ((inAmount * ioOperPriceListTo) AS NUMERIC (16, 2));

     --����� ��� (�� ����, �����)
     outTotalSummPriceListBalance   := (CAST (outTotalSummPriceList * CASE WHEN vbCurrencyId = zc_Currency_Basis()
                                                                           THEN 1
                                                                           ELSE outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END
                                                                      END AS NUMERIC (16, 2))) ;
     --����� ��� (����, �����)
     outTotalSummPriceListToBalance := (CAST (outTotalSummPriceListTo * CASE WHEN vbCurrencyId_pl_to = zc_Currency_Basis()
                                                                             THEN 1
                                                                             ELSE vbCurrencyValue_to / CASE WHEN vbParValue_to <> 0 THEN vbParValue_to ELSE 1 END
                                                                        END AS NUMERIC (16, 2))) ;


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.04.20         *
 26.06.17         *
 09.05.17         *
 25.04.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Send (ioId := 31 , inMovementId := 13 , inGoodsId := 349 , inPartionId := 41 , inAmount := 10 ,  inSession := '2');
