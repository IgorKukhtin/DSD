-- Function: gpInsertUpdate_MovementItem_ContractGoods()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ContractGoods(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId                Integer   , -- ������
    IN inGoodsKindId            Integer   , -- ���� �������
    IN inisBonusNo              Boolean   , -- ��� ���������� �� �������
    IN inisSave                 Boolean   , -- c�������� ��/���
    IN inPrice                  TFloat    , --
    IN inChangePrice            TFloat    , -- ������ � ����
    IN inChangePercent          TFloat    , -- % ������ 
    IN inCountForAmount         TFloat    , -- ����� �������� �� ���-�� ����������
    IN inCountForPrice          TFloat    , -- ���� �� ����������
    IN inComment                TVarChar  , -- 
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbContractId      Integer;
   DECLARE vbPriceListId     Integer;
   DECLARE vbOperDate        TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ContractGoods());
 
     --�������� ���� ��� �������� � ������ ����� ����� �� �������, ���� � �� ��� �� ����������
     IF COALESCE (inisSave,FALSE) = FALSE
     THEN
         IF COALESCE (ioId,0) = 0 
         THEN 
             RETURN; 
         ELSE
             PERFORM lpSetErased_MovementItem (inMovementItemId:= ioId, inUserId:= vbUserId);
             RETURN;
         END IF;
     END IF;

     --�������� ���� ����� ���������� ��������� ��������� �� �� ������� ��������
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.isErased = TRUE) AND  COALESCE (inisSave,FALSE) = TRUE
     THEN
         PERFORM lpSetUnErased_MovementItem (inMovementItemId:= ioId, inUserId:= vbUserId);
     END IF;

      --�������� ������ ��� ������� ������ 1 ��������    ��� inChangePrice ��� inChangePercent
     IF COALESCE (inChangePrice,0) <> 0 AND COALESCE (inChangePercent,0) <> 0
     THEN
          RAISE EXCEPTION '������.����� ���������� ������ 1 �������� - ������� ������ ��� ������ � ����.';
     END IF;

     -- ���� ���� 0 ������� �����
     IF COALESCE (inPrice,0) = 0
     THEN
         -- ������ ���������
         SELECT Movement.OperDate
              , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                INTO vbOperDate, vbContractId
         FROM Movement
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
         WHERE Movement.Id = inMovementId
           AND Movement.DescId = zc_Movement_ContractGoods();

         vbPriceListId := (SELECT ObjectLink_ContractPriceList_PriceList.ChildObjectId AS PriceListId
                           FROM (SELECT vbContractId AS ContractId) AS tmp
                            
                                 INNER JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                                                       ON ObjectLink_ContractPriceList_Contract.ChildObjectId = tmp.ContractId
                                                      AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
                       
                                 INNER JOIN Object AS Object_ContractPriceList
                                                   ON Object_ContractPriceList.Id = ObjectLink_ContractPriceList_Contract.ObjectId
                                                  AND Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
                                                  AND Object_ContractPriceList.isErased = FALSE

                                 INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                       ON ObjectDate_StartDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                      AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
                                                      AND ObjectDate_StartDate.ValueData <= vbOperDate
                                 INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                       ON ObjectDate_EndDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                      AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractPriceList_EndDate()
                                                      AND ObjectDate_EndDate.ValueData >= vbOperDate

                                 LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                                                      ON ObjectLink_ContractPriceList_PriceList.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                     AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()
                       );
         
         inPrice := COALESCE ( (SELECT lfSelect.ValuePrice  AS Price_PriceList
                                FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate) AS lfSelect
                                WHERE lfSelect.GoodsId = inGoodsId AND COALESCE(lfSelect.GoodsKindId,0) = COALESCE (inGoodsKindId,0) LIMIT 1)
                             , (SELECT lfSelect.ValuePrice  AS Price_PriceList
                                FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate) AS lfSelect
                                WHERE lfSelect.GoodsId = inGoodsId LIMIT 1)
                             ,0 )::TFloat;

     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_ContractGoods (ioId            := ioId
                                                      , inMovementId    := inMovementId
                                                      , inGoodsId       := inGoodsId
                                                      , inGoodsKindId   := inGoodsKindId
                                                      , inisBonusNo     := inisBonusNo
                                                      , inPrice         := inPrice
                                                      , inChangePrice   := inChangePrice
                                                      , inChangePercent := inChangePercent
                                                      , inCountForAmount:= inCountForAmount
                                                      , inCountForPrice := inCountForPrice
                                                      , inComment       := inComment
                                                      , inUserId        := vbUserId
                                                       ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.11.24         *
 08.11.23         *
 28.07.22         *
 05.07.21         *
*/

-- ����
--