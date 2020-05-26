-- Function: gpSelect_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Sale (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Sale(
    IN inMovementId       Integer      , -- ���� ���������
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, LineNum Integer, PartionId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, NameFull TVarChar, MeasureName TVarChar
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeId Integer, GoodsSizeName TVarChar
             , BrandName    TVarChar
             , PeriodName   TVarChar
             , PeriodYear   Integer

             , DiscountSaleKindId Integer, DiscountSaleKindName TVarChar
             , Amount TFloat, Remains TFloat
             , OperPrice TFloat, CountForPrice TFloat
             , OperPriceList TFloat, OperPriceList_curr TFloat, OperPriceList_original TFloat, OperPriceListReal TFloat
             , SummChangePercent_curr     TFloat
             , TotalChangePercent_curr    TFloat
             , TotalChangePercentPay_curr TFloat
             , TotalPay_curr              TFloat
             , TotalPayOth_curr           TFloat
             , TotalReturn_curr           TFloat
             , TotalPayReturn_curr        TFloat
             , CurrencyName_pl TVarChar
               --
             , TotalSumm TFloat, TotalSummBalance TFloat
               --
             , TotalSummPriceList TFloat, TotalSummPriceList_curr TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , ChangePercent TFloat, SummChangePercent TFloat
             , TotalChangePercent TFloat, TotalChangePercentPay TFloat
             , TotalSummToPay TFloat, TotalSummToPay_curr TFloat, TotalSummDebt TFloat, TotalSummDebt_curr TFloat
             , TotalPay_Grn TFloat, TotalPay_USD TFloat, TotalPay_Eur TFloat, TotalPay_Card TFloat
             , TotalPay TFloat
             , TotalPayOth TFloat
             , TotalCountReturn TFloat, TotalReturn TFloat
             , TotalPayReturn TFloat

             , Amount_USD_Exc    TFloat
             , Amount_EUR_Exc    TFloat
             , Amount_GRN_Exc    TFloat

             , BarCode_item TVarChar
             , Comment TVarChar
             , isClose Boolean
             , isChecked Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId        Integer;
  DECLARE vbUnitId        Integer;
  DECLARE vbOperDate      TDateTime;
  DECLARE vbIsOperPrice   Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- �������� - ���������� ���� ��.
     vbIsOperPrice:= lpCheckOperPrice_visible (vbUserId);


     -- ��������� ���������
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
            INTO vbOperDate, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;


     -- ��������� �����
     RETURN QUERY
     WITH
     tmpMI_Master AS (SELECT MovementItem.Id
                           , ROW_NUMBER() OVER (ORDER BY CASE WHEN MovementItem.isErased = FALSE AND MovementItem.Amount > 0 THEN 0 ELSE 1 END ASC, MovementItem.Id ASC) AS LineNum
                           , MovementItem.ObjectId                                      AS GoodsId
                           , MovementItem.PartionId
                           , MILinkObject_DiscountSaleKind.ObjectId                     AS DiscountSaleKindId
                           , MovementItem.Amount
                             -- ���� ��.
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)                  AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)              AS CountForPrice
                             -- ���� �� ������, ��� ������ - � ���
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)              AS OperPriceList
                             -- ���� �� ������, ��� ������ - � ������
                           , COALESCE (MIFloat_OperPriceList_curr.ValueData, 0)         AS OperPriceList_curr
                             -- ���� �� ������ - � ������������ ������
                           , CASE WHEN COALESCE (MILinkObject_Currency_pl.ObjectId, zc_Currency_Basis()) = zc_Currency_Basis()
                                       THEN COALESCE (MIFloat_OperPriceList.ValueData, 0)
                                  ELSE COALESCE (MIFloat_OperPriceList_curr.ValueData, 0)
                             END AS OperPriceList_original
                             -- ������ ������������ ����, ��� ������
                           , COALESCE (MILinkObject_Currency_pl.ObjectId, zc_Currency_Basis()) AS CurrencyId_pl
                             -- ���� ���� ���, �� ����� ��������
                           , COALESCE (MIFloat_OperPriceListReal.ValueData, 0)          AS OperPriceListReal
                             --
                           , COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0)     AS SummChangePercent_curr
                           , COALESCE (MIFloat_TotalChangePercent_curr.ValueData, 0)    AS TotalChangePercent_curr
                           , COALESCE (MIFloat_TotalChangePercentPay_curr.ValueData, 0) AS TotalChangePercentPay_curr
                           , COALESCE (MIFloat_TotalPay_curr.ValueData, 0)              AS TotalPay_curr
                           , COALESCE (MIFloat_TotalPayOth_curr.ValueData, 0)           AS TotalPayOth_curr
                           , COALESCE (MIFloat_TotalReturn_curr.ValueData, 0)           AS TotalReturn_curr
                           , COALESCE (MIFloat_TotalPayReturn_curr.ValueData, 0)        AS TotalPayReturn_curr

                           , COALESCE (MIFloat_CurrencyValue.ValueData, 0)         AS CurrencyValue
                           , COALESCE (MIFloat_ParValue.ValueData, 0)              AS ParValue
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                             -- ����� �� ������� ����� � ������
                           , zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData) AS TotalSumm
                             -- ����� �� ������ ���, ��� ������
                           , zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)                       AS TotalSummPriceList
                             -- ����� �� ������ � ������, ��� ������
                           , zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData)                  AS TotalSummPriceList_curr

                           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)     AS SummChangePercent     -- �������������� ������ � ������� ���
                           , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)    AS TotalChangePercent    -- ����� ����� ������ - ��� "��������" ��������� �������: 1)�� %������ + 2)��������������
                           , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) AS TotalChangePercentPay -- �������������� ������ � �������� ���
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay              -- ����� ������ � ������� ���
                           , COALESCE (MIFloat_TotalPayOth.ValueData, 0)           AS TotalPayOth           -- ����� ������ � �������� ���
                           , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)      AS TotalCountReturn      -- ���-�� �������
                           , COALESCE (MIFloat_TotalReturn.ValueData, 0)           AS TotalReturn           -- ����� �������� ���
                           , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)        AS TotalPayReturn        -- ����� �������� ������ ���
                           , MIString_BarCode.ValueData                            AS BarCode_item
                           , MIString_Comment.ValueData                            AS Comment
                           , COALESCE (MIBoolean_Close.ValueData, FALSE)           AS isClose
                           , COALESCE (MIBoolean_Checked.ValueData, FALSE)         AS isChecked
                           , MovementItem.isErased
                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.isErased ORDER BY MovementItem.Id ASC) AS Ord
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased

                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                            -- � �������� ������������ ����
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                                                       AND vbIsOperPrice                    = TRUE
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                                        ON MIFloat_OperPriceList_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList_curr.DescId         = zc_MIFloat_OperPriceList_curr()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListReal
                                                        ON MIFloat_OperPriceListReal.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceListReal.DescId         = zc_MIFloat_OperPriceListReal()
                            -- � �������� ������������ ����
                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                                                     --AND vbIsOperPrice                        = TRUE
                            -- � �������� ������������ ����
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                                                     --AND vbIsOperPrice                   = TRUE

                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
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
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                        ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                        ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                        ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

                            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_curr
                                                        ON MIFloat_SummChangePercent_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_SummChangePercent_curr.DescId         = zc_MIFloat_SummChangePercent_curr()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent_curr
                                                        ON MIFloat_TotalChangePercent_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalChangePercent_curr.DescId         = zc_MIFloat_TotalChangePercent_curr()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay_curr
                                                        ON MIFloat_TotalChangePercentPay_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalChangePercentPay_curr.DescId         = zc_MIFloat_TotalChangePercentPay_curr()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_curr
                                                        ON MIFloat_TotalPay_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPay_curr.DescId         = zc_MIFloat_TotalPay_curr()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth_curr
                                                        ON MIFloat_TotalPayOth_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPayOth_curr.DescId         = zc_MIFloat_TotalPayOth_curr()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn_curr
                                                        ON MIFloat_TotalReturn_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalReturn_curr.DescId         = zc_MIFloat_TotalReturn_curr()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn_curr
                                                        ON MIFloat_TotalPayReturn_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPayReturn_curr.DescId         = zc_MIFloat_TotalPayReturn_curr()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                             ON MILinkObject_DiscountSaleKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_DiscountSaleKind.DescId = zc_MILinkObject_DiscountSaleKind()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency_pl
                                                             ON MILinkObject_Currency_pl.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency_pl.DescId         = zc_MILinkObject_Currency_pl()

                            LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                                          ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                                         AND MIBoolean_Close.DescId         = zc_MIBoolean_Close()
                            LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                          ON MIBoolean_Checked.MovementItemId = MovementItem.Id
                                                         AND MIBoolean_Checked.DescId         = zc_MIBoolean_Checked()

                            LEFT JOIN MovementItemString AS MIString_BarCode
                                                         ON MIString_BarCode.MovementItemId = MovementItem.Id
                                                        AND MIString_BarCode.DescId         = zc_MIString_BarCode()
                            LEFT JOIN MovementItemString AS MIString_Comment
                                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                       )

    , tmpMI_Child AS (SELECT COALESCE (MovementItem.ParentId, 0) AS ParentId
                           , SUM (CASE WHEN MovementItem.ParentId IS NULL
                                            -- ��������� ����� � ��� ��� �����
                                            THEN -1 * zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                       WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN()
                                            THEN MovementItem.Amount
                                       ELSE 0
                                  END) AS Amount_GRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END) AS Amount_USD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END) AS Amount_EUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END) AS Amount_Bank
                           --, MovementItem.isErased
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                      GROUP BY MovementItem.ParentId
                     )
     -- �������
   , tmpContainer AS (SELECT DISTINCT Container.*
                      FROM tmpMI_Master
                           INNER JOIN Container ON Container.PartionId     = tmpMI_Master.PartionId
                                               AND Container.WhereObjectId = vbUnitId
                                               AND Container.DescId        = zc_Container_Count()
                                               -- !!!����������� �������, �.�. ��� �������� GoodsId � ����� � Container - ��������� �����!!!
                                               AND Container.ObjectId      = tmpMI_Master.GoodsId
                                               -- !!!����������� �������, �.�. ��� �������� GoodsSizeId � ����� � Container - ��������� �����!!!
                                               AND Container.Amount        <> 0
                           LEFT JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                      WHERE CLO_Client.ContainerId IS NULL -- !!!��������� ����� �����������!!!
                     )
       -- ���������
       SELECT
             tmpMI.Id
           , CASE WHEN tmpMI.isErased = FALSE AND tmpMI.Amount > 0 THEN tmpMI.LineNum ELSE NULL END :: Integer AS LineNum
           , tmpMI.PartionId
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , (COALESCE (ObjectString_GoodsGroupFull.ValueData, '') || ' - ' || COALESCE (Object_GoodsInfo.ValueData, '')) :: TVarChar AS NameFull
           , Object_Measure.ValueData       AS MeasureName

           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.Id            AS GoodsSizeId
           , Object_GoodsSize.ValueData     AS GoodsSizeName

           , Object_Brand.ValueData         AS BrandName
           , Object_Period.ValueData        AS PeriodName
           , Object_PartionGoods.PeriodYear AS PeriodYear

           , Object_DiscountSaleKind.Id        AS DiscountSaleKindId
           , Object_DiscountSaleKind.ValueData AS DiscountSaleKindName

           , tmpMI.Amount                  :: TFloat AS Amount
           , Container.Amount              :: TFloat AS Remains
             -- ���� ��.
           , tmpMI.OperPrice               :: TFloat AS OperPrice
           , tmpMI.CountForPrice           :: TFloat AS CountForPrice
             -- ���� �� ������, ��� ������ - � ���
           , tmpMI.OperPriceList           :: TFloat AS OperPriceList
             -- ���� �� ������, ��� ������ - � ������
           , tmpMI.OperPriceList_curr      :: TFloat AS OperPriceList_curr
             -- ���� �� ������ - � ������������ ������
           , tmpMI.OperPriceList_original  :: TFloat AS OperPriceList_curr
             -- ���� ���� ���, �� ����� ��������
           , tmpMI.OperPriceListReal       :: TFloat AS OperPriceListReal

           , tmpMI.SummChangePercent_curr                                   :: TFloat AS SummChangePercent_curr     -- ����� ����� ������: 2)��������������
           , (tmpMI.TotalChangePercent_curr - tmpMI.SummChangePercent_curr) :: TFloat AS TotalChangePercent_curr    -- ����� ����� ������: 1)�� %������
           , tmpMI.TotalChangePercentPay_curr                               :: TFloat AS TotalChangePercentPay_curr -- �������������� ������ � ��������, � ������
           , tmpMI.TotalPay_curr                                            :: TFloat AS TotalPay_curr              -- 
           , tmpMI.TotalPayOth_curr                                         :: TFloat AS TotalPayOth_curr
           , tmpMI.TotalReturn_curr                                         :: TFloat AS TotalReturn_curr
           , tmpMI.TotalPayReturn_curr                                      :: TFloat AS TotalPayReturn_curr

           , Object_Currency_pl.ValueData        AS CurrencyName_pl
             -- ����� �� ������� �����
           , tmpMI.TotalSumm                  :: TFloat AS TotalSumm
           , zfCalc_CurrencyFrom (tmpMI.TotalSumm, tmpMI.CurrencyValue, tmpMI.ParValue) :: TFloat AS TotalSummBalance
             -- ����� �� ������ ���, ��� ������
           , tmpMI.TotalSummPriceList         :: TFloat AS TotalSummPriceList
             -- ����� �� ������ � ������, ��� ������
           , tmpMI.TotalSummPriceList_curr    :: TFloat AS TotalSummPriceList_curr

           , tmpMI.CurrencyValue              :: TFloat AS CurrencyValue
           , tmpMI.ParValue                   :: TFloat AS ParValue

           , tmpMI.ChangePercent                                  :: TFloat AS ChangePercent         -- % ������
           , tmpMI.SummChangePercent                              :: TFloat AS SummChangePercent     -- ����� ����� ������: 2)��������������
           , (tmpMI.TotalChangePercent - tmpMI.SummChangePercent) :: TFloat AS TotalChangePercent    -- ����� ����� ������: 1)�� %������
           , tmpMI.TotalChangePercentPay                          :: TFloat AS TotalChangePercentPay -- �������������� ������ � �������� ���

             -- ����� � ������
           , (zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList)      - tmpMI.TotalChangePercent)      :: TFloat AS TotalSummToPay
           , (zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList_curr) - tmpMI.TotalChangePercent_curr) :: TFloat AS TotalSummToPay_curr
             -- ����� ����� � ������� ���
           , (zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList)      - tmpMI.TotalChangePercent      - tmpMI.TotalPay)      :: TFloat AS TotalSummDebt
           , (zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList_curr) - tmpMI.TotalChangePercent_curr - tmpMI.TotalPay_curr) :: TFloat AS TotalSummDebt_curr

           , tmpMI_Child.Amount_GRN         :: TFloat AS TotalPay_Grn
           , tmpMI_Child.Amount_USD         :: TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR         :: TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank        :: TFloat AS TotalPay_Card

           , tmpMI.TotalPay                 :: TFloat AS TotalPay          -- ����� ������ � ������� ���
           , tmpMI.TotalPayOth              :: TFloat AS TotalPayOth       -- ����� ������ � �������� ���
           , tmpMI.TotalCountReturn         :: TFloat AS TotalCountReturn  -- ���-�� �������
           , tmpMI.TotalReturn              :: TFloat AS TotalReturn       -- ����� �������� ���
           , tmpMI.TotalPayReturn           :: TFloat AS TotalPayReturn    -- ����� �������� ������ ���

           , tmpMI_Child_Exc.Amount_USD     :: TFloat AS Amount_USD_Exc    -- ����� USD - ����� ������
           , tmpMI_Child_Exc.Amount_EUR     :: TFloat AS Amount_EUR_Exc    -- ����� EUR - ����� ������
           , tmpMI_Child_Exc.Amount_GRN     :: TFloat AS Amount_GRN_Exc    -- ����� GRN - ����� ������

           , tmpMI.BarCode_item
           , tmpMI.Comment
           , tmpMI.isClose   :: Boolean AS isClose
           , tmpMI.isChecked :: Boolean AS isChecked
           , tmpMI.isErased

       FROM tmpMI_Master AS tmpMI
            LEFT JOIN tmpContainer AS Container ON Container.PartionId = tmpMI.PartionId
                                               AND Container.ObjectId  = tmpMI.GoodsId

            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            LEFT JOIN tmpMI_Child AS tmpMI_Child_Exc ON tmpMI_Child_Exc.ParentId = 0
                                                    AND tmpMI.Ord                = 1
                                                    AND tmpMI.isErased           = FALSE

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

            LEFT JOIN Object AS Object_Currency_pl ON Object_Currency_pl.Id = tmpMI.CurrencyId_pl

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

           LEFT JOIN Object AS Object_DiscountSaleKind ON Object_DiscountSaleKind.Id = tmpMI.DiscountSaleKindId

       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.05.20         *
 23.03.18         *
 06.03.18         *
 10.05.17         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Sale (inMovementId:= 7, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
