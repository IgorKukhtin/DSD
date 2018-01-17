-- Function: gpInsertUpdate_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnIn(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
 INOUT ioGoodsId                Integer   , -- ������
    IN inPartionId              Integer   , -- ������
    IN inSaleMI_Id              Integer   , -- ������ ���. �������
    IN inIsPay                  Boolean   , -- �������� � �������
    IN inAmount                 TFloat    , -- ����������
   OUT outOperPrice             TFloat    , -- ���� ��. � ������
   OUT outCountForPrice         TFloat    , -- ���� �� ����������
   OUT outTotalSumm             TFloat    , -- +����� ��. � ������
   OUT outTotalSummBalance      TFloat    , -- +����� ��. (���)
 INOUT ioOperPriceList          TFloat    , -- *** - ���� �� ������
   OUT outTotalSummPriceList    TFloat    , -- +����� �� ������
   OUT outCurrencyValue         TFloat    , -- *���� ��� �������� �� ������
   OUT outParValue              TFloat    , -- *������� ��� �������� �� ����
   OUT outTotalChangePercent    TFloat    , -- ����� ����� �������� ������ (� ���)
   OUT outTotalPay              TFloat    , -- ����� ����� �������� ������ (� ���)
   OUT outTotalPayOth           TFloat    , -- ����� ����� �������� ������  � �������� (� ���)
   OUT outTotalSummToPay        TFloat    , -- +����� � �������� ���
    IN inComment                TVarChar  , -- ����������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionMI_Id Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbClientId Integer;
   DECLARE vbCashId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());
     -- !!!�������� - ��� Sybase!!!
     vbUserId := zc_User_Sybase() ;


     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inSaleMI_Id, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ��������� ������� �������.';
     END IF;


     -- ������ �� �����
     SELECT Movement.OperDate                AS OperDate
          , MovementLinkObject_From.ObjectId AS ClientId
          , MovementLinkObject_To.ObjectId   AS UnitId
            INTO vbOperDate, vbClientId, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;


     -- ���������� ������ �������� �������/��������
     vbPartionMI_Id := lpInsertFind_Object_PartionMI (inSaleMI_Id);


     -- ������ �� ������ : GoodsId � OperPrice � CountForPrice � CurrencyId
     SELECT Object_PartionGoods.GoodsId                                    AS GoodsId
          , COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
          , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
            INTO ioGoodsId, outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (ioGoodsId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;

     -- ���� (�����)
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!��� SYBASE - ����� ������!!!
         IF 1=0 THEN RAISE EXCEPTION '������.�������� ������ ��� �������� �� Sybase.'; END IF;
     ELSE
         -- �� �������� �������
         ioOperPriceList := (SELECT COALESCE (MIFloat_OperPriceList.ValueData, 0) AS OperPriceList
                             FROM MovementItemFloat AS MIFloat_OperPriceList
                             WHERE MIFloat_OperPriceList.MovementItemId = inSaleMI_Id
                               AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                            );
         -- �������� - �������� ������ ���� �����������
         IF COALESCE (ioOperPriceList, 0) <= 0 THEN
            RAISE EXCEPTION '������.�� ����������� �������� <���� (�����)>. (%)', inSaleMI_Id;
         END IF;

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


     -- ������� ����� ��. � ������, ��� ����� - ��������� �� 2-� ������
     outTotalSumm := zfCalc_SummIn (inAmount, outOperPrice, outCountForPrice);
     -- ������� ����� ��. � ��� �� ��������, ��� �����
     outTotalSummBalance := zfCalc_CurrencyFrom (outTotalSumm, outCurrencyValue, outParValue);

     -- ��������� ����� �� ������ �� ��������, ��� �����
     outTotalSummPriceList := zfCalc_SummPriceList (inAmount, ioOperPriceList);

     -- ��������� ����� ������ � �������� ���, ��� ����� - !!!�� �������� �������!!!
     IF inIsPay = TRUE
     THEN
         outTotalPay := COALESCE ((SELECT CASE -- ���� ������� ��� - ��� ����� ������
                                               WHEN MovementItem.Amount = inAmount
                                                    THEN COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0)

                                               -- ���� ������� ��� ��� �������� - ����� ���������� ������� ��� ����� ������ � ��������
                                               WHEN MovementItem.Amount - COALESCE (MIFloat_TotalCountReturn.ValueData, 0) = inAmount
                                                    THEN COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) - COALESCE (MIFloat_TotalPayReturn.ValueData, 0)

                                               -- ���� ������ * "���� � ������" ������ ��� ������� ������ - ����� ���� ���������� ������� ��� ����� ������ � ��������
                                               WHEN (zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                                   - COALESCE (MIFloat_TotalChangePercent.ValueData, 0) - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                                    )
                                                  / MovementItem.Amount * inAmount
                                                      >= COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) - COALESCE (MIFloat_TotalPayReturn.ValueData, 0)

                                                    THEN COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) - COALESCE (MIFloat_TotalPayReturn.ValueData, 0)

                                               -- ����� ������ * ���� � ������
                                               ELSE ROUND ((zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                                          - COALESCE (MIFloat_TotalChangePercent.ValueData, 0) - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                                           )
                                                         / MovementItem.Amount * inAmount, 2)
                                          END
                                   FROM MovementItem
                                        LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                                    ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                    ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                                    ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()
                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                                    ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                                    ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()

                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                    ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                                    ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                                   WHERE MovementItem.Id         = inSaleMI_Id
                                     -- AND MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Master()
                                     AND MovementItem.isErased   = FALSE
                                  ), 0);
     ELSE
         outTotalPay := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()), 0);
     END IF;

     -- ��������� ����� ����� �������� ������ (� ���)
     outTotalChangePercent:= (SELECT CASE -- ���� ������� ��� - ����� ��� ������ �� �������
                                          WHEN MovementItem.Amount = inAmount
                                               THEN COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)

                                          -- !!!������� ������ - ��� Sybase - ��� � ����� �������� ������ ���� ��� = 0 - ������ ��� ��/�=1!!!
                                          WHEN vbUserId = zc_User_Sybase()
                                           AND MIBoolean_Close.ValueData = TRUE
                                               -- ��/�=1
                                           AND COALESCE (ioId, 0) = COALESCE ((SELECT tmp.Id
                                                                               FROM (SELECT MovementItem.Id
                                                                                          , ROW_NUMBER() OVER (PARTITION BY MIL_PartionMI.ObjectId ORDER BY Movement.OperDate ASC, MovementItem.Id ASC) AS Ord
                                                                                     FROM MovementItemLinkObject AS MIL_PartionMI
                                                                                          INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                                 AND MovementItem.DescId   = zc_MI_Master()
                                                                                                                 AND MovementItem.isErased = FALSE
                                                                                          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                                             AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                                             AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                                      ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                                     AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
      
                                                                                     WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                                                                       AND MIL_PartionMI.ObjectId = vbPartionMI_Id
      
                                                                                    ) AS tmp
                                                                               WHERE tmp.Ord = 1
                                                                              ), 0)

                                               THEN 0 - (-- ����� �� ������
                                                         zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                                         -- ����� ������� ������ !!!������ �� �������, �.�. ��� Sybase ������ �� �������=0!!!
                                                       - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                                         -- ����� ����� ����� ������ !!!������ �� �������!!!
                                                       - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                                         -- ����� ����� ������ !!!������� - ��� �������!!!
                                                       - COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0))
                                                                    FROM MovementItemLinkObject AS MIL_PartionMI
                                                                         INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                AND MovementItem.DescId   = zc_MI_Master()
                                                                                                AND MovementItem.isErased = FALSE
                                                                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                            AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                                                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                     ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                                                      AND MIL_PartionMI.ObjectId = vbPartionMI_Id

                                                                   ), 0)
                                                         -- ����� ����� - ����� ������� �� ������
                                                       - zfCalc_SummPriceList (COALESCE ((SELECT SUM (MovementItem.Amount)
                                                                                          FROM MovementItemLinkObject AS MIL_PartionMI
                                                                                               INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                                      AND MovementItem.DescId   = zc_MI_Master()
                                                                                                                      AND MovementItem.isErased = FALSE
                                                                                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                                                  AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                                                  AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                                          WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                                                                            AND MIL_PartionMI.ObjectId = vbPartionMI_Id
                      
                                                                                         ), 0)
                                                                             , MIFloat_OperPriceList.ValueData)
                                                         -- ���� ����� - ����� ������� ������
                                                       + COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0))
                                                                    FROM MovementItemLinkObject AS MIL_PartionMI
                                                                         INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                AND MovementItem.DescId   = zc_MI_Master()
                                                                                                AND MovementItem.isErased = FALSE
                                                                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                            AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                     ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                                                      AND MIL_PartionMI.ObjectId = vbPartionMI_Id

                                                                   ), 0)
                                                         /*COALESCE ((SELECT MIFloat_TotalPay.ValueData
                                                                    FROM MovementItemFloat AS MIFloat_TotalPay
                                                                    WHERE MIFloat_TotalPay.MovementItemId = ioId
                                                                      AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                                                   ), 0)*/
                                                        )

                                          -- !!!����� - ��� Sybase - ��/�<>1!!!
                                          WHEN vbUserId = zc_User_Sybase()
                                           AND MIBoolean_Close.ValueData = TRUE
                                               THEN 0

                                          -- !!!��� Sybase!!! ���� ������� ��� �� �� ����� - ����� ��� ������ �� ������� ����� ������� ������ ������� ������
                                          WHEN vbUserId = zc_User_Sybase()
                                           AND MovementItem.Amount - COALESCE ((SELECT SUM (COALESCE (MovementItem.Amount, 0))
                                                                                FROM MovementItemLinkObject AS MIL_PartionMI
                                                                                     INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                            AND MovementItem.DescId   = zc_MI_Master()
                                                                                                            AND MovementItem.isErased = FALSE
                                                                                                            AND (MovementItem.Id < ioId OR COALESCE (ioId, 0) = 0)
                                                                                     INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                                        AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                                        AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                                WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                                  AND MIL_PartionMI.ObjectId = vbPartionMI_Id
            
                                                                               ), 0)
                                             = inAmount
                                               THEN COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                                    -- ����� ������� ������ ������� ������
                                                  - COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalChangePercent.ValueData, 0))
                                                               FROM MovementItemLinkObject AS MIL_PartionMI
                                                                    INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                           AND MovementItem.DescId   = zc_MI_Master()
                                                                                           AND MovementItem.isErased = FALSE
                                                                                           AND (MovementItem.Id < ioId OR COALESCE (ioId, 0) = 0)
                                                                    INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                       AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                       AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                    LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                                                ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                                               AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()

                                                               WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                 AND MIL_PartionMI.ObjectId = vbPartionMI_Id

                                                              ), 0)

                                          -- ���� ������� ��� �� �� ����� - ����� ��� ������ �� ������� ����� ������� ������ ������� ������
                                          WHEN MovementItem.Amount - COALESCE (MIFloat_TotalCountReturn.ValueData, 0)  = inAmount
                                               THEN COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                                    -- ����� ������� ������ ������� ������
                                                  - COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalChangePercent.ValueData, 0))
                                                               FROM MovementItemLinkObject AS MIL_PartionMI
                                                                    INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                           AND MovementItem.DescId   = zc_MI_Master()
                                                                                           AND MovementItem.isErased = FALSE
                                                                    INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                       AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                    LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                                                ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                                               AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()

                                                               WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                 AND MIL_PartionMI.ObjectId = vbPartionMI_Id

                                                              ), 0)
                                          
                                          ELSE -- ����� ����� ��������������� - �������� ������� ����� ����� ������� �����
                                               ROUND ((COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0))
                                                    / MovementItem.Amount * inAmount, 2)
                                     END
                             FROM MovementItem
                                LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                                              ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_Close.DescId         = zc_MIBoolean_Close()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                            ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                            ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                            ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                            ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()

                             WHERE MovementItem.Id         = inSaleMI_Id
                               -- AND MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE
                            );

