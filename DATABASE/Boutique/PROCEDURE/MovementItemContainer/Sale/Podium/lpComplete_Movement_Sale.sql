-- Function: lpComplete_Movement_Sale()

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer);
DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale(
    IN inMovementId        Integer  , -- ���� ���������
    IN inKeySMS            Integer  , -- 
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
  DECLARE vbAccountDirectionId_To   Integer;
  DECLARE vbJuridicalId_Basis       Integer; -- �������� ���� �� ������������
  DECLARE vbBusinessId              Integer; -- �������� ���� �� ������������
  DECLARE vbContainerId_err         Integer;
  DECLARE vbId_err                  Integer;
  DECLARE vbCurrencyId_Client       Integer;
  DECLARE vbCurrencyValueEUR        TFloat;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� ������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpPay;
     -- !!!�����������!!! �������� ������� - �������� �� ����������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummClient;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ��������
     IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.ValueData = TRUE AND MB.DescId = zc_MovementBoolean_DisableSMS())
        AND NOT EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.ValueData > 0 AND MF.DescId = zc_MovementFloat_KeySMS())
        AND EXISTS (SELECT 1
                    FROM MovementItem
                         JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                     ON MILinkObject_DiscountSaleKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()
                                                    AND MILinkObject_DiscountSaleKind.ObjectId       = zc_Enum_DiscountSaleKind_Client()
                         JOIN MovementItemFloat AS MIF
                                                ON MIF.MovementItemId = MovementItem.Id
                                               AND MIF.DescId         = zc_MIFloat_ChangePercent()
                                               AND MIF.ValueData      > 0
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     > 0
                   )
        AND inUserId <> 23902 -- ������� �.�.
      --AND inUserId <> 2     -- 
      --AND 1=0
     THEN
         RAISE EXCEPTION '������.��� ���� �������������.%���������� ��������� SMS �� ������� ����������.', CHR (13);
     END IF;

     -- ��������
     IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.ValueData = TRUE AND MB.DescId = zc_MovementBoolean_DisableSMS())
        AND EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.ValueData > 0 AND MF.DescId = zc_MovementFloat_KeySMS())
        AND inKeySMS <> (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_KeySMS())
        AND inKeySMS <> 22334455
        AND inUserId <> 23902 -- ������� �.�.
     THEN
         RAISE EXCEPTION '������.��� ������������� ���� �� SMS <%>.%������� ���������� ���.', inKeySMS, CHR (13);
     END IF;

     -- ��������� �� ���������
     SELECT _tmp.MovementDescId, _tmp.OperDate, _tmp.UnitId, _tmp.ClientId
          , _tmp.AccountDirectionId_From, _tmp.AccountDirectionId_To
          , _tmp.CurrencyId_Client
            INTO vbMovementDescId
               , vbOperDate
               , vbUnitId
               , vbClientId
               , vbAccountDirectionId_From
               , vbAccountDirectionId_To
               , vbCurrencyId_Client
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()   THEN Object_From.Id ELSE 0 END, 0) AS UnitId
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Client() THEN Object_To.Id   ELSE 0 END, 0) AS ClientId

                  -- ��������� ������ - ����������� - !!!�������� - zc_Enum_AccountDirection_10100!!! ������ + ��������
                , COALESCE (ObjectLink_Unit_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_From

                  -- !!!������ - zc_Enum_AccountDirection_20100!!! �������� + ����������
                , zc_Enum_AccountDirection_20100() AS AccountDirectionId_To
                
                , COALESCE (ObjectLink_Unit_AccountDirection.ObjectId, 0) AS CurrencyId_Client

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyClient
                                             ON MovementLinkObject_CurrencyClient.MovementId = Movement.Id
                                            AND MovementLinkObject_CurrencyClient.DescId     = zc_MovementLinkObject_CurrencyClient()

                LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                     ON ObjectLink_Unit_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_Unit_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Sale()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased()) -- ����������� ���, �.�. � gp ����� ���������� ����
          ) AS _tmp;


     -- ���������� ���� - ���� �������
     SELECT MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE (MIFloat_CurrencyValue.ValueData, 0) ELSE 0 END) AS CurrencyValueEUR
            INTO vbCurrencyValueEUR
     FROM MovementItem
          LEFT JOIN MovementItem AS MI_Master ON MI_Master.Id       = MovementItem.ParentId
                                             AND MI_Master.isErased = FALSE
          LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
          INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                            ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
          LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                      ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                     AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
          LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValueIn
                                      ON MIFloat_CurrencyValueIn.MovementItemId = MovementItem.Id
                                     AND MIFloat_CurrencyValueIn.DescId         = zc_MIFloat_CurrencyValueIn()
          LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                      ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                     AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE;
              
     -- �������� - ����������� �������������
     IF COALESCE (vbUnitId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� �������� <�������������>.';
     END IF;
     -- �������� - ���������� ����������
     IF COALESCE (vbClientId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� �������� <����������>.';
     END IF;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods
                         , GoodsId, PartionId, GoodsSizeId
                         , OperCount, OperPrice, CountForPrice, OperSumm, OperSumm_Currency
                         , OperSumm_ToPay, OperSummPriceList, TotalChangePercent, TotalPay
                         , Summ_10201, Summ_10202, Summ_10203, Summ_10204
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , CurrencyValue, ParValue
                         , isGoods_Debt
                          )
        WITH -- ���� - �� �������
             tmpCurrency AS (SELECT *
                             FROM lfSelect_Movement_CurrencyAll_byDate (inOperDate      := vbOperDate
                                                                      , inCurrencyFromId:= zc_Currency_Basis()
                                                                      , inCurrencyToId  := 0
                                                                       )
                            )
            -- ��� Sybase
          , tmpCheck AS (SELECT Object.ObjectCode AS PartionId_MI FROM Object WHERE Object.Id IN (SELECT -12345 AS PartionId_MI
                   UNION SELECT 764132 -- select ObP.*, MovementItem.* , Movement.* from MovementItem join Object as ObP on ObP.ObjectCode = MovementItem.Id and ObP.DescId = zc_Object_PartionMI() join Movement on Movement.Id = MovementId and Movement.DescId = zc_Movement_Sale() and Movement.Operdate = '14.05.2012' where PartionId = (SELECT MovementItemId FROM Object_PartionGoods join Object on Object.Id = GoodsId and Object.ObjectCode = 69023 join Object as o2 on o2.Id = GoodsSizeId and o2.ValueData = '40')
                   UNION SELECT 764131
                   UNION SELECT 764129
                   UNION SELECT 686338
                   UNION SELECT 685769
                   UNION SELECT 685753
                   UNION SELECT 685567
                   UNION SELECT 596053
                   UNION SELECT 764134
                   UNION SELECT 764133
                   UNION SELECT 764130
                   UNION SELECT 696356
                   UNION SELECT 685616
                   UNION SELECT 592549
                   UNION SELECT 592548
                   UNION SELECT 592547
                   UNION SELECT 696906
                   UNION SELECT 685767
                   UNION SELECT 685766
                   UNION SELECT 599412
                   UNION SELECT 592546
                   UNION SELECT 764136
                   UNION SELECT 764135
                   UNION SELECT 685590
                   UNION SELECT 595497
                   UNION SELECT 592069
                         -- FROM gpSelect_MovementItem_Sale_Sybase_Check()
                        ))
        -- ���������
        SELECT tmp.MovementItemId
             , 0 AS ContainerId_Summ          -- ���������� �����
             , 0 AS ContainerId_Goods         -- ���������� �����
             , tmp.GoodsId
             , tmp.PartionId
             , tmp.GoodsSizeId
             , tmp.OperCount

               -- ���� - �� ������
             , tmp.OperPrice
               -- ���� �� ���������� - �� ������
             , tmp.CountForPrice

               -- ����� �� ��. � zc_Currency_Basis
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN 0 -- !!!��� �����!!!

                    -- � ����������� �� 2-� ������
                    ELSE zfCalc_SummIn (tmp.OperCount, tmp.OperPrice_basis, tmp.CountForPrice)

               END AS OperSumm

               -- ����� �� ��. � ������
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN 0  -- !!!��� �����!!!
                    ELSE tmp.OperSumm_Currency
               END AS OperSumm_Currency

               -- ����� � ������
             , tmp.OperSummPriceList - tmp.TotalChangePercent AS OperSumm_ToPay

               -- ����� �� ������
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN tmp.OperSummPriceList - tmp.TotalChangePercent -- ���������� - ����� � ������ !!!�.�. ��� �����!!!
                    ELSE tmp.OperSummPriceList
               END AS OperSummPriceList

               -- ����� ����� ������
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN 0 -- !!!��� �����!!!
                    ELSE tmp.TotalChangePercent
               END AS TotalChangePercent

               -- ����� ����� ������
             , tmp.TotalPay

             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 ELSE tmp.Summ_10201 END -- �������� ������
             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 ELSE tmp.Summ_10202 END -- ������ outlet
             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 ELSE tmp.Summ_10203 END -- ������ �������
             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 ELSE tmp.Summ_10204 END -- ������ ��������������

             , 0 AS AccountId -- ����(�����������), ���������� �����

               -- �� ��� Sale - ��� ����������� ����� ������
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

               -- ���� - �� �������
             , COALESCE (tmp.CurrencyValue, 0) AS CurrencyValue
               -- ������� ����� - �� �������
             , COALESCE (tmp.ParValue, 0)      AS ParValue

             , tmp.isGoods_Debt

        FROM (SELECT MovementItem.Id                    AS MovementItemId
                   , Object_PartionGoods.GoodsId        AS GoodsId
                   , MovementItem.PartionId             AS PartionId
                   , Object_PartionGoods.GoodsSizeId    AS GoodsSizeId
                   , MovementItem.Amount                AS OperCount
                   , Object_PartionGoods.OperPrice      AS OperPrice
                   , CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS CountForPrice
                   , Object_PartionGoods.CurrencyId     AS CurrencyId

                   , CASE -- ���� - �� MI - !!!��� ������!!!
                          WHEN zc_Enum_GlobalConst_isTerry() = FALSE AND Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                               THEN MIFloat_CurrencyValue.ValueData
                          WHEN zc_Enum_GlobalConst_isTerry() = FALSE AND Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND MIFloat_CurrencyValue.ValueData > 0
                               -- ����� �������
                               THEN 1000 * 1 / MIFloat_CurrencyValue.ValueData

                          WHEN zc_Enum_GlobalConst_isTerry() = FALSE
                               THEN 0

                          -- ���� - �� �������
                          WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                               THEN tmpCurrency.Amount

                          WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND tmpCurrency.Amount > 0
                               -- ����� �������
                               THEN 1000 * 1 / tmpCurrency.Amount

                     END AS CurrencyValue

                   , CASE -- ������� ����� - �� MI - !!!��� ������!!!
                          WHEN zc_Enum_GlobalConst_isTerry() = FALSE AND Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                               THEN MIFloat_ParValue.ValueData
                          WHEN zc_Enum_GlobalConst_isTerry() = FALSE AND Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND MIFloat_CurrencyValue.ValueData > 0
                               -- ����� �������
                               THEN 1000 * 1 / MIFloat_ParValue.ValueData

                          WHEN zc_Enum_GlobalConst_isTerry() = FALSE
                               THEN 0

                          -- ������� ����� - �� �������
                          WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                               THEN tmpCurrency.ParValue
                          WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND tmpCurrency.Amount > 0
                               -- �.�. ���� �������
                               THEN 1000 * tmpCurrency.ParValue

                     END AS ParValue

                     -- ���� ��. - ������ � ��������� � zc_Currency_Basis - � ����������� �� 2-� ������
                   , zfCalc_PriceIn_Basis (Object_PartionGoods.CurrencyId, Object_PartionGoods.OperPrice
                                         , CASE WHEN zc_Enum_GlobalConst_isTerry() = FALSE AND Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                                                     THEN MIFloat_CurrencyValue.ValueData
                                                WHEN zc_Enum_GlobalConst_isTerry() = FALSE AND Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND MIFloat_CurrencyValue.ValueData > 0
                                                     -- ����� �������
                                                     THEN 1000 * 1 / MIFloat_CurrencyValue.ValueData
                                                WHEN zc_Enum_GlobalConst_isTerry() = FALSE
                                                     THEN 0

                                                WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                                                     THEN tmpCurrency.Amount
                                                WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND tmpCurrency.Amount > 0
                                                     -- ����� �������
                                                     THEN 1000 * 1 / tmpCurrency.Amount
                                           END
                                         , CASE WHEN zc_Enum_GlobalConst_isTerry() = FALSE AND Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                                                     THEN MIFloat_ParValue.ValueData
                                                WHEN zc_Enum_GlobalConst_isTerry() = FALSE AND Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND MIFloat_CurrencyValue.ValueData > 0
                                                     -- �.�. ���� �������
                                                     THEN 1000 * MIFloat_ParValue.ValueData
                                                WHEN zc_Enum_GlobalConst_isTerry() = FALSE
                                                     THEN 0

                                                WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                                                     THEN tmpCurrency.ParValue
                                                WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND tmpCurrency.Amount > 0
                                                     -- �.�. ���� �������
                                                     THEN 1000 * tmpCurrency.ParValue
                                           END
                                          ) AS OperPrice_basis

                     -- ����� �� ��. � ������ - � ����������� �� 2-� ������
                   , zfCalc_SummIn (MovementItem.Amount, Object_PartionGoods.OperPrice, Object_PartionGoods.CountForPrice) AS OperSumm_Currency

                     -- ����� �� ������ - � ����������� �� 0/2-� ������
                   , zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) AS OperSummPriceList
                     -- ����� ����� ������ (� ���) - ������ ��� �������� ��������� - ����������� 1)�� %������ + 2)��������������
                   , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)                          AS TotalChangePercent
                     -- ����� ����� ������ (� ���) - � ������� ��������� �� zc_MI_Child
                   , COALESCE (MIFloat_TotalPay.ValueData, 0)                                    AS TotalPay
                   
                     -- �������� ������
                   , CASE WHEN MILinkObject_DiscountSaleKind.ObjectId = zc_Enum_DiscountSaleKind_Period() 
                          THEN zfCalc_SummIn (MovementItem.Amount, CASE WHEN vbCurrencyId_Client <> zc_Currency_GRN()
                                                                            THEN zfCalc_CurrencyFrom (MIFloat_OperPriceList_curr.ValueData, vbCurrencyValueEUR, 1)
                                                                       ELSE MIFloat_OperPriceList.ValueData
                                                                  END, 1) -
                               CASE WHEN vbCurrencyId_Client <> zc_Currency_GRN()
                                        THEN zfCalc_CurrencyFrom (zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                                                , vbCurrencyValueEUR, 1)
                                        ELSE zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                        END
                          ELSE 0 END                                                             AS Summ_10201
                     -- ������ outlet
                   , CASE WHEN MILinkObject_DiscountSaleKind.ObjectId = zc_Enum_DiscountSaleKind_Outlet() 
                          THEN zfCalc_SummIn (MovementItem.Amount, CASE WHEN vbCurrencyId_Client <> zc_Currency_GRN()
                                                                            THEN zfCalc_CurrencyFrom (MIFloat_OperPriceList_curr.ValueData, vbCurrencyValueEUR, 1)
                                                                       ELSE MIFloat_OperPriceList.ValueData
                                                                  END, 1) -
                               CASE WHEN vbCurrencyId_Client <> zc_Currency_GRN()
                                        THEN zfCalc_CurrencyFrom (zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                                                , vbCurrencyValueEUR, 1)
                                        ELSE zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                        END
                          ELSE 0 END                                                             AS Summ_10202
                     -- ������ �������
                   , CASE WHEN MILinkObject_DiscountSaleKind.ObjectId = zc_Enum_DiscountSaleKind_Client() 
                          THEN zfCalc_SummIn (MovementItem.Amount, CASE WHEN vbCurrencyId_Client <> zc_Currency_GRN()
                                                                            THEN zfCalc_CurrencyFrom (MIFloat_OperPriceList_curr.ValueData, vbCurrencyValueEUR, 1)
                                                                       ELSE MIFloat_OperPriceList.ValueData
                                                                  END, 1) -
                               CASE WHEN vbCurrencyId_Client <> zc_Currency_GRN()
                                        THEN zfCalc_CurrencyFrom (zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                                                , vbCurrencyValueEUR, 1)
                                        ELSE zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                        END
                          ELSE 0 END                                                             AS Summ_10203
                     -- ������ ��������������
                   , COALESCE (MIFloat_SummChangePercent.ValueData, 0) + COALESCE (MIFloat_SummRounding.ValueData, 0) AS Summ_10204
                   
                   
                    /* -- �������� ������
                   , CASE WHEN MILinkObject_DiscountSaleKind.ObjectId = zc_Enum_DiscountSaleKind_Period() THEN zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) - zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData) ELSE 0 END AS Summ_10201
                     -- ������ outlet
                   , CASE WHEN MILinkObject_DiscountSaleKind.ObjectId = zc_Enum_DiscountSaleKind_Outlet() THEN zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) - zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData) ELSE 0 END AS Summ_10202
                     -- ������ �������
                   , CASE WHEN MILinkObject_DiscountSaleKind.ObjectId = zc_Enum_DiscountSaleKind_Client() THEN zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) - zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData) ELSE 0 END AS Summ_10203
                     -- ������ ��������������
                   , COALESCE (MIFloat_SummChangePercent.ValueData, 0) AS Summ_10204*/

                     -- �������������� ������
                   , View_InfoMoney.InfoMoneyGroupId
                     -- �������������� ����������
                   , View_InfoMoney.InfoMoneyDestinationId
                     -- ������ ����������
                   , View_InfoMoney.InfoMoneyId

                   , CASE WHEN Object_PartionGoods.GoodsId = zc_Enum_Goods_Debt() THEN TRUE
                          WHEN EXISTS (SELECT 1 FROM tmpCheck WHERE tmpCheck.PartionId_MI = MovementItem.Id) THEN TRUE
                               ELSE FALSE
                     END AS isGoods_Debt

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                   LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                               ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                              AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                   LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                               ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                               ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                              AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                   LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                               ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentNext
                                               ON MIFloat_ChangePercentNext.MovementItemId = MovementItem.Id
                                              AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext()
                   LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                               ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_SummRounding
                                               ON MIFloat_SummRounding.MovementItemId = MovementItem.Id
                                              AND MIFloat_SummRounding.DescId         = zc_MIFloat_SummRounding()

                   LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                               ON MIFloat_OperPriceList_curr.MovementItemId = MovementItem.Id
                                              AND MIFloat_OperPriceList_curr.DescId         = zc_MIFloat_OperPriceList_curr()

                   LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                               ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                   LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                               ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                    ON MILinkObject_DiscountSaleKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()

                   LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = Object_PartionGoods.GoodsId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101()) -- !!!��������!!! ������ + ������ + ������

                   LEFT JOIN tmpCurrency ON (tmpCurrency.CurrencyFromId = Object_PartionGoods.CurrencyId OR tmpCurrency.CurrencyToId = Object_PartionGoods.CurrencyId)
                                        AND Object_PartionGoods.CurrencyId <> zc_Currency_Basis()

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Sale()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
            ;


     -- �������� ��� �������� �� ������ ��� ����
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.TotalPay > _tmpItem.OperSumm_ToPay)
     THEN
         RAISE EXCEPTION '������. ����� ������ = <%> ������ ��� ����� � ������ = <%>.��� <%>'
                       , (SELECT _tmpItem.TotalPay       FROM _tmpItem WHERE _tmpItem.TotalPay > _tmpItem.OperSumm_ToPay ORDER BY _tmpItem.MovementItemId LIMIT 1)
                       , (SELECT _tmpItem.OperSumm_ToPay FROM _tmpItem WHERE _tmpItem.TotalPay > _tmpItem.OperSumm_ToPay ORDER BY _tmpItem.MovementItemId LIMIT 1)
                       , lfGet_Object_ValueData((SELECT _tmpItem.GoodsId FROM _tmpItem WHERE _tmpItem.TotalPay > _tmpItem.OperSumm_ToPay ORDER BY _tmpItem.MovementItemId LIMIT 1))
         ;
     END IF;

