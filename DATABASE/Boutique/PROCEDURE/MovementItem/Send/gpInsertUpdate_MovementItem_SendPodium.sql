-- Function: gpInsertUpdate_MovementItem_SendPodium()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendPodium (Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendPodium (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendPodium(
 INOUT ioId                            Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                    Integer   , -- ���� ������� <��������>
    IN inGoodsName                     TVarChar  , -- ������
    IN inGoodsSizeName                 TVarChar  , -- ������
 INOUT ioAmount                        TFloat    , -- ����������
   OUT outOperPrice                    TFloat    , -- ����
   OUT outCountForPrice                TFloat    , -- ���� �� ����������
 INOUT ioOperPriceList                 TFloat    , -- ���� (�����)
 INOUT ioOperPriceListTo_start         TFloat    , -- ���� ������ �������� (�����)(����) --(��� �������� ����������)
 INOUT ioOperPriceListTo               TFloat    , -- ���� (�����)(����) --(��� �������� ����������)
   OUT outTotalSumm                    TFloat    , -- ����� ��.
   OUT outTotalSummBalance             TFloat    , -- ����� ��. (���)
   OUT outTotalSummPriceList           TFloat    , -- ����� �� ������
   OUT outTotalSummPriceListTo         TFloat    , -- ����� (����, �����)
   OUT outTotalSummPriceListBalance    TFloat    , -- ����� ��� (�� ����, �����)
   OUT outTotalSummPriceListToBalance  TFloat    , -- ����� ��� (����, �����) 

   OUT outTotalSummPriceList_disc           TFloat    , -- ����� �� ������ � ��. ���.������
   OUT outTotalSummPriceListTo_disc         TFloat    , -- ����� (����, �����) � ��. ���.������
   OUT outTotalSummPriceListBalance_disc    TFloat    , -- ����� ��� (�� ����, �����) � ��. ���.������
   OUT outTotalSummPriceListToBalance_disc  TFloat    , -- ����� ��� (����, �����)  � ��. ���.������

   OUT outCurrencyValue                TFloat    , --
   OUT outParValue                     TFloat    , --
   OUT outGoodsSizeName                TVarChar  , --
    IN inSession                       TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsSizeId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
   DECLARE vbCurrencyId_pl_to Integer;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
   DECLARE vbPriceListId_to Integer;
   DECLARE vbCurrencyValue_to TFloat;
   DECLARE vbParValue_to TFloat;

   DECLARE vbStartDate_plTo_find TDateTime;
   DECLARE vbOperPriceListTo_find TFloat; 
   
   DECLARE vbDiscountTax_From TFloat;
   DECLARE vbDiscountTax_To TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     IF COALESCE (inGoodsName, '') = ''
     THEN 
         RETURN;
     END IF;
     
     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
/*     IF COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;
*/
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (ioAmount, 0) < 0 THEN
        RAISE EXCEPTION '������.���-�� �� ����� ���� ������ 0.';
     END IF;


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- ���������� ����� �� inGoodsName
     SELECT MAX (Object.Id)
            INTO vbGoodsId
     FROM Object
     WHERE Object.DescId    = zc_Object_Goods()
       AND Object.ValueData = inGoodsName;
       
     IF COALESCE (vbGoodsId,0) = 0 
     THEN 
         RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;
       
     -- ���� ���������, ������������� ����, ����� ��� �������. ����
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId AS FromId
          , MovementLinkObject_To.ObjectId   AS ToId
          , ObjectLink_Unit_PriceList_to.ChildObjectId AS PriceListId_to
          , COALESCE (ObjectLink_PriceList_Currency_to.ChildObjectId, zc_Currency_Basis()) AS CurrencyId_pl_to
            INTO vbOperDate, vbFromId, vbToId, vbPriceListId_to, vbCurrencyId_pl_to
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
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
                                                                                                   , (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbFromId AND OL.DescId = zc_ObjectLink_Unit_PriceList())
                                                                                                   , vbGoodsId
                                                                                                    ) AS tmp), 0);
     END IF;

     -- !!!������!!!
     IF zc_Enum_GlobalConst_isTerry() = FALSE
     THEN
         IF vbIsInsert = TRUE AND ioAmount = 0 THEN ioAmount:= 1; END IF;
         -- ���� ������ ����� ��
         IF vbCurrencyId_pl_to = (SELECT OL_Currency_from.ChildObjectId
                                  FROM ObjectLink AS OL
                                       LEFT JOIN ObjectLink AS OL_Currency_from
                                                            ON OL_Currency_from.ObjectId = OL.ChildObjectId
                                                           AND OL_Currency_from.DescId   = zc_ObjectLink_PriceList_Currency()
                                  WHERE OL.ObjectId = vbFromId AND OL.DescId = zc_ObjectLink_Unit_PriceList()
                                 )
        -- ����� ����������
        AND vbPriceListId_to <> zc_PriceList_Basis()
        -- ������ ��� ��������
        AND vbIsInsert = TRUE
         THEN
              -- ��� ������ - �� �������� ����
              ioOperPriceListTo      := ioOperPriceList ;
              ioOperPriceListTo_start:= ioOperPriceList;
         END IF;
         
         -- ��������
         IF COALESCE (ioOperPriceListTo, 0) = 0 AND ioOperPriceListTo_start > 0
         THEN
             ioOperPriceListTo:= ioOperPriceListTo_start;
         END IF;
     END IF;


     -- �������� - �������� ������ ���� �����������
     IF COALESCE (ioOperPriceList, 0) <= 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <���� (�����)>.';
     END IF;

     outGoodsSizeName :=inGoodsSizeName;
     
     -- ����� ������� - ������
     vbGoodsSizeId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsSize() AND LOWER (Object.ValueData) = LOWER (inGoodsSizeName));
     --
     IF COALESCE (vbGoodsSizeId, 0) = 0
     THEN
         -- ��������
         vbGoodsSizeId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsSize (ioId     := 0
                                                                               , ioCode   := 0
                                                                               , inName   := inGoodsSizeName
                                                                               , inSession:= vbUserId :: TVarChar
                                                                                 ) AS tmp);
     END IF;

     -- ������ �� ������ : OperPrice � CountForPrice � CurrencyId
     SELECT COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
          , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
          , COALESCE (Object_PartionGoods.MovementItemId,0)                AS PartionId
            INTO outCountForPrice, outOperPrice, vbCurrencyId, vbPartionId
     FROM Object_PartionGoods
          JOIN Container ON Container.PartionId     = Object_PartionGoods.MovementItemId
                        AND Container.Amount        > 0 
                        AND Container.WhereObjectId = vbFromId
          LEFT JOIN ContainerLinkObject AS CLO_Client
                                        ON CLO_Client.ContainerId = Container.Id
                                       AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
     WHERE Object_PartionGoods.GoodsId = vbGoodsId
       AND Object_PartionGoods.GoodsSizeId = vbGoodsSizeId --Object_PartionGoods.MovementItemId = inPartionId;
       -- !!!��������� ����� �����������!!!
       AND CLO_Client.ContainerId IS NULL
    ;
     
     IF COALESCE (vbPartionId,0) = 0
     THEN
         -- ������ �� ������ : OperPrice � CountForPrice � CurrencyId
         SELECT COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
              , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
              , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
              , COALESCE (Object_PartionGoods.MovementItemId,0)                AS PartionId
                INTO outCountForPrice, outOperPrice, vbCurrencyId, vbPartionId
         FROM Object_PartionGoods
         WHERE Object_PartionGoods.GoodsId = vbGoodsId
           AND Object_PartionGoods.GoodsSizeId = vbGoodsSizeId --Object_PartionGoods.MovementItemId = inPartionId;
        ;
         
     END IF;



     -- ����� ������ ������� ���� �� �������
     IF COALESCE (vbPartionId,0) = 0
     THEN
         SELECT COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
              , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
              , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
              , COALESCE (Object_PartionGoods.MovementItemId,0)                AS PartionId 
              , COALESCE (Object_GoodsSize.ValueData, '') ::TVarChar           AS GoodsSizeName
       INTO outCountForPrice, outOperPrice, vbCurrencyId, vbPartionId, outGoodsSizeName
         FROM (SELECT MIN ( Container.PartionId) AS PartionId
               FROM Container
                    LEFT JOIN ContainerLinkObject AS CLO_Client
                                                  ON CLO_Client.ContainerId = Container.Id
                                                 AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
               WHERE Container.WhereObjectId = vbFromId
                 AND Container.DescId = zc_Container_count()
                 AND COALESCE(Container.Amount, 0) <> 0
                 AND Container.ObjectId = vbGoodsId
                 AND COALESCE (Container.Amount,0) <> 0
                 AND CLO_Client.ContainerId IS NULL -- !!!��������� ����� �����������!!!
               ) AS tmp
               LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmp.PartionId
               LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = Object_PartionGoods.GoodsSizeId
         ;
     END IF; 

     -- ���� � ����� ����� �� ������� ������, �� ������
     IF COALESCE (vbPartionId,0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������� ������ ������.';
     END IF;
     
     
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


     -- !!!������!!!
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.ObjectId = vbGoodsId AND MI.isErased = FALSE)
     AND 1=0
     THEN
         -- ���� ������ �������� (�����)(����) --(��� �������� ����������)
         ioOperPriceListTo_start:= (SELECT DISTINCT MIF.ValueData
                                    FROM MovementItem AS MI
                                         INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_OperPriceListTo_start()
                                    WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.ObjectId = vbGoodsId AND MI.isErased = FALSE
                                   );
         -- ���� (�����)(����) --(��� �������� ����������)
         ioOperPriceListTo:= (SELECT DISTINCT MIF.ValueData
                              FROM MovementItem AS MI
                                   INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_OperPriceListTo()
                              WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.ObjectId = vbGoodsId AND MI.isErased = FALSE
                             );
     END IF;

     -- PriceListTo - start - ���� ���� ���� � ����� ��� ����. ���� ��������� ��������� ����
     IF COALESCE (vbPriceListId_to,0) <> 0 AND COALESCE (ioOperPriceListTo_start, 0) <> 0
     THEN
         -- ������ - �� �������
         SELECT COALESCE (lpGet.StartDate, zc_DateStart()) AS StartDate
              , COALESCE (lpGet.ValuePrice, 0 )            AS ValuePrice
                INTO vbStartDate_plTo_find, vbOperPriceListTo_find
         FROM (SELECT vbGoodsId AS GoodsId) AS tmp
              LEFT JOIN lpGet_ObjectHistory_PriceListItem (zc_DateStart()
                                                         , vbPriceListId_to
                                                         , vbGoodsId
                                                          ) AS lpGet ON 1=1;
         -- ���� ��� ���� ��� ���� ����� �� ����, �.�. � ������������
         IF (COALESCE (vbOperPriceListTo_find, 0) = 0
             OR vbOperPriceListTo_find = (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_OperPriceListTo_start())
            )
            -- !!!��������
            -- AND vbToId = 6319 -- ������� ����
            AND vbPriceListId_to <> zc_PriceList_Basis()
         THEN
             PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId         := 0
                                                               , inPriceListId:= vbPriceListId_to
                                                               , inGoodsId    := vbGoodsId
                                                               , inOperDate   := vbStartDate_plTo_find
                                                               , inValue      := ioOperPriceListTo_start
                                                               , inUserId     := vbUserId
                                                                );
         ELSE
             -- ����� ������ �� ��� �����
             ioOperPriceListTo_start:= vbOperPriceListTo_find;
         END IF;
     END IF;
      
     -- PriceListTo - ���� ���� ���� � ����� ��� ����. ���� ��������� ��������� ����
     IF COALESCE (vbPriceListId_to,0) <> 0 AND COALESCE (ioOperPriceListTo,0) <> 0
     THEN
         -- ������ - �� �������
         SELECT COALESCE (lpGet.StartDate, vbOperDate)     AS StartDate
              , COALESCE (lpGet.ValuePrice, 0 )            AS ValuePrice
                INTO vbStartDate_plTo_find, vbOperPriceListTo_find
         FROM (SELECT vbGoodsId AS GoodsId) AS tmp
              LEFT JOIN lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                         , vbPriceListId_to
                                                         , vbGoodsId
                                                          ) AS lpGet ON 1=1;
         -- ���� ��� ���� ��� ���� ����� �� ����, �.�. � ������������
         IF (vbOperPriceListTo_find = 0
          OR vbStartDate_plTo_find  = zc_DateStart()
          OR vbOperPriceListTo_find = (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_OperPriceListTo())
            )
          -- !!!��������
          AND vbToId = 6319 -- ������� ����
         THEN
             PERFORM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId         := 0
                                                                   , inPriceListId:= vbPriceListId_to
                                                                   , inGoodsId    := vbGoodsId
                                                                   , inOperDate   := CASE WHEN vbStartDate_plTo_find = zc_DateStart() THEN vbOperDate ELSE vbStartDate_plTo_find END
                                                                   , inValue      := ioOperPriceListTo
                                                                   , inIsLast     := TRUE
                                                                   , inIsDiscountDelete:= FALSE
                                                                   , inIsDiscount := FALSE
                                                                   , inSession    := inSession
                                                                    );
         ELSE
             -- ����� ������ �� ��� �����
             ioOperPriceListTo:= vbOperPriceListTo_find;
         END IF;
     END IF;

         ---�������� ������
     vbDiscountTax_From := (SELECT ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS DiscountTax
                            FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
                                 INNER JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
                                                       ON ObjectLink_DiscountPeriodItem_Unit.ObjectId      = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                      AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = vbFromId
                                                      AND ObjectLink_DiscountPeriodItem_Unit.DescId   = zc_ObjectLink_DiscountPeriodItem_Unit()
                                 INNER JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                          ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                         AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                         AND vbOperDate >= ObjectHistory_DiscountPeriodItem.StartDate
                                                         AND vbOperDate < ObjectHistory_DiscountPeriodItem.EndDate
                                 LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                                              ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                             AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
                            WHERE ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = vbGoodsId
                              AND ObjectLink_DiscountPeriodItem_Goods.DescId = zc_ObjectLink_DiscountPeriodItem_Goods()
                            );
                            
     vbDiscountTax_To := (SELECT ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS DiscountTax
                          FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
                               INNER JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
                                                     ON ObjectLink_DiscountPeriodItem_Unit.ObjectId      = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                    AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = vbToId
                                                    AND ObjectLink_DiscountPeriodItem_Unit.DescId   = zc_ObjectLink_DiscountPeriodItem_Unit()
                               INNER JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                        ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                       AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                       AND vbOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND vbOperDate < ObjectHistory_DiscountPeriodItem.EndDate
                               LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                                            ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                           AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
                          WHERE ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = vbGoodsId
                            AND ObjectLink_DiscountPeriodItem_Goods.DescId = zc_ObjectLink_DiscountPeriodItem_Goods()
                          );



     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), vbGoodsId, vbPartionId, inMovementId, ioAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, outOperPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, ioOperPriceList);

     IF zc_Enum_GlobalConst_isTerry() = FALSE
     THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListTo_start(), ioId, ioOperPriceListTo_start);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListTo(), ioId, ioOperPriceListTo);
     END IF;


     -- ��������� �������� <���� �� ����������>
     IF COALESCE (outCountForPrice, 0) = 0 THEN outCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, outCountForPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, outCurrencyValue);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioId, outParValue);

     -- ��������� ����� �� ��������, ��� �����
     outTotalSumm := CASE WHEN outCountForPrice > 0
                               THEN CAST (ioAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                          ELSE CAST (ioAmount * outOperPrice AS NUMERIC (16, 2))
                     END;

     -- ���������� ������ ��� ���� �� �����-����� - vbPriceListId_to
     vbCurrencyId_pl_to:= (SELECT COALESCE (OH_PriceListItem_Currency.ObjectId, vbCurrencyId_pl_to) AS CurrencyId
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
                           WHERE OL_PriceListItem_Goods.ChildObjectId = vbGoodsId
                             AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                          );

    -- �������� ���� ��� ����
    SELECT COALESCE (tmpCurrency.Amount, 1)   AS CurrencyValue
         , COALESCE (tmpCurrency.ParValue, 0) AS ParValue
           INTO vbCurrencyValue_to, vbParValue_to
    FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                          , inCurrencyFromId:= zc_Currency_Basis()
                                          , inCurrencyToId  := vbCurrencyId_pl_to
                                           ) AS tmpCurrency
                                            ;

     -- ��������� ����� ��. � ��� �� ��������, ��� �����
     outTotalSummBalance := (CAST (outTotalSumm * outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END AS NUMERIC (16, 2))) ;


     -- ��������� ����� �� ������ �� ��������, ��� �����
     outTotalSummPriceList := CAST ((ioAmount * ioOperPriceList) AS NUMERIC (16, 2));

     -- ��������� ����� (����, �����)
     outTotalSummPriceListTo := CAST ((ioAmount * ioOperPriceListTo) AS NUMERIC (16, 2));

     -- ����� ��� (�� ����, �����)
     outTotalSummPriceListBalance   := (CAST (outTotalSummPriceList * CASE WHEN vbCurrencyId = zc_Currency_Basis()
                                                                           THEN 1
                                                                           ELSE outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END
                                                                      END AS NUMERIC (16, 2))) ;
     -- ����� ��� (����, �����)
     outTotalSummPriceListToBalance := (CAST (outTotalSummPriceListTo * CASE WHEN vbCurrencyId_pl_to = zc_Currency_Basis()
                                                                             THEN 1
                                                                             ELSE vbCurrencyValue_to / CASE WHEN vbParValue_to <> 0 THEN vbParValue_to ELSE 1 END
                                                                        END AS NUMERIC (16, 2))) ;


     -- � ��. ���. ������ 
     -- ��������� ����� �� ������ �� ��������, ��� �����
     outTotalSummPriceList_disc := CAST ((ioAmount * ioOperPriceList 
                                          * (1 - COALESCE (vbDiscountTax_From, 0) / 100)) AS NUMERIC (16, 2));

     -- ��������� ����� (����, �����)
     outTotalSummPriceListTo_disc := CAST ( (ioAmount * ioOperPriceListTo
                                          * (1 - COALESCE (vbDiscountTax_To, 0) / 100))  AS NUMERIC (16, 2));

     -- ����� ��� (�� ����, �����)
     outTotalSummPriceListBalance_disc   := (CAST (outTotalSummPriceList * CASE WHEN vbCurrencyId = zc_Currency_Basis()
                                                                                THEN 1
                                                                                ELSE outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END
                                                                           END
                                          * (1 - COALESCE (vbDiscountTax_From, 0) / 100) AS NUMERIC (16, 2) )) ;
     -- ����� ��� (����, �����)
     outTotalSummPriceListToBalance_disc := (CAST (outTotalSummPriceListTo * CASE WHEN vbCurrencyId_pl_to = zc_Currency_Basis()
                                                                                  THEN 1
                                                                                  ELSE vbCurrencyValue_to / CASE WHEN vbParValue_to <> 0 THEN vbParValue_to ELSE 1 END
                                                                             END
                                          * (1 - COALESCE (vbDiscountTax_To, 0) / 100)   AS NUMERIC (16, 2))) ;


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
 14.05.20         *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_SendPodium(ioId := 0 , inMovementId := 6540 , inGoodsName := '13801'::TVarChar , inGoodsSizeName := ''::TVarChar , ioAmount := 1::TFloat , ioOperPriceList := 250::TFloat , ioOperPriceListTo_start := 7525::TFloat , ioOperPriceListTo := 7525 ::TFloat,  inSession := '2'::TVarChar);
