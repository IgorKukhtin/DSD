-- Function: gpInsertUpdate_MovementItem_GoodsAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsAccount(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inPartionId              Integer   , -- ������
    IN inSaleMI_Id              Integer   , -- ������ �������� �������/�������
   OUT outLineNum               Integer   , -- � �.�.
   OUT outIsLine                TVarChar  , -- � �.�.
    IN inIsPay                  Boolean   , -- �������� � �������
    IN inAmount                 TFloat    , -- ����������
   OUT outSummChangePercent     TFloat    , -- ����� ���. ������ - "������� �����������"
   OUT outTotalPay              TFloat    , -- ����� ������ - "������� �����������"
   OUT outSummDebt              TFloat    , -- ����
    IN inComment                TVarChar  , -- ����������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId          Integer;

   DECLARE vbMovementId_sale Integer; -- <�������� �������>
   DECLARE vbPartionMI_Id    Integer;
   DECLARE vbUnitId          Integer;
   DECLARE vbUnitId_user     Integer;
   DECLARE vbCashId          Integer;
   DECLARE vbGoodsId         Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_GoodsAccount());
     vbUserId:= lpGetUserBySession (inSession);


     -- �������� ��� ������������ - � ������ ������������� �� ��������
     vbUnitId_user:= lpGetUnit_byUser (vbUserId);

     -- ���������� ������ �������� �������/��������
     vbPartionMI_Id := lpInsertFind_Object_PartionMI (inSaleMI_Id);
     -- ���������� ��� ��������
     vbMovementId_sale:=  (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inSaleMI_Id);

     -- ��������� �� ���������
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());


     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (vbUnitId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�������������>.';
     END IF;
     -- �������� - ������������
     IF vbUnitId_user > 0 AND vbUnitId_user <> vbUnitId THEN
        RAISE EXCEPTION '������.��� ���� ��������� �������� ��� ������������� <%>.', lfGet_Object_ValueData_sh (vbUnitId);
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inSaleMI_Id, 0) = 0 AND  vbUserId <> zc_User_Sybase() THEN
        RAISE EXCEPTION '������.�� ��������� ������� �������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF inAmount < 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <���-��>.';
     END IF;
     -- �������� - ���������� vbPartionMI_Id
     IF EXISTS (SELECT 1 FROM MovementItem AS MI INNER JOIN MovementItemLinkObject AS MILO ON MILO.MovementItemId = MI.Id AND MILO.DescId = zc_MILinkObject_PartionMI() AND MILO.ObjectId = vbPartionMI_Id WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.Id <> COALESCE (ioId, 0)) THEN
        RAISE EXCEPTION '������.� ��������� ��� ���� ����� <% %> �.<%>.������������ ���������.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                       ;
     END IF;


     -- ������
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!��� SYBASE - ����� ������!!!
         IF 1=0 THEN RAISE EXCEPTION '������.�������� ������ ��� �������� �� Sybase.'; END IF;
     ELSE
         -- �������������� ������ � �������� ���
         IF (inIsPay = TRUE AND inAmount <> COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId), 0))
            OR inAmount = 0
         THEN
             -- !!!��������!!!
             outSummChangePercent:= 0;
         ELSE
             -- ����� �� ��� ����
             outSummChangePercent:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChangePercent()), 0);
         END IF;

     END IF;


     -- ������ �� ������ : GoodsId
     vbGoodsId:= (SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId);


     -- ���������
     ioId:= lpInsertUpdate_MovementItem_GoodsAccount (ioId                 := ioId
                                                    , inMovementId         := inMovementId
                                                    , inGoodsId            := vbGoodsId
                                                    , inPartionId          := COALESCE (inPartionId, 0)
                                                    , inPartionMI_Id       := COALESCE (vbPartionMI_Id, 0)
                                                    , inAmount             := inAmount
                                                    , inComment            := COALESCE (inComment,'') :: TVarChar
                                                    , inUserId             := vbUserId
                                                     );

     -- ��������� ������ � ���
     IF inIsPay = TRUE AND vbUserId <> zc_User_Sybase()
     THEN
         -- ������� ����� ������ � �������� ��� = "������� �����", ��� �����
         outTotalPay := CASE WHEN inAmount = 0
                        THEN 0
                        ELSE COALESCE ((SELECT zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                             - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                             - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                             - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                             - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                                               -- ��� ��������� �������
                                             - COALESCE (MIFloat_TotalReturn.ValueData, 0)
                                               -- !!!����!!!
                                             + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
                                               -- ����� ������ ������
                                             - outSummChangePercent
                                        FROM MovementItem
                                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                                         ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                         ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                                         ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                         ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                                         ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                                         ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                                         ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
                                        WHERE MovementItem.MovementId = vbMovementId_sale
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.Id         = inSaleMI_Id
                                          AND MovementItem.isErased   = FALSE
                                       ), 0)
                        END;

         -- ������� ����� ��� ��������, � ������� ������� ������
         vbCashId := (SELECT lpSelect.CashId
                      FROM lpSelect_Object_Cash (vbUnitId, vbUserId) AS lpSelect
                      WHERE lpSelect.isBankAccount = FALSE
                        AND lpSelect.CurrencyId    = zc_Currency_GRN()
                     );
         -- �������� - �������� ������ ���� �����������
         IF COALESCE (vbCashId, 0) = 0 THEN
           RAISE EXCEPTION '������.��� �������� <%> �� ����������� �������� <�����> � ���. (%)', lfGet_Object_ValueData (vbUnitId), vbUnitId;
         END IF;

         -- ���������
         PERFORM lpInsertUpdate_MI_GoodsAccount_Child (ioId                 := tmp.Id
                                                     , inMovementId         := inMovementId
                                                     , inParentId           := ioId
                                                     , inCashId             := tmp.CashId
                                                     , inCurrencyId         := tmp.CurrencyId
                                                     , inCashId_Exc         := NULL
                                                     , inAmount             := tmp.Amount
                                                     , inCurrencyValue      := tmp.CurrencyValue
                                                     , inParValue           := tmp.ParValue
                                                     , inUserId             := vbUserId
                                                      )
         FROM (WITH tmpMI AS (SELECT MovementItem.Id                 AS Id
                                   , MovementItem.ObjectId           AS CashId
                                   , MILinkObject_Currency.ObjectId  AS CurrencyId
                                   , MIFloat_CurrencyValue.ValueData AS CurrencyValue
                                   , MIFloat_ParValue.ValueData      AS ParValue
                              FROM MovementItem
                                   LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                               ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                              AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                                   LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                               ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                              AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                    ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                              WHERE MovementItem.ParentId   = ioId
                                AND MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Child()
                                AND MovementItem.isErased   = FALSE
                             )
               SELECT tmpMI.Id                                                  AS Id
                    , COALESCE (_tmpCash.CashId, tmpMI.CashId)                  AS CashId
                    , COALESCE (_tmpCash.CurrencyId, tmpMI.CurrencyId)          AS CurrencyId
                    , CASE WHEN _tmpCash.CashId > 0 THEN outTotalPay ELSE 0 END AS Amount
                    , COALESCE (tmpMI.CurrencyValue, 0)                         AS CurrencyValue
                    , COALESCE (tmpMI.CurrencyId, 0)                            AS ParValue
               FROM (SELECT vbCashId AS CashId, zc_Currency_GRN() AS CurrencyId
                    ) AS _tmpCash
                    FULL JOIN tmpMI ON tmpMI.CashId = _tmpCash.CashId
              ) AS tmp
         ;

         -- � ������ �������� - �������������� ������ � �������� ��� - �.�. ����� ��������
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, COALESCE (outSummChangePercent, 0));

         -- � ������ �������� - ����� ������ � �������� ���
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, outTotalPay);

         -- ����������� �������� ����� �� ���������
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     ELSE
        -- ������� ����� ������ � �������� ���, ��� �����
         outTotalPay := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()), 0);
     END IF;


     -- ������� ����� ����� ���, ��� �����
     outSummDebt:= COALESCE ((SELECT zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                   - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                   - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                   - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                   - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                                     -- ��� ��������� �������
                                   - COALESCE (MIFloat_TotalReturn.ValueData, 0)
                                     -- !!!����!!!
                                   + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
                                     -- ��������� ���� �� ����� �� ���. ���������
                                   - outSummChangePercent
                                   - outTotalPay
                              FROM MovementItem
                                   LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                               ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                              AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                               ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                               ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                               ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                               ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                               ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                               ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
                              WHERE MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.MovementId = vbMovementId_sale
                                AND MovementItem.Id         = inSaleMI_Id
                                AND MovementItem.isErased   = FALSE
                             ), 0);



    -- � �.�. ������
    SELECT CASE WHEN tmp.isErased = FALSE AND tmp.Amount > 0 THEN tmp.LineNum ELSE NULL END :: Integer  AS LineNum
         , CASE WHEN tmp.isErased = FALSE AND tmp.Amount > 0 THEN '*'         ELSE '_'  END :: TVarChar AS isLine
           INTO outLineNum, outIsLine
    FROM (SELECT MI_Master.Id
               , ROW_NUMBER() OVER (ORDER BY CASE WHEN MI_Master.isErased = FALSE AND MI_Master.Amount > 0 THEN 0 ELSE 1 END ASC, MI_Master.Id ASC) AS LineNum
               , MI_Master.Amount
               , MI_Master.isErased
          FROM MovementItem AS MI_Master
          WHERE MI_Master.MovementId = inMovementId
            AND MI_Master.DescId     = zc_MI_Master()
         ) AS tmp
    WHERE tmp.Id = ioId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.03.18         *
 18.05.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_GoodsAccount (ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');