if inUserId = 2 and 1=0
then
   UPDATE _tmpItem SET Summ_10201 = _tmpItem.Summ_10201 + 1 WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204;
end if;
     

     -- �������� ��� ������ �� ��� ����
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204)
     THEN
         RAISE EXCEPTION '������. ������ ����� <%> �� ����� <%>.', (SELECT _tmpItem.TotalChangePercent FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
                                                                 , (SELECT _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
         ;
     END IF;


     -- ��������� ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem_SummClient (MovementItemId, ContainerId_Summ, ContainerId_Summ_20102, ContainerId_Goods, AccountId, AccountId_20102, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                                    , GoodsId, PartionId, GoodsSizeId, PartionId_MI
                                    , OperCount, OperSumm, OperSumm_ToPay, TotalPay
                                    , OperCount_sale, OperSumm_sale, OperSummPriceList_sale
                                    , Summ_10201, Summ_10202, Summ_10203, Summ_10204
                                    , ContainerId_ProfitLoss_10101, ContainerId_ProfitLoss_10201, ContainerId_ProfitLoss_10202, ContainerId_ProfitLoss_10203, ContainerId_ProfitLoss_10204, ContainerId_ProfitLoss_10301
                                     )
        SELECT tmp.MovementItemId
             , 0 AS ContainerId_Summ, 0 AS ContainerId_Summ_20102, 0 AS ContainerId_Goods, 0 AS AccountId, 0 AS AccountId_20102
             , tmp.InfoMoneyGroupId, tmp.InfoMoneyDestinationId, tmp.InfoMoneyId
             , tmp.GoodsId
             , tmp.PartionId
             , tmp.GoodsSizeId

               -- ���������� ������ �������� �������/��������
             , lpInsertFind_Object_PartionMI (tmp.MovementItemId) AS PartionId_MI

               -- ��� ���-��
             , tmp.OperCount

             , (tmp.OperSumm)          AS OperSumm       -- ����� �� ��.
             , (tmp.OperSumm_ToPay)    AS OperSumm_ToPay -- ����� � ������
             , (tmp.TotalPay)          AS TotalPay       -- ����� ������

               -- ������ ���-�� ������� �������� � ������� - ����
             , tmp.OperCount_sale

               -- ������ �/� ������� �������� � ������� - ����
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.OperSumm
                    ELSE -- ����� ���-�� ������� �������� � �������
                         tmp.OperCount_sale
                         -- ���� �/� � ��� - ��������� �� 2-� ������
                       * ROUND (tmp.OperSumm / tmp.OperCount * 100) / 100
               END AS OperSumm_sale

               -- ������ ����� ������� �������� � ������� - ����
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.OperSummPriceList
                    ELSE -- ����� ���-�� ������� �������� � �������
                         tmp.OperCount_sale
                         -- ���� ����� � ��� - ��������� �� 2-� ������
                       * ROUND (tmp.OperSummPriceList / tmp.OperCount * 100) / 100
               END AS OperSummPriceList_sale

               -- ������ �������� ������ ������� �������� � �������
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.Summ_10201
                    ELSE -- ����� ���-�� ������� �������� � �������
                         tmp.OperCount_sale
                         -- ���� "������" � ��� - ��������� �� 2-� ������
                       * ROUND (tmp.Summ_10201 / tmp.OperCount * 100) / 100
               END AS Summ_10201

               -- ������ ������ outlet ������� �������� � �������
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.Summ_10202
                    ELSE -- ����� ���-�� ������� �������� � �������
                         tmp.OperCount_sale
                         -- ���� "������" � ��� - ��������� �� 2-� ������
                       * ROUND (tmp.Summ_10202 / tmp.OperCount * 100) / 100
               END AS Summ_10202

               -- ������ ������ ������� ������� �������� � �������
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.Summ_10203
                    ELSE -- ����� ���-�� ������� �������� � �������
                         tmp.OperCount_sale
                         -- ���� "������" � ��� - ��������� �� 2-� ������
                       * ROUND (tmp.Summ_10203 / tmp.OperCount * 100) / 100
               END AS Summ_10203

               -- ������ ������ �������������� ������� �������� � �������
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.Summ_10204
                    ELSE -- ����� ���-�� ������� �������� � �������
                         tmp.OperCount_sale
                         -- ���� "������" � ��� - ��������� �� 2-� ������
                       * ROUND (tmp.Summ_10204 / tmp.OperCount * 100) / 100
               END AS Summ_10204

             , 0 AS ContainerId_ProfitLoss_10101, 0 AS ContainerId_ProfitLoss_10201, 0 AS ContainerId_ProfitLoss_10202, 0 AS ContainerId_ProfitLoss_10203, 0 AS ContainerId_ProfitLoss_10204, 0 AS ContainerId_ProfitLoss_10301

        FROM (SELECT _tmpItem.*
                     -- ������ ���-�� ������� �������� � ������� - ����
                   , CASE WHEN _tmpItem.isGoods_Debt = TRUE
                               THEN 1 -- !!!���������� ��� � ����� � �������!!!
                          WHEN _tmpItem.OperSumm_ToPay = _tmpItem.TotalPay
                               THEN _tmpItem.OperCount
                          ELSE -- ����� ������ ����
                               0
                     END AS OperCount_sale
              FROM _tmpItem
             ) AS tmp
        ;

     -- �������� ��� ����� ������ ....
     -- IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204)
     -- THEN
     --     RAISE EXCEPTION '������. �������� ��� ����� ������ .....', (SELECT _tmpItem.TotalChangePercent FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
     --                                                              , (SELECT _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
     --     ;
     -- END IF;


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
                   -- , CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() THEN MovementItem.Amount ELSE ROUND (zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData), 2) END AS OperSumm
                   , CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() 
                          THEN MovementItem.Amount 
                          ELSE CASE WHEN MovementItem.ParentId IS NULL 
                                    THEN COALESCE(MIFloat_AmountExchange.ValueData, Round(zfCalc_CurrencyFrom (MovementItem.Amount, COALESCE(MIFloat_CurrencyValueIn.ValueData, MIFloat_CurrencyValue.ValueData), MIFloat_ParValue.ValueData), 2)) 
                                    ELSE ROUND (zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData), 2) END 
                          END AS OperSumm
                   , CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() THEN 0 ELSE MovementItem.Amount END AS OperSumm_Currency
                   , MILinkObject_Currency.ObjectId AS CurrencyId

                     -- ������ ��� �����
                   , CASE WHEN MovementItem.ParentId IS NULL THEN zc_Currency_Basis()   ELSE 0 END AS CurrencyId_from
                     -- ����� � ��� ��� �����
                   , CASE WHEN MovementItem.ParentId IS NULL THEN MILinkObject_Cash.ObjectId ELSE 0 END AS ObjectId_from
                     -- ���� � ��� ��� ����� ������ - �������� �������� + ����� ��������� + �����*****
                   , CASE WHEN MovementItem.ParentId IS NULL THEN zc_Enum_Account_30201()    ELSE 0 END AS AccountId_from
                     -- ��������� ����� � ��� ��� �����
                   , CASE WHEN MovementItem.ParentId IS NULL AND MILinkObject_Currency.ObjectId = zc_Currency_Basis() AND Object.DescId = zc_Object_Cash()
                          THEN COALESCE(MIFloat_AmountExchange.ValueData, Round(zfCalc_CurrencyFrom (MovementItem.Amount, COALESCE(MIFloat_CurrencyValueIn.ValueData, MIFloat_CurrencyValue.ValueData), MIFloat_ParValue.ValueData), 2)) /*+
                               COALESCE(DiffLeft.OperSummDiffLeft, 0)*/
                          ELSE 0 END AS OperSumm_from
              FROM Movement
                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId     = zc_MI_Child()
                                          AND MovementItem.isErased   = FALSE
                                         
                   LEFT JOIN MovementItem AS MI_Master
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
                   LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValueIn
                                               ON MIFloat_CurrencyValueIn.MovementItemId = MovementItem.Id
                                              AND MIFloat_CurrencyValueIn.DescId         = zc_MIFloat_CurrencyValueIn()
                   LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                               ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountExchange
                                               ON MIFloat_AmountExchange.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountExchange.DescId         = zc_MIFloat_AmountExchange()
                   /*LEFT JOIN (SELECT SUM(COALESCE(MIFloat_SummChangePercent.ValueData, 0)) AS OperSummDiffLeft 
                              FROM MovementItem                    
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                               ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.isErased   = FALSE) AS DiffLeft ON MovementItem.ParentId IS NULL*/                                 
              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Sale()
                AND (MovementItem.Amount <> 0 OR COALESCE(MIFloat_AmountExchange.ValueData, 0) <> 0)
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
        ;

     -- �������� ��� ����� ������ ....
     IF  COALESCE ((SELECT SUM (_tmpItem_SummClient.TotalPay) FROM _tmpItem_SummClient), 0)
      <> COALESCE ((SELECT SUM (tmpPay.OperSumm) 
                    FROM (SELECT SUM (_tmpPay.OperSumm - _tmpPay.OperSumm_from) /*- MAX(COALESCE(MIFloat_SummChangePercent.ValueData, 0))*/ AS OperSumm 
                          FROM _tmpPay                    
                               LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                           ON MIFloat_SummChangePercent.MovementItemId = _tmpPay.ParentId
                                                          AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                          WHERE _tmpPay.ParentId IS NOT NULL
                          GROUP BY _tmpPay.ParentId) AS tmpPay), 0)
     THEN
         RAISE EXCEPTION '������. ����� ������ Main <%> �� ����� Child <%>.', (SELECT SUM (_tmpItem_SummClient.TotalPay) FROM _tmpItem_SummClient)
                                                                            , (SELECT SUM (tmpPay.OperSumm) 
                                                                               FROM (SELECT SUM (_tmpPay.OperSumm - _tmpPay.OperSumm_from) /*- MAX(COALESCE(MIFloat_SummChangePercent.ValueData, 0))*/ AS OperSumm 
                                                                                     FROM _tmpPay                    
                                                                                          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                                                                      ON MIFloat_SummChangePercent.MovementItemId = _tmpPay.ParentId
                                                                                                                     AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                                                                                     WHERE _tmpPay.ParentId IS NOT NULL
                                                                                     GROUP BY _tmpPay.ParentId) AS tmpPay)
               ;
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inMemberId               := NULL
                                                                                , inClientId               := NULL
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inPartionId              := _tmpItem.PartionId
                                                                                , inPartionId_MI           := NULL
                                                                                , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 );



     -- ��������: ������� ������ ����
     IF inUserId <> zc_User_Sybase()
     -- AND inUserId <> 1017903 -- 
     THEN
         --
         vbContainerId_err:= (WITH tmpContainer AS (SELECT Container.Id, Container.Amount
                                                    FROM _tmpItem
                                                         INNER JOIN Container ON Container.Id = _tmpItem.ContainerId_Goods
                                                         LEFT JOIN ContainerLinkObject AS CLO_Client
                                                                                       ON CLO_Client.ContainerId = Container.Id
                                                                                      AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                    WHERE CLO_Client.ContainerId IS NULL -- !!!��������� ����� �����������!!!
         
                                                   )
                              SELECT _tmpItem.ContainerId_Goods
                              FROM _tmpItem
                                   LEFT JOIN tmpContainer ON tmpContainer.Id = _tmpItem.ContainerId_Goods
                              WHERE _tmpItem.OperCount > COALESCE (tmpContainer.Amount, 0)
                              LIMIT 1
                             );
         --
         vbId_err:= (SELECT Container.PartionId FROM Container WHERE Container.Id = vbContainerId_err);

     END IF;
     -- ��������: ������� ������ ����
     IF vbId_err > 0 AND 1=1 AND inUserId <> '8'
     THEN
        RAISE EXCEPTION '������.��� ������ <% %> �.<%> ������� = <%>. ���-�� = <%>'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = vbId_err))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = vbId_err))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = vbId_err))
                      , zfConvert_FloatToString (COALESCE ((SELECT Container.Amount FROM Container WHERE Container.Id = vbContainerId_err
                                                          /*FROM Container
                                                                 LEFT JOIN ContainerLinkObject AS CLO_Client
                                                                                               ON CLO_Client.ContainerId = Container.Id
                                                                                              AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                            WHERE Container.PartionId     = vbId_err
                                                              AND Container.DescId        = zc_Container_Count()
                                                              AND Container.WhereObjectId = vbUnitId
                                                              AND Container.Amount        > 0
                                                              AND CLO_Client.ContainerId IS NULL -- !!!��������� ����� �����������!!!
                                                          */
                                                           ), 0))
                      -- , zfConvert_FloatToString (COALESCE ((SELECT _tmpItem.OperCount FROM _tmpItem WHERE _tmpItem.ContainerId_Goods = vbId_err), 0))
                      , zfConvert_FloatToString (COALESCE ((SELECT _tmpItem.OperCount FROM _tmpItem WHERE _tmpItem.PartionId = vbId_err), 0))
                       ;
     END IF;

     -- 2.1. ������������ ����(�����������) ��� �������� �� ��������� �����
     UPDATE _tmpItem SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId_From
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
    ;

     -- 2.2. ������������ ContainerId_Summ ��� �������� �� ��������� �����
     UPDATE _tmpItem SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                              , inUnitId                 := vbUnitId
                                                                              , inMemberId               := NULL
                                                                              , inClientId               := NULL
                                                                              , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                              , inBusinessId             := vbBusinessId
                                                                              , inAccountId              := _tmpItem.AccountId
                                                                              , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                              , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                              , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                              , inGoodsId                := _tmpItem.GoodsId
                                                                              , inPartionId              := _tmpItem.PartionId
                                                                              , inPartionId_MI           := NULL
                                                                              , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                               );

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
                                                                                            );

     -- 3.2.1. ������������ ����(�����������) ��� �������� �� ����������
     UPDATE _tmpItem_SummClient SET AccountId       = _tmpItem_byAccount.AccountId
                                  , AccountId_20102 = zc_Enum_Account_20102() -- �������� + ���������� + ������� ������� ��������

     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ��������
                                             , inAccountDirectionId     := vbAccountDirectionId_To
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


     -- 4.1. ����������� �������� - ����� ������� ���������� �������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- ��������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem.AccountId                      AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , _tmpItem.PartionId                      AS PartionId              -- ������
            , vbUnitId                                AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- ���� - ������������� - ���������� !!!���� �� ���!!!
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerId_Analyzer   -- ��������� - ������������� - ���������� � �������/������� !!!���� �� ���!!!
            , _tmpItem.ContainerId_Summ               AS ContainerIntId_Analyzer-- ��������� - "�����"
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbClientId                              AS ObjectExtId_Analyzer   -- ������������� ���������� - ����������
            , -1 * _tmpItem.OperCount                 AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.isGoods_Debt = FALSE
      ;

     -- 4.2. ����������� �������� - ����� ������� ����� c/c �������
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
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem.AccountId                      AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , _tmpItem.PartionId                      AS PartionId              -- ������
            , vbUnitId                                AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- ���� - ������������� - ���������� !!!���� �� ���!!!
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerId_Analyzer   -- ��������� - ������������� - ���������� � �������/������� !!!���� �� ���!!!
            , _tmpItem.ContainerId_Summ               AS ContainerIntId_Analyzer-- ��������� - ��� �� �����
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbClientId                              AS ObjectExtId_Analyzer   -- ������������� ���������� - ����������
            , -1 * _tmpItem.OperSumm                  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.isGoods_Debt = FALSE
      ;


     -- 5.1. ����������� �������� - ���� ������� ���������� � �������� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- ��������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- ���� �� ��������� �����
            , zc_Enum_AnalyzerId_SaleCount_10100()    AS AnalyzerId             -- ���-��, ����������  - ���� �������� (��������)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- �����
            , _tmpItem_SummClient.PartionId           AS PartionId              -- ������
            , vbClientId                              AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem.AccountId                      AS AccountId_Analyzer     -- ���� - ������������� - �������
            , _tmpItem.ContainerId_Summ               AS ContainerId_Analyzer   -- ��������� - ������������� - �������
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- ��������� - "�����"
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId                                AS ObjectExtId_Analyzer   -- ������������� ���������� - �������������
            , 1 * _tmpItem_SummClient.OperCount       AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.isGoods_Debt = FALSE
      ;


     -- 5.2. ����������� �������� - ���� ������� ����� c/c + ������� � �������� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - c/c
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- ����
            , zc_Enum_AnalyzerId_SaleSumm_10300()     AS AnalyzerId             -- ����� �/�, ����������   - ���� �������� (��������)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- �����
            , _tmpItem_SummClient.PartionId           AS PartionId              -- ������
            , vbClientId                              AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem.AccountId                      AS AccountId_Analyzer     -- ���� - ������������� - �������
            , _tmpItem.ContainerId_Summ               AS ContainerId_Analyzer   -- ��������� - ������������� - �������
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- ��������� - ��� �� �����
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId                                AS ObjectExtId_Analyzer   -- ������������� ���������� - �������������
            , 1 * _tmpItem_SummClient.OperSumm        AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.isGoods_Debt = FALSE
      UNION ALL
       -- �������� - ������� ������� �������� - ������� � �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- ����
            , _tmpCalc.AnalyzerId                     AS AnalyzerId             -- ���� �������� (��������)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- �����
            , _tmpItem_SummClient.PartionId           AS PartionId              -- ������
            , vbClientId                              AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_SummClient.AccountId_20102        AS AccountId_Analyzer  -- ���� - ������������� - ������� ������� ��������
            , _tmpItem_SummClient.ContainerId_Summ_20102 AS ContainerId_Analyzer-- ��������� - ������������� - ������� ������� ��������
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- ��������� - ��� �� �����
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId                                AS ObjectExtId_Analyzer   -- ������������� ���������� - �������������
            , 1 * _tmpCalc.Amount                     AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_SummClient
            LEFT JOIN (-- �������� ������
                       SELECT _tmpItem.MovementItemId
                            , -1* _tmpItem.Summ_10201             AS Amount
                            , zc_Enum_AnalyzerId_SaleSumm_10201() AS AnalyzerId
                       FROM _tmpItem
                       WHERE _tmpItem.Summ_10201 <> 0
                      UNION ALL
                       -- ������ outlet
                       SELECT _tmpItem.MovementItemId
                            , -1 * _tmpItem.Summ_10202            AS Amount
                            , zc_Enum_AnalyzerId_SaleSumm_10202() AS AnalyzerId
                       FROM _tmpItem
                       WHERE _tmpItem.Summ_10202 <> 0
                      UNION ALL
                       -- ������ �������
                       SELECT _tmpItem.MovementItemId
                            , -1 * _tmpItem.Summ_10203            AS Amount
                            , zc_Enum_AnalyzerId_SaleSumm_10203() AS AnalyzerId
                       FROM _tmpItem
                       WHERE _tmpItem.Summ_10203 <> 0
                      UNION ALL
                       -- ������ ��������������
                       SELECT _tmpItem.MovementItemId
                            , -1 * _tmpItem.Summ_10204            AS Amount
                            , zc_Enum_AnalyzerId_SaleSumm_10204() AS AnalyzerId
                       FROM _tmpItem
                       WHERE _tmpItem.Summ_10204 <> 0
                      UNION ALL
                       -- �����, ���������� (�� ������) - !!!���� ����� ������� ��� ������!!!
                       SELECT _tmpItem.MovementItemId
                            , _tmpItem.OperSummPriceList - _tmpItem.OperSumm AS Amount
                            , zc_Enum_AnalyzerId_SaleSumm_10100()            AS AnalyzerId
                       FROM _tmpItem
                      ) AS _tmpCalc ON _tmpCalc.MovementItemId = _tmpItem_SummClient.MovementItemId
      UNION ALL
       -- �������� - ������� ������� �������� - � �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ_20102
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId_20102     AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- �����
            , _tmpItem_SummClient.PartionId           AS PartionId              -- ������
            , vbClientId                              AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- ���� - ������������� - �������
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerId_Analyzer   -- ��������� - ������������� - �������
            , _tmpItem_SummClient.ContainerId_Summ_20102 AS ContainerIntId_Analyzer -- ��������� - ��� �� �����
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId                                AS ObjectExtId_Analyzer   -- ������������� ���������� - �������������
            , -1 * (_tmpItem.OperSummPriceList - _tmpItem.OperSumm
                  - _tmpItem.Summ_10201 - _tmpItem.Summ_10202 - _tmpItem.Summ_10203 - _tmpItem.Summ_10204
                   )                                  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.isGoods_Debt = FALSE
      ;


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
            , -1 * _tmpItem_SummClient.TotalPay       AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem_SummClient.TotalPay <> 0
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
                  )                                   AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
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
            , 1 * _tmpCalc.Amount                     AS Amount
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
             -- ������������� ����������
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10301 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10300()              AS AnalyzerId
                  , _tmpItem_SummClient.OperSumm_sale                AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale <> 0
            ) AS _tmpCalc ON _tmpCalc.MovementItemId = _tmpItem_SummClient.MovementItemId
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
       WHERE _tmpPay.OperSumm <> 0

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


     IF zc_Enum_GlobalConst_isTerry() = TRUE
     THEN
         -- 5.0.1. ������������ ��-��: ���� - �� �������
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(),     _tmpItem.MovementItemId, _tmpItem.OperPrice)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), _tmpItem.MovementItemId, _tmpItem.CountForPrice)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), _tmpItem.MovementItemId, _tmpItem.CurrencyValue)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(),      _tmpItem.MovementItemId, _tmpItem.ParValue)
         FROM _tmpItem;
     ELSE 
         -- 5.0.1. ������������ ��-�� �� ������: <����> + <���� �� ����������> + ���� - �� �������
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(),     _tmpItem.MovementItemId, _tmpItem.OperPrice)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), _tmpItem.MovementItemId, _tmpItem.CountForPrice)
         FROM _tmpItem;

     END IF;
     
     -- 5.0.2. ������������ ��-�� �� ������: <�����>
     UPDATE MovementItem SET ObjectId = _tmpItem.GoodsId
     FROM _tmpItem
     WHERE _tmpItem.MovementItemId = MovementItem.Id
       AND _tmpItem.GoodsId        <> MovementItem.ObjectId
     ;


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Sale()
                                , inUserId     := inUserId
                                 );

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- �������� �������� ����� �� ���������� - !!!����� �������� ����� �� ���������!!!
     PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= TRUE, inUserId:= inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 14.05.17         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Sale (inMovementId:= 1100, inUserId:= zfCalc_UserAdmin() :: Integer)