-- RAISE EXCEPTION '<%>', outTotalChangePercent;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_ReturnIn (ioId                    := ioId
                                                , inMovementId            := inMovementId
                                                , inGoodsId               := ioGoodsId
                                                , inPartionId             := inPartionId
                                                , inPartionMI_Id          := vbPartionMI_Id
                                                , inAmount                := inAmount
                                                , inOperPrice             := COALESCE (outOperPrice, 0)
                                                , inCountForPrice         := COALESCE (outCountForPrice, 0)
                                                , inOperPriceList         := ioOperPriceList
                                                , inCurrencyValue         := outCurrencyValue
                                                , inParValue              := outParValue
                                                , inTotalChangePercent    := COALESCE (outTotalChangePercent, 0)
                                                , inComment               := -- !!!��� SYBASE - ����� ������!!!
                                                                             CASE WHEN vbUserId = zc_User_Sybase() AND SUBSTRING (inComment FROM 1 FOR 5) = '*123*'
                                                                                       THEN -- ������ �������
                                                                                            SUBSTRING (inComment FROM 6 FOR CHAR_LENGTH (inComment) - 5)
                                                                                       ELSE inComment
                                                                             END
                                                , inUserId                := vbUserId
                                                 );

    -- !!!��� SYBASE - ����� ������!!!
    IF vbUserId = zc_User_Sybase() AND SUBSTRING (inComment FROM 1 FOR 5) = '*123*'
    THEN
        -- ��������� ��� �������� - � SYBASE ��� ��������� ���������� ������� -> ���� ����������� ��������
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Close(), ioId, TRUE);

    ELSEIF vbUserId = zc_User_Sybase() AND EXISTS (SELECT 1 FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = ioId AND MIB.DescId = zc_MIBoolean_Close() AND MIB.ValueData = TRUE)
    THEN
        -- ������ ��� �������� - � SYBASE ��� �� ��������� ���������� ������� -> �� ���� ����������� ��������
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Close(), ioId, FALSE);

    END IF;


    -- ��������� ������ � ���
    IF inIsPay = TRUE THEN
       -- ������� ����� ��� ��������, � ������� ������� ������
        vbCashId := (SELECT Object_Cash.Id AS CashId
                     FROM Object AS Object_Unit
                          -- ���� ����� �������� �� ��������
                          LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                               ON ObjectLink_Cash_Unit.ChildObjectId = Object_Unit.Id
                                              AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
                          -- ����� ��������� ����� ����� ������ �������������
                          LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                               ON ObjectLink_Unit_Parent.ObjectId    = Object_Unit.Id
                                              AND ObjectLink_Unit_Parent.DescId      = zc_ObjectLink_Unit_Parent()
                                              AND ObjectLink_Cash_Unit.ChildObjectId IS NULL
                          LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit_Parent
                                               ON ObjectLink_Cash_Unit_Parent.ChildObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                              AND ObjectLink_Cash_Unit_Parent.DescId        = zc_ObjectLink_Cash_Unit()
                          -- ����� ��� �����
                          LEFT JOIN Object AS Object_Cash
                                           ON Object_Cash.Id       = COALESCE (ObjectLink_Cash_Unit.ObjectId, ObjectLink_Cash_Unit_Parent.ObjectId)
                                          AND Object_Cash.DescId   = zc_Object_Cash()
                                          AND Object_Cash.isErased = FALSE
                          -- ������
                          INNER JOIN ObjectLink AS ObjectLink_Cash_Currency
                                                ON ObjectLink_Cash_Currency.ObjectId      = Object_Cash.Id
                                               AND ObjectLink_Cash_Currency.DescId        = zc_ObjectLink_Cash_Currency()
                                               AND ObjectLink_Cash_Currency.ChildObjectId = zc_Currency_GRN()

                     WHERE Object_Unit.Id = vbUnitId
                    );

        -- �������� - �������� ������ ���� �����������
        IF COALESCE (vbCashId, 0) = 0 THEN
          -- ��� Sybase - ��������
          IF vbUserId = zc_User_Sybase()
          THEN vbCashId:= 4219;
          ELSE RAISE EXCEPTION '������.��� �������� <%> �� ����������� �������� <�����> � ���. (%)', lfGet_Object_ValueData (vbUnitId), vbUnitId;
          END IF;
        END IF;

       -- ���������
       PERFORM lpInsertUpdate_MI_ReturnIn_Child (ioId                 := tmp.Id
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
            ) AS tmp;

       -- � ������ �������� - ����� ������ ��� �������� ���
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, outTotalPay);

       -- ����������� �������� ����� �� ���������
       PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    END IF;


    -- "������" ����������� "��������" ����� �� ��������
    PERFORM lpUpdate_MI_ReturnIn_Total (ioId);


    -- ������� ����� �������� ������ � �������� ���, ��� �����
    outTotalPayOth:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayOth()), 0);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.06.17         *
 15.05.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_ReturnIn(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');
