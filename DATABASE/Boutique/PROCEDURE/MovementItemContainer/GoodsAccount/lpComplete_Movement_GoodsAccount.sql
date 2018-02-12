DROP FUNCTION IF EXISTS lpComplete_Movement_GoodsAccount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_GoodsAccount(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId          Integer;
  DECLARE vbOperDate                TDateTime;
  DECLARE vbUnitId                  Integer;
  DECLARE vbClientId                Integer;
  DECLARE vbAccountDirectionId_From Integer;
  DECLARE vbJuridicalId_Basis       Integer; -- �������� ���� �� ������������
  DECLARE vbBusinessId              Integer; -- �������� ���� �� ������������
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� ������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpPay;
     -- !!!�����������!!! �������� ������� - �������� �� ����������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummClient;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

     -- !!!�������� - ��� Sybase!!!
     inUserId := zc_User_Sybase();


     -- ��������� �� ���������
     SELECT _tmp.MovementDescId, _tmp.OperDate, _tmp.UnitId, _tmp.ClientId
          , _tmp.AccountDirectionId_From
            INTO vbMovementDescId
               , vbOperDate
               , vbUnitId
               , vbClientId
               , vbAccountDirectionId_From
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Unit()   THEN Object_To.Id   ELSE 0 END, 0) AS UnitId
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Client() THEN Object_From.Id ELSE 0 END, 0) AS ClientId

                  -- !!!������ - zc_Enum_AccountDirection_20100!!! �������� + ����������
                , zc_Enum_AccountDirection_20100() AS AccountDirectionId_From

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_GoodsAccount()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmp;


     -- �������� - ����������� �������������
     IF COALESCE (vbUnitId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� �������� <�������������>. (%)(%)(%)'
                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                        , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                        , inMovementId
                        ;
     END IF;
     -- �������� - ���������� ����������
     IF COALESCE (vbClientId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� �������� <����������>. (%)(%)(%)'
                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                        , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                        , inMovementId
                        ;
     END IF;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods
                         , GoodsId, PartionId, PartionId_MI, GoodsSizeId
                         , OperCount, OperPrice, CountForPrice, OperSumm, OperSumm_Currency
                         , OperSumm_ToPay, OperSummPriceList, TotalChangePercent, SummChangePercent_curr, TotalPay, TotalPay_curr
                         , Summ_10201, Summ_10202, Summ_10203, Summ_10204
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , SummDebt_sale, SummDebt_return
                         , CurrencyValue, ParValue
                         , isGoods_Debt
                          )
       WITH -- ��� Sybase
            tmpCheck AS (SELECT -12345 AS PartionId_MI
                   /*UNION SELECT 366872 AS PartionId_MI
                   UNION SELECT 374215
                   UNION SELECT 739198
                   UNION SELECT 739264
                   UNION SELECT 739269
                   UNION SELECT 739270
                   UNION SELECT 739271
                   UNION SELECT 744408
                   UNION SELECT 744677
                   UNION SELECT 739173
                   UNION SELECT 739185*/

UNION SELECT 923274 -- select ObP.*, MovementItem.* , Movement.* from MovementItem join Object as ObP on ObP.ObjectCode = MovementItem.Id and ObP.DescId = zc_Object_PartionMI() join Movement on Movement.Id = MovementId and Movement.DescId = zc_Movement_Sale() and Movement.Operdate = '14.05.2012' where PartionId = (SELECT MovementItemId FROM Object_PartionGoods join Object on Object.Id = GoodsId and Object.ObjectCode = 69023 join Object as o2 on o2.Id = GoodsSizeId and o2.ValueData = '40')
UNION SELECT 793448
UNION SELECT 793469
UNION SELECT 793471
UNION SELECT 821522
UNION SELECT 821528
UNION SELECT 793544
UNION SELECT 793184
UNION SELECT 793202
UNION SELECT 476394
UNION SELECT 483737
UNION SELECT 793470

UNION SELECT 476871
UNION SELECT 476872
UNION SELECT 479822
UNION SELECT 480378
UNION SELECT 793598
UNION SELECT 895551
UNION SELECT 895554
UNION SELECT 476874
UNION SELECT 895549
UNION SELECT 895552
UNION SELECT 476394
UNION SELECT 476873
UNION SELECT 895553
UNION SELECT 895548
UNION SELECT 895550
UNION SELECT 895555
                         -- FROM gpSelect_MovementItem_Sale_Sybase_Check()
                        )
            -- ������ �� MI + ������ SummDebt
          , tmpMI AS (SELECT MovementItem.Id                  AS MovementItemId
                           , Object_PartionGoods.GoodsId      AS GoodsId
                           , MovementItem.PartionId           AS PartionId
                           -- , Object_PartionMI.ObjectCode   AS MovementItemId_MI
                           , MILinkObject_PartionMI.ObjectId  AS PartionId_MI
                           , Object_PartionGoods.GoodsSizeId  AS GoodsSizeId
                           , MovementItem.Amount              AS OperCount
                           , Object_PartionGoods.OperPrice    AS OperPrice
                           , MIFloat_OperPriceList.ValueData  AS OperPriceList
                           , CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS CountForPrice
                           , Object_PartionGoods.CurrencyId   AS CurrencyId


                             -- ���� ��. � ������ - ������� ��������� � zc_Currency_Basis - � ����������� �� 2-� ������
                           , zfCalc_PriceIn_Basis (Object_PartionGoods.CurrencyId, Object_PartionGoods.OperPrice, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData) AS OperPrice_basis

                             -- !!!1.1. ����� ������ - ������� ������ ����� - ��� ��������!!!
                           , -- ����� �� ������
                             zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)

                             -- �����: ����� ����� ������ (� ���) - ��� ���� ���������� - ����������� 1)�� %������ + 2)�������������� + 3)�������������� � ������� + 4)� ������� ���������
                           - (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) + COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0))

                             -- �����: ����� ����� ������ (� ���) - ��� ���� ���������� - ����������� 1) + 2) + 3)� ������� ��������� �� zc_MI_Child
                           - (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) + COALESCE (MIFloat_TotalPay_curr.ValueData, 0))

                             -- !!!�������� - ��� Sybase!!! - zc_Enum_Status_UnComplete
                           - COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_SummChangePercent.ValueData, 0))
                                        FROM MovementItemLinkObject AS MIL_PartionMI
                                             INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                                    AND MovementItem.isErased   = FALSE
                                                                    AND MovementItem.MovementId <> inMovementId
                                             INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                                AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                         ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                             LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                         ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                                        WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                          AND MIL_PartionMI.ObjectId     = MILinkObject_PartionMI.ObjectId
                                          AND inUserId                   = zc_User_Sybase()
                                          AND MIFloat_TotalPay.ValueData < 0
                                       ), 0)

                             AS SummDebt_sale -- 1.1.


                             -- !!!1.2. ����� ������ - ������� ������ ����� - � ������ ��������!!!
                           , -- ����� �� ������
                             zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)

                             -- �����: ����� ����� ������ (� ���) - ��� ���� ���������� - ����������� 1)�� %������ + 2)�������������� + 3)�������������� � ������� + 4)� ������� ���������
                           - (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) + COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0))

                             -- �����: ����� ����� ������ (� ���) - ��� ���� ���������� - ����������� 1) + 2) + 3)� ������� ��������� �� zc_MI_Child
                           - (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) + COALESCE (MIFloat_TotalPay_curr.ValueData, 0))

                             -- ����� TotalReturn - ����� ����� �������� �� ������� - ��� ���-��
                           - COALESCE (MIFloat_TotalReturn.ValueData, 0)
                             -- !!!����!!! TotalReturn - ����� ������� ������ - ��� ���-��
                           + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)

                             -- !!!�������� - ��� Sybase!!! - zc_Enum_Status_UnComplete
                           /*- COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_SummChangePercent.ValueData, 0))
                                        FROM MovementItemLinkObject AS MIL_PartionMI
                                             INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                                    AND MovementItem.isErased   = FALSE
                                                                    AND MovementItem.MovementId <> inMovementId
                                             INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                                AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                         ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                             LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                         ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                                        WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                          AND MIL_PartionMI.ObjectId     = MILinkObject_PartionMI.ObjectId
                                          AND inUserId                   = zc_User_Sybase()
                                          AND MIFloat_TotalPay.ValueData < 0
                                       ), 0)*/
                             AS SummDebt_return -- 1.2.


                             -- ���-�� � ����� �������
                           , MI_Sale.Amount AS Amount_Sale
                             -- ������ % - � ����� �������
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0)          AS ChangePercent
                             -- ������ � ����� ������� - ����������� 1)�� %������ + 2)��������������
                           , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)     AS TotalChangePercent
                             -- ������ � ����� ������� - �������������� �� ������� �����������
                           , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)  AS TotalChangePercentPay
                             -- ����� ������ � ����� �������
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)               AS TotalPay
                             -- ����� ������ � ����� ������� - �� ������� �����������
                           , COALESCE (MIFloat_TotalPayOth.ValueData, 0)            AS TotalPayOth

                             -- ���-�� ����� �������
                           , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)       AS Amount_Return
                             -- ����� ����� �������� �� ������� - ��� ���-��
                           , COALESCE (MIFloat_TotalReturn.ValueData, 0)            AS TotalReturn
                             -- ����� ����� �������� ������ - ��� ���-��
                           , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)         AS TotalPayReturn

                             -- ����� ������ - � ������� ���������
                           , COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0) AS SummChangePercent_curr
                             -- ����� ����� ������ (� ���) - � ������� ��������� �� zc_MI_Child
                           , COALESCE (MIFloat_TotalPay_curr.ValueData, 0)          AS TotalPay_curr


                           , MILinkObject_DiscountSaleKind.ObjectId AS DiscountSaleKindId

                             -- �������������� ������
                           , View_InfoMoney.InfoMoneyGroupId
                             -- �������������� ����������
                           , View_InfoMoney.InfoMoneyDestinationId
                             -- ������ ����������
                           , View_InfoMoney.InfoMoneyId

                           , MIFloat_CurrencyValue.ValueData  AS CurrencyValue
                           , MIFloat_ParValue.ValueData       AS ParValue

                           , CASE WHEN Object_PartionGoods.GoodsId = zc_Enum_Goods_Debt() THEN TRUE 
                                  WHEN EXISTS (SELECT 1 FROM tmpCheck WHERE tmpCheck.PartionId_MI = MILinkObject_PartionMI.ObjectId) THEN TRUE 
                                  ELSE FALSE
                             END AS isGoods_Debt

                      FROM Movement
                           JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE

                           LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_curr
                                                       ON MIFloat_SummChangePercent_curr.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummChangePercent_curr.DescId         = zc_MIFloat_SummChangePercent()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_curr
                                                       ON MIFloat_TotalPay_curr.MovementItemId = MovementItem.Id
                                                      AND MIFloat_TotalPay_curr.DescId         = zc_MIFloat_TotalPay()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                            ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                           LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId

                           LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode

                           LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                       ON MIFloat_OperPriceList.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                       ON MIFloat_TotalChangePercent.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                       ON MIFloat_TotalChangePercentPay.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                       ON MIFloat_TotalPay.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                       ON MIFloat_TotalPayOth.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()
                           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                       ON MIFloat_ChangePercent.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                       ON MIFloat_SummChangePercent.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()

                           LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                       ON MIFloat_TotalCountReturn.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                       ON MIFloat_TotalReturn.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                       ON MIFloat_TotalPayReturn.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

                           LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                       ON MIFloat_CurrencyValue.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                           LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                       ON MIFloat_ParValue.MovementItemId = Object_PartionMI.ObjectCode
                                                      AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                            ON MILinkObject_DiscountSaleKind.MovementItemId = Object_PartionMI.ObjectCode
                                                           AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()

                           LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                ON ObjectLink_Goods_InfoMoney.ObjectId = Object_PartionGoods.GoodsId
                                               AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101()) -- !!!��������!!! ������ + ������ + ������

                      WHERE Movement.Id       = inMovementId
                        AND Movement.DescId   = zc_Movement_GoodsAccount()
                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                     )
         -- ����� ������ ��������� ����������� ������, �.�. ������ ��� ���� ����������� Amount_begin
        , tmpLast AS (SELECT tmpMI.PartionId_MI
                           , Movement.OperDate
                           , Movement.Id AS MovementId
                             --  � �/�
                           , ROW_NUMBER() OVER (PARTITION BY tmpMI.PartionId_MI ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                      FROM tmpMI
                           INNER JOIN MovementItemLinkObject AS MIL_PartionMI
                                                             ON MIL_PartionMI.ObjectId = tmpMI.PartionId_MI
                                                            AND MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                           INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                  AND MovementItem.DescId   = zc_MI_Master()
                                                  AND MovementItem.isErased = FALSE
                           INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                              AND Movement.DescId   = zc_Movement_GoodsAccount()
                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                       ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                      AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                       ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                      WHERE MIFloat_TotalPay.ValueData <> 0 OR MIFloat_SummChangePercent.ValueData <> 0
                     )
        
        -- ���������
        SELECT tmp.MovementItemId
             , 0 AS ContainerId_Summ          -- ���������� �����
             , 0 AS ContainerId_Goods         -- ���������� �����
             , tmp.GoodsId
             , tmp.PartionId
             , tmp.PartionId_MI
             , tmp.GoodsSizeId

               -- !!!��������!!!
             , tmp.Amount_begin AS OperCount

               -- ���� - �� ������
             , tmp.OperPrice
               -- ���� �� ���������� - �� ������
             , tmp.CountForPrice

               -- ����� �� ��. � zc_Currency_Basis
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN 0 -- !!!��� �����!!!
                    -- ����� �� ��. - � ����������� �� 2-� ������
                    ELSE zfCalc_SummIn (tmp.Amount_begin, tmp.OperPrice_basis, tmp.CountForPrice)
               END AS OperSumm

               -- ����� �� ��. � ������
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN 0  -- !!!��� �����!!!
                    ELSE zfCalc_SummIn (tmp.Amount_begin, tmp.OperPrice, tmp.CountForPrice)
               END AS OperSumm_Currency

               -- ����� � ������ �����
             , zfCalc_SummPriceList (tmp.Amount_Sale, tmp.OperPriceList)
             - (tmp.TotalChangePercent + tmp.TotalChangePercentPay + tmp.SummChangePercent_curr)
             - tmp.TotalReturn_calc
               AS OperSumm_ToPay

               -- ����� �� ������ - � ����������� �� 2-� ������
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN tmp.SummChangePercent_curr -- ���������� - ������ � ������� ���������!!!�.�. ��� �����!!!
                    ELSE zfCalc_SummPriceList (tmp.Amount_begin, tmp.OperPriceList)
               END AS OperSummPriceList

               -- ����� ����� ������ - 1) + 2) + 3) + 4)� ������� ��������� - 5)������� ������ - �������
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN 0 -- !!!��� �����!!!
                    ELSE tmp.TotalChangePercent + tmp.TotalChangePercentPay + tmp.SummChangePercent_curr - tmp.SummChangePercent_return
               END AS TotalChangePercent

             , tmp.SummChangePercent_curr -- ����� ����� ������ - � ������� ���������

             , tmp.TotalPay + tmp.TotalPayOth + tmp.TotalPay_curr - tmp.TotalPayReturn_calc AS TotalPay      -- ����� ����� ������ - 1) + 2) + 3)� ������� ��������� - 4)������� ������ - �������
             , tmp.TotalPay_curr                                                            AS TotalPay_curr -- ����� ����� ������ - � ������� ���������

               -- �������� ������ - ������ ��� %
             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 WHEN tmp.DiscountSaleKindId = zc_Enum_DiscountSaleKind_Period() THEN tmp.SummChangePercent_pl ELSE 0 END AS Summ_10201
               -- ������ outlet - ������ ��� %
             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 WHEN tmp.DiscountSaleKindId = zc_Enum_DiscountSaleKind_Outlet() THEN tmp.SummChangePercent_pl ELSE 0 END AS Summ_10202
               -- ������ ������� - ������ ��� %
             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 WHEN tmp.DiscountSaleKindId = zc_Enum_DiscountSaleKind_Client() THEN tmp.SummChangePercent_pl ELSE 0 END AS Summ_10203
               -- ������ �������������� - ������� ������� �� �� �������
             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 ELSE tmp.TotalChangePercent + tmp.TotalChangePercentPay + tmp.SummChangePercent_curr - tmp.SummChangePercent_return - tmp.SummChangePercent_pl END AS Summ_10204

             , 0 AS AccountId          -- ����(�����������), ���������� �����

               -- �� ��� Sale - ��� ����������� ����� ������
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

             , tmp.SummDebt_sale
             , tmp.SummDebt_return

               -- ���� - �� ������ �������
             , COALESCE (tmp.CurrencyValue, 0) AS CurrencyValue
               -- ������� ����� - �� ������ �������
             , COALESCE (tmp.ParValue, 0)      AS ParValue

             , tmp.isGoods_Debt

        FROM (SELECT tmp.*

                     -- !!!����� ������ - ���������� ���-��!!!
                   , CASE WHEN tmp.isGoods_Debt = TRUE AND tmp.SummChangePercent_curr <> 0
                               THEN 1 -- !!!���������� ��� � ����� � �������!!!
                          WHEN tmp.SummDebt_sale = 0 AND tmpLast.PartionId_MI IS NULL
                               THEN -- �� ��� � �������
                                    tmp.Amount_Sale

                          -- !!!!
                          -- 1. ���� ��� Sybase �������� ���� � ����� 2 ��. + ������� �������� �� 1��, ����� ��� 1 �� �������, � ����� ������� 1�� �� ������� ��������
                          -- !!!!
                          WHEN inUserId        = zc_User_Sybase()
                           AND tmp.Amount_Sale = tmp.Amount_Return AND tmp.SummDebt_return = 0 AND (tmp.TotalPay_curr > 0 OR tmp.SummChangePercent_curr > 0) AND tmpLast.PartionId_MI IS NULL
                           -- � ���� ������� �� �����
                           AND tmp.Amount_Sale <> (SELECT MovementItem.Amount
                                                   FROM MovementItemLinkObject AS MIL_PartionMI
                                                        INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                                               AND MovementItem.isErased   = FALSE
                                                        INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                           AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                                   WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                                     AND MIL_PartionMI.ObjectId     = tmp.PartionId_MI
                                                     AND inUserId                   = zc_User_Sybase()
                                                   LIMIT 1
                                                  )
                            -- ����� "� ������" ��������������� ��� OperCount
                            AND -- ����� �� ������
                                (zfCalc_SummPriceList (tmp.Amount_Sale, tmp.OperPriceList)
                                 -- �����: ����� ����� ������ (� ���) - ����������� ������ 1)�� %������ + 2)�������������� + 3)�������������� � �������
                               - (tmp.TotalChangePercent + tmp.TotalChangePercentPay )
                                ) / tmp.Amount_Sale * tmp.OperCount
                                -- �����: ����� ������ (� ���) - � ������� ���������
                              - tmp.SummChangePercent_curr
                              -- ����� ����� ������: 1+2+3
                              = tmp.TotalPay_curr + tmp.TotalPayOth + tmp.TotalPay

                               THEN -- ?���� ���, �� ������ �� ����� ��������� ?
                                    tmp.OperCount
                          -- !!!!
                          -- 1. ���� ��� Sybase
                          -- !!!!

                          WHEN tmp.SummDebt_return = 0 AND (tmp.TotalPay_curr > 0 OR tmp.SummChangePercent_curr > 0) AND tmpLast.PartionId_MI IS NULL
                               THEN -- ������� ����� �������
                                    tmp.Amount_Sale - tmp.Amount_Return

                          ELSE 0
                     END AS Amount_begin


                     -- !!!����� ������ - ���������� ��� Amount_begin ������ - ������ ��� %!!!
                   , CASE WHEN tmp.SummDebt_sale = 0 AND tmpLast.PartionId_MI IS NULL
                               THEN -- �� ��� � �������
                                    zfCalc_SummPriceList (tmp.Amount_Sale, tmp.OperPriceList) - zfCalc_SummChangePercent (tmp.Amount_Sale, tmp.OperPriceList, tmp.ChangePercent)

                          -- !!!!
                          -- 2. ���� ��� Sybase �������� ���� � ����� 2 ��. + ������� �������� �� 1��, ����� ��� 1 �� �������, � ����� ������� 1�� �� ������� ��������
                          -- !!!!
                          WHEN inUserId        = zc_User_Sybase()
                           AND tmp.Amount_Sale = tmp.Amount_Return AND tmp.SummDebt_return = 0 AND (tmp.TotalPay_curr > 0 OR tmp.SummChangePercent_curr > 0) AND tmpLast.PartionId_MI IS NULL
                           -- � ���� ������� �� �����
                           AND tmp.Amount_Sale <> (SELECT MovementItem.Amount
                                                   FROM MovementItemLinkObject AS MIL_PartionMI
                                                        INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                                               AND MovementItem.isErased   = FALSE
                                                        INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                           AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                                   WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                                     AND MIL_PartionMI.ObjectId     = tmp.PartionId_MI
                                                     AND inUserId                   = zc_User_Sybase()
                                                   LIMIT 1
                                                  )
                            -- ����� "� ������" ��������������� ��� OperCount
                            AND -- ����� �� ������
                                (zfCalc_SummPriceList (tmp.Amount_Sale, tmp.OperPriceList)
                                 -- �����: ����� ����� ������ (� ���) - ����������� ������ 1)�� %������ + 2)�������������� + 3)�������������� � �������
                               - (tmp.TotalChangePercent + tmp.TotalChangePercentPay )
                                ) / tmp.Amount_Sale * tmp.OperCount
                                -- �����: ����� ������ (� ���) - � ������� ���������
                              - tmp.SummChangePercent_curr
                              -- ����� ����� ������: 1+2+3
                              = tmp.TotalPay_curr + tmp.TotalPayOth + tmp.TotalPay

                               THEN -- ?���� ���, �� ������ �� ����� ��������� ?
                                    zfCalc_SummPriceList (tmp.OperCount, tmp.OperPriceList) - zfCalc_SummChangePercent (tmp.OperCount, tmp.OperPriceList, tmp.ChangePercent)
                          -- !!!!
                          -- 2. ���� ��� Sybase
                          -- !!!!

                          WHEN tmp.SummDebt_return = 0 AND tmpLast.PartionId_MI IS NULL
                               THEN -- ������� ����� �������
                                    zfCalc_SummPriceList (tmp.Amount_Sale - tmp.Amount_Return, tmp.OperPriceList) - zfCalc_SummChangePercent (tmp.Amount_Sale - tmp.Amount_Return, tmp.OperPriceList, tmp.ChangePercent)
                          ELSE 0
                     END AS SummChangePercent_pl


                     -- !!!����� ������ - ���������� ����!!!
                   , CASE WHEN tmp.SummDebt_sale = 0 AND tmpLast.PartionId_MI IS NULL
                               THEN -- �� ��� � �������
                                    tmp.SummDebt_sale
                          WHEN tmp.SummDebt_return = 0 AND tmpLast.PartionId_MI IS NULL
                               THEN -- ������� ����� �������
                                    tmp.SummDebt_return
                          ELSE tmp.SummDebt_return
                     END AS SummDebt


                     -- !!!������� ������ - �������!!!
                   , CASE WHEN tmp.SummDebt_sale = 0 AND tmpLast.PartionId_MI IS NULL
                               THEN -- �� ��������� �
                                    0
                          -- !!!!
                          -- 3.1. ���� ��� Sybase �������� ���� � ����� 2 ��. + ������� �������� �� 1��, ����� ��� 1 �� �������, � ����� ������� 1�� �� ������� ��������
                          -- !!!!
                          WHEN inUserId        = zc_User_Sybase()
                           AND tmp.Amount_Sale = tmp.Amount_Return AND tmp.SummDebt_return = 0 AND (tmp.TotalPay_curr > 0 OR tmp.SummChangePercent_curr > 0) AND tmpLast.PartionId_MI IS NULL
                           -- � ���� ������� �� �����
                           AND tmp.Amount_Sale <> (SELECT MovementItem.Amount
                                                   FROM MovementItemLinkObject AS MIL_PartionMI
                                                        INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                                               AND MovementItem.isErased   = FALSE
                                                        INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                           AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                                   WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                                     AND MIL_PartionMI.ObjectId     = tmp.PartionId_MI
                                                     AND inUserId                   = zc_User_Sybase()
                                                   LIMIT 1
                                                  )
                            -- ����� "� ������" ��������������� ��� OperCount
                            AND -- ����� �� ������
                                (zfCalc_SummPriceList (tmp.Amount_Sale, tmp.OperPriceList)
                                 -- �����: ����� ����� ������ (� ���) - ����������� ������ 1)�� %������ + 2)�������������� + 3)�������������� � �������
                               - (tmp.TotalChangePercent + tmp.TotalChangePercentPay )
                                ) / tmp.Amount_Sale * tmp.OperCount
                                -- �����: ����� ������ (� ���) - � ������� ���������
                              - tmp.SummChangePercent_curr
                              -- ����� ����� ������: 1+2+3
                              = tmp.TotalPay_curr + tmp.TotalPayOth + tmp.TotalPay

                               THEN -- ?���� ���, �� ������ �� ����� ��������� ?
                                    COALESCE (
                                    (SELECT SUM (COALESCE (MIFloat_TotalChangePercent.ValueData, 0))
                                     FROM MovementItemLinkObject AS MIL_PartionMI
                                          INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                                 AND MovementItem.isErased   = FALSE
                                          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                             AND Movement.DescId   = zc_Movement_ReturnIn()
                                                             AND Movement.StatusId = zc_Enum_Status_Complete()
                                                             AND Movement.OperDate <= vbOperDate
                                          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                      ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                     WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                       AND MIL_PartionMI.ObjectId     = tmp.PartionId_MI
                                    ), 0)
                          -- !!!!
                          -- 3.1. ���� ��� Sybase
                          -- !!!!


                          WHEN tmp.SummDebt_return = 0 AND tmpLast.PartionId_MI IS NULL
                               THEN -- ������ �������
                                    zfCalc_SummPriceList (tmp.Amount_Return, tmp.OperPriceList) - tmp.TotalReturn
                          ELSE 0
                     END AS SummChangePercent_return


                     -- !!!������� ������ - �������!!!
                   , CASE WHEN tmp.SummDebt_sale = 0 AND tmpLast.PartionId_MI IS NULL
                               THEN -- �� ��������� �
                                    0
                          -- !!!!
                          -- 3.2. ���� ��� Sybase �������� ���� � ����� 2 ��. + ������� �������� �� 1��, ����� ��� 1 �� �������, � ����� ������� 1�� �� ������� ��������
                          -- !!!!
                          WHEN inUserId        = zc_User_Sybase()
                           AND tmp.Amount_Sale = tmp.Amount_Return AND tmp.SummDebt_return = 0 AND (tmp.TotalPay_curr > 0 OR tmp.SummChangePercent_curr > 0) AND tmpLast.PartionId_MI IS NULL
                           -- � ���� ������� �� �����
                           AND tmp.Amount_Sale <> (SELECT MovementItem.Amount
                                                   FROM MovementItemLinkObject AS MIL_PartionMI
                                                        INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                                               AND MovementItem.isErased   = FALSE
                                                        INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                           AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                                   WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                                     AND MIL_PartionMI.ObjectId     = tmp.PartionId_MI
                                                     AND inUserId                   = zc_User_Sybase()
                                                   LIMIT 1
                                                  )
                            -- ����� "� ������" ��������������� ��� OperCount
                            AND -- ����� �� ������
                                (zfCalc_SummPriceList (tmp.Amount_Sale, tmp.OperPriceList)
                                 -- �����: ����� ����� ������ (� ���) - ����������� ������ 1)�� %������ + 2)�������������� + 3)�������������� � �������
                               - (tmp.TotalChangePercent + tmp.TotalChangePercentPay )
                                ) / tmp.Amount_Sale * tmp.OperCount
                                -- �����: ����� ������ (� ���) - � ������� ���������
                              - tmp.SummChangePercent_curr
                              -- ����� ����� ������: 1+2+3
                              = tmp.TotalPay_curr + tmp.TotalPayOth + tmp.TotalPay

                               THEN -- ?���� ���, �� ������ �� ����� ��������� ?
                                    COALESCE (
                                    (SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0))
                                     FROM MovementItemLinkObject AS MIL_PartionMI
                                          INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                                 AND MovementItem.isErased   = FALSE
                                          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                             AND Movement.DescId   = zc_Movement_ReturnIn()
                                                             AND Movement.StatusId = zc_Enum_Status_Complete()
                                                             AND Movement.OperDate <= vbOperDate
                                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                      ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                     WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                       AND MIL_PartionMI.ObjectId     = tmp.PartionId_MI
                                    ), 0)
                          -- !!!!
                          -- 3.2. ���� ��� Sybase
                          -- !!!!

                          WHEN tmp.SummDebt_return = 0 AND tmpLast.PartionId_MI IS NULL
                               THEN -- ��������� �
                                    tmp.TotalPayReturn
                          ELSE 0
                     END AS TotalPayReturn_calc


                     -- !!!������� ����� �� ������� - �������!!!
                   , CASE WHEN tmp.SummDebt_sale = 0 AND tmpLast.PartionId_MI IS NULL
                               THEN -- �� ��������� �
                                    0
                          -- !!!!
                          -- 3.3. ���� ��� Sybase �������� ���� � ����� 2 ��. + ������� �������� �� 1��, ����� ��� 1 �� �������, � ����� ������� 1�� �� ������� ��������
                          -- !!!!
                          WHEN inUserId        = zc_User_Sybase()
                           AND tmp.Amount_Sale = tmp.Amount_Return AND tmp.SummDebt_return = 0 AND (tmp.TotalPay_curr > 0 OR tmp.SummChangePercent_curr > 0) AND tmpLast.PartionId_MI IS NULL
                           -- � ���� ������� �� �����
                           AND tmp.Amount_Sale <> (SELECT MovementItem.Amount
                                                   FROM MovementItemLinkObject AS MIL_PartionMI
                                                        INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                                               AND MovementItem.isErased   = FALSE
                                                        INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                           AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                                   WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                                     AND MIL_PartionMI.ObjectId     = tmp.PartionId_MI
                                                     AND inUserId                   = zc_User_Sybase()
                                                   LIMIT 1
                                                  )
                            -- ����� "� ������" ��������������� ��� OperCount
                            AND -- ����� �� ������
                                (zfCalc_SummPriceList (tmp.Amount_Sale, tmp.OperPriceList)
                                 -- �����: ����� ����� ������ (� ���) - ����������� ������ 1)�� %������ + 2)�������������� + 3)�������������� � �������
                               - (tmp.TotalChangePercent + tmp.TotalChangePercentPay )
                                ) / tmp.Amount_Sale * tmp.OperCount
                                -- �����: ����� ������ (� ���) - � ������� ���������
                              - tmp.SummChangePercent_curr
                              -- ����� ����� ������: 1+2+3
                              = tmp.TotalPay_curr + tmp.TotalPayOth + tmp.TotalPay

                               THEN -- ?���� ���, �� ������ �� ����� ��������� ?
                                    COALESCE (
                                    (SELECT SUM (zfCalc_SummPriceList (MovementItem.Amount, tmp.OperPriceList) - COALESCE (MIFloat_TotalChangePercent.ValueData, 0))
                                     FROM MovementItemLinkObject AS MIL_PartionMI
                                          INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                                 AND MovementItem.isErased   = FALSE
                                          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                             AND Movement.DescId   = zc_Movement_ReturnIn()
                                                             AND Movement.StatusId = zc_Enum_Status_Complete()
                                                             AND Movement.OperDate <= vbOperDate
                                          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                      ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                     WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                       AND MIL_PartionMI.ObjectId     = tmp.PartionId_MI
                                    ), 0)
                          -- !!!!
                          -- 3.3. ���� ��� Sybase
                          -- !!!!

                          WHEN tmp.SummDebt_return = 0 AND tmpLast.PartionId_MI IS NULL
                               THEN -- ��������� �
                                    tmp.TotalReturn
                          ELSE 0
                     END AS TotalReturn_calc


             FROM tmpMI AS tmp
                  -- ���� ������ ����������� ��� ��������� ����� - ����� � ��� ����� Amount_begin
                  LEFT JOIN tmpLast ON tmpLast.PartionId_MI = tmp.PartionId_MI
                                   AND tmpLast.Ord          = 1                -- !!!������� ��������� �����������!!!
                                   AND tmpLast.OperDate     >= vbOperDate      -- � ���� �� ����� ���� ��� ������
                                   AND tmpLast.MovementId   >  inMovementId    -- � ���� �� ����� ���� ��� ������

             WHERE tmp.SummChangePercent_curr <> 0
                OR tmp.TotalPay_curr          <> 0

             ) AS tmp
            ;

     -- �������� PartionId_MI
     IF /*inUserId <> zc_User_Sybase() AND*/ EXISTS (SELECT 1 FROM _tmpItem WHERE COALESCE (_tmpItem.PartionId_MI, 0) = 0)
     THEN
         RAISE EXCEPTION '������. PartionId_MI = 0';
     END IF;

     -- �������� ��� �������� �� ������ ��� ����
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.TotalPay > _tmpItem.OperSumm_ToPay)
     THEN
         RAISE EXCEPTION '������. ����� � ������ = <%> ������ ��� ����� ������ = <%>.', (SELECT _tmpItem.OperSumm_ToPay FROM _tmpItem WHERE _tmpItem.TotalPay > _tmpItem.OperSumm_ToPay ORDER BY _tmpItem.MovementItemId LIMIT 1)
                                                                                      , (SELECT _tmpItem.TotalPay       FROM _tmpItem WHERE _tmpItem.TotalPay > _tmpItem.OperSumm_ToPay ORDER BY _tmpItem.MovementItemId LIMIT 1)
         ;
     END IF;
     -- �������� ��� ������ �� ��� ����
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204)
     THEN
         RAISE EXCEPTION '������. ����� ����� <%> �� ����� <%>.', (SELECT _tmpItem.TotalChangePercent FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
                                                                , (SELECT _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
         ;
     END IF;
     -- �������� SummDebt_sale
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.SummDebt_sale < 0)
          -- !!!�������� - ��� Sybase!!! - zc_Enum_Status_UnComplete
      /*AND EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.SummDebt_sale - COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_SummChangePercent.ValueData, 0))
                                                                                     FROM MovementItemLinkObject AS MIL_PartionMI
                                                                                          INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                                                                                 AND MovementItem.isErased   = FALSE
                                                                                                                 AND MovementItem.MovementId <> inMovementId
                                                                                          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                                             AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                                                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                                                                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                                      ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                                     AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                                                                          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                                                                      ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                                                                                     AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                                                                                     WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                                                                       AND MIL_PartionMI.ObjectId     = _tmpItem.PartionId_MI
                                                                                       AND inUserId                   = zc_User_Sybase()
                                                                                       AND MIFloat_TotalPay.ValueData < 0
                                                                                    ), 0)
                  < 0)*/
     THEN
         RAISE EXCEPTION '������. ����� ����� ����� ������ = <%> <SummDebt_sale>.', (SELECT _tmpItem.SummDebt_sale FROM _tmpItem WHERE _tmpItem.SummDebt_sale < 0 ORDER BY _tmpItem.MovementItemId LIMIT 1);
     END IF;
     -- �������� SummDebt_return
     IF   EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.SummDebt_return < 0)
          -- !!!��������!!!
      -- AND inUserId <> zc_User_Sybase()
      -- AND 1=0
      -- AND inMovementId <> 334388
          -- !!!�������� - ��� Sybase!!! - zc_Enum_Status_UnComplete
      AND EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.SummDebt_sale <> 0
                                           AND _tmpItem.SummDebt_return - COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_SummChangePercent.ValueData, 0))
                                                                                     FROM MovementItemLinkObject AS MIL_PartionMI
                                                                                          INNER JOIN MovementItem ON MovementItem.Id         = MIL_PartionMI.MovementItemId
                                                                                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                                                                                 AND MovementItem.isErased   = FALSE
                                                                                                                 AND MovementItem.MovementId <> inMovementId
                                                                                          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                                             AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                                                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                                                                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                                      ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                                     AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                                                                          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                                                                      ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                                                                                     AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                                                                                     WHERE MIL_PartionMI.DescId       = zc_MILinkObject_PartionMI()
                                                                                       AND MIL_PartionMI.ObjectId     = _tmpItem.PartionId_MI
                                                                                       AND inUserId                   = zc_User_Sybase()
                                                                                       AND MIFloat_TotalPay.ValueData < 0
                                                                                    ), 0)
                  < 0)
     THEN
         RAISE EXCEPTION '������. ����� ����� ����� ������ = <%> <SummDebt_return>.', (SELECT _tmpItem.SummDebt_return FROM _tmpItem WHERE _tmpItem.SummDebt_return < 0 ORDER BY _tmpItem.MovementItemId LIMIT 1);
     END IF;


     -- ��������� ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem_SummClient (MovementItemId, ContainerId_Summ, ContainerId_Summ_20102, ContainerId_Goods, AccountId, AccountId_20102, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                                    , GoodsId, PartionId, GoodsSizeId, PartionId_MI
                                    , OperCount, OperSumm, OperSumm_ToPay, TotalPay, TotalPay_curr
                                    , OperCount_sale, OperSumm_sale, OperSummPriceList_sale
                                    , Summ_10201, Summ_10202, Summ_10203, Summ_10204
                                    , ContainerId_ProfitLoss_10101, ContainerId_ProfitLoss_10201, ContainerId_ProfitLoss_10202, ContainerId_ProfitLoss_10203, ContainerId_ProfitLoss_10204, ContainerId_ProfitLoss_10301
                                    , isGoods_Debt
                                     )

        WITH -- ����� ���-�� ������� (����) - .�.�. �������� ����� ������ � ������ MovementId
             tmpContainer AS (SELECT _tmpItem.PartionId_MI, Container.ObjectId AS GoodsId, Container.Amount
                              FROM _tmpItem
                                   INNER JOIN Container ON Container.PartionId = _tmpItem.PartionId
                                                       AND Container.DescId    = zc_Container_Count()
                                   INNER JOIN ContainerLinkObject AS CLO_PartionMI
                                                                  ON CLO_PartionMI.ContainerId = Container.Id
                                                                 AND CLO_PartionMI.DescId      = zc_ContainerLinkObject_PartionMI()
                                                                 AND CLO_PartionMI.ObjectId    = _tmpItem.PartionId_MI
                                   INNER JOIN ContainerLinkObject AS CLO_Client
                                                                  ON CLO_Client.ContainerId = Container.Id
                                                                 AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                                 AND CLO_Client.ObjectId    = vbClientId
                                   INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                  ON CLO_Unit.ContainerId = Container.Id
                                                                 AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                 AND CLO_Unit.ObjectId    = vbUnitId
                             )
        -- ���������
        SELECT tmp.MovementItemId
             , 0 AS ContainerId_Summ, 0 AS ContainerId_Summ_20102, 0 AS ContainerId_Goods, 0 AS AccountId, 0 AS AccountId_20102
             , tmp.InfoMoneyGroupId, tmp.InfoMoneyDestinationId, tmp.InfoMoneyId
             , tmp.GoodsId
             , tmp.PartionId
             , tmp.GoodsSizeId

               -- ������ �������� �������/��������
             , tmp.PartionId_MI

               -- ��� ���-��
             , tmp.OperCount

             , (tmp.OperSumm)          AS OperSumm       -- ����� �� ��.
             , (tmp.OperSumm_ToPay)    AS OperSumm_ToPay -- ����� � ������
             , (tmp.TotalPay)          AS TotalPay       -- ����� ������ - 1) + 2) + 3)� ������� ���������
             , (tmp.TotalPay_curr)     AS TotalPay_curr  -- ����� ������ - � ������� ���������

               -- ������ ���-�� ������� �������� � ������� - ����
             , tmp.OperCount_sale

               -- ������ �/� ������� �������� � �������
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.OperSumm
                    ELSE 0
               END AS OperSumm_sale

               -- ������ ����� ������� �������� � �������
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.OperSummPriceList
                    ELSE 0
               END AS OperSummPriceList_sale

               -- ������ �������� ������ ������� �������� � �������
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.Summ_10201
                    ELSE 0
               END AS Summ_10201

               -- ������ ������ outlet ������� �������� � �������
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.Summ_10202
                    ELSE 0
               END AS Summ_10202

               -- ������ ������ ������� ������� �������� � �������
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.Summ_10203
                    ELSE 0
               END AS Summ_10203

               -- ������ ������ �������������� ������� �������� � �������
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.Summ_10204
                    ELSE 0
               END AS Summ_10204

             , 0 AS ContainerId_ProfitLoss_10101, 0 AS ContainerId_ProfitLoss_10201, 0 AS ContainerId_ProfitLoss_10202, 0 AS ContainerId_ProfitLoss_10203, 0 AS ContainerId_ProfitLoss_10204, 0 AS ContainerId_ProfitLoss_10301

             , tmp.isGoods_Debt

        FROM (SELECT _tmpItem.*
                     -- ������ ���-�� ������� �������� � ������� - ����
                   , CASE WHEN 1=1
                               THEN _tmpItem.OperCount
                          WHEN _tmpItem.OperSumm_ToPay = _tmpItem.TotalPay AND _tmpItem.OperCount = tmpContainer.Amount
                               THEN _tmpItem.OperCount
                          WHEN _tmpItem.OperSumm_ToPay = _tmpItem.TotalPay AND tmpContainer.Amount > 0
                               THEN -1 * tmpContainer.Amount -- !!!����� ������
                          ELSE 0
                     END AS OperCount_sale
              FROM _tmpItem
                   LEFT JOIN tmpContainer ON tmpContainer.PartionId_MI = _tmpItem.PartionId_MI
                                         -- !!!����������� �������, �.�. ��� �������� GoodsId � ����� � Container - ��������� �����!!!
                                         AND tmpContainer.GoodsId      = _tmpItem.GoodsId
              -- WHERE _tmpItem.OperCount > 0
             ) AS tmp
        ;

     -- �������� ��� ����� ������ ....
     -- IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204)
     -- THEN
     --     RAISE EXCEPTION '������. �������� ��� ����� ������ .....', (SELECT _tmpItem.TotalChangePercent FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
     --                                                              , (SELECT _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
     --    ;
     -- END IF;

     -- �������� ��� ���������� - ����� ���-�� ������� (����)
     IF EXISTS (SELECT 1 FROM _tmpItem_SummClient WHERE _tmpItem_SummClient.OperCount_sale < 0)
     THEN
         RAISE EXCEPTION '������. ���-�� � ������ ������� = <%> �� ����� ���-�� ������� (����) = <%>.'
                       , (SELECT _tmpItem_SummClient.OperCount           FROM _tmpItem_SummClient WHERE _tmpItem_SummClient.OperCount_sale < 0 ORDER BY _tmpItem_SummClient.MovementItemId LIMIT 1)
                       , (SELECT -1 * _tmpItem_SummClient.OperCount_sale FROM _tmpItem_SummClient WHERE _tmpItem_SummClient.OperCount_sale < 0 ORDER BY _tmpItem_SummClient.MovementItemId LIMIT 1)
        ;
     END IF;


     -- ��������� ������� - �������� ������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpPay (MovementItemId, ParentId, ObjectId, ObjectDescId, CurrencyId
                        , AccountId, ContainerId, ContainerId_Currency
                        , OperSumm, OperSumm_Currency
                        , ObjectId_from
                        , AccountId_from, ContainerId_from
                        , OperSumm_from
                         )
        SELECT tmp.MovementItemId
             , tmp.ParentId
             , tmp.ObjectId
             , tmp.ObjectDescId
             , tmp.CurrencyId
             , tmp.AccountId

               -- ContainerId
             , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                     , inParentId          := NULL
                                     , inObjectId          := tmp.AccountId
                                     , inPartionId         := NULL
                                     , inJuridicalId_basis := vbJuridicalId_Basis
                                     , inBusinessId        := vbBusinessId
                                     , inDescId_1          := CASE WHEN tmp.ObjectDescId = zc_Object_Cash() THEN zc_ContainerLinkObject_Cash() WHEN tmp.ObjectDescId = zc_Object_BankAccount() THEN zc_ContainerLinkObject_BankAccount() END
                                     , inObjectId_1        := tmp.ObjectId
                                     , inDescId_2          := zc_ContainerLinkObject_Currency()
                                     , inObjectId_2        := tmp.CurrencyId
                                      ) AS ContainerId

               -- ContainerId_Currency
             , CASE WHEN tmp.CurrencyId <> zc_Currency_Basis() THEN
               lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                     , inParentId          := NULL
                                     , inObjectId          := tmp.AccountId
                                     , inPartionId         := NULL
                                     , inJuridicalId_basis := vbJuridicalId_Basis
                                     , inBusinessId        := vbBusinessId
                                     , inDescId_1          := CASE WHEN tmp.ObjectDescId = zc_Object_Cash() THEN zc_ContainerLinkObject_Cash() WHEN tmp.ObjectDescId = zc_Object_BankAccount() THEN zc_ContainerLinkObject_BankAccount() END
                                     , inObjectId_1        := tmp.ObjectId
                                     , inDescId_2          := zc_ContainerLinkObject_Currency()
                                     , inObjectId_2        := tmp.CurrencyId
                                      )
               END AS ContainerId_Currency

             , tmp.OperSumm
             , tmp.OperSumm_Currency

             , tmp.ObjectId_from
             , tmp.AccountId_from
             , CASE WHEN tmp.OperSumm_from <> 0 THEN
               lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                     , inParentId          := NULL
                                     , inObjectId          := tmp.AccountId_from
                                     , inPartionId         := NULL
                                     , inJuridicalId_basis := vbJuridicalId_Basis
                                     , inBusinessId        := vbBusinessId
                                     , inDescId_1          := zc_ContainerLinkObject_Cash()
                                     , inObjectId_1        := tmp.ObjectId_from
                                     , inDescId_2          := zc_ContainerLinkObject_Currency()
                                     , inObjectId_2        := tmp.CurrencyId_from
                                      )
                         ELSE 0
               END AS ContainerId_from
             , tmp.OperSumm_from

        FROM (SELECT MovementItem.Id       AS MovementItemId
                   , MovementItem.ParentId AS ParentId
                   , MovementItem.ObjectId AS ObjectId
                   , Object.DescId         AS ObjectDescId

                   , CASE -- �������� �������� + ����� ��������� + �����*****
                          WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() AND Object.DescId = zc_Object_Cash()
                              THEN zc_Enum_Account_30201()
                          -- �������� �������� + ����� ��������� + � ������
                          WHEN Object.DescId = zc_Object_Cash()
                              THEN zc_Enum_Account_30202()
                          -- �������� �������� + ��������� ���� + ��������� ����
                          WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() AND Object.DescId = zc_Object_BankAccount()
                              THEN zc_Enum_Account_30301()
                     END AS AccountId

                     -- ���� ���� - ��������� ����� � ������ � ���
                   , CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() THEN MovementItem.Amount ELSE ROUND (zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData), 2) END AS OperSumm
                   , CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() THEN 0 ELSE MovementItem.Amount END AS OperSumm_Currency
                   , MILinkObject_Currency.ObjectId AS CurrencyId

                     -- ������ ��� �����
                   , CASE WHEN MovementItem.ParentId IS NULL THEN zc_Currency_Basis()   ELSE 0 END AS CurrencyId_from
                     -- ����� � ��� ��� �����
                   , CASE WHEN MovementItem.ParentId IS NULL THEN MILinkObject_Cash.ObjectId ELSE 0 END AS ObjectId_from
                     -- ���� � ��� ��� ����� ������ - �������� �������� + ����� ��������� + �����*****
                   , CASE WHEN MovementItem.ParentId IS NULL THEN zc_Enum_Account_30201()    ELSE 0 END AS AccountId_from
                     -- ��������� ����� � ��� ��� �����
                   , CASE WHEN MovementItem.ParentId IS NULL THEN zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData) ELSE 0 END AS OperSumm_from
              FROM Movement
                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId     = zc_MI_Child()
                                          AND MovementItem.isErased   = FALSE
                                          AND MovementItem.Amount     <> 0
                   INNER JOIN MovementItem AS MI_Master
                                           ON MI_Master.MovementId = Movement.Id
                                          AND MI_Master.DescId     = zc_MI_Master()
                                          AND MI_Master.Id         = MovementItem.ParentId
                                          AND MI_Master.isErased   = FALSE
                   LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                    ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Cash
                                                    ON MILinkObject_Cash.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Cash.DescId         = zc_MILinkObject_Cash()
                   LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                               ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                   LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                               ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_GoodsAccount()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
        ;

     -- �������� ��� ����� ������ ....
     IF  COALESCE ((SELECT SUM (_tmpItem_SummClient.TotalPay_curr) FROM _tmpItem_SummClient), 0)
      <> COALESCE ((SELECT SUM (_tmpPay.OperSumm - _tmpPay.OperSumm_from) FROM _tmpPay), 0)
     THEN
         RAISE EXCEPTION '������. ����� ������ Main <%> �� ����� Child <%>.', (SELECT SUM (_tmpItem_SummClient.TotalPay_curr) FROM _tmpItem_SummClient)
                                                                            , (SELECT SUM (_tmpPay.OperSumm - _tmpPay.OperSumm_from) FROM _tmpPay)
         ;
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 3.1. ������������ ContainerId_Goods ��� ��������������� ����� �� ����������
     UPDATE _tmpItem_SummClient SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                           , inUnitId                 := vbUnitId
                                                                                           , inMemberId               := NULL
                                                                                           , inClientId               := vbClientId
                                                                                           , inInfoMoneyDestinationId := _tmpItem_SummClient.InfoMoneyDestinationId
                                                                                           , inGoodsId                := _tmpItem_SummClient.GoodsId
                                                                                           , inPartionId              := _tmpItem_SummClient.PartionId
                                                                                           , inPartionId_MI           := _tmpItem_SummClient.PartionId_MI
                                                                                           , inGoodsSizeId            := _tmpItem_SummClient.GoodsSizeId
                                                                                           , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                            )
     -- WHERE _tmpItem_SummClient.OperCount_sale > 0 -- !!!���� ����� �������!!!
    ;

     -- 3.2.1. ������������ ����(�����������) ��� �������� �� ����������
     UPDATE _tmpItem_SummClient SET AccountId       = _tmpItem_byAccount.AccountId
                                  , AccountId_20102 = zc_Enum_Account_20102() -- �������� + ���������� + ������� ������� ��������

     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ��������
                                             , inAccountDirectionId     := vbAccountDirectionId_From
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem_SummClient.InfoMoneyDestinationId FROM _tmpItem_SummClient) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem_SummClient.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;


     -- 3.2.2. ������������ ContainerId_Summ ��� �������� �� ����������
     UPDATE _tmpItem_SummClient SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                         , inUnitId                 := vbUnitId
                                                                                         , inMemberId               := NULL
                                                                                         , inClientId               := vbClientId
                                                                                         , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                         , inBusinessId             := vbBusinessId
                                                                                         , inAccountId              := _tmpItem_SummClient.AccountId
                                                                                         , inInfoMoneyDestinationId := _tmpItem_SummClient.InfoMoneyDestinationId
                                                                                         , inInfoMoneyId            := _tmpItem_SummClient.InfoMoneyId
                                                                                         , inContainerId_Goods      := _tmpItem_SummClient.ContainerId_Goods
                                                                                         , inGoodsId                := _tmpItem_SummClient.GoodsId
                                                                                         , inPartionId              := _tmpItem_SummClient.PartionId
                                                                                         , inPartionId_MI           := _tmpItem_SummClient.PartionId_MI
                                                                                         , inGoodsSizeId            := _tmpItem_SummClient.GoodsSizeId
                                                                                          )
                            , ContainerId_Summ_20102 = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                         , inUnitId                 := vbUnitId
                                                                                         , inMemberId               := NULL
                                                                                         , inClientId               := vbClientId
                                                                                         , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                         , inBusinessId             := vbBusinessId
                                                                                         , inAccountId              := _tmpItem_SummClient.AccountId_20102
                                                                                         , inInfoMoneyDestinationId := _tmpItem_SummClient.InfoMoneyDestinationId
                                                                                         , inInfoMoneyId            := _tmpItem_SummClient.InfoMoneyId
                                                                                         , inContainerId_Goods      := _tmpItem_SummClient.ContainerId_Goods
                                                                                         , inGoodsId                := _tmpItem_SummClient.GoodsId
                                                                                         , inPartionId              := _tmpItem_SummClient.PartionId
                                                                                         , inPartionId_MI           := _tmpItem_SummClient.PartionId_MI
                                                                                         , inGoodsSizeId            := _tmpItem_SummClient.GoodsSizeId
                                                                                          )
                             ;

     -- 3.3. ������� ���������� ��� �������� - �������
     UPDATE _tmpItem_SummClient SET ContainerId_ProfitLoss_10101 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10101
                                  , ContainerId_ProfitLoss_10201 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10201
                                  , ContainerId_ProfitLoss_10202 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10202
                                  , ContainerId_ProfitLoss_10203 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10203
                                  , ContainerId_ProfitLoss_10204 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10204
                                  , ContainerId_ProfitLoss_10301 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10301
     FROM (SELECT -- ��� ����� �� ����� �������
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10101() -- ����� �� ����� �������
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10101
                  -- ��� ������������� ����������
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10301() -- ������������� ����������
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10301
                  -- ��� �������� ������
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10201() -- �������� ������
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10201
                  -- ��� ������ outlet
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10202() -- ������ outlet
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10202

                  -- ��� ������ �������
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10203() -- ������ �������
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10203

                  -- ��� ������ ��������������
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10204() -- ������ ��������������
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10204

                , tmpItem_byDestination.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem_SummClient.InfoMoneyDestinationId
                 FROM _tmpItem_SummClient
                 WHERE _tmpItem_SummClient.OperCount_sale > 0
                ) AS tmpItem_byDestination
          ) AS tmpItem_byProfitLoss
     WHERE _tmpItem_SummClient.InfoMoneyDestinationId = tmpItem_byProfitLoss.InfoMoneyDestinationId;




     -- 5.3. ����������� �������� - ����� ������� ���������� � �������� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - ���-��
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- ���� �� ��������� �����
            , zc_Enum_AnalyzerId_SaleCount_10100()    AS AnalyzerId             -- ���-��, ���������� - ���� �������� (��������)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- �����
            , _tmpItem_SummClient.PartionId           AS PartionId              -- ������
            , vbClientId                              AS WhereObjectId_Analyzer -- ����� �����
            , zc_Enum_Account_100301()                         AS AccountId_Analyzer     -- ���� - ������������� - ������� �������� �������
            , _tmpItem_SummClient.ContainerId_ProfitLoss_10101 AS ContainerId_Analyzer   -- ��������� - ������������� - ���� !!!���� �� �����!!!
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- ��������� - "�����"
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId                                AS ObjectExtId_Analyzer   -- ������������� ���������� - �������������
            , -1 * _tmpItem_SummClient.OperCount_sale AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem_SummClient.OperCount_sale > 0
         AND _tmpItem.isGoods_Debt              = FALSE
      ;


     -- 5.4. ����������� �������� - ����� ������� ����� � �������� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - ����� ������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- �����
            , _tmpItem_SummClient.PartionId           AS PartionId              -- ������
            , vbClientId                              AS WhereObjectId_Analyzer -- ����� �����
            , 0                                       AS AccountId_Analyzer     -- ���� - ������������� - �����
            , 0                                       AS ContainerId_Analyzer   -- ��������� - ������������� - ����� !!!���� �� �����!!!
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- ��������� - ��� �� �����
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId                                AS ObjectExtId_Analyzer   -- ������������� ���������� - �������������
            , -1 * _tmpItem_SummClient.TotalPay_curr  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem_SummClient.TotalPay_curr <> 0
      UNION ALL
       -- �������� - !!!������!!! � ������� ����� � �������� ���������� - � �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- ����
            , zc_Enum_AnalyzerId_SaleSumm_10204()     AS AnalyzerId             -- ������ ��������������
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- �����
            , _tmpItem_SummClient.PartionId           AS PartionId              -- ������
            , vbClientId                              AS WhereObjectId_Analyzer -- ����� �����
            , 0                                       AS AccountId_Analyzer     -- ���� - �������������
            , 0                                       AS ContainerId_Analyzer   -- ��������� - �������������
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- ��������� - ��� �� �����
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId                                AS ObjectExtId_Analyzer   -- ������������� ���������� - �������������
            , -1 * _tmpItem.SummChangePercent_curr    AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.SummChangePercent_curr   <> 0
         -- !!! AND _tmpItem.isGoods_Debt = FALSE
      UNION ALL
       -- �������� - !!!������!!! � ������� ������� �������� - � ������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ_20102
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId_20102     AS AccountId              -- ����
            , zc_Enum_AnalyzerId_SaleSumm_10204()     AS AnalyzerId             -- ������ ��������������
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- �����
            , _tmpItem_SummClient.PartionId           AS PartionId              -- ������
            , vbClientId                              AS WhereObjectId_Analyzer -- ����� �����
            , 0                                       AS AccountId_Analyzer     -- ���� - �������������
            , 0                                       AS ContainerId_Analyzer   -- ��������� - �������������
            , _tmpItem_SummClient.ContainerId_Summ_20102 AS ContainerIntId_Analyzer -- ��������� - ��� �� �����
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId                                AS ObjectExtId_Analyzer   -- ������������� ���������� - �������������
            , 1 * _tmpItem.SummChangePercent_curr     AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.SummChangePercent_curr <> 0
         AND _tmpItem.isGoods_Debt = FALSE
      UNION ALL
       -- �������� - ������� ������� �������� - � ������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ_20102
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId_20102     AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- �����
            , _tmpItem_SummClient.PartionId           AS PartionId              -- ������
            , vbClientId                              AS WhereObjectId_Analyzer -- ����� �����
            , zc_Enum_Account_100301()                         AS AccountId_Analyzer     -- ���� - ������������� - ������� �������� �������
            , _tmpItem_SummClient.ContainerId_ProfitLoss_10101 AS ContainerId_Analyzer   -- ��������� - ������������� - ���� !!!���� �� �����!!!
            , _tmpItem_SummClient.ContainerId_Summ_20102 AS ContainerIntId_Analyzer -- ��������� - ��� �� �����
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId                                AS ObjectExtId_Analyzer   -- ������������� ���������� - �������������
            , 1 * (_tmpItem_SummClient.OperSummPriceList_sale - _tmpItem_SummClient.OperSumm_sale
                 - _tmpItem_SummClient.Summ_10201 - _tmpItem_SummClient.Summ_10202 - _tmpItem_SummClient.Summ_10203 - _tmpItem_SummClient.Summ_10204
                  ) AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem_SummClient.OperCount_sale > 0
         AND _tmpItem.isGoods_Debt              = FALSE
      ;


     -- ����


     -- 1. ����������� �������� - �������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpCalc.ContainerId_ProfitLoss
            , 0                                       AS ParentId
            , zc_Enum_Account_100301()                AS AccountId              -- ������� �������� �������
            , _tmpCalc.AnalyzerId                     AS AnalyzerId             -- ���� �������� (��������)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- �����
            , _tmpItem_SummClient.PartionId           AS PartionId              -- ������
            , vbClientId                              AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- ���� - ������������� - ���������� !!!���� �� ���!!!
            , 0                                       AS ContainerId_Analyzer   -- � ���� �� �����
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- ��������� "�����"
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId                                AS ObjectExtId_Analyzer   -- ������������� ���������� - �������������
            , _tmpCalc.Amount                         AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_SummClient
            INNER JOIN
            (-- �����, ���������� (�� ������)
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10101 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10100()              AS AnalyzerId
                  , -1 * _tmpItem_SummClient.OperSummPriceList_sale  AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale > 0
            UNION ALL
             -- �������� ������
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10201 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10201()              AS AnalyzerId
                  , _tmpItem_SummClient.Summ_10201                   AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale <> 0
               AND _tmpItem_SummClient.Summ_10201     <> 0

            UNION ALL
             -- ������ outlet
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10202 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10202()              AS AnalyzerId
                  , _tmpItem_SummClient.Summ_10202                   AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale <> 0
               AND _tmpItem_SummClient.Summ_10202     <> 0
            UNION ALL
             -- ������ �������
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10203 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10203()              AS AnalyzerId
                  , _tmpItem_SummClient.Summ_10203                   AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale <> 0
               AND _tmpItem_SummClient.Summ_10203     <> 0
            UNION ALL
             -- ������ ��������������
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10204 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10204()              AS AnalyzerId
                  , _tmpItem_SummClient.Summ_10204                   AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale <> 0
               AND _tmpItem_SummClient.Summ_10204     <> 0
            UNION ALL
             -- ������ ��������������
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10301 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10300()              AS AnalyzerId
                  , _tmpItem_SummClient.OperSumm_sale                AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale <> 0
            ) AS _tmpCalc ON _tmpCalc.MovementItemId = _tmpItem_SummClient.MovementItemId
       WHERE _tmpItem_SummClient.isGoods_Debt        = FALSE
      ;


     -- 2. ����������� �������� - ������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpPay.MovementItemId
            , _tmpPay.ContainerId
            , 0                                       AS ParentId
            , _tmpPay.AccountId                       AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpPay.CurrencyId                      AS ObjectId_Analyzer      -- ������
            , 0                                       AS PartionId              -- ������
            , _tmpPay.ObjectId                        AS WhereObjectId_Analyzer -- ����� �����
            , COALESCE (_tmpItem_SummClient.AccountId, _tmpPay.AccountId_from)          AS AccountId_Analyzer   -- ���� - ������������� - ���������� / ��� �����
            , COALESCE (_tmpItem_SummClient.ContainerId_Summ, _tmpPay.ContainerId_from) AS ContainerId_Analyzer -- ��������� - ������������� - ���������� / ��� �����
            , _tmpPay.ContainerId                     AS ContainerIntId_Analyzer-- ��������� - ��� �� �����
            , vbUnitId                                AS ObjectIntId_Analyzer   -- ������������� ���������� - �������������
            , vbClientId                              AS ObjectExtId_Analyzer   -- ������������� ���������� - ����������
            , 1 * _tmpPay.OperSumm                    AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpPay
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpPay.ParentId

      UNION ALL
       -- �������� - �����
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpPay.MovementItemId
            , _tmpPay.ContainerId_from
            , 0                                       AS ParentId
            , _tmpPay.AccountId_from                  AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , zc_Currency_Basis()                     AS ObjectId_Analyzer      -- ������
            , 0                                       AS PartionId              -- ������
            , _tmpPay.ObjectId_from                   AS WhereObjectId_Analyzer -- ����� �����
            , _tmpPay.AccountId                       AS AccountId_Analyzer     -- ���� - ������������� -  �����
            , _tmpPay.ContainerId                     AS ContainerId_Analyzer   -- ��������� - ������������� - �����
            , _tmpPay.ContainerId_from                AS ContainerIntId_Analyzer-- ��������� - ��� �� �����
            , vbUnitId                                AS ObjectIntId_Analyzer   -- ������������� ���������� - �������������
            , vbClientId                              AS ObjectExtId_Analyzer   -- ������������� ���������� - ����������
            , -1 * _tmpPay.OperSumm_from              AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpPay
       WHERE _tmpPay.OperSumm_from <> 0

      UNION ALL
       -- �������� - ����������� �������� ����
       SELECT 0, zc_MIContainer_SummCurrency() AS DescId, vbMovementDescId, inMovementId
            , _tmpPay.MovementItemId
            , _tmpPay.ContainerId_Currency
            , 0                                       AS ParentId
            , _tmpPay.AccountId                       AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpPay.CurrencyId                      AS ObjectId_Analyzer      -- ������
            , 0                                       AS PartionId              -- ������
            , _tmpPay.ObjectId                        AS WhereObjectId_Analyzer -- ����� �����
            , COALESCE (_tmpItem_SummClient.AccountId, _tmpPay.AccountId_from)          AS AccountId_Analyzer   -- ���� - ������������� - ���������� / ��� �����
            , COALESCE (_tmpItem_SummClient.ContainerId_Summ, _tmpPay.ContainerId_from) AS ContainerId_Analyzer -- ��������� - ������������� - ���������� / ��� �����
            , _tmpPay.ContainerId                     AS ContainerIntId_Analyzer-- ��������� - ��� �� �����
            , vbUnitId                                AS ObjectIntId_Analyzer   -- ������������� ���������� - �������������
            , vbClientId                              AS ObjectExtId_Analyzer   -- ������������� ���������� - ����������
            , 1 * _tmpPay.OperSumm_Currency           AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpPay
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpPay.ParentId
       WHERE _tmpPay.OperSumm_Currency <> 0
      ;



     -- 5.0. ������������ ��-�� �� ������: ���� - �� ������ �������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), _tmpItem.MovementItemId, COALESCE (_tmpItem.CurrencyValue, 0))
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(),      _tmpItem.MovementItemId, COALESCE (_tmpItem.ParValue, 0))
     FROM _tmpItem;

     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_GoodsAccount()
                                , inUserId     := inUserId
                                 );

     -- 6.1. ����������� "��������" ����� �� ��������� ������ ������� - ����������� ����� lpComplete
     PERFORM lpUpdate_MI_Partion_Total_byMovement (inMovementId);

     -- 6.2. �������� �������� ����� �� ����������
     PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= TRUE, inUserId:= inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 18.05.17         *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_GoodsAccount (inMovementId:= 332188, inSession:= zfCalc_UserAdmin())
